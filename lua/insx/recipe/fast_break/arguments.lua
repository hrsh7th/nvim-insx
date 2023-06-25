local helper = require('insx.helper')

local PAIRS_MAP = {
  ['('] = ')',
  ['['] = ']',
  ['{'] = '}',
  ['<'] = '>',
}

---@class insx.recipe.fast_break.arguments.Option
---@field public open_pat string
---@field public close_pat string

---@param option insx.recipe.fast_break.arguments.Option
---@return insx.RecipeSource
local function arguments(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      -- Remove spaces.
      ctx.remove([[\s*\%#\s*]])

      -- Open side.
      local open_indent = helper.indent.get_current_indent()
      ctx.send('<CR>')
      ctx.send(helper.indent.adjust({
        current = helper.indent.get_current_indent(),
        expected = open_indent .. helper.indent.get_one_indent(),
      }))

      -- Close side.
      local row, col = ctx.row(), ctx.col()
      local close_pos = assert(helper.search.get_pair_close(option.open_pat, option.close_pat))
      ctx.move(close_pos[1], close_pos[2])
      ctx.send('<CR>')
      ctx.send(helper.indent.adjust({
        current = helper.indent.get_current_indent(),
        expected = open_indent,
      }))
      ctx.move(row, col)

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
          if main_close_pos and curr_close_pos and helper.position.lt(curr_close_pos, main_close_pos) then
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

return arguments
