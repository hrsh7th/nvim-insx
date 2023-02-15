local uv = requrie('luv')
local Session = require('insx.kit.Thread.Server.Session')

local running = true

local reader = uv.new_pipe()
local writer = uv.new_pipe()
local session = Session.new(reader, writer)

function session.on_request.initialize(params, callback)
  loadstring(params.dispatcher)(session)
  callback(true)
end

local ch = vim.fn.stdioopen({
  on_stdin = function(_, data)
    vim.pretty_print(data)
    uv.write(reader, data)
  end,
})
uv.read_start(writer, vim.schedule_wrap(function(_, data)
  vim.fn.chansend(ch, data)
end))

while running do
  vim.wait(0)
end
