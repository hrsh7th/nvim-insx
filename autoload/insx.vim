function! insx#expand(char) abort
  return luaeval('require("insx").expand(_A)', a:char)
endfunction

function! insx#detect(char) abort
  return luaeval('require("insx").detect(_A)', a:char)
endfunction

