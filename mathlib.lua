--[[
	Math Library
	
	A simple extended library to use for animations, smooth transition, etc.
	
	Functions:
	----------------------------------------------------------------------------------------------------------
	
	mathlib.Lerp ( number a , number b , number x ) -> number
		This function returns the lerp value of x between a and b.
	
	----------------------------------------------------------------------------------------------------------
	
	mathlib.Interpolate ( number a , number b , number x ) -> number
		This function returns the inverse lerp value of x between a and b.
	
	----------------------------------------------------------------------------------------------------------
	
	mathlib.Clamp ( number a , number b , number x ) -> number
		Returns x clamped with the minimum a and the maximum b.
	
	----------------------------------------------------------------------------------------------------------
	
	mathlib.Loopcheck ( number a , number b , number x ) -> bool
		Tries to calculate the looping value. If b is less than a, this function returns whether x is outside
		the range. Otherwise, the result is the exact opposite.
		
		If for some reason a and b are equal, this function always returns false.
	
	----------------------------------------------------------------------------------------------------------
]]

local mod = {}
local min, max = math.min, math.max
function mod.Lerp(a, b, x)
	for i, n in ipairs{a, b, x} do
		if type(n) ~= "number" then
			error("bad argument at index "..i..": number expected (got "..type(n)..")", 2)
		end
	end
	return a+(b-a) * x
end
function mod.Interpolate(a, b, x)
	for i, n in ipairs{a, b, x} do
		if type(n) ~= "number" then
			error("bad argument at index "..i..": number expected (got "..type(n)..")", 2)
		end
	end
	if b < a then
		return 1-mod.Interpolate(b, a, x)
	end
	if a == b then
		return (x > a) and 1 or 0
	end
	if x < a then
		return 0
	end
	if x > b then
		return 1
	end
	local diff = b - a
	local xd = (x - a) / diff
	return xd
end

function mod.Loopcheck(a, b, x)
	for i, n in ipairs{a, b, x} do
		if type(n) ~= "number" then
			error("bad argument at index "..i..": number expected (got "..type(n)..")", 2)
		end
	end
	if b < a then
		return not mod.Loopcheck(b, a, x)
	end
	if a == b then
		return false
	end
	return x >= a and x < b
end

function mod.Clamp(a, b, x)
	for i, n in ipairs{a, b, x} do
		if type(n) ~= "number" then
			error("bad argument at index "..i..": number expected (got "..type(n)..")", 2)
		end
	end
	if b < a then
		return mod.Clamp(b, a, x)
	end
	if a == b then
		return a
	end
	return max(min(x, b), a)
end

return mod