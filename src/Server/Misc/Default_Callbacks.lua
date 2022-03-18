local Fastr = script.Parent.Parent
local remotes = game.ReplicatedStorage:WaitForChild("Fastr_Remotes")
local mps = game:GetService("MarketplaceService")

--this script contains all of the callbacks made on the client. pretty self-explanitory

local commands = require(Fastr.Utils.MiscUtils).CompileCommands(Fastr.Core.Commands)

remotes.GetCmdData.OnServerInvoke =
	function() --this gets every commands metadata and sends them to the client for the :cmds command. this isn't a great place to put it but it's here anyway
		return commands
	end

remotes.PromptPurchase.OnServerEvent:Connect(function(player, Purchase)
	local Store = {
		["Donate100"] = 1225919041,
		["Donate50"] = 1225919151,
	}

	local Download = {
		["Loader"] = 7981503602,
		["Source"] = 7768369303,
		["MainModule"] = 7981493975,
	}

	if Store[Purchase] then
		mps:PromptGamePassPurchase(player, Store[Purchase])
	elseif Download[Purchase] then
		mps:PromptPurchase(player, Download[Purchase])
	end
end)
