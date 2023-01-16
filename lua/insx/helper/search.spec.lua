local insx = require('insx')
local spec = require('insx.spec')
local Keymap = require('insx.kit.Vim.Keymap')

describe('insx.helper.search', function()
  local function assert_check(case, check, option)
    local ok, err = pcall(function()
      spec.setup(case, option)
      Keymap.spec(function()
        Keymap.send('i'):await()
        check()
      end)
    end)
    if not ok then
      ---@diagnostic disable-next-line: need-check-nil
      error(err.message, 2)
    end
  end

  it('should work', function()
    assert_check('(|"foo")', function()
      assert.are.same({ 0, 1 }, insx.helper.search.get_pair_open('(', ')'))
    end)
    assert_check('(|"foo")', function()
      assert.are.same({ 0, 6 }, insx.helper.search.get_pair_close('(', ')'))
    end)
    assert_check('("|foo")', function()
      assert.are.same({ 0, 2 }, insx.helper.search.get_pair_open('"', '"'))
    end)
    assert_check('("|foo")', function()
      assert.are.same({ 0, 5 }, insx.helper.search.get_pair_close('"', '"'))
    end)
    assert_check('"|"', function()
      assert.are.same({ 0, 0 }, insx.helper.search.get_next([["\%#]]))
      assert.are.same({ 0, 1 }, insx.helper.search.get_next([[\%#"]]))
    end)
    assert_check('"|"', function()
      assert.are.same({ 0, 0 }, insx.helper.search.get_prev([["\%#]]))
      assert.are.same({ 0, 1 }, insx.helper.search.get_prev([[\%#"]]))
    end)

    -- nvim-insx does not support nested strings.
    assert_check('`|foo${`bar`}baz`', function()
      assert.are.same({ 0, 6 }, insx.helper.search.get_pair_close('`', '`'))
    end, { filetype = 'typescript' })

    -- but escaped string start token can be skipped.
    assert_check([["|foo\"bar"]], function()
      assert.are.same({ 0, 9 }, insx.helper.search.get_pair_close('"', '"'))
    end)
  end)
end)
