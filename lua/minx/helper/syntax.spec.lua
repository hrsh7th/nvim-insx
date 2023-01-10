local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.helper.syntax', function()
  local function setup_buffer()
    vim.cmd.enew({ bang = true })
    vim.cmd([[ set noswapfile ]])
    vim.cmd([[ syntax on ]])
    vim.api.nvim_buf_set_option(0, 'filetype', 'lua')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'local function example()',
      '  return string.format("foo%sbar", "_")',
      'end',
    })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  it('it should detect in_string', function()
    setup_buffer()
    Keymap.spec(function()
      Keymap.send(Keymap.termcodes('/"foo<CR>i')):await()
      assert.is_false(minx.helper.syntax.in_string_or_comment())
      Keymap.send(Keymap.termcodes('<Right>')):await()
      assert.is_true(minx.helper.syntax.in_string_or_comment())
      Keymap.send(Keymap.termcodes('<Esc>/"<CR>i')):await()
      assert.is_true(minx.helper.syntax.in_string_or_comment())
      Keymap.send(Keymap.termcodes('<Esc>/,<CR>i')):await()
      assert.is_false(minx.helper.syntax.in_string_or_comment())
    end)
  end)
end)
