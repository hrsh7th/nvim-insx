local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_break.basic', function()
  before_each(insx.clear)
  it('should work', function()
    insx.clear()
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
        '  bar(|)',
        ')',
      },
      '<CR>',
      {
        'foo(',
        '  bar(',
        '    |',
        '  )',
        ')',
      }
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
        '  |baz)',
        ')',
      }
    )
    spec.assert(
      {
        '\t\t{',
        '\t\t\tfoo::bar(|$foo, { $bar, 1 }, $baz)',
        '\t\t}',
      },
      '<CR>',
      {
        '\t\t{',
        '\t\t\tfoo::bar(',
        '\t\t\t|$foo, { $bar, 1 }, $baz)',
        '\t\t}',
      },
      {
        filetype = 'php',
        noexpandtab = true,
        shiftwidth = 4,
        tabstop = 4,
      }
    )

    insx.clear()
    insx.add(
      '<CR>',
      require('insx.recipe.fast_break')({
        open_pat = [[```\w*]],
        close_pat = [[```]],
      })
    )
    spec.assert({ '```bash|```' }, '<CR>', {
      '```bash',
      '  |',
      '```',
    })
  end)
end)
