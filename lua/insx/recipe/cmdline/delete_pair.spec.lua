local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.cmdline.delete_pair', function()
  it('should work', function()
    insx.add(
      '<BS>',
      require('insx.recipe.cmdline.delete_pair')({
        open = '(',
        close = ')',
      }),
      { mode = 'c' }
    )
    spec.assert('(|)', '<BS>', '|', { mode = 'c' })
    insx.add(
      '<BS>',
      require('insx.recipe.cmdline.delete_pair')({
        open = '"',
        close = '"',
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )
    spec.assert('"|"', '<BS>', '|', { mode = 'c' })
    spec.assert('\\"|"', '<BS>', '\\|"', { mode = 'c' })
  end)
end)
