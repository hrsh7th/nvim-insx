local kit = require('insx.kit')
local Keymap = require('insx.kit.Vim.Keymap')
local runner = require('insx.runner')

---@alias insx.Enabled fun(ctx: insx.Context): boolean?
---@alias insx.Action fun(ctx: insx.ActionContext): nil

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
---@field public row fun(): integer 0-origin index
---@field public col fun(): integer 0-origin utf8 byte index
---@field public text fun(): string
---@field public after fun(): string
---@field public before fun(): string

---@class insx.ActionContext : insx.Context
---@field public send fun(keys: insx.kit.Vim.Keymap.KeysSpecifier): nil
---@field public move fun(row: integer, col: integer): nil

---@class insx.Override
---@field public enabled? fun(enabled: insx.Enabled, ctx: insx.Context): boolean?
---@field public action? fun(action: insx.Action, ctx: insx.ActionContext): nil

---@param char string
---@return insx.Context
local function context(char)
  return {
    filetype = vim.api.nvim_buf_get_option(0, 'filetype'),
    char = char,
    data = {},
    row = function()
      return vim.api.nvim_win_get_cursor(0)[1] - 1
    end,
    col = function()
      return vim.api.nvim_win_get_cursor(0)[2]
    end,
    text = function()
      return vim.api.nvim_get_current_line()
    end,
    before = function()
      local c = vim.api.nvim_win_get_cursor(0)[2]
      return vim.api.nvim_get_current_line():sub(1, c)
    end,
    after = function()
      local c = vim.api.nvim_win_get_cursor(0)[2]
      return vim.api.nvim_get_current_line():sub(c + 1)
    end,
  }
end

---@param key string
---@return string
local function normalize(key)
  return vim.fn.keytrans(Keymap.termcodes(key))
end

---@type table<string, insx.Recipe[]>
local recipes_map = {}

---Get sorted/normalized entries for specific mapping.
---@param ctx insx.Context
---@return insx.Recipe|nil
local function get_recipe(ctx)
  local recipes = recipes_map[ctx.char] or {}
  table.sort(recipes, function(a, b)
    if a.priority ~= b.priority then
      return a.priority > b.priority
    end
    return a.index < b.index
  end)
  for _, recipe in ipairs(recipes) do
    if recipe.enabled(ctx) then
      return recipe
    end
  end
end

local insx = {}

insx.h = require('insx.helper')
insx.helper = require('insx.helper')

---Add new mapping recipe for specific mapping.
---@param char string
---@param recipe_source insx.RecipeSource
function insx.add(char, recipe_source)
  char = normalize(char)

  -- initialize mapping.
  if not recipes_map[char] then
    recipes_map[char] = {}

    vim.keymap.set('i', char, function()
      return insx.expand(char)
    end, {
      desc = 'insx',
      expr = true,
      replace_keycodes = false,
    })
  end

  -- add normalized recipe.
  local recipe = {
    index = #recipes_map[char] + 1,
    action = recipe_source.action,
    enabled = recipe_source.enabled or function()
      return true
    end,
    priority = recipe_source.priority or 0,
  }
  table.insert(recipes_map[char], recipe)
end

---Remove mappings.
function insx.clear()
  for _, keymap in ipairs(vim.api.nvim_get_keymap('i')) do
    if keymap.desc == 'insx' then
      vim.api.nvim_del_keymap('i', keymap.lhs)
    end
  end
  recipes_map = {}
end

---Expand key mapping as cmd mapping.
---@param char string
---@return string
function insx.expand(char)
  char = normalize(char)

  local ctx = context(char)
  local r = get_recipe(ctx)
  if r then
    return Keymap.to_sendable(function()
      runner.run(ctx, r)
    end)
  end
  return Keymap.termcodes(char)
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
