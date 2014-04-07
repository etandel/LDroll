require 'utils'

local parse = require'parser'.parse


local ops = {
    ['+'] = function (a, b)
        if type(a) == 'table' then
            a = table.sum(a)
        end
        if type(b) == 'table' then
            b = table.sum(b)
        end
        return a + b
    end,

    ['-'] = function (a, b)
        if type(a) == 'table' then
            a = table.sum(a)
        end
        if type(b) == 'table' then
            b = table.sum(b)
        end
        return a - b
    end,
}


local roll = function (roll_args)
    local rolls = {}
    for i = 1, roll_args.ndice do
        rolls[i] = math.random(1, roll_args.dsize)
    end
    return rolls
end


local function eval (node)
    if node.const then
        return tonumber(node.const)
    elseif node.roll then
        return roll(node.roll)
    elseif node.op then
        return ops[node.op](eval(node[1]), eval(node[2]))
    else
        return eval(node[1])
    end
end


return {
    eval = eval,
    ops = ops,
    roll = roll,
}
