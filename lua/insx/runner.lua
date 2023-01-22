local kit = require('insx.kit')
local Async = require('insx.kit.Async')
local RegExp = require('insx.kit.Vim.RegExp')
local Keymap = require('insx.kit.Vim.Keymap')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

---@param keys_ insx.kit.Vim.Keymap.KeysSpecifier
---@param ctx insx.Context
---@return insx.kit.Vim.Keymap.KeysSpecifier
local function convert(keys_, ctx)
  return vim.tbl_map(function(keys)
    if type(keys) == 'string' then
      keys = { keys = keys, remap = false }
    end
    keys.keys = Keymap.termcodes(keys.keys)
    if ctx.mode == 'i' then
      keys.keys = RegExp.gsub(keys.keys, undojoin, '')
      keys.keys = RegExp.gsub(keys.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. left, undojoin .. left)
      keys.keys = RegExp.gsub(keys.keys, [[\%(]] .. undobreak .. [[\)\@<!]] .. right, undojoin .. right)
    end
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
        Keymap.send(convert(keys, ctx)):await()
      end,
      move = function(row, col)
        local virtualedit = vim.o.virtualedit
        vim.o.virtualedit = 'all'

        local cursor = { ctx.row(), ctx.col() }

        -- fix row.
        if cursor[1] ~= row then
          local delta = cursor[1] - row
          if delta > 0 then
            Keymap.send(convert(('<Up>'):rep(delta), ctx)):await()
          elseif delta < 0 then
            Keymap.send(convert(('<Down>'):rep(math.abs(delta)), ctx)):await()
          end
        end

        -- fix col.
        local cursor_col, cursor_off = ctx.col(), ctx.off()
        local t = ctx.text()
        local s = (cursor_col < col) and cursor_col or col
        local e = (cursor_col < col) and col or cursor_col
        local delta_text = t:sub(s + 1, math.min(#t, e)) .. (' '):rep(cursor_off) -- for supporting `<Tab>` character width.
        if col > cursor[2] then
          Keymap.send(convert(('<Right>'):rep(vim.fn.strdisplaywidth(delta_text)), ctx)):await()
        elseif col < cursor[2] then
          Keymap.send(convert(('<Left>'):rep(vim.fn.strdisplaywidth(delta_text)), ctx)):await()
        end

        vim.o.virtualedit = virtualedit
      end,
    }, ctx))
    vim.o.lazyredraw = lazyredraw
  end)
  return ''
end

return runner
