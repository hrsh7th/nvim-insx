local kit = require('insx.kit')
local helper = require('insx.helper')
local RegExp = require('insx.kit.Vim.RegExp')

---@param pairwise_pat string[]
---@return boolean
local function is_pairwise(pairwise_pat)
  for _, pat in ipairs(pairwise_pat) do
    if helper.search.get_next([=[\%#\s*]=] .. pat) then
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

---@class insx.recipe.fast_wrap.Option
---@field public close string
---@field public pairwise_pat? string|string[]
---@field public next_pat? string[]

---@param option insx.recipe.fast_wrap.Option
---@return insx.RecipeSource
local function fast_wrap(option)
  local pairwise_pat = kit.to_array(option and option.pairwise_pat or {
    helper.search.Tag.Open,
    [=[[^[:blank:][[({]*\s*[[({]]=], -- function() or setup {} or Vec![]
    [=[\%(\<function\>\|\<func\>\|\<fn\>\)]=],
    [=[\%(\<if\>\|\<switch\>\|\<match\>\|\<for\>\|\<while\>\)]=],
  })
  local next_pat = kit.to_array(option and option.next_pat or {
    [=[\k\+\%(\.\k\+\)*\zs]=],
  })
  return {
    ---@param ctx insx.ActionContext
    action = function(ctx)
      ctx.send('<Del>')
      if not wrap_string(ctx) then
        if is_pairwise(pairwise_pat) then
          ctx.send({ '<C-o>', { keys = '%', remap = true }, '<Right>' })
        else
          local pos = { math.huge, math.huge }
          for _, pat in ipairs(next_pat) do
            local new_pos = helper.search.get_next(pat)
            if new_pos then
              if new_pos[1] < pos[1] or (new_pos[1] == pos[1] and new_pos[2] < pos[2]) then
                pos = new_pos
              end
            end
          end
          if pos[1] ~= math.huge then
            ctx.move(pos[1], pos[2])
          end
        end
      end
      ctx.send(option.close .. '<Left>')
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      return ctx.after():sub(1, 1) == option.close
    end,
  }
end

return fast_wrap
