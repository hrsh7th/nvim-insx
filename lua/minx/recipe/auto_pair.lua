---@class minx.recipe.auto_pair.Option
---@field public open string
---@field public close string

---@param option minx.recipe.auto_pair.Option
---@return minx.RecipeSource
local function auto_pair(option)
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
    end,
  }
end

return auto_pair
