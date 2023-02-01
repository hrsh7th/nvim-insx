local kit = require('insx.kit')

---@class insx.recipe.universal.delete_pair.Option
---@field public open string
---@field public close string
---@field public ignore_pat? string|string[]

---@param option insx.recipe.universal.delete_pair.Option
---@return insx.RecipeSource
local function delete_pair(option)
  local ignore_pat = kit.to_array(option.ignore_pat or {})
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<BS><Del>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      for _, pat in ipairs(ignore_pat) do
        if ctx.match(pat) then
          return false
        end
      end
      local match_open = ctx.before():sub(-1) == option.open
      local match_close = ctx.after():sub(1, 1) == option.close
      return match_open and match_close
    end,
  }
end

return delete_pair
