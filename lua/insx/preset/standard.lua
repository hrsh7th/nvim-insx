local insx = require('insx')
local esc = require('insx.helper.regex').esc

local standard = {}

function standard.setup()
  standard.setup_insert_mode()
  standard.setup_cmdline_mode()
end

function standard.setup_insert_mode()
  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    insx.add(
      quote,
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
        },
      })
    )
    insx.add(
      quote,
      insx.with(
        require('insx.recipe.auto_pair')({
          open = quote,
          close = quote,
          ignore_pat = [[\\\%#]],
        }),
        {
          enabled = function(enabled, ctx)
            return enabled(ctx) and not insx.helper.syntax.in_string_or_comment()
          end,
        }
      )
    )
    insx.add(
      '<BS>',
      require('insx.recipe.delete_pair')({
        open_pat = esc(quote),
        close_pat = esc(quote),
      })
    )
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }) do
    insx.add(
      close,
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. esc(close) .. [[\zs]],
        },
      })
    )
    insx.add(
      open,
      require('insx.recipe.auto_pair')({
        open = open,
        close = close,
      })
    )
    insx.add(
      '<BS>',
      require('insx.recipe.delete_pair')({
        open_pat = esc(open),
        close_pat = esc(close),
      })
    )
    insx.add(
      '<Space>',
      require('insx.recipe.pair_spacing').increase({
        open_pat = esc(open),
        close_pat = esc(close),
      })
    )
    insx.add(
      '<BS>',
      require('insx.recipe.pair_spacing').decrease({
        open_pat = esc(open),
        close_pat = esc(close),
      })
    )
    insx.add(
      '<CR>',
      require('insx.recipe.fast_break')({
        open_pat = esc(open),
        close_pat = esc(close),
        split = true,
      })
    )
    insx.add(
      '<C-]>',
      require('insx.recipe.fast_wrap')({
        close = close,
      })
    )
  end
end

function standard.setup_cmdline_mode()
  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    -- jump_out
    insx.add(
      quote,
      require('insx.recipe.cmdline.jump_out')({
        close = quote,
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(
      quote,
      require('insx.recipe.cmdline.auto_pair')({
        open = quote,
        close = quote,
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.cmdline.delete_pair')({
        open = quote,
        close = quote,
      }),
      { mode = 'c' }
    )
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }) do
    -- jump_out
    insx.add(
      close,
      require('insx.recipe.cmdline.jump_out')({
        close = close,
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(
      open,
      require('insx.recipe.cmdline.auto_pair')({
        open = open,
        close = close,
        ignore_escaped = true,
      }),
      { mode = 'c' }
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.cmdline.delete_pair')({
        open = open,
        close = close,
      }),
      { mode = 'c' }
    )
  end
end

return standard
