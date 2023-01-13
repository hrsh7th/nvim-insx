local indent = {}

---Return one indent size.
---@return string
function indent.get_one_indent()
  if not vim.o.expandtab then
    return '\t'
  end
  return (' '):rep(vim.o.shiftwidth ~= 0 and vim.o.shiftwidth or vim.o.tabstop)
end

---Return current indent size.
---@return string
function indent.get_current_indent()
  return vim.api.nvim_get_current_line():match('^(%s*)')
end

---Return key sequence to ajudst indentation between from and to.
function indent.ajudst_keys(f, t)
  local one_indent = indent.get_one_indent()
  local f_count = #f:gsub(vim.pesc(one_indent), '\t')
  local t_count = #t:gsub(vim.pesc(one_indent), '\t')
  local delta = t_count - f_count
  if delta > 0 then
    return one_indent:rep(delta)
  elseif delta < 0 then
    return ('<Left><Del>'):rep(vim.fn.strchars(one_indent:rep(math.abs(delta)), true))
  end
  return ''
end

return indent
