local kit = require('insx.kit')
local Keymap = require('insx.kit.Vim.Keymap')
local runner = require('insx.runner')

---@alias insx.Enabled fun(ctx: insx.Context): any
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
---@field public mode fun(): string
---@field public row fun(): integer 0-origin index
---@field public col fun(): integer 0-origin utf8 byte index
---@field public off fun(): integer 0-origin utf8 byte index
---@field public text fun(): string
---@field public after fun(): string
---@field public before fun(): string
---@field public match fun(pattern: string): boolean

---@class insx.ActionContext : insx.Context
---@field public send fun(keys: insx.kit.Vim.Keymap.KeysSpecifier): nil
---@field public move fun(row: integer, col: integer): nil

---@class insx.Override
---@field public enabled? fun(enabled: insx.Enabled, ctx: insx.Context): boolean?
---@field public action? fun(action: insx.Action, ctx: insx.ActionContext): nil

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

---@param char string
---@return insx.Context
local function context(char)
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
      if not pattern:find([[\%#]], 1, true) then
        error('pattern must contain cursor position (\\%#)')
      end

      local _, before_e = vim.regex([[^.*\ze\\%#]]):match_str(pattern)
      local after_s, _ = vim.regex([[\\%#\zs.*$]]):match_str(pattern)
      local before_pat = pattern:sub(1, before_e)
      local after_pat = pattern:sub(after_s + 1)
      local before_match = vim.regex(before_pat .. [[$]]):match_str(ctx.before())
      local after_match = vim.regex([[^]] .. after_pat):match_str(ctx.after())
      return before_match and after_match
    end,
  }
  return ctx
end

---Get sorted/normalized entries for specific mapping.
---@param ctx insx.Context
---@return insx.Recipe|nil
local function get_recipe(ctx)
  local recipe_map = mode_map[ctx.mode()] or {}
  local recipes = recipe_map[ctx.char] or {}
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

insx.helper = require('insx.helper')

---Add new mapping recipe for specific mapping.
---@param char string
---@param recipe_source insx.RecipeSource
---@param option? { mode?: 'i' | 'c' }
function insx.add(char, recipe_source, option)
  char = normalize(char)

  -- initialize mapping.
  local mode = option and option.mode or 'i'
  if not mode_map[mode] then
    mode_map[mode] = {}
  end
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
  local recipe = {
    index = #mode_map[mode][char] + 1,
    action = recipe_source.action,
    enabled = recipe_source.enabled or function()
      return true
    end,
    priority = recipe_source.priority or 0,
  }
  table.insert(mode_map[mode][char], recipe)
end

---Remove mappings.
function insx.clear()
  for _, keymap in ipairs(vim.api.nvim_get_keymap('i')) do
    if keymap.desc == 'insx' then
      vim.api.nvim_del_keymap('i', keymap.lhs)
    end
  end
  for _, keymap in ipairs(vim.api.nvim_get_keymap('c')) do
    if keymap.desc == 'insx' then
      vim.api.nvim_del_keymap('c', keymap.lhs)
    end
  end
  mode_map = {}
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
