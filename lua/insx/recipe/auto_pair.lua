local helper = require('insx.helper')
local kit = require('insx.kit')

---@class insx.recipe.auto_pair.Option
---@field public open string
---@field public close string
---@field public ignore_pat? string{}

---@param option insx.recipe.auto_pair.Option
---@return insx.RecipeSource
local function auto_pair(option)
  local ignore_pat = kit.to_array(option and option.ignore_pat or {})
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
    end,
    ---@param _ insx.Context
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
