local insx = require('insx')
local spec = require('insx.spec')

describe('insx.recipe.pair_spacing', function()
  describe('increase', function()
    it('should work', function()
      insx.add(
        ' ',
        require('insx.recipe.pair_spacing').increase({
          open_pat = insx.helper.regex.esc('('),
          close_pat = insx.helper.regex.esc(')'),
        })
      )
      spec.assert('(|)', ' ', '( | )')
      spec.assert('( |)', ' ', '(  |  )')
      spec.assert('(| )', ' ', '( | )')
      spec.assert('(|foo)', ' ', '( |foo )')
      spec.assert('( |foo)', ' ', '(  |foo  )')
      spec.assert('(|foo )', ' ', '( |foo )')
    end)
  end)
  describe('decrease', function()
    it('should work', function()
      insx.add(
        '<BS>',
        require('insx.recipe.pair_spacing').decrease({
          open_pat = insx.helper.regex.esc('('),
          close_pat = insx.helper.regex.esc(')'),
        })
      )
      spec.assert('( | )', '<BS>', '(|)')
      spec.assert('(  | )', '<BS>', '( | )')
      spec.assert('( |  )', '<BS>', '(|)')
      spec.assert('( |foo )', '<BS>', '(|foo)')
      spec.assert('(  |foo )', '<BS>', '( |foo )')
      spec.assert('( |foo  )', '<BS>', '(|foo)')
    end)
  end)
end)
