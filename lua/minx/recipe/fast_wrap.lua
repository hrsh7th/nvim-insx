local helper = require('minx.helper')
local RegExp = require('minx.kit.Vim.RegExp')

---@param option minx.recipe.fast_wrap.Option
---@return boolean
local function is_pairwise(option)
  for _, pattern in ipairs(option.pairwise_patterns) do
    local pos = vim.fn.searchpos([=[\%#\s*]=] .. pattern, 'Wznc')
    if pos[1] ~= 0 then
      return true
    end
  end
  return false
end

---Special handling for strings.
---@return boolean
local function wrap_string(ctx)
  if helper.syntax.in_string_or_comment() then
    return false
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local _, _, e = RegExp.extract_at(vim.api.nvim_get_current_line(), [[\s*]], col + 1)
  if not e then
    return false
  end

  local cursor = { row - 1, e - 1 }
  if not helper.syntax.in_string_or_comment_at_pos(cursor) then
    return false
  end

  local found = false
  while true do
    local text = vim.api.nvim_buf_get_lines(0, cursor[1], cursor[1] + 1, false)[1]
    for i = cursor[2] + 1, #text do
      cursor[2] = i
      if not helper.syntax.in_string_or_comment_at_pos(cursor) then
        found = true
        break
      end
    end
    if found then
      break
    end
    cursor[1] = cursor[1] + 1
    cursor[2] = 0
  end
  if found then
    ctx.move(cursor[1], cursor[2])
    return true
  end
  return false
end

---@class minx.recipe.fast_wrap.Option
---@field public close string
---@field public pairwise_patterns? string[]

---@param option minx.recipe.fast_wrap.Option
---@return minx.RecipeSource
local function fast_wrap(option)
  option = option or {}
  option.pairwise_patterns = option.pairwise_patterns or {
    helper.search.Tag.Open,
    [=[[^[:blank:][[({]*\s*[[({]]=], -- function() or setup {} or Vec![]
    [=[\%(\<function\>\|\<func\>\|\<fn\>\)]=],
    [=[\%(\<if\>\|\<switch\>\|\<match\>\|\<for\>\|\<while\>\)]=],
  }
  return {
    ---@param ctx minx.ActionContext
    action = function(ctx)
      ctx.send('<Del>')
      if not wrap_string(ctx) then
        if is_pairwise(option) then
          ctx.send({ '<C-o>', { keys = '%', remap = true }, '<Right>' })
        else
          local pos = helper.search.get_next([[\k\+\zs]])
          if pos then
            ctx.move(pos[1], pos[2])
          end
        end
      end
      ctx.send(option.close .. '<Left>')
    end,
    ---@param ctx minx.Context
    enabled = function(ctx)
      return ctx.after():sub(1, 1) == option.close
    end,
  }
end

return fast_wrap
