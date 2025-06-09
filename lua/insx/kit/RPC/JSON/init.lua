local kit = require('insx.kit')
local Async = require('insx.kit.Async')

---@class insx.kit.RPC.JSON.Transport
---@field send fun(self: insx.kit.RPC.JSON.Transport, data: table): insx.kit.Async.AsyncTask
---@field on_message fun(self: insx.kit.RPC.JSON.Transport, callback: fun(data: table))
---@field start fun(self: insx.kit.RPC.JSON.Transport)
---@field close fun(self: insx.kit.RPC.JSON.Transport): insx.kit.Async.AsyncTask

---@class insx.kit.RPC.JSON.Transport.LineDelimitedPipe: insx.kit.RPC.JSON.Transport
---@field private _buffer insx.kit.buffer.Buffer
---@field private _reader uv.uv_pipe_t
---@field private _writer uv.uv_pipe_t
---@field private _on_message fun(data: table)
local LineDelimitedPipe = {}
LineDelimitedPipe.__index = LineDelimitedPipe

---Create new LineDelimitedPipe instance.
---@param reader uv.uv_pipe_t
---@param writer uv.uv_pipe_t
function LineDelimitedPipe.new(reader, writer)
  return setmetatable({
    _buffer = kit.buffer(),
    _reader = reader,
    _writer = writer,
    _on_message = nil,
  }, LineDelimitedPipe)
end

---Send data.
---@param message table
---@return insx.kit.Async.AsyncTask
function LineDelimitedPipe:send(message)
  return Async.new(function(resolve, reject)
    self._writer:write(vim.json.encode(message) .. '\n', function(err)
      if err then
        return reject(err)
      else
        resolve()
      end
    end)
  end)
end

---Set message callback.
---@param callback fun(data: table)
function LineDelimitedPipe:on_message(callback)
  self._on_message = callback
end

---Start transport.
function LineDelimitedPipe:start()
  self._reader:read_start(function(err, data)
    if err then
      return
    end
    self._buffer.put(data)

    local found = data:find('\n', 1, true)
    if found then
      for i, byte in self._buffer.iter_bytes() do
        if byte == 10 then
          local message = vim.json.decode(self._buffer.get(i - 1), { object = true, array = true })
          self._buffer.skip(1)
          self._on_message(message)
        end
      end
    end
  end)
end

---Close transport.
---@return insx.kit.Async.AsyncTask
function LineDelimitedPipe:close()
  self._reader:read_stop()

  local p = Async.resolve()
  p = p:next(function()
    if not self._reader:is_closing() and self._reader:is_active() then
      return Async.new(function(resolve)
        self._reader:close(resolve)
      end)
    end
  end)
  p = p:next(function()
    if not self._writer:is_closing() and self._writer:is_active() then
      return Async.new(function(resolve)
        self._writer:close(resolve)
      end)
    end
  end)
  return p
end

---@class insx.kit.RPC.JSON.RPC
---@field private _transport insx.kit.RPC.JSON.Transport
---@field private _next_requet_id number
---@field private _pending_callbacks table<string, fun(response: table)>
---@field private _on_request_map table<string, fun(ctx: { params: table }): table>
---@field private _on_notification_map table<string, (fun(ctx: { params: table }))[]>
local RPC = {
  Transport = {
    LineDelimitedPipe = LineDelimitedPipe,
  },
}
RPC.__index = RPC

---Create new RPC instance.
---@param params { transport: insx.kit.RPC.JSON.Transport }
function RPC.new(params)
  return setmetatable({
    _transport = params.transport,
    _next_requet_id = 0,
    _pending_callbacks = {},
    _on_request_map = {},
    _on_notification_map = {},
  }, RPC)
end

---Start RPC.
function RPC:start()
  self._transport:on_message(function(data)
    if data.id then
      if data.method then
        -- request.
        local request_callback = self._on_request_map[data.method]
        if request_callback then
          Async.resolve():next(function()
            return request_callback(data)
          end):dispatch(function(res)
            -- request success.
            self._transport:send({
              jsonrpc = '2.0',
              id = data.id,
              result = res,
            })
          end, function(err)
            -- request failure.
            self._transport:send({
              jsonrpc = '2.0',
              id = data.id,
              error = {
                code = -32603,
                message = tostring(err),
              },
            })
          end)
        else
          -- request not found.
          self._transport:send({
            jsonrpc = "2.0",
            id = data.id,
            error = {
              code = -32601,
              message = ('Method not found: %s'):format(data.method),
            },
          })
        end
      else
        -- response.
        local pending_callback = self._pending_callbacks[data.id]
        if pending_callback then
          pending_callback(data)
          self._pending_callbacks[data.id] = nil
        end
      end
    else
      -- notification.
      local notification_callbacks = self._on_notification_map[data.method]
      if notification_callbacks then
        for _, callback in ipairs(notification_callbacks) do
          pcall(callback, { params = data.params })
        end
      end
    end
  end)
  self._transport:start()
end

---Close RPC.
---@return insx.kit.Async.AsyncTask
function RPC:close()
  return self._transport:close()
end

---Set request callback.
---@param method string
---@param callback fun(ctx: { params: table }): table
function RPC:on_request(method, callback)
  if self._on_request_map[method] then
    error('Method already exists: ' .. method)
  end
  self._on_request_map[method] = callback
end

---Set notification callback.
---@param method string
---@param callback fun(ctx: { params: table })
function RPC:on_notification(method, callback)
  if not self._on_notification_map[method] then
    self._on_notification_map[method] = {}
  end
  table.insert(self._on_notification_map[method], callback)
end

---Request.
---@param method string
---@param params table
---@return insx.kit.Async.AsyncTask| { cancel: fun() }
function RPC:request(method, params)
  self._next_requet_id = self._next_requet_id + 1

  local request_id = self._next_requet_id

  local p = Async.new(function(resolve, reject)
    self._pending_callbacks[request_id] = function(response)
      if response.error then
        reject(response.error)
      else
        resolve(response.result)
      end
    end
    self._transport:send({
      jsonrpc = '2.0',
      id = request_id,
      method = method,
      params = params,
    })
  end)

  ---@diagnostic disable-next-line: inject-field
  p.cancel = function()
    self._pending_callbacks[request_id] = nil
  end

  return p
end

---Notify.
---@param method string
---@param params table
function RPC:notify(method, params)
  self._transport:send({
    jsonrpc = '2.0',
    method = method,
    params = params,
  })
end

return RPC
