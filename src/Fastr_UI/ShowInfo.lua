local TweenService = game:GetService("TweenService")
local IsOpen = false

script.Parent.MouseButton1Click:Connect(function()
	
	local Info = script.Parent.Parent.Parent:FindFirstChild(script.Parent.Parent.Name.."_Info")
	
	if IsOpen then
		local TweenButton = TweenService:Create(script.Parent,TweenInfo.new(0.5),{Rotation = 90})
		local Tween_Info = TweenService:Create(Info,TweenInfo.new(0.5),{Size = UDim2.new(0.95,0,0,0)})

		TweenButton:Play()
		Tween_Info:Play()
		
		IsOpen = false
		
		task.wait(0.1)
		
		for i,v in pairs(Info:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Visible = false
			end
		end
		
	else
		local TweenButton = TweenService:Create(script.Parent,TweenInfo.new(0.5),{Rotation = -90})
		local Tween_Info = TweenService:Create(Info,TweenInfo.new(0.5),{Size = UDim2.new(0.95,0,0.15,0)})
		
		TweenButton:Play()
		Tween_Info:Play()
		
		IsOpen = true
		
		task.wait(0.1)
		
		for i,v in pairs(Info:GetChildren()) do
			if v:IsA("TextLabel") then
				v.Visible = true
			end
		end
		
	end
end)
