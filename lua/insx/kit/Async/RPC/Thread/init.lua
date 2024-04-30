---@diagnostic disable: redefined-local
local uv = require('luv')
local Session = require('insx.kit.Async.RPC.Session')

---@class insx.kit.Async.RPC.Thread
---@field private thread uv.luv_thread_t
---@field private session insx.kit.Async.RPC.Session
local Thread = {}
Thread.__index = Thread

---Create new thread.
---@param dispatcher fun(session: insx.kit.Async.RPC.Session)
function Thread.new(dispatcher)
  local self = setmetatable({}, Thread)

  -- prepare server connections.
  local client2server_fds = uv.socketpair(nil, nil, { nonblock = true }, { nonblock = true })
  local server2client_fds = uv.socketpair(nil, nil, { nonblock = true }, { nonblock = true })
  self.thread = uv.new_thread(function(dispatcher, client2server_fd, server2client_fd)
    local uv = require('luv')
    local running = true

    local server2client_write = uv.new_tcp()
    server2client_write:open(server2client_fd)
    local client2server_read = uv.new_tcp()
    client2server_read:open(client2server_fd)
    local Session = require('insx.kit.Async.RPC.Session')
    local session = Session.new()
    session:on_request('$/exit', function()
      running = false
    end)
    assert(loadstring(dispatcher))(session)
    session:connect(client2server_read, server2client_write)
    while running do
      uv.run('once')
    end
  end, string.dump(dispatcher), client2server_fds[2], server2client_fds[1])

  -- prepare client connections.
  local client2server_write = uv.new_tcp()
  client2server_write:open(client2server_fds[1])
  local server2client_read = uv.new_tcp()
  server2client_read:open(server2client_fds[2])
  self.session = Session.new()
  self.session:connect(server2client_read, client2server_write)
  return self
end

---Add request handler.
---@param method string
---@param callback fun(params: table): any
function Thread:on_request(method, callback)
  self.session:on_request(method, callback)
end

---Add notification handler.
---@param method string
---@param callback fun(params: table)
function Thread:on_notification(method, callback)
  self.session:on_notification(method, callback)
end

---Send request to the peer.
---@param method string
---@param params table
---@return insx.kit.Async.AsyncTask
function Thread:request(method, params)
  return self.session:request(method, params)
end

---Send notification to the peer.
---@param method string
---@param params table
function Thread:notify(method, params)
  self.session:notify(method, params)
end

---Close session.
function Thread:close()
  return self:request('$/exit', {}):next(function()
    self.session:close()
  end)
end

return Thread
