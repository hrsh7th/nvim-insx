---@class insx.recipe.snippet.Option
---@field pattern string
---@field content string

---@class insx.recipe.snippet.ExpandParams
---@field content string

---Expand text like snippet.
local snippet
snippet = setmetatable({
  ---@param params insx.recipe.snippet.ExpandParams
  expand = function(params)
    error([[You must set `require('insx.recipe.snippet').expand = ...`]])
  end
}, {
  ---@param option insx.recipe.snippet.Option
  __call = function(_, option)
    if not option.pattern:find([[\%#]], 1, true) then
      error("`pattern` must contain '%#'")
    end
    return {
      ---@param ctx insx.Context
      enabled = function(ctx)
        return ctx.match(option.pattern)
      end,
      ---@param ctx insx.Context
      action = function(ctx)
        local matches = assert(ctx.match(option.pattern))
        local content = option.content:gsub('\\t', '\t'):gsub([[\%d]], function(p)
          local m = matches[tonumber(p:sub(2)) + 1] or ''
          m = vim.fn.escape(m, [[$\]])
          return m
        end)
        ctx.remove(option.pattern)

        snippet.expand({ content = content })
      end,
    }
  end
})

return snippet

