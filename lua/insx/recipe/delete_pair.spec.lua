local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.delete_pair', function()
  before_each(insx.clear)
  it('should work', function()
    insx.add(
      '<BS>',
      require('insx.recipe.delete_pair')({
        open_pat = insx.helper.regex.esc('('),
        close_pat = insx.helper.regex.esc(')'),
      })
    )
    insx.add(
      '<BS>',
      insx.with(require('insx.recipe.delete_pair')({
        open_pat = insx.helper.regex.esc('"'),
        close_pat = insx.helper.regex.esc('"'),
      }), {
        insx.with.nomatch([[\\]] .. insx.helper.regex.esc('"') .. [[\%#]])
      })
    )
    spec.assert('(|)', '<BS>', '|')
    spec.assert('"|"', '<BS>', '|')
    spec.assert('"\\"|"', '<BS>', '"\\|"')
  end)
end)
