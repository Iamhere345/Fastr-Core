local MiscUtils = {}

MiscUtils.CompileCommands = function(Root)
	
	local compiledTable = {}
	
	for i,v in pairs(Root:GetChildren()) do
		if v:IsA("ModuleScript") then
			
			local CommandTable = require(v)
			
			for i,v in pairs(CommandTable) do
				compiledTable[string.lower(v.Name)] = v --this is how you can have a command with an uppercase name have fastr still work with that command
			end
			
		end
	end
	
	return compiledTable
	
end

MiscUtils.CompileMods = function(CmdTable)
	
	local fnMods = {
		["all"] = {"all","me","others","random","randother","team","player"},
		["standard"] = {"all","me","others",},
	}
	
	local function GetFnMods(key,modTable)
		
		for _,mod in ipairs(fnMods[key]) do
			table.insert(modTable,mod)	
		end
		
	end
	
	for _,cmd in pairs(CmdTable) do
		if cmd.Modifyers then
			for x,mod in pairs(cmd.Modifyers) do
				if fnMods[mod] then
					GetFnMods(mod,cmd.Modifyers)
				end
			end
		end
	end
	
end

return MiscUtils
