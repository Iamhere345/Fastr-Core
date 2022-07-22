--[[

UI_Handler:
	Author: github.com/Iamhere345
	License: MIT
	Description: receives remote events from the server and show the corresponding ui when they are fired. This script handles messages,
	countdown, and most notably notifications - which can be customised by the remote event extensibly.

]]

local TweenService = game:GetService("TweenService")
local remotes = game.ReplicatedStorage:WaitForChild("Fastr_Remotes")
local resources = script.Parent.Parent.Resources

local Notif_Types = {
	["Error"] = {
		TopBarMsg = "Error",
		Msg = "Fastr has encountered an error",
		Colour = Color3.new(1, 0.198383, 0.192981),
		Duration = 5,
	},
	["Alert"] = {
		TopBarMsg = "Alert",
		Msg = "Be Alert!",
		Colour = Color3.new(0, 0.964309, 0.126268),
		Duration = 7,
	},
}

remotes.ShowNotification.OnClientEvent:Connect(function(Type, Msg, TopBarMsg, Colour, Duration)
	if Notif_Types[Type] and Type ~= nil then
		local TypeActual = Notif_Types[Type]

		if not TopBarMsg then
			TopBarMsg = TypeActual.TopBarMsg
		end

		if not Msg then
			Msg = TypeActual.Msg
		end

		if not Colour then
			Colour = TypeActual.Colour
		end

		if not Colour then
			Duration = TypeActual.Duration
		end
	end

	if not Duration then
		Duration = 5
	end

	local Notif = resources.Notification:Clone()
	Notif.Parent = script.Parent

	if TopBarMsg then
		Notif.TopBar.Text = TopBarMsg
	end

	if Colour then
		Notif.TopBar.BackgroundColor3 = Colour
	end

	Notif.Msg.Text = Msg

	local tween = TweenService:Create(Notif, TweenInfo.new(0.5), { Position = UDim2.new(0.85, 0, 0.8, 0) })

	tween:Play()
	tween.Completed:Wait()

	task.wait(Duration)

	local tween2 = TweenService:Create(Notif, TweenInfo.new(0.5), { Position = UDim2.new(1, 0, 0.8, 0) })

	tween2:Play()
	tween2.Completed:Wait()

	Notif:Destroy()
end)

remotes.ShowMessage.OnClientEvent:Connect(function(msg, player, duration)
	local message = resources.Message:Clone()
	message.Parent = script.Parent

	message.ByLine.Text = player .. " says:"
	message.Message.Text = msg

	local t1 = TweenService:Create(message, TweenInfo.new(0.5), { BackgroundTransparency = 0.45 })
	local t2 = TweenService:Create(message.ByLine, TweenInfo.new(0.5), { TextTransparency = 0 })
	local t3 = TweenService:Create(message.Message, TweenInfo.new(0.5), { TextTransparency = 0 })

	t1:Play()
	t2:Play()
	t3:Play()

	t3.Completed:Wait()

	task.wait(duration)

	local t4 = TweenService:Create(message, TweenInfo.new(0.5), { BackgroundTransparency = 1 })
	local t5 = TweenService:Create(message.ByLine, TweenInfo.new(0.5), { TextTransparency = 1 })
	local t6 = TweenService:Create(message.Message, TweenInfo.new(0.5), { TextTransparency = 1 })

	t4:Play()
	t5:Play()
	t6:Play()

	t6.Completed:Wait()

	message:Destroy()
end)

remotes.ShowSmallMessage.OnClientEvent:Connect(function(msg, player, duration)
	local message = resources.SmallMessage:Clone()
	message.Parent = script.Parent

	message.Text = player .. " says: " .. msg

	local tween = TweenService:Create(
		message,
		TweenInfo.new(0.5),
		{ BackgroundTransparency = 0.45, TextTransparency = 0 }
	)

	tween:Play()

	tween.Completed:Wait()

	task.wait(duration)

	local tween2 = TweenService:Create(
		message,
		TweenInfo.new(0.5),
		{ BackgroundTransparency = 1, TextTransparency = 1 }
	)

	tween2:Play()

	tween2.Completed:Wait()

	message:Destroy()
end)

remotes.ShowCountdown.OnClientEvent:Connect(function(Time)
	local countdown = resources.SmallMessage:Clone()
	countdown.Parent = script.Parent

	countdown.Text = Time

	local tween = TweenService:Create(
		countdown,
		TweenInfo.new(0.5),
		{ BackgroundTransparency = 0.45, TextTransparency = 0 }
	)

	tween:Play()

	tween.Completed:Wait()

	task.wait(0.5)

	for i = Time - 1, 0, -1 do
		countdown.Text = i
		task.wait(1)
	end

	local tween2 = TweenService:Create(
		countdown,
		TweenInfo.new(0.5),
		{ BackgroundTransparency = 1, TextTransparency = 1 }
	)

	tween2:Play()

	tween2.Completed:Wait()

	countdown:Destroy()
end)
