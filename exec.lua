-- Collect tables returned by ModuleScripts and write one big dump to a file
local root = game.ReplicatedStorage.Collection.Item

-- Pretty, cycle-safe serializer that produces a Lua-ish dump
local function serialize(value, seen, indent)
	seen = seen or {}
	indent = indent or ""
	local t = (typeof and typeof(value)) or type(value)

	-- Simple primitives
	if t == "string" then
		return string.format("%q", value)
	elseif t == "number" or t == "boolean" or t == "nil" then
		return tostring(value)
	end

	-- Roblox datatypes / Instances -> readable placeholders
	if t == "Instance" then
		local ok, path = pcall(function() return value:GetFullName() end)
		return string.format("<Instance %q>", ok and path or tostring(value))
	elseif t == "Vector3" or t == "CFrame" or t == "Color3" or t == "UDim2"
		or t == "UDim" or t == "BrickColor" or t == "EnumItem" then
		return string.format("<%s %s>", t, tostring(value))
	end

	-- Tables (with cycle protection and stable key order)
	if t == "table" then
		if seen[value] then
			return "<cycle>"
		end
		seen[value] = true

		-- Sort keys for stability
		local keys = {}
		for k in pairs(value) do
			table.insert(keys, k)
		end
		table.sort(keys, function(a, b) return tostring(a) < tostring(b) end)

		local lines = {"{"}
		local nextIndent = indent .. "  "
		for _, k in ipairs(keys) do
			local keyStr
			if type(k) == "string" and k:match("^%a[%w_]*$") then
				keyStr = k
			else
				keyStr = "[" .. serialize(k, seen, nextIndent) .. "]"
			end
			local valStr = serialize(value[k], seen, nextIndent)
			table.insert(lines, nextIndent .. keyStr .. " = " .. valStr .. ",")
		end
		table.insert(lines, indent .. "}")
		seen[value] = nil
		return table.concat(lines, "\n")
	end

	-- Fallback for functions, threads, userdata, etc.
	return string.format("<%s %s>", t, tostring(value))
end

-- Require everything and keep only tables
local collected = {}  -- key: module full name, value: returned table

for _, folder in next, root:GetChildren() do
	for _, mod in next, folder:GetChildren() do
		if mod.ClassName ~= "ModuleScript" then
			continue
		end
		local ok, result = pcall(require, mod)
		if ok and type(result) == "table" then
			collected[mod:GetFullName()] = result
		end
	end
end

-- Build one big string (Lua-literal style so it's easy to paste back if needed)
local dump = ("-- Dump generated on %s UTC\nreturn %s")
	:format(os.date("!%Y-%m-%d %H:%M:%S"), serialize(collected))

-- ---- Save to file instead of clipboard ----
local function ensureFolder(path)
	local isfolderFn = rawget(getfenv(0), "isfolder")
	local makefolderFn = rawget(getfenv(0), "makefolder")
	if isfolderFn and makefolderFn then
		if not isfolderFn(path) then
			pcall(makefolderFn, path)
		end
	end
end

local function writeBigFile(path, content)
	-- Try writefile first
	if typeof(writefile) == "function" then
		local ok, err = pcall(writefile, path, content)
		if ok then return true end

		-- If writefile fails (e.g., size limits), fall back to chunked append
		if typeof(appendfile) == "function" then
			-- best-effort clear (some executors overwrite; others require removal)
			pcall(writefile, path, "")
			local CHUNK = 200000 -- 200 KB chunks; adjust up/down if needed
			local i = 1
			while i <= #content do
				local j = math.min(i + CHUNK - 1, #content)
				local ok2 = pcall(appendfile, path, content:sub(i, j))
				if not ok2 then
					return false
				end
				i = j + 1
			end
			return true
		else
			warn("writefile failed and no appendfile() available: " .. tostring(err))
			return false
		end
	else
		warn("writefile() is not available in this environment.")
		return false
	end
end

local folder = "dumps"
ensureFolder(folder)
local filename = string.format("%s/dump-%s.lua", folder, os.date("!%Y-%m-%d_%H-%M-%S"))

local saved = writeBigFile(filename, dump)
if saved then
	print(string.format("Wrote %s (%d chars).", filename, #dump))
else
	warn("Failed to write dump; printing a preview below (first 1000 chars):")
	print(dump:sub(1, 1000))
end
