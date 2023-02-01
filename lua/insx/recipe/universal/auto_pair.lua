local kit = require('insx.kit')

---@class insx.recipe.universal.auto_pair.Option
---@field public open string
---@field public close string
---@field public ignore_pat? string|string[]

---@param option insx.recipe.universal.auto_pair.Option
---@return insx.RecipeSource
local function auto_pair(option)
  local ignore_pat = kit.to_array(option.ignore_pat or {})
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      for _, pat in ipairs(ignore_pat) do
        if ctx.match(pat) then
          return false
        end
      end
      return true
    end,
  }
end

return auto_pair
