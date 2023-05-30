local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_break.arguments', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '<CR>',
      require('insx.recipe.fast_break')({
        open_pat = insx.helper.regex.esc('('),
        close_pat = insx.helper.regex.esc(')'),
        html_attrs = true,
        arguments = true,
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
        '\t\t\t\t|$foo,',
        '\t\t\t\t{ $bar, 1 },',
        '\t\t\t\t$baz',
        '\t\t\t)',
        '\t\t}',
      },
      {
        filetype = 'php',
        noexpandtab = true,
        shiftwidth = 4,
        tabstop = 4,
      }
    )
  end)
end)
