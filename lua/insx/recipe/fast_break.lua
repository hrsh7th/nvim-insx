local helper = require('insx.helper')

---@class insx.recipe.fast_break.Option
---@field public open_pat string
---@field public close_pat string
---@field public split? boolean

---@param option insx.recipe.fast_break.Option
---@return insx.RecipeSource
local function fast_break(option)
  local pairs_map = {
    ['('] = ')',
    ['['] = ']',
    ['{'] = '}',
    ['<'] = '>',
  }

  return {
    ---@param ctx insx.Context
    action = function(ctx)
      local open_indent = helper.indent.get_current_indent()

      -- Open side.
      ctx.send(ctx.char)
      ctx.send(helper.indent.make_ajudst_keys({
        current = helper.indent.get_current_indent(),
        expected = open_indent .. helper.indent.get_one_indent(),
      }))

      -- Close side.
      local row, col = ctx.row(), ctx.col()
      local close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
      assert(close_pos)
      ctx.move(close_pos[1], close_pos[2])
      ctx.send(ctx.char)
      ctx.send(helper.indent.make_ajudst_keys({
        current = helper.indent.get_current_indent(),
        expected = open_indent,
      }))
      ctx.move(row, col)

      -- Splitjoin like behavior if needed.
      if option and option.split then
        local memo_row, memo_col = ctx.row(), ctx.col()

        local main_close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
        while true do
          local comma_pos = helper.search.get_next([[,\s*\zs]])
          if not comma_pos or comma_pos[1] ~= ctx.row() then
            break
          end
          ctx.move(comma_pos[1], comma_pos[2])

          local inner = false
          for open, close in pairs(pairs_map) do
            local curr_close_pos = helper.search.get_pair_close(helper.regex.esc(open), helper.regex.esc(close))
            if main_close_pos and curr_close_pos and helper.position.gt(curr_close_pos, main_close_pos) then
              inner = true
              break
            end
          end
          if not inner then
            if ctx.before():match('%s+$') then
              ctx.send(('<Left><Del>'):rep(vim.fn.strchars(ctx.before():match('%s+$'), true)))
            end
            ctx.send(ctx.char)
            ctx.send(helper.indent.make_ajudst_keys({
              current = helper.indent.get_current_indent(),
              expected = open_indent .. helper.indent.get_one_indent(),
            }))
            main_close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
          end
        end
        ctx.move(memo_row, memo_col)
      end
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if helper.syntax.in_string_or_comment() then
        return false
      end
      if not helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]]) then
        return false
      end
      if not (option and option.split) then
        if not helper.regex.match(ctx.after(), [[^\s*]] .. option.close_pat) then
          return false
        end
      end
      local close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
      if not close_pos or close_pos[1] ~= ctx.row() then
        return false
      end
      return true
    end,
  }
end

return fast_break
