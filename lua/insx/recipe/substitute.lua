---@class insx.recipe.substitute.Option
---@field pattern string
---@field replace string

---Expand text like snippet.
---@param option insx.recipe.substitute.Option
local function substitute(option)
  if not option.pattern:find([[\%#]], 1, true) then
    error("`pattern` must contain '%#'")
  end
  if not option.replace:find([[\%#]], 1, true) then
    error("`replace` must contain '%#'")
  end
  return {
    ---@param ctx insx.Context
    enabled = function(ctx)
      return ctx.match(option.pattern)
    end,
    ---@param ctx insx.Context
    action = function(ctx)
      local matches = assert(ctx.match(option.pattern))
      local replace = option.replace:gsub([[\%d]], function(p)
        return matches[tonumber(p:sub(2)) + 1]
      end)
      ctx.remove(option.pattern)

      local left, right = unpack(vim.split(replace, [[\%#]], { plain = true }))
      ctx.send(left)
      local row, col = ctx.row(), ctx.col()
      ctx.send(right)
      ctx.move(row, col)
    end,
  }
end

return substitute
