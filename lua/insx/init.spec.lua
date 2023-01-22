local insx = require('insx')

describe('insx', function()
  it('should work', function()
    insx.add('(', insx.with(require('insx.recipe.auto_pair')({}), {
      enabled = function(enabled, ctx)
        return enabled(ctx) and insx.helper.syntax.in_string_or_comment()
      end
    }))
  end)
end)
