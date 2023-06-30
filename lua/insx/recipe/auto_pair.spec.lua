local insx = require('insx')
local spec = require('insx.spec')

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
    insx.add('-', require('insx.recipe.auto_pair')({
      open = '<!--',
      close = '-->',
    }))
    spec.assert('<!-|', '-', '<!--|-->')
  end)
end)
