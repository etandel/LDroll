local parse = require 'parser'.parse
local eval = require 'eval'
local eval, ops, roll = eval.eval, eval.ops, eval.roll


describe('Eval tests', function()
    it('should eval constants', function()
        local s = '140'
        assert.equals(140, eval(parse(s)))
    end)

    it('should eval sum of consts', function()
        local s = '140 + 2'
        assert.equals(142, eval(parse(s)))
    end)

    it('should eval subtraction of consts', function()
        local s = '140 - 40'
        assert.equals(100, eval(parse(s)))
    end)

    it('should eval nested const ops', function()
        local s = '(140 - 40) + 10'
        assert.equals(110, eval(parse(s)))
    end)

    it('should eval deeply nested const ops', function()
        local s = '(140 - (40 + (15 - 5))) + 10'
        assert.equals(100, eval(parse(s)))
    end)

    it('should eval parenth\'d deeply nested const ops', function()
        local s = '((140 - (40 + (15 - 5))) + 10)'
        assert.equals(100, eval(parse(s)))
    end)
end)


describe('Ops tests', function()
    describe('add tests', function()
        local add = ops['+']

        it('should add two constants', function()
            assert.equals(4, add(1, 3))
        end)

        it('should add const and seq', function()
            assert.equals(6, add(1, {2, 3}))
        end)

        it('should add seq and const', function()
            assert.equals(6, add({2, 3}, 1))
        end)

        it('should add two seqs', function()
            assert.equals(7, add({2, 3}, {1, 1}))
        end)
    end)

    describe('sub tests', function()
        local sub = ops['-']

        it('should sub two constants', function()
            assert.equals(-2, sub(1, 3))
        end)

        it('should sub const and seq', function()
            assert.equals(-4, sub(1, {2, 3}))
        end)

        it('should sub seq and const', function()
            assert.equals(4, sub({2, 3}, 1))
        end)

        it('should sub two seqs', function()
            assert.equals(3, sub({2, 3}, {1, 1}))
        end)
    end)
end)


describe('roll tests', function()
    it('should roll ndice times', function()
        local roll_args = {ndice = 5, dsize = 6}
        local rolls = roll(roll_args)
        assert.equals(roll_args.ndice, #rolls)
    end)
end)
