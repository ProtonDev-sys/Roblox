local scriptVersion = "2023-04-25T04:57:53.2998803Z"
local MarketplaceService = game:GetService("MarketplaceService")
local placeVersion = MarketplaceService:GetProductInfo(game.PlaceId).Updated
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/xHeptc/Kavo-UI-Library/main/source.lua"))()

local menu = lib.CreateLib("Slime Mine", "DarkTheme")

--[[

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


]]


local replicatedStorage = game:GetService("ReplicatedStorage")
local knitServices = replicatedStorage.Modules._Index["sleitnick_knit@1.4.7"].knit.Services

local knit = require(replicatedStorage:WaitForChild("Modules"):WaitForChild("knit"))


local invUtil = require(replicatedStorage.Util.inventoryUtil)
local infoHandler = knit.GetController("InformationController")
local eggInfo = infoHandler:getInformation("eggInfo")
local zoneInfo = infoHandler:getInformation("zonesInfo")
local oreInfo = infoHandler:getInformation("blocksInfo")
local dataController = knit.GetController("DataController")
local uiController = knit.GetController("UIController")
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
local services = replicatedStorage.Modules._Index["sleitnick_knit@1.4.7"].knit.Services

local localPage = menu:NewTab("Local")
local localTab = localPage:NewSection("Local Player")

