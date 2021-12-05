local MainModule = {}

local MinimumLoaderVersion = 0.63
local WarningLoaderVersion = 0.62

local function CompileMenuWidgets(widgets,menu,MenuResources)

	for i,v in pairs(widgets:GetChildren()) do

		local newWidget = menu.Tabs.Help:Clone()
		newWidget.Parent = menu.Tabs
		newWidget.Name = v.Name
		newWidget.Text = v.Name

		v.Parent = MenuResources

	end

end

MainModule.Initialise = function(root,Loaderversion)

	if Loaderversion >= MinimumLoaderVersion then

		if Loaderversion <= WarningLoaderVersion then
			warn("your fastr loader is old and it is possible that it could become incompatable with fastr soon")
		end

		root.Settings.Parent = script.FastrPackage.Fastr_Main

		local Settings = require(script.FastrPackage.Fastr_Main.Settings)

		if Settings.SoftLoad == true then

			game.Loaded:Wait()

			local Cmds = script.FastrPackage.Fastr_Main.Core.Commands
			local Resources = script.FastrPackage.Fastr_Main.Resources
			local Remotes = script.FastrPackage.Fastr_Remotes

			for i,v in pairs(root.Commands:GetChildren()) do
				v.Parent = Cmds
				wait(0.05)
			end

			for i,v in pairs(root.Resources:GetChildren()) do
				v.Parent = Resources
				wait(0.05)
			end

			for i,v in pairs(root.Remotes:GetChildren()) do
				v.Parent = Remotes
				wait(0.05)
			end

		else

			for i,v in pairs(root.Commands:GetChildren()) do
				v.Parent = script.FastrPackage.Fastr_Main.Core.Commands
			end

			for i,v in pairs(root.Resources:GetChildren()) do
				v.Parent = script.FastrPackage.Fastr_Main.Resources
			end

			for i,v in pairs(root.Remotes:GetChildren()) do
				v.Parent = script.FastrPackage.Fastr_Remotes
			end

		end

		CompileMenuWidgets(root.MenuWidgets,script.FastrPackage.Fastr_UI.Resources.Menu,script.FastrPackage.Fastr_UI.Resources.MenuResources)

		wait(1)

		for i,player in pairs(game.Players:GetPlayers()) do
			print(player.Name)
			local ui = script.FastrPackage.Fastr_UI:Clone()
			ui.Parent = player.PlayerGui
		end


		script.FastrPackage.FastInstall.Disabled = false

		script.FastrPackage:Clone().Parent = game.workspace

		script.FastrPackage:Destroy()

	else
		warn("your loader version in incompatable with the latest version of fastr in this update channel. check the faq for more info and how to fix this")
		script.Parent:Destroy()
	end
end

return MainModule
