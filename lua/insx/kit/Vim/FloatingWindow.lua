local kit = require('insx.kit')

---@alias insx.kit.Vim.FloatingWindow.WindowKind 'main' | 'scrollbar_track' | 'scrollbar_thumb'

---@class insx.kit.Vim.FloatingWindow.BorderSize
---@field public top integer
---@field public left integer
---@field public right integer
---@field public bottom integer
---@field public h integer
---@field public v integer

---@class insx.kit.Vim.FloatingWindow.ContentSize
---@field public width integer
---@field public height integer

---@class insx.kit.Vim.FloatingWindow.WindowConfig
---@field public row integer 0-indexed utf-8
---@field public col integer 0-indexed utf-8
---@field public width integer
---@field public height integer
---@field public border? string | string[]
---@field public anchor? "NW" | "NE" | "SW" | "SE"
---@field public style? string
---@field public title? string
---@field public title_pos? 'left' | 'right' | 'center'
---@field public footer? string
---@field public footer_pos? 'left' | 'right' | 'center'
---@field public zindex? integer

---@class insx.kit.Vim.FloatingWindow.Viewport
---@field public row integer
---@field public col integer
---@field public inner_width integer window inner width
---@field public inner_height integer window inner height
---@field public outer_width integer window outer width that includes border and scrollbar width
---@field public outer_height integer window outer height that includes border width
---@field public border_size insx.kit.Vim.FloatingWindow.BorderSize
---@field public content_size insx.kit.Vim.FloatingWindow.ContentSize
---@field public scrollbar boolean
---@field public ui_width integer
---@field public ui_height integer
---@field public border string | string[] | nil
---@field public zindex integer

---@class insx.kit.Vim.FloatingWindow.Config
---@field public markdown? boolean

---@class insx.kit.Vim.FloatingWindow
---@field private _augroup string
---@field private _config insx.kit.Vim.FloatingWindow.Config
---@field private _buf_option table<string, { [string]: any }>
---@field private _win_option table<string, { [string]: any }>
---@field private _buf integer
---@field private _scrollbar_track_buf integer
---@field private _scrollbar_thumb_buf integer
---@field private _win? integer
---@field private _scrollbar_track_win? integer
---@field private _scrollbar_thumb_win? integer
local FloatingWindow = {}
FloatingWindow.__index = FloatingWindow

---Returns true if the window is visible
---@param win? integer
---@return boolean
local function is_visible(win)
  if not win then
    return false
  end
  if not vim.api.nvim_win_is_valid(win) then
    return false
  end
  return true
end

---Show the window
---@param win? integer
---@param buf integer
---@param win_config insx.kit.Vim.FloatingWindow.WindowConfig
---@return integer
local function show_or_move(win, buf, win_config)
  win_config.border = win_config.border or (vim.o.winborder --[[@as string]])

  local border_size = FloatingWindow.get_border_size(win_config.border)
  if win_config.anchor == 'NE' then
    win_config.col = win_config.col - win_config.width - border_size.right - border_size.left
  elseif win_config.anchor == 'SW' then
    win_config.row = win_config.row - win_config.height - border_size.top - border_size.bottom
  elseif win_config.anchor == 'SE' then
    win_config.row = win_config.row - win_config.height - border_size.top - border_size.bottom
    win_config.col = win_config.col - win_config.width - border_size.right - border_size.left
  end
  win_config.anchor = 'NW'

  if is_visible(win) then
    vim.api.nvim_win_set_config(win --[=[@as integer]=], {
      relative = 'editor',
      row = win_config.row,
      col = win_config.col,
      width = win_config.width,
      height = win_config.height,
      anchor = 'NW',
      style = win_config.style,
      border = win_config.border,
      title = win_config.title,
      title_pos = win_config.title_pos,
      footer = win_config.footer,
      footer_pos = win_config.footer_pos,
      zindex = win_config.zindex,
    })
    return win --[=[@as integer]=]
  else
    return vim.api.nvim_open_win(buf, false, {
      noautocmd = true,
      relative = 'editor',
      row = win_config.row,
      col = win_config.col,
      width = win_config.width,
      height = win_config.height,
      anchor = 'NW',
      style = win_config.style,
      border = win_config.border,
      title = win_config.title,
      title_pos = win_config.title_pos,
      footer = win_config.footer,
      footer_pos = win_config.footer_pos,
      zindex = win_config.zindex,
    })
  end
end

---Hide the window
---@param win integer
local function hide(win)
  if is_visible(win) then
    vim.api.nvim_win_hide(win)
  end
