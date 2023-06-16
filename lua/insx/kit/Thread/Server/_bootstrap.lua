vim.o.runtimepath = _G.arg[1]

local uv = require('luv')
local Session = require('insx.kit.Thread.Server.Session')
local AsyncTask = require('insx.kit.Async.AsyncTask')

local stdin = uv.new_pipe()
stdin:open(0)
local stdout = uv.new_pipe()
stdout:open(1)

local session = Session.new()
session:on_request('$/connect', function(params)
  local mod, load_err = loadstring(params.dispatcher)
  if not mod then
    return print(load_err)
  end
  local ok, runtime_err = pcall(mod, session)
  if not ok then
    return print(runtime_err)
  end
end)
session:on_notification('$/error', function(params)
  print(params.error)
end)
AsyncTask.on_unhandled_rejection = function(err)
  print(err)
end
session:connect(stdin, stdout)

while true do
  uv.run('once')
  vim.wait(0)
end
