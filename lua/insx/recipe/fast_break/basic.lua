local helper = require('insx.helper')

---@param option insx.recipe.fast_break.Option
---@return insx.RecipeSource
local function basic(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      -- Remove spaces.
      ctx.backspace([[\s*\%#]])
      ctx.delete([[\%#\s*]])

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
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if not ctx.match(option.open_pat .. [[\s*\%#]]) then
        return false
      end
      if not ctx.match([[\%#\s*]] .. option.close_pat) then
        return false
      end
      return true
    end,
  }
end

return basic
