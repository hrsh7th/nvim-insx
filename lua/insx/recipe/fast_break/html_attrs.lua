local helper = require('insx.helper')

local ATTR_OPEN = [=[[[:alpha:]:-]\+\%(=\)\?]=]

---@class insx.recipe.fast_break.html_attrs.Option

---@param _ insx.recipe.fast_break.html_attrs.Option
---@return insx.RecipeSource
local function html_attrs(_)
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
        -- Move to ATTR_OPEN.
        local attr_end_pos = ctx.search([[\%#\s*]] .. ATTR_OPEN .. [[\s*\zs]])
        if not attr_end_pos then
          break
        end
        ctx.move(attr_end_pos[1], attr_end_pos[2])

        local is_flag_attribute = not ctx.match([[=\%#]])

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

        if not is_flag_attribute then
          ctx.send('<Right>')
        end
        ctx.delete([[\s*]])

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
      return ctx.match([[<\%(\w\|\.\)\+\s*\%#[^>]\+>]])
    end,
  }
end

return html_attrs
