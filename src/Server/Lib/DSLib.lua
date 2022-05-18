local DSLib = {}

local DSS = game:GetService("DataStoreService")
local DS = DSS:GetDataStore("FastrDS")

local Fastr = script.Parent.Parent

local UIUtils = require(Fastr:WaitForChild("Utils").UIUtils)

local Settings = require(Fastr:WaitForChild("Settings"))
local Key = Settings.Key

--for any of the stuff here to work in studio please turn studio access to api on.
--currently this module is only used for the ban command, but you can put all of your command's datastore stuff here as well

local function SafeGet(key: string, error_msg: string, show_error: boolean, player: Player, kickOnError: boolean, timeout: number)
	local data
	local s, r
	local i = 0

	repeat
		s, r = pcall(function()
			data = DS:GetAsync(key)
		end)

		i += 1

	until not r or (i == timeout or i == 20)

	if not r and (i == timeout or i == 20) then
		if show_error then
			UIUtils.Notify(player, "Error", error_msg)
		else
			warn(error_msg)
		end

		if kickOnError then
			player:Kick(error_msg)
		end
	end

	if data then
		return data
	else
		return nil
	end
end

local function SafeSet(key: string, data: any, error_msg: string, show_error: string, player: Player, kickOnError: boolean, timeout: number)
	local s, r
	local i = 0

	repeat
		s, r = pcall(function()
			DS:SetAsync(key, data)
		end)

		print(s)

		i += 1

	until not r or i == (timeout or 20)

	if r and i == (timeout or 20) then
		warn(r)

		if show_error then
			UIUtils.Notify(player, "Error", error_msg .. " Error: " .. r)
		else
			warn(error_msg .. " Error: " .. r)
		end

		if kickOnError then
			player:Kick(error_msg)
		end
	end
end

local function OnPlayerAdded(player)
	local data = SafeGet(
		player.UserId .. "-" .. Key,
		"Fastr: error loading moderation data, please rejoin",
		player,
		true
	)

	print("got data")

	if data then
		print("data")
		if data.Bans[1].ban_time[1] > tick() and data.Bans[1].ban_repealed == false then
			print("KICK")
			player:Kick(
				"you have been banned for "
					.. data.Bans[1].ban_time[2]
					.. " days by "
					.. data.Bans[1].moderator
					.. ". \n Moderator note: "
					.. data.Bans[1].mod_note
			)
		else
			print("no kick")
		end
	end
end

DSLib.Ban = function(player, days, user, note)
	print(note)

	local data = SafeGet(
		player.UserId .. "-" .. Key,
		"Fastr: error getting player moderation data for ban. Moderation data may be wiped.",
		false,
		user,
		false,
		250
	)

	if data then
		if player.UserId ~= game.CreatorId then
			table.insert(data.Bans, 1, {
				ban_time = { tick() + (days * 86400), days },
				moderator = user.Name,
				mod_note = note,
				ban_repealed = false,
			})

			SafeSet(
				player.UserId .. "-" .. Key,
				data,
				"Error occured while banning player. Please try again.",
				true,
				user,
				false,
				250
			)

			player:Kick(
				"you have been banned for "
					.. days
					.. " days by "
					.. data.moderator
					.. ".\n Moderator note: "
					.. data.mod_note
			)
		else
			UIUtils.Notify(player, "Error", "you cannot ban the creator of this game")
		end
	else
		if player.UserId ~= game.CreatorId then
			local DataTable = {}

			DataTable.Bans = {}

			table.insert(DataTable.Bans, 1, {
				ban_time = { tick() + (days * 86400), days },
				moderator = user.Name,
				mod_note = note,
				ban_repealed = false,
			})

			SafeSet(
				player.UserId .. "-" .. Key,
				DataTable,
				"Error occured while banning player. Please try again.",
				true,
				user,
				false,
				250
			)

			player:Kick(
				"you have been banned for "
					.. days
					.. " days by "
					.. DataTable.Bans[1].moderator
					.. ".\n Moderator note: "
					.. DataTable.Bans[1].mod_note
			)
		else
			UIUtils.Notify(player, "Error", "you cannot ban the creator of this game")
		end
	end
end

DSLib.Unban = function(user: Player, userId: number)
	local data = SafeGet(userId .. "-" .. Key, "Unable to unban player. Please try again", true, user, false, 20)

	if data then
		if data.Bans[1].ban_time[1] > tick() then
			data.Bans[1].ban_repealed = true

			print(data)

			SafeSet(userId .. "-" .. Key, data, "Unable to unban player. Please try again", true, user, false, 20)
		end
	else
		print("what")
	end
end

task.wait(0.1)

for _, p in pairs(game.Players:GetPlayers()) do
	print(p.Name)
	OnPlayerAdded(p)
end

game.Players.PlayerAdded:Connect(OnPlayerAdded)

return DSLib
