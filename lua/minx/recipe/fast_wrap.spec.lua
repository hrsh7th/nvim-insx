local minx = require('minx')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.recipe.fast_wrap', function()
  ---@param option? { text: string[] }
  local function setup_buffer(option)
    option = option or {}

    vim.cmd.enew({ bang = true })
    vim.cmd([[ set noswapfile ]])
    vim.api.nvim_buf_set_option(0, 'filetype', 'lua')
    vim.api.nvim_buf_set_lines(0, 0, -1, false, option.text or {
      'local function example()',
      '  return string.format("foo%sbar", "_")',
      'end',
    })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
  end

  it('should wrap identifier', function()
    setup_buffer()
    minx.add(')', require('minx.recipe.fast_wrap')({
      close = ')'
    }))
    Keymap.spec(function()
      Keymap.send({
        Keymap.termcodes('i()<Left>'),
        { keys = ')', remap = true },
      }):await()
      assert.are.same({
        '(local) function example()',
        '  return string.format("foo%sbar", "_")',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)

  it('should wrap function-call', function()
    setup_buffer()
    minx.add(')', require('minx.recipe.fast_wrap')({
      close = ')'
    }))
    Keymap.spec(function()
      Keymap.send({
        Keymap.termcodes('/string<CR>i'),
        Keymap.termcodes('()<Left>'),
        { keys = ')', remap = true },
      }):await()
      assert.are.same({
        'local function example()',
        '  return (string.format("foo%sbar", "_"))',
        'end',
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)

  it('should wrap string 1', function()
    setup_buffer({
      text = {
        '"foobarbaz"'
      }
    })
    minx.add(')', require('minx.recipe.fast_wrap')({
      close = ')'
    }))
    Keymap.spec(function()
      Keymap.send({
        Keymap.termcodes('i'),
        Keymap.termcodes('()<Left>'),
        { keys = ')', remap = true },
      }):await()
      assert.are.same({
        '("foobarbaz")'
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)

  it('should wrap string 2', function()
    setup_buffer({
      text = {
        '[[foobarbaz]],'
      }
    })
    minx.add(')', require('minx.recipe.fast_wrap')({
      close = ')'
    }))
    Keymap.spec(function()
      Keymap.send({
        Keymap.termcodes('i'),
        Keymap.termcodes('()<Left>'),
        { keys = ')', remap = true },
      }):await()
      assert.are.same({
        '([[foobarbaz]]),'
      }, vim.api.nvim_buf_get_lines(0, 0, -1, false))
    end)
  end)

end)

