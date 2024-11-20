local AsyncTask = require('insx.kit.Async.AsyncTask')

local Async = {}

_G.kit = _G.kit or {}
_G.kit.Async = _G.kit.Async or {}
_G.kit.Async.___threads___ = _G.kit.Async.___threads___ or {}

---Alias of AsyncTask.all.
---@param tasks insx.kit.Async.AsyncTask[]
---@return insx.kit.Async.AsyncTask
function Async.all(tasks)
  return AsyncTask.all(tasks)
end

---Alias of AsyncTask.race.
---@param tasks insx.kit.Async.AsyncTask[]
---@return insx.kit.Async.AsyncTask
function Async.race(tasks)
  return AsyncTask.race(tasks)
end

---Alias of AsyncTask.resolve(v).
---@param v any
---@return insx.kit.Async.AsyncTask
function Async.resolve(v)
  return AsyncTask.resolve(v)
end

---Alias of AsyncTask.reject(v).
---@param v any
---@return insx.kit.Async.AsyncTask
function Async.reject(v)
  return AsyncTask.reject(v)
end

---Alias of AsyncTask.new(...).
---@param runner fun(resolve: fun(value: any), reject: fun(err: any))
---@return insx.kit.Async.AsyncTask
function Async.new(runner)
  return AsyncTask.new(runner)
end

---Run async function immediately.
---@generic T: fun(): insx.kit.Async.AsyncTask
---@param runner T
---@return insx.kit.Async.AsyncTask
function Async.run(runner)
  return Async.async(runner)()
end

---Return current context is async coroutine or not.
---@return boolean
function Async.in_context()
  return _G.kit.Async.___threads___[coroutine.running()] ~= nil
end

---Create async function.
---@generic T: fun(...): insx.kit.Async.AsyncTask
---@param runner T
---@return T
function Async.async(runner)
  return function(...)
    local args = { ... }

    local thread = coroutine.create(runner)
    return AsyncTask.new(function(resolve, reject)
      _G.kit.Async.___threads___[thread] = 1

      local function next_step(ok, v)
        if coroutine.status(thread) == 'dead' then
          _G.kit.Async.___threads___[thread] = nil
          if AsyncTask.is(v) then
            v:dispatch(resolve, reject)
          else
            if ok then
              resolve(v)
            else
              reject(v)
            end
          end
          return
        end

        v:dispatch(function(...)
          next_step(coroutine.resume(thread, true, ...))
        end, function(...)
          next_step(coroutine.resume(thread, false, ...))
        end)
      end

      next_step(coroutine.resume(thread, unpack(args)))
    end)
  end
end

---Await async task.
---@param task insx.kit.Async.AsyncTask
---@return any
function Async.await(task)
  if not _G.kit.Async.___threads___[coroutine.running()] then
    error('`Async.await` must be called in async context.')
  end
  if not AsyncTask.is(task) then
    error('`Async.await` must be called with AsyncTask.')
  end

  local ok, res = coroutine.yield(task)
  if not ok then
    error(res, 2)
  end
  return res
end

---Create vim.schedule task.
---@return insx.kit.Async.AsyncTask
function Async.schedule()
  return AsyncTask.new(function(resolve)
    vim.schedule(resolve)
  end)
end

---Create vim.defer_fn task.
---@param timeout integer
---@return insx.kit.Async.AsyncTask
function Async.timeout(timeout)
  return AsyncTask.new(function(resolve)
    vim.defer_fn(resolve, timeout)
  end)
end

---Create async function from callback function.
---@generic T: ...
---@param runner fun(...: T)
---@param option? { schedule?: boolean, callback?: integer }
---@return fun(...: T): insx.kit.Async.AsyncTask
function Async.promisify(runner, option)
  option = option or {}
  option.schedule = not vim.is_thread() and (option.schedule or false)
  option.callback = option.callback or nil
  return function(...)
    local args = { ... }
    return AsyncTask.new(function(resolve, reject)
      local max = #args + 1
      local pos = math.min(option.callback or max, max)
      table.insert(args, pos, function(err, ...)
        if option.schedule and vim.in_fast_event() then
          resolve = vim.schedule_wrap(resolve)
          reject = vim.schedule_wrap(reject)
        end
        if err then
          reject(err)
        else
          resolve(...)
        end
      end)
      runner(unpack(args))
    end)
  end
end

return Async
