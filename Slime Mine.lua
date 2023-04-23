local scriptVersion = "2023-04-23T20:51:13.3458556Z"
local MarketplaceService = game:GetService("MarketplaceService")
local placeVersion = MarketplaceService:GetProductInfo(game.PlaceId).Updated

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()

local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

local menu = lib.new("Slime Mine", 5013109572)

if placeVersion ~= scriptVersion then 
    menu:toggle()
    getgenv()._continue = nil
    menu:Notify("UPDATE DETECTED", "The game has updated and the script is not guranteed to be safe, are you sure you want to continue?", function(val)
        getgenv()._continue = val 
    end) 
    repeat 
        task.wait()
    until getgenv()._continue ~= nil 
    if getgenv()._continue == false then 
        exit()
    end 
    menu:toggle()
end

for _,v in next, getconnections(game.Players.LocalPlayer.Idled) do 
    v:Disable()
end

local knit = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("knit"));
local invUtil = require(game:GetService("ReplicatedStorage").Util.inventoryUtil)
local infoHandler = knit.GetController("InformationController")
local eggInfo = infoHandler:getInformation("eggInfo")
local zoneInfo = infoHandler:getInformation("zonesInfo")
local dataController = knit.GetController("DataController");

local player = game:GetService("Players").LocalPlayer
local services = game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services

function pickup() 
    for i,v in pairs(game.Workspace.PickupParts:GetChildren()) do
        if v.Name:sub(1,game.Players.LocalPlayer.Name:len()) == game.Players.LocalPlayer.Name  and v:FindFirstChild("Part") then
            services.BlocksService.RF.tryPickUpBlock:InvokeServer(v.Name:split("#")[4])
        end
    end
end

function getAreas() 
    local areas = {}
    for _,v in next, zoneInfo['names'] do 
        if _ <= zoneInfo['maxUnlockableZone'] then 
            table.insert(areas, v)
        end 
    end
    return areas
end

function getEggs()
    local eggs = {}
    for _,v in next, eggInfo['eggNames'] do 
        if _ ~= "StarterOrb" and v ~= "Beta Portal" then
            table.insert(eggs, v)
        end 
    end 

    table.sort(eggs, function(egg1,egg2)
        local number1,number2 
        for eggIndex,eggName in next, eggInfo['eggNames'] do
            if eggName == egg1 then 
                number1 = tonumber(string.split(eggIndex ,"Egg")[2])
            elseif eggName == egg2 then 
                number2 = tonumber(string.split(eggIndex ,"Egg")[2])
            end 
        end 
        return number1 < number2
    end)

    return eggs 
end 

function teleportToArea(area)
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = CFrame.new(Vector3.new(570.1199951171875, 213.043701171875, 1469.739990234375) - Vector3.new(0,0,380) * area)
end

function teleport(cframe)
    player.Character.PrimaryPart.CFrame = cframe
end

function shouldSell()
    if (invUtil:getBackpackCapacity(game.Players.LocalPlayer) - getBackpackAmount() < 5) then 
        return true 
    else 
        return false 
    end
end

function getBackpackAmount()
    local size = 0
    for _,v in next, dataController:GetPlayerData("Inventory.inventory") do 
        size += v.space 
    end 
    return size 
end 

function sell()
    if not shouldSell() or not getgenv().area then return end
    local oldCFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
    if not workspace:WaitForChild("Sell"):FindFirstChild("Zone"..getgenv().area) then 
        teleportToArea(tonumber(getgenv().area))
        wait(2)
        teleport(oldCFrame)
    end
    repeat
        teleport(workspace.Sell:WaitForChild("Zone"..getgenv().area).CFrame)
        wait()
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        wait(.25)
    until not shouldSell()
    if not getgenv().legit then
        teleport(oldCFrame)
    end
    game.Players.LocalPlayer.Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
end

function teleportFarm()
    for _,block in next, game.Workspace.Blocks:GetChildren() do
        if not getgenv().autofarm then break end 
        if v.Name:sub(1,1) == getgenv().area then 
            repeat 
                task.wait()
                teleport(block.CFrame)
                block.CanCollide = false 
            until not block or not block.Parent or block.Parent.Name ~= "Blocks" or not getgenv().autofarm 
        end
    end
end

function closestBlock()
    local closestDistance, block = math.huge, nil
    for _,v in next, workspace.Blocks:GetChildren() do 
        if not getgenv().autofarm then break end 
        if v.Name:sub(1,1) == getgenv().area then 
            local _dist = (game.Players.LocalPlayer.Character.PrimaryPart.Position-v.Position).magnitude 
            if _dist < closestDistance and math.abs(game.Players.LocalPlayer.Character.PrimaryPart.Position.Y-v.Position.Y) < 14 then 
                closestDistance = _dist 
                block = v 
            end 
        end 
    end
    return block
end

