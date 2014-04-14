#!/usr/bin/env lua

local ldroll = require'ldroll.ldroll'


local function droll_main_loop()
    while true do
        print("Enter number of rolls, type of die and action tokens:\n")

        local prog = io.read()
        if prog:match'exit' then
            break
        else
            local result, msg = ldroll.run(prog)
            if result then
                ldroll.funcs.p(result)
            else
                io.write(msg, '\n\n\n')
            end
        end
    end
end


math.randomseed(os.time())
--d.print_manual()
droll_main_loop()
