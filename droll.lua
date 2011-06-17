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
(Notice the space separating the roll from the token. Also, at least one space is required to separate each token.)
The action tokens are symbols that represent some kind of post processing of the data and may come at any order.
Currentily, the supported tokens are:
  '++'  will print the sum of all rolls;
  '{number}<' will print the top 'number' least roll values;
  '{number}>' will print the top 'number' greatest roll values.
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
	--Pattern: get positive or negative number(nrolls), d(separator), get number(type of dice), get 0+ tokens(actions), 0+ spaces 
	local _, tokens, nrolls, dice = string.find(command, "(%-?%d+)" .. "d" .. "(%d+)" .."%s*")
	if tokens then
		tokens = string.sub(command, tokens)
		tokens = string.match(tokens, "[%d%p%s]*")
	end

	nrolls, dice = tonumber(nrolls), tonumber(dice)
	return nrolls, dice, tokens
end

do
	tokens_actions = {}
	local sum_ex = "%+%+"
	local least_ex = "(%d+)".."%s*".."%<"
	local greatest_ex = "(%d+)".."%s*".."%>"

	tokens_actions[sum_ex] = function(rolls, tokens)
		-- sums all rolls
		print("\nThe sum of all rolls is: " .. table.sum(rolls))
	end

	tokens_actions[least_ex] = function(rolls, tokens)
		--gets top x least rolls (x is user defined)

		local top = string.match(tokens, least_ex)
		print("\nThe " .. top .. " least rolls are:")

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

	tokens_actions[greatest_ex] = function(rolls, tokens)
		--gets top x greatest rolls (x is user defined)

		local top = string.match(tokens, greatest_ex)
		print("\nThe " .. top .. " greatest rolls are:")

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
end

function has_token(tokens, token)
	return string.match(tokens, token)
end

function find_action(token)
	for pattern, action in pairs(tokens_actions) do
		if string.find(token, pattern) then
			return action
		end
	end
	return nil
end

function do_tokens(rolls, tokens)
	local SPACE_1 = "%s+"
	local SPACE_0 = "%s-"
	for token in string.gmatch(tokens, SPACE_1 .. "([%d%p][%d%p])" .. SPACE_0) do
		local action = find_action(token)
		if action then
			action(rolls, tokens)
		end
	end

end
