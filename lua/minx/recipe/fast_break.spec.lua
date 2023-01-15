local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.fast_break', function()
  it('should work', function()
    minx.add(
      '<CR>',
      require('minx.recipe.fast_break')({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      })
    )
    spec.assert(
      {
        'foo(',
        '  bar(|baz)',
        ')',
      },
      '<CR>',
      {
        'foo(',
        '  bar(',
        '    |baz',
        '  )',
        ')',
      }
    )
  end)
end)
