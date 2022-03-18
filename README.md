# Fastr

this file was written to teach you how to use fastr.

I am not responsible for any harm or moderation action caused by commands that you make or commands that have been
modifyed by you. if any of that stuff does happen, thats on you.

### Download

Source Version: https://www.roblox.com/library/7768369303/ <br>
Loader Version: https://www.roblox.com/library/7981503602/

### Installation

if you are using the loader version of fastr:

no installation needed! fastr will automatically install itself. i would recommend that you put fastr in ServerScriptService, though

if you are using the source version of fastr:

fastr will install automatically every time you start the game, but if you dont wan't that you can:

1. delete or disable the fast install script
2. put Fastr_Main in ServerScriptService
3. put Fastr_Remotes in ReplicatedStorage
4. put Fastr_UI in starterGui

### Configuring

to configure fastr, open the settings module.

Ranks: the table called ranks is for checking if a player has the correct permissions to use a command.
example: say you want your friend (whose name happens to be builderman) to have the permission level 1 in your game you would add this to the table:

{"Builderman",1} OR {156,1}

Group ranks: this is like the ranks table, but for groups.
e.g: you have a group with the id 1337, and you want people with the rank 250 to have the permission level 1.5:
{1337,250,1.5}

Key: this is the key that Fastr saves your data with. Change it to whatever you want, and if you ever want.

Prefix: this is what you put at the start of a command. by default it is ":", so if you wanted to use the fly command, you would have to say :fly.
you can change this to whatever you want (except characters like " or ' or %).

### Making Commands

prerequsites: knowledge of luau

to make a command, you must add a table to the commands module script.
command template:

```lua

Commands.(command name goes here) = {
	Name = "",
	Desc = "",
	Usage = "",
	PermissionLevel = 1,
	Modifyers = {},
	Aliases = {},
	Run = function(player,target,args)
		
	end
}

```

Name: this is for the :cmds command and the lexer to identify your command. make sure it is the same as the name you have used in the module (although).
another IMPORTANT thing to note is that the name you are using for the commands.(command name) is IT MUST BE ALL LOWERCASE, otherwise the user cannot call it.

Desc: a description of the command. this is useful for readability and is used by the :cmds command.

Usage: this is also good for readability and is also used in the :cmds command

PermissionLevel: remember when you learned about the ranks and groupRanks tables before? well the user's permission level must be greater than or equal to the PermissionLevel variable
of the command, otherwise they will be presented with an error telling them that they cannot run that command.

Modifyers: (THIS IS IMPORTANT) for commands with an argument like me or all or random, you have to specify if they can be used here. the defualt modifyers are: me, all, others, random,
randothers and team. also if you want to have an argument of the players name shortened (e.g :kill Shed instead of :kill Shedletsky) you must have at least one modifyer, (or you can just put
"player" in the table). these ONLY WORK FOR THE FIRST ARGUMENT, and if you want to use the shortend player name for any other arguments, you can use ArgUtils.ShortenedPlayerName() instead.

Aliases: these are not required, but they are (as the name suggests) aliases for your command. say you have a command called :kill and you have "stopliving" in the aliases table.
if you do that, doing :stopliving will be that same as :kill.

Run: this is the actual function where you put your code. it has three arguments: 

	player: the player that called the command. this is an instance, not a string
	target: the target player, which is nil if your command doesn't have a modifyer. this is an instance, not a string.
	args: these are all of the arguments for the command. if you used modifyers for your command, your first modifyer should be that modfyer. if the modifyer is team then the second modifyer
	will be the name of the team
	
example command:

```lua
Commands.kill = {
	Name = "kill",
	Desc = "kills the target player",
	Usage = ":kill <player> [amount of times you want to kill them]",
	PermissionLevel = 1.5,
	Modifyers = {"all","me","random","randother","others","team"},
	Aliases = {},
	Run = function(player,target,args)
		
		local TimesToRepeat = args[2]
		
		for i = 0,TimesToRepeat,1 do
			if target.Character then
				target.Character:WaitForChild("Humanoid"):TakeDamage(100)
			else
				target.CharacterAdded:Wait()
				target.Character:WaitForChild("Humanoid"):TakeDamage(100)
			end
	        end
	end
}
```
also there is already a command called kill by defualt so don't just copy and paste this lol.

### FAQ

Q: i've found a bug; how can i report it?

A: you can send me a DM on the devforums or roblox, or just contact me through the group wall of one of my groups :)

Q: im getting a message saying my loader won't be compatable with fastr soon, what do i do?

A: this means that you have an old version of fastr, so you can do 3 things: 1. migrate you current version of fastr over to a newer version 2. stick with your current version to 
see if a new update will break your installation 3. go to the loader script and change the UPDATE_CHANNEL variable to "COMPATABILITY".

Q: im getting a message saying that my version of fastr is old and won't work anymore. what do i do?

A: save as the question above, except you obviously can't do number 2.

Q: i don't want to have have updates, is there any way i can not get them?

A: yes, there is. use the source version of Fastr. this version wont update, but it is a bit more complicated to use.

### Menu Widgets

as of fastr version 0.63 you can now create your own widgets for the menu (which was also introduced in 0.63)!

if you are using the Fastr Loader:

go to your installation and create a folder and name it the name you would like for your widget. inside this put the gui stuff you would like to havee for your widget.
please keep in mind that the space you have for you ui is {0.775,0},{1,0}. while building your ui, you may want to put it inside a frame of that size.

if you are using the source version of fastr:

(this is a bit harder to do than the loader version)

step 1: go to Fastr_UI > Resources > Menu > Tabs, duplicate one of the text buttons and name it what you want your widget to be called and change the text property to che text to the name of your widget.
step 2: now go to Fastr_UI > Resources > MenuResources and create a folder that has the EXACT same name as the text button you just made (case sensitive).
step 3: go to Fastr_UI > Resources > Menu > MainMenu and build you ui there. when you are done drag the ui you made to the folder you made in step 2

### Editing Core_Commands

the core_commands script is a script that contains all of the default commands. this script is a ModuleScript, so you can manupulate it like a table.

prerequsites:
	an understanding of ModuleScripts
	an understanding of table and dictionaries
	
there is a designated script to put these edits in, call CoreCommandsEdits. you can find it in the loader.

lets say you don't want to have the btools command active, you could do this:

```lua
Core_Commands.btools = nil
```

if you wanted to change it's description, you could do this:

```lua
Core_Commands.btools.desc = "this is a different description"
```

the complete format of a command goes as follows:

```lua
Core_Commands.[command name here] = {
	Name = "Name",
	Desc = "Desc",
	Usage = ":command <argument> [optional argument]",
	PermissionLevel = 1.5,
	RepeatCeiling = 10,
	Modifyers = {"all","me","others","random","randother","team"},
	Aliases = {"othercommandname"}
	Run = function(player,target,args)
		print("code goes here")
	end
}
```
=======
Generated by [Rojo](https://github.com/rojo-rbx/rojo) 6.2.0.

## Getting Started
To build the place from scratch, use:

```bash
rojo build -o "Fastr.rbxlx"
```

Next, open `Fastr.rbxlx` in Roblox Studio and start the Rojo server:

```bash
rojo serve
```

For more help, check out [the Rojo documentation](https://rojo.space/docs).
>>>>>>> 36ddd82 (add rojo)
