local Syntax = require('minx.kit.Vim.Syntax')

local syntax = {}

---@param searching? boolean
---@return boolean
function syntax.in_string_or_comment(searching)
  local cursor = vim.api.nvim_win_get_cursor(0)
  cursor[1] = cursor[1] - 1
  if not searching then
    cursor[2] = cursor[2] - 1
  end
  for _, group in ipairs(Syntax.get_syntax_groups(cursor)) do
    local match = false
    match = match or (group:lower():match('^comment'))
    match = match or (group:lower():match('comment$'))
    match = match or (group:lower():match('^string'))
    match = match or (group:lower():match('string$'))
    if match ~= nil then
      return true
    end
  end
  return false
end

---@param cursor { [1]: integer, [2]: integer }
---@return boolean
function syntax.in_string_or_comment_at_pos(cursor)
  for _, group in ipairs(Syntax.get_syntax_groups(cursor)) do
    local match = false
    match = match or (group:lower():match('^comment'))
    match = match or (group:lower():match('comment$'))
    match = match or (group:lower():match('^string'))
    match = match or (group:lower():match('string$'))
    if match ~= nil then
      return true
    end
  end
  return false
end

return syntax
