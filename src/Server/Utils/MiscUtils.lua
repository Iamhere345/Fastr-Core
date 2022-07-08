local MiscUtils = {}

MiscUtils.CompileCommands = function(Root)
	local MakeEdits
	local compiledTable = {}

	if script:FindFirstChild("CoreCommandsEdits") then
		s,r = pcall(function()
			MakeEdits = require(script.CoreCommandsEdits)
		end)
		
		if r then warn("Fastr: CoreCommandsEdits was unable to load due to error: "..r) end

	end

	for _, v in pairs(Root:GetChildren()) do
		if v:IsA("ModuleScript") then

			local CommandTable

			s,r = pcall(function()
				CommandTable = require(v)
			end)

			if r then
				warn("Fastr: Unable to mount command module '"..v.Name.."' due to error: "..r)
				continue
			end
			
			for _, command in pairs(CommandTable) do
				compiledTable[string.lower(command.Name)] = command --this is how you can have a command with an uppercase name have fastr still work with that command
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
			-- selene: allow(unused_variable)
			for x, mod in pairs(cmd.Modifyers) do
				if fnMods[mod] then
					GetFnMods(mod, cmd.Modifyers)
				end
			end
		end
	end
end

MiscUtils.DeepCopy = function(t: {})
	local tableCopy = {}

	for k, v in pairs(t) do
		tableCopy[k] = v
	end

	return tableCopy
end

return MiscUtils
