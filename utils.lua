--[[

This file has a few general handy functions for table manipulation.

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

--]]


function table.sum(array)
	local sum = 0
	for i,value in ipairs(array) do
		sum = sum + value
	end
	return sum
end

function table.copy(t)
	local cp = {}
	for i,v in pairs(t) do
		cp[i] = v
	end
	return cp
end

function table.getindex(t, value)
	for k,v in pairs(t) do
		if v == value then
			return k
		end
	end
	return nil
end
