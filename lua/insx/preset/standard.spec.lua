local insx = require('insx')
local spec = require('insx.spec')

describe('insx.preset.standard', function()
  before_each(insx.clear)
  for _, mode in ipairs({ 'i', 'c' }) do
    local option = { mode = mode }
    it(('should work (%s)'):format(mode), function()
      require('insx.preset.standard').setup({
        cmdline = {
          enabled = true,
        },
      })

      -- quotes.
      for _, quote in ipairs({ '"', "'", '`' }) do
        -- autopairs.
        spec.assert('|', quote, ('%s|%s'):format(quote, quote), option)
        spec.assert(' | ', quote, (' %s|%s '):format(quote, quote), option)
        -- autopairs (disabled if escaped).
        spec.assert('\\|', quote, ('\\%s|'):format(quote), option)
        if quote == [[']] then
          -- autopairs (auto `'` is disabled if previous char is alphabet).
          spec.assert('I|', quote, ("I'|"):format(quote), option)
        end
        -- jumpout.
        spec.assert(('%s|%s'):format(quote, quote), quote, ('%s%s|'):format(quote, quote), option)
        -- delete.
        spec.assert(('%s|%s'):format(quote, quote), '<BS>', '|', option)
        -- delete (disabled if escaped).
        spec.assert(('%s\\%s|%s'):format(quote, quote, quote), '<BS>', ('%s\\|%s'):format(quote, quote), option)
      end

      -- pairs.
      for open, close in pairs({
        ['('] = ')',
        ['['] = ']',
        ['{'] = '}',
      }) do
        -- autopairs.
        spec.assert('|', open, ('%s|%s'):format(open, close), option)
        spec.assert(' | ', open, (' %s|%s '):format(open, close), option)
        -- jumpout.
        spec.assert(('%s|%s'):format(open, close), close, ('%s%s|'):format(open, close), option)
        -- delete.
        spec.assert(('%s|%s'):format(open, close), '<BS>', '|', { mode = mode })
        if mode == 'i' then
          -- increase space.
          spec.assert(('%s|%s'):format(open, close), '<Space>', ('%s | %s'):format(open, close))
          -- decrease space.
          spec.assert(('%s | %s'):format(open, close), '<BS>', ('%s|%s'):format(open, close))
          -- break.
          spec.assert(('%s|%s'):format(open, close), '<CR>', {
            open,
            '  |',
            close,
          })
          -- wrap.
          spec.assert(('%s|%sconsole.log(foo, bar)'):format(open, close), '<C-]>', ('%sconsole.log(foo, bar)|%s'):format(open, close))
        end
      end

      -- tags.
      if option.mode == 'i' then
        spec.assert('<div>|aiueo</div>', '<CR>', {
          '<div>',
          '  |aiueo',
          '</div>',
        }, option)
      end
    end)
  end
end)
