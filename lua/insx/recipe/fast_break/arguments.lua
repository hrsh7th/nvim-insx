local helper = require('insx.helper')
local basic = require('insx.recipe.fast_break.basic')

local PAIRS_MAP = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['<'] = '>',
}

---@param option insx.recipe.fast_break.Option
return function(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      local open_indent = helper.indent.get_current_indent()

      -- Invoke basic action.
      basic(option).action(ctx)

      -- Split behavior.
      local memo_row, memo_col = ctx.row(), ctx.col()
      local main_close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
      while true do
        local comma_pos = ctx.search([[\%#.\{-},\s*\zs]])
        if not comma_pos or comma_pos[1] ~= ctx.row() then
          break
        end
        ctx.move(comma_pos[1], comma_pos[2])

        local inner = false
        for open, close in pairs(PAIRS_MAP) do
          local curr_close_pos = helper.search.get_pair_close(helper.regex.esc(open), helper.regex.esc(close))
          if main_close_pos and curr_close_pos and helper.position.gt(curr_close_pos, main_close_pos) then
            inner = true
            break
          end
        end
        if not inner then
          ctx.backspace([[\s*]])
          ctx.send('<CR>')
          ctx.send(helper.indent.adjust({
            current = helper.indent.get_current_indent(),
            expected = open_indent .. helper.indent.get_one_indent(),
          }))
          main_close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
        end
      end
      ctx.move(memo_row, memo_col)
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if not option.split then
        return false
      end
      if not ctx.match(option.open_pat .. [[\s*\%#]]) then
        return false
      end
      local close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
      if not close_pos or close_pos[1] ~= ctx.row() then
        return false
      end
      return true
    end,
  }
end
