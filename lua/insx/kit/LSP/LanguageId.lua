local mapping = {
  ['sh'] = 'shellscript',
  ['javascript.tsx'] = 'javascriptreact',
  ['typescript.tsx'] = 'typescriptreact',
}

local LanguageId = {}

function LanguageId.from_filetype(filetype)
  return mapping[filetype] or filetype
end

return LanguageId
