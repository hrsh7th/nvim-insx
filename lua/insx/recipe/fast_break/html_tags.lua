local helper = require('insx.helper')

---@class insx.recipe.fast_break.html_tags.Option

---@param _ insx.recipe.fast_break.html_tags.Option
---@return insx.RecipeSource
local function html_tags(_)
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
      local memo_row, memo_col = ctx.row(), ctx.col()
      local close_pos = assert(helper.search.get_pair_close(helper.search.Tag.Open, [[\ze]] .. helper.search.Tag.Close))
      ctx.move(close_pos[1], close_pos[2])
      ctx.send('<CR>')
      ctx.send(helper.indent.adjust({
        current = helper.indent.get_current_indent(),
        expected = open_indent,
      }))

      ctx.move(memo_row, memo_col)
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return ctx.match(helper.search.Tag.Open .. [[\s*\%#]]) and helper.search.get_pair_close(helper.search.Tag.Open, helper.search.Tag.Close)
    end,
  }
end

return html_tags

