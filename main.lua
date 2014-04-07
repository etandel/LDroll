#!/usr/bin/env lua

package.path = './src/?.lua;' .. package.path

local d = require "droll"


local function droll_main_loop()
    while true do
        print("Enter number of rolls, type of die and action tokens:\n")

        local nrolls, dice, tokens = d.parse_command(io.read())
        if nrolls and dice then
            --check whether program should stop executing
            if nrolls == 0 or dice == 0 then
                break
            else
                --if not, roll, store and print all rolls
                rolls = d.roll(math.abs(nrolls), dice)
                if nrolls > 0 then
                        d.print_rolls(rolls)
                end
                d.do_tokens(rolls, tokens)
            end
        else
            print(d.CMD_ERROR)
        end
    end
end


math.randomseed(os.time())
d.print_manual()
droll_main_loop()
