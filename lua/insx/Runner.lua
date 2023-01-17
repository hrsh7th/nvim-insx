local kit = require('insx.kit')
local Async = require('insx.kit.Async')
local RegExp = require('insx.kit.Vim.RegExp')
local Keymap = require('insx.kit.Vim.Keymap')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

---@param keys_ insx.kit.Vim.Keymap.KeysSpecifier
---@return insx.kit.Vim.Keymap.KeysSpecifier
local function convert(keys_)
  return vim.tbl_map(function(keys)
    if type(keys) == 'string' then
      keys = { keys = keys, remap = false }
    end
    keys.keys = Keymap.termcodes(keys.keys)
    keys.keys = RegExp.gsub(keys.keys, undojoin, '')
    keys.keys = RegExp.gsub(keys.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. left, undojoin .. left)
    keys.keys = RegExp.gsub(keys.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. right, undojoin .. right)
    return keys
  end, kit.to_array(keys_))
end

---@class insx.Runner
---@field public ctx insx.Context
---@field public recipe insx.Recipe
local Runner = {}

---Create step object.
---@param ctx insx.Context
---@param recipe insx.Recipe
function Runner.new(ctx, recipe)
  local self = setmetatable({}, { __index = Runner })
  self.ctx = ctx
  self.recipe = recipe
  return self
end

---Return bootstrap keycodes.
---@return string
function Runner:run()
  Async.run(function()
    local lazyredraw = vim.o.lazyredraw
    vim.o.lazyredraw = true
    self.recipe.action(vim.tbl_deep_extend('keep', {
      send = function(keys)
        Keymap.send(convert(keys)):await()
      end,
      move = function(row, col)
        local cursor = vim.api.nvim_win_get_cursor(0)

        -- fix row.
        if cursor[1] ~= row + 1 then
          local delta = cursor[1] - (row + 1)
          if delta > 0 then
            Keymap.send(convert(('<Up>'):rep(delta))):await()
          elseif delta < 0 then
            Keymap.send(convert(('<Down>'):rep(math.abs(delta)))):await()
          end
        end

        -- fix col.
        local delta = col - cursor[2]
        if delta > 0 then
          Keymap.send(convert(('<Right>'):rep(delta))):await()
        elseif delta < 0 then
          Keymap.send(convert(('<Left>'):rep(math.abs(delta)))):await()
        end
      end,
    }, self.ctx))
    vim.o.lazyredraw = lazyredraw
  end)
  return ''
end

return Runner
