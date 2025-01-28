---@class insx.kit.App.Command.SubCommand.Argument
---@field public complete? fun(prefix: string):string[]
---@field public required? boolean

---@class insx.kit.App.Command.SubCommandSpecifier
---@field public desc? string
---@field public args? table<string|number, insx.kit.App.Command.SubCommand.Argument>
---@field public execute fun(params: insx.kit.App.Command.ExecuteParams, arguments: table<string, string>)

---@class insx.kit.App.Command.SubCommand: insx.kit.App.Command.SubCommandSpecifier
---@field public name string
---@field public args table<string|number, insx.kit.App.Command.SubCommand.Argument>

---@class insx.kit.App.Command
---@field public name string
---@field public subcommands table<string, insx.kit.App.Command.SubCommand>
local Command = {}
Command.__index = Command

---Create a new command.
---@param name string
---@param subcommand_specifiers table<string, insx.kit.App.Command.SubCommandSpecifier>
function Command.new(name, subcommand_specifiers)
  -- normalize subcommand specifiers.
  local subcommands = {}
  for subcommand_name, subcommand_specifier in pairs(subcommand_specifiers) do
    subcommands[subcommand_name] = {
      name = subcommand_name,
      args = subcommand_specifier.args or {},
      execute = subcommand_specifier.execute,
    }
  end

  -- create command.
  return setmetatable({
    name = name,
    subcommands = subcommands,
  }, Command)
end

---@class insx.kit.App.Command.ExecuteParams
---@field public name string
---@field public args string
---@field public fargs string[]
---@field public nargs string
---@field public bang boolean
---@field public line1 integer
---@field public line2 integer
---@field public range 0|1|2
---@field public count integer
---@field public req string
---@field public mods string
---@field public smods string[]
---Execute command.
---@param params insx.kit.App.Command.ExecuteParams
function Command:execute(params)
  local parsed = self._parse(params.args)

  local subcommand = self.subcommands[parsed[1].text]
  if not subcommand then
    error(('Unknown subcommand: %s'):format(parsed[1].text))
  end

  local arguments = {}

  local pos = 1
  for i, part in ipairs(parsed) do
    if i > 1 then
      local is_named_argument = vim.iter(pairs(subcommand.args)):any(function(name)
        return type(name) == 'string' and part.text:sub(1, #name + 1) == ('%s='):format(name)
      end)
      if is_named_argument then
        local s = part.text:find('=', 1, true)
        if s then
          local name = part.text:sub(1, s - 1)
          local value = part.text:sub(s + 1)
          arguments[name] = value
        end
      else
        arguments[pos] = part.text
        pos = pos + 1
      end
    end
  end

  -- check required arguments.
  for name, arg in pairs(subcommand.args or {}) do
    if arg.required and not arguments[name] then
      error(('Argument %s is required.'):format(name))
    end
  end

  subcommand.execute(params, arguments)
end

---Complete command.
---@param cmdline string
---@param cursor integer
function Command:complete(cmdline, cursor)
  local parsed = self._parse(cmdline)

  -- check command.
  if parsed[1].text ~= self.name then
    return {}
  end

  -- complete subcommand names.
  if parsed[2] and parsed[2].s <= cursor and cursor <= parsed[2].e then
    return vim
      .iter(pairs(self.subcommands))
      :map(function(_, subcommand)
        return subcommand.name
      end)
      :totable()
  end

  -- check subcommand is exists.
  local subcommand = self.subcommands[parsed[2].text]
  if not subcommand then
    return {}
  end

  -- check subcommand arguments.
  local pos = 1
  for i, part in ipairs(parsed) do
    if i > 2 then
      local is_named_argument_name = vim.regex([=[^--\?[^=]*$]=]):match_str(part.text) ~= nil
      local is_named_argument_value = vim.iter(pairs(subcommand.args)):any(function(name)
        name = tostring(name)
        return part.text:sub(1, #name + 1) == ('%s='):format(name)
      end)

      -- current cursor argument.
      if part.s <= cursor and cursor <= part.e then
        if is_named_argument_name then
          -- return named-argument completion.
          return vim
            .iter(pairs(subcommand.args))
            :map(function(name)
              return name
            end)
            :filter(function(name)
              return type(name) == 'string'
            end)
            :totable()
        elseif is_named_argument_value then
          -- return specific named-argument value completion.
          for name, argument in pairs(subcommand.args) do
            if type(name) == 'string' then
              if part.text:sub(1, #name + 1) == ('%s='):format(name) then
                if argument.complete then
                  return argument.complete(part.text:sub(#name + 2))
                end
                return {}
              end
            end
          end
        elseif subcommand.args[pos] then
          local argument = subcommand.args[pos]
          if argument.complete then
            return argument.complete(part.text)
          end
          return {}
        end
      end

      -- increment positional argument.
      if not is_named_argument_name and not is_named_argument_value then
        pos = pos + 1
      end
    end
  end
end

---Parse command line.
---@param cmdline string
---@return { text: string, s: integer, e: integer }[]
function Command._parse(cmdline)
  ---@type { text: string, s: integer, e: integer }[]
  local parsed = {}

  local part = {}
  local s = 1
  local i = 1
  while i <= #cmdline do
    local c = cmdline:sub(i, i)
    if c == '\\' then
      table.insert(part, cmdline:sub(i + 1, i + 1))
      i = i + 1
    elseif c == ' ' then
      if #part > 0 then
        table.insert(parsed, {
          text = table.concat(part),
          s = s - 1,
          e = i - 1,
        })
        part = {}
        s = i + 1
      end
    else
      table.insert(part, c)
    end
    i = i + 1
  end

  if #part then
    table.insert(parsed, {
      text = table.concat(part),
      s = s - 1,
      e = i - 1,
    })
    return parsed
  end

  table.insert(parsed, {
    text = '',
    s = #cmdline,
    e = #cmdline + 1,
  })

  return parsed
end

return Command
