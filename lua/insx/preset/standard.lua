local kit = require('insx.kit')
local insx = require('insx')
local esc = require('insx.helper.regex').esc

local standard = {}

---@param config? insx.preset.standard.Config
function standard.setup(config)
  standard.config = config or {}
  standard.setup_insert_mode()
  standard.setup_cmdline_mode()
end

function standard.setup_insert_mode()
  -- markdown `.
  insx.add('`', {
    enabled = function(ctx)
      return ctx.match([[`\%#`]]) and ctx.filetype == 'markdown'
    end,
    action = function(ctx)
      ctx.send('``<Left>')
      ctx.send('``<Left>')
    end,
  })
  insx.add(
    '<CR>',
    require('insx.recipe.fast_break')({
      open_pat = [[```\w*]],
      close_pat = '```',
      indent = 0,
    })
  )

  -- html tag like.
  insx.add(
    '<CR>',
    require('insx.recipe.fast_break')({
      open_pat = insx.helper.search.Tag.Open,
      close_pat = insx.helper.search.Tag.Close,
    })
  )

  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    standard.set_quote('i', quote)
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
  }) do
    standard.set_pair('i', open, close)
  end
end

function standard.setup_cmdline_mode()
  if not kit.get(standard.config, { 'cmdline', 'enabled' }, false) then
    return
  end

  -- quotes
  for _, quote in ipairs({ '"', "'", '`' }) do
    standard.set_quote('c', quote)
  end

  -- pairs
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
  }) do
    standard.set_pair('c', open, close)
  end
end

---@param mode string
---@param quote string
---@param withs? insx.Override[]
function standard.set_quote(mode, quote, withs)
  withs = withs or {}
  local option = { mode = mode }

  -- jump_out
  insx.add(
    quote,
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\\\@<!\%#]] .. esc(quote) .. [[\zs]],
        },
      }),
      withs
    ),
    option
  )

  -- auto_pair
  insx.add(
    quote,
    insx.with(
      require('insx.recipe.auto_pair').strings({
        open = quote,
        close = quote,
      }),
      withs
    ),
    option
  )

  -- delete_pair
  insx.add(
    '<BS>',
    insx.with(
      require('insx.recipe.delete_pair').strings({
        open_pat = esc(quote),
        close_pat = esc(quote),
      }),
      withs
    ),
    option
  )
end

---@param mode string
---@param open string
---@param close string
---@param withs? insx.Override[]
function standard.set_pair(mode, open, close, withs)
  withs = withs or {}
  local option = { mode = mode }

  -- jump_out
  insx.add(
    close,
    insx.with(
      require('insx.recipe.jump_next')({
        jump_pat = {
          [[\%#]] .. esc(close) .. [[\zs]],
        },
      }),
      withs
    ),
    option
  )

  -- auto_pair
  insx.add(
    open,
    insx.with(
      require('insx.recipe.auto_pair')({
        open = open,
        close = close,
      }),
      withs
    ),
    option
  )

  -- delete_pair
  insx.add(
    '<BS>',
    insx.with(
      require('insx.recipe.delete_pair')({
        open_pat = esc(open),
        close_pat = esc(close),
      }),
      withs
    ),
    option
  )

  -- spacing
  if kit.get(standard.config, { 'spacing', 'enabled' }, true) then
    insx.add(
      '<Space>',
      insx.with(
        require('insx.recipe.pair_spacing').increase({
          open_pat = esc(open),
          close_pat = esc(close),
        }),
        withs
      ),
      option
    )

    insx.add(
      '<BS>',
      insx.with(
        require('insx.recipe.pair_spacing').decrease({
          open_pat = esc(open),
          close_pat = esc(close),
        }),
        withs
      ),
      option
    )
  end

  -- insert mode only.
  if option.mode == 'i' then
    -- fast_break
    if kit.get(standard.config, { 'fast_break', 'enabled' }, true) then
      insx.add(
        '<CR>',
        insx.with(
          require('insx.recipe.fast_break')({
            open_pat = esc(open),
            close_pat = esc(close),
            split = kit.get(standard.config, { 'fast_break', 'split' }, nil),
            html_attrs = kit.get(standard.config, { 'fast_break', 'html_attrs' }, true),
            html_tags = kit.get(standard.config, { 'fast_break', 'html_tags' }, true),
            arguments = kit.get(standard.config, { 'fast_break', 'arguments' }, true),
          }),
          withs
        ),
        option
      )
    end

    -- fast_wrap
    if kit.get(standard.config, { 'fast_wrap', 'enabled' }, true) then
      insx.add(
        '<C-]>',
        insx.with(
          require('insx.recipe.fast_wrap')({
            close = close,
          }),
          withs
        ),
        option
      )
    end
  end
end

return standard
