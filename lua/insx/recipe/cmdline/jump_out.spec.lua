local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.cmdline.jump_out', function()
  it('should work', function()
    insx.add(
      '"',
      require('insx.recipe.cmdline.jump_out')({
        close = '"',
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )
    spec.assert('|"', '"', '"|', { mode = 'c' })
    spec.assert('\\|"', '"', '\\"|"', { mode = 'c' })
  end)
end)
