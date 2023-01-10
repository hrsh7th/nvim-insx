local Runner = require('minx.Runner')

---@param char string
---@return minx.Context
local function context(char)
  return {
    row = function()
      return vim.api.nvim_win_get_cursor(0)[1] - 1
    end,
    col = function()
      return vim.api.nvim_win_get_cursor(0)[2]
    end,
    char = char,
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

local minx = {}

minx.helper = require('minx.helper')

---@class minx.Position
---@field public row integer
---@field public col integer

---@alias minx.Recipe fun(matches: string[])

---@class minx.EntrySource
---@field public action fun(ctx: minx.ActionContext): nil
---@field public enabled? fun(ctx: minx.Context): boolean
---@field public priority? integer

---@class minx.Entry
---@field public index integer
---@field public action fun(ctx: minx.ActionContext): nil
---@field public enabled fun(ctx: minx.Context): boolean
---@field public priority integer

---@class minx.Context
---@field public char string
---@field public row fun(): integer 0-origin index
---@field public col fun(): integer 0-origin utf8 byte index
---@field public text fun(): string
---@field public after fun(): string
---@field public before fun(): string

---@class minx.ActionContext : minx.Context
---@field public send fun(keys: minx.kit.Vim.Keymap.KeysSpecifier): nil
---@field public move fun(row: integer, col: integer): nil

---@type table<string, minx.Entry[]>
minx.entries = {}

---Add new mapping entry for specific mapping.
---@param char string
---@param entry_source minx.EntrySource
function minx.add(char, entry_source)
  -- initialize mapping.
  if not minx.entries[char] then
    minx.entries[char] = {}

    vim.keymap.set('i', char, function()
      local ctx = context(char)
      local e = minx.get_entry(ctx)
      if e then
        return Runner.new(ctx, e):run()
      end
      return char
    end, {
      expr = true,
    })
  end

  -- add normalized entry.
  table.insert(minx.entries[char], {
    index = #minx.entries[char] + 1,
    action = entry_source.action,
    enabled = entry_source.enabled or function()
      return true
    end,
    priority = entry_source.priority,
  })
end

---Get sorted/normalized entries for specific mapping.
---@param ctx minx.Context
---@return minx.Entry|nil
function minx.get_entry(ctx)
  local entries = minx.entries[ctx.char] or {}
  table.sort(entries, function(a, b)
    if a.priority and b.priority then
      local diff = a.priority - b.priority
      if diff == 0 then
        return a.priority > b.priority
      end
    end
    return a.index < b.index
  end)
  for _, entry in ipairs(entries) do
    if entry.enabled(ctx) then
      return entry
    end
  end
end

return minx
