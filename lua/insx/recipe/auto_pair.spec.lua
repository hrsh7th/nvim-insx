local insx = require('insx')
local spec = require('insx.spec')
local Keymap = require('insx.kit.Vim.Keymap')

describe('insx.recipe.auto_pair', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '(',
      insx.with(
        require('insx.recipe.auto_pair')({
          open = '(',
          close = ')',
        }),
        {
          insx.with.nomatch([[\\\%#]]),
        }
      )
    )
    spec.assert('|', '(', '(|)')
    spec.assert('\\|', '(', '\\(|')
  end)

  it('should work with multichar', function()
    insx.add(
      '-',
      require('insx.recipe.auto_pair')({
        open = '<!--',
        close = '-->',
      })
    )
    spec.assert('<!-|', '-', '<!--|-->')
  end)

  it('should support backslash', function()
    insx.add(
      '(',
      require('insx.recipe.auto_pair')({
        open = [[\(]],
        close = [[\)]],
      })
    )
    spec.assert([[\|]], '(', [[\(|\)]])
  end)

  it('should work with dot-repeat', function()
    insx.add(
      '(',
      require('insx.recipe.auto_pair')({
        open = '(',
        close = ')',
      })
    )
    insx.add(
      '<Tab>',
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. insx.helper.regex.esc(')') .. [[\zs]],
        },
      })
    )
    Keymap.spec(function()
      spec.setup('|', {})
      Keymap.send(Keymap.termcodes('<Esc>o')):await()
      Keymap.send({ keys = Keymap.termcodes('(<Tab>('), remap = true }):await()
      spec.expect({ '', '()(|)' })
      Keymap.send(Keymap.termcodes('<Esc>.')):await()
      spec.expect({ '', '()()', '()|()' })
    end)
  end)
end)
