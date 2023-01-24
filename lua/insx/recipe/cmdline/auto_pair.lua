---@class insx.recipe.cmdline.auto_pair.Option
---@field public open string
---@field public close string
---@field public ignore_escaped? boolean

---@param option insx.recipe.cmdline.auto_pair.Option
---@return insx.RecipeSource
local function auto_pair(option)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if option.ignore_escaped and ctx.before():sub(-1) == [[\]] then
        return false
      end
      return true
    end,
  }
end

return auto_pair
