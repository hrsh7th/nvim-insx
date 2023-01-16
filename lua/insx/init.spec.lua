local insx = require('insx')
local Keymap = require('insx.kit.Vim.Keymap')

describe('insx', function()
  before_each(function()
    vim.cmd.enew({ bang = true })
    vim.cmd([[ set noswapfile ]])
  end)

  local function assert_current_line(expect)
    assert.equals(expect:gsub('|', ''), vim.api.nvim_get_current_line())
    assert.equals(expect:find('|', 1, true), vim.api.nvim_win_get_cursor(0)[2] + 1)
  end

  it('should send multiple keys sequencialy', function()
    insx.add('(', {
      action = function(ctx)
        ctx.send('()')
        ctx.send('<Left>')
      end,
    })
    Keymap.spec(function()
      Keymap.send({ 'i', { keys = '(', remap = true }, 'a' }):await()
      assert_current_line('(a|)')
    end)
  end)

  it('should sendable expand result', function() end)
end)
