local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.endwise', function()
  it('should work', function()
    local endwise = require('minx.recipe.endwise')
    minx.add('<CR>', endwise.recipe(endwise.builtin))
    spec.assert('if foo then|', '<CR>', {
      'if foo then',
      '|',
      'end',
    })
  end)
end)
