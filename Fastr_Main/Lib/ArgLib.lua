local ArgLib = {}
--these functions are called whenever a player uses the corresponding argument
local Fastr = script.Parent.Parent
local UIUtils = require(Fastr:WaitForChild("Utils"):WaitForChild("UIUtils"))

ArgUtils.ShortenedPlayerName = function(player,short) --you can use this for arguments other than the first one.
	
	local Target = short

	if game.Players:FindFirstChild(Target) then --if the player has typed in the full username of the target
		return Target
	end

	local PossiblePlayers = {}

	for i,v in pairs(game.Players:GetPlayers()) do --loops through players

		if string.find(v.Name,Target) or string.find(v.DisplayName,Target) then --if the the given shortened player name if found in the players username or display name

			if string.split(string.find(v.Name,Target)," ")[1] == "1" then --if the string found starts at the start of the string
				table.insert(PossiblePlayers,v.Name)
			elseif string.split(string.find(v.DisplayName,Target)," ")[1] == "1" then
				table.insert(PossiblePlayers,v.DisplayName)
			end

		end

	end

	local BestMatch = "no-one"

	for i,v in pairs(PossiblePlayers) do --loop through the candidates for the what the player meant

		if i == 1 then --at the start of the loop, there is no best match, therefor by default the first candidate is the first best match
			BestMatch = v
		else

			if string.find(v,Target)[2] > string.find(BestMatch,Target)[2] then
				BestMatch = v
			elseif string.find(v,Target)[2] == string.find(BestMatch,Target)[2] then
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
		return game.Players[BestMatch]
	else
		UIUtils.Notify(player,"Error","not a valid player name")
	end

end

ArgUtils.player = function(player,args,Command)
	local Target = args[1]
	
	if game.Players:FindFirstChild(Target) then --if the player has typed in the full username of the target
		Command(player,game.Players:FindFirstChild(Target))
		return nil
	end
	
	local PossiblePlayers = {}
	
	for i,v in pairs(game.Players:GetPlayers()) do --loops through players
		
		if string.find(v.Name,Target) or string.find(v.DisplayName,Target) then --if the the given shortened player name if found in the players username or display name
			
			if string.split(string.find(v.Name,Target)," ")[1] == "1" then --if the string found starts at the start of the string
				table.insert(PossiblePlayers,v.Name)
			elseif string.split(string.find(v.DisplayName,Target)," ")[1] == "1" then
				table.insert(PossiblePlayers,v.DisplayName)
			end
			
		end
		
	end
	
	local BestMatch = "no-one"
	
	for i,v in pairs(PossiblePlayers) do --loop through the candidates for the what the player meant

		if i == 1 then --at the start of the loop, there is no best match, therefor by default the first candidate is the first best match
			BestMatch = v
		else
			
			if string.find(v,Target)[2] > string.find(BestMatch,Target)[2] then
				BestMatch = v
			elseif string.find(v,Target)[2] == string.find(BestMatch,Target)[2] then
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
		Command(player,game.Players:FindFirstChild(BestMatch),args)
	else
		UIUtils.Notify(player,"Error","not a valid player name")
	end
	
end

ArgUtils.me = function(player,args,Command)
	Command(player,player,args)
end

ArgUtils.others = function(player,args,Command)
	for i,v in pairs(game.Players:GetPlayers()) do
		if v ~= player then
			Command(player,v,args)
		end
	end
end

ArgUtils.all = function(player,args,Command)
	for i,v in pairs(game.Players:GetChildren()) do
		Command(player,v,args)
	end
end

ArgUtils.random = function(player,args,Command)
	local ChosenPlayer = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
	
	Command(player,ChosenPlayer,args)
	
end

ArgUtils.randother = function(player,args,Command)
	
	local ChosenPlayer = player
	
	repeat
		local ChosenPlayer = game.Players:GetPlayers()[math.random(1,#game.Players:GetPlayers())]
	until ChosenPlayer ~= player
	
	Command(player,ChosenPlayer,args)
	
end

ArgUtils.team = function(player,args,Command)
	local TeamName = args[2]
	
	if game.Teams:FindFirstChild(TeamName) then
		local Team = game.Teams[TeamName]
		
		for _,Player in pairs(game.Players:GetPlayers()) do
			if Player.Team == Team then
				Command(player,Player,args)
			end
		end
		
	else
		UIUtils.Notify(player,"Error","Not a valid team")
	end
	
end

return ArgLib
