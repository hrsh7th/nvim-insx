local helper = require('insx.helper')
local RegExp = require('insx.kit.Vim.RegExp')

---@param pos { [1]: integer, [2]: integer }
---@return string, integer, integer
local function get_space(pos)
  local text = vim.api.nvim_buf_get_lines(0, pos[1], pos[1] + 1, false)[1]
  ---@diagnostic disable-next-line: return-type-mismatch, missing-return-value
  return RegExp.extract_at(text, [[\s*]], pos[2] + 1)
end

---@param curr_space string
---@param pos { [1]: integer, [2]: integer }
local function sync_space(curr_space, pos)
  local _, s, e = get_space(pos)
  vim.api.nvim_buf_set_text(0, pos[1], s - 1, pos[1], e - 1, { curr_space })
end

---@class insx.recipe.pair_spacing.Option
---@field public open_pat string
---@field public close_pat string

---@param option insx.recipe.pair_spacing.Option
---@return insx.RecipeSource
local function increase(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      ctx.send(' ')

      local before_match = helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]])
      local after_match = helper.regex.match(ctx.after(), [[^\s*]] .. option.close_pat)
      if before_match and after_match then
        -- Logic for pairs & white only.
        local diff = #before_match - #after_match
        ctx.send((' '):rep(math.abs(diff)))
        if diff > 0 then
          ctx.send(('<Left>'):rep(math.abs(diff)))
        elseif diff < 0 then
          ctx.send(('<Right>'):rep(math.abs(diff)))
        end
      else
        -- Logic for separated pair.
        local pair_pos = helper.search.get_pair_close(option.open_pat, option.close_pat)
        if pair_pos then
          local row, col = ctx.row(), ctx.col()
          sync_space((get_space({ row, col })), pair_pos)
        end
      end
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return (helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]]) or helper.regex.match(ctx.after(), [[^\s*]] .. option.close_pat))
    end,
  }
end

---@param option insx.recipe.pair_spacing.Option
---@return insx.RecipeSource
local function decrease(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      ctx.send('<Left><Del>')

      local before_match = helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]])
      local after_match = helper.regex.match(ctx.after(), [[^\s*]] .. option.close_pat)
      if before_match and after_match then
        -- Logic for pairs & white only.
        local diff = #before_match - #after_match
        if diff > 0 then
          ctx.send(('<Left><Del>'):rep(math.abs(diff)))
        elseif diff < 0 then
          ctx.send(('<Del>'):rep(math.abs(diff)))
        end
      else
        -- Logic for separated pair.
        local pair_pos = helper.search.get_pair_close(option.open_pat, option.close_pat) or helper.search.get_pair_open(option.open_pat, option.close_pat)
        if pair_pos then
          local row, col = ctx.row(), ctx.col()
          sync_space((get_space({ row, col })), pair_pos)
        end
      end
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return (helper.regex.match(ctx.before(), option.open_pat .. [[\s*$]]) or helper.regex.match(ctx.after(), [[^\s*]] .. option.close_pat))
    end,
  }
end

return {
  increase = increase,
  decrease = decrease,
}
