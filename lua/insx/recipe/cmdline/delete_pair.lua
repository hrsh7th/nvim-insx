local helper = require('insx.helper')

---@class insx.recipe.cmdline.delete_pair.Option
---@field public open string
---@field public close string
---@field public ignore_escaped? boolean

---@param option insx.recipe.cmdline.delete_pair.Option
---@return insx.RecipeSource
local function delete_pair(option)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<BS><Del>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if option.ignore_escaped and helper.regex.match(ctx.before(), [[\\]] .. helper.regex.esc(option.open) .. [[$]]) then
        return false
      end
      local match_open = ctx.before():sub(-1) == option.open
      local match_close = ctx.after():sub(1, 1) == option.close
      return match_open and match_close
    end,
  }
end

return delete_pair
