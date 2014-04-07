#!/usr/bin/env lua

package.path = './src/?.lua;' .. package.path

local eval = require'eval'.eval
local parse = require'parser'.parse


local CMD_ERROR = "Wrong command. Please, stick to the instructions.\n\n\n"


local function print_result(result)
    if type(result) == 'table' then
        for i, val in ipairs(result) do
            io.write("Roll " .. tostring(i) .. ": " .. tostring(val) .. "\n")
        end
        io.write("\n\n")
    else
        io.write("Result: " .. tostring(result) .. "\n\n")
    end
end


local function droll_main_loop()
    while true do
        print("Enter number of rolls, type of die and action tokens:\n")

        local prog = io.read()
        if prog:match'exit' then
            break
        else
            local ast = parse(prog)
            if not ast then
                io.write(CMD_ERROR)
            else
                local result = eval(ast)
                print_result(result)
            end
        end
    end
end


math.randomseed(os.time())
--d.print_manual()
droll_main_loop()
