require 'utils'

local parse = require'parser'.parse


local whole_op = function (op)
    return function(a, b)
        if type(a) == 'table' then
            a = table.sum(a)
        end
        if type(b) == 'table' then
            b = table.sum(b)
        end
        return op(a, b)
    end
end


local rollwise_op = function (op)
    return function(a, b)
        local rolls, const
        if type(a) == 'table' then
            rolls, const = a, b
        elseif type(b) == 'table' then
            rolls, const = b, a
        end

        local newrolls = {}
        for i, v in ipairs(rolls) do
            newrolls[i] = op(v, const)
        end
        return newrolls
    end
end


local ops = {
    ['+'] = whole_op(function(a,b) return a + b end),
    ['-'] = whole_op(function(a,b) return a - b end),

    ['.+'] = rollwise_op(function(a,b) return a + b end),
    ['.-'] = rollwise_op(function(a,b) return a - b end),
}


local roll = function (roll_args)
    local rolls = {}
    for i = 1, roll_args.ndice do
        rolls[i] = math.random(1, roll_args.dsize)
    end
    return rolls
end


local funcs = {
    sum = function(v)
        local s
        if type(v) == 'table' then
            s = 0
            for _, i in ipairs(v) do
                s = s + i
            end
        else
            s = v
        end
        return s
    end,
}


local function eval (node)
    if node.const then
        return tonumber(node.const)
    elseif node.roll then
        return roll(node.roll)
    elseif node.op then
        return ops[node.op](eval(node[1]), eval(node[2]))
    elseif node.func then
        local func = node.func

        local args = {}
        for i, arg in ipairs(func) do
            args[i] = eval(arg)
        end

        return funcs[func.ident](table.unpack(args))
    else
        return eval(node[1])
    end
end


return {
    eval = eval,
    ops = ops,
    roll = roll,
    funcs = funcs,
}
