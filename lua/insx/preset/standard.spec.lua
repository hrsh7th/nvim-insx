local spec = require('insx.spec')

describe('insx.preset.standard', function()
  it('should work', function()
    require('insx.preset.standard').setup()

    -- quotes.
    for _, quote in ipairs({ '"', "'", '`' }) do
      -- autopairs.
      spec.assert('|', quote, ('%s|%s'):format(quote, quote))
      -- autopairs (disabled if escaped).
      spec.assert('\\|', quote, ('\\%s|'):format(quote))
      -- autopairs (disabled in string or comment).
      if quote == '"' then
        spec.assert("'|'", quote, ("'%s|'"):format(quote))
      else
        spec.assert('"|"', quote, ('"%s|"'):format(quote))
      end
      -- jumpout.
      spec.assert(('%s|%s'):format(quote, quote), quote, ('%s%s|'):format(quote, quote))
      -- delete.
      spec.assert(('%s|%s'):format(quote, quote), '<BS>', '|')
    end

    -- pairs.
    for open, close in pairs({
      ['('] = ')',
      ['['] = ']',
      ['{'] = '}',
      ['<'] = '>',
    }) do
      -- autopairs.
      spec.assert('|', open, ('%s|%s'):format(open, close))
      -- jumpout.
      spec.assert(('%s|%s'):format(open, close), close, ('%s%s|'):format(open, close))
      -- delete.
      spec.assert(('%s|%s'):format(open, close), '<BS>', '|')
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
  end)
end)
