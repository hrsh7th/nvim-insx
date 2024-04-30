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

  describe('ctx.move', function()
    it('should move with multibyte chars', function()
      insx.add('<CR>', {
        action = function(ctx)
          local search = assert(ctx.search([[\%#.*\zs]]))
          ctx.move(search[1], search[2])
        end,
      })
      spec.assert('|あいうえお', '<CR>', 'あいうえお|')
    end)
  end)

  describe('ctx.match', function()
    for _, mode in ipairs({ 'i', 'c' }) do
      describe(('mode=%s'):format(mode), function()
        it('should match cursor before text', function()
          insx.add('<CR>', {
            action = function(ctx)
              ctx.send(' ok ')
            end,
            enabled = function(ctx)
              return ctx.match([[a\%#]])
            end,
          }, {
            mode = mode,
          })
          spec.assert('a|b', '<CR>', 'a ok |b', {
            mode = mode,
          })
        end)

        it('should match cursor after text', function()
          insx.add('<CR>', {
            action = function(ctx)
              ctx.send(' ok ')
            end,
            enabled = function(ctx)
              return ctx.match([[\%#b]])
            end,
          }, {
            mode = mode,
          })
          spec.assert('a|b', '<CR>', 'a ok |b', {
            mode = mode,
          })
        end)

        it('should match cursor before/after text', function()
          insx.add('<CR>', {
            action = function(ctx)
              ctx.send(' ok ')
            end,
            enabled = function(ctx)
              return ctx.match([[a\%#b]])
            end,
          }, {
            mode = mode,
          })
          spec.assert('a|b', '<CR>', 'a ok |b', {
            mode = mode,
          })
        end)

        it('should capture matches', function()
          insx.add('<CR>', {
            action = function(ctx)
              assert.are.same(ctx.search([[\(a\)\(b\)\%#\(c\)\(d\)]]), {
                0,
                0,
                matches = { 'abcd', 'a', 'b', 'c', 'd', '', '', '', '', '' },
              })
            end,
          }, {
            mode = mode,
          })
          spec.assert('ab|cd', '<CR>', 'ab|cd', {
            mode = mode,
          })
        end)
      end)
    end
  end)

  describe('ctx.search', function()
    for _, mode in ipairs({ 'i', 'c' }) do
      describe(('mode=%s'):format(mode), function()
        it('should search pattern near the cursor', function()
          for _, case in ipairs({
            {
              setup = '|',
              pattern = [[\\\%#]],
              expected = nil,
            },
            {
              setup = 'foo(|',
              pattern = [[\V(\m\%#\V)\m]],
              expected = nil,
            },
            {
              setup = 'a|b',
              pattern = [[a\%#]],
              expected = { 0, 0, matches = { 'a', '', '', '', '', '', '', '', '', '' } },
            },
            {
              setup = '"|"',
              pattern = [[\\\@<!\%#]] .. insx.helper.regex.esc('"') .. [[\zs]],
              expected = { 0, 2, matches = { '', '', '', '', '', '', '', '', '', '' } },
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
            vim.print({
              setup = case.setup,
              pattern = case.pattern,
              expected = vim.inspect(case.expected),
            })
            assert.are.same(case.expected, actual)
          end
        end)
      end)
    end
  end)

  describe('ctx.substr', function()
    it('should work', function()
      local ctx ---@type insx.Context
      insx.add('<CR>', {
        action = function(ctx_)
          ctx = ctx_
        end,
      })
      vim.api.nvim_feedkeys(Keymap.termcodes('i<CR>'), 'x', true)

      local chars = { '1', '🗿', '2', '🗿', '3', '🗿', '4', '🗿', '5', '🗿', '6' }
      for s = -12, 12 do
        for e = -12, 12 do
          local len = #chars + 1
          local s_ = (len + s) % len
          local e_ = (len + e) % len
          local expected = ''
          for i = s_, e_ do
            expected = expected .. (chars[i] or '')
          end
          -- vim.print({ s = s, e = e, expected = expected })
          assert.are.same(ctx.substr('1🗿2🗿3🗿4🗿5🗿6', s, e), expected)
        end
      end

      assert.are.same(ctx.substr('123', 1, 1), '1')
      assert.are.same(ctx.substr('123', 1, -1), '123')
      assert.are.same(ctx.substr('123', -2, -1), '23')
      assert.are.same(ctx.substr('123', -3, -1), '123')
    end)
  end)

  describe('ctx.mode', function()
    it('ctx.mode: () => "i"', function()
      local ctx ---@type insx.Context
      insx.add('<CR>', {
        action = function(ctx_)
          ctx = ctx_
        end,
      })
      Keymap.spec(function()
        Keymap.send(Keymap.termcodes('i')):await()
        Keymap.send({ keys = Keymap.termcodes('<CR>'), remap = true }):await()
        vim.fn.complete(1, {})
        assert.are.same(ctx.mode(), 'i')
      end)
    end)
  end)

  describe('abbr', function()
    it('should work with iabbr', function()
      insx.add(' ', {
        enabled = function(ctx)
          return ctx.match([[(\%#)]])
        end,
        action = function(ctx)
          ctx.send('  <Left>')
        end
      })

      vim.keymap.set('ia', 'foo', 'foobarbaz')
      Keymap.spec(function()
        spec.setup('|')
        Keymap.send(Keymap.termcodes('()<Left>')):await()
        Keymap.send('foo'):await()
        Keymap.send({ keys = ' ', remap = true }):await()
        spec.expect('(foobarbaz |)')
      end)
      vim.keymap.del('ia', 'foo')
    end)
  end)

  describe('macro', function()
    it('should support macro', function()
      insx.add(
        '(',
        require('insx.recipe.auto_pair')({
          open = '(',
          close = ')',
        })
      )
      insx.add(
        ')',
        require('insx.recipe.fast_wrap')({
          close = ')',
        })
      )
      insx.add(
        '<Tab>',
        require('insx.recipe.jump_next')({
          jump_pat = {
            [[\%#\s*]] .. insx.helper.regex.esc(';') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc(')') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc(']') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc('}') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc('>') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc('"') .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc("'") .. [[\zs]],
            [[\%#\s*]] .. insx.helper.regex.esc('`') .. [[\zs]],
          },
        })
      )

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
