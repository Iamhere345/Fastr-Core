--[[

Settings:
	Author: github.com/Iamhere345
	License: MIT
	Description: configuration file for Fastr. You can change these settings for different behavior.

]]

local Settings = {}

--read the readme file for more info

Settings.Ranks = { --add someone to this along with a permission level and they will have that permission level in this game. format goes like this: {username or userid,permission} e.g {"Builderman",2}
	{game.CreatorId,100}, --this line allows the creator of the game to have the maximum permission level (in the defualt commands, 2 is the highest permission level, but if you have your own commands with your own levels they could be higher, but i think 100  should be enough)	
	
}

Settings.GroupRanks = { --if someone in a specific group has a specific rank, they can have certain permissions. the format goes like this: {group,rank,permission}
	
}

Settings.DefaultRank = 100

Settings.waitForDS = false --wait for moderation data to load before loading the rest of the system

Settings.Key = "FN6akfa93" --the key that Fastr's datastore will use. If you change this you will lose all of Fastr's moderation data

--control characters
Settings.Prefix = ":" -- the character used at the beginning of a message to signify a command. This should not be changed to a pattern (e.g . or & or ^)

Settings.PipeChar  = "|" --used to 'pipe' the output of one command to the input of another.

Settings.RepeatChar = "*" --used to repeat a command a set amount of times

Settings.AndChar = "+" --used to have an extra command in the message

return Settings
