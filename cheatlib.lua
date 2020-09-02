--[[
	CHEAT LIBRARY
	
	This library can be used for detecting Konami code and other input sequences
]]

local cheatlib = {}

local cheats = {}
-- Cheats are objects stored in tables


-- CONSTRUCTOR |
--  & METHODS  V
--[[
	
	----------------------------------------------------------------------------------------------------------
	
	cheatlib.NewCheat(key1, key2, ...)
		Creates a new Cheat. These types of objects can typically be stored and used for the love.keypressed event, but can listen to other things, like object clicks, button presses, and other stuff.
	
	cheat:Input(key)
		Triggers the key. If the wrong key is triggered, the cheat basically starts back to the beginning.
	
	cheat:Clear()
		This method clears the cheats back to the first. This can be used in cases where the client reaches the cooldown threshold, as to avoid spam on multiplayer games.
	
	----------------------------------------------------------------------------------------------------------
	
]]
function cheatlib.NewCheat(...)
	
	for i, v in ipairs{...} do
		if type(v) ~= "string" then
			error("bad argument at index "..i..": string expected (got "..type(v)..")", 2)
		end
	end
	local cheat = {
		sequence = {...},
		input = 1
	}
	local obj = {}
	local methods = {}
	setmetatable(obj, {__index = methods})
	cheats[obj] = cheat
	function methods:Input(str)
		if type(str) ~= "string" then
			error("bad argument at index 1: string expected (got "..type(str)..")", 2)
		end
		local c = cheat.sequence[cheat.input]
		if str == c then
			if cheat.input == #cheat.sequence then
				cheat.input = 1
				return true
			end
			cheat.input = cheat.input + 1
			return false
		end
		cheat.input = 1
		return false
	end
	function methods:Clear()
		cheat.input = 1
	end
	return obj
end
return cheatlib