local UIUtils = {}

local Remotes = game.ReplicatedStorage:WaitForChild("Fastr_Remotes")

UIUtils.Notify = function(player,Type,Msg,TopBarMsg,Colour,Duration)
	Remotes.ShowNotificaiton:FireClient(player,Type,Msg,TopBarMsg,Colour,Duration)
end

return UIUtils
