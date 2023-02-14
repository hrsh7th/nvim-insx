local insx = require('insx')
local spec = require('insx.spec')

describe('insx', function()
  before_each(insx.clear)

  it('should enhance existing recipe', function()
    local events = {} --[[@as { id: string, type: 'action' | 'enabled' }]]

    ---@param id string
    local function chain(id)
      return {
        action = function(action, ctx)
          table.insert(events, {
            id = id,
            type = 'action'
          })
          action(ctx)
        end,
        enabled = function(enabled, ctx)
          table.insert(events, {
            id = id,
            type = 'enabled'
          })
          return enabled(ctx)
        end
      }
    end

    insx.add(
      '(',
      insx.with(
        require('insx.recipe.auto_pair')({
          open = '(',
          close = ')'
        }),
        chain('1'),
        chain('2')
      )
    )
    spec.assert('|', '(', '(|)')
    assert.are.same({
      {
        id = '2',
        type = 'enabled',
      }, {
        id = '1',
        type = 'enabled',
      }, {
        id = '2',
        type = 'action',
      }, {
        id = '1',
        type = 'action',
      }
    }, events)
  end)

  it('should chain to next recipe', function()
    local step = {}
    insx.add(
      '(',
      {
        action = function(ctx)
          table.insert(step, '0')
          ctx.next()
        end
      }
    )
    insx.add(
      '(',
      insx.compose({
        {
          action = function(ctx)
            table.insert(step, '1')
            ctx.next()
          end
        },
        {
          action = function(ctx)
            table.insert(step, '2')
            ctx.send('()')
            ctx.next()
          end
        },
        {
          action = function(ctx)
            table.insert(step, '3')
            ctx.next()
          end
        },
      })
    )
    insx.add(
      '(',
      {
        action = function(ctx)
          table.insert(step, '4')
          ctx.send('<Left>')
        end
      }
    )
    spec.assert('|', '(', '(|)')
    assert.are.same({ '0', '1', '2', '3', '4' }, step)
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