end

---Get border size.
---@param border nil | string | string[]
---@return insx.kit.Vim.FloatingWindow.BorderSize
function FloatingWindow.get_border_size(border)
  border = border or (vim.o.winborder --[[@as string]])

  local maybe_border_size = (function()
    if not border or border == '' then
      return { top = 0, right = 0, bottom = 0, left = 0 }
    end
    if type(border) == 'string' then
      if border == 'none' then
        return { top = 0, right = 0, bottom = 0, left = 0 }
      elseif border == 'single' then
        return { top = 1, right = 1, bottom = 1, left = 1 }
      elseif border == 'double' then
        return { top = 2, right = 2, bottom = 2, left = 2 }
      elseif border == 'rounded' then
        return { top = 1, right = 1, bottom = 1, left = 1 }
      elseif border == 'solid' then
        return { top = 1, right = 1, bottom = 1, left = 1 }
      elseif border == 'shadow' then
        return { top = 0, right = 1, bottom = 1, left = 0 }
      end
      return { top = 0, right = 0, bottom = 0, left = 0 }
    end
    local chars = border --[=[@as string[]]=]
    while #chars < 8 do
      chars = kit.concat(chars, chars)
    end
    return {
      top = vim.api.nvim_strwidth(chars[2]),
      right = vim.api.nvim_strwidth(chars[4]),
      bottom = vim.api.nvim_strwidth(chars[6]),
      left = vim.api.nvim_strwidth(chars[8]),
    }
  end)()
  maybe_border_size.v = maybe_border_size.top + maybe_border_size.bottom
  maybe_border_size.h = maybe_border_size.left + maybe_border_size.right
  return maybe_border_size
end

