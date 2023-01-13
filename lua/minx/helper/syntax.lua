local Syntax = require('minx.kit.Vim.Syntax')

local syntax = {}

---@return boolean
function syntax.in_string_or_comment()
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[1] = cursor[1] - 1
  cursor[2] = cursor[2]
  return syntax.in_string_or_comment_at_pos({ cursor[1], cursor[2] - 1 }) and syntax.in_string_or_comment_at_pos(cursor)
end

---@param cursor { [1]: integer, [2]: integer }
---@return boolean
function syntax.in_string_or_comment_at_pos(cursor)
  for _, group in ipairs(Syntax.get_syntax_groups({ cursor[1], cursor[2] })) do
    local match = false
    match = match or (group:lower():match('comment'))
    match = match or (group:lower():match('string'))
    if match ~= nil then
      return true
    end
  end
  return false
end

return syntax
