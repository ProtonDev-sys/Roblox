loadstring(game:HttpGet("https://raw.githubusercontent.com/ProtonDev-sys/Roblox/main/linkvertise.lua"))()

local Neverlose_UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Mana42138/Neverlose-UI/main/Source.lua"))()
function Neverlose_UI:AutoJoinDiscord(code) -- wtf i don't wanna autojoin your discord
    return
end
local Win = Neverlose_UI:Window({
    Title = "Rush Point",
    CFG = "RUSHPOINTPROTON",
    Key = Enum.KeyCode.H,
    External = {
        KeySystem = false,
    }
})

local miscSection = Win:TSection("Misc")
local localTab = miscSection:Tab("Local")
local coloursSection = localTab:Section("Colours")

for _,v in next, getconnections(workspace.Camera.ChildAdded) do 
    v:Disable()
end 
for _,v in next, getconnections(workspace.Camera.ChildRemoved) do 
    v:Disable()
end 



workspace.Camera.ChildAdded:Connect(function(v)
    if v.Name == "Weapon" and getgenv().jadsioji9u2.misc.rainbowGun and not getgenv().isgay then 
        wait()
        getgenv().isgay = true
        for _,v in workspace.Camera.Weapon:GetDescendants() do 
            if v.Name == "SurfaceAppearance" or v.Name == "CharacterClothing" then 
                v:Destroy()
            end
            if v:IsA("BasePart") then 
                v.Material = "Neon"
                task.spawn(function()
                    while getgenv().jadsioji9u2.misc.rainbowGun and task.wait() do 
                        for i = 0 , 1, 0.001 do
                            v.Color = Color3.fromHSV(i,1,1)
                            task.wait()
                            if not getgenv().jadsioji9u2.misc.rainbowGun then 
                                break 
                            end
                        end
                    end
                end)
            end 
        end
    end
end)

workspace.Camera.ChildRemoved:Connect(function(v)
    if v.Name == "Weapon" then 
        getgenv().isgay = false 
    end 
end)

local blatentSection = Win:TSection("Rage")
local killTab = blatentSection:Tab("Auto Kill")
local autoSection = killTab:Section("Auto Kill")



local bones = {"Head", "HumanoidRootPart"}
getgenv().jadsioji9u2 = {
    ["autokill"] = {},
    ["misc"] = {}
}

getgenv().jadsioji9u2.autokill.bone = "Head"
local selectBone = autoSection:Dropdown("Select Attack Bone", bones, function(bone)
    getgenv().jadsioji9u2.autokill.bone = bone
end):Set("Head")

local localplayer = game.Players.LocalPlayer


local function GetModule(Fake)
    local __index = getrawmetatable(Fake).__index
    return getupvalue(__index, 1)
end

local Modules = game:GetService("ReplicatedStorage"):WaitForChild("Modules")
local Client = Modules:WaitForChild("Client")
local Shared = Modules:WaitForChild("Shared")

local Network = require(Shared.Network)
Network = GetModule(Network)

local Memory = require(Shared.SharedMemory)

function reload()
	game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer("AnimationUpdate", "Reload")
	game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer("ReloadStart")
	wait(3)
	game:GetService("ReplicatedStorage").Modules.Remotes.RemoteFunction:InvokeServer("ReloadEnd")
end 

