local Parser = {}
--this script parses commands and also compiles stuff from settings

--//instances
local Fastr = script.Parent.Parent
local CommandsFolder = Fastr:WaitForChild("Core").Commands
--//dependencies
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

local function PipeCommand(player,args1,args2) --these are both parsed tables

	local targets = ArgLib.CheckMod(args2[2])

	local cmd2 = args2[1]
	table.remove(args2,1)

	print(args1)
	print(args2)

	cmd2 = Commands[cmd2]

	print(cmd2)

	local cmd2Ret = cmd2.Run(player,player,args2)

	table.insert(args1,cmd2Ret)

	print(args1)

	return args1

end

local function RepeatCmd(args,cmd)
	
	if args[#args-1] == Settings.RepeatChar and tonumber(args[#args]) then
		
		return cmd["RepeatCeiling"] or math.clamp(tonumber(args[#args]),1,250)

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

			if table.find(args,Settings.PipeChar) then --this means the user wants to pipe a command to another command
				--prep args for piping
				local argsCopy = MiscUtils.DeepCopy(args)

				argsCopy = table.concat(argsCopy," ")

				argsCopy = string.split(argsCopy,Settings.PipeChar)

				local args1 = string.split(argsCopy[1]," ")
				local args2 = string.split(argsCopy[2]," ")

				if args2[1] == "" then --if the user used a space after typing the pipe char, there would be a space as an argument, which Fastr does not like
					table.remove(args2,1)
				end

				if args1[#args1] == "" then
					table.remove(args1,#args1)
				end

				args = PipeCommand(player,args1,args2)

			end
			
			if table.find(args,Settings.AndChar) then --if the user has inputted multiple command (:sm message + m  message + fly me)
				
				local argsCopy = MiscUtils.DeepCopy(args)
				
				argsCopy = table.concat(argsCopy," ")
				argsCopy = string.split(argsCopy,Settings.AndChar)
				
				table.remove(argsCopy,1)
				
				for i,s in ipairs(argsCopy) do --im sorry
					
					if string.sub(s,0,1) == " " then
						argsCopy[i] = string.sub(s,2,-1)
					end
					--[[
					if string.sub(s,string.len(s)-1,string.len(s)) == " " then
						print("EE")
						argsCopy[i] = string.sub(s,0,string.len(s)-1)
					end]]-- support for more than two commands at a time will come in the future
				end
				
				argsCopy = table.concat(argsCopy,"")
				
				Parser.ParseCmd(player,argsCopy,false)
				
				args = table.concat(args," ")
				args = string.split(args,Settings.AndChar)
				
				table.remove(args,2)
				
				args = args[1]
				args = string.split(args," ")
				
			end
			
			if Modifyers then

				if table.find(Modifyers,args[1]) then

					if ArgLib[args[1]] and args[1] ~= "player" then --ArgLib.player is special and cannot be accessed from the player just typing player

						local targets = ArgLib.CheckMod(player,args[1],args)
						
						local RptCmd_result = RepeatCmd(args,command)
						
						if RptCmd_result then
							
							table.remove(args,#args)
							table.remove(args,#args)
							
							for i = 0,RptCmd_result,1 do
								for i,target in pairs(targets) do
									command.Run(player,target,args)
								end
							end
							
						else
							
							for i,target in pairs(targets) do
								command.Run(player,target,args)
							end
							
						end


					end

				else  --this will fire if the first argument (usually reserved for a mod) is not a valid mod.

					local Target = ArgLib.player(player,args[1])

					if Target then
						
						local RptCmd_result = RepeatCmd(args,command)
						
						if RptCmd_result then
							
							table.remove(args,#args)
							table.remove(args,#args)
							
							print("in1")
							
							for i = 0,RptCmd_result,1 do
								command.Run(player,Target,args)
							end
							
						else
							print("no1")
							command.Run(player,Target,args)
						end
						
					else
						
						local RptCmd_result = RepeatCmd(args,command)
						
						if RptCmd_result then
							
							table.remove(args,#args)
							table.remove(args,#args)
							
							print("in2")
							
							for i = 0,RptCmd_result,1 do 
								command.Run(player,player,args)
							end
							
						else
							print("no2")
							command.Run(player,player,args)
						end
						
						
					end

				end

			else --if there are no modifyers, the mod argument will be the player that ran the command
				
				local RptCmd_result = RepeatCmd(args,command)
				
				if RptCmd_result then
					
					table.remove(args,#args)
					table.remove(args,#args)
					
					for i = 0,RptCmd_result,1 do
						command.Run(player,player,args)
					end
					
				else
					command.Run(player,player,args)
				end
				

			end
		else
			UIUtils.Notify(player,"Error","you do not have permission to run this command")
		end
	end

end

return Parser
