-- venyx ui lib stemmed from the original example (ty)
-- Coded badly, this will be updated slowly as I feel features should be added


-- init
local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()
local venyx = library.new("Venyx", 5013109572)

-- themes
local themes = {
Background = Color3.fromRGB(24, 24, 24),
Glow = Color3.fromRGB(0, 0, 0),
Accent = Color3.fromRGB(10, 10, 10),
LightContrast = Color3.fromRGB(20, 20, 20),
DarkContrast = Color3.fromRGB(14, 14, 14),  
TextColor = Color3.fromRGB(255, 255, 255)
}

local events
for _,v in next, game.ReplicatedStorage:GetChildren() do 
    if string.find(v.Name,'events') and v.ClassName == 'Folder' then 
        events = v
        for _,v in next, v:GetChildren() do 
            v.Name = _ 
        end
    end 
end

function speedCameras()
    for _,v in next, game:GetService("Workspace").SpeedCameras:GetDescendants() do 
        if v.Name == 'TouchInterest' then 
            v.Parent:Destroy()
        end 
    end
end

function trafficLights()
    for _,v in next, game:GetService("Workspace").Roads["Traffic Lights"]:GetDescendants() do 
        if v.Name == 'Detection' then 
            v:Destroy()
        end 
    end
end

local staminaTable = nil 
for _,v in next, getgc(true) do 
    if type(v) == 'table' and rawget(v, "stamina") then 
        staminaTable = v 
    end
end
game.Players.LocalPlayer.CharacterAdded:Connect(function()
    wait(2)
    for _,v in next, getgc(true) do 
        if type(v) == 'table' and rawget(v, "stamina") then 
            staminaTable = v 
        end
    end
end)

local old 
old = hookmetamethod(game, "__namecall", newcclosure(function(self,...) -- block crashes/bans
    if getnamecallmethod() == 'FireServer' and tostring(self) == "28" and getgenv().settings.blockCrashes  then 
        warn("crash blocked")
        return false 
    elseif getnamecallmethod() == "FireServer" and tostring(self) == "11" then
        warn("Ban blocked")
        return false
    end 
    return old (self,...)
end))



getgenv().settings = {}



local localPage = venyx:addPage("Local", 5012544693)

local section = localPage:addSection("Traps")

section:addButton("Delete Speed Cameras", function(value)
    speedCameras()
    venyx:Notify("Speed Cameras", "Speed Cameras deleted. You will no longer get those hefty fines.")
end)

section:addButton("Block traffic light fines", function(value)
    trafficLights()
    venyx:Notify("Traffic Lights", "You will no longer get fined for running a red light.")
end)





section = localPage:addSection("Character")



section:addToggle("Infinite Stamina", nil, function(value)
    getgenv().settings.stamina = value 
    task.spawn(function()
        while getgenv().settings.stamina and task.wait() do 
            staminaTable.stamina = 1 
        end 
    end)
    if value then
        venyx:Notify("Stamina", "Your stamina will no longer deplete.")
    else 
        venyx:Notify("Stamina", "Your stamina will now deplete.")
    end
end)



section:addButton("Suicide", function(value)
    game.Players.LocalPlayer.Character:BreakJoints()
    venyx:Notify("Suicide", "You're now dead.")
end)

local criminalPage = venyx:addPage("Criminal", 5012544693)
section = criminalPage:addSection("Criminal")

function rob()
    local char = game.Players.LocalPlayer.Character 
    if not char or not char.PrimaryPart then return end 
    local prim = char.PrimaryPart
    for _,v in next, game:GetService("Workspace").Robberies.BankRobbery.Gold:GetChildren() do 
        if (v.Position-prim.Position).magnitude < 40 and v.Transparency ~= 1 then
            events['22']:FireServer(v, "Rvy")
            events['22']:FireServer(v, "MQw")
        end
    end
    for _,v in next, game:GetService("Workspace").Robberies.BankRobbery.Money:GetChildren() do 
        if (v.Position-prim.Position).magnitude < 40 and v.Transparency ~= 1 then
            events['22']:FireServer(v, "Mqw")
        end
    end
    for _,v in next, game:GetService("Workspace").Robberies.JewelerRobbery.Robbables:GetChildren() do 
        if v.Glass.Transparency == 1 then
            for _,v in next, v.Collectables:GetChildren() do 
                if (v.Position-prim.Position).magnitude < 40 and v.Transparency ~= 1 then
                    events['22']:FireServer(v, "Rvy")
                end
            end
        end
    end
    
    for _,v in next, game:GetService("Workspace").Drops:GetChildren() do 
        if (v.Position-prim.Position).magnitude < 40 and v.Transparency ~= 1 then
            events['22']:FireServer(v, "Mqw")
        end
    end
end

section:addToggle("Automatically steal items", nil, function(value)
    getgenv().settings.autosteal = value 
    task.spawn(function()
        while getgenv().settings.autosteal and wait(.5) do 
            warn("rob")
            rob()
        end 
    end) 
    if value then
        venyx:Notify("Auto Steal", "You will now automatically steal gold and jewelry and diamonds.")
    else 
        venyx:Notify("Auto Steal", "You will no longer automatically steal gold and jewelry and diamonds.")
    end
end) 

section:addButton("Sell Jewelry/Gold/Diamonds", function(value)
    for i = 0 , 200 , 1 do 
        events["36"]:FireServer("Gold", "Dealer")
    
        events["36"]:FireServer("Jewelry", "Dealer")
        
        events["36"]:FireServer("Diamond", "Smuggler")
    end
    venyx:Notify("Sell", "Items sold")
end) 



