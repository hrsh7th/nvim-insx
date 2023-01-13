local kit = require('minx.kit')
local helper = require('minx.helper')

---@class minx.recipe.leave_symbol.Option
---@field public symbol_pat string|string[]

---@param option minx.recipe.leave_symbol.Option
---@return minx.RecipeSource
local function leave_symbol(option)
  vim.deprecate('require("minx.recipe.leave_symbol")', 'require("minx.recipe.jump_next")', '', 'nvim-minx', false)
  local symbol_pat = kit.to_array(option.symbol_pat)
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      ctx.send('<Right>')
    end,
    ---@param ctx minx.Context
    enabled = function(ctx)
      local after = ctx.after()
      for _, pat in ipairs(symbol_pat) do
        if helper.regex.match(after, [[^]] .. pat) then
          return true
        end
      end
    end,
  }
end

return leave_symbol
