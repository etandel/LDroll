local function matches(patt, s)
    return assert.equals(#s+1, patt:match(s))
end


local p = require 'parser'


describe('Pattern tests', function()
    it('should match constants', function()
        local s = '140'
        matches(p.term, s) 
    end)

    it('should match single-digit rolls', function()
        local s = '1d6'
        matches(p.term, s) 
    end)

    it('should match multi-digit rolls', function()
        local s = '10d62'
        matches(p.term, s) 
    end)

    it('should match rolls followed by ops', function()
        local s = '10d62+2'
        matches(p.term, s) 
    end)

    it('should match rolls followed by ops (with spaces)', function()
        local s = ' 10d62 + 2 '
        matches(p.term, s) 
    end)

    it('should match parenthised single rolls', function()
        local s = '( 1d6 )'
        matches(p.term, s) 
    end)

    it('should match parenthised ops', function()
        local s = '( 1d6 + 2 )'
        matches(p.term, s) 
    end)

    it('should match nested terms', function()
        local s = '1d6 + (2d6 + 4)'
        matches(p.term, s) 
    end)

    it('should match deeply nested terms', function()
        local s = '(1d6 +1) + (2d6 + (2 + 4d10))'
        matches(p.term, s) 
    end)
end)
