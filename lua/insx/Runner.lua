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

local runner = {}

---Return bootstrap keycodes.
---@param ctx insx.Context
---@param recipe insx.Recipe
---@return string
function runner.run(ctx, recipe)
  Async.run(function()
    local lazyredraw = vim.o.lazyredraw
    vim.o.lazyredraw = true
    recipe.action(vim.tbl_deep_extend('keep', {
      send = function(keys)
        Keymap.send(convert(keys)):await()
      end,
      move = function(row, col)
        local virtualedit = vim.o.virtualedit
        vim.o.virtualedit = 'all'

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
        local _, _, cursor_col, cursor_off = unpack(vim.fn.getpos('.'))
        local t = vim.api.nvim_get_current_line()
        local s = (cursor_col < col + 1) and cursor_col - 1 or col
        local e = (cursor_col < col + 1) and col or cursor_col - 1
        local delta_text = t:sub(s + 1, math.min(#t, e)) .. (' '):rep(cursor_off) -- for supporting `<Tab>` character width.
        if col > cursor[2] then
          Keymap.send(convert(('<Right>'):rep(vim.fn.strdisplaywidth(delta_text)))):await()
        elseif col < cursor[2] then
          Keymap.send(convert(('<Left>'):rep(vim.fn.strdisplaywidth(delta_text)))):await()
        end

        vim.o.virtualedit = virtualedit
      end,
    }, ctx))
    vim.o.lazyredraw = lazyredraw
  end)
  return ''
end

return runner
