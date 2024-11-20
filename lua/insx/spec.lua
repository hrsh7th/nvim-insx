local kit = require('insx.kit')
local assert = require('luassert')
local Keymap = require('insx.kit.Vim.Keymap')

---@class insx.spec.Option
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
---@param option? insx.spec.Option
function spec.setup(lines_, option)
  option = option or {}

  local filetype = option and option.filetype or 'lua'
  vim.cmd.enew({ bang = true })
  vim.cmd([[ set indentkeys= ]])
  vim.cmd([[ set noswapfile ]])
  vim.cmd([[ set virtualedit=all ]])
  vim.api.nvim_buf_set_option(0, 'filetype', filetype)
  vim.cmd(([[ set shiftwidth=%s ]]):format(option and option.shiftwidth or 2))
  vim.cmd(([[ set tabstop=%s ]]):format(option and option.tabstop or 2))
  if option and option.noexpandtab then
    vim.cmd([[ set noexpandtab ]])
  else
    vim.cmd([[ set expandtab ]])
  end

  vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.fnamemodify('./tmp/nvim-treesitter', ':p')
  require('nvim-treesitter').setup()
  require('nvim-treesitter.configs').setup({
    highlight = {
      enable = true,
    },
  })
  if not require('nvim-treesitter.parsers').has_parser() then
    vim.cmd(([[silent! TSInstallSync! %s]]):format(filetype))
  else
    vim.cmd(([[silent! TSUpdateSync %s]]):format(filetype))
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
  vim.treesitter.get_parser(0, filetype):parse()
end

---@param prev string|string[]
---@param char string
---@param next string|string[]
---@param option? insx.spec.Option
function spec.assert(prev, char, next, option)
  option = option or {}

  local ok, err = pcall(function()
    Keymap.spec(function()
      spec.setup(prev, option)
      Keymap.send({ keys = Keymap.termcodes(char), remap = true }):await()
      local next_lines, next_cursor = parse(next)
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
    if type(err) == 'string' then
      error(err)
    end
    ---@diagnostic disable-next-line: need-check-nil
    error(err.message, 2)
  end
end

---@param next string|string[]
---@param option? { mode: 'i'|'c' }
function spec.expect(next, option)
  local next_lines, next_cursor = parse(next)
  if option and option.mode == 'c' then
    assert.are.same(next_lines, { vim.fn.getcmdline() })
    assert.are.same(next_cursor, { 1, vim.fn.getcmdpos() - 1 })
  else
    assert.are.same(next_lines, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    assert.are.same(next_cursor, vim.api.nvim_win_get_cursor(0))
  end
end

return spec
