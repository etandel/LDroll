#!/usr/bin/lua
--[[
This file has the main program and is the one that should be executed by the Lua interpreter.

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


require "droll"
math.randomseed(os.time())

function droll_main_loop()
        while true do

                print("\nEnter number of rolls, type of die and action tokens:")

                local nrolls, dice, tokens = parse_command(io.read())

                if nrolls and dice then
                        --check whether program should stop executing   
                        if nrolls == 0 or dice == 0 then
                                break 
                        else
                        --if not, roll, store and print all rolls
                                rolls = roll(math.abs(nrolls), dice)
                                if nrolls > 0 then
                                        print_rolls(rolls)
                                end
                                do_tokens(rolls, tokens)
                        end
                else
                        print(CMD_ERROR)
                end

        end
end


print_manual()
droll_main_loop()
