local Fastr = script.Parent.Parent

local DSLib = require(Fastr.Lib.DSLib).new()
local UIUtils = require(Fastr.Utils.UIUtils)
local Settings = require(Fastr.Settings)

local key = Settings.Key

local ModLib = {}
ModLib.__index = ModLib

function ModLib.new()
    return setmetatable({}, ModLib)
end

function ModLib:banPlr(player: Player, days: number, moderator: Player, note: string)

    local data = DSLib:safeGet(
        player.UserId.."-"..key,
        "Fastr: error getting player moderation data for ban. Moderation data may be wiped",
        false,
        moderator,
        false,
        20
    )

    if player.UserId == game.CreatorId then
        UIUtils.Notify(moderator, "Error", "You cannot ban the owner of this game.")
        return
    end

    if data then

        table.insert(data.Bans, 1, {
            ban_time = { tick() + (days * 86400), days},
            moderator = moderator.Name,
            mod_note = note,
            ban_repealed = false,
        })

        DSLib:safeSet(
            player.UserId.."-"..key,
            data,
            "Error occured while banning player. Please try again later.",
            true,
            moderator,
            false,
            20
        )

        player:Kick(string.format("You have been for %s days by %s.\n Moderator note: %s", 
            data.Bans[1].ban_time,
            data.Bans[1].moderator,
            data.Bans[1].mod_note
        ))

    else
        local dataTable = {}
        dataTable.Bans = {}

        table.insert(dataTable.Bans, 1, {
            ban_time = { tick() + (days * 86400), days },
            moderator = moderator.Name,
            mod_note = note,
            ban_repealed = false,
        })

        DSLib:safeSet(player.UserId.."-"..key, data, "Error occured while banning player. Please try again later", true, moderator, false, 20)

        player:Kick(string.format("You have been for %s days by %s.\n Moderator note: %s", 
            data.Bans[1].ban_time,
            data.Bans[1].moderator,
            data.Bans[1].mod_note
        ))
        
    end
end

function ModLib:unbanPlr(user: Player, userId: number)
    local data = DSLib:safeGet(userId .. "-" .. key, "Unable to unban player. Please try again", true, user, false, 20)

    if data then
        if data.Bans[1].ban_time[1] > tick() then
            data.Bans[1].ban_repealed = true

            DSLib:safeSet(userId.."-"..key, data, "Unable to unban player. Please try again later.", true, user, false, 20)
        else
            UIUtils.Notify(user, "Error", "Player is not banned.")
        end
    end
end

return ModLib