local carPage = venyx:addPage("Car", 5012544693)

section = carPage:addSection("Car")

section:addToggle("Anti Car Crash", nil, function(value)
    getgenv().settings.blockCrashes = value 
    if value then
        venyx:Notify("Anti Car Crash", "Your car will no longer be damanged from crashing it.")
    else 
        venyx:Notify("Anti Car Crash", "Your car will now be damanged from crashing it.")
    end
end)

section:addSlider("Max Speed", 400, 0, 1000, function(value)
    getgenv().settings.maxSpeed = value 
end)
section:addSlider("Reverse Max Speed", 400, 0, 1000, function(value)
    getgenv().settings.reverseMaxSpeed = value 
end)
section:addSlider("Max Brake Force", 10000, 0, 100000, function(value)
    getgenv().settings.maxBrakeForce = value 
end)
section:addSlider("Max Acceleration Force", 10000, 0, 100000, function(value)
    getgenv().settings.maxAccelerationForce = value 
end)
section:addSlider("Parking Brake Force", 1000000, 0, 1000000, function(value)
    getgenv().settings.parkingBrakeForce = value 
end)
section:addSlider("Min Brake Force", 1000, 0, 100000, function(value)
    getgenv().settings.minBrakeForce = value 
end)
section:addSlider("Min Acceleration Force", 1000, 0, 100000, function(value)
    getgenv().settings.minAccelerationForce = value 
end)
section:addButton("Mod Car", function()
    for _,v in next, getgc(true) do 
        if type(v) == 'table' and rawget(v, 'MaxSpeed') and type(v.MaxBrakeForce) ~= 'function' then 
            
            v.MaxSpeed = getgenv().settings.maxSpeed or 400
            v.ReverseMaxSpeed = getgenv().settings.reverseMaxSpeed or 400 
            v.MaxBreakForce = getgenv().settings.maxBrakeForce or 10000
            v.MaxAccelerationForce = getgenv().settings.maxAccelerationForce or 10000
            v.ParkingBrakeForce = getgenv().settings.parkingBrakeForce or 1000000
            v.MinAccelerateForce = getgenv().settings.minBrakeForce or 1000
            v.MinBrakeForce = getgenv().settings.minAccelerationForce or 1000  
        end 
    end    
end) 
section:addButton("Fix Car", function()
    events["27"]:FireServer()
end) 
section:addButton("Fuel Car", function()
    local car = workspace.Vehicles[game.Players.LocalPlayer.Name].Body.Mass
    local cf = car.CFrame
    for i = 0 , 12 , 1 do 
        car.CFrame = workspace.Interactables["Fuel Stations"].Ares.CFrame
        events["22"]:FireServer(workspace.Interactables["Fuel Stations"].Ares, "LQp")
        task.wait()
    end
    for i = 0 , 12 , 1 do 
        car.CFrame = cf
        task.wait()
    end
end) 

section:addDropdown("Change Car Colour", {"Black", "Blue", "Green", "Orange", "Purple", "Red", "White", "Yellow"}, function(colour)
    events["33"]:FireServer(colour)
end)

local moneyPage = venyx:addPage("Money", 5012544693)

section = moneyPage:addSection("Farms")

section:addToggle("Medic Money/XP Farm", nil, function(value)
    warn(value)
    getgenv().farmMedic = value
    events['37']:FireServer()
    events['25']:FireServer(4)
    if value then 
        venyx:Notify("Money Farm", "Stand next to people and you will earn xp, when you want to claim the money just toggle this off.")
        while getgenv().farmMedic and task.wait() do 
            for _,v in next, game.Players:GetPlayers() do 
                if v ~= game.Players.LocalPlayer and v.Character and v.Character.PrimaryPart and (v.Character.PrimaryPart.Position-game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < 15 then
                    repeat 
                        wait()
                        for i = 0 , 1 ,1 do 
                            events["3"]:FireServer("Bandage", "Fire Department Locker")
                            events["21"]:FireServer("Bandage")
                            if (v ~= game.Players.LocalPlayer and v.Character and v.Character.PrimaryPart and (v.Character.PrimaryPart.Position-game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < 15 and getgenv().farmMedic) then
                                events["22"]:FireServer(v.Character.PrimaryPart, "Z4v")
                            else 
                                break 
                            end
                        end
                    until not (v ~= game.Players.LocalPlayer and v.Character and v.Character.PrimaryPart and (v.Character.PrimaryPart.Position-game.Players.LocalPlayer.Character.PrimaryPart.Position).Magnitude < 15 and getgenv().farmMedic)
                end 
            end
        end
    else     
        venyx:Notify("Money Farm", "Money claimed, it may take a minute for the game to update.")
    end
end)

section:addButton("End Shift", function()
    events['37']:FireServer()
end)

local settings = venyx:addPage("Settings", 5012544693)
local settingSection = settings:addSection("Settings")

settingSection:addKeybind("Toggle Keybind", Enum.KeyCode.RightControl, function()
venyx:toggle()
end, function()
end)



local colors = settings:addSection("Colors")

for theme, color in pairs(themes) do -- all in one theme changer, i know, im cool
colors:addColorPicker(theme, color, function(color3)
venyx:setTheme(theme, color3)
end)
end

-- load
venyx:SelectPage(venyx.pages[1], true)
