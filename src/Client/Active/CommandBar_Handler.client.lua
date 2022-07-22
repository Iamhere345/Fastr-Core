--[[

CommandBar_Handler:
	Author: github.com/Iamhere345
	License: MIT,
	Description: handles effects and inputs for the command bar. If the '\' key is press it will tween the command bar onto the screen,
	and if a message is entered it will send that to the parser via a remote event, where it will be validated. One future feature for the
	command bar is autocomplete, but that has not been fully implemented yet (you can see the progress in the UpdateCmdBarAutoFill() function).

]]

local uis = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local CmdData = game.ReplicatedStorage:WaitForChild("Fastr_Remotes").GetCmdData:InvokeServer()
local Cmds = {}

local IsFocused = false
local IsOpen = false
local debounce = false

local CommandBar = script.Parent.Parent.Resources.CommandBar:Clone() --im fetching the command bar ui from resources so it will reset every time it is close.
CommandBar.Parent = script.Parent

local function CreateCommandBarAnims(obj)
	local OpenCommandBar = TweenService:Create(obj, TweenInfo.new(0.5), { Position = UDim2.new(0, 0, 1, 0) })
	local CloseCommandBar = TweenService:Create(obj, TweenInfo.new(0.5), { Position = UDim2.new(-1, 0, 1, 0) })

	return OpenCommandBar, CloseCommandBar
end

-- selene: allow(unused_variable)
local function UpdateCmdBarAutoFill(text) --wip, will be coming soon(tm)
	local Cmd

	if string.split(text, " ")[2] then
		Cmd = string.split(text, " ")[1]
	else
		Cmd = text
	end

	local suggested_cmds = {}

	for _, c in ipairs(Cmds) do --checks for similar commands to what the user just typed
		local startI, endI = string.find(Cmd, c)

		if startI and startI == 1 then
			table.insert(suggested_cmds, { c, endI })
		end
	end

	table.sort(suggested_cmds, function(cmdA, cmdB)
		if cmdA[2] > cmdB[2] or cmdA[2] == cmdB[2] then
			return true
		else
			return false
		end
	end)
end

local OpenCommandBar, CloseCommandBar = CreateCommandBarAnims(CommandBar)

local function ExecuteCommand(CommandBarObj)
	local Focus = CommandBarObj.Focused:Connect(function()
		IsFocused = true

		uis.InputBegan:Connect(function(key)
			--UpdateCmdBarAutoFill(CommandBarObj.Text)

			if key.KeyCode == Enum.KeyCode.Return and IsFocused then
				CommandBarObj:ReleaseFocus()
				IsFocused = false

				game.ReplicatedStorage:WaitForChild("Fastr_Remotes").ExecuteCommand:FireServer(CommandBarObj.Text)
			end
		end)
	end)

	CommandBarObj.FocusLost:Connect(function(enterPressed)
		if not enterPressed then
			IsFocused = false

			Focus:Disconnect()
		end
	end)

	return Focus
end

for _, c in pairs(CmdData) do --we only need the names of the commands for UpdateCmdAutoFill(), so only using the commands will elimenate some complexity
	if c.Name then
		table.insert(Cmds, c.Name)
	end
end

uis.InputBegan:Connect(function(key, internallyActed)
	local Focus

	if key.KeyCode == Enum.KeyCode.BackSlash and not internallyActed then
		if not debounce then
			debounce = true

			Focus = ExecuteCommand(CommandBar)

			CommandBar:CaptureFocus()

			if IsOpen then
				CloseCommandBar:Play()

				CloseCommandBar.Completed:Wait()

				CommandBar:Destroy() --reset command bar
				CommandBar = script.Parent.Parent.Resources.CommandBar:Clone()
				CommandBar.Parent = script.Parent

				Focus:Disconnect() --disconnect events for last command bar
				OpenCommandBar, CloseCommandBar = CreateCommandBarAnims(CommandBar) --reset tweens

				Focus = ExecuteCommand(CommandBar)

				IsOpen = false
			else
				OpenCommandBar:Play()

				IsOpen = true

				CommandBar.Text = ""
			end

			wait(0.2)

			debounce = false
		end
	end
end)
