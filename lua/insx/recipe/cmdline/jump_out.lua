local helper = require('insx.helper')

---@class insx.recipe.cmdline.jump_out.Option
---@field public close string
---@field public ignore_escaped? boolean

---@param option insx.recipe.cmdline.jump_out.Option
---@return insx.RecipeSource
local function jump_out(option)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<Right>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if option.ignore_escaped and helper.regex.match(ctx.before(), [[\\$]]) then
        return false
      end
      return helper.regex.match(ctx.after(), [[^]] .. helper.regex.esc(option.close))
    end,
  }
end

return jump_out
