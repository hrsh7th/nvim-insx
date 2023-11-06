local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.fast_break.html_tags', function()
  before_each(insx.clear)
  it('should work', function()
    insx.clear()
    insx.add(
      '<CR>',
      require('insx.recipe.fast_break')({
        open_pat = insx.helper.regex.esc('('),
        close_pat = insx.helper.regex.esc(')'),
        html_attrs = true,
        html_tags = true,
        arguments = true,
      })
    )
    spec.assert(
      {
        '<div id="foo" class="bar" button>|</div>',
      },
      '<CR>',
      {
        '<div id="foo" class="bar" button>',
        '  |',
        '</div>',
      }
    )
    spec.assert(
      {
        '<div id="foo" class="bar" button>|contents</div>',
      },
      '<CR>',
      {
        '<div id="foo" class="bar" button>',
        '  |contents',
        '</div>',
      }
    )
    spec.assert(
      {
        '<div id="foo" class="bar" button>|<span>contents</span></div>',
      },
      '<CR>',
      {
        '<div id="foo" class="bar" button>',
        '  |<span>contents</span>',
        '</div>',
      }
    )
    spec.assert(
      {
        '<div id="foo" class="bar" button><span>|contents</span></div>',
      },
      '<CR>',
      {
        '<div id="foo" class="bar" button><span>',
        '  |contents',
        '</span></div>',
      }
    )
  end)
end)
