local helper = require('insx.helper')
local insx = require('insx')

---The basic endwise recipe.
---This is early stage recipe so this can be modified in the future.

---Return pattern based enabled function.
---@param trigger_pattern string
---@param addition string
---@return insx.RecipeSource
local function simple(trigger_pattern, addition)
  return insx.with({
    ---@param ctx insx.Context
    action = function(ctx)
      local row, col = ctx.row(), ctx.col()
      ctx.send('<CR>' .. addition)
      ctx.move(row, col)
      ctx.send('<CR>')
    end,
    ---@param ctx insx.ContextSource
    enabled = function(ctx)
      if trigger_pattern:match('%$$') then
        vim.deprecate('endwise.simple\' trigger_pattern', 'remove `$` from regexp', '0', 'nvim-insx')
        trigger_pattern = trigger_pattern:gsub('%$$', '')
      end
      return ctx.match(trigger_pattern .. [[\%#]])
    end
  }, insx.with.in_string(false), insx.with.in_comment(false))
end

---@alias insx.recipe.endwise.Option table<string, insx.RecipeSource[]>

---@param option insx.recipe.endwise.Option
---@return insx.RecipeSource[]
local function endwise(option)
  local recipe_sources = {}
  for filetype, recipe_sources_ in pairs(option) do
    for _, recipe_source in ipairs(recipe_sources_) do
      table.insert(recipe_sources, insx.with(
        recipe_source,
        insx.with.filetype(filetype)
      ))
    end
  end
  return insx.compose(recipe_sources)
end

return setmetatable({
  simple = simple,
  builtin = {
    ['lua'] = {
      simple([[\<if\>.*\<then\>]], 'end'),
      simple([[\<while\>.*\<do\>]], 'end'),
      simple([[\<for\>.*\<do\>]], 'end'),
      simple([[^\s*\<do\>]], 'end'),
      simple([[\<repeat\>]], 'until'),
      simple([[\<function\>\%(\s\+\k\+\%(:\k\+\)\?\)\?()]], 'end'),
    },
    ['html'] = {
      {
        ---@param ctx insx.Context
        action = function(ctx)
          local name = ctx.before():match('<(%w+)')
          local row, col = ctx.row(), ctx.col()
          ctx.send('<CR>' .. ([[</%s>]]):format(name))
          ctx.move(row, col)
          ctx.send('<CR>')
        end,
        ---@param ctx insx.Context
        enabled = function(ctx)
          return helper.regex.match(ctx.before(), helper.search.Tag.Open) ~= nil and helper.regex.match(ctx.after(), helper.search.Tag.Close) == nil
        end,
      },
    },
  },
  ---@param option insx.recipe.endwise.Option
  ---@return insx.RecipeSource[]
  recipe = function(option)
    vim.deprecate('endwise.recipe', 'endwise()', '0', 'nvim-insx')
    return endwise(option)
  end,
}, {
  ---@param option insx.recipe.endwise.Option
  ---@return insx.RecipeSource[]
  __call = function(_, option)
    return endwise(option)
  end
})
