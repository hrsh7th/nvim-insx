local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.pair_spacing', function()
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

  it('should increase spaces', function()
    setup_buffer()
    minx.add(
      ' ',
      require('minx.recipe.pair_spacing').increase_pair_spacing({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    Keymap.spec(function()
      Keymap.send(Keymap.termcodes('/"foo<CR>i')):await()
      Keymap.send({ keys = ' ', remap = true }):await()
      assert.are.same({
        'local function example()',
        '  return string.format( "foo%sbar", "_" )',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      assert.are.same({ 2, 24 }, vim.api.nvim_win_get_cursor(0))
    end)
  end)

  it('should increase spaces from no spacing', function()
    setup_buffer()
    minx.add(
      ' ',
      require('minx.recipe.pair_spacing').increase_pair_spacing({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    Keymap.spec(function()
      Keymap.send(Keymap.termcodes('i()<Left>')):await()
      Keymap.send({ keys = ' ', remap = true }):await()
      assert.are.same({
        '(  )local function example()',
        '  return string.format("foo%sbar", "_")',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      assert.are.same({ 1, 2 }, vim.api.nvim_win_get_cursor(0))
    end)
  end)
end)
