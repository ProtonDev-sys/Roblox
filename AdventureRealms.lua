-- Farewell Infortality.
-- Version: 2.82
-- Instances:
local uwuowostoplookingatmyguicunt = Instance.new("ScreenGui")
local uwuowo = Instance.new("Frame")
local owolisty = Instance.new("Frame")
local UIListLayout = Instance.new("UIListLayout")
local TextButton = Instance.new("TextButton")
local TextButton_2 = Instance.new("TextButton")
local AutoFarming = Instance.new("Frame")
local UIGridLayout = Instance.new("UIGridLayout")
local TextButton_3 = Instance.new("TextButton")
local TextLabel = Instance.new("TextLabel")
local TextButton_4 = Instance.new("TextButton")
local Misc = Instance.new("Frame")
local UIGridLayout_2 = Instance.new("UIGridLayout")
local TextButton_5 = Instance.new("TextButton")
--Properties:
uwuowostoplookingatmyguicunt.Name = "uwu owo stop looking at my gui cunt"
uwuowostoplookingatmyguicunt.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
uwuowostoplookingatmyguicunt.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

uwuowo.Name = "uwu owo "
uwuowo.Parent = uwuowostoplookingatmyguicunt
uwuowo.Active = true
uwuowo.BackgroundColor3 = Color3.new(0.180392, 0.180392, 0.180392)
uwuowo.BorderColor3 = Color3.new(1, 1, 1)
uwuowo.BorderSizePixel = 3
uwuowo.Position = UDim2.new(0.122763723, 0, 0.228337243, 0)
uwuowo.Size = UDim2.new(0.297964215, 0, 0.443793923, 0)

owolisty.Name = "owo listy"
owolisty.Parent = uwuowo
owolisty.BackgroundColor3 = Color3.new(0.337255, 0.337255, 0.337255)
owolisty.BorderColor3 = Color3.new(1, 1, 1)
owolisty.BorderSizePixel = 3
owolisty.Size = UDim2.new(0.207039341, 0, 1, 0)

UIListLayout.Parent = owolisty
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 5)

TextButton.Parent = owolisty
TextButton.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextButton.BorderSizePixel = 0
TextButton.Size = UDim2.new(1, 0, 0.0949868038, 0)
TextButton.Font = Enum.Font.SourceSans
TextButton.Text = "Auto-Farming"
TextButton.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextButton.TextScaled = true
TextButton.TextSize = 14
TextButton.TextWrapped = true

TextButton_2.Parent = owolisty
TextButton_2.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextButton_2.BorderSizePixel = 0
TextButton_2.Size = UDim2.new(1, 0, 0.0949868038, 0)
TextButton_2.Font = Enum.Font.SourceSans
TextButton_2.Text = "Misc"
TextButton_2.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextButton_2.TextScaled = true
TextButton_2.TextSize = 14
TextButton_2.TextWrapped = true

AutoFarming.Name = "Auto-Farming"
AutoFarming.Parent = uwuowo
AutoFarming.BackgroundColor3 = Color3.new(1, 1, 1)
AutoFarming.BackgroundTransparency = 1
AutoFarming.Position = UDim2.new(0.223602489, 0, 0.0158311352, 0)
AutoFarming.Size = UDim2.new(0.755693555, 0, 0.955145121, 0)
AutoFarming.Visible = false

UIGridLayout.Parent = AutoFarming
UIGridLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout.CellSize = UDim2.new(0.300000012, 0, 0.0949999988, 0)

TextButton_3.Parent = AutoFarming
TextButton_3.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextButton_3.BorderSizePixel = 0
TextButton_3.Size = UDim2.new(0, 200, 0, 50)
TextButton_3.Font = Enum.Font.SourceSans
TextButton_3.Text = "Enable Auto-Farm"
TextButton_3.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextButton_3.TextScaled = true
TextButton_3.TextSize = 14
TextButton_3.TextWrapped = true

