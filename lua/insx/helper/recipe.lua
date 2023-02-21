local recipe = {}

---Create recipe exports.
---@generic T
---@param recipe T
---@param preset table<string, T>
---@return T|table<string, T>
function recipe.exports(recipe, preset)
  return setmetatable(preset, {
    __call = function(_, ...)
      return recipe(...)
    end,
  })
end

return recipe
