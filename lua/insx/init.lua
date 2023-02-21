local kit = require('insx.kit')
local Async = require('insx.kit.Async')
local Keymap = require('insx.kit.Vim.Keymap')
local RegExp = require('insx.kit.Vim.RegExp')
local search = require('insx.helper.search')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

---@alias insx.Enabled fun(ctx: insx.Context): nil
---@alias insx.Action fun(ctx: insx.Context): nil

---@class insx.RecipeSource
---@field public priority? integer
---@field public enabled? insx.Enabled
---@field public action insx.Action

---@class insx.Recipe
---@field public index integer
---@field public priority integer
---@field public enabled insx.Enabled
---@field public action insx.Action

---@class insx.Context
---@field public filetype string
---@field public char string
---@field public data table
---@field public mode fun(): string
---@field public row fun(): integer 0-origin index
---@field public col fun(): integer 0-origin utf8 byte index
---@field public off fun(): integer 0-origin utf8 byte index
---@field public text fun(): string
---@field public after fun(): string
---@field public before fun(): string
---@field public match fun(pattern: string): boolean
---@field public search fun(pattern: string): { [1]: integer, [2]: integer }?
---@field public send fun(keys: insx.kit.Vim.Keymap.KeysSpecifier): nil
---@field public move fun(row: integer, col: integer): nil
---@field public next fun(): nil

---@class insx.Override
---@field public enabled? fun(enabled: insx.Enabled, ctx: insx.Context): boolean?
---@field public action? fun(action: insx.Action, ctx: insx.Context): nil

---@class insx.preset.standard.Config
---@field public cmdline? { enabled?: boolean }
---@field public spacing? { enabled?: boolean }
---@field public fast_break? { enabled?: boolean, split?: boolean }
---@field public fast_wrap? { enabled?: boolean }

---@type table<string, table<string, insx.RecipeSource[]>>
local mode_map = {}

---@param key string
---@return string
local function normalize(key)
  return vim.fn.keytrans(Keymap.termcodes(key))
end

