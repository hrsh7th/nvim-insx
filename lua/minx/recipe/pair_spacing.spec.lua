local minx = require('minx')
local spec = require('minx.spec')

describe('minx.recipe.pair_spacing', function()
  describe('increase_pair_spacing', function()
    it('should work', function()
      minx.add(' ', require('minx.recipe.pair_spacing').increase_pair_spacing({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      }))
      spec.assert('(|)', ' ', '( | )')
      spec.assert('( |)', ' ', '(  |  )')
      spec.assert('(| )', ' ', '( | )')
      spec.assert('(|foo)', ' ', '( |foo )')
      spec.assert('( |foo)', ' ', '(  |foo  )')
      spec.assert('(|foo )', ' ', '( |foo )')
    end)
  end)
  describe('decrease_pair_spacing', function()
    it('should work', function()
      minx.add('<BS>', require('minx.recipe.pair_spacing').decrease_pair_spacing({
        open_pat = minx.helper.regex.esc('('),
        close_pat = minx.helper.regex.esc(')'),
      }))
      spec.assert('( | )', '<BS>', '(|)')
      spec.assert('(  | )', '<BS>', '( | )')
      spec.assert('( |  )', '<BS>', '(|)')
      spec.assert('( |foo )', '<BS>', '(|foo)')
      spec.assert('(  |foo )', '<BS>', '( |foo )')
      spec.assert('( |foo  )', '<BS>', '(|foo)')
    end)
  end)
end)
