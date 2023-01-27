local spec = require('insx.spec')

describe('insx.preset.standard', function()
  for _, mode in ipairs({ 'i', 'c' }) do
    local option = { mode = mode }
    it(('should work (%s)'):format(mode), function()
      require('insx.preset.standard').setup()

      -- quotes.
      for _, quote in ipairs({ '"', "'", '`' }) do
        -- autopairs.
        spec.assert('|', quote, ('%s|%s'):format(quote, quote), option)
        -- autopairs (disabled if escaped).
        spec.assert('\\|', quote, ('\\%s|'):format(quote), option)
        -- autopairs (disabled in string or comment).
        if mode == 'i' then
          if quote == '"' then
            spec.assert("local _ = '|'", quote, ("local _ = '%s|'"):format(quote), option)
          else
            spec.assert('local _ = "|"', quote, ('local _ = "%s|"'):format(quote), option)
          end
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
        ['<'] = '>',
      }) do
        -- autopairs.
        spec.assert('|', open, ('%s|%s'):format(open, close), option)
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
    end)
  end
end)
