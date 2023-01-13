# nvim-minx

Manage insert mode mapping.

<video src="https://user-images.githubusercontent.com/629908/211611400-4912f939-386c-4ec4-b63d-f79aa543e4e1.mov" width="100%"></video>

### Warning

- This plugin does not support `dot-repeat`.
  - The macro have the highest priority.
- This plugin is *usually* works as expected.
  - Does not aim to support to always work as expected because this plugin uses RegExp 😅
- It is more convenient when used with vim-matchup.
  - The demo image uses with vim-matchup. 👍

### Usage

This plugin does not provide any default mappings.

You should define mapping by yourself like this.

```lua
do
  local minx = require('minx')
  local esc = minx.helper.regex.esc

  -- Endwise (experimental).
  local endwise = require('minx.recipe.endwise')
  minx.add('<CR>', endwise.recipe(endwise.builtin))

  -- Quotes
  for open, close in pairs({
    ["'"] = "'",
    ['"'] = '"',
    ['`'] = '`',
  }) do
    -- Auto pair.
    minx.add(open, require('minx.recipe.auto_pair')({
      open = open,
      close = close,
    }))

    -- Leave pair.
    minx.add(close, require('minx.recipe.leave_symbol')({
      symbol_pat = {
        esc(close)
      }
    }))

    -- Delete pair.
    minx.add('<BS>', require('minx.recipe.delete_pair')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))
  end

  -- Pairs.
  for open, close in pairs({
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }) do
    -- Auto pair.
    minx.add(open, require('minx.recipe.auto_pair')({
      open = open,
      close = close,
    }))

    -- Leave pair.
    minx.add(close, require('minx.recipe.leave_symbol')({
      symbol_pat = {
        esc(close)
      }
    }))

    -- Delete pair.
    minx.add('<BS>', require('minx.recipe.delete_pair')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Increase/decrease spacing.
    minx.add('<Space>', require('minx.recipe.pair_spacing').increase_pair_spacing({
      open_pat = esc(open),
      close_pat = esc(close),
    }))
    minx.add('<BS>', require('minx.recipe.pair_spacing').decrease_pair_spacing({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Break pairs: `(|)` -> `<CR>` -> `(<CR>|<CR>)`
    minx.add('<CR>', require('minx.recipe.fast_break')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Wrap next token: `(|)func(...)` -> `)` -> `(func(...)|)`
    minx.add('<C-;>', require('minx.recipe.fast_wrap')({
      close = close
    }))
  end

  -- Remove HTML Tag: `<div>|</div>` -> `<BS>` -> `|`
  minx.add('<BS>', require('minx.recipe.delete_pair')({
    open_pat = minx.helper.search.Tag.Open,
    close_pat = minx.helper.search.Tag.Close,
  }))

  -- Break HTML Tag: `<div>|</div>` -> `<BS>` -> `<div><CR>|<CR></div>`
  minx.add('<CR>', require('minx.recipe.fast_break')({
    open_pat = minx.helper.search.Tag.Open,
    close_pat = minx.helper.search.Tag.Close,
  }))
end
```

### Status

early development.
