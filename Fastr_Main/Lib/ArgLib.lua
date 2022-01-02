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

ArgLib.player = function(player,Target)
	
	if game.Players:FindFirstChild(Target) then --if the player has typed in the full username of the target
		return game.Players:FindFirstChild(Target)
	end
	
	local PossiblePlayers = {}
	
	for i,v in pairs(game.Players:GetPlayers()) do --loops through players
		
		if string.find(v.Name,Target) or string.find(v.DisplayName,Target) then --if the the given shortened player name if found in the players username or display name
			
			local usernameStart,usernameEnd = string.find(v.Name,Target)
			local displayStart,DisplayEnd = string.find(v.Name,Target)
			
			if usernameStart == 1 then --if the string found starts at the start of the string having ":cmd here" when the username is Iamhere is unexpected behavior
				table.insert(PossiblePlayers,v.Name)
			elseif displayStart == 1 then --same thing but for display names
				table.insert(PossiblePlayers,v.DisplayName)
			end
			
		end
		
	end
	
	local BestMatch = "no-one"
	
	for i,v in pairs(PossiblePlayers) do --loop through the candidates for the what the player meant

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
		if v.DisplayName == BestMatch then
			v.Name = BestMatch
		end
	end
	
	if game.Players:FindFirstChild(BestMatch) then
		return game.Players:FindFirstChild(BestMatch) --other mods would return a table, because some of them have multiple targets (e.g ArgLib.all), and all of them apart from this mod are executed in the same way. since arglib.player is 'special' it only needs to return a single value 
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
		
	else
		UIUtils.Notify(player,"Error","Not a valid team")
	end
	
end

return ArgLib

