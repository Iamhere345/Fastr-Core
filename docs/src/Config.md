# Configuration

There are several setting you can change using Fastr's settings module.

### With the loader version:
Open the Fastr folder and you will see the settings module.

### With the souce version:
In the Fastr folder, navigate to: Fastr > Fastr_Server and you will see the settings module.

## Settings

### Ranks

this is a table that fastr uses to check if a user has the permissions required to run a command. The format is `userid,rank` or `username,rank`. the rank can be any number but the default rank is 0 for all users and the highest rank used in the default commands is 2. You set the minimum rank required to use a command in your own commands.

Example:

```lua
local Ranks = {
    {156,2},
    {"Builderman",2}
}
```

### Group Ranks

This is simular to the ranks table; it controls who has permissions to run different commands, except this is for groups, not idividual people. The first value is the `groupid`, the second is the `rank` and the third is the `permissionLevel`.

Example:

```lua
    local GroupRanks = {
        {1337,250,1.5}
    }
```

### Key

This is just the key that fastr uses for datastores. You can change it to whatever you want but be warned; if you ever want to change the key all previous data (including moderation data, i.e bans) will be wiped.

### Prefix

This is what you type before your command to let fastr know that you are typing a command. If you type `bring all` fastr won't do anything, but if you type `<prefix>bring all` it will bring all players to you. The default prefix is ":".

Example: `:tp all me`

### This page is a work in progress; not all information on this topic has been written yet.
