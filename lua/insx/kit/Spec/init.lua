local kit = require('insx.kit')
local assert = require('luassert')

---@class insx.Spec.SetupOption
---@field filetype? string
---@field noexpandtab? boolean
---@field shiftwidth? integer
---@field tabstop? integer

---@param buffer string|string[]
local function parse_buffer(buffer)
  buffer = kit.to_array(buffer)

  for i, line in ipairs(buffer) do
    local s = line:find('|', 1, true)
    if s then
      buffer[i] = line:gsub('|', '')
      return buffer, { i, s - 1 }
    end
  end
  error('cursor position is not found.')
end

local Spec = {}

---Setup buffer.
---@param buffer string|string[]
---@param option? insx.Spec.SetupOption
function Spec.setup(buffer, option)
  option = option or {}

  vim.cmd.enew({ bang = true })
  vim.cmd(([[ set noswapfile ]]))
  vim.cmd(([[ set virtualedit=onemore ]]))
  vim.cmd(([[ set shiftwidth=%s ]]):format(option.shiftwidth or 2))
  vim.cmd(([[ set tabstop=%s ]]):format(option.tabstop or 2))
  if option.noexpandtab then
    vim.cmd([[ set noexpandtab ]])
  else
    vim.cmd([[ set expandtab ]])
  end
  if option.filetype then
    vim.cmd(([[ set filetype=%s ]]):format(option.filetype))
  end


  local lines, cursor = parse_buffer(buffer)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, cursor)
end

---Expect buffer.
function Spec.expect(buffer)
  local lines, cursor = parse_buffer(buffer)
  assert.are.same(lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
  assert.are.same(cursor, vim.api.nvim_win_get_cursor(0))
end

return Spec
