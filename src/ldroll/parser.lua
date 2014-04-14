local lpeg = require 'lpeg'

local P, R, S, V = lpeg.P, lpeg.R, lpeg.S, lpeg.V

local C, Cg, Cs, Ct = lpeg.C, lpeg.Cg, lpeg.Cs, lpeg.Ct

local function Ctg(p, ...)
    return Ct(Cg(p, ...))
end


local space = P' '^0
local number = R'09'^1
local identifier = Cg(R'az'^1, 'ident')
local roll = Ct(Cg(number, 'ndice') * 'd' * Cg(number, 'dsize'))
local atom = Ct(Cg(roll, 'roll') + Cg(number, 'const')) * space
local op = Cg(P'.+' + P'.-' + S'-+', 'op') * space
local open = '(' * space
local close = ')' * space

local Term, Exp, Func, ArgList  = V'Term', V'Exp', V'Func', V'ArgList'
local grammar = P{Exp,
    Exp = Ct(Term * (op * Term)^0),
    Term = Ctg(Ct(Func), 'func') + atom + open * Exp * close,
    Func = identifier * open * ArgList * close,
    ArgList = (Term * space)^0,
}

grammar = space * grammar * space


local parse = function (str)
    return grammar:match(str)
end


return {
    parse = parse,
}
