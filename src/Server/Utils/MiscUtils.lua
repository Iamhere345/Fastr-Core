local MiscUtils = {}

MiscUtils.CompileCommands = function(Root)
	local MakeEdits
	local compiledTable = {}

	if script:FindFirstChild("CoreCommandsEdits") then
		MakeEdits = require(script.CoreCommandsEdits)
	end

	for i, v in pairs(Root:GetChildren()) do
		if v:IsA("ModuleScript") then
			local CommandTable = require(v)

			for i, v in pairs(CommandTable) do
				compiledTable[string.lower(v.Name)] = v --this is how you can have a command with an uppercase name have fastr still work with that command
			end

			if v.Name == "Core_Commands" and MakeEdits then
				MakeEdits(CommandTable)
			end
		end
	end

	return compiledTable
end

MiscUtils.CompileMods = function(CmdTable)
	local fnMods = {
		["all"] = { "all", "me", "others", "random", "randother", "team", "player" },
		["standard"] = { "all", "me", "others" },
	}

	local function GetFnMods(key, modTable)
		for _, mod in ipairs(fnMods[key]) do
			table.insert(modTable, mod)
		end
	end

	for _, cmd in pairs(CmdTable) do
		if cmd.Modifyers then
			for x, mod in pairs(cmd.Modifyers) do
				if fnMods[mod] then
					GetFnMods(mod, cmd.Modifyers)
				end
			end
		end
	end
end

MiscUtils.DeepCopy = function(t: table)
	local tableCopy = {}

	for k, v in pairs(t) do
		tableCopy[k] = v
	end

	return tableCopy
end

return MiscUtils
