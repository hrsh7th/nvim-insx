local insx = require('insx')

---@class insx.recipe.auto_pair.Option
---@field public open string
---@field public close string

---@param option insx.recipe.auto_pair.Option
---@return insx.RecipeSource
local function auto_pair(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      ctx.send(option.open .. option.close .. '<Left>')
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
  end
}, {
  ---@param option insx.recipe.auto_pair.Option
  __call = function(_, option)
    return auto_pair(option)
  end
})
