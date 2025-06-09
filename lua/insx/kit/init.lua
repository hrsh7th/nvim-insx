-- luacheck: ignore 512

---@class insx.kit.buffer.Buffer
---@field put fun(data: string)
---@field get fun(byte_size?: integer): string
---@field len integer
---@field skip fun(byte_size: integer)
---@field peek fun(index: integer): integer?
---@field clear fun()
---@field reserve fun(byte_size: integer)
---@field iter_bytes fun(): fun(): integer, integer

local kit = {}

do
  local buffer = package.preload['string.buffer'] and require('string.buffer')
  if buffer then
    ---Create buffer object.
    ---@return insx.kit.buffer.Buffer
    function kit.buffer_jit()
      local buf = buffer.new()
      local ptr, len = buf:ref()
      ---@type insx.kit.buffer.Buffer
      return setmetatable({
        put = function(data)
          buf:put(data)
          ptr, len = buf:ref()
        end,
        get = function(byte_size)
          local o = buf:get(byte_size)
          ptr, len = buf:ref()
          return o
        end,
        len = function()
          return len
        end,
        skip = function(byte_size)
          buf:skip(byte_size)
          ptr, len = buf:ref()
        end,
        clear = function()
          buf:reset()
          ptr, len = buf:ref()
        end,
        peek = function(index)
          if index < 1 or index > len then
            return nil
          end
          return ptr[index - 1]
        end,
        reserve = function(byte_size)
          buf:reserve(byte_size)
        end,
        iter_bytes = function()
          local i = 0
          return function()
            if i < len then
              local byte = ptr[i]
              i = i + 1
              return i, byte
            end
          end
        end,
      }, {
        __tostring = function()
          return buf:tostring()
        end,
      })
    end
  end
end

---Create buffer object.
---@return insx.kit.buffer.Buffer
function kit.buffer_tbl()
  local tmp_get = {}
  local buf = {}
  ---@type insx.kit.buffer.Buffer
  local buffer
  buffer = setmetatable({
    put = function(data)
      table.insert(buf, data)
    end,
    get = function(byte_size)
      if byte_size == nil then
        local data = table.concat(buf, '')
        kit.clear(buf)
        return data
      end
      if byte_size == 0 then
        return ''
      end

      kit.clear(tmp_get)
      local off = 0
      local i = 1
      while i <= #buf do
        local b = buf[i]
        if off + #b >= byte_size then
          local data_size = byte_size - off
          if #b <= data_size then
            table.insert(tmp_get, b)
            table.remove(buf, i)
          else
            table.insert(tmp_get, b:sub(1, data_size))
            buf[i] = b:sub(data_size + 1)
          end
          break
        end
        i = i + 1
        off = off + #b
      end
      return table.concat(tmp_get, '')
    end,
    len = function()
      local len = 0
      for _, data in ipairs(buf) do
        len = len + #data
      end
      return len
    end,
    skip = function(byte_size)
      buffer.get(byte_size)
    end,
    peek = function(index)
      local i = 1
      while i <= #buf do
        if index <= #buf[i] then
          return buf[i]:byte(index)
        end
        index = index - #buf[i]
        i = i + 1
      end
    end,
    clear = function()
      kit.clear(buf)
    end,
    reserve = function()
      -- noop
    end,
    iter_bytes = function()
      local i = 1
      local j = 1
      local c = 1
      return function()
        while i <= #buf do
          local data = buf[i]
          if j <= #data then
            local byte = data:byte(j)
            j = j + 1
            c = c + 1
            return (c - 1), byte
          end
          i = i + 1
          j = 1
        end
        return nil
      end
    end,
  }, {
    __tostring = function()
      return table.concat(buf)
    end,
  })
  return buffer
end

---Create buffer object.
---@return insx.kit.buffer.Buffer
kit.buffer = function()
  return kit.buffer_jit and kit.buffer_jit() or kit.buffer_tbl()
end

do
  local clear = package.preload['table.clear'] and require('table.clear')

  ---Clear table.
  ---@generic T: table
  ---@param tbl T
  ---@return T
  kit.clear = function(tbl)
    if type(tbl) ~= 'table' then
      return tbl
    end
    if clear then
      clear(tbl)
    else
      for k, _ in pairs(tbl) do
        tbl[k] = nil
      end
    end
    return tbl
  end
end

---Check shallow equals.
---@param a any
---@param b any
---@return boolean
function kit.shallow_equals(a, b)
  if type(a) ~= type(b) then
    return false
  end
  if type(a) ~= 'table' then
    return a == b
  end
  for k, v in pairs(a) do
    if v ~= b[k] then
      return false
    end
  end
  for k, v in pairs(b) do
    if v ~= a[k] then
      return false
    end
  end
  return true
end

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

---Safe version of vim.schedule.
---@param fn fun(...: any): any
function kit.safe_schedule(fn)
  if vim.is_thread() then
    local timer = assert(vim.uv.new_timer())
    timer:start(0, 0, function()
      timer:stop()
      timer:close()
      fn()
    end)
  else
    vim.schedule(fn)
  end
