-- luacheck: ignore 512

local kit = {}

---Create gabage collection detector.
---@param callback fun(...: any): any
---@return userdata
function kit.gc(callback)
  local gc = newproxy(true)
  if vim.is_thread() or os.getenv('NODE_ENV') == 'test' then
    getmetatable(gc).__gc = callback
  else
    getmetatable(gc).__gc = vim.schedule_wrap(callback)
  end
  return gc
end

---Find up directory.
---@param path string
---@param markers string[]
function kit.findup(path, markers)
  path = vim.fs.normalize(path)
  if vim.fn.filereadable(path) == 1 then
    path = vim.fs.dirname(path)
  end
  while path ~= '/' do
    for _, marker in ipairs(markers) do
      local target = vim.fs.joinpath(path, (marker:gsub('/', '')))
      if marker:match('/$') and vim.fn.isdirectory(target) == 1 then
        return path
      elseif vim.fn.filereadable(target) == 1 then
        return path
      end
    end
    path = vim.fs.dirname(path)
  end
end

---Create debounced callback.
---@generic T: fun(...: any): nil
---@param callback T
---@param ms integer
---@return T
function kit.debounce(callback, ms)
  local timer = assert(vim.uv.new_timer())
  return function(...)
    local arguments = { ... }

    timer:stop()
    timer:start(ms, 0, function()
      timer:stop()
      callback(unpack(arguments))
    end)
  end
end

---Create throttled callback.
---@generic T: fun(...: any): nil
---@param callback T
---@param throttle_ms integer
function kit.throttle(callback, throttle_ms)
  local timer = assert(vim.uv.new_timer())
  local arguments = nil
  local last_time = vim.uv.now() - throttle_ms
  return setmetatable({
    throttle_ms = throttle_ms,
  }, {
    __call = function(self, ...)
      arguments = { ... }

      local timeout_ms = self.throttle_ms - (vim.uv.now() - last_time)
      if timeout_ms <= 0 then
        timer:stop()
        callback(unpack(arguments))
        last_time = vim.uv.now()
      else
        timer:stop()
        timer:start(timeout_ms, 0, function()
          timer:stop()
          callback(unpack(arguments))
          last_time = vim.uv.now()
        end)
      end
    end,
  })
end

---Clear list
---@generic T
---@param tbl T[]
---@return T[]
function kit.clear(tbl)
  if not tbl then
    return {}
  end

  for k in pairs(tbl) do
    tbl[k] = nil
  end
  return tbl
end

do
  local mpack = require('mpack')

  local MpackFunctionType = {}
  MpackFunctionType.__index = MpackFunctionType

  kit.Packer = mpack.Packer({
    ext = {
      [MpackFunctionType] = function(data)
        return 5, string.dump(data.fn)
      end,
    },
  })

  kit.Unpacker = mpack.Unpacker({
    ext = {
      [5] = function(_, data)
        return loadstring(data)
      end,
    },
  })

  ---Serialize object like values.
  ---@param target any
  ---@return string
  function kit.pack(target)
    if type(target) == 'nil' then
      return kit.Packer(mpack.NIL)
    end
    if type(target) == 'table' then
      local copy = kit.clone(target)
      kit.traverse(copy, function(v, parent, path)
        if type(v) == 'function' then
          if parent == nil then
            error('The root value cannot be a function.')
          end
          kit.set(parent, path, setmetatable({ fn = v }, MpackFunctionType))
        end
      end)
      return kit.Packer(copy)
    end
    return kit.Packer(target)
  end

  ---Deserialize object like values.
  ---@param target string
  ---@return any
  function kit.unpack(target)
    return kit.Unpacker(target)
  end
end

---Bind arguments for function.
---@param fn fun(...: any): any
---@vararg any
---@return fun(...: any): any
function kit.bind(fn, ...)
  local args = { ... }
  return function(...)
    return fn(unpack(args), ...)
  end
end

---Safe version of vim.schedule.
---@param fn fun(...: any): any
function kit.safe_schedule(fn)
  if vim.is_thread() then
    fn()
  else
    vim.schedule(fn)
  end
end

---Safe version of vim.schedule_wrap.
---@param fn fun(...: any): any
function kit.safe_schedule_wrap(fn)
  if vim.is_thread() then
    return fn
  else
    return vim.schedule_wrap(fn)
  end
end

---Traverse object tree.
---@param root_node any
---@param root_callback fun(v: any, parent: table, path: string[])
function kit.traverse(root_node, root_callback)
  local function traverse(node, callback, parent, path)
    if type(node) == 'table' then
      for k, v in pairs(node) do
        traverse(v, callback, node, kit.concat(path, { k }))
      end
    else
      callback(node, parent, path)
    end
  end
  traverse(root_node, root_callback, nil, {})
end

---Create unique id.
---@return integer
kit.unique_id = setmetatable({
  unique_id = 0,
}, {
  __call = function(self)
    self.unique_id = self.unique_id + 1
    return self.unique_id
  end,
})

