local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.universal.auto_pair', function()
  it('should work', function()
    insx.add(
      '(',
      require('insx.recipe.universal.auto_pair')({
        open = '(',
        close = ')',
        ignore_pat = [[\\\%#]],
      }),
      { mode = 'c' }
    )
    spec.assert('|', '(', '(|)', { mode = 'c' })
    spec.assert('\\|', '(', '\\(|', { mode = 'c' })
  end)
end)
