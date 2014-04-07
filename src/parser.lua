local lpeg = require 'lpeg'

local P, R, S, V = lpeg.P, lpeg.R, lpeg.S, lpeg.V

local C, Cg, Cs, Ct = lpeg.C, lpeg.Cg, lpeg.Cs, lpeg.Ct


local space = P' '^0
local number = R'09'^1
local roll = Ct(Cg(number, 'ndice') * 'd' * Cg(number, 'dsize'))
local atom = Ct(Cg(roll, 'roll') + Cg(number, 'const')) * space
local op = Cg(S'-+', 'op') * space
local open = '(' * space
local close = ')' * space

local Term, Exp = V'Term', V'Exp'
local grammar = P{Exp,
    Exp = Ct(Term * (op * Term)^0),
    Term = atom + open * Exp * close,
}

grammar = space * grammar * space


local parse = function (str)
    return grammar:match(str)
end


return {
    parse = parse,
}
