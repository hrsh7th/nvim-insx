local kit = require('insx.kit')
local Async = require('insx.kit.Async')
local Keymap = require('insx.kit.Vim.Keymap')
local RegExp = require('insx.kit.Vim.RegExp')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

---@alias insx.Mode 'x' | 'i' | 'c' | 'n' | 'o' | 's'

---@alias insx.Enabled fun(ctx: insx.Context): nil
---@alias insx.Action fun(ctx: insx.Context): nil

---@class insx.RecipeSource
---@field public priority? integer
---@field public enabled? insx.Enabled
---@field public action insx.Action

---@alias insx.RecipeSourceLike insx.RecipeSource|insx.Action|string

---@class insx.Recipe
---@field public index integer
---@field public priority integer
---@field public enabled insx.Enabled
---@field public action insx.Action

---@class insx.Context
---@field public filetype string
---@field public char string
---@field public mode fun(): string
---@field public row fun(): integer 0-origin index
---@field public col fun(): integer 0-origin utf8 byte index
---@field public off fun(): integer 0-origin utf8 byte index
---@field public text fun(): string
---@field public after fun(): string
---@field public before fun(): string
---@field public match fun(pattern: string): string[]?
---@field public search fun(pattern: string): { [1]: integer, [2]: integer, matches: string[] }?
---@field public send fun(keys: insx.kit.Vim.Keymap.KeysSpecifier): nil
---@field public delete fun(pattern: string): nil
---@field public backspace fun(pattern: string): nil
---@field public remove fun(pattern: string): nil
---@field public move fun(row: integer, col: integer): nil
---@field public substr fun(str: string, i: integer, j: integer): string # char base substr function.
---@field public next fun(): nil

---@class insx.Override
---@field public priority? number
---@field public enabled? fun(enabled: insx.Enabled, ctx: insx.Context): boolean?
---@field public action? fun(action: insx.Action, ctx: insx.Context): nil

---@class insx.preset.standard.Config
---@field public cmdline? { enabled?: boolean }
---@field public spacing? { enabled?: boolean }
---@field public fast_break? { enabled?: boolean, split?: boolean, html_attrs?: boolean, arguments?: boolean }
---@field public fast_wrap? { enabled?: boolean }

---@type table<string, table<string, insx.RecipeSource[]>>
local mode_recipes_map = {}

---Get sorted/normalized entries for specific mapping.
---@param ctx insx.Context
---@param recipe_sources insx.RecipeSource[]
---@return insx.Recipe[]
local function get_recipes(ctx, recipe_sources)
  local recipes = kit.map(recipe_sources, function(recipe_source, index)
    return {
      index = index,
      ---@param ctx_ insx.Context
      enabled = function(ctx_)
        return not recipe_source.enabled or recipe_source.enabled(ctx_)
      end,
      ---@param ctx_ insx.Context
      action = function(ctx_)
        recipe_source.action(ctx_)
      end,
      priority = recipe_source.priority or 0,
    }
  end) --[=[@as insx.Recipe[]]=]

  table.sort(recipes, function(a, b)
    if a.priority ~= b.priority then
      return a.priority > b.priority
    end
    return a.index < b.index
  end)

  return vim.tbl_filter(function(recipe)
    return recipe.enabled(ctx)
  end, recipes)
end

---Normalize recipe source like.
---@param recipe_source_like insx.RecipeSource|insx.Action|string
---@return insx.RecipeSource
local function normalize_recipe_source_like(recipe_source_like)
  if type(recipe_source_like) == 'string' then
    return {
      action = function(ctx)
        ctx.send(recipe_source_like)
      end,
    }
  end
  if type(recipe_source_like) == 'function' then
    return {
      action = recipe_source_like,
    }
  end
  return recipe_source_like
end

