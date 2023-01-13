local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.delete_pair', function()
  it('should work', function()
    minx.add(
      '<BS>',
      require('minx.recipe.delete_pair')({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    spec.assert('(|)', '<BS>', '|')
    spec.assert('(|foo)', '<BS>', '|foo')
  end)
end)
