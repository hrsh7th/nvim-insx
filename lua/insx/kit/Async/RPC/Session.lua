---@diagnostic disable: invisible, redefined-local
local kit = require('insx.kit')
local mpack = require('mpack')
local Async = require('insx.kit.Async')

---Encode data to msgpack.
---@param v any
---@return string
local function encode(v)
  if v == nil then
    return mpack.encode(mpack.NIL)
  end
  return mpack.encode(v)
end

---@class insx.kit.Async.RPC.Session
---@field private mpack_session any
---@field private stdin uv.uv_pipe_t
---@field private stdout uv.uv_pipe_t
---@field private _on_request table<string, fun(params: table): any>
---@field private _on_notification table<string, fun(params: table): nil>
local Session = {}
Session.__index = Session

---Create new session.
---@return insx.kit.Async.RPC.Session
function Session.new()
  local self = setmetatable({}, Session)
  self.mpack_session = mpack.Session({ unpack = kit.Unpacker })
  self.stdin = nil
  self.stdout = nil
  self._on_request = {}
  self._on_notification = {}
  return self
end

---Connect stdin/stdout.
---@param stdin uv.uv_pipe_t
---@param stdout uv.uv_pipe_t
function Session:connect(stdin, stdout)
  self.stdin = stdin
  self.stdout = stdout

  self.stdin:read_start(function(err, data)
    if err then
      error(err)
    end
    if not data then
      return
    end

    local offset = 1
    local length = #data
    while offset <= length do
      local type, id_or_cb, method_or_error, params_or_result, new_offset = self.mpack_session:receive(data, offset)
      if type == 'request' then
        local request_id, method, params = id_or_cb, method_or_error, params_or_result
        Async.resolve():next(function()
          return Async.run(function()
            return self._on_request[method](params)
          end)
        end):next(function(res)
          self.stdout:write(self.mpack_session:reply(request_id) .. kit.pack(mpack.NIL) .. kit.pack(res))
        end):catch(function(err_)
          self.stdout:write(self.mpack_session:reply(request_id) .. kit.pack(err_) .. kit.pack(mpack.NIL))
        end)
      elseif type == 'notification' then
        local method, params = method_or_error, params_or_result
        self._on_notification[method](params)
      elseif type == 'response' then
        local callback, err_, res = id_or_cb, method_or_error, params_or_result
        if err_ == mpack.NIL then
          callback(nil, res)
        else
          callback(err_, nil)
        end
      end
      offset = new_offset
    end
  end)
end

---Close session.
function Session:close()
  self.stdin:close()
  self.stdout:close()
  self.stdin = nil
  self.stdout = nil
end

---Add request handler.
---@param method string
---@param callback fun(params: table): any
function Session:on_request(method, callback)
  self._on_request[method] = callback
end

---Add notification handler.
---@param method string
---@param callback fun(params: table)
function Session:on_notification(method, callback)
  self._on_notification[method] = callback
end

---Send request to the peer.
---@param method string
---@param params table
---@return insx.kit.Async.AsyncTask
function Session:request(method, params)
  return Async.new(function(resolve, reject)
    local request = self.mpack_session:request(function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end)
    self.stdout:write(request .. kit.pack(method) .. kit.pack(params))
  end)
end

---Send notification to the peer.
---@param method string
---@param params table
function Session:notify(method, params)
  self.stdout:write(self.mpack_session:notify() .. kit.pack(method) .. kit.pack(params))
end

return Session
