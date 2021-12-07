--this is the exprirmental loader for fastr admin

local channels = { --other channels coming soon
	["STABLE"] = 7981493975,
	["UNSTABLE"] = 0000,
	["EXPERIMENTAL"] = 0000,
	["COMPATABILITY"] = 0000
}

local UPDATE_CHANNEL = "STABLE"  --options for the update channel: this is the main version "STABLE" this is the version i use for features that currently don't work well "UNSTABLE" this is what i use for prototyping ideas for fastr "EXPERIMENTAL" if you get a warning saying that your loader version is too old then switch your update channel to "COMPATABILITY"
local LoaderVersion = 0.63 --if you change this it could stop fastr to stop working for you. this is used to check the compatability of your version of the loader and the latest version of

local fastr = require(channels[UPDATE_CHANNEL])

fastr.Initialise(script.Parent,LoaderVersion)

fastr.Parent = game.Workspace

script.Parent:Destroy()
