local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.jump_next', function()
  it('should work', function()
    minx.add(
      '<Tab>',
      require('minx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. minx.helper.regex.esc(')') .. [[\zs]],
        },
      })
    )
    spec.assert('|)', '<Tab>', ')|')
    spec.assert('| )', '<Tab>', '  | )')
  end)
end)
