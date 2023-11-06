local insx = require('insx')

---@class insx.recipe.fast_break.Option: insx.recipe.fast_break.html_attrs.Option, insx.recipe.fast_break.html_tags.Option, insx.recipe.fast_break.arguments.Option, insx.recipe.fast_break.basic.Option
---@field split? boolean # deprecated
---@field html_attrs? boolean
---@field html_tags? boolean
---@field arguments? boolean

---@param option insx.recipe.fast_break.Option
---@return insx.RecipeSource
local function fast_break(option)
  if option.split then
    vim.deprecate('fast_break option.split', 'option.html_attrs and option.arguments', '0', 'nvim-insx')
  end

  local recipes = {}

  table.insert(
    recipes,
    require('insx.recipe.fast_break.basic')({
      open_pat = option.open_pat,
      close_pat = option.close_pat,
      indent = option.indent,
    })
  )

  --- html_attrs
  if option.split or option.html_attrs then
    table.insert(recipes, require('insx.recipe.fast_break.html_attrs')({}))
  end

  --- html_tags
  if option.split or option.html_tags then
    table.insert(recipes, require('insx.recipe.fast_break.html_tags')({}))
  end

  --- arguments
  if option.split or option.arguments then
    table.insert(
      recipes,
      require('insx.recipe.fast_break.arguments')({
        open_pat = option.open_pat,
        close_pat = option.close_pat,
      })
    )
  end
  return insx.compose(recipes)
end

return fast_break
