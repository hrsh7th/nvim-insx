local insx = require('insx')
local spec = require('insx.spec')
local Keymap = require('insx.kit.Vim.Keymap')

describe('insx', function()
  before_each(insx.clear)

  describe('insx.with', function()
    it('should invoke enhanced recipe methods', function()
      local events = {} --[[@as { id: string, type: 'action' | 'enabled' }]]

      ---@param id string
      local function chain(id)
        return {
          action = function(action, ctx)
            table.insert(events, { id = id, type = 'action' })
            action(ctx)
          end,
          enabled = function(enabled, ctx)
            table.insert(events, { id = id, type = 'enabled' })
            return enabled(ctx)
          end,
        }
      end

      insx.add(
        '(',
        insx.with(
          require('insx.recipe.auto_pair')({
            open = '(',
            close = ')',
          }),
          {
            chain('1'),
            chain('2'),
          }
        )
      )
      spec.assert('|', '(', '(|)')
      assert.are.same({
        {
          id = '1',
          type = 'enabled',
        },
        {
          id = '2',
          type = 'enabled',
        },
        {
          id = '1',
          type = 'action',
        },
        {
          id = '2',
          type = 'action',
        },
      }, events)
    end)
  end)

  describe('insx.compose', function()
    it('should chain to the next recipe', function()
      local step = {}
      insx.add('(', {
        action = function(ctx)
          table.insert(step, '0')
          ctx.next()
        end,
      })
      insx.add(
        '(',
        insx.compose({
          {
            priority = 1,
            action = function(ctx)
              table.insert(step, '3')
              ctx.next()
            end,
          },
          {
            priority = 3,
            action = function(ctx)
              table.insert(step, '1')
              ctx.send('()')
              ctx.next()
            end,
          },
          {
            priority = 2,
            action = function(ctx)
              table.insert(step, '2')
              ctx.next()
            end,
          },
        })
      )
      insx.add('(', {
        action = function(ctx)
          table.insert(step, '4')
          ctx.send('<Left>')
        end,
      })
      spec.assert('|', '(', '(|)')
      assert.are.same({ '0', '1', '2', '3', '4' }, step)
    end)
  end)

  describe('ctx.backspace', function()
    it('should remove before text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.backspace([[\W*]])
        end,
      })
      spec.assert('-=|a', '<CR>', '|a')
    end)
  end)

  describe('ctx.delete', function()
    it('should remove after text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.delete([[\W*]])
        end,
      })
      spec.assert('a|-=', '<CR>', 'a|')
    end)
  end)

  describe('ctx.remove', function()
    it('should remove cursor around text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.remove([[.\%#.]])
        end,
      })
      spec.assert('a-|=', '<CR>', 'a|')
    end)
  end)

  describe('ctx.match', function()
    it('should match cursor before text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.send(' ok ')
        end,
        enabled = function(ctx)
          return ctx.match([[a\%#]])
        end,
      })
      spec.assert('a|b', '<CR>', 'a ok |b')
    end)

    it('should match cursor after text', function()
      insx.add('<CR>', {
        action = function(ctx)
          ctx.send(' ok ')
        end,
        enabled = function(ctx)
          return ctx.match([[\%#b]])
        end,
      })
      spec.assert('a|b', '<CR>', 'a ok |b')
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

  describe('ctx.search', function()
    it('should search pattern near the cursor', function()
      for _, mode in ipairs({ 'i', 'c' }) do
        for _, case in ipairs({
          {
            setup = '|',
            pattern = [[\\\%#]],
            expected = nil,
          },
          {
            setup = 'a|b',
            pattern = [[a\%#]],
            expected = { 0, 0 },
          },
          {
            setup = '"|"',
            pattern = [[\\\@<!\%#]] .. insx.helper.regex.esc('"') .. [[\zs]],
            expected = { 0, 2 },
          },
        }) do
          insx.clear()

          local actual = nil
          insx.add('<CR>', {
            action = function(ctx)
              actual = ctx.search(case.pattern)
            end,
          }, { mode = mode })
          spec.assert(case.setup, '<CR>', case.setup, {
            mode = mode,
          })
          vim.print({ case.setup, case.pattern })
          assert.are.same(case.expected, actual)
        end
      end
    end)
  end)

  describe('macro', function()
    it('should support macro', function()
      insx.add('(', require('insx.recipe.auto_pair')({
        open = '(',
        close = ')'
      }))
      insx.add(')', require('insx.recipe.fast_wrap')({
        close = ')',
      }))
      insx.add('<Tab>', require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#\s*]] .. insx.helper.regex.esc(';') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc(')') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc(']') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc('}') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc('>') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc('"') .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc("'") .. [[\zs]],
          [[\%#\s*]] .. insx.helper.regex.esc('`') .. [[\zs]],
        }
      }))

      Keymap.spec(function()
        spec.setup({
          "|'foo'",
          "'foo'",
        }, {
          filetype = 'lua',
        })
        Keymap.send(Keymap.termcodes('<Esc>qq')):await()
        Keymap.send({ keys = Keymap.termcodes('i(), aiueo<Tab>(foo<Esc>'), remap = true }):await()
        vim.fn.setreg('q', Keymap.termcodes('i(), aiueo<Tab>(foo<Esc>'))
        Keymap.send('2G1|@q'):await()
        assert.are.same({
          "('foo', aiueo)(foo)",
          "('foo', aiueo)(foo)",
        }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
      end)
    end)
  end)
end)
