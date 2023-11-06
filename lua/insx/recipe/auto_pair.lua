local insx = require('insx')
local regex = require('insx.helper.regex')

---@class insx.recipe.auto_pair.Option
---@field public open string
---@field public close string

---@param option insx.recipe.auto_pair.Option
---@return insx.RecipeSource
local function auto_pair(option)
  return {
    ---@param ctx insx.Context
    enabled = function(ctx)
      return ctx.match(regex.esc(ctx.substr(option.open, 1, -2)) .. [[\%#]])
    end,
    ---@param ctx insx.Context
    action = function(ctx)
      if #option.open > 1 then
        ctx.remove(regex.esc(ctx.substr(option.open, 1, -2)) .. [[\%#]])
      end
      ctx.send(option.open .. option.close .. ('<Left>'):rep(vim.fn.strchars(option.close, true)))
    end,
  }
end

return setmetatable({
  ---@param option insx.recipe.auto_pair.Option
  strings = function(option)
    local overrides = { insx.with.nomatch([[\\\%#]]) }
    if option.open == [[']] then
      table.insert(overrides, insx.with.nomatch([[\a\%#]]))
    end
    return insx.with(auto_pair(option), overrides)
  end,
}, {
  ---@param option insx.recipe.auto_pair.Option
  __call = function(_, option)
    return auto_pair(option)
  end,
})
