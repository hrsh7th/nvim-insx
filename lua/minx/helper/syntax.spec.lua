local minx = require('minx')
local spec = require('minx.spec')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.helper.syntax', function()
  local function assert_syntax(case, expected)
    local ok, err = pcall(function()
      spec.setup(case)
      Keymap.spec(function()
        Keymap.send('i'):await()
        assert.equals(minx.helper.syntax.in_string_or_comment(), expected)
      end)
    end)
    if not ok then
      ---@diagnostic disable-next-line: need-check-nil
      error(err.message, 2)
    end
  end

  it('should work', function()
    assert_syntax('(|"foo")', false)
    assert_syntax('("|foo")', true)
    assert_syntax('("foo|")', true)
    assert_syntax('("foo"|)', false)
    assert_syntax('(|[[foo]])', false)
    assert_syntax('([[|foo]])', true)
    assert_syntax('([[foo|]])', true)
    assert_syntax('([[foo]]|)', false)
  end)
end)
