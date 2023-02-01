local kit = require('insx.kit')

---@class insx.recipe.universal.jump_out.Option
---@field public close string
---@field public ignore_pat? string|string[]

---@param option insx.recipe.universal.jump_out.Option
---@return insx.RecipeSource
local function jump_out(option)
  local ignore_pat = kit.to_array(option.ignore_pat or {})
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<Right>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      for _, pat in ipairs(ignore_pat) do
        if ctx.match(pat) then
          return false
        end
      end
      return ctx.after():sub(1, 1) == option.close
    end,
  }
end

return jump_out
