local scriptVersion = "2023-04-25T04:57:53.2998803Z"
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



local knit = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("knit"))
local invUtil = require(game:GetService("ReplicatedStorage").Util.inventoryUtil)
local infoHandler = knit.GetController("InformationController")
local eggInfo = infoHandler:getInformation("eggInfo")
local zoneInfo = infoHandler:getInformation("zonesInfo")
local oreInfo = infoHandler:getInformation("blocksInfo")
local dataController = knit.GetController("DataController")
local uiController = knit.GetController("UIController")
wait(2)
local petHandlerTable
for _,v in next, getgc(true) do 
    if type(v) == 'table' and rawget(v, 'attackInfo') and rawget(v, 'maid') and rawget(v, 'petHandlers') then 
        if v.player == game.Players.LocalPlayer then 
            petHandlerTable = v
        end
    end 
end

getgenv().defaultAutoMining = uiController.autoMining

local player = game:GetService("Players").LocalPlayer
local services = game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services

for _,v in next, getconnections(player.Idled) do 
    v:Disable()
end

function pickup() 
    for i,v in pairs(game.Workspace.PickupParts:GetChildren()) do
        if v.Name:sub(1,player.Name:len()) == player.Name  and v:FindFirstChild("Part") then
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
    player.Character.PrimaryPart.CFrame = CFrame.new(Vector3.new(570.1199951171875, 213.043701171875, 1469.739990234375) - Vector3.new(0,0,380) * area)
end

function teleport(cframe)
    player.Character.PrimaryPart.CFrame = cframe
end

function shouldSell()
    if (invUtil:getBackpackCapacity(player) - getBackpackAmount() < 5) then 
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
    local oldCFrame = player.Character.PrimaryPart.CFrame
    if not workspace:WaitForChild("Sell"):FindFirstChild("Zone"..getgenv().area) then 
        teleportToArea(tonumber(getgenv().area))
        wait(2)
        teleport(oldCFrame)
    end
    
    repeat
        teleport(workspace.Sell:WaitForChild("Zone"..getgenv().area).CFrame)
        wait()
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        wait(.1)
    until not shouldSell()
    if not getgenv().legit then
        teleport(oldCFrame)
    end
    player.Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
end

function attack(block)
    if not block then return end
    local arr = {}
    for i,v in next, petHandlerTable.equipped do 
        arr[tostring(v)] = {
            ["targeted"] = true,
            ["position"] = tonumber(i), 
            ["blockName"] = tostring(block)
        }
    end 
    
    for _,v in next, petHandlerTable.equipped do    
        task.spawn(function()
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("setAttackInfo", arr) 
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.BlocksService.RF.attackBlock:InvokeServer(tostring(block), tostring(v))
        end)
    end
end

function teleportFarm()
    repeat 
        task.wait()
        local block = closestBlock()
        if block and not shouldSell() then 
            teleport(block.CFrame)
            block.CanCollide = false 
            attack(block)
            wait()
        end
    until not block or not block.Parent or block.Parent.Name ~= "Blocks" or not getgenv().autofarm 
end
wait(1)
warn("loading function")
function closestBlock()
    local closestDistance, block = math.huge, nil
    local ores = {}
    local playerPos = player.Character.PrimaryPart.Position 
    for _,v in next, workspace.Blocks:GetChildren() do 
        if not getgenv().autofarm then break end 
        if v.Name:sub(1,1) == tostring(getgenv().area) then 
            local _dist = (playerPos-v.Position).magnitude
            local children = v:GetChildren()
            if #children > 8 then 
                local orename 
                for _2,v2 in next, children do 
                    local oreData = oreInfo['blocks'][tostring(v2)]
                    if oreData then 
                        orename = tostring(v2)
                        table.insert(ores, {
                            ['block'] = v,
                            ['rarity'] = oreInfo['raritiesScore'][oreData['rarity']] 
                        })
                        break 
                    end 
                end 
            elseif _dist < closestDistance then 
                closestDistance = _dist 
                block = v 
            end 
        end
    end
    table.sort(ores, function(a,b)
        return a['rarity'] > b['rarity']
    end)
    if #ores > 0 and not getgenv().legit then
        return ores[1]['block']
    end
    return block
end
wait(1)
warn("loaded")
wait(1)
function walkFarm()
    local block = closestBlock()
    if block then 
        pickup()
        player.Character.Humanoid:MoveTo(block.Position)
        attack(block)
        wait()
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

localTab:addButton("Open Slime Awakening Menu", function()
    local oldCFrame = player.Character.PrimaryPart.CFrame 
    if not workspace:FindFirstChild("Map"):FindFirstChild("Zone1"):FindFirstChild("PetMerge"):FindFirstChild("PetMerge"):FindFirstChild("Circle Activated") then
        repeat task.wait()
            teleportToArea(1)
        until workspace:FindFirstChild("Map"):FindFirstChild("Zone1"):FindFirstChild("PetMerge"):FindFirstChild("PetMerge"):FindFirstChild("Circle Activated")
    end
    teleport(workspace.Map.Zone1.PetMerge:GetChildren()[1]['Circle Activated'].CFrame)
    wait()
    teleport(oldCFrame)
end)

localTab:addButton("Open Ascension Menu", function()
    local oldCFrame = player.Character.PrimaryPart.CFrame 
    if #workspace.Ascension:GetChildren() < 1 then 
        repeat task.wait()
            teleportToArea(2)
        until #workspace.Ascension:GetChildren() >= 1
    end
    teleport(workspace.Ascension:GetChildren()[1]['Circle Activated'].CFrame)
    wait()
    teleport(oldCFrame)
end)

localTab:addButton("Open Player Upgrades Menu", function()
    local oldCFrame = player.Character.PrimaryPart.CFrame 
    if not workspace:FindFirstChild("Map"):FindFirstChild("Zone4"):FindFirstChild("Upgrade"):FindFirstChild("Main") then
        repeat task.wait()
            teleportToArea(4)
        until workspace:FindFirstChild("Map"):FindFirstChild("Zone4"):FindFirstChild("Upgrade"):FindFirstChild("Main")
    end
    teleport(workspace.Map.Zone4.Upgrade.Main.CFrame)
    wait()
    teleport(oldCFrame)
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
        uiController.autoMining = false
        while getgenv().autofarm do 
            if getgenv().area then 
                local _closestBlock = closestBlock()
                if not _closestBlock or (player.Character.PrimaryPart.Position - _closestBlock.Position).magnitude > 250 then 
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
        uiController.autoMining = getgenv().defaultAutoMining
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
            local oldCFrame = player.Character.PrimaryPart.CFrame 
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


