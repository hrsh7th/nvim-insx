local helper = require('insx.helper')

local ATTR_OPEN = [=[[[:alpha:]:-]\+\%(=\)\?]=]

---@param option {}
return function(option)
  return {
    ---@param ctx insx.Context
    action = function(ctx)
      -- Remove spaces.
      ctx.remove([[\s*\%#\s*]])

      -- Open side.
      local open_indent = helper.indent.get_current_indent()
      ctx.send('<CR>')
      ctx.send(helper.indent.adjust({
        current = helper.indent.get_current_indent(),
        expected = open_indent .. helper.indent.get_one_indent(),
      }))

      -- Recursive html attrs.
      local memo_row, memo_col = ctx.row(), ctx.col()
      while true do
        -- Move to ATTR_OPEN and remove unnecessary spaces.
        local attr_end_pos = ctx.search([[\%#\s*]] .. ATTR_OPEN .. [[\s*\zs]])
        if not attr_end_pos then
          break
        end
        ctx.move(attr_end_pos[1], attr_end_pos[2])

        -- Search ATTR_CLOSE.
        for open_pat, close_pat in pairs({
          ["'"] = "'",
          ['"'] = '"',
          ['{'] = '}',
        }) do
          local pos = ctx.search([[\%#\s*]] .. open_pat .. [[\s*\zs]])
          if pos then
            ctx.move(unpack(pos))
            ctx.move(unpack(assert(helper.search.get_pair_close(open_pat, close_pat))))
            break
          end
        end
        if ctx.match([[\%#\s*/\?>]]) then
          ctx.send('<CR>')
          break
        end
        ctx.send('<Right>')

        -- Split line.
        ctx.send('<CR>')
        ctx.send(helper.indent.adjust({
          current = helper.indent.get_current_indent(),
          expected = open_indent .. helper.indent.get_one_indent(),
        }))
      end
      ctx.send(helper.indent.adjust({
        current = helper.indent.get_current_indent(),
        expected = open_indent,
      }))
      ctx.move(memo_row, memo_col)
    end,
    ---@param ctx insx.Context
    enabled = function(ctx)
      if not option.split then
        return false
      end
      return ctx.match([[<\w\+\s*\%#[^>]\+>]])
    end,
  }
end
