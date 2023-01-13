local assert = require('luassert')
local Keymap = require('minx.kit.Vim.Keymap')

---@param lines string|string[]
---@return string[], { [1]: integer, [2]: integer }
local function parse(lines)
  lines = type(lines) == 'table' and lines or { lines }
  for i, line in ipairs(lines) do
    local s = line:find('|', 1, true)
    if s then
      lines[i] = line:gsub('|', '')
      return lines, { i, s - 1 }
    end
  end
  error('cursor position is not found.')
end

local spec = {}

---@param lines_ string|string[]
function spec.setup(lines_)
  vim.cmd.enew({ bang = true })
  vim.cmd([[ set noswapfile ]])
  vim.cmd([[ set syntax=on ]])
  vim.cmd([[ syntax on ]])
  vim.api.nvim_buf_set_option(0, 'filetype', 'lua')
  local lines, cursor = parse(lines_)
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.api.nvim_win_set_cursor(0, cursor)
end

---@param prev_lines_ string|string[]
---@param char string
---@param next_lines_ string|string[]
function spec.assert(prev_lines_, char, next_lines_)
  spec.setup(prev_lines_)
  local ok, err = pcall(function()
    Keymap.spec(function()
      Keymap.send('i'):await()
      Keymap.send({ keys = Keymap.termcodes(char), remap = true }):await()
      local next_lines, next_cursor = parse(next_lines_)
      assert.are.same(next_lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      assert.are.same(next_cursor, vim.api.nvim_win_get_cursor(0))
    end)
  end)
  if not ok then
    ---@diagnostic disable-next-line: need-check-nil
    error(err.message, 2)
  end
end

return spec
