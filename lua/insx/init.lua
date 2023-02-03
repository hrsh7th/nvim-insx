local kit = require('insx.kit')
local Async = require('insx.kit.Async')
local Keymap = require('insx.kit.Vim.Keymap')
local context = require('insx.context')

---@alias insx.Enabled fun(ctx: insx.ContextSource): nil
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

---@class insx.ContextSource
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

---@class insx.Context: insx.ContextSource
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

---@type table<string, table<string, insx.Recipe[]>>
local mode_map = {}

---@param key string
---@return string
local function normalize(key)
  return vim.fn.keytrans(Keymap.termcodes(key))
end

---Get sorted/normalized entries for specific mapping.
---@param ctx_source insx.ContextSource
---@param recipes insx.Recipe[]
---@return insx.Recipe[]
local function get_recipes(ctx_source, recipes)
  for i, recipe in ipairs(recipes) do
    recipe.index = recipe.index or i
  end
  table.sort(recipes, function(a, b)
    if a.priority ~= b.priority then
      return a.priority > b.priority
    end
    return a.index < b.index
  end)
  return vim.tbl_filter(function(recipe)
    return recipe.enabled(ctx_source)
  end, recipes)
end

local insx = {}

insx.helper = require('insx.helper')

---Add new mapping recipe for specific mapping.
---@param char string
---@param recipe_sources insx.RecipeSource|insx.RecipeSource[]
---@param option? { mode?: 'i' | 'c' }
function insx.add(char, recipe_sources, option)
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

  -- add normalized recipe.
  for _, recipe_source in ipairs(kit.to_array(recipe_sources)) do
    ---@type insx.Recipe
    local recipe = {
      index = #mode_map[mode][char] + 1,
      enabled = function(ctx)
        return not recipe_source.enabled or recipe_source.enabled(ctx)
      end,
      action = function(ctx)
        recipe_source.action(ctx)
      end,
      priority = recipe_source.priority or 0,
    }
    table.insert(mode_map[mode][char], recipe)
  end
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

  local ctx_source = context.create_source(char)
  local recipes = get_recipes(ctx_source, kit.get(mode_map, { ctx_source.mode(), char }, {})--[=[@as insx.Recipe[]]=] )
  table.insert(recipes, {
    ---@param ctx insx.Context
    action = function(ctx)
      ctx.send(ctx.char)
    end
  })
  return Keymap.to_sendable(function()
    Async.run(function()
      local lazyredraw = vim.o.lazyredraw
      vim.o.lazyredraw = true
      context.create(ctx_source, recipes).next()
      vim.o.lazyredraw = lazyredraw
    end)
  end)
end

---@param recipe insx.RecipeSource
---@param override insx.Override
---@return insx.RecipeSource
function insx.with(recipe, override)
  override = override or {}

  local new_recipe = kit.merge({}, recipe)
  if override.action then
    new_recipe.action = function(ctx)
      return override.action(recipe.action, ctx)
    end
  end
  if override.enabled then
    new_recipe.enabled = function(ctx)
      return override.enabled(recipe.enabled or function()
        return true
      end, ctx)
    end
  end
  return new_recipe
end

return insx