do
  ---@generic T
  ---@param target T
  ---@param seen table<any, any>
  ---@return T
  local function do_clone(target, seen)
    if type(target) ~= 'table' then
      return target
    end
    if seen[target] then
      return seen[target]
    end
    if kit.is_array(target) then
      local new_tbl = {}
      setmetatable(new_tbl, getmetatable(target))
      seen[target] = new_tbl
      for k, v in ipairs(target) do
        new_tbl[k] = do_clone(v, seen)
      end
      return new_tbl
    else
      local new_tbl = {}
      setmetatable(new_tbl, getmetatable(target))
      seen[target] = new_tbl
      for k, v in pairs(target) do
        new_tbl[k] = do_clone(v, seen)
      end
      return new_tbl
    end
  end

  ---Clone object.
  ---@generic T
  ---@param target T
  ---@return T
  function kit.clone(target)
    return do_clone(target, {})
  end
end

---Merge two tables.
---@generic T: any[]
---NOTE: This doesn't merge array-like table.
---@param tbl1 T
---@param tbl2 T
---@return T
function kit.merge(tbl1, tbl2)
  local is_dict1 = kit.is_dict(tbl1)
  local is_dict2 = kit.is_dict(tbl2)
  if is_dict1 and is_dict2 then
    local new_tbl = {}
    setmetatable(new_tbl, getmetatable(tbl1))

    for k, v in pairs(tbl2) do
      if tbl1[k] ~= vim.NIL then
        new_tbl[k] = kit.merge(tbl1[k], v)
      end
    end
    for k, v in pairs(tbl1) do
      if tbl2[k] == nil then
        if v ~= vim.NIL then
          new_tbl[k] = kit.merge(v, {})
        else
          new_tbl[k] = nil
        end
      end
    end
    return new_tbl
  end

  if tbl1 == vim.NIL then
    return nil
  elseif tbl1 == nil then
    return kit.clone(tbl2)
  else
    return kit.clone(tbl1)
  end
end

---Map array.
---@param array table
---@param fn fun(item: unknown, index: integer): unknown
---@return unknown[]
function kit.map(array, fn)
  local new_array = {}
  for i, item in ipairs(array) do
    table.insert(new_array, fn(item, i))
  end
  return new_array
end

---Concatenate two tables.
---NOTE: This doesn't concatenate dict-like table.
---@param tbl1 table
---@param tbl2 table
---@return table
function kit.concat(tbl1, tbl2)
  local new_tbl = {}
  for _, item in ipairs(tbl1) do
    table.insert(new_tbl, item)
  end
  for _, item in ipairs(tbl2) do
    table.insert(new_tbl, item)
  end
  return new_tbl
end

---Return true if v is contained in array.
---@param array any[]
---@param v any
---@return boolean
function kit.contains(array, v)
  for _, item in ipairs(array) do
    if item == v then
      return true
    end
  end
  return false
end

---Slice the array.
---@generic T: any[]
---@param array T
---@param s integer
---@param e integer
---@return T
function kit.slice(array, s, e)
  if not kit.is_array(array) then
    error('[kit] specified value is not an array.')
  end
  local new_array = {}
  for i = s, e do
    table.insert(new_array, array[i])
  end
  return new_array
end

---The value to array.
---@param value any
---@return table
function kit.to_array(value)
  if type(value) == 'table' then
    if kit.is_array(value) then
      return value
    end
  end
  return { value }
end

---Check the value is array.
---@param value any
---@return boolean
function kit.is_array(value)
  if type(value) ~= 'table' then
    return false
  end
  for k, _ in pairs(value) do
    if type(k) ~= 'number' then
      return false
    end
  end
  return true
end

---Check the value is dict.
---@param value any
---@return boolean
function kit.is_dict(value)
  return type(value) == 'table' and (not kit.is_array(value) or kit.is_empty(value))
end

---Check the value is empty.
---@param value any
---@return boolean
function kit.is_empty(value)
  if type(value) ~= 'table' then
    return false
  end
  if #value == 0 then
    return true
  end
  for _ in pairs(value) do
    return false
  end
  return true
end

---Reverse the array.
---@param array table
---@return table
function kit.reverse(array)
  if not kit.is_array(array) then
    error('[kit] specified value is not an array.')
  end

  local new_array = {}
  for i = #array, 1, -1 do
    table.insert(new_array, array[i])
  end
  return new_array
end

---@generic T
---@param value T?
---@param default T
function kit.default(value, default)
  if value == nil then
    return default
  end
  return value
end

---Get object path with default value.
---@generic T
---@param value table
---@param path integer|string|(string|integer)[]
---@param default? T
---@return T
function kit.get(value, path, default)
  local result = value
  for _, key in ipairs(kit.to_array(path)) do
    if type(result) == 'table' then
      result = result[key]
    else
      return default
    end
  end
  if result == nil then
    return default
  end
  return result
end

---Set object path with new value.
---@param value table
---@param path integer|string|(string|integer)[]
---@param new_value any
function kit.set(value, path, new_value)
  local current = value
  for i = 1, #path - 1 do
    local key = path[i]
    if type(current[key]) ~= 'table' then
      error('The specified path is not a table.')
    end
    current = current[key]
  end
  current[path[#path]] = new_value
end

---String dedent.
function kit.dedent(s)
  local lines = vim.split(s, '\n')
  if lines[1]:match('^%s*$') then
    table.remove(lines, 1)
  end
  if lines[#lines]:match('^%s*$') then
    table.remove(lines, #lines)
  end
  local base_indent = lines[1]:match('^%s*')
  for i, line in ipairs(lines) do
    lines[i] = line:gsub('^' .. base_indent, '')
  end
  return table.concat(lines, '\n')
end

return kit
