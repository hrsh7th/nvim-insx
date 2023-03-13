local uv = require('luv')
local Session = require('insx.kit.Thread.Server.Session')

---Return current executing file directory.
---@return string
local function dirname()
  return debug.getinfo(2, 'S').source:sub(2):match('(.*)/')
end

---@class insx.kit.Thread.Server
---@field public on_request table<string, fun(params: table): any>
---@field public on_notification table<string, fun(params: table): any>
---@field private stdin uv.uv_pipe_t
---@field private stdout uv.uv_pipe_t
---@field private stderr uv.uv_pipe_t
---@field private dispatcher fun(session: insx.kit.Thread.Server.Session): nil
---@field private process? uv.uv_process_t
---@field private session? insx.kit.Thread.Server.Session
local Server = {}
Server.__index = Server

---Create new server instance.
---@param dispatcher fun(session: insx.kit.Thread.Server.Session): nil
---@return insx.kit.Thread.Server
function Server.new(dispatcher)
  local self = setmetatable({}, Server)
  self.stdin = uv.new_pipe()
  self.stdout = uv.new_pipe()
  self.stderr = uv.new_pipe()
  self.dispatcher = dispatcher
  self.process = nil
  self.session = nil
  self.on_request = {}
  self.on_notification = {}
  return self
end

---Connect to server.
---@return insx.kit.Async.AsyncTask
function Server:connect()
  self.process = uv.spawn('nvim', {
    cwd = uv.cwd(),
    args = {
      '--headless',
      '--noplugin',
      '-l',
      ('%s/_bootstrap.lua'):format(dirname()),
      vim.o.runtimepath,
    },
    stdio = { self.stdin, self.stdout, self.stderr },
  })

  self.session = Session.new(self.stdout, self.stdin)
  for k, v in pairs(self.on_request) do
    self.session.on_request[k] = v
  end
  for k, v in pairs(self.on_notification) do
    self.session.on_notification[k] = v
  end
  self.on_request = self.session.on_request
  self.on_notification = self.session.on_notification

  return self.session:request('connect', {
    dispatcher = string.dump(self.dispatcher),
  })
end

--- Send request.
---@param method string
---@param params table
function Server:request(method, params)
  if not self.process then
    error('Server is not connected.')
  end
  return self.session:request(method, params)
end

---Send notification.
---@param method string
---@param params table
function Server:notify(method, params)
  if not self.process then
    error('Server is not connected.')
  end
  self.session:notify(method, params)
end

---Kill server process.
function Server:kill()
  if self.process then
    local ok, err = self.process:kill('SIGINT')
    if not ok then
      error(err)
    end
    self.process = nil
  end
end

return Server
