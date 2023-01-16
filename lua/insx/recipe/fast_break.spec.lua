local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_break', function()
  it('should work', function()
    insx.add(
      '<CR>',
      require('insx.recipe.fast_break')({
        open_pat = insx.helper.regex.esc('('),
        close_pat = insx.helper.regex.esc(')'),
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
