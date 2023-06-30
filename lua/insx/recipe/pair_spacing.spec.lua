local insx = require('insx')
local spec = require('insx.spec')
local esc = require('insx.helper.regex').esc

describe('insx.recipe.pair_spacing', function()
  before_each(insx.clear)
  describe('increase with multichar', function()
    it('should work', function()
      insx.add(
        ' ',
        require('insx.recipe.pair_spacing').increase({
          open_pat = esc('('),
          close_pat = esc(')'),
        })
      )
      spec.assert('(|)', ' ', '( | )')
      spec.assert('( |)', ' ', '(  |  )')
      spec.assert('(| )', ' ', '( | )')
      spec.assert('(|foo)', ' ', '( |foo )')
      spec.assert('( |foo)', ' ', '(  |foo  )')
      spec.assert('(|foo )', ' ', '( |foo )')
    end)
    it('should work with multichar', function()
      insx.add(
        ' ',
        require('insx.recipe.pair_spacing').increase({
          open_pat = esc('<!--'),
          close_pat = esc('-->'),
        })
      )
      spec.assert('<!--|-->', ' ', '<!-- | -->')
      spec.assert('<!-- |-->', ' ', '<!--  |  -->')
      spec.assert('<!--| -->', ' ', '<!-- | -->')
      spec.assert('<!--|foo-->', ' ', '<!-- |foo -->')
      spec.assert('<!-- |foo-->', ' ', '<!--  |foo  -->')
      spec.assert('<!--|foo -->', ' ', '<!-- |foo -->')
    end)
  end)
  describe('decrease', function()
    it('should work', function()
      insx.add(
        '<BS>',
        require('insx.recipe.pair_spacing').decrease({
          open_pat = esc('('),
          close_pat = esc(')'),
        })
      )
      spec.assert('( | )', '<BS>', '(|)')
      spec.assert('(  | )', '<BS>', '( | )')
      spec.assert('( |  )', '<BS>', '(|)')
      spec.assert('( |foo )', '<BS>', '(|foo)')
      spec.assert('(  |foo )', '<BS>', '( |foo )')
      spec.assert('( |foo  )', '<BS>', '(|foo)')
    end)
    it('should work with multichar', function()
      insx.add(
        '<BS>',
        require('insx.recipe.pair_spacing').decrease({
          open_pat = esc('<!--'),
          close_pat = esc('-->'),
        })
      )
      spec.assert('<!-- | -->', '<BS>', '<!--|-->')
      spec.assert('<!--  | -->', '<BS>', '<!-- | -->')
      spec.assert('<!-- |  -->', '<BS>', '<!--|-->')
      spec.assert('<!-- |foo -->', '<BS>', '<!--|foo-->')
      spec.assert('<!--  |foo -->', '<BS>', '<!-- |foo -->')
      spec.assert('<!-- |foo  -->', '<BS>', '<!--|foo-->')
    end)
  end)
end)
