local TweenService = game:GetService("TweenService")
local OpenMenu = game.ReplicatedStorage:WaitForChild("Fastr_Remotes"):WaitForChild("OpenMenu")
local src = script.Parent.Parent.Resources.MenuResources

local PrevPage = nil

local function OpenPage(page,MainMenu)

	if PrevPage then

		for i,v in pairs(MainMenu:GetChildren()) do
			v.Parent = src:FindFirstChild(PrevPage)
		end

	end

	for i,v in pairs(src:FindFirstChild(page):GetChildren()) do
		v.Parent = MainMenu
	end

	PrevPage = page

end

local function ClosePage(MainMenu)

	if PrevPage then

		for i,v in pairs(MainMenu:GetChildren()) do
			v.Parent = src:FindFirstChild(PrevPage)
		end

	end

end

OpenMenu.OnClientEvent:Connect(function(page)

	local Menu = script.Parent.Parent.Resources:WaitForChild("Menu")

	Menu.Parent = script.Parent

	for i,tab in pairs(Menu.Tabs:GetChildren()) do

		if tab.ClassName ~= "UIListLayout" then
			
			local t1 = tab.MouseEnter:Connect(function()
				local HoverEffect = TweenService:Create(tab,TweenInfo.new(0.25),{Transparency = 0.5}):Play()
			end)

			local t2 = tab.MouseLeave:Connect(function()
				local UnHoverEffect = TweenService:Create(tab,TweenInfo.new(0.25),{Transparency = 0}):Play()
			end)

			local t3 = tab.MouseButton1Click:Connect(function()
				OpenPage(tab.Name,Menu.MainMenu)
			end)

			Menu.Exit.Activated:Connect(function()

				t1:Disconnect()
				t2:Disconnect()
				t3:Disconnect()

				ClosePage(Menu.MainMenu)
				
				Menu.Parent = src.Parent
				
			end)

		end
	end

	OpenPage(page,Menu.MainMenu)

end)