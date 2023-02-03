local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.auto_pair', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '(',
      require('insx.recipe.auto_pair')({
        open = '(',
        close = ')',
        ignore_pat = [[\\\%#]],
      })
    )
    spec.assert('|', '(', '(|)')
    spec.assert('\\|', '(', '\\(|')
  end)
end)
