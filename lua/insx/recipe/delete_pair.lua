local kit = require('insx.kit')
local helper = require('insx.helper')

---@class insx.recipe.delete_pair.Option
---@field public open_pat string
---@field public close_pat string
---@field public ignore_pat? string|string[]

---@param option insx.recipe.delete_pair.Option
---@return insx.RecipeSource
local function delete_pair(option)
  local ignore_pat = kit.to_array(option and option.ignore_pat or {})
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      local row, col = ctx.row(), ctx.col()
      local close_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
      if close_pos and close_pos[1] == row then
        ctx.move(close_pos[1], close_pos[2])
        local close_text = helper.regex.match(ctx.after(), [[^]] .. option.close_pat)
        ctx.send(('<Del>'):rep(vim.fn.strchars(close_text, true)))

        ctx.move(row, col)
        local open_text = helper.regex.match(ctx.before(), option.open_pat .. [[$]])
        ctx.send(('<Left><Del>'):rep(vim.fn.strchars(open_text, true)))
      elseif helper.regex.match(ctx.before(), option.open_pat .. '$') and helper.regex.match(ctx.after(), '^' .. option.close_pat) then
        ctx.send('<BS><Del>')
      else
        ctx.send(ctx.char)
      end
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      for _, pat in ipairs(ignore_pat) do
        if ctx.match(pat) then
          return false
        end
      end
      return helper.regex.match(ctx.before(), option.open_pat .. '$')
    end,
  }
end

return delete_pair