end

---Safe version of vim.schedule_wrap.
---@param fn fun(...: any): any
function kit.safe_schedule_wrap(fn)
  if vim.is_thread() then
    return function(...)
      local args = { ... }
      local timer = assert(vim.uv.new_timer())
      timer:start(0, 0, function()
        timer:stop()
        timer:close()
        fn(unpack(args))
      end)
    end
  else
    return vim.schedule_wrap(fn)
  end
end

---Fast version of vim.schedule.
---@param fn fun(): any
function kit.fast_schedule(fn)
  if vim.in_fast_event() then
    kit.safe_schedule(fn)
  else
    fn()
  end
end

---Safe version of vim.schedule_wrap.
---@generic A
---@param fn fun(...: A)
---@return fun(...: A)
function kit.fast_schedule_wrap(fn)
  return function(...)
    local args = { ... }
    kit.fast_schedule(function()
      fn(unpack(args))
    end)
  end
end

---Find up directory.
---@param path string
---@param markers string[]
---@return string?
function kit.findup(path, markers)
  path = vim.fs.normalize(path)
  if vim.fn.filereadable(path) == 1 then
    path = vim.fs.dirname(path)
  end
  while path ~= '/' do
    for _, marker in ipairs(markers) do
      local target = vim.fs.joinpath(path, (marker:gsub('/', '')))
      if vim.fn.isdirectory(target) == 1 or vim.fn.filereadable(target) == 1 then
        return path
      end
    end
    path = vim.fs.dirname(path)
  end
end

do
  _G.kit = _G.kit or {}
  _G.kit.unique_id = 0

  ---Create unique id.
  ---@return integer
  kit.unique_id = function()
    _G.kit.unique_id = _G.kit.unique_id + 1
    return _G.kit.unique_id
  end
end

---Map array.
---@deprecated
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

---@generic T
---@deprecated
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

---Create debounced callback.
---@generic T: fun(...: any): nil
---@param callback T
---@param timeout_ms integer
---@return T
function kit.debounce(callback, timeout_ms)
  local timer = require('insx.kit.Async.ScheduledTimer').new()
  return setmetatable({
    timeout_ms = timeout_ms,
    is_running = function()
      return timer:is_running()
    end,
    stop = function()
      timer:stop()
    end,
  }, {
    __call = function(self, ...)
      local arguments = { ... }

      self.running = true
      timer:stop()
      timer:start(self.timeout_ms, 0, function()
        self.running = false
        timer:stop()
        callback(unpack(arguments))
      end)
    end,
  })
end

---Create throttled callback.
---First call will be called immediately.
---@generic T: fun(...: any): nil
---@param callback T
---@param timeout_ms integer
function kit.throttle(callback, timeout_ms)
  local timer = require('insx.kit.Async.ScheduledTimer').new()
  local arguments = nil
  local last_time = (vim.uv.hrtime() / 1000000) - timeout_ms - 1
  return setmetatable({
    timeout_ms = timeout_ms,
    is_running = function()
      return timer:is_running()
    end,
    stop = function()
      timer:stop()
    end,
  }, {
    __call = function(self, ...)
      arguments = { ... }

      if self.is_running() then
        timer:stop()
      end
      local delay_ms = self.timeout_ms - ((vim.uv.hrtime() / 1000000) - last_time)
      if delay_ms > 0 then
        timer:start(delay_ms, 0, function()
          timer:stop()
          last_time = (vim.uv.hrtime() / 1000000)
          callback(unpack(arguments))
        end)
      else
        last_time = (vim.uv.hrtime() / 1000000)
        callback(unpack(arguments))
      end
    end,
  })
end

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
      seen[target] = new_tbl
      for k, v in ipairs(target) do
        new_tbl[k] = do_clone(v, seen)
      end
      return new_tbl
    else
      local new_tbl = {}
      local meta = getmetatable(target)
      if meta then
        setmetatable(new_tbl, meta)
      end
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
  local is_dict1 = kit.is_dict(tbl1) and getmetatable(tbl1) == nil
  local is_dict2 = kit.is_dict(tbl2) and getmetatable(tbl2) == nil
  if is_dict1 and is_dict2 then
    local new_tbl = {}
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

  -- premitive like values.
  if tbl1 == vim.NIL then
    return nil
  elseif tbl1 == nil then
    return kit.merge(tbl2, {}) -- clone & prevent vim.NIL
  end
  return tbl1
end

---Concatenate two tables.
---NOTE: This doesn't concatenate dict-like table.
---@param tbl1 table
---@param ... table
---@return table
function kit.concat(tbl1, ...)
  local new_tbl = {}

  local off = 0
  for _, item in pairs(tbl1) do
    new_tbl[off + 1] = item
    off = off + 1
  end

  for _, tbl2 in ipairs({ ... }) do
    for _, item in pairs(kit.to_array(tbl2)) do
      new_tbl[off + 1] = item
      off = off + 1
    end
  end
  return new_tbl
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
  for _ in pairs(value) do
    return false
  end
  if #value == 0 then
    return true
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
