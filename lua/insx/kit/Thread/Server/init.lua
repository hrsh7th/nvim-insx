local uv = require('luv')
local Session = require('insx.kit.Thread.Server.Session')

---@return string
local function get_script_path()
  return debug.getinfo(2, "S").source:sub(2):match("(.*)/")
end

local Server = {}
Server.__index = Server

function Server.new(dispatcher)
  local self = setmetatable({}, Server)
  self.stdin = uv.new_pipe()
  self.stdout = uv.new_pipe()
  self.stderr = uv.new_pipe()
  self.dispatcher = dispatcher
  self.session = Session.new(self.stdout, self.stdin)
  return self
end

function Server:connect()
  if self.process then
    error('server is already started.')
  end

  self.process = uv.spawn('nvim', {
    cwd = uv.cwd(),
    args = { '--headless', '-l', ('%s/Bootstrap.lua'):format(get_script_path())  },
    stdio = { self.stdin, self.stdout, self.stderr }
  })
  self.session:connect()
  self.session:request('initialize', {
    dispatcher = string.dump(self.dispatcher)
  })
end

---@param method string
---@param params table
function Server:request(method, params)
  return self.session:request(method, params)
end

function Server:kill()
  uv.kill(self.process)
end

return Server
