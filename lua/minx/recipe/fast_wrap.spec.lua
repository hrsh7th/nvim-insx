local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.fast_wrap', function()
  it('should work', function()
    minx.add(
      ')',
      require('minx.recipe.fast_wrap')({
        close = ')',
      })
    )
    spec.assert('(|)foo', ')', '(foo|)')
    spec.assert('(|)"foo"', ')', '("foo"|)')
    spec.assert('(|)[[foo]]', ')', '([[foo]]|)')
    spec.assert('(|){ "foo" }', ')', '({ "foo" }|)')
    spec.assert('(|){ "foo" }', ')', '({ "foo" }|)')
    spec.assert('((|)foo)', ')', '((foo|))') -- #2
  end)
end)
