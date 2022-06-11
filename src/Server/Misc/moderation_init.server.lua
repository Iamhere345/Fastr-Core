local Fastr = script.Parent.Parent

local DSLib = require(Fastr:WaitForChild("Lib").DSLib).new()
local Settings = require(Fastr:WaitForChild("Settings"))
local key = Settings.Key

local function OnPlayerAdded(player)
	local data = DSLib:safeGet(
		player.UserId .. "-" .. key,
		"Fastr: error loading moderation data, please rejoin",
		false,
		player,
		false,
		20
	)


	if data then

		if data.Bans[1].ban_time[1] > tick() and data.Bans[1].ban_repealed == false then
			player:Kick(string.format("You have been for %s days by %s.\n Moderator note: %s", 
                data.Bans[1].ban_time[2],
                data.Bans[1].moderator,
                data.Bans[1].mod_note
            ))

		end
	end
end

task.wait(0.1)

for _, plr in game.Players:GetPlayers() do
	OnPlayerAdded(plr)
end

game.Players.PlayerAdded:Connect(OnPlayerAdded)
