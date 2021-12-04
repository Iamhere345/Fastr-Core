local Parser = {}
--this script parses commands and also compiles stuff from settings
local Fastr = script.Parent.Parent
local CommandsFolder = Fastr:WaitForChild("Core").Commands
local ArgLib = require(Fastr:WaitForChild("Lib"):WaitForChild("ArgLib"))
local MiscUtils = require(Fastr.Utils.MiscUtils)
local UIUtils = require(Fastr:WaitForChild("Utils"):WaitForChild("UIUtils"))
local Settings = require(Fastr:WaitForChild("Settings"))
local Ranks = Settings.Ranks
local GroupRanks = Settings.GroupRanks
local prefix = Settings.Prefix

local Commands = MiscUtils.CompileCommands(CommandsFolder)

local function GetPermissionLevel(player)
	for i,v in pairs(Ranks) do
		if v[1] == player.UserId or v[1] == player.Name then
			return v[2]
		end
	end
	return 0
end

local function CheckGroupPerms(player)
	for i,v in pairs(GroupRanks) do
		if player:IsInGroup(v[1]) then
			if player:GetRankInGroup(v[1]) == v[2] then
				table.insert(Ranks,{player.UserId,v[2]})
			end
		end
	end
end

local function GetDefaultRank(player)
	if GetPermissionLevel(player) == 0 then
		table.insert(Ranks,{player.UserId,Settings.DefaultRank})
	end
end

local function IsValidCommand(cmd)
	if Commands[string.lower(cmd)] then
		return true
	else
		return false
	end
end

local function IsValidAliase(cmd)
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

local function CheckMods(mod)
	for i,v in pairs(ArgLib) do
		if v == mod then
			return true
		end
	end
	return false
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

				local HasFoundModifyer = false

				for i,v in pairs(Modifyers) do --loop through modifyers

					if v == args[1] then --if the modifyer matches what the player said

						if ArgLib[v] then --if there is a function for it in ArgLib

							ArgLib[v](player,args,command.Run)--run the agrUtils command
							HasFoundModifyer = true
							break

						end
					end
				end
				if HasFoundModifyer == false and args[1] then
					ArgLib.player(player,args,command.Run)
				elseif HasFoundModifyer == false and not table.find(Modifyers,"NotSelf") then
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
