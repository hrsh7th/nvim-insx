local insx = require('insx')
local esc = require('insx.helper.regex').esc

local standard = {}

function standard.setup()
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
      require('insx.recipe.auto_pair')({
        open = quote,
        close = quote,
        ignore_pat = [[\\\%#]],
      })
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

return standard
