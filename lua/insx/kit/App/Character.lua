---@diagnostic disable: discard-returns

local Character = {}

---@type table<integer, string>
Character.alpha = {}
string.gsub('abcdefghijklmnopqrstuvwxyz', '.', function(char)
  Character.alpha[string.byte(char)] = char
end)

---@type table<integer, string>
Character.upper = {}
string.gsub('ABCDEFGHIJKLMNOPQRSTUVWXYZ', '.', function(char)
  Character.upper[string.byte(char)] = char
end)

---@type table<integer, string>
Character.digit = {}
string.gsub('1234567890', '.', function(char)
  Character.digit[string.byte(char)] = char
end)

---@type table<integer, string>
Character.white = {}
string.gsub(' \t\n', '.', function(char)
  Character.white[string.byte(char)] = char
end)

---Return specified byte is alpha or not.
---@param byte integer
---@return boolean
function Character.is_alpha(byte)
  return not not (Character.alpha[byte] ~= nil or (byte and Character.alpha[byte + 32] ~= nil))
end

---Return specified byte is digit or not.
---@param byte integer
---@return boolean
function Character.is_digit(byte)
  return Character.digit[byte] ~= nil
end

---Return specified byte is alpha or not.
---@param byte integer
---@return boolean
function Character.is_alnum(byte)
  return Character.is_alpha(byte) or Character.is_digit(byte)
end

---Return specified byte is alpha or not.
---@param byte integer
---@return boolean
function Character.is_upper(byte)
  return Character.upper[byte] ~= nil
end

---Return specified byte is alpha or not.
---@param byte integer
---@return boolean
function Character.is_lower(byte)
  return Character.alpha[byte] ~= nil
end

---Return specified byte is white or not.
---@param byte integer
---@return boolean
function Character.is_white(byte)
  return Character.white[byte] ~= nil
end

---Return specified byte is symbol or not.
---@param byte integer
---@return boolean
function Character.is_symbol(byte)
  return not Character.is_alnum(byte) and not Character.is_white(byte)
end

---@param a integer
---@param b integer
function Character.match_ignorecase(a, b)
  if a == b then
    return true
  elseif Character.is_alpha(a) and Character.is_alpha(b) then
    return (a == b + 32) or (a == b - 32)
  end
  return false
end

---@param text string
---@param index integer
---@return boolean
function Character.is_semantic_index(text, index)
  if index <= 1 then
    return true
  end

  local prev = string.byte(text, index - 1)
  local curr = string.byte(text, index)

  if not Character.is_upper(prev) and Character.is_upper(curr) then
    return true
  end
  if Character.is_symbol(curr) or Character.is_white(curr) then
    return true
  end
  if not Character.is_alpha(prev) and Character.is_alpha(curr) then
    return true
  end
  if not Character.is_digit(prev) and Character.is_digit(curr) then
    return true
  end
  return false
end

---@param text string
---@param current_index integer
---@return integer
function Character.get_next_semantic_index(text, current_index)
  for i = current_index + 1, #text do
    if Character.is_semantic_index(text, i) then
      return i
    end
  end
  return #text + 1
end

return Character
