local kit = require('insx.kit')
local Keymap = require('insx.kit.Vim.Keymap')
local RegExp = require('insx.kit.Vim.RegExp')

local undobreak = Keymap.termcodes('<C-g>u')
local undojoin = Keymap.termcodes('<C-g>U')
local left = Keymap.termcodes('<Left>')
local right = Keymap.termcodes('<Right>')

local context = {}

function context.create(char)
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
    send = function(key_specifiers)
      Keymap.send(vim.tbl_map(function(key_specifier)
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
      end, kit.to_array(key_specifiers))):await()
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

return context
