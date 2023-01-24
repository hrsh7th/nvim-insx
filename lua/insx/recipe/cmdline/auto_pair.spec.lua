local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.cmdline.auto_pair', function()
  it('should work', function()
    insx.add(
      '(',
      require('insx.recipe.cmdline.auto_pair')({
        open = '(',
        close = ')',
        ignore_escaped = true
      }),
      { mode = 'c' }
    )
    spec.assert('|', '(', '(|)', { mode = 'c' })
    spec.assert('\\|', '(', '\\(|', { mode = 'c' })
  end)
end)
