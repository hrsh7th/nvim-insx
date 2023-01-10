local helper = require('minx.helper')

---@class minx.recipe.delete_pair.Option
---@field public open_pat string
---@field public close_pat string

---@param option minx.recipe.delete_pair.Option
---@return minx.RecipeSource
local function delete_pair(option)
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      local open_text = helper.regex.match(ctx.before(), option.open_pat .. '$')
      local close_text = helper.regex.match(ctx.after(), '^' .. option.close_pat)
      ctx.send(('<BS>'):rep(vim.fn.strchars(open_text, true)))
      ctx.send(('<Del>'):rep(vim.fn.strchars(close_text, true)))
    end,
    ---@param ctx minx.Context
    enabled = function(ctx)
      return helper.regex.match(ctx.before(), option.open_pat .. '$') and helper.regex.match(ctx.after(), '^' .. option.close_pat)
    end,
  }
end

return delete_pair
