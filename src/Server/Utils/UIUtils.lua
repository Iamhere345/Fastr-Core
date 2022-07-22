--[[

UIUtils:
	Author: github.com/Iamhere345
	License: MIT
	Description: contains UI-related utilites. There is currently only one of these - Notify(). This function displays a notification on the client.

]]

local UIUtils = {}

local Remotes = game.ReplicatedStorage:WaitForChild("Fastr_Remotes")

UIUtils.Notify = function(player, Type, Msg, TopBarMsg, Colour, Duration)
	Remotes.ShowNotification:FireClient(player, Type, Msg, TopBarMsg, Colour, Duration)
end

return UIUtils