TextLabel.Parent = AutoFarming
TextLabel.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextLabel.Size = UDim2.new(0, 200, 0, 50)
TextLabel.Font = Enum.Font.SourceSans
TextLabel.Text = "WEAPON"
TextLabel.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextLabel.TextScaled = true
TextLabel.TextSize = 14
TextLabel.TextWrapped = true

TextButton_4.Parent = AutoFarming
TextButton_4.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextButton_4.BorderSizePixel = 0
TextButton_4.Size = UDim2.new(0, 200, 0, 50)
TextButton_4.Font = Enum.Font.SourceSans
TextButton_4.Text = "Enable Auto-Sell"
TextButton_4.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextButton_4.TextScaled = true
TextButton_4.TextSize = 14
TextButton_4.TextWrapped = true

Misc.Name = "Misc"
Misc.Parent = uwuowo
Misc.BackgroundColor3 = Color3.new(1, 1, 1)
Misc.BackgroundTransparency = 1
Misc.Position = UDim2.new(0.223602489, 0, 0.0158311352, 0)
Misc.Size = UDim2.new(0.755693555, 0, 0.955145121, 0)

UIGridLayout_2.Parent = Misc
UIGridLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
UIGridLayout_2.CellSize = UDim2.new(0.300000012, 0, 0.0949999988, 0)

TextButton_5.Parent = Misc
TextButton_5.BackgroundColor3 = Color3.new(0.219608, 0.219608, 0.219608)
TextButton_5.BorderSizePixel = 0
TextButton_5.Size = UDim2.new(0, 200, 0, 50)
TextButton_5.Font = Enum.Font.SourceSans
TextButton_5.Text = "Teleport To Any Area"
TextButton_5.TextColor3 = Color3.new(0.784314, 0.784314, 0.784314)
TextButton_5.TextScaled = true
TextButton_5.TextSize = 14
TextButton_5.TextWrapped = true
-- Scripts:
function SCRIPT_GWYB85_FAKESCRIPT() -- TextButton.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton
	script.Parent.MouseButton1Click:Connect(function()
		for i , v in pairs(script.Parent.Parent.Parent:GetChildren()) do
			pcall(function()
				if v.Name ~= 'owo listy' and v.Name ~= script.Parent.Text then
					v.Visible = false;
				elseif v.Name == script.Parent.Text then
					v.Visible = true;
				end
			end);
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_GWYB85_FAKESCRIPT))
function SCRIPT_HQVA82_FAKESCRIPT() -- TextButton_2.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_2
	script.Parent.MouseButton1Click:Connect(function()
		for i , v in pairs(script.Parent.Parent.Parent:GetChildren()) do
			if v.Name ~= 'owo listy' and v.Name ~= script.Parent.Text then
				v.Visible = false;
			elseif v.Name == script.Parent.Text then
				v.Visible = true;
			end
		end
	end)

