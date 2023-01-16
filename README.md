# nvim-insx

Extensible insert-mode key mapping manager.

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
  local insx = require('insx')
  local esc = insx.helper.regex.esc

  -- Endwise (experimental).
  local endwise = require('insx.recipe.endwise')
  insx.add('<CR>', endwise.recipe(endwise.builtin))

  -- Quotes
  for open, close in pairs({
    ["'"] = "'",
    ['"'] = '"',
    ['`'] = '`',
  }) do
    -- Auto pair.
    insx.add(open, require('insx.recipe.auto_pair')({
      open = open,
      close = close,
      ignore_pat = [[\\\%#]],
    }))

    -- Jump next.
    insx.add(close, require('insx.recipe.jump_next')({
      jump_pat = {
        [[\%#]] .. esc(close) .. [[\zs]]
      }
    }))

    -- Delete pair.
    insx.add('<BS>', require('insx.recipe.delete_pair')({
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
    insx.add(open, require('insx.recipe.auto_pair')({
      open = open,
      close = close,
    }))

    -- Jump next.
    insx.add(close, require('insx.recipe.jump_next')({
      jump_pat = {
        [[\%#]] .. esc(close) .. [[\zs]]
      }
    }))

    -- Delete pair.
    insx.add('<BS>', require('insx.recipe.delete_pair')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Increase/decrease spacing.
    insx.add('<Space>', require('insx.recipe.pair_spacing').increase({
      open_pat = esc(open),
      close_pat = esc(close),
    }))
    insx.add('<BS>', require('insx.recipe.pair_spacing').decrease({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Break pairs: `(|)` -> `<CR>` -> `(<CR>|<CR>)`
    insx.add('<CR>', require('insx.recipe.fast_break')({
      open_pat = esc(open),
      close_pat = esc(close),
    }))

    -- Wrap next token: `(|)func(...)` -> `)` -> `(func(...)|)`
    insx.add('<C-;>', require('insx.recipe.fast_wrap')({
      close = close
    }))
  end

  -- Remove HTML Tag: `<div>|</div>` -> `<BS>` -> `|`
  insx.add('<BS>', require('insx.recipe.delete_pair')({
    open_pat = insx.helper.search.Tag.Open,
    close_pat = insx.helper.search.Tag.Close,
  }))

  -- Break HTML Tag: `<div>|</div>` -> `<BS>` -> `<div><CR>|<CR></div>`
  insx.add('<CR>', require('insx.recipe.fast_break')({
    open_pat = insx.helper.search.Tag.Open,
    close_pat = insx.helper.search.Tag.Close,
  }))
end
```

### Status

development stage.

bug report & feature request are welcome.
