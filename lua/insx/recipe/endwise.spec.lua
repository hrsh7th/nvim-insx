local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.endwise', function()
  before_each(insx.clear)
  it('should work', function()
    local endwise = require('insx.recipe.endwise')
    insx.add('<CR>', endwise(endwise.builtin))
    spec.assert('if foo then|', '<CR>', {
      'if foo then',
      '|',
      'end',
    })
  end)
end)
