#!/usr/bin/env lua

package.path = './src/?.lua;' .. package.path

local eval = require'eval'


local function droll_main_loop()
    while true do
        print("Enter number of rolls, type of die and action tokens:\n")

        local prog = io.read()
        if prog:match'exit' then
            break
        else
            local result, msg = eval.run(prog)
            if result then
                eval.funcs.p(result)
            else
                io.write(msg, '\n\n\n')
            end
        end
    end
end


math.randomseed(os.time())
--d.print_manual()
droll_main_loop()