localTab:NewSlider("Walkspeed", "Changed your walkspeed", 300, 0, function(value)
    player.Character.Humanoid.WalkSpeed = value
end)
localTab:NewButton("Unlock teleports", "Locally unlocks all the teleports in the teleport menu", function()
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
localTab:NewButton("Open Slime Awakening Menu", "Opens the Slime Awakening Menu (note you may have to press this more than once)", function()
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
localTab:NewButton("Open Ascension Menu", "Opens the Ascension Menu (note you may have to press this more than once)", function()
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
localTab:NewButton("Open Player Upgrades Menu", "Opens the Player Upgrades Menu (note you may have to press this more than once)", function()
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
local mainPage = menu:NewTab("Main")
local autofarmTab = mainPage:NewSection("Autofarm")
function getAreas() 
    local areas = {}
    for _,v in next, zoneInfo['names'] do 
        if _ <= zoneInfo['maxUnlockableZone'] then 
            table.insert(areas, v)
        end 
    end
    return areas
end
local areas = getAreas()
autofarmTab:NewDropdown("Select area", "Select the area you want to farm", areas,function(selected) 
    for _,v in next, zoneInfo['names'] do 
        if v == selected then 
            getgenv().area = _
        end 
    end    
end)
autofarmTab:NewToggle("Autopickup", "Automatically picks up drops", function(value)
    getgenv().autopickup = value
    if value then 
        task.spawn(function()
            while wait(.25) and getgenv().autopickup do 
                pickup()
            end 
        end) 
    end
end)
autofarmTab:NewToggle("Legit Mode", "Will walk to the blocks like a player, note it will not prioritise ores",function(value) 
    getgenv().legit = value
end)
autofarmTab:NewToggle("Autofarm", "If legit mode is not enabled then it will automatically mine from best->worst without moving at all",function(value) 
   getgenv().autofarm = value
   if value then 
        uiController.autoMining = false
        while getgenv().autofarm do 
            if getgenv().area then 
                local _closestBlock = closestBlock()

                warn(_closestBlock)
                if not getgenv().legit and not _closestBlock or (player.Character.PrimaryPart.Position - _closestBlock.Position).magnitude > 250 then 
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
autofarmTab:NewToggle("Autosell","Automatically teleports to sell when you have < 5 space left",function(value)
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
autofarmTab:NewToggle("Auto unlock next area","Will automatically put money/blocks into the new door",function(value)
    getgenv().autoUnlock = value 
    task.spawn(function()
        while getgenv().autoUnlock and task.wait() do 
            services.PlayerService.RF.requestAction:InvokeServer("unlockZone", getNextZone())
        end 
    end)
end)
local hatchTab = mainPage:NewSection("Auto hatch")


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
local eggs = getEggs()
hatchTab:NewDropdown("Select portal", "Select the portal you want to auto open", eggs,function(selected) 
    for i,v in next, eggInfo["eggNames"] do 
        if v == selected then 
            getgenv().egg = i 
        end 
    end
end)
hatchTab:NewToggle("Triple Hatch","Enable this if you have the triple hatch gamepass",function(value) 
   getgenv().hatchamount = value and 3 or 1
end)
hatchTab:NewToggle("Auto hatch","Automatically opens portals",function(value) 
    getgenv().autohatch = value 
    task.spawn(function()
        while getgenv().autohatch do
            local oldCFrame = player.Character.PrimaryPart.CFrame 
            if not game:GetService("Workspace").EggTriggers:FindFirstChild(getgenv().egg) then 
                for i = 0 , 7 , 1 do 
                    teleportToArea(i)
                    wait(.5)
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
local settingsPage = menu:NewTab("Settings")
local settings = settingsPage:NewSection("Settings")

settings:NewKeybind("Toggle ui", "Toggles the menu", Enum.KeyCode.RightControl, function()
	lib:ToggleUI()
end)

for _,v in next, getconnections(player.Idled) do 
    v:Disable()
end
warn("loaded ui")
function pickup() 
    for i,v in pairs(game.Workspace.PickupParts:GetChildren()) do
        if v.Name:sub(1,player.Name:len()) == player.Name  and v:FindFirstChild("Part") then
            services.BlocksService.RF.tryPickUpBlock:InvokeServer(v.Name:split("#")[4])
        end
    end
end

function teleportToArea(area)
    teleport(CFrame.new(Vector3.new(570.1199951171875, 213.043701171875, 1469.739990234375) - Vector3.new(0,0,380) * area))
end

function teleport(cframe)
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = cframe
    --[[
    local store = game.Players.LocalPlayer.Character.HumanoidRootPart
    store.Parent = nil
    wait()
    store.Parent = game.Players.LocalPlayer.Character
    wait()
    game.Players.LocalPlayer.Character.PrimaryPart = store
    warn("Tp complete")
    ]]
end


function shouldSell()
    return (invUtil:getBackpackCapacity(player) - getBackpackAmount() < 5) 
end

function getBackpackAmount()
    local backpackSize = 0
    for _,item in pairs(dataController:GetPlayerData("Inventory.inventory")) do 
        backpackSize += item.space 
    end 
    return backpackSize 
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
        player.Character.Humanoid:MoveTo(workspace.Sell:WaitForChild("Zone"..getgenv().area).Position)
        teleport(workspace.Sell:WaitForChild("Zone"..getgenv().area).CFrame)
        wait()
        player.Character.Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        wait(.5)
    until not shouldSell()
    if not getgenv().legit then
        teleport(oldCFrame)
    end
    player.Character.PrimaryPart.Velocity = Vector3.new(0,0,0)
end

function attack(targetBlock)
    if not targetBlock then return end
    local attackInfo = {}
    for i = 1, #petHandlerTable.equipped do 
        local pet = petHandlerTable.equipped[i]
        attackInfo[tostring(pet)] = {
            ["targeted"] = true,
            ["position"] = tonumber(i), 
            ["blockName"] = tostring(targetBlock)
        }
    end 
    
    for i = 1, #petHandlerTable.equipped do    
        local pet = petHandlerTable.equipped[i]
        task.spawn(function()
            knitServices.PlayerService.RF.requestAction:InvokeServer("setAttackInfo", attackInfo) 
            knitServices.BlocksService.RF.attackBlock:InvokeServer(tostring(targetBlock), tostring(pet))
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
            task.wait()
        end
    until not block or not block.Parent or block.Parent.Name ~= "Blocks" or not getgenv().autofarm 
end

teleportToArea(1)
warn("loading function")
function closestBlock()
    local area = getgenv().area
    local legit = getgenv().legit
    local closestDistance, closestBlock = math.huge, nil
    local ores = {}
    local playerPosition = player.Character.PrimaryPart.Position 
    for _,block in pairs(workspace.Blocks:GetChildren()) do 
        if not getgenv().autofarm then break end 
        if block.Name:sub(1,1) == tostring(area) then 
            local distance = (playerPosition-block.Position).magnitude
            local children = block:GetChildren()
            if #children > 8 then 
                for _,child in pairs(children) do 
                    local oreData = oreInfo['blocks'][tostring(child)]
                    if oreData then 
                        table.insert(ores, {
                            ['block'] = block,
                            ['rarity'] = oreInfo['raritiesScore'][oreData['rarity']] 
                        })
                        break 
                    end 
                end 
            elseif distance < closestDistance then 
                closestDistance = distance 
                closestBlock = block 
            end 
        end
    end
    table.sort(ores, function(a,b)
        return a['rarity'] > b['rarity']
    end)
    if #ores > 0 and not legit then
        return ores[1]['block']
    end
    return closestBlock
end
function walkFarm()
    local block = closestBlock()
    warn(block)
    if block then 
        pickup()
        player.Character.Humanoid:MoveTo(block.Position)
        attack(block)
        task.wait()
    end
    pickup()
end

function getNextZone() 
    local areas = {}
    for _,v in next, game:GetService("Workspace"):WaitForChild("Doors"):GetChildren() do 
        table.insert(areas, tonumber(v.Name))
    end 
    table.sort(areas, function(a,b)
        return a < b 
    end) 

    return areas[1]
end