---@param char string
---@return insx.Context
local function create_context(char)
  ---@type insx.Context
  local ctx
  ctx = {
    next = function()
      error('ctx.next` can only be called in `recipe.action`.')
    end,
    filetype = vim.api.nvim_get_option_value('filetype', { buf = 0 }),
    char = char,
    data = {},
    mode = function()
      -- i|ic|ix → i & c|cx → c
      -- see `:h mode()`
      local mode = vim.api.nvim_get_mode().mode --[[@as string]]
      if vim.tbl_contains({ 'v', 'V', '' }, mode) then
        return 'x'
      end
      return mode:sub(1, 1)
    end,
    -- region = function()
    --   local mode = vim.api.nvim_get_mode().mode --[[@as string]]
    --   if not vim.tbl_contains({ 'v', 'V', '' }, mode) then
    --     error('mode is not visual')
    --   end
    --   ctx.send('<Esc>gv')
    --   if vim.tbl_contains({ 'v', '' }, mode) then
    --     local s = vim.fn.getpos("'<")
    --     local e = vim.fn.getpos("'>")
    --     return {
    --       s = { s[2] - 1, s[3] - 1 },
    --       e = { e[2] - 1, e[3] },
    --     }
    --   elseif mode == 'V' then
    --     return {
    --       s = { ctx.row(), 0 },
    --       e = { ctx.row(), #ctx.text() },
    --     }
    --   end
    -- end,
    row = function()
      if ctx.mode() == 'c' then
        return 0
      end
      return vim.api.nvim_win_get_cursor(0)[1] - 1
    end,
    col = function()
      if ctx.mode() == 'c' then
        return vim.fn.getcmdpos() - 1
      end
      return vim.api.nvim_win_get_cursor(0)[2]
    end,
    off = function()
      if ctx.mode() == 'c' then
        return 0
      end
      return vim.fn.getpos('.')[4]
    end,
    text = function()
      if ctx.mode() == 'c' then
        return vim.fn.getcmdline()
      end
      return vim.api.nvim_get_current_line()
    end,
    before = function()
      return ctx.text():sub(1, ctx.col())
    end,
    after = function()
      return ctx.text():sub(ctx.col() + 1)
    end,
    match = function(pattern)
      local pos = ctx.search(pattern)
      if pos then
        return pos.matches
      end
    end,
    search = function(pattern)
      if not pattern:find([[\%#]], 1, true) then
        error('pattern must contain cursor position (\\%#)')
      end
      local _, before_e = vim.regex([[^.*\ze\\%#]]):match_str(pattern)
      local after_s, _ = vim.regex([[\\%#\zs.*$]]):match_str(pattern)

      local before_pat = pattern:sub(1, before_e)
      local after_pat = pattern:sub(after_s + 1)
      local after_has_zs = not not after_pat:find([[\zs]])
      local before_match_s = before_pat == '' and ctx.col() or vim.regex(before_pat .. [[$]]):match_str(ctx.before())
      local after_match_s = after_pat == '' and ctx.col() or vim.regex([[^]] .. after_pat):match_str(ctx.after())

      if not before_match_s or not after_match_s then
        return
      end

      if after_has_zs then
        return {
          ctx.row(),
          ctx.col() + after_match_s,
          matches = vim.fn.matchlist(ctx.text():sub(before_match_s + 1, ctx.col() + after_match_s), before_pat .. after_pat),
        }
      end
      return {
        ctx.row(),
        before_match_s,
        matches = vim.fn.matchlist(ctx.text():sub(before_match_s + 1), before_pat .. after_pat),
      }
    end,
    send = function(key_specifiers)
      key_specifiers = kit.to_array(key_specifiers)
      key_specifiers = vim.tbl_filter(function(key_specifier)
        if type(key_specifier) == 'string' then
          key_specifier = { keys = key_specifier, remap = false }
        end
        return key_specifier.keys ~= ''
      end, key_specifiers)
      key_specifiers = vim.tbl_map(function(key_specifier)
        if type(key_specifier) == 'string' then
          key_specifier = { keys = key_specifier, remap = false }
        end
        key_specifier.keys = Keymap.termcodes(key_specifier.keys)
        if ctx.mode() ~= 'c' then
          key_specifier.keys = RegExp.gsub(key_specifier.keys, undojoin, '')
          key_specifier.keys = RegExp.gsub(key_specifier.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. left, undojoin .. left)
          key_specifier.keys = RegExp.gsub(key_specifier.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. right, undojoin .. right)
        end
        return key_specifier
      end, key_specifiers)
      if #key_specifiers ~= 0 then
        Keymap.send(key_specifiers):await()
      end
    end,
    delete = function(pattern)
      ctx.remove([[\%#]] .. pattern)
    end,
    backspace = function(pattern)
      ctx.remove(pattern .. [[\%#]])
    end,
    remove = function(pattern)
      local pos = pattern:find([[\%#]], 1, true)
      if not pos then
        error('pattern must contain cursor position (\\%#)')
      end

      local keys = ''

      local before_pat = pattern:sub(1, pos - 1)
      if before_pat then
        local before_s = vim.regex(before_pat .. '$'):match_str(ctx.before())
        if before_s then
          local text = ctx.text():sub(before_s + 1, ctx.col())
          if text ~= '' then
            keys = keys .. ('<Left><Del>'):rep(vim.fn.strchars(text, true))
          end
        end
      end

      local after_pat = pattern:sub(pos + 3)
      if after_pat then
        local _, after_e = vim.regex('^' .. after_pat):match_str(ctx.after())
        if after_e then
          local text = ctx.text():sub(ctx.col() + 1, ctx.col() + after_e)
          if text ~= '' then
            keys = keys .. ('<Del>'):rep(vim.fn.strchars(text, true))
          end
        end
      end

      ctx.send(keys)
    end,
    move = function(row, col)
      if ctx.mode() == 'c' then
        vim.fn.setcmdline(vim.fn.getcmdline(), col + 1)
      else
        if ctx.row() == row then
          local diff = ctx.col() - col
          if diff > 0 then
            local text = ctx.text():sub(col + 1, ctx.col())
            ctx.send(('<Left>'):rep(vim.fn.strchars(text, true)))
          else
            local text = ctx.text():sub(ctx.col() + 1, col)
            ctx.send(('<Right>'):rep(vim.fn.strchars(text, true)))
          end
        else
          vim.api.nvim_win_set_cursor(0, { row + 1, col })
        end
      end
    end,
    substr = function(str, i, j)
      local len = vim.fn.strchars(str, true) + 1
      i = (len + i) % len
      j = (len + j) % len
      return vim.fn.strcharpart(str, i - 1, j - i + 1)
    end,
  }
  return ctx
end

local insx = {}

insx.helper = require('insx.helper')

---Add new mapping recipe for specific mapping.
---@param char string
---@param recipe_source_like insx.RecipeSourceLike
---@param option? { mode?: insx.Mode|insx.Mode[] }
function insx.add(char, recipe_source_like, option)
  char = Keymap.normalize(char)

  local recipe_source = normalize_recipe_source_like(recipe_source_like)

  -- ensure tables.
  local modes = kit.to_array(option and option.mode or 'i')
  for _, mode in ipairs(modes) do
    if not mode_recipes_map[mode] then
      mode_recipes_map[mode] = {}
    end

    -- initialize mapping.
    if not mode_recipes_map[mode][char] then
      mode_recipes_map[mode][char] = {}

      vim.keymap.set(mode, char, function()
        return insx.expand(char)
      end, {
        desc = 'insx',
        expr = true,
        replace_keycodes = false,
      })
    end

    table.insert(mode_recipes_map[mode][char], recipe_source)
  end
end

---Remove mappings.
function insx.clear()
  for mode, keys in pairs(mode_recipes_map) do
    for key in pairs(keys) do
      vim.api.nvim_del_keymap(mode, key)
    end
  end
  mode_recipes_map = {}
end

---Expand key mapping as cmd mapping.
---@param char string
---@return string
function insx.expand(char)
  if vim.b.insx_disabled then
    return Keymap.termcodes(char)
  end

  char = Keymap.normalize(char)

  local ctx = create_context(char)

  -- initialize ctx.next function.
  do
    local recipes = kit.concat(get_recipes(ctx, kit.get(mode_recipes_map, { ctx.mode(), char }, {})), {
      {
        action = function()
          if RegExp.get([=[^\k\+$]=]) ~= nil then
            ctx.send('<C-]>' .. ctx.char)
          else
            ctx.send(ctx.char)
          end
        end,
      },
    })
    function ctx.next()
      table.remove(recipes, 1).action(ctx)
    end
  end

  return Keymap.to_sendable(function()
    Async.run(function()
      local lazyredraw = vim.o.lazyredraw
      vim.o.lazyredraw = true
      local virtualedit = vim.o.virtualedit
      vim.o.virtualedit = 'all'
      ctx.next()
      vim.o.lazyredraw = lazyredraw
      vim.o.virtualedit = virtualedit
    end)
  end)
end

---Return the recipes for specified key in current context (except fallback recipe).
---@param char string
---@return insx.Recipe[]
function insx.detect(char)
  char = Keymap.normalize(char)
  local ctx = create_context(char)
  return get_recipes(ctx, kit.get(mode_recipes_map, { ctx.mode(), char }, {}))
end

---Compose multiple recipes as one recipe.
---@param recipe_source_likes insx.RecipeSourceLike[]
---@return insx.RecipeSource
function insx.compose(recipe_source_likes)
  ---@type insx.RecipeSource[]
  local recipe_sources = {}
  for _, recipe_source_like in ipairs(recipe_source_likes) do
    table.insert(recipe_sources, normalize_recipe_source_like(recipe_source_like))
  end

  return {
    ---@param ctx insx.Context
    action = function(ctx)
      local recipes = get_recipes(ctx, recipe_sources)
      local next = ctx.next
      ctx.next = function()
        if #recipes > 0 then
          table.remove(recipes, 1).action(ctx)
        else
          ctx.next = next
          ctx.next()
        end
      end
      ctx.next()
    end,
  }
end

---Escape string for regex.
---@param s string
---@return string
function insx.esc(s)
  return [[\V]] .. vim.fn.escape(s, [[\]]) .. [[\m]]
end

---Dedent specified text.
function insx.dedent(s)
  s = vim.split(s, '\n', { plain = true })
  if s[1] == '' then
    table.remove(s, 1)
  end
  if s[#s]:find([[^%s*$]]) then
    table.remove(s, #s)
  end

  -- detect base indentation.
  local base_indent = ''
  for _, text in ipairs(s) do
    local indent = text:match([=[^%s*]=])
    if base_indent == '' or (indent ~= '' and #indent < #base_indent) then
      base_indent = indent
    end
  end

  -- remove all base indentation.
  return table.concat(
    vim.tbl_map(function(text)
      return text:sub(#base_indent + 1)
    end, s),
    '\n'
  )
end

insx.with = setmetatable({
  ---Create pattern match override.
  ---@param pattern string
  ---@return insx.Override
  match = function(pattern)
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return ctx.match(pattern) and enabled(ctx)
      end,
    }
  end,
  ---Create pattern match override.
  ---@param pattern string
  ---@return insx.Override
  nomatch = function(pattern)
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return not ctx.match(pattern) and enabled(ctx)
      end,
    }
  end,
  ---Create filetype override.
  ---@param filetypes string|string[]
  ---@return insx.Override
  filetype = function(filetypes)
    filetypes = kit.to_array(filetypes) --[=[@as string[]]]=]
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return vim.tbl_contains(filetypes, ctx.filetype) and enabled(ctx)
      end,
    }
  end,
  ---Create string syntax override.
  ---@param ok_or_ng boolean default=false
  ---@return insx.Override
  in_string = function(ok_or_ng)
    ok_or_ng = kit.default(ok_or_ng, false)
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return insx.helper.syntax.in_string() == ok_or_ng and enabled(ctx)
      end,
    }
  end,
  ---Create comment syntax override.
  ---@param ok_or_ng boolean default=false
  ---@return insx.Override
  in_comment = function(ok_or_ng)
    ok_or_ng = kit.default(ok_or_ng, false)
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return insx.helper.syntax.in_comment() == ok_or_ng and enabled(ctx)
      end,
    }
  end,
  ---Create undopoint overrides.
  ---@param post boolean default=false
  undopoint = function(post)
    post = kit.default(post, false)
    return {
      action = function(action, ctx)
        if not post then
          vim.o.undolevels = vim.o.undolevels
        end
        action(ctx)
        if post then
          vim.o.undolevels = vim.o.undolevels
        end
      end,
    }
  end,
  ---Set priority.
  ---@param priority number
  priority = function(priority)
    return {
      priority = priority,
    }
  end,
}, {
  ---Enhance existing recipe with overrides.
  ---@param recipe_source_like insx.RecipeSourceLike
  ---@param overrides insx.Override
  ---@return insx.RecipeSource
  __call = function(_, recipe_source_like, overrides, ...)
    if #{ ... } > 0 then
      vim.deprecate('insx.with(recipe, ...overrides)', 'insx.with(recipe, overrides)', '0', 'nvim-insx', false)
      overrides = kit.concat(kit.to_array(overrides), { ... })
    end

    local new_recipe = normalize_recipe_source_like(recipe_source_like)
    for _, override_ in ipairs(kit.reverse(overrides)) do
      new_recipe = (function(override, prev_recipe)
        local next_recipe = kit.merge({}, prev_recipe)

        if type(override.priority) == 'number' then
          next_recipe.priority = override.priority
        end

        -- enhance action.
        if override.action then
          next_recipe.action = function(ctx)
            return override.action(prev_recipe.action, ctx)
          end
        end

        -- enhance enabled.
        if override.enabled then
          next_recipe.enabled = function(ctx)
            return override.enabled(prev_recipe.enabled or function()
              return true
            end, ctx)
          end
        end

        return next_recipe
      end)(override_, new_recipe)
    end
    return new_recipe
  end,
})

return insx
