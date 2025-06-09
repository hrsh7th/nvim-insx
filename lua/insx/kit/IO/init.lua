local uv = vim.uv
local Async = require('insx.kit.Async')

local bytes = {
  backslash = string.byte('\\'),
  slash = string.byte('/'),
  tilde = string.byte('~'),
  dot = string.byte('.'),
}

---@param path string
---@return string
local function sep(path)
  for i = 1, #path do
    local c = path:byte(i)
    if c == bytes.slash then
      return path
    end
    if c == bytes.backslash then
      return (path:gsub('\\', '/'))
    end
  end
  return path
end

local home = sep(assert(vim.uv.os_homedir()))

---@see https://github.com/luvit/luvit/blob/master/deps/fs.lua
local IO = {}

---@class insx.kit.IO.UV.Stat
---@field public dev integer
---@field public mode integer
---@field public nlink integer
---@field public uid integer
---@field public gid integer
---@field public rdev integer
---@field public ino integer
---@field public size integer
---@field public blksize integer
---@field public blocks integer
---@field public flags integer
---@field public gen integer
---@field public atime { sec: integer, nsec: integer }
---@field public mtime { sec: integer, nsec: integer }
---@field public ctime { sec: integer, nsec: integer }
---@field public birthtime { sec: integer, nsec: integer }
---@field public type string

---@enum insx.kit.IO.UV.AccessMode
IO.AccessMode = {
  r = 'r',
  rs = 'rs',
  sr = 'sr',
  ['r+'] = 'r+',
  ['rs+'] = 'rs+',
  ['sr+'] = 'sr+',
  w = 'w',
  wx = 'wx',
  xw = 'xw',
  ['w+'] = 'w+',
  ['wx+'] = 'wx+',
  ['xw+'] = 'xw+',
  a = 'a',
  ax = 'ax',
  xa = 'xa',
  ['a+'] = 'a+',
  ['ax+'] = 'ax+',
  ['xa+'] = 'xa+',
}

---@enum insx.kit.IO.WalkStatus
IO.WalkStatus = {
  SkipDir = 1,
  Break = 2,
}

---@type fun(path: string): insx.kit.Async.AsyncTask
local uv_fs_stat = Async.promisify(uv.fs_stat)

---@type fun(path: string): insx.kit.Async.AsyncTask
local uv_fs_unlink = Async.promisify(uv.fs_unlink)

---@type fun(path: string): insx.kit.Async.AsyncTask
local uv_fs_rmdir = Async.promisify(uv.fs_rmdir)

---@type fun(path: string, mode: integer): insx.kit.Async.AsyncTask
local uv_fs_mkdir = Async.promisify(uv.fs_mkdir)

---@type fun(from: string, to: string, option?: { excl?: boolean, ficlone?: boolean, ficlone_force?: boolean }): insx.kit.Async.AsyncTask
local uv_fs_copyfile = Async.promisify(uv.fs_copyfile)

---@type fun(path: string, flags: insx.kit.IO.UV.AccessMode, mode: integer): insx.kit.Async.AsyncTask
local uv_fs_open = Async.promisify(uv.fs_open)

---@type fun(fd: userdata): insx.kit.Async.AsyncTask
local uv_fs_close = Async.promisify(uv.fs_close)

---@type fun(fd: userdata, chunk_size: integer, offset?: integer): insx.kit.Async.AsyncTask
local uv_fs_read = Async.promisify(uv.fs_read)

---@type fun(fd: userdata, content: string, offset?: integer): insx.kit.Async.AsyncTask
local uv_fs_write = Async.promisify(uv.fs_write)

---@type fun(fd: userdata, offset: integer): insx.kit.Async.AsyncTask
local uv_fs_ftruncate = Async.promisify(uv.fs_ftruncate)

---@type fun(path: string): insx.kit.Async.AsyncTask
local uv_fs_scandir = Async.promisify(uv.fs_scandir)

---@type fun(path: string): insx.kit.Async.AsyncTask
local uv_fs_realpath = Async.promisify(uv.fs_realpath)

---Return if the path is directory.
---@param path string
---@return insx.kit.Async.AsyncTask
function IO.is_directory(path)
  path = IO.normalize(path)
  return Async.run(function()
    return uv_fs_stat(path)
        :catch(function()
          return {}
        end)
        :await().type == 'directory'
  end)
end

---Return if the path is exists.
---@param path string
---@return insx.kit.Async.AsyncTask
function IO.exists(path)
  path = IO.normalize(path)
  return Async.run(function()
    return uv_fs_stat(path)
        :next(function()
          return true
        end)
        :catch(function()
          return false
        end)
        :await()
  end)
end

---Get realpath.
---@param path string
---@return insx.kit.Async.AsyncTask
function IO.realpath(path)
  path = IO.normalize(path)
  return Async.run(function()
    return IO.normalize(uv_fs_realpath(path):await())
  end)
