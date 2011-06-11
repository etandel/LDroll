--[[

This file has all LuaDroll specific functions and constants declarations.

Copyright (C) 2011 Elias Tandel Barrionovo <elias.tandel@gmail.com>

This program is free software; you can redistribute it and/or
modify it under the terms of the GNU General Public License
as published by the Free Software Foundation; either version 2
of the License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program; if not, write to the Free Software
Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

]]--

require "utils"


------------begin functions and constants definitions------------
CMD_ERROR = "Wrong command. Please, stick to the instructions."

function print_manual()
	print(
[[

This dice roller can roll amost any number of dice of any type (1000 d37 is possible)
The syntax of use is: '<number_of_rolls>d<type_of_dice> <action_tokens>'
(There must be one, and only one 'd' between the number of rolls and the type of dice.)
The action tokens are symbols that represent some kind of post processing of the data and may come at any order.
Currentily, the supported tokens are:
  '+'  will print the sum of all rolls;
  '<{number}' will print the top 'number' least roll values;
  '>{number}' will print the top 'number' greatest roll values.
Also, if the number of rolls is negative, the rolls will not be displayed, but dice will be rolled and tokens remain active.

A null(0) number of rolls or type of dice exits the program.
]]	)
end

function roll(nrolls, dice) 
	local rolls = {}

	for i=1,nrolls do
		rolls[#rolls+1] = math.random(dice)
	end 

	return rolls
end


function print_rolls(rolls) 
	for i, val in ipairs(rolls) do
		print("Roll " .. i .. ": " .. val) 
	end
end

function parse_command(command)
	--Pattern: get positive or negative number(nrolls), d(separator), get number(type of dice), 0+ spaces, get 0+ tokens(actions) 
	local _, tokens, nrolls, dice = string.find(command, "(%-?%d+)" .. "d" .. "(%d+)" .."%s*")
	if tokens then
		tokens = string.sub(command, tokens+1)
		tokens = string.match(tokens, "[%d%p]*")
	end

	nrolls, dice = tonumber(nrolls), tonumber(dice)
	return nrolls, dice, tokens
end

local function gen_tokens_actions()
	local tokens_actions = {}
	tokens_actions.sum_ex = "%+%+"
	tokens_actions.least_ex = "%<".."%s*".."(%d+)"
	tokens_actions.greatest_ex = "%>".."%s*".."(%d+)"

	tokens_actions[tokens_actions.sum_ex] = function(rolls, tokens)
		-- sums all rolls
		print("\nThe sum of all rolls is: " .. table.sum(rolls))
	end

	tokens_actions[tokens_actions.least_ex] = function(rolls, tokens)
		--gets top x least rolls (x is user defined)

		local top = string.match(tokens, tokens_actions.least_ex)
		print("\nThe top " .. top .. " least rolls are:")

		local sorted = table.copy(rolls)
		table.sort(sorted)
		for i=1,top do
			--checks invalid imput
			if i > #rolls then
				break
			end
			print("Value " .. i .. ": " .. sorted[i])
		end
	end

	tokens_actions[tokens_actions.greatest_ex] = function(rolls, tokens)
		--gets top x greatest rolls (x is user defined)

		local top = string.match(tokens, tokens_actions.greatest_ex)
		print("\nThe top " .. top .. " greatest rolls are:")

		local sorted = table.copy(rolls)
		table.sort(sorted, function(a,b) return a>b end)
		for i=1,top do
			--checks invalid imput
			if i > #rolls then
				break
			end
			print("Value " .. i .. ": " .. sorted[i])
		end
	end

	return tokens_actions
end
tokens_actions = gen_tokens_actions()

function has_token(tokens, token)
	return string.match(tokens, token)
end

function do_tokens(rolls, tokens)
	for token, action in pairs(tokens_actions) do
		if has_token(tokens, token) then
			action(rolls, tokens)
		end
	end
end

--------------------begin configs------------------------
