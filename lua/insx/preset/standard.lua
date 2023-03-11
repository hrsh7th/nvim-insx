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
    insx.add(quote, require('insx.recipe.auto_pair').strings({
      open = quote,
      close = quote,
    }))

    -- delete_pair
    insx.add('<BS>', require('insx.recipe.delete_pair').strings({
      open_pat = esc(quote),
      close_pat = esc(quote),
    }))
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
  }) do
    -- jump_out
    insx.add(close, require('insx.recipe.jump_next')({
      jump_pat = {
        [[\%#]] .. esc(close) .. [[\zs]],
      },
    }))

    -- auto_pair
    insx.add(open, require('insx.recipe.auto_pair')({
      open = open,
      close = close,
    }))

    -- delete_pair
    insx.add('<BS>', require('insx.recipe.delete_pair')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- spacing
    if kit.get(config, { 'spacing', 'enabled' }, true) then
      insx.add('<Space>', require('insx.recipe.pair_spacing').increase({
        open_pat = esc(open),
        close_pat = esc(close),
      }))
      insx.add('<BS>', require('insx.recipe.pair_spacing').decrease({
        open_pat = esc(open),
        close_pat = esc(close),
      }))
    end

    -- fast_break
    if kit.get(config, { 'fast_break', 'enabled' }, true) then
      insx.add('<CR>', require('insx.recipe.fast_break')({
        open_pat = esc(open),
        close_pat = esc(close),
        split = kit.get(config, { 'fast_break', 'split' }, true),
      }))
    end

    -- fast_wrap
    if kit.get(config, { 'fast_wrap', 'enabled' }, true) then
      insx.add('<C-]>', require('insx.recipe.fast_wrap')({
        close = close,
      }))
    end
  end

  -- tags.
  insx.add('<CR>', require('insx.recipe.fast_break')({
    open_pat = insx.helper.search.Tag.Open,
    close_pat = insx.helper.search.Tag.Close,
  }))
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
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
        },
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(quote, require('insx.recipe.auto_pair').strings({
      open = quote,
      close = quote,
    }), { mode = 'c' })

    -- delete_pair
    insx.add('<BS>', require('insx.recipe.delete_pair').strings({
      open_pat = esc(quote),
      close_pat = esc(quote),
    }), { mode = 'c' })
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
  }) do
    -- jump_out
    insx.add(
      close,
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. esc(close) .. [[\zs]]
        }
      }),
      { mode = 'c' }
    )

    -- auto_pair
    insx.add(open, require('insx.recipe.auto_pair')({
      open = open,
      close = close,
    }), { mode = 'c' })

    -- delete_pair
    insx.add('<BS>', require('insx.recipe.delete_pair')({
      open_pat = esc(open),
      close_pat = esc(close),
    }), { mode = 'c' })
  end
end

return standard
