local Parser = {}
--this script parses commands and also compiles stuff from settings

--//instances
local Fastr = script.Parent.Parent
--//dependencies
local CommandsFolder = Fastr:WaitForChild("Core").Commands
local ArgLib = require(Fastr:WaitForChild("Lib"):WaitForChild("ArgLib"))
local MiscUtils = require(Fastr:WaitForChild("Utils").MiscUtils)
local UIUtils = require(Fastr:WaitForChild("Utils"):WaitForChild("UIUtils"))
local Settings = require(Fastr:WaitForChild("Settings"))
--//settings
local Ranks = Settings.Ranks
local GroupRanks = Settings.GroupRanks
local prefix = Settings.Prefix

local Commands = MiscUtils.CompileCommands(CommandsFolder)

local function GetPermissionLevel(player) --gets a players permission level. it loops through the ranks table and if it finds the players userid or name as the first value it will return the second value. otherwise it will return 0
	for i,v in pairs(Ranks) do
		if v[1] == player.UserId or v[1] == player.Name then
			return v[2]
		end
	end
	return 0
end

local function CheckGroupPerms(player) --converts a players value in the group ranks table to a normal rank
	for i,v in pairs(GroupRanks) do
		if player:IsInGroup(v[1]) then
			if player:GetRankInGroup(v[1]) == v[2] and GetPermissionLevel(player) == 0 then
				table.insert(Ranks,{player.UserId,v[2]})
			end
		end
	end
end

local function GetDefaultRank(player) --changes all the rank of all players who don't have a rank to the default rank
	if GetPermissionLevel(player) == 0 then
		table.insert(Ranks,{player.UserId,Settings.DefaultRank})
	end
end

local function IsValidCommand(cmd) --checks if a command is in the commands table
	if Commands[string.lower(cmd)] then
		return true
	else
		return false
	end
end

local function IsValidAliase(cmd) --checks if the command the player has said is an aliase of a command
	for _,command in pairs(Commands) do
		if command.Aliases then
			for i,a in ipairs(command.Aliases) do
				if a == cmd then
					return string.lower(command.Name)
				end
			end
		end
	end
	return nil
end

Parser.ParseCmd = function(player,msg,UsingPrefix)

	CheckGroupPerms(player)
	GetDefaultRank(player)


	local rank = GetPermissionLevel(player)


	local CommandStr = string.split(msg," ")[1]
	local args = string.split(msg," ")

	if string.sub(msg,0,1) == prefix then
		CommandStr = string.split(CommandStr,":")[2]
	end

	string.lower(CommandStr)
	table.remove(args,1)

	if IsValidCommand(CommandStr) or IsValidAliase(CommandStr) then --checks if the command is valid

		if IsValidAliase(CommandStr) then
			CommandStr = IsValidAliase(CommandStr)
		end

		local command = Commands[string.lower(CommandStr)]
		local Modifyers = command.Modifyers


		if command.PermissionLevel <= rank then
			
			if Modifyers then
				
				if table.find(Modifyers,args[1]) then
					
					if ArgLib[args[1]] and args[1] ~= "player" then

						local targets = ArgLib.CheckMod(player,args[1],args)

						for i,target in pairs(targets) do
							command.Run(player,target,args)
						end

					else
						
						local Target = ArgLib.player(player,args[1])

						if Target then

							command.Run(player,Target,args)

						end
						
					end
					
				else 
					
					command.Run(player,player,args)
					
				end
				
			else
				
				command.Run(player,player,args)
				
			end
		else
			UIUtils.Notify(player,"Error","you do not have permission to run this command")
		end
	end

end

return Parser
