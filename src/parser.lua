local lpeg = require 'lpeg'

local P, R, S, V = lpeg.P, lpeg.R, lpeg.S, lpeg.V


local number = R'09'^1
local roll = number * 'd' * number
local atom = roll + number

local sep = P' '^0

local op = S'-+'

local function separated(...)
    local p = sep
    for i = 1, select('#', ...) do
        p = p * select(i, ...) * sep
    end
    return p
end

local term = P{
    'S',
    S = separated(V'A', op, V'A') + V'A',
    A = separated('(', V'S',')') + atom,
}


return {
    term = term,
}
