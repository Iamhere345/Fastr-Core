local uis = game:GetService("UserInputService")
local tween = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local camera = workspace.CurrentCamera
local ForwardToggle = false
local BodyVel
local BodyGyro
local camCF
local IE
local IB
local TF
local flying = false

local function fly(speed)
	
	flying = true
	char.Humanoid.PlatformStand = true
	
	char.HumanoidRootPart.Velocity = Vector3.new(0,0,0)
	
	BodyGyro = Instance.new("BodyGyro",hrp)
	BodyGyro.MaxTorque = Vector3.new(5000,5000,5000)
	BodyGyro.P = 2500
	BodyGyro.CFrame = hrp.CFrame
	BodyGyro.D = 250

	BodyVel = Instance.new("BodyVelocity",hrp)
	BodyVel.MaxForce = Vector3.new(5000,5000,5000)
	BodyVel.P = 2500
	BodyVel.Velocity = Vector3.new(0,0,0)
	
	if ForwardToggle == true then
		BodyVel.Velocity = camera.CFrame.LookVector * 65
	end
	
	camCF = camera:GetPropertyChangedSignal("CFrame"):Connect(function() --TODO: switch to CAS

		if uis:IsKeyDown(Enum.KeyCode.W) or ForwardToggle == true then
			BodyVel.Velocity = camera.CFrame.LookVector * 65
		end

		if uis:IsKeyDown(Enum.KeyCode.A) then
			BodyVel.Velocity = camera.CFrame.RightVector * -65
		end

		if uis:IsKeyDown(Enum.KeyCode.S) then
			BodyVel.Velocity = camera.CFrame.LookVector * -65
		end

		if uis:IsKeyDown(Enum.KeyCode.D) then
			BodyVel.Velocity = camera.CFrame.RightVector * 65
		end
		
		if uis:IsKeyDown(Enum.KeyCode.R) then
			BodyVel.Velocity = camera.CFrame.UpVector * 65
		end
		
		if uis:IsKeyDown(Enum.KeyCode.F) then
			BodyVel.Velocity = camera.CFrame.UpVector * -65
		end

		if BodyGyro and BodyGyro.Parent then
			BodyGyro.CFrame = camera.CFrame
		end

	end)

	IE = uis.InputEnded:Connect(function(input)
		if input.KeyCode == Enum.KeyCode.W then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
		if input.KeyCode == Enum.KeyCode.A then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
		if input.KeyCode == Enum.KeyCode.S then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
		if input.KeyCode == Enum.KeyCode.D then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
		if input.KeyCode == Enum.KeyCode.R then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
		if input.KeyCode == Enum.KeyCode.F then
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
	end)
end

local function StopFlying()
	char.Humanoid.PlatformStand = false
	camCF:Disconnect()
	IE:Disconnect()
	BodyGyro:Destroy()
	BodyVel:Destroy()
end

game.ReplicatedStorage:WaitForChild("Fastr_Remotes").Fly.OnClientEvent:Connect(function()
	
	local FC = script.Parent.Parent.Resources.FlightControl:Clone() --flight control gui
	FC.Parent = script.Parent
	
	local FCT = tween:Create(FC,TweenInfo.new(0.5),{Position = UDim2.new(0.85,0,0.8,0)}) --flight control gui tween
	FCT:Play()
	
	FCT.Completed:Wait()
	
	if flying == false then
		fly()
	end

	IB = uis.InputBegan:Connect(function(input,otherInput)
		if input.KeyCode == Enum.KeyCode.E and not otherInput then
			if flying == true then
				StopFlying()
				flying = false
			elseif flying == false then
				fly()
			end
		end
	end)
	
	TF = script.Parent.FlightControl.ToggleGoForward.MouseButton1Click:Connect(function()
		if ForwardToggle == false then
			ForwardToggle = true
		else
			ForwardToggle = false
			BodyVel.Velocity = Vector3.new(0,0,0)
		end
	end)
	
	script.Parent:WaitForChild("FlightControl").StopFlight.MouseButton1Click:Connect(function()
		IB:Disconnect()
		TF:Disconnect()
		StopFlying()
		script.Parent.FlightControl:Destroy()
		flying = false
	end)
	
end)
