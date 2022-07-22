--[[

Init:
	Author: github.com/Iamhere345
	License: MIT
	Description: Initialises Fastr's server-side components.

]]

local Fastr = script.Parent.Parent
local Parser = require(script.Parent.Parser)
local MiscUtils = require(Fastr.Utils.MiscUtils)

local CommandsFolder = script.Parent.Commands

local function TextCommandsSetup(player)
	player.Chatted:Connect(function(msg)
		Parser.ParseCmd(player, msg, true)
	end)
end

for _, player in pairs(game.Players:GetPlayers()) do --when fastr is loaded play will of already join, so this is to setup the lexer for those players
	TextCommandsSetup(player)
end

MiscUtils.CompileCommands(CommandsFolder)

game.Players.PlayerAdded:Connect(function(player) --some players woll join after fastr has loaded and already looped through the existing players
	TextCommandsSetup(player)
end)

game.ReplicatedStorage:WaitForChild("Fastr_Remotes").ExecuteCommand.OnServerEvent:Connect(function(player, cmd) --this would go in Default_Callbacks if it weren't so important
	Parser.ParseCmd(player, cmd, false) --there are security checks within Parser.ParseCmd()
end)
