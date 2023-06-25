local position = {}

---@param a { [1]: integer, [2]: integer }
---@param b { [1]: integer, [2]: integer }
function position.lt(a, b)
  return a[1] < b[1] or (a[1] == b[1] and a[2] < b[2])
end

---@param a { [1]: integer, [2]: integer }
---@param b { [1]: integer, [2]: integer }
function position.lte(a, b)
  return a[1] < b[1] or (a[1] == b[1] and a[2] <= b[2])
end

---@param a { [1]: integer, [2]: integer }
---@param b { [1]: integer, [2]: integer }
function position.gt(a, b)
  return not position.lte(a, b)
end

---@param a { [1]: integer, [2]: integer }
---@param b { [1]: integer, [2]: integer }
function position.gte(a, b)
  return not position.lt(a, b)
end

return position
