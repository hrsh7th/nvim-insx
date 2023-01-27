local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.delete_pair', function()
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
      require('insx.recipe.delete_pair')({
        open_pat = insx.helper.regex.esc('"'),
        close_pat = insx.helper.regex.esc('"'),
        ignore_pat = [[\\]] .. insx.helper.regex.esc('"') .. [[\%#]]
      })
    )
    spec.assert('(|)', '<BS>', '|')
    spec.assert('(|foo)', '<BS>', '|foo')
    spec.assert('"|"', '<BS>', '|')
    spec.assert('"\\"|"', '<BS>', '"\\|"')
    spec.assert('"|foo"', '<BS>', '|foo')

    -- Does not delete multiline pair.
    assert.error(function()
      spec.assert(
        {
          '(|',
          '  foo',
          ')',
        },
        '<BS>',
        {
          '|',
          '  foo',
          '',
        }
      )
    end)
  end)
end)
