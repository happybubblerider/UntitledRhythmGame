--[[
	String Library
	
	A simple extended library to use for string parsing, matching, and checking.
	
	Functions:
	----------------------------------------------------------------------------------------------------------
	
	stringlib.StartsWith ( string str , string prefix ) -> string or nil
		If the string str begins with prefix, then this function returns the remaining portion of it.
		Otherwise, it returns nil.
	
	----------------------------------------------------------------------------------------------------------
	
	stringlib.EndsWith ( string str , string suffix ) -> string or nil
		If the string str ends with suffix, then this function returns the remaining portion of it.
		Otherwise, it returns nil.
	
	----------------------------------------------------------------------------------------------------------
	
	stringlib.Clip ( string str , string delim ) -> string , string or nil
		Checks the string str for the first occurrance of delim, then returns the parts before and after that.
		This function returns nil if no match is found.
	
	----------------------------------------------------------------------------------------------------------
	
	stringlib.Split ( string str , string sep ) -> array of string
		This function returns a table of portions between occurances of sep in str. This is a Lua wrapper for
		Javascript's string.split method.
	
	----------------------------------------------------------------------------------------------------------
]]

local mod = {}
local sub, match = string.sub, string.match
local find = string.find

local insert = table.insert

function mod.StartsWith(str, sym)
	for i, j in ipairs{str, sym} do
		if type(j) ~= "string" then
			error("bad argument at index "..i..": string expected (got "..type(j)..")", 2)
		end
	end
	local symp = sub(str, 1, #sym)
	if symp == sym then
		return sub(str, #sym+1)
	end
	return nil
end
function mod.EndsWith(str, sym)
	for i, j in ipairs{str, sym} do
		if type(j) ~= "string" then
			error("bad argument at index "..i..": string expected (got "..type(j)..")", 2)
		end
	end
	local symp = sub(str, -#sym, -1)
	if sym == symp then
		return sub(str, 1, -(#sym+1))
	end
	return nil
end

function mod.Clip(str, sym)
	local fm, fn = find(str, sym, 1, true)
	if fm then
		return sub(str, 1, fm-1), sub(str, fn+1)
	end
end
local clip = mod.Clip
function mod.Split(str, sym)
	for i, j in ipairs{str, sym} do
		if type(j) ~= "string" then
			error("bad argument at index "..i..": string expected (got "..type(j)..")", 2)
		end
	end
	local split = {}
	local subject = str
	while true do
		local subj, suff = clip(subject, sym)
		if subj == nil then
			break
		end
		insert(split, subj)
		subject = suff
	end
	insert(split, subject)
	return split
end

return mod