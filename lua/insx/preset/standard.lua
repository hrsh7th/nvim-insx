local kit = require('insx.kit')
local insx = require('insx')
local esc = require('insx.helper.regex').esc

local standard = {}

---@param config? insx.preset.standard.Config
function standard.setup(config)
  config = config or {}
  standard.setup_insert_mode(config)
  standard.setup_cmdline_mode(config)
end

---@param config insx.preset.standard.Config
function standard.setup_insert_mode(config)
  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    -- jump_out
    insx.add(
      quote,
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
        },
      })
    )

    -- auto_pair
    insx.add(
      quote,
      insx.with(
        require('insx.recipe.auto_pair')({
          open = quote,
          close = quote,
          ignore_pat = quote == [[']] and {
            [[\\\%#]],
            [[\a\%#]],
          } or {
            [[\\\%#]],
          },
        }),
        {
          enabled = function(enabled, ctx)
            return enabled(ctx) and not insx.helper.syntax.in_string_or_comment()
          end,
        }
      )
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.delete_pair')({
        open_pat = esc(quote),
        close_pat = esc(quote),
        ignore_pat = ([[\\%s\%%#]]):format(esc(quote)),
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
    -- jump_out
    insx.add(
      close,
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. esc(close) .. [[\zs]],
        },
      })
    )

    -- auto_pair
    insx.add(
      open,
      require('insx.recipe.auto_pair')({
        open = open,
        close = close,
      })
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.delete_pair')({
        open_pat = esc(open),
        close_pat = esc(close),
      })
    )

    -- spacing
    if kit.get(config, { 'spacing', 'enabled' }, true) then
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
    end

    -- fast_break
    if kit.get(config, { 'fast_break', 'enabled' }, true) then
      insx.add(
        '<CR>',
        require('insx.recipe.fast_break')({
          open_pat = esc(open),
          close_pat = esc(close),
          split = kit.get(config, { 'fast_break', 'split' }, true),
        })
      )
    end

    -- fast_wrap
    if kit.get(config, { 'fast_wrap', 'enabled' }, true) then
      insx.add(
        '<C-]>',
        require('insx.recipe.fast_wrap')({
          close = close,
        })
      )
    end
  end
end

---@param config insx.preset.standard.Config
function standard.setup_cmdline_mode(config)
  if not kit.get(config, { 'cmdline', 'enabled' }, false) then
    return
  end

  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    -- jump_out
    insx.add(
      quote,
      require('insx.recipe.universal.jump_out')({
        close = quote,
        ignore_pat = [[\\\%#]],
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(
      quote,
      require('insx.recipe.universal.auto_pair')({
        open = quote,
        close = quote,
        ignore_pat = quote == [[']] and {
          [[\\\%#]],
          [[\a\%#]],
        } or {
          [[\\\%#]],
        },
      }),
      { mode = 'c' }
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.universal.delete_pair')({
        open = quote,
        close = quote,
        ignore_pat = [[\\]] .. quote .. [[\%#]],
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
      require('insx.recipe.universal.jump_out')({
        close = close,
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(
      open,
      require('insx.recipe.universal.auto_pair')({
        open = open,
        close = close,
      }),
      { mode = 'c' }
    )

    -- delete_pair
    insx.add(
      '<BS>',
      require('insx.recipe.universal.delete_pair')({
        open = open,
        close = close,
      }),
      { mode = 'c' }
    )
  end
end

return standard
