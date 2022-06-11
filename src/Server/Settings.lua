local Settings = {}

--read the readme file for more info
--please remember that this is version 1.0, so there will be more things that you can configure from here in the future. for now you can do more by adding, removing or tweaking code.

Settings.Ranks = { --add someone to this along with a permission level and they will have that permission level in this game. format goes like this: {username or userid,permission} e.g {"Builderman",2}
	{game.CreatorId,100}, --this line allows the creator of the game to have the maximum permission level (in the defualt commands, 2 is the highest permission level, but if you have your own commands with your own levels they could be higher, but i think 100  should be enough)	
	
}

Settings.GroupRanks = { --if someone in a specific group has a specific rank, they can have certain permissions. the format goes like this: {group,rank,permission}
	
}

Settings.DefaultRank = 100

Settings.waitForDS = false --wait for moderation data to load before loading the rest of the system

Settings.Key = "FN6akfa93" --the key that Fastr's datastore will use. If you change this you will lose all of Fastr's moderation data

--control characters
Settings.Prefix = ":"

Settings.PipeChar  = "|"

Settings.RepeatChar = "*"

Settings.AndChar = "+"

return Settings
