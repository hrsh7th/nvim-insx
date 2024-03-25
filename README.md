# nvim-insx

nvim-insx is a flexible key mapping manager.

https://github.com/hrsh7th/nvim-insx/assets/629908/ad878d95-c541-4d6c-b135-139d511602b8


## Limitations and Warnings

- Dot-repeat is supported by only *basic* recipes.
  - Note that dot-repeat may not work with the complicated recipes.
- This plugin *usually* works as expected.
  - It may fire the accidental action,
    because the regular expression does not capture the structure of whole text.
  - We do not intend to integrate with tree-sitter
    as control over the regular expression is more convenient and sufficient.
- It is more convenient when used with vim-matchup.
  - A demonstration of vim-match usage can be referred to above.
- This plugin provides *basic* cmdline-mode pairwise features.
  - The advanced recipes do not support cmdline-mode.
- We can not accept the proposal for `preset` if it incorporates `breaking changes`.
  - Please write your own mapping definitions in your vimrc. 😢

## Usage

This plugin provides no default mappings.
You need to define your custom mappings as follows.

#### Preset

```lua
require('insx.preset.standard').setup()
```

#### Recipe

```lua
local insx = require('insx')

insx.add(
  "'",
  insx.with(require('insx.recipe.auto_pair')({
    open = "'",
    close = "'"
  }), {
    insx.with.in_string(false),
    insx.with.in_comment(false),
    insx.with.nomatch([[\\\%#]]),
    insx.with.nomatch([[\a\%#]])
  })
)
```

## Custom recipe

```lua
-- Simple pair deletion recipe.
local function your_recipe(option)
  return {
    action = function(ctx)
      if option.allow_space then
        ctx.remove([[\s*\%#\s*]])
      end
      ctx.send('<BS><Right><BS>')
    end,
    enabled = function(ctx)
      if option.allow_space then
        return ctx.match([[(\s*\%#\s*)]])
      end
      return ctx.match([[(\%#)]])
    end
  }
end
```

The standard preset enables some advanced features.

### Status

The API is stable except for the helper-related APIs.

Bug report & feature request are welcome.