function walkFarm()
    local block = closestBlock()
    if block then 
        pickup()
        game.Players.LocalPlayer.Character.Humanoid:MoveTo(block.Position)
    end
    pickup()
end

function getNextZone() 
    local areas = {}
    for _,v in next, game:GetService("Workspace").Doors:GetChildren() do 
        table.insert(areas, tonumber(v.Name))
    end 
    table.sort(areas, function(a,b)
        return a < b 
    end) 

    return areas[1]
end

local localPage = menu:addPage("Local Player", 5012544693)
local localTab = localPage:addSection("Local Player")

localTab:addSlider("Walkspeed", 16, 0, 300, function(value)
    player.Character.Humanoid.WalkSpeed = value
end)

localTab:addButton("Unlock teleports", function()
    for _,v in next, player.PlayerGui.UI.Zones.ScrollingFrame:GetChildren() do 
        if v.ClassName == 'Frame' and v.Name ~= "Lobby" then 
            v.TextButton.Locked.Visible = false 
            v.TextButton.MouseButton1Click:Connect(function()
                teleportToArea(tonumber(v.Name:split("Zone")[2]))
            end) 
        end
    end

    player.PlayerGui.UI.ChildAdded:Connect(function(v)
        local old = v.Visible
        v.Visible = false 
        wait()
        if string.match(v.Description.Text, "teleport") then 
            v:Destroy()
        else 
            v.Visible = old
        end 
    end)
end)

local mainPage = menu:addPage("Main", 5012544693)
local autofarmTab = mainPage:addSection("Autofarm")

autofarmTab:addDropdown("Select area",getAreas(),function(selected) 
    for _,v in next, zoneInfo['names'] do 
        if v == selected then 
            getgenv().area = _
        end 
    end    
end)

autofarmTab:addToggle("Autopickup",false,function(value)
    getgenv().autopickup = value
    if value then 
        task.spawn(function()
            while getgenv().autopickup and wait(.25) do 
                pickup()
            end 
        end) 
    end
end)

autofarmTab:addToggle("Legit Mode",false,function(value) 
    getgenv().legit = value
 end)

autofarmTab:addToggle("Autofarm",false,function(value) 
   getgenv().autofarm = value
   if value then 
        while getgenv().autofarm do 
            if getgenv().area then 
                local _closestBlock = closestBlock()
                if not _closestBlock or (player.Character.PrimaryPart.Position - _closestBlock.Position).magnitude > 150 then 
                    teleportToArea(tonumber(getgenv().area))
                end 
                if not getgenv().legit then 
                    teleportFarm()
                else 
                    walkFarm()
                end 
            end 
            wait(.2)
        end 
    end
end)

autofarmTab:addToggle("Autosell",false,function(value)
    getgenv().autosell = value
    if value then 
        task.spawn(function()
            while getgenv().autosell do 
                wait(.1)
                if shouldSell() then 
                    sell() 
                end 
            end 
        end) 
    end
end)

autofarmTab:addToggle("Auto unlock next area",false,function(value)
    getgenv().autoUnlock = value 
    task.spawn(function()
        while getgenv().autoUnlock and task.wait() do 
            services.PlayerService.RF.requestAction:InvokeServer("unlockZone", getNextZone())
        end 
    end)
end)

local hatchTab = mainPage:addSection("Auto hatch")

hatchTab:addDropdown("Select egg",getEggs(),function(selected) 
    for i,v in next, eggInfo["eggNames"] do 
        if v == selected then 
            getgenv().egg = i 
        end 
    end
end)

hatchTab:addToggle("Triple Hatch",false,function(value) 
   getgenv().hatchamount = value and 3 or 1
end)

hatchTab:addToggle("Auto hatch",false,function(value) 
    getgenv().autohatch = value 
    task.spawn(function()
        while getgenv().autohatch do
            local oldCFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame 
            if not game:GetService("Workspace").EggTriggers:FindFirstChild(getgenv().egg) then 
                for i = 0 , 7 , 1 do 
                    teleportToArea(i)
                    wait(1)
                end 
            end
            teleport(Workspace.EggTriggers:WaitForChild(getgenv().egg).CFrame)
            wait(.05)
            services.PlayerService.RF.requestAction:InvokeServer("hatch", getgenv().egg, getgenv().hatchamount or 1)
            wait(.05)
            teleport(oldCFrame)
            wait(2.22)
        end 
    end)
end)

local themePage = menu:addPage("Settings", 5012544693)
local colors = themePage:addSection("Colors")

for theme, color in pairs(themes) do 
    colors:addColorPicker(theme, color, function(color3)
        menu:setTheme(theme, color3)
    end)
end

local miscSection = themePage:addSection("misc")

miscSection:addKeybind("Toggle Keybind", Enum.KeyCode.RightControl, function()
    print("Activated Keybind")
    menu:toggle()
end, function()
    print("Changed Keybind")
end)


