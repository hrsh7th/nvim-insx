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

return indent
