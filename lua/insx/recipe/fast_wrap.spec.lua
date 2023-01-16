local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_wrap', function()
  it('should work', function()
    insx.add(
      ')',
      require('insx.recipe.fast_wrap')({
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
