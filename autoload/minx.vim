function! minx#expand(char) abort
  return luaeval('require("minx").expand(_A)', a:char)
endfunction
