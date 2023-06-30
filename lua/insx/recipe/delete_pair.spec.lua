local insx = require('insx')
local spec = require('insx.spec')
local esc = require('insx.helper.regex').esc

describe('insx.recipe.delete_pair', function()
  before_each(insx.clear)

  for _, mode in ipairs({ 'i', 'c' }) do
    describe(('mode=%s'):format(mode), function()
      it('should work', function()
        insx.add(
          '<BS>',
          require('insx.recipe.delete_pair')({
            open_pat = esc('('),
            close_pat = esc(')'),
          }),
          {
            mode = mode,
          }
        )
        insx.add(
          '<BS>',
          insx.with(
            require('insx.recipe.delete_pair')({
              open_pat = esc('"'),
              close_pat = esc('"'),
            }),
            {
              insx.with.nomatch([[\\]] .. esc('"') .. [[\%#]]),
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

      it('should work with multichar', function()
        insx.add(
          '<BS>',
          require('insx.recipe.delete_pair')({
            open_pat = esc('<!--'),
            close_pat = '-->',
          })
        )
        spec.assert('<!--|-->', '<BS>', '|')
      end)
    end)
  end
end)