end

---Return file stats or throw error.
---@param path string
---@return insx.kit.Async.AsyncTask
function IO.stat(path)
  path = IO.normalize(path)
  return Async.run(function()
    return uv_fs_stat(path):await()
  end)
end

---Read file.
---@param path string
---@param chunk_size? integer
---@return insx.kit.Async.AsyncTask
function IO.read_file(path, chunk_size)
  path = IO.normalize(path)
  chunk_size = chunk_size or 1024
  return Async.run(function()
    local stat = uv_fs_stat(path):await()
    local fd = uv_fs_open(path, IO.AccessMode.r, tonumber('755', 8)):await()
    local ok, res = pcall(function()
      local chunks = {}
      local offset = 0
      while offset < stat.size do
        local chunk = uv_fs_read(fd, math.min(chunk_size, stat.size - offset), offset):await()
        if not chunk then
          break
        end
        table.insert(chunks, chunk)
        offset = offset + #chunk
      end
      return table.concat(chunks, ''):sub(1, stat.size - 1) -- remove EOF.
    end)
    uv_fs_close(fd):await()
    if not ok then
      error(res)
    end
    return res
  end)
end

---Write file.
---@param path string
---@param content string
---@param chunk_size? integer
function IO.write_file(path, content, chunk_size)
  path = IO.normalize(path)
  content = content .. '\n' -- add EOF.
  chunk_size = chunk_size or 1024
  return Async.run(function()
    local fd = uv_fs_open(path, IO.AccessMode.w, tonumber('755', 8)):await()
    local ok, err = pcall(function()
      local offset = 0
      while offset < #content do
        local chunk = content:sub(offset + 1, offset + chunk_size)
        offset = offset + uv_fs_write(fd, chunk, offset):await()
      end
      uv_fs_ftruncate(fd, offset):await()
    end)
    uv_fs_close(fd):await()
    if not ok then
      error(err)
    end
  end)
end

---Create directory.
---@param path string
---@param mode integer
---@param option? { recursive?: boolean }
function IO.mkdir(path, mode, option)
  path = IO.normalize(path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    if not option.recursive then
      uv_fs_mkdir(path, mode):await()
    else
      local not_exists = {}
      local current = path
      while current ~= '/' do
        local stat = uv_fs_stat(current):catch(function() end):await()
        if stat then
          break
        end
        table.insert(not_exists, 1, current)
        current = IO.dirname(current)
      end
      for _, dir in ipairs(not_exists) do
        uv_fs_mkdir(dir, mode):await()
      end
    end
  end)
end

---Remove file or directory.
---@param start_path string
---@param option? { recursive?: boolean }
function IO.rm(start_path, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = uv_fs_stat(start_path):await()
    if stat.type == 'directory' then
      local children = IO.scandir(start_path):await()
      if not option.recursive and #children > 0 then
        error(('IO.rm: `%s` is a directory and not empty.'):format(start_path))
      end
      IO.walk(start_path, function(err, entry)
        if err then
          error('IO.rm: ' .. tostring(err))
        end
        if entry.type == 'directory' then
          uv_fs_rmdir(entry.path):await()
        else
          uv_fs_unlink(entry.path):await()
        end
      end, { postorder = true }):await()
    else
      uv_fs_unlink(start_path):await()
    end
  end)
end

---Copy file or directory.
---@param from any
---@param to any
---@param option? { recursive?: boolean }
---@return insx.kit.Async.AsyncTask
function IO.cp(from, to, option)
  from = IO.normalize(from)
  to = IO.normalize(to)
  option = option or {}
  option.recursive = option.recursive or false
  return Async.run(function()
    local stat = uv_fs_stat(from):await()
    if stat.type == 'directory' then
      if not option.recursive then
        error(('IO.cp: `%s` is a directory.'):format(from))
      end
      local from_pat = ('^%s'):format(vim.pesc(from))
      IO.walk(from, function(err, entry)
        if err then
          error('IO.cp: ' .. tostring(err))
        end
        local new_path = entry.path:gsub(from_pat, to)
        if entry.type == 'directory' then
          IO.mkdir(new_path, tonumber(stat.mode, 10), { recursive = true }):await()
        else
          uv_fs_copyfile(entry.path, new_path):await()
        end
      end):await()
    else
      uv_fs_copyfile(from, to):await()
    end
  end)
end

