local parse = require'parser'.parse


-------------------------------------
----------------FUNCS----------------
-------------------------------------


local funcs = {}

function funcs.p(v)
    if type(v) == 'table' then
        for i, val in ipairs(v) do
            io.write("Roll " .. tostring(i) .. ": " .. tostring(val) .. "\n")
        end
        io.write("\n\n")
    else
        io.write("Result: " .. tostring(v) .. "\n\n")
    end
    return v
end

function funcs.sum(v)
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
end

function funcs.max(v)
    if type(v) == 'table' then
        return math.max(table.unpack(v))
    else
        return v
    end
end

function funcs.min(v)
    if type(v) == 'table' then
        return math.min(table.unpack(v))
    else
        return v
    end
end

local function slice(t, i, j)
    i = i or 1
    j = j or #t
    local newt = {}
    for idx = i, j do
        newt[#newt+1] = t[idx]
    end
    return newt
end

local function copy(t)
    local newt = {}
    for i, v in ipairs(t) do
        newt[i] = v
    end
    return newt
end

function funcs.minn(t, n)
    local cp = copy(t)
    table.sort(cp)
    return slice(cp, 1, n)
end

function funcs.maxn(t, n)
    local cp = copy(t)
    table.sort(cp)
    return slice(cp, #t-n+1)
end


function funcs.err(msg)
    return error('Error: ' .. (msg or ''))
end


-------------------------------------
----------------OPS------------------
-------------------------------------


local whole_op = function (op)
    return function(a, b)
        if type(a) == 'table' then
            a = funcs.sum(a)
        end
        if type(b) == 'table' then
            b = funcs.sum(b)
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


-------------------------------------
----------------MISC-----------------
-------------------------------------


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
    elseif node.func then
        local func = node.func

        local args = {}
        for i, arg in ipairs(func) do
            args[i] = eval(arg)
        end

        f = funcs[func.ident]
        if not f then
            return funcs.err('function "' .. func.ident .. '" not found.')
        else
            local ok, res = pcall(f, table.unpack(args))
            if not ok then
                return funcs.err('bad call to function "' .. func.ident .. '".')
            else
                return res
            end
        end

    else
        return eval(node[1])
    end
end


local function msg_handler(m)
    return m:match('.-:%d+:%s+(.+)') or m
end

local function run(code)
    local ast = parse(code)
    if ast then
        local ok, res = xpcall(eval, msg_handler, ast)
        if not ok then
            return nil, res
        else
            return res
        end
    else
        return nil, 'Syntax error'
    end
end


return {
    eval = eval,
    ops = ops,
    roll = roll,
    funcs = funcs,
    run = run,
}
