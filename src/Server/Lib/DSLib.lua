local DSS = game:GetService("DataStoreService")
local DS = DSS:GetDataStore("FastrDS")

local Fastr = script.Parent.Parent

local UIUtils = require(Fastr:WaitForChild("Utils").UIUtils)

local HARD_TIMEOUT = 20 -- timeout constant incase someone sets a timeout to something really high

--[[ for any of the stuff here to work in studio please turn studio access to api on.
currently this module is only used for the ban command, but you can put all of your command's datastore stuff here as well
]]

local DSLib = {}
DSLib.__index = DSLib

function DSLib.new()
    return setmetatable({}, DSLib)
end

function DSLib:safeGet(key: string, errorMsg: string, showError: boolean, player: Player, kickOnError: boolean, timeout: number)
    local data
    local s,r
    local i = 0

    if timeout > HARD_TIMEOUT then
        warn("Fastr: timeout set to value above maximum timout (20)")
    end

    repeat
        s, r = pcall(function()
            data = DS:GetAsync(key)
        end)

        i += 1

    until (not r and s) or i == (timeout or HARD_TIMEOUT)

    if not r and i == timeout then
        if showError then
            UIUtils.Notify(player, "Error", errorMsg)
        else
            warn(errorMsg)
        end

        if kickOnError then
            player:Kick(errorMsg)
        end
    end

    if data then
        return data
    else
        return nil
    end

end

function DSLib:safeSet(key: string, data: any, errorMsg: string, showError: string, player: Player, kickOnError: boolean, timeout: number)
    local s, r
    local i = 0

    if timeout > HARD_TIMEOUT then
        warn("Fastr: timeout set to value above maximum timout (20)")
    end

    repeat
        s, r = pcall(function()
            DS:SetAsync(key, data)
        end)

        i += 1

    until (not r or s) or i == (timeout or HARD_TIMEOUT)

    if r and i == (timeout or HARD_TIMEOUT) then
        warn(r)

        if showError then
            UIUtils.Notify(player)
        else
            warn(string.format("%s Error: %s", errorMsg, r))
        end

        if kickOnError then
            player:Kick(errorMsg)
        end
    end

end

return DSLib