local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.auto_pair', function()
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

  it('it should insert pairs', function()
    setup_buffer()
    minx.add(
      '(',
      require('minx.recipe.auto_pair')({
        open = '(',
        close = ')',
      })
    )
    Keymap.spec(function()
      Keymap.send({ 'i', { keys = '(', remap = true } }):await()
      assert.are.same({
        '()local function example()',
        '  return string.format("foo%sbar", "_")',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      assert.are.same({ 1, 1 }, vim.api.nvim_win_get_cursor(0))
    end)
  end)
end)
