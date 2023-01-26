local Syntax = require('insx.kit.Vim.Syntax')

local syntax = {}

---@return boolean
function syntax.in_string_or_comment()
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[1] = cursor[1] - 1
  return syntax.in_string_or_comment_at_pos(cursor)
end

---@param cursor { [1]: integer, [2]: integer }
---@return boolean
function syntax.in_string_or_comment_at_pos(cursor)
  return syntax.in_string_at_pos(cursor) or syntax.in_comment_at_pos(cursor)
end

---@param cursor { [1]: integer, [2]: integer }
---@return boolean
function syntax.in_string_at_pos(cursor)
  cursor = { cursor[1], cursor[2] }

  local groups = {}
  for _, group in ipairs(Syntax.get_syntax_groups(cursor)) do
    if group:lower():match('string') then
      groups[group] = true
    end
  end
  if #vim.tbl_keys(groups) == 0 then
    return false
  end

  for _, group in ipairs(Syntax.get_syntax_groups({ cursor[1], cursor[2] - 1 })) do
    if groups[group] then
      return true
    end
  end
  return false
end

---@param cursor { [1]: integer, [2]: integer }
---@return boolean
function syntax.in_comment_at_pos(cursor)
  for _, group in ipairs(Syntax.get_syntax_groups({ cursor[1], cursor[2] - 1 })) do
    if group:lower():match('comment') then
      return true
    end
  end
  return false
end

return syntax
