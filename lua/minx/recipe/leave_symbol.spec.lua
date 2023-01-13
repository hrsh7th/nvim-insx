local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.leave_symbol', function()
  it('should work', function()
    minx.add(
      '<Tab>',
      require('minx.recipe.leave_symbol')({
        symbol_pat = {
          minx.helper.regex.esc(')'),
        },
      })
    )
    spec.assert('(|)', '<Tab>', '()|')
  end)
end)
