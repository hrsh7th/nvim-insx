local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.fast_break', function()
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

  it('it should break pairs', function()
    setup_buffer()
    minx.add(
      '<CR>',
      require('minx.recipe.fast_break')({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    Keymap.spec(function()
      Keymap.send({
        Keymap.termcodes('/"foo<CR>i'),
        { keys = Keymap.termcodes('<CR>'), remap = true },
      }):await()
      assert.are.same({
        'local function example()',
        '  return string.format(',
        '  "foo%sbar", "_"',
        '  )',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      assert.are.same({ 3, 2 }, vim.api.nvim_win_get_cursor(0))
    end)
  end)
end)
