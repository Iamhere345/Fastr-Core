wait(1)

local pkg = script.Parent

local destinations = {
	{"ThumbnailCamera","Destroy"},
	{"Fastr_Main",game.ServerScriptService},
	{"Fastr_UI",game.StarterGui},
	{"Fastr_Remotes",game.ReplicatedStorage},
}

local blacklist = {
	{"docs","Enable-Script"}
}

local function CheckBlacklist(Entry,Type)
	for _,li in pairs(blacklist) do
		if li[1] == Entry and li[2] == Type then
			return true
		end
	end
	return false
end

for _,item in pairs(pkg:GetChildren()) do

	if item:IsA("Folder") then
		if not CheckBlacklist(item.Name,"Enable-Script") then
			for i,v in pairs(item:GetDescendants()) do
				if v:IsA("Script") then
					v.Disabled = false
				end
			end
		end
	end

	for x,dest in pairs(destinations) do

		if dest[1] == item.Name then

			if dest[2] == "Destroy" then
				item:Destroy()
				continue
			end

			if dest[3] == "Merge" and dest[2]:FindFirstChild(dest[1]) then
				for i,v in pairs(item) do
					v.Parent = dest[2][dest[1]]
				end
				item:Destroy()
			end

			item.Parent = dest[2]

		end

	end

	if item:IsA("Folder") then
		if not CheckBlacklist(item.Name,"Enable-Script") then
			for i,v in pairs(item:GetDescendants()) do
				if v:IsA("Script") then
					v.Disabled = false
				end
			end
		end
	end

end


for _,item in pairs(pkg:GetChildren()) do
	if item:IsA("Folder") then
		if not CheckBlacklist(item.Name,"Enable-Script") then
			for i,v in pairs(item:GetDescendants()) do
				if v:IsA("Script") then
					v.Disabled = false
				end
			end
		end
	end
end

pkg:Destroy()
