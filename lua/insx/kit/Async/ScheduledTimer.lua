---@class insx.kit.Async.ScheduledTimer
---@field private _timer uv.uv_timer_t
---@field private _running boolean
---@field private _revision integer
local ScheduledTimer = {}
ScheduledTimer.__index = ScheduledTimer

---Create new timer.
function ScheduledTimer.new()
  return setmetatable({
    _timer = assert(vim.uv.new_timer()),
    _running = false,
    _revision = 0,
  }, ScheduledTimer)
end

---Check if timer is running.
---@return boolean
function ScheduledTimer:is_running()
  return self._running
end

---Start timer.
function ScheduledTimer:start(ms, repeat_ms, callback)
  self._timer:stop()
  self._running = true
  self._revision = self._revision + 1
  local revision = self._revision

  local function on_tick()
    if revision ~= self._revision then
      return
    end
    local function tick()
      if revision ~= self._revision then
        return
      end
      if repeat_ms ~= 0 then
        callback()
        self:start(repeat_ms, repeat_ms, callback)
      else
        self._running = false
        callback()
      end
    end
    if vim.in_fast_event() then
      vim.schedule(tick)
    else
      tick()
    end
  end
  if ms == 0 then
    on_tick()
    return
  end
  self._timer:start(ms, 0, on_tick)
end

---Stop timer.
function ScheduledTimer:stop()
  self._timer:stop()
  self._running = false
  self._revision = self._revision + 1
end

return ScheduledTimer