---Get sorted/normalized entries for specific mapping.
---@param ctx insx.Context
---@param recipe_sources insx.RecipeSource[]
---@return insx.Recipe[]
local function get_recipes(ctx, recipe_sources)
  local recipes = kit.map(recipe_sources, function(recipe_source, index)
    return {
      index = index,
      enabled = function(ctx)
        return not recipe_source.enabled or recipe_source.enabled(ctx)
      end,
      action = function(ctx)
        recipe_source.action(ctx)
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

---@param char string
---@return insx.Context
local function create_context(char)
  ---@type insx.Context
  local ctx
  ctx = {
    filetype = vim.api.nvim_buf_get_option(0, 'filetype'),
    char = char,
    data = {},
    mode = function()
      return vim.api.nvim_get_mode().mode
    end,
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
      return ctx.search(pattern) ~= nil
    end,
    search = function(pattern)
      if not pattern:find([[\%#]], 1, true) then
        error('pattern must contain cursor position (\\%#)')
      end
      if ctx.mode() == 'i' then
        return search.get_next(pattern)
      end

      local _, before_e = vim.regex([[^.*\ze\\%#]]):match_str(pattern)
      local after_s, _ = vim.regex([[\\%#\zs.*$]]):match_str(pattern)
      local before_pat = pattern:sub(1, before_e)
      local after_pat = pattern:sub(after_s + 1)
      local after_has_zs = not not after_pat:find([[\zs]])
      local before_match_s = before_pat ~= '' and vim.regex(before_pat .. [[$]]):match_str(ctx.before())
      local after_match_s = after_pat ~= '' and vim.regex([[^]] .. after_pat):match_str(ctx.after())
      if before_match_s and not after_has_zs then
        return { ctx.row(), before_match_s }
      elseif after_match_s then
        return { ctx.row(), ctx.col() + after_match_s }
      elseif before_pat == '' and after_pat == '' then
        return { ctx.row(), ctx.col() }
      end
    end,
    next = function()
      error('ctx.next` can only be called in `recipe.action`.')
    end,
    send = function(key_specifiers)
      Keymap.send(
        vim.tbl_map(function(key_specifier)
          if type(key_specifier) == 'string' then
            key_specifier = { keys = key_specifier, remap = false }
          end
          key_specifier.keys = Keymap.termcodes(key_specifier.keys)
          if ctx.mode() == 'i' then
            key_specifier.keys = RegExp.gsub(key_specifier.keys, undojoin, '')
            key_specifier.keys = RegExp.gsub(key_specifier.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. left, undojoin .. left)
            key_specifier.keys = RegExp.gsub(key_specifier.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. right, undojoin .. right)
          end
          return key_specifier
        end, kit.to_array(key_specifiers))
      ):await()
    end,
    move = function(row, col)
      if ctx.row() ~= row then
        vim.api.nvim_win_set_cursor(0, { row + 1, col })
      else
        local diff = col - ctx.col()
        if diff > 0 then
          ctx.send(('<Right>'):rep(diff))
        elseif diff < 0 then
          ctx.send(('<Left>'):rep(math.abs(diff)))
        end
      end
    end,
  }
  return ctx
end

local insx = {}

insx.helper = require('insx.helper')

---Add new mapping recipe for specific mapping.
---@param char string
---@param recipe_source insx.RecipeSource
---@param option? { mode?: 'i' | 'c' }
function insx.add(char, recipe_source, option)
  char = normalize(char)

  -- ensure tables.
  local mode = option and option.mode or 'i'
  if not mode_map[mode] then
    mode_map[mode] = {}
  end

  -- initialize mapping.
  if not mode_map[mode][char] then
    mode_map[mode][char] = {}

    vim.keymap.set(mode, char, function()
      return insx.expand(char)
    end, {
      desc = 'insx',
      expr = true,
      replace_keycodes = false,
    })
  end

  table.insert(mode_map[mode][char], recipe_source)
end

---Remove mappings.
function insx.clear()
  for _, mode in ipairs({ 'i', 'c' }) do
    for _, keymap in ipairs(vim.api.nvim_get_keymap(mode)) do
      if keymap.desc == 'insx' then
        vim.api.nvim_del_keymap(mode, keymap.lhs)
      end
    end
  end
  mode_map = {}
end

---Expand key mapping as cmd mapping.
---@param char string
---@return string
function insx.expand(char)
  char = normalize(char)

  local ctx = create_context(char)

  -- initialize ctx.next function.
  do
    local recipes = kit.concat(get_recipes(ctx, kit.get(mode_map, { ctx.mode(), char }, {})), {
      {
        ---@param ctx insx.Context
        action = function(ctx)
          ctx.send(ctx.char)
        end
      }
    })
    function ctx.next()
      table.remove(recipes, 1).action(ctx)
    end
  end

  return Keymap.to_sendable(function()
    Async.run(function()
      local lazyredraw = vim.o.lazyredraw
      vim.o.lazyredraw = true
      ctx.next()
      vim.o.lazyredraw = lazyredraw
    end)
  end)
end

---Compose multiple recipes as one recipe.
---@param recipe_sources insx.RecipeSource[]
---@return insx.RecipeSource
function insx.compose(recipe_sources)
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
    end
  }
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
      end
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
      end
    }
  end,
  ---Create filetype override.
  ---@param filetypes string|string[]
  ---@return insx.Override
  filetype = function(filetypes)
    filetypes = kit.to_array(filetypes) --[=[@as string[]]=]
    return {
      ---@param enabled insx.Enabled
      ---@param ctx insx.Context
      enabled = function(enabled, ctx)
        return vim.tbl_contains(filetypes, ctx.filetype) and enabled(ctx)
      end
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
      end
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
      end
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
      end
    }
  end,
}, {
  ---Enhance existing recipe with overrides.
  ---@param recipe insx.RecipeSource
  ---@param overrides insx.Override
  ---@return insx.RecipeSource
  __call = function(_, recipe, overrides, ...)
    if #{ ... } > 0 then
      vim.deprecate('insx.with(recipe, ...overrides)', 'insx.with(recipe, overrides)', '0', 'nvim-insx', false)
      overrides = kit.concat(kit.to_array(overrides), { ... })
    end

    local new_recipe = recipe
    for _, override_ in ipairs(kit.reverse(overrides)) do
      new_recipe = (function(override, prev_recipe)
            local next_recipe = kit.merge({}, prev_recipe)

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
  end
})

return insx
