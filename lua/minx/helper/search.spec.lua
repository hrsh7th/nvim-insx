local minx = require('minx')
local spec = require('minx.spec')
local Keymap = require('minx.kit.Vim.Keymap')

describe('minx.helper.search', function()
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
      assert.are.same({ 0, 1 }, minx.helper.search.get_pair_open('(', ')'))
    end)
    assert_check('(|"foo")', function()
      assert.are.same({ 0, 6 }, minx.helper.search.get_pair_close('(', ')'))
    end)
    assert_check('("|foo")', function()
      assert.are.same({ 0, 2 }, minx.helper.search.get_pair_open('"', '"'))
    end)
    assert_check('("|foo")', function()
      assert.are.same({ 0, 5 }, minx.helper.search.get_pair_close('"', '"'))
    end)
    assert_check('"|"', function()
      assert.are.same({ 0, 0 }, minx.helper.search.get_next([["\%#]]))
      assert.are.same({ 0, 1 }, minx.helper.search.get_next([[\%#"]]))
    end)
    assert_check('"|"', function()
      assert.are.same({ 0, 0 }, minx.helper.search.get_prev([["\%#]]))
      assert.are.same({ 0, 1 }, minx.helper.search.get_prev([[\%#"]]))
    end)

    -- nvim-minx does not support nested strings.
    assert_check('`|foo${`bar`}baz`', function()
      assert.are.same({ 0, 6 }, minx.helper.search.get_pair_close('`', '`'))
    end, { filetype = 'typescript' })

    -- but escaped string start token can be skipped.
    assert_check([["|foo\"bar"]], function()
      assert.are.same({ 0, 9 }, minx.helper.search.get_pair_close('"', '"'))
    end)
  end)
end)