---Get content size.
---@param params { bufnr: integer, wrap: boolean, max_inner_width: integer, markdown?: boolean }
---@return insx.kit.Vim.FloatingWindow.ContentSize
function FloatingWindow.get_content_size(params)
  --- compute content width.
  local content_width --[=[@as integer]=]
  do
    local max_text_width = 0
    for _, text in ipairs(vim.api.nvim_buf_get_lines(params.bufnr, 0, -1, false)) do
      local text_width = math.max(1, vim.api.nvim_strwidth(text))
      if params.markdown then
        local j = 1
        local s, e = text:find('%b[]%b()', j)
        if s then
          text_width = text_width - (#text:match('%b[]', j) - 2)
          j = e + 1
        end
      end
      max_text_width = math.max(max_text_width, text_width)
    end
    content_width = max_text_width
  end

  --- compute content height.
  local content_height --[=[@as integer]=]
  do
    if params.wrap then
      local max_width = math.min(params.max_inner_width, content_width)
      local height = 0
      for _, text in ipairs(vim.api.nvim_buf_get_lines(params.bufnr, 0, -1, false)) do
        local text_width = math.max(1, vim.api.nvim_strwidth(text))
        height = height + math.max(1, math.ceil(text_width / max_width))
      end
      content_height = height
    else
      content_height = vim.api.nvim_buf_line_count(params.bufnr)
    end

    for _, extmark in
    ipairs(vim.api.nvim_buf_get_extmarks(params.bufnr, -1, 0, -1, {
      details = true,
    }))
    do
      if extmark[4] and extmark[4].virt_lines then
        content_height = content_height + #extmark[4].virt_lines
      end
    end
  end

  return {
    width = content_width,
    height = content_height,
  }
end

---Guess viewport information.
---@param params { border_size: insx.kit.Vim.FloatingWindow.BorderSize, content_size: insx.kit.Vim.FloatingWindow.ContentSize, max_outer_width: integer, max_outer_height: integer }
---@return { inner_width: integer, inner_height: integer, outer_width: integer, outer_height: integer, scrollbar: boolean }
function FloatingWindow.compute_restricted_size(params)
  local inner_size = {
    width = math.min(params.content_size.width, params.max_outer_width - params.border_size.h),
    height = math.min(params.content_size.height, params.max_outer_height - params.border_size.v),
  }

  local scrollbar = inner_size.height < params.content_size.height

  return {
    outer_width = inner_size.width + params.border_size.h + (scrollbar and 1 or 0),
    outer_height = inner_size.height + params.border_size.v,
    inner_width = inner_size.width,
    inner_height = inner_size.height,
    scrollbar = scrollbar,
  }
end

---Create window.
---@return insx.kit.Vim.FloatingWindow
function FloatingWindow.new()
  return setmetatable({
    _augroup = vim.api.nvim_create_augroup(('insx.kit.Vim.FloatingWindow:%s'):format(kit.unique_id()), {
      clear = true,
    }),
    _config = {
      markdown = false,
      border = #vim.o.winborder > 0 and vim.o.winborder or 'none',
    },
    _win_option = {},
    _buf_option = {},
    _buf = vim.api.nvim_create_buf(false, true),
    _scrollbar_track_buf = vim.api.nvim_create_buf(false, true),
    _scrollbar_thumb_buf = vim.api.nvim_create_buf(false, true),
  }, FloatingWindow)
end

---Get config.
---@return insx.kit.Vim.FloatingWindow.Config
function FloatingWindow:get_config()
  return self._config
end

---Set config.
---@param config insx.kit.Vim.FloatingWindow.Config
function FloatingWindow:set_config(config)
  self._config = kit.merge(config, self._config)
end

---Set window option.
---@param key string
---@param value any
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
function FloatingWindow:set_win_option(key, value, kind)
  kind = kind or 'main'
  self._win_option[kind] = self._win_option[kind] or {}
  self._win_option[kind][key] = value
  self:_update_option()
end

---Get window option.
---@param key string
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
---@return any
function FloatingWindow:get_win_option(key, kind)
  kind = kind or 'main'
  local win = ({
    main = self._win,
    scrollbar_track = self._scrollbar_track_win,
    scrollbar_thumb = self._scrollbar_thumb_win,
  })[kind] --[=[@as integer]=]
  if not is_visible(win) then
    return self._win_option[kind] and self._win_option[kind][key]
  end
  return vim.api.nvim_get_option_value(key, { win = win }) or vim.api.nvim_get_option_value(key, { scope = 'global' })
end

---Set buffer option.
---@param key string
---@param value any
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
function FloatingWindow:set_buf_option(key, value, kind)
  kind = kind or 'main'
  self._buf_option[kind] = self._buf_option[kind] or {}
  self._buf_option[kind][key] = value
  self:_update_option()
end

---Get window option.
---@param key string
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
---@return any
function FloatingWindow:get_buf_option(key, kind)
  kind = kind or 'main'
  local buf = ({
    main = self._buf,
    scrollbar_track = self._scrollbar_track_buf,
    scrollbar_thumb = self._scrollbar_thumb_buf,
  })[kind] --[=[@as integer]=]
  if not buf then
    return self._buf_option[kind] and self._buf_option[kind][key]
  end
  return vim.api.nvim_get_option_value(key, { buf = buf }) or vim.api.nvim_get_option_value(key, { scope = 'global' })
end

---Returns the related bufnr.
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
---@return integer
function FloatingWindow:get_buf(kind)
  if kind == 'scrollbar_track' then
    return self._scrollbar_track_buf
  elseif kind == 'scrollbar_thumb' then
    return self._scrollbar_thumb_buf
  end
  return self._buf
end

---Returns the current win.
---@param kind? insx.kit.Vim.FloatingWindow.WindowKind
---@return integer?
function FloatingWindow:get_win(kind)
  if kind == 'scrollbar_track' then
    return self._scrollbar_track_win
  elseif kind == 'scrollbar_thumb' then
    return self._scrollbar_thumb_win
  end
  return self._win
end

---Show the window
---@param win_config insx.kit.Vim.FloatingWindow.WindowConfig
function FloatingWindow:show(win_config)
  self._win = show_or_move(self._win, self._buf, {
    row = win_config.row,
    col = win_config.col,
    width = win_config.width,
    height = win_config.height,
    anchor = win_config.anchor,
    style = win_config.style,
    border = win_config.border,
    title = win_config.title,
    title_pos = win_config.title_pos,
    footer = win_config.footer,
    footer_pos = win_config.footer_pos,
    zindex = win_config.zindex or 1000,
  })

  vim.api.nvim_clear_autocmds({ group = self._augroup })
  vim.api.nvim_create_autocmd({ 'WinResized', 'WinScrolled' }, {
    group = self._augroup,
    callback = function()
      self:_update_scrollbar()
    end,
  })

  self:_update_scrollbar()
  self:_update_option()
end

---Hide the window
function FloatingWindow:hide()
  vim.api.nvim_clear_autocmds({ group = self._augroup })
  hide(self._win)
  hide(self._scrollbar_track_win)
  hide(self._scrollbar_thumb_win)
end

---Scroll the window.
---@param delta integer
function FloatingWindow:scroll(delta)
  if not is_visible(self._win) then
    return
  end
  local viewport = self:get_viewport()
  vim.api.nvim_win_call(self._win, function()
    local topline = vim.fn.getwininfo(self._win)[1].topline
    topline = math.max(1, topline + delta)
    topline = math.min(viewport.content_size.height - vim.api.nvim_win_get_height(self._win) + 1, topline)
    vim.cmd.normal({
      ('%szt'):format(topline),
      bang = true,
      mods = {
        keepmarks = true,
        keepjumps = true,
        keepalt = true,
        noautocmd = true,
      },
    })
  end)
end

---Returns true if the window is visible
function FloatingWindow:is_visible()
  return is_visible(self._win)
end

---Get window viewport.
---NOTE: this method can only be called if window is showing.
---@return insx.kit.Vim.FloatingWindow.Viewport
function FloatingWindow:get_viewport()
  if not self:is_visible() then
    error('this method can only be called if window is showing.')
  end

  local win_config = vim.api.nvim_win_get_config(self:get_win() --[[@as integer]])
  local win_position = vim.api.nvim_win_get_position(self:get_win() --[[@as integer]])
  local border_size = FloatingWindow.get_border_size(win_config.border)
  local content_size = FloatingWindow.get_content_size({
    bufnr = self:get_buf(),
    wrap = self:get_win_option('wrap'),
    max_inner_width = win_config.width,
    markdown = self:get_config().markdown,
  })
  local scrollbar = win_config.height < content_size.height

  local ui_width = border_size.h + (scrollbar and 1 or 0)
  local ui_height = border_size.v
  return {
    row = win_position[1],
    col = win_position[2],
    inner_width = win_config.width,
    inner_height = win_config.height,
    outer_width = win_config.width + ui_width,
    outer_height = win_config.height + ui_height,
    ui_width = ui_width,
    ui_height = ui_height,
    border_size = border_size,
    content_size = content_size,
    scrollbar = scrollbar,
    border = win_config.border,
    zindex = win_config.zindex,
  }
end

---Update scrollbar.
function FloatingWindow:_update_scrollbar()
  if is_visible(self._win) then
    local viewport = self:get_viewport()
    if viewport.scrollbar then
      do
        self._scrollbar_track_win = show_or_move(self._scrollbar_track_win, self._scrollbar_track_buf, {
          row = viewport.row + viewport.border_size.top,
          col = viewport.col + viewport.outer_width - 1,
          width = 1,
          height = viewport.inner_height,
          style = 'minimal',
          zindex = viewport.zindex + 1,
          border = 'none',
        })
      end
      do
        local topline = vim.fn.getwininfo(self._win)[1].topline
        local ratio = topline / (viewport.content_size.height - viewport.inner_height)
        local thumb_height = viewport.inner_height / viewport.content_size.height * viewport.inner_height
        local thumb_row = (viewport.inner_height - thumb_height) * ratio
        thumb_row = math.floor(math.min(viewport.inner_height - thumb_height, thumb_row))
        self._scrollbar_thumb_win = show_or_move(self._scrollbar_thumb_win, self._scrollbar_thumb_buf, {
          row = viewport.row + viewport.border_size.top + thumb_row,
          col = viewport.col + viewport.outer_width - 1,
          width = 1,
          height = math.ceil(thumb_height),
          style = 'minimal',
          zindex = viewport.zindex + 2,
          border = 'none',
        })
      end
      return
    end
  end
  hide(self._scrollbar_track_win)
  hide(self._scrollbar_thumb_win)
end

---Update options.
function FloatingWindow:_update_option()
  -- update buf.
  for kind, buf in pairs({
    main = self._buf,
    scrollbar_track = self._scrollbar_track_buf,
    scrollbar_thumb = self._scrollbar_thumb_buf,
  }) do
    for k, v in pairs(self._buf_option[kind] or {}) do
      if vim.api.nvim_get_option_value(k, { buf = buf }) ~= v then
        vim.api.nvim_set_option_value(k, v, { buf = buf })
      end
    end
  end

  -- update win.
  for kind, win in pairs({
    main = self._win,
    scrollbar_track = self._scrollbar_track_win,
    scrollbar_thumb = self._scrollbar_thumb_win,
  }) do
    if is_visible(win) then
      for k, v in pairs(self._win_option[kind] or {}) do
        if vim.api.nvim_get_option_value(k, { win = win }) ~= v then
          vim.api.nvim_set_option_value(k, v, { win = win })
        end
      end
    end
  end
end

return FloatingWindow
