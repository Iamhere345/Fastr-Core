local Commands = game.ReplicatedStorage:WaitForChild("Fastr_Remotes").GetCmdData:InvokeServer()

print(Commands)

for i,command in pairs(Commands) do
	
	script.Parent.CanvasSize += UDim2.new(0,0,0.1,0)

	local cmd = script.Parent.Parent.Parent.Parent.CommandInfo:Clone()
	cmd.Parent = script.Parent
	cmd.Name = command.Name

	cmd.Info.Name = command.Name.."_Info"
	cmd[command.Name.."_Info"].Parent = script.Parent

	local info = script.Parent:FindFirstChild(command.Name.."_Info")

	cmd.Text = command.Name

	local Aliases_Displayed = nil


	if command.Aliases then
		for x,a in pairs(command.Aliases) do
			if Aliases_Displayed then
				Aliases_Displayed = Aliases_Displayed..", "..a
			else
				Aliases_Displayed = a
			end
		end
	end

	if Aliases_Displayed then
		info.Aliases.Text = "Aliases: "..Aliases_Displayed
	else
		info.Aliases.Text = "Aliases: none"
	end

	if command.Usage then
		info.Usage.Text = "Usage: "..command.Usage
	else
		info.Usage.Text = "Usage: none"
	end

	if command.Desc then
		info.Desc.Text = "Description: "..command.Desc
	else
		info.Desc.Text = "Description: none"
	end

end