end
coroutine.resume(coroutine.create(SCRIPT_HQVA82_FAKESCRIPT))
function SCRIPT_THTO70_FAKESCRIPT() -- TextButton_3.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_3
	getgenv().on = false;
	script.Parent.MouseButton1Click:Connect(function()
		getgenv().on = not getgenv().on
		if getgenv().on == true then
			script.Parent.Text = 'Disable Auto-Farm';
		else
			script.Parent.Text = 'Enable Auto-Farm';
		end
		if #game.Players.LocalPlayer.Backpack:GetChildren() > 0 then
			game.Players.LocalPlayer.Backpack:GetChildren()[1].Parent = game.Players.LocalPlayer.Character;
		end;
		spawn(function()
			while getgenv().on == true do
				game:GetService("RunService").Heartbeat:wait();
				game.Players.LocalPlayer.Character.Humanoid:ChangeState(11);
			end;
			game.Players.LocalPlayer.Character.HumanoidRootPart.Anchored = false;
			game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = Vector3.new(0,100,0)
		end);
		spawn(function()
			while getgenv().on == true do
				wait();
				for i , v in pairs(game:GetService("Workspace").CharacterDump:GetChildren()) do
					if v:FindFirstChild("ServerRootPart") and getgenv().on == true and (v.HumanoidRootPart.Position-game.Players.LocalPlayer.Character.HumanoidRootPart.Position).magnitude < 20 then
						pcall(function()
							game:GetService("ReplicatedStorage").Remotes.PetAttack:FireServer()
							game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").ServerDriver.RemoteEvent:FireServer(v.ServerRootPart.Value)
							game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").ServerDriver.RemoteEvent:FireServer()

						end);
					end;
				end;
			end;
		end);


		while getgenv().on == true do
			wait();
			for i , v in pairs(game:GetService("Workspace").CharacterDump:GetChildren()) do
				if v:FindFirstChild("ServerRootPart") and getgenv().on == true and v ~= nil then
					t = v.ServerRootPart.Value;
						
					repeat
						if t then
							game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = (t.CFrame - Vector3.new(0,12,0))*CFrame.Angles(math.rad(-180),0,0);
						end;
						wait();
					until v.Parent == nil or t == nil or t:FindFirstChild("Health") == nil or t.Health.Value <= 0 or getgenv().on == false
					game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(100,100,100)
				end;
			end;
		end;
	end)

end
coroutine.resume(coroutine.create(SCRIPT_THTO70_FAKESCRIPT))
function SCRIPT_UQOE88_FAKESCRIPT() -- TextLabel.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextLabel
	while wait() do
		if #game.Players.LocalPlayer.Backpack:GetChildren() > 0 then
			script.Parent.Text = game.Players.LocalPlayer.Backpack:GetChildren()[1].Name;
		else
			script.Parent.Text = game.Players.LocalPlayer.Character:FindFirstChildOfClass("Tool").Name;
		end
	end

end
coroutine.resume(coroutine.create(SCRIPT_UQOE88_FAKESCRIPT))
function SCRIPT_PMLX77_FAKESCRIPT() -- TextButton_4.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_4
	getgenv().sell = false;
	script.Parent.MouseButton1Click:Connect(function()
		getgenv().sell = not getgenv().sell
		if getgenv().sell == true then
			script.Parent.Text = 'Disable Auto-Sell';
		else
			script.Parent.Text = 'Enable Auto-Sell';
		end
		spawn(function()
			while getgenv().sell == true do
				wait(.1)
				firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Shops["Zone_Sell"],0)
				firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,game:GetService("Workspace").Shops["Zone_Sell"],1)
			end
		end)
	end)

end
coroutine.resume(coroutine.create(SCRIPT_PMLX77_FAKESCRIPT))
function SCRIPT_HOBI73_FAKESCRIPT() -- TextButton_5.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = TextButton_5
	script.Parent.MouseButton1Click:Connect(function()
		local mt = getrawmetatable(game);
		local ind = mt.__index;
		local nmc = mt.__namecall;
		setreadonly(mt,false)
		for i , v in pairs(game.Players.LocalPlayer.PlayerGui.CoreUI.WizardWarpFrame.Worlds.Grid:GetDescendants()) do
			if v.Name == 'LockedIcon' then
				v.Visible = false;
			elseif tostring(tonumber(v.Name)) == v.Name then
				v.Visible = true;
			end;
		end;
		mt.__namecall = newcclosure(function(a,...)
			if getnamecallmethod() == "FireServer" and a == r   then
				local args = {...}
				game:GetService("TeleportService"):Teleport(args[1])
				return nmc(a,...);
			end;
			return nmc(a,...);
		end);
	end)

end
coroutine.resume(coroutine.create(SCRIPT_HOBI73_FAKESCRIPT))
function SCRIPT_QNDH90_FAKESCRIPT() -- uwuowo.LocalScript 
	local script = Instance.new('LocalScript')
	script.Parent = uwuowo
	script.Parent.Draggable = true;

end
coroutine.resume(coroutine.create(SCRIPT_QNDH90_FAKESCRIPT))
