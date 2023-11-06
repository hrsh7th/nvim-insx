local regex = {}

---@param s string
---@return string
function regex.esc(s)
  return [[\V]] .. vim.fn.escape(s, [[\]]) .. [[\m]]
end

---@param text string
---@param pattern string
---@return string?
function regex.match(text, pattern)
  local s, e = vim.regex(pattern):match_str(text)
  if s then
    return text:sub(s + 1, e)
  end
end

return regex
