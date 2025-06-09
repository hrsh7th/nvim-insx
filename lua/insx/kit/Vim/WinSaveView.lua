---@class insx.kit.Vim.WinSaveView
---@field private _mode string
---@field private _view table
---@field private _cmd string
---@field private _win number
---@field private _cur table
local WinSaveView = {}
WinSaveView.__index = WinSaveView

---Create WinSaveView.
function WinSaveView.new()
  return setmetatable({
    _mode = vim.api.nvim_get_mode().mode,
    _view = vim.fn.winsaveview(),
    _cmd = vim.fn.winrestcmd(),
    _win = vim.api.nvim_get_current_win(),
    _cur = vim.api.nvim_win_get_cursor(0),
  }, WinSaveView)
end

function WinSaveView:restore()
  vim.api.nvim_set_current_win(self._win)

  -- restore modes.
  if vim.api.nvim_get_mode().mode ~= self._mode then
    if self._mode == 'i' then
      vim.cmd.startinsert()
    elseif vim.tbl_contains({ 'v', 'V', vim.keycode('<C-v>') }, self._mode) then
      vim.cmd.normal({ 'gv', bang = true })
    end
  end

  vim.api.nvim_win_set_cursor(0, self._cur)
  vim.cmd(self._cmd)
  vim.fn.winrestview(self._view)
end

return WinSaveView
