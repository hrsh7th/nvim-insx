---@class insx.recipe.universal.jump_out.Option
---@field public close string
---@field public ignore_escaped? boolean

---@param option insx.recipe.universal.jump_out.Option
---@return insx.RecipeSource
local function jump_out(option)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<Right>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if option.ignore_escaped and ctx.before():sub(-1) == [[\]] then
        return false
      end
      return ctx.after():sub(1, 1) == option.close
    end,
  }
end

return jump_out
