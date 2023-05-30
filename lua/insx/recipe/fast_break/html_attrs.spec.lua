local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_break.html_attrs', function()
  before_each(insx.clear)
  it('should work', function()
    insx.clear()
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
        '<div |id="foo" class="bar" button>',
      },
      '<CR>',
      {
        '<div',
        '  |id="foo"',
        '  class="bar"',
        '  button',
        '>',
      }
    )
    spec.assert(
      {
        '<div |id="foo" class="bar" button />',
      },
      '<CR>',
      {
        '<div',
        '  |id="foo"',
        '  class="bar"',
        '  button',
        '/>',
      }
    )
    spec.assert(
      {
        '<div |id="foo" title={<Title id="foo-title" baz />} class="bar" button>',
      },
      '<CR>',
      {
        '<div',
        '  |id="foo"',
        '  title={<Title id="foo-title" baz />}',
        '  class="bar"',
        '  button',
        '>',
      }
    )
    spec.assert(
      {
        '<div |id="foo" title={<Title id="foo-title" baz />} class="bar" button />',
      },
      '<CR>',
      {
        '<div',
        '  |id="foo"',
        '  title={<Title id="foo-title" baz />}',
        '  class="bar"',
        '  button',
        '/>',
      }
    )
  end)
end)
