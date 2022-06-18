--//services
local uis = game:GetService("UserInputService")
local rs = game:GetService("RunService")
local tween = game:GetService("TweenService")
--//references
local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local humanoid = char:WaitForChild("Humanoid")
local camera = workspace.CurrentCamera
local BodyVel: BodyVelocity
local BodyGyro: BodyGyro
--//dependencies
local playerModule = require(player.PlayerScripts:WaitForChild("PlayerModule"))
--//logic
local speed: number = 30
local ForwardToggle = false
local flying = false
--//connections
local RS: RBXScriptConnection?
local IE: RBXScriptConnection?
local IB: RBXScriptConnection?
local TF: RBXScriptConnection
local NE: RBXScriptConnection?
local camCF: RBXScriptConnection


local function fly(noclip_enabled)

	flying = true

	humanoid.PlatformStand = true
	hrp.Velocity = Vector3.new(0, 0, 0)

	local controls = playerModule:GetControls()
	local velY: number = 0

	BodyGyro = Instance.new("BodyGyro", hrp)
	BodyGyro.MaxTorque = Vector3.new(5000, 5000, 5000)
	BodyGyro.P = 2500
	BodyGyro.CFrame = hrp.CFrame
	BodyGyro.D = 250

	BodyVel = Instance.new("BodyVelocity", hrp)
	BodyVel.MaxForce = Vector3.new(5000, 5000, 5000)
	BodyVel.P = 2500
	BodyVel.Velocity = Vector3.new(0, 0, 0)

	camCF =  camera:GetPropertyChangedSignal("CFrame"):Connect(function()
		BodyGyro.CFrame = camera.CFrame
		--print(controls:GetMoveVector())
	end)

	RS = nil
	RS = rs.RenderStepped:Connect(function()
		local input: Vector3 = controls:GetMoveVector()

		BodyVel.Velocity = ((camera.CFrame * CFrame.new(input.X, velY, input.Z)).Position - camera.CFrame.Position) * speed


	end)

	NE = nil
	if noclip_enabled then
		NE = rs.Stepped:Connect(function(time, deltaTime)
			for _,v in pairs(char:GetDescendants()) do
				if v:IsA("BasePart") then
					v.CanCollide = false
				end
			end
		end)
	end

	IB = nil
	IB  = uis.InputBegan:Connect(function(input, internallyProcessed)
		
		if internallyProcessed then return end

		if input.KeyCode == Enum.KeyCode.R then
			if velY == -1 then
				velY = 0
			else
				velY = 1
			end
		elseif input.KeyCode == Enum.KeyCode.F then
			if velY == 1 then
				velY = 0
			else
				velY = -1
			end
		end

	end)

	IE = nil
	IE = uis.InputEnded:Connect(function(input, internallyProcessed)
		
		if internallyProcessed then return end

		if input.KeyCode == Enum.KeyCode.R or input.KeyCode == Enum.KeyCode.F then
			velY = 0
		end

	end)

end

local function StopFlying()
	char.Humanoid.PlatformStand = false
	camCF:Disconnect()
	RS:Disconnect()
	IB:Disconnect()
	IE:Disconnect()
	BodyGyro:Destroy()
	BodyVel:Destroy()

	if NE then
		NE:Disconnect()
	end
end

game.ReplicatedStorage:WaitForChild("Fastr_Remotes").Fly.OnClientEvent:Connect(function(noclip_enabled)
	if not flying then
		local FC = script.Parent.Parent.Resources.FlightControl:Clone() --flight control gui
		FC.Parent = script.Parent

		local FCT = tween:Create(FC, TweenInfo.new(0.5), { Position = UDim2.new(0.85, 0, 0.8, 0) }) --flight control gui tween
		FCT:Play()

		FCT.Completed:Wait()

		fly(noclip_enabled)

		local IB_flightToggle: RBXScriptConnection

		IB_flightToggle = uis.InputBegan:Connect(function(input, otherInput)
			if input.KeyCode == Enum.KeyCode.E and not otherInput then
				if flying == true then
					StopFlying()
					flying = false
				elseif flying == false then
					fly(noclip_enabled)
				end
			end
		end)

		TF = script.Parent.FlightControl.ToggleGoForward.MouseButton1Click:Connect(function()
			if ForwardToggle == false then
				ForwardToggle = true
			else
				ForwardToggle = false
				BodyVel.Velocity = Vector3.new(0, 0, 0)
			end
		end)

		script.Parent:WaitForChild("FlightControl").StopFlight.MouseButton1Click:Connect(function()
			IB_flightToggle:Disconnect()
			TF:Disconnect()
			StopFlying()
			script.Parent.FlightControl:Destroy()
			flying = false
		end)
	end
end)
