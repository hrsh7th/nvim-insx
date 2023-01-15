local helper = require('minx.helper')
local kit = require('minx.kit')

---@class minx.recipe.auto_pair.Option
---@field public open string
---@field public close string
---@field public ignore_pat? string{}

---@param option minx.recipe.auto_pair.Option
---@return minx.RecipeSource
local function auto_pair(option)
  local ignore_pat = kit.to_array(option and option.ignore_pat or {})
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
    end,
    ---@param _ minx.Context
    enabled = function(_)
      for _, pat in ipairs(ignore_pat) do
        if helper.search.get_next(pat) then
          return false
        end
      end
      return true
    end,
  }
end

return auto_pair
