--[[
	Table Library
	
	A simple extended library to use for table replication and templating.
	
	Functions:
	----------------------------------------------------------------------------------------------------------
	
	tablelib.DeepCopy ( any val ) -> any
		This function performs a deep copy of val. Reference looping which can cause the game to crash during
		copying is not allowed. If val is a userdata, metatables are copied as well. Packages can override
		this by using the __metatable metafield. Userdata is simply not copied, as there is no API for
		determining how this can be done. If it is a number, function, or boolean, then the value itself is
		returned, as these types of values do not use referencing, and therefore can be copied directly by
		assigning them on different variables. However, you can modify this function if you have an API that
		you wish to specifically be able to use it for, like pictures in C libraries when you need to be able
		to clone them.
	
	----------------------------------------------------------------------------------------------------------
	
	tablelib.Sanitize ( any val1 , any val2 ) -> any
		This function replaces any entries of val1 whose type does not match the criteria of val2. This
		criteria is as follows:
		
		Tables are checked recursively. If val1 is a table, while val2 is not, then the check simply gets
		dropped, and the result is a copy of val1 created using tablelib.DeepCopy. This function performs
		loop checking to avoid crashing.
	
	----------------------------------------------------------------------------------------------------------
	
	tablelib.Search ( any obj , any val ) -> any
		Searches for entries of obj, and returns the result. If obj is a table with a metamethod named
		__search, then this metamethod is called instead, passing obj and value, and returning the result.
	
	----------------------------------------------------------------------------------------------------------
]]

local mod = {}
function mod.DeepCopy(tbl)
	if type(tbl) == "table" then
		local mt = getmetatable(tbl)
		local copy = {}
		local refloop = {}
		if mt then
			mt = mod.DeepCopy(mt)
			setmetatable(copy, mt)
			return copy
		end
		for k, v in pairs(tbl) do
			if refloop[k] then
				error("DeepCopy does not allow looping references", 2)
			end
			if refloop[v] then
				error("DeepCopy does not allow looping references", 2)
			end
			refloop[k] = true
			refloop[v] = true
			copy[mod.DeepCopy(k)] = mod.DeepCopy(v)
		end
		return copy
	end
	return tbl
end
local deepcopy = mod.DeepCopy
function mod.Sanitize(tbl, def)
	if type(def) == "table" then
		if type(tbl) ~= "table" then
			return deepcopy(def)
		end
		local refloop = {}
		local c = deepcopy(tbl)
		for k, v in pairs(def) do
			if refloop[k] then
				error("DeepCopy does not allow looping references", 2)
			end
			if refloop[v] then
				error("DeepCopy does not allow looping references", 2)
			end
			refloop[k] = true
			refloop[v] = true
			c[k] = mod.Sanitize(c[k], v)
		end
		return c
	end
	if type(tbl) ~= type(def) then
		return deepcopy(def)
	end
	return deepcopy(tbl)
end

function mod.Search(tbl, val)
	if type(tbl) ~= "table" then
		return nil
	end
	local mt = getmetatable(tbl)
	if mt == nil then
		for k, v in pairs(tbl) do
			if type(v) ~= "table" then
				return val==v
			end
			if rawequal(v, val) then
				return v
			end
		end
		return nil
	end
	local func = mt.__search
	if type(func) == "function" then
		return func(tbl, val)
	end
	return nil
end

return mod