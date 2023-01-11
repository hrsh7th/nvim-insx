local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.delete_pair', function()
  local function setup_buffer()
    vim.cmd.enew({ bang = true })
    vim.cmd([[ set noswapfile ]])
    vim.api.nvim_buf_set_option(0, 'filetype', 'lua')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      'local function example()',
      '  return string.format("foo%sbar", "_")',
      'end',
    })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  it('should delete pairs', function()
    setup_buffer()
    minx.add(
      '<BS>',
      require('minx.recipe.delete_pair')({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    Keymap.spec(function()
      Keymap.send({ Keymap.termcodes('i()<Left>'), { keys = Keymap.termcodes('<BS>'), remap = true } }):await()
      assert.are.same({
        'local function example()',
        '  return string.format("foo%sbar", "_")',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)

  it('should delete separated pairs', function()
    setup_buffer()
    minx.add(
      '<BS>',
      require('minx.recipe.delete_pair')({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    Keymap.spec(function()
      Keymap.send({ Keymap.termcodes('/format<CR>w<Right>i'), { keys = Keymap.termcodes('<BS>'), remap = true } }):await()
      assert.are.same({
        'local function example()',
        '  return string.format"foo%sbar", "_"',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)
end)
