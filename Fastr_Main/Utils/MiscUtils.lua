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

return MiscUtils
