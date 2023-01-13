local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.auto_pair', function()
  it('should work', function()
    minx.add('(', require('minx.recipe.auto_pair')({
      open = '(',
      close = ')',
    }))
    spec.assert('|', '(', '(|)')
  end)
end)
