local helper = require('insx.helper')

---The basic endwise recipe.
---This is early stage recipe so this can be modified in the future.

---Return pattern based enabled function.
---@param trigger_pattern string
---@param addition string
---@return insx.RecipeSource
local function simple(trigger_pattern, addition)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      local row, col = ctx.row(), ctx.col()
      ctx.send('<CR>' .. addition)
      ctx.move(row, col)
      ctx.send('<CR>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return not helper.syntax.in_string_or_comment() and helper.regex.match(ctx.before(), trigger_pattern) ~= nil
    end,
  }
end

---@alias insx.recipe.endwise.Option table<string, insx.RecipeSource[]>

---@param option insx.recipe.endwise.Option
---@return insx.RecipeSource
local function endwise(option)
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      local definitions = option[ctx.filetype] or {}
      if definitions then
        for _, definition in ipairs(definitions) do
          if definition.enabled(ctx) then
            return definition.action(ctx)
          end
        end
      else
        ctx.send(ctx.char)
      end
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      local definitions = option[ctx.filetype] or {}
      if definitions then
        for _, definition in ipairs(definitions) do
          if definition.enabled(ctx) then
            return true
          end
        end
      end
      return false
    end,
  }
end

return {
  recipe = endwise,
  simple = simple,
  builtin = {
    ['lua'] = {
      simple([[\<if\>.*\<then\>$]], 'end'),
      simple([[\<while\>.*\<do\>$]], 'end'),
      simple([[\<for\>.*\<do\>$]], 'end'),
      simple([[^\s*\<do\>$]], 'end'),
      simple([[\<repeat\>$]], 'until'),
      simple([[\<function\>\%(\s\+\k\+\%(:\k\+\)\?\)\?()$]], 'end'),
    },
    ['html'] = {
      {
        ---@param ctx insx.ActionContext
        action = function(ctx)
          local name = ctx.before():match('<(%a+)')
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
}
