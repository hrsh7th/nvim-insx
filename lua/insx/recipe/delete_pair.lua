local insx = require('insx')

---@class insx.recipe.delete_pair.Option
---@field public open_pat string
---@field public close_pat string

---@param option insx.recipe.delete_pair.Option
---@return insx.RecipeSource
local function delete_pair(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      ctx.send('<BS><Del>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return ctx.match(option.open_pat .. [[\%#]] .. option.close_pat)
    end,
  }
end

return setmetatable({
  ---@param option insx.recipe.delete_pair.Option
  strings = function(option)
    return insx.with(delete_pair(option), {
      insx.with.nomatch([[\\]] .. option.open_pat .. [[\%#]]),
    })
  end,
}, {
  ---@param option insx.recipe.delete_pair.Option
  __call = function(_, option)
    return delete_pair(option)
  end,
})
