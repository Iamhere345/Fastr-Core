local ArgLib = {}
--these functions are called whenever a player uses the corresponding argument
local Fastr = script.Parent.Parent
local UIUtils = require(Fastr:WaitForChild("Utils"):WaitForChild("UIUtils"))

ArgLib.CheckMod = function(player,PossibleMod,args)
	if ArgLib[PossibleMod] then
		return ArgLib[PossibleMod](player,PossibleMod,args)
	else
		return nil
	end
end

ArgLib.player = function(player: Object,Target: string)
	
	print("fired player")
	
	local function GetPlayer(name: string)
		for _,p in pairs(game.Players:GetPlayers()) do
			if string.lower(p.Name) == name then
				return p
			end
		end
	end

	local function GetPlayerByDisplayName(displayName: string)
		for _,p in pairs(game.Players:GetPlayers()) do
			if string.lower(p.DisplayName) == displayName then
				return p
			end
		end
	end

	if not Target then
		return nil
	end

	Target = string.lower(Target)

	if GetPlayer(Target) then --if the player has typed in the full username of the target
		return GetPlayer(Target)
	end
	
	if GetPlayerByDisplayName(Target) then
		return GetPlayerByDisplayName(Target)
	end
	
	local PossiblePlayers = {}

	for i,v in pairs(game.Players:GetPlayers()) do --loops through players

		if string.find(string.lower(v.Name),Target) or string.find(string.lower(v.DisplayName),Target) then --if the the given shortened player name if found in the players username or display name
			
			print("found match")
			
			local usernameStart,usernameEnd = string.find(string.lower(v.Name),Target)
			local displayStart,DisplayEnd = string.find(string.lower(v.DisplayName),Target)

			if usernameStart == 1 then --if the string found starts at the start of the string having ":cmd here" when the username is Iamhere is unexpected behavior
				table.insert(PossiblePlayers,string.lower(v.Name))
			elseif displayStart == 1 then --same thing but for display names
				table.insert(PossiblePlayers,string.lower(v.DisplayName))
			end
			
			else
			
		end

	end

	local BestMatch = "no-one"
	
	for _,v in pairs(PossiblePlayers) do
		print(v)
	end
	
	for i,v in pairs(PossiblePlayers) do --loop through the candidates for the what the player meant
		
		print("looping")
		
		if i == 1 then --at the start of the loop, there is no best match, therefor by default the first candidate is the first best match
			BestMatch = v
		else

			local usernameStart,usernameEnd = string.find(v,Target)
			local bestMatch_start,bestMatch_end = string.find(BestMatch,Target)

			if usernameEnd > bestMatch_end then
				BestMatch = v
			elseif usernameEnd == bestMatch_end then
				UIUtils.Notify(player,"Error","two players with same start of name, please be more specific")
				return nil
			end

		end

	end

	for i,v in pairs(game.Players:GetPlayers()) do --this block converts the players displayName into the players Username for execution
		if string.lower(v.DisplayName) == BestMatch then
			BestMatch = string.lower(v.Name)
		end
	end

	if GetPlayer(BestMatch) then
		return GetPlayer(BestMatch) --other mods would return a table, because some of them have multiple targets (e.g ArgLib.all), and all of them apart from this mod are executed in the same way. since arglib.player is 'special' it only needs to return a single value 
	else
		--UIUtils.Notify(player,"Error","not a valid player name")
	end

end

ArgLib.me = function(player)
	return {player}
end

ArgLib.others = function(player)

	local OthersTable = {}

	for i,v in pairs(game.Players:GetPlayers()) do
		if v ~= player then
			table.insert(OthersTable,v)
		end
	end

	return OthersTable

end

ArgLib.all = function()
	return game.Players:GetPlayers()
end

ArgLib.random = function()
	return {game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]}
end

ArgLib.randother = function(player)

	local ChosenPlayer = player

	if #game.Players:GetPlayers() > 1 then
		return {} --return an empty table instead of nil to prevent throwing an error
	end

	repeat
		ChosenPlayer = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
	until ChosenPlayer ~= player

	return {ChosenPlayer}

end

ArgLib.team = function(player,mod,args)
	local TeamName = args[2]

	if game.Teams:FindFirstChild(TeamName) then
		local Team = game.Teams[TeamName]

		local PlayersInTeam = {}

		for _,Player in pairs(game.Players:GetPlayers()) do
			if Player.Team == Team then
				table.insert(PlayersInTeam,Player)
			end
		end

		return PlayersInTeam

	else
		UIUtils.Notify(player,"Error","Not a valid team")
	end

end

return ArgLib