---Walk directory entries recursively.
---@param start_path string
---@param callback fun(err: string|nil, entry: { path: string, type: string }): insx.kit.IO.WalkStatus?
---@param option? { postorder?: boolean }
function IO.walk(start_path, callback, option)
  start_path = IO.normalize(start_path)
  option = option or {}
  option.postorder = option.postorder or false
  return Async.run(function()
    local function walk_pre(dir)
      local ok, iter_entries = pcall(function()
        return IO.iter_scandir(dir.path):await()
      end)
      if not ok then
        return callback(iter_entries, dir)
      end
      local status = callback(nil, dir)
      if status == IO.WalkStatus.SkipDir then
        return
      elseif status == IO.WalkStatus.Break then
        return status
      end
      for entry in iter_entries do
        if entry.type == 'directory' then
          if walk_pre(entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        else
          if callback(nil, entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        end
      end
    end

    local function walk_post(dir)
      local ok, iter_entries = pcall(function()
        return IO.iter_scandir(dir.path):await()
      end)
      if not ok then
        return callback(iter_entries, dir)
      end
      for entry in iter_entries do
        if entry.type == 'directory' then
          if walk_post(entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        else
          if callback(nil, entry) == IO.WalkStatus.Break then
            return IO.WalkStatus.Break
          end
        end
      end
      return callback(nil, dir)
    end

    if not IO.is_directory(start_path) then
      error(('IO.walk: `%s` is not a directory.'):format(start_path))
    end
    if option.postorder then
      walk_post({ path = start_path, type = 'directory' })
    else
      walk_pre({ path = start_path, type = 'directory' })
    end
  end)
end

---Scan directory entries.
---@param path string
---@return insx.kit.Async.AsyncTask
function IO.scandir(path)
  path = IO.normalize(path)
  return Async.run(function()
    local fd = uv_fs_scandir(path):await()
    local entries = {}
    while true do
      local name, type = uv.fs_scandir_next(fd)
      if not name then
        break
      end
      table.insert(entries, {
        type = type,
        path = IO.join(path, name),
      })
    end
    return entries
  end)
end

---Scan directory entries.
---@param path any
---@return insx.kit.Async.AsyncTask
function IO.iter_scandir(path)
  path = IO.normalize(path)
  return Async.run(function()
    local fd = uv_fs_scandir(path):await()
    return function()
      local name, type = uv.fs_scandir_next(fd)
      if name then
        return {
          type = type,
          path = IO.join(path, name),
        }
      end
    end
  end)
end

---Return normalized path.
---@param path string
---@return string
function IO.normalize(path)
  path = sep(path)

  -- remove trailing slash.
  if #path > 1 and path:byte(-1) == bytes.slash then
    path = path:sub(1, -2)
  end

  -- homedir.
  if path:byte(1) == bytes.tilde and path:byte(2) == bytes.slash then
    path = (path:gsub('^~/', home))
  end

  -- absolute.
  if IO.is_absolute(path) then
    return path
  end

  -- resolve relative path.
  return IO.join(IO.cwd(), path)
end

do
  local cache = {
    raw = nil,
    fix = nil
  }

  ---Return the current working directory.
  ---@return string
  function IO.cwd()
    local cwd = assert(uv.cwd())
    if cache.raw == cwd then
      return cache.fix
    end
    cache.raw = cwd
    cache.fix = sep(cwd)
    return cache.fix
  end
end

do
  local cache_pat = {}

  ---Join the paths.
  ---@param base string
  ---@vararg string
  ---@return string
  function IO.join(base, ...)
    base = sep(base)

    -- remove trailing slash.
    -- ./   → ./
    -- aaa/ → aaa
    if not (base == './' or base == '../') and base:byte(-1) == bytes.slash then
      base = base:sub(1, -2)
    end

    for i = 1, select('#', ...) do
      local path = sep(select(i, ...))
      local path_s = 1
      if path:byte(path_s) == bytes.dot and path:byte(path_s + 1) == bytes.slash then
        path_s = path_s + 2
      end
      local up_count = 0
      while path:byte(path_s) == bytes.dot and path:byte(path_s + 1) == bytes.dot and path:byte(path_s + 2) == bytes.slash do
        up_count = up_count + 1
        path_s = path_s + 3
      end
      if path_s > 1 then
        cache_pat[path_s] = cache_pat[path_s] or ('^%s'):format(('.'):rep(path_s - 2))
      end

      -- optimize for avoiding new string creation.
      if path_s == 1 then
        base = ('%s/%s'):format(IO.dirname(base, up_count), path)
      else
        base = path:gsub(cache_pat[path_s], IO.dirname(base, up_count))
      end
    end
    return base
  end
end

---Return the path of the current working directory.
---@param path string
---@param level? integer
---@return string
function IO.dirname(path, level)
  path = sep(path)
  level = level or 1

  if level == 0 then
    return path
  end

  for i = #path - 1, 1, -1 do
    if path:byte(i) == bytes.slash then
      if level == 1 then
        return path:sub(1, i - 1)
      end
      level = level - 1
    end
  end
  return path
end

---Return the path is absolute or not.
---@param path string
---@return boolean
function IO.is_absolute(path)
  path = sep(path)
  return path:byte(1) == bytes.slash or path:match('^%a:/')
end

return IO
