local mpack = require('mpack')

local Async = require('insx.kit.Async')

local Session = {}
Session.__index = Session

Session.Request = 0
Session.Response = 1
Session.Notification = 2

function Session.new(reader, writer)
  local self = setmetatable({}, Session)
  self.reader = reader
  self.writer = writer
  self.buffer = ''
  self.request_id = 0
  self.on_request = {}
  self.on_notification = {}
  self.pending_requests = {}
  return self
end

function Session:connect()
  self.reader:read_start(function(err, data)
    vim.pretty_print(data)
    if err then
      error(err)
    end
    data = data or ''
    if self.buffer == '' then
      self.buffer = data
      self:consume()
    else
      self.buffer = self.buffer .. data
    end
  end)
end

function Session:request(method, params)
  self.request_id = self.request_id + 1
  self:_write({ Session.Request, self.request_id, method, params })

  return Async.new(function(resolve, reject)
    self.pending_requests[self.request_id] = function(err, res)
      if err then
        reject(err)
      else
        resolve(res)
      end
    end
  end)
end

function Session:notify(method, params)
  self:_write({ Session.Notification, method, params })
end

function Session:consume()
  while self.buffer ~= '' do
    local res, off = mpack.Unpacker()(self.buffer)
    if not res then
      return
    end
    self.buffer = string.sub(self.buffer, off)

    if res[1] == Session.Request then
      if self.on_request[res[3]] then
        local ok, err = pcall(function()
          self.on_request[res[3]](res[4], function(result)
            self:_write({ Session.Response, res[2], nil, result })
          end)
        end)
        if not ok then
          self:_write({ Session.Response, res[2], err, nil })
        end
      end
    elseif res[1] == Session.Response then
      if self.pending_requests[res[2]] then
        self.pending_requests[res[2]](res[3], res[4])
        self.pending_requests[res[2]] = nil
      end
    elseif res[1] == Session.Notification then
      if self.on_notification[res[2]] then
        pcall(function()
          self.on_notification[res[2]](res[3])
        end)
      end
    end
  end
end

function Session:_write(msg)
  self.writer:write(mpack.Packer()(msg))
end

return Session
