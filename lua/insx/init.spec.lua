local insx = require('insx')
local spec = require('insx.spec')

describe('insx', function()
  before_each(insx.clear)

  it('should work', function()
    insx.add(
      '(',
      insx.with(require('insx.recipe.auto_pair')({}), {
        enabled = function(enabled, ctx)
          return enabled(ctx) and insx.helper.syntax.in_string_or_comment()
        end,
      })
    )
  end)

  describe('context', function()
    it('should match cursor before/after text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.send(' ok ')
        end,
        enabled = function(ctx)
          return ctx.match([[a\%#b]])
        end,
      })
      spec.assert('a|b', '<CR>', 'a ok |b')
    end)
  end)
end)
