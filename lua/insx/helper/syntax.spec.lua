local insx = require('insx')
local spec = require('insx.spec')
local Keymap = require('insx.kit.Vim.Keymap')

describe('insx.helper.syntax', function()
  local function assert_syntax(case, expected)
    local ok, err = pcall(function()
      Keymap.spec(function()
        spec.setup(case, {})
        assert.equals(insx.helper.syntax.in_string_or_comment(), expected)
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
