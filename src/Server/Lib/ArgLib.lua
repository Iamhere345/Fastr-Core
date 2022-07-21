--# selene: allow(unused_variable)
local Players = game:GetService("Players")

local Fastr = script.Parent.Parent
local UIUtils = require(Fastr:WaitForChild("Utils").UIUtils)

local ArgLib = {}
ArgLib.__index = ArgLib

function ArgLib.new()
    return setmetatable(
		{
			controlArgs = {
				["all"] = true,
				["me"] = true,
				["others"] = true,
				["randother"] = true,
				["random"] = true,
				["team"] = true,
			},
		}, 
		ArgLib
	)
end

function ArgLib:checkMod(player: Player, mod, args)
    if self[mod] then
        return self[mod](player, mod, args)
    else
        return {}
    end
end

function ArgLib:autocomplete(player, t: {}, target: string)
	
	local function getIndex(name: string)

		local index = t[string.lower(name)]

		if index then
			return index
		end
	end

	if not target then
		return nil
	end

	target = target:lower()

	if getIndex(target) then
		return getIndex(target)
	end

	local candidates

	for k, v in t do
		if string.match(k:lower(), target) then
			--found match
			local start = string.find(k:lower(), target)

			if start == 1 then
				table.insert(candidates, k:lower())
			end
		end
	end

	local bestMatch = "no-one"

	for i,v in candidates do
		
		if i == 1 then
			bestMatch = v
		else
			local _, currentEnd = string.find(v, target)
			local _, bestMatch_end = string.find(bestMatch, target)

			if currentEnd > bestMatch_end then
				bestMatch = v
			elseif currentEnd == bestMatch_end then
				UIUtils.Notify(player, "Error", "two items with same start of name, please be more specific")
				return nil
			end
		end

	end

	return getIndex(bestMatch)

end

function ArgLib:getPlayerTarget(player: Player, target: string): Player

    print("fired player")

	local function getPlayer(name: string)
		for _, plr in Players:GetPlayers() do

			if string.lower(plr.Name) == name then
				return plr
			end

		end
	end

	local function getPlayerByDisplayName(displayName: string)
		for _, plr in Players:GetPlayers() do
			if string.lower(plr.DisplayName) == displayName then
				return plr
			end
		end
	end

	if not target then
		return nil
	end

	target = string.lower(target)

	if getPlayer(target) then --if the player has typed in the full username of the target
		return getPlayer(target)
	end

	if getPlayerByDisplayName(target) then
		return getPlayerByDisplayName(target)
	end

	local PossiblePlayers = {}

	for _, v in pairs(Players:GetPlayers()) do --loops through players
		if string.match(string.lower(v.Name), target) or string.match(string.lower(v.DisplayName), target) then --if the the given shortened player name if found in the players username or display name
			print("found match")

			local usernameStart = string.find(string.lower(v.Name), target)
			local displayStart = string.find(string.lower(v.DisplayName), target)

			if usernameStart == 1 then --if the string found starts at the start of the string having ":cmd here" when the username is Iamhere is unexpected behavior
				table.insert(PossiblePlayers, string.lower(v.Name))
			elseif displayStart == 1 then --same thing but for display names
				table.insert(PossiblePlayers, string.lower(v.DisplayName))
			end
		end
	end

	local BestMatch = "no-one"

	for _, v in PossiblePlayers do
		print(v)
	end

	for i, v in PossiblePlayers do --loop through the candidates for the what the player meant
		print("looping")

		if i == 1 then --at the start of the loop, there is no best match, therefor by default the first candidate is the first best match
			BestMatch = v
		else
			local _, usernameEnd = string.find(v, target)
			local _, bestMatch_end = string.find(BestMatch, target)

			if usernameEnd > bestMatch_end then
				BestMatch = v
			elseif usernameEnd == bestMatch_end then
				UIUtils.Notify(player, "Error", "two players with same start of name, please be more specific")
				return nil
			end
		end
	end

	for _, v in Players:GetPlayers() do --this block converts the players displayName into the players Username for execution
		if string.lower(v.DisplayName) == BestMatch then --TODO remove edge case here where display name would take prevelance over username
			BestMatch = string.lower(v.Name)
		end
	end

	if getPlayer(BestMatch) then
		return getPlayer(BestMatch) --other mods would return a table, because some of them have multiple targets (e.g ArgLib.all), and all of them apart from this mod are executed in the same way. since arglib.player is 'special' it only needs to return a single value
	end

end

function ArgLib:me(player: Player)
    return { player }
end

function ArgLib:others(player: Player)
    local others = {}

    for _, plr in Players:GetPlayers() do -- this for loop may be inconsistent with other for loops because it doesn't use the pairs() iterator
        if plr ~= player then
            table.insert(others, plr)
        end
    end

    return others
end

function ArgLib:all()
    return Players:GetPlayers()
end

function ArgLib:random()
    
    local players = Players:GetPlayers()

    return { players[math.random(1, #players)] }
    
end

function ArgLib:randother(player: Player)
    local chosenPlayer = player
    local players = Players:GetPlayers()

    if #players <= 1 then
        return { }
    end

    repeat
        chosenPlayer = players[math.random(1, #players)]
    until chosenPlayer ~= player

    return { chosenPlayer }

end

function ArgLib:team(player, mod, args)
    local teamName = args[2]

    if game.Teams:FindFirstChild(teamName) then
        local team = game.Teams[teamName]
        local teamPlayers = {}

        for _, plr in Players:GetPlayers() do
            if plr.Team == team then
                table.insert(teamPlayers, plr)
            end
        end

        return teamPlayers

    else
        UIUtils.Notify(player, "Error", "Not a valid team")
    end

    return {}

end

return ArgLib