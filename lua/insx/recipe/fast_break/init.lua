local insx = require('insx')

---@class insx.recipe.fast_break.Option
---@field public open_pat string
---@field public close_pat string
---@field public split? boolean

---@param option insx.recipe.fast_break.Option
---@return insx.RecipeSource
local function fast_break(option)
  return insx.compose({
    require('insx.recipe.fast_break.html_attrs')(option),
    require('insx.recipe.fast_break.arguments')(option),
    require('insx.recipe.fast_break.basic')(option),
  })
end

return fast_break
