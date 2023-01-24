local kit = require('insx.kit')
local assert = require('luassert')
local Keymap = require('insx.kit.Vim.Keymap')

---@class minx.spec.Option
---@field public mode? 'i' | 'c'
---@field public filetype? string
---@field public noexpandtab? boolean
---@field public shiftwidth? integer
---@field public tabstop? integer

---@param lines_ string|string[]
---@return string[], { [1]: integer, [2]: integer }
local function parse(lines_)
  local lines = kit.to_array(lines_)
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
---@param option minx.spec.Option
function spec.setup(lines_, option)
  vim.cmd.enew({ bang = true })
  vim.cmd([[ syntax on ]])
  vim.cmd([[ set noswapfile ]])
  vim.cmd([[ set syntax=on ]])
  vim.cmd([[ set virtualedit=onemore ]])
  vim.api.nvim_buf_set_option(0, 'filetype', option and option.filetype or 'lua')
  vim.cmd(([[ set shiftwidth=%s ]]):format(option and option.shiftwidth or 2))
  vim.cmd(([[ set tabstop=%s ]]):format(option and option.tabstop or 2))
  if option and option.noexpandtab then
    vim.cmd([[ set noexpandtab ]])
  else
    vim.cmd([[ set expandtab ]])
  end

  local lines, cursor = parse(lines_)
  if option.mode == 'c' then
    Keymap.send(':'):await()
    vim.fn.setcmdline(lines[1], cursor[2] + 1)
  else
    vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
    vim.api.nvim_win_set_cursor(0, cursor)
    Keymap.send('i'):await()
  end
end

---@param prev_lines_ string|string[]
---@param char string
---@param next_lines_ string|string[]
---@param option? minx.spec.Option
function spec.assert(prev_lines_, char, next_lines_, option)
  option = option or {}

  local ok, err = pcall(function()
    Keymap.spec(function()
      spec.setup(prev_lines_, option)
      Keymap.send({ keys = Keymap.termcodes(char), remap = true }):await()
      local next_lines, next_cursor = parse(next_lines_)
      if option.mode == 'c' then
        assert.are.same(next_lines, { vim.fn.getcmdline() })
        assert.are.same(next_cursor, { 1, vim.fn.getcmdpos() - 1 })
      else
        assert.are.same(next_lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
        assert.are.same(next_cursor, vim.api.nvim_win_get_cursor(0))
      end
    end)
  end)
  if not ok then
    ---@diagnostic disable-next-line: need-check-nil
    error(err.message, 2)
  end
end

return spec
