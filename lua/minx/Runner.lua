local kit = require('minx.kit')
local Async = require('minx.kit.Async')
local RegExp = require('minx.kit.Vim.RegExp')
local Keymap = require('minx.kit.Vim.Keymap')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

---@param keys_ minx.kit.Vim.Keymap.KeysSpecifier
---@return minx.kit.Vim.Keymap.KeysSpecifier
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

---@class minx.Runner
---@field public ctx minx.Context
---@field public recipe minx.Recipe
local Runner = {}

---Create step object.
---@param ctx minx.Context
---@param recipe minx.Recipe
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
    self.recipe.action(vim.tbl_deep_extend('keep', {
      send = function(keys)
        Keymap.send(convert(keys)):await()
      end,
      move = function(row, col)
        local cursor = vim.api.nvim_win_get_cursor(0)
        if cursor[1] == row + 1 then
          -- Same line cursor move.
          local delta = col - cursor[2]
          if delta > 0 then
            Keymap.send(convert(('<Right>'):rep(delta))):await()
          elseif delta < 0 then
            Keymap.send(convert(('<Left>'):rep(math.abs(delta)))):await()
          end
        else
          -- Jump to the other line.
          Keymap.send(convert(('<C-o>:<C-u>call cursor(%s, %s)<CR>'):format(row + 1, col + 1))):await()
        end
      end,
    }, self.ctx))
  end)
  return ''
end

return Runner
