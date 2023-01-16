function! insx#expand(char) abort
  return luaeval('require("insx").expand(_A)', a:char)
endfunction
