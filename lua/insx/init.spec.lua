local insx = require('insx')
local spec = require('insx.spec')

describe('insx', function()
  before_each(insx.clear)

  it('should enhance existing recipe', function()
    insx.add(
      '(',
      insx.with(require('insx.recipe.auto_pair')({
        open = '(',
        close = ')'
      }), {
        enabled = function(enabled, ctx)
          return enabled(ctx) and not insx.helper.syntax.in_string_or_comment()
        end,
      })
    )
    spec.assert('|', '(', '(|)')
    spec.assert('[[|]]', '(', '[[(|]]')
  end)

  it('should chain to next recipe', function()
    insx.add(
      '(',
      {
        priority = 1,
        action = function(ctx)
          ctx.next()
        end
      }
    )
    insx.add(
      '(',
      {
        priority = 0,
        action = function(ctx)
          ctx.send('()<Left>')
        end
      }
    )
    spec.assert('|', '(', '(|)')
  end)

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
