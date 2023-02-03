local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.universal.delete_pair', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '<BS>',
      require('insx.recipe.universal.delete_pair')({
        open = '(',
        close = ')',
      }),
      { mode = 'c' }
    )
    spec.assert('(|)', '<BS>', '|', { mode = 'c' })

    insx.add(
      '<BS>',
      require('insx.recipe.universal.delete_pair')({
        open = '"',
        close = '"',
        ignore_pat = [[\\"\%#]],
      }),
      { mode = 'c' }
    )
    spec.assert('"|"', '<BS>', '|', { mode = 'c' })
    spec.assert('\\"|"', '<BS>', '\\|"', { mode = 'c' })
  end)
end)
