--this is the script that calls the parser when a player chats. it's a small script, but without it fastr won't parse commands
local Fastr = script.Parent.Parent
local Parser = require(script.Parent.Parser)
local MiscUtils = require(Fastr.Utils.MiscUtils)

local function TextCommandsSetup(player)
	
	player.Chatted:Connect(function(msg)
		Parser.ParseCmd(player,msg,true)
	end)
	
end

for _,player in pairs(game.Players:GetPlayers()) do --when fastr is loaded play will of already join, so this is to setup the lexer for those players
	TextCommandsSetup(player)
end

game.Players.PlayerAdded:Connect(function(player) --some players woll join after fastr has loaded and already looped through the existing players
	TextCommandsSetup(player)
end)
 
