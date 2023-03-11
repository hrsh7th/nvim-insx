local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.jump_next', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '<Tab>',
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. insx.helper.regex.esc(')') .. [[\zs]],
        },
      })
    )
    spec.assert('|)', '<Tab>', ')|')
    spec.assert('| )', '<Tab>', '  | )')
  end)

  it('should work (cmdline)', function()
    insx.add(
      '<Tab>',
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\\\@<!\%#]] .. insx.helper.regex.esc('"') .. [[\zs]],
        },
      }),
      { mode = 'c' }
    )
    spec.assert('"|"', '<Tab>', '""|', {
      mode = 'c',
    })
  end)
end)
