local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.endwise', function()
  local function setup_buffer()
    vim.cmd.enew({ bang = true })
    vim.cmd([[ set noswapfile ]])
    vim.api.nvim_buf_set_option(0, 'filetype', 'lua')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, {
      '',
    })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  it('it should add the end token wisely', function()
    setup_buffer()
    local endwise = require('minx.recipe.endwise')
    minx.add('<CR>', endwise.recipe(endwise.builtin))
    Keymap.spec(function()
      Keymap.send(Keymap.termcodes('iif foo then')):await()
      Keymap.send({ keys = Keymap.termcodes('<CR>'), remap = true }):await()
      assert.are.same({
        'if foo then',
        '',
        'end'
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)
end)

