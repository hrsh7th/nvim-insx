local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.delete_pair', function()
  before_each(insx.clear)

  for _, mode in ipairs({ 'i', 'c' }) do
    describe(('mode=%s'):format(mode), function()
      it('should work', function()
        insx.add(
          '<BS>',
          require('insx.recipe.delete_pair')({
            open_pat = insx.helper.regex.esc('('),
            close_pat = insx.helper.regex.esc(')'),
          }),
          {
            mode = mode,
          }
        )
        insx.add(
          '<BS>',
          insx.with(
            require('insx.recipe.delete_pair')({
              open_pat = insx.helper.regex.esc('"'),
              close_pat = insx.helper.regex.esc('"'),
            }),
            {
              insx.with.nomatch([[\\]] .. insx.helper.regex.esc('"') .. [[\%#]]),
            }
          ),
          {
            mode = mode,
          }
        )
        spec.assert('foo(|', '<BS>', 'foo|', {
          mode = mode,
        })
        spec.assert('(|)', '<BS>', '|', {
          mode = mode,
        })
        spec.assert('"|"', '<BS>', '|', {
          mode = mode,
        })
        spec.assert('"\\"|"', '<BS>', '"\\|"', {
          mode = mode,
        })
      end)
    end)
  end
end)
