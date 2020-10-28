repeat
    wait()
until game:IsLoaded() and game.Players.LocalPlayer.Character ~= nil and game.Players.LocalPlayer.Character:FindFirstChild("Head") ~= nil and game.Players.LocalPlayer.Character.Head:FindFirstChild("NameLevelBBGUI") ~= nil
for i , v in pairs(game:GetDescendants()) do
    if v.ClassName == 'TextLabel' and v.Text == game.Players.LocalPlayer.Name then
        v.Text = 'Script made by ProtonDev-Sys#4419'
    end;
end;
    
if not firetouchinterest then
    print("Your exploit is not supported!");
    return;
end;


local function getEnemey()
    local e = game.Workspace.Enemies:GetChildren();
    table.sort(e,function(a,b)
        return a.PathNumber.Value > b.PathNumber.Value
    end);
    game.Workspace.CurrentCamera.CameraSubject = e[1].Humanoid
    
    return(e[1])
end;

if game.Workspace:FindFirstChild("Queue") ~= nil then
    print("Joining game..")
    for i , v in pairs(game:GetService("Workspace").Queue.Elevator:GetChildren()) do
        if v.SurfaceGui.Frame.TextLabel.Text == 'Empty' then
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v,0)
            firetouchinterest(game.Players.LocalPlayer.Character.HumanoidRootPart,v,1)
            wait();
            local ohString1 = "Level"
            local ohString2 = getgenv().settings['LEVEL']
            local ohBoolean3 = true
            
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1, ohString2, ohBoolean3)

            local ohString1 = "Start"
        
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer(ohString1)
        end
    end;
else
    while true do
        wait();
        if game.Players.LocalPlayer.PlayerGui.HUD.NextWaveVote.Visible == true then
            game:GetService("ReplicatedStorage").Remotes.Input:FireServer("VoteWaveConfirm")
        end;
        
        if #game.Workspace.Enemies:GetChildren() > 0 then
            local e = getEnemey()
            for i = -1 , 1 , 2 do
                local pos = e.REALPOSITIONPOS;
                
                local ohTable2 = {
                	["Rotation"] = 0,
                	["cframe"] = pos.CFrame+pos.CFrame.lookVector+Vector3.new(3,0,0)*i,
                	["Unit"] = getgenv().settings['UNIT']
                }
                
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer("Summon", ohTable2)
                local ohTable2 = {
                	["Rotation"] = 0,
                	["cframe"] = pos.CFrame+pos.CFrame.lookVector+Vector3.new(3,0,0)*i,
                	["Unit"] = getgenv().settings['UNIT']
                }
                
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer("Summon", ohTable2)            
                local ohTable2 = {
                	["Rotation"] = 0,
                	["cframe"] = pos.CFrame+pos.CFrame.lookVector+Vector3.new(3,0,0)*i,
                	["Unit"] = getgenv().settings['UNIT']
                }
                
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer("Summon", ohTable2)            
                local ohTable2 = {
                	["Rotation"] = 0,
                	["cframe"] = pos.CFrame+pos.CFrame.lookVector+Vector3.new(3,0,0)*i,
                	["Unit"] = getgenv().settings['UNIT']
                }
                
                game:GetService("ReplicatedStorage").Remotes.Input:FireServer("Summon", ohTable2)            
                
            end;
            spawn(function()
                for i , v in pairs(game.Workspace.Unit:GetChildren()) do
                    if v.Owner.Value == game.Players.LocalPlayer and v.UpgradeTag.Value < getgenv().settings['UPGLEVEL'] then
                        game:GetService("ReplicatedStorage").Remotes.Input:FireServer("Upgrade", v)
                        wait();
                    end;
                end;
            end);
        end;
        wait();
    end;
end;
