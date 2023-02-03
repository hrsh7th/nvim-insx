local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.universal.jump_out', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '"',
      require('insx.recipe.universal.jump_out')({
        close = '"',
        ignore_pat = [[\\\%#]],
      }),
      { mode = 'c' }
    )
    spec.assert('|"', '"', '"|', { mode = 'c' })
    spec.assert('\\|"', '"', '\\"|"', { mode = 'c' })
  end)
end)
