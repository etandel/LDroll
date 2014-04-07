require "utils"


------------begin functions and constants definitions------------

local function print_manual()
	print(
[[

This dice roller can roll amost any number of dice of any type (1000 d37 is possible)
The syntax of use is: '<number_of_rolls>d<type_of_dice> <action_tokens>'
(Notice the space separating the roll from the tokens. Also, at least one space is required to separate each token.)
The action tokens are symbols that represent some kind of post processing of the data and may come at any order.
Currentily, the supported tokens are:
  '++' will print the sum of all rolls;
  '..' will print all rolls;
  '+n' wil add 'n' to all rolls (warning: overwrites rolls)
  '-n' wil subtract 'n' to all rolls (warning: overwrites rolls)
  'n<' will print the 'n' least roll values;
  'n>' will print the 'n' greatest roll values.
Also, if the number of rolls is negative, the rolls will not be displayed, but dice will be rolled and tokens remain active.

A null(0) number of rolls or type of dice exits the program.

]]	)
end

local function roll(nrolls, dice)
	local rolls = {}

	for i=1,nrolls do
		rolls[#rolls+1] = math.random(dice)
	end

	return rolls
end


local function print_rolls(rolls)
	for i, val in ipairs(rolls) do
		print("Roll " .. i .. ": " .. val)
	end
	print("\n")
end

local function parse_command(command)
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
	local plus_ex = "%+" .. "(%d+)"
	local minus_ex = "%-" .. "(%d+)"
	local print_ex = "%.%."

	tokens_actions[print_ex] = function(rolls, token)
		print_rolls(rolls)
	end

	tokens_actions[plus_ex] = function(rolls, token)
		local factor = string.match(token, plus_ex)
		for index, roll in ipairs(rolls) do
			rolls[index] = roll + factor
		end
	end

	tokens_actions[minus_ex] = function(rolls, token)
		local factor = string.match(token, minus_ex)
		for index, roll in ipairs(rolls) do
			rolls[index] = roll - factor
		end
	end

	tokens_actions[sum_ex] = function(rolls, token)
		-- sums all rolls
		print("The sum of all rolls is: " .. table.sum(rolls))
		print("\n")
	end

	tokens_actions[least_ex] = function(rolls, token)
		--gets top x least rolls (x is user defined)

		local top = string.match(token, least_ex)
		print("The " .. top .. " least rolls are:")

		local sorted = table.copy(rolls)
		table.sort(sorted)
		for i=1,top do
			--checks invalid imput
			if i > #rolls then
				break
			end
			print("Value " .. i .. ": " .. sorted[i])
		end

		print("\n")
	end

	tokens_actions[greatest_ex] = function(rolls, token)
		--gets top x greatest rolls (x is user defined)

		local top = string.match(token, greatest_ex)
		print("The " .. top .. " greatest rolls are:")

		local sorted = table.copy(rolls)
		table.sort(sorted, function(a,b) return a>b end)
		for i=1,top do
			--checks invalid imput
			if i > #rolls then
				break
			end
			print("Value " .. i .. ": " .. sorted[i])
		end
		print("\n")
	end
end

local function has_token(tokens, token)
	return string.match(tokens, token)
end

local function find_action(token)
	for pattern, action in pairs(tokens_actions) do
		if string.find(token, pattern) then
			return action
		end
	end
	return nil
end

local function do_tokens(rolls, tokens)
	local SPACE_1 = "%s+"
	local SPACE_0 = "%s-"
	for token in string.gmatch(tokens, "%s+" .."([%d%p]+)".. "%s-") do
		local action = find_action(token)
		if action then
			action(rolls, token)
		end
	end

end


return {
    do_tokens = do_tokens,
    parse_command = parse_command,
    print_manual = print_manual,
    print_rolls = print_rolls,
    roll = roll,
}
