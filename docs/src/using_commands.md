# Using Commands

## Basic usage

To execute a command, type the prefix, then the command's name (`:cmds` brings up a menu of all the commands). By default, the prefix is ":"

### Arguments

Some commands require additional information to run. For instance, the `ban` command needs to know which player you want to ban and for how long. Arguments go in a specific order; the `ban` command must have the player passed first, then the time. Some commands are optional; in Fastr's list of commands, these are annotated like this: `[optional argument]`, and required arguments are annotated like this: `<required argument>`.

Example: `Command <arg1> <arg2> [arg3]>`

### Modifiers

Some words can be used as arguments. These words are: `all me random others randother team`. 
- all: this modifier represents every player on the server. Example: `:bring all`
- me: this passes the player that called the command as an argument. Example: `:kill me`
- random: this passes a random player to the command. Example: `:bring random`
- others: this passes every player apart from the player calling the command. Example: `:kick others`
- randother: this passes a random player that is not the player who called it. `:kick randother`
- team: this command takes the argument placed after the `team` argument and sees if it's a valid team. If it is a valid team, Fastr will pass every player in that team. `:bring team red`
- player: this modifier is very different to the other modifiers: this modifier will be avaliable if the command has any modifier. All this means is if you type in a player's username or display name or you type in some of a player's username or display name it will pass that player as an argument.

### Flags

Flags are similar to arguments; they can modify the behavior of the command and are specified by the user. Flags are do not hold any information (currently), the only information the carry is weather they exist. Flags must be written with a hyphen.

Example: `:command -f`
Example `:fly -n`

## Advanced Usage

### Command Bar

If you press the backslash button on your keyboard ('\\\'), a command bar will appear on the bottom of your screen. You can type out commands from the command bar without using the prefix. Any commands you type here will also not be displayed in the chat. Anyone can access the command bar, but only people with the correct permissions can execute commands.

### Chaining Commands

You can chain multiple commands together using the Chain operator (by default "+"). All this does is executes multiple commands in one message. 

Example: `:m 5 splitting teams + splitteam team1 team2 team3`

### Piping commands

Using the pipe operator (by default, it's "|"), you can use a command as an argument for a command. This only works if that command returns something. The format for piping a command is `Command1 | commandThatWillBePiped`. The first command will run after the piped command has run. Look up "piping in Unix" to learn more about piping commands.

Example: `:team all | createteam reallyRed red_team`

### Repeating Commands

Like the name suggests, you can repeat commands. This will repeat the given command a certain amount of times. The default repeat operator is "*".

Example: `:kill random * 55`
