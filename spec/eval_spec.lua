local parse = require 'parser'.parse
local eval = require 'eval'
local funcs, ops, roll = eval.funcs, eval.ops, eval.roll
local eval, run = eval.eval, eval.run


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

    it('should eval funcs', function()
        local s = spy.on(funcs, 'sum')
            eval(parse('sum(3d6)'))
            call = s.calls[1]
            assert.equals(1, call.n)
            assert.is.table(call[1])
        s:revert()
    end)

    it('should call err when func not found', function()
        local s = stub(funcs, 'err')
            eval(parse('bla(243)'))
            assert.stub(s).called_with('function "bla" not found.')
        s:revert()
    end)
end)


describe('run() tests', function()
    it('should return nil on syntax error', function()
        r, msg = run('----')
        assert.are.same(r, nil)
        assert.equals(msg, 'Syntax error')
    end)

    it('should return whatever eval() returns', function()
        assert.equal(1, run('1'))

        local code = 'blaaa()'
        local r, m = run(code)
        assert.are.same(r, nil)
        assert.equals(select(2, eval(parse(code))), m)
    end)
end)


describe('Ops tests', function()
    describe('whole add tests', function()
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

    describe('whole sub tests', function()
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

    describe('rollwise add tests', function()
        local add = ops['.+']

        it('should add const and seq', function()
            local rolls = {2, 5}
            assert.are.same({3, 6}, add(1, rolls))
        end)

        it('should add seq and const', function()
            local rolls = {2, 5}
            assert.are.same({3, 6}, add(rolls, 1))
        end)
    end)

    describe('rollwise sub tests', function()
        local sub = ops['.-']

        it('should sub const and seq', function()
            local rolls = {2, 5}
            assert.are.same({1, 4}, sub(1, rolls))
        end)

        it('should sub seq and const', function()
            local rolls = {2, 5}
            assert.are.same({1, 4}, sub(rolls, 1))
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


describe('func tests', function()
    describe('sum()', function()
        local f = funcs.sum

        it('should sum rolls', function()
            assert.equals(7, f{1, 2, 4})
        end)

        it('should return passing const ', function()
            assert.equals(1, f(1))
        end)
    end)

    describe('max()', function()
        local f = funcs.max

        it('should find max', function()
            assert.equals(8, f{1, 8, 4, 8})
        end)

        it('should return passing const ', function()
            assert.equals(1, f(1))
        end)
    end)

    describe('min()', function()
        local f = funcs.min

        it('should find min', function()
            assert.equals(4, f{123, 4, 4, 8})
        end)

        it('should return passing const ', function()
            assert.equals(1, f(1))
        end)
    end)

    describe('minn()', function()
        local f = funcs.minn

        it('should find least 3', function()
            assert.are.same({1, 3, 4}, f({4, 8, 3, 1, 5}, 3))
        end)
    end)

    describe('maxn()', function()
        local f = funcs.maxn

        it('should find largest 3', function()
            assert.are.same({5, 8, 15}, f({4, 8, 3, 15, 5}, 3))
        end)
    end)

    describe('p()', function()
        local f = funcs.p

        it('should return passing arg', function()
            local s = stub(io, 'write')
                local t = {}
                f(t)
                assert.equals(t, f(t))
                assert.equals(1, f(1))
            s:revert()
        end)
    end)

    describe('err()', function()
        local f = funcs.err

        it('should return nil + msg', function()
            local s = stub(io, 'write')
                local m = 'blabla'
                local r, msg = f(m)
                assert.are.same(r, nil)
                assert.equal('Error: ' .. m, msg)
            s:revert()
        end)
    end)
end)