local teamcheck_toggle = autoSection:Toggle("Team Check", function(state)
    getgenv().jadsioji9u2.autokill.teamcheck = state
end):Set(true)
-- Create a UI toggle for the autokill functionality (Replace this with the actual UI creation function from lib.lua)
local autokill_toggle = autoSection:Toggle("AutoKill", function(state)
    getgenv().jadsioji9u2.autokill.enabled = state
    
    task.spawn(function()
        while getgenv().jadsioji9u2.autokill.enabled and wait() do 
            reload()
        end 
    end)
    

    while getgenv().jadsioji9u2.autokill.enabled and wait() do 
        for _,v in next, game:GetService("Workspace").MapFolder.Players:GetChildren() do 
            local bone = getgenv().jadsioji9u2.autokill.bone
            if v.Name ~= localplayer.Name and v:FindFirstChild(bone) and v:FindFirstChild("Humanoid").Health > 0 then
                if not getgenv().jadsioji9u2.autokill.teamCheck or game:GetService("Players"):FindFirstChild(v.Name) and getgenv().jadsioji9u2.autokill.teamCheck and game:GetService("Players"):FindFirstChild(v.Name).PermanentTeam.Value ~= localplayer.PermanentTeam.Value or not game:GetService("Players"):FindFirstChild(v.Name) then 
                    
                    local ohString1 = "AnimationUpdate"
                    local ohString2 = "Shoot"

                    game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer(ohString1, ohString2)
                    wait()
                    local uid = game:GetService("HttpService"):GenerateGUID()
                    local Weapon = Memory.CurrentWeapon
                    local Muzzle = Weapon.Object.Muzzle
                    local MuzzlePos = Muzzle.Position


                    local ohString1 = "FireBullet"
                    local ohTable2 = {
                        [1] = {
                            ["BulletType"] = "PistolBullet",
                            ["RotationMatrix"] = CFrame.new(0, 0, 0, 0.0242617372, -0.00589860789, -0.999688208, 4.09272616e-12, 0.999982715, -0.00590034435, 0.999705732, 0.000143152589, 0.0242613163),
                            ["CreatedTick"] = tick(),
                            ["Ignore"] = {
                                [1] = localplayer.Character,
                                [2] = localplayer.Character.Collision,
                                [3] = localplayer.Character.HumanoidRootPart
                            },
                            ["OriginCFrame"] = CFrame.new(workspace.CurrentCamera.CFrame.Position, v[bone].Position),
                            ["Owner"] = game:GetService("Players").LocalPlayer,
                            ["BulletCFrame"] = CFrame.new(MuzzlePos, v[bone].Position),
                            ["BulletID"] = uid,
                            ["Weapon"] = localplayer.Character.Weapon.WeaponName.Value
                        }
                    }
                    local ohCFrame3 = localplayer.Character[bone].CFrame

                    game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer(ohString1, ohTable2, ohCFrame3)
                    if not v:FindFirstChild("Head") then break end
                    game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer(
                        "DamagePlayer", 
                        uid, 
                        v, 
                        v.Head.CFrame:ToObjectSpace(localplayer.Character.Head.CFrame), 
                        string.pack("fff", 
                            localplayer.Character.HumanoidRootPart.Position.X, 
                            localplayer.Character.HumanoidRootPart.Position.Y, 
                            localplayer.Character.HumanoidRootPart.Position.Z), 
                        string.pack("fff", 
                            v[bone].Position.X, 
                            v[bone].Position.Y, 
                            v[bone].Position.Z), 
                        false, 
                        true
                    )

                    local ohString1 = "DamagePlayer"
                    local ohString2 = uid
                    local ohInstance3 = v.Head
                    local ohCFrame4 = v[bone].CFrame:ToObjectSpace(localplayer.Character.Head.CFrame)
                    local ohString5 = string.pack("fff", localplayer.Character.HumanoidRootPart.Position.X, localplayer.Character.HumanoidRootPart.Position.Y, localplayer.Character.HumanoidRootPart.Position.Z)
                    local ohString6 = string.pack("fff", v[bone].Position.X, v[bone].Position.Y, v[bone].Position.Z)

                    game:GetService("ReplicatedStorage").Modules.Remotes.RemoteEvent:FireServer(ohString1, ohString2, ohInstance3, ohCFrame4, ohString5, ohString6)
                    wait()
                    if not getgenv().jadsioji9u2.autokill.enabled then 
                        break 
                    end
                end
            end
        end	
    end
end)


getgenv().isgay = false
local gun_and_hand_chams = coloursSection:Toggle("Rainbow gun", function(state)
    warn(state)
    getgenv().jadsioji9u2.misc.rainbowGun = state
    if not getgenv().isgay and getgenv().jadsioji9u2.misc.rainbowGun then
        print("gay?")
        getgenv().isgay = true
        for _,v in workspace.Camera.Weapon:GetDescendants() do 
            if v.Name == "SurfaceAppearance" or v.Name == "CharacterClothing" then 
                v:Destroy()
            end
            if v:IsA("BasePart") then 
                v.Material = "Neon"
                task.spawn(function()
                    while getgenv().jadsioji9u2.misc.rainbowGun and task.wait() do 
                        for i = 0 , 1, 0.001 do
                            v.Color = Color3.fromHSV(i,1,1)
                            task.wait()
                            if not getgenv().jadsioji9u2.misc.rainbowGun then 
                                break 
                            end
                        end
                    end
                end)
            end 
        end
    end
end)
