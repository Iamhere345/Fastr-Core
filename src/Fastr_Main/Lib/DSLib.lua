local DSLib = {}

local DSS = game:GetService("DataStoreService")
local DS = DSS:GetDataStore("FastrDS")

local Fastr = script.Parent.Parent

local UIUtils = require(Fastr:WaitForChild("Utils").UIUtils)

local Settings = require(Fastr.Settings)
local Key = Settings.Key

--for any of the stuff here to work in studio please turn studio access to api on.
--currently this module is only used for the ban command, but you can put all of your command's datastore stuff here as well

DSLib.Ban = function(player,days)
	local suc,ret

	local data

	repeat
		
		suc,ret = pcall(function()
			data = DS:GetAsync(string.lower(player.UserId).."-"..Key)
		end)
		
		if ret then warn(ret) end
		
	until suc

	if data then
		if player.UserId ~= game.CreatorId then
			data.TimeUntilUnbanned = tick() + (days*144)
			DS:UpdateAsync(player.UserId.."-",data)
			player:Kick("you have been banned for "..days.." days")
		else
			UIUtils.Notify(player,"Error","you cannot ban the creator of this game")
		end
	else
		if player.UserId ~= game.CreatorId then
			local DataTable = {}
			DataTable.TimeUntilUnbanned = tick() + (days*144)

			local suc2,ret2

			repeat

				suc2,ret2 = pcall(function()
					DS:UpdateAsync(string.lower(player.UserId).."-",DataTable)
				end)
				
				if ret then warn(ret) end
				
			until suc2

			player:Kick("you have been banned for "..days.." days")
		else
			UIUtils.Notify(player,"Error","you cannot ban the creator of this game")
		end
	end
end

DSLib.Unban = function(userId)
	local data = DS:GetAsync(userId.."-"..Key)

	if data.TimeUntilUnbanned then

		local DataTable = {}
		DataTable.TimeUntilUnbanned = 0

		DS:UpdateAsync(userId.."-"..Key,DataTable)

	end

end

game.Players.PlayerAdded:Connect(function(player)
	local data = DS:GetAsync(string.lower(player.UserId).."-"..Key)

	if data then
		if data.TimeUntilUnbanned > tick() then
			player:Kick("you have been banned for "..(data.TimeUntilUnbanned/144 - tick()).." days")
		end
	end

end)

return DSLib
