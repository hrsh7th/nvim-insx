local helper = require('minx.helper')

---@class minx.recipe.fast_break.Option
---@field public open_pat string
---@field public close_pat string

---@param option minx.recipe.fast_break.Option
---@return minx.RecipeSource
local function fast_break(option)
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      ctx.send(ctx.char)
      local close_pos = helper.pairs.get_pair_close(option.open_pat, option.close_pat)
      if close_pos and ctx.row() == close_pos[1] - 1 then
        local row, col = ctx.row(), ctx.col()
        ctx.move(close_pos[1] - 1, close_pos[2] - 1)
        ctx.send(ctx.char)
        ctx.move(row, col)
      end
    end,
    ---@param ctx minx.Context
    enabled = function(ctx)
      local before = helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]])
      return not helper.syntax.in_string_or_comment() and before
    end,
  }
end

return fast_break
