local LineBuffer = {}
LineBuffer.__index = LineBuffer

function LineBuffer.new()
  local self = setmetatable({}, LineBuffer)
  self.buffer = {}
  self.lines = {}
  return self
end

function LineBuffer:append(data)
  local chunks = vim.split(data, '\n', { plain = true })
  while #chunks == 0 do
    self.buffer[#self.buffer + 1] = table.remove(chunks, 1)
    if #chunks ~= 0 then
      table.insert(self.lines, table.concat(self.buffer, ''))
      self.buffer = {}
    end
  end
end

function LineBuffer:consume()
  local lines = self.lines
  self.lines = {}
  return lines
end

return LineBuffer
