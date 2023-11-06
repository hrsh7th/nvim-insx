local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.substitute', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add('>', require('insx.recipe.substitute')({
      pattern = [[<\(\w\+\).\{-}\%#>]],
      replace = [[\0\%#</\1>]]
    }))
    spec.assert('<div|>', '>', '<div>|</div>')
    spec.assert('<span|>', '>', '<span>|</span>')
  end)
end)
