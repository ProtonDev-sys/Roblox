local cachedVersion = "2023-04-21T19:06:28.443495Z"
local MarketplaceService = game:GetService("MarketplaceService")
local placeVersion = MarketplaceService:GetProductInfo(game.PlaceId).Updated



local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/GreenDeno/Venyx-UI-Library/main/source.lua"))()



local function getAreas() 
    local areas = {}
    for _,v in next, game:GetService("Workspace").Areas:GetChildren() do 
        if tostring(tonumber(v.Name)) == v.Name then 
            table.insert(areas, v.Name)
        end
    end 
    table.sort(areas, function(a,b)
        return tonumber(a) < tonumber(b)
    end)
    return areas
end

function getEggs()
    local eggs = {}
    for _,v in next, game:GetService("ReplicatedStorage").Eggs:GetChildren() do 
        local txt = v.Name:sub(v.Name:len(),v.Name:len())
        if tostring(tonumber(txt)) == txt then 
            table.insert(eggs, v.Name)
        end 
    end 
    return eggs 
end 

function getpets() 
    for _,v in next, getgc(true) do 
        if type(v) == 'table' and rawget(v,'petHandlers') then 
            if v['player'] == game.Players.LocalPlayer then 
                return v
            end
        end 
    end    
end


local themes = {
    Background = Color3.fromRGB(24, 24, 24),
    Glow = Color3.fromRGB(0, 0, 0),
    Accent = Color3.fromRGB(10, 10, 10),
    LightContrast = Color3.fromRGB(20, 20, 20),
    DarkContrast = Color3.fromRGB(14, 14, 14),  
    TextColor = Color3.fromRGB(255, 255, 255)
}

local menu = lib.new("Slime Mine", 5013109572)

if placeVersion ~= cachedVersion then 
    menu:toggle()
    getgenv()._continue = nil
    menu:Notify("UPDATE DETECTED", "The game has updated and the script is not guranteed to be safe, are you sure you want to continue?", function(val)
        getgenv()._continue = val 
    end) 
    repeat 
        task.wait()
    until getgenv()._continue ~= nil 
    warn(getgenv()._continue)
    if getgenv()._continue == false then 
        exit()
    end 
    menu:toggle()
end

local page = menu:addPage("Local Player", 5012544693)
local tab = page:addSection("Local Player")
tab:addSlider("Walkspeed", 16, 0, 300, function(value)
    game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
end)
tab:addButton("Unlock teleports", function()
    local plr = game.Players.LocalPlayer 
    for _,v in next, plr.PlayerGui.UI.Zones.ScrollingFrame:GetChildren() do 
        if v.ClassName == 'Frame' and v.Name ~= "Lobby" then 
            v.TextButton.Locked.Visible = false 
            v.TextButton.MouseButton1Click:Connect(function()
                game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("teleportToZone", tonumber(v.Name:split("Zone")[2]))
            end) 
        end
    end

    plr.PlayerGui.UI.ChildAdded:Connect(function(v)
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
local page1 = menu:addPage("Main", 5012544693)

local tab1 = page1:addSection("Autofarm")
tab1:addDropdown("Select area",getAreas(),function(selected) 
    if tostring(tonumber(selected)) == selected then 
        getgenv().area = selected
    end
end)

tab1:addToggle("Autopickup",false,function(value)
    getgenv().autopickup = value
end)

tab1:addToggle("Legit Mode",false,function(value) 
    getgenv().legit = value
 end)

tab1:addToggle("Autofarm",false,function(value) 
   getgenv().autofarm = value
end)

tab1:addToggle("Autosell",false,function(value)
    getgenv().autosell = value
end)

function getNextZone() 
    local smal = math.huge 
    local areas = {}
    for _,v in next, game:GetService("Workspace").Doors:GetChildren() do 
        table.insert(areas, tonumber(v.Name))
    end 
    table.sort(areas, function(a,b)
        return a<b 
    end) 

    return areas[1]
end

tab1:addToggle("Auto unlock area",false,function(value)
    getgenv().autoUnlock = value 
    task.spawn(function()
        while getgenv().autoUnlock and task.wait() do 
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("unlockZone", getNextZone())
        end 
    end)
end)

local tab2 = page1:addSection("Auto hatch")
tab2:addDropdown("Select egg",getEggs(),function(selected) 
    getgenv().egg = selected
end)
getgenv().hatchamount = 1
tab2:addToggle("Triple Hatch",false,function(value) 
   getgenv().hatchamount = value and 3 or 1
end)

tab2:addToggle("Auto hatch",false,function(value) 
    getgenv().autohatch = value 
    task.spawn(function()
        while getgenv().autohatch do
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("hatch", getgenv().egg, getgenv().hatchamount)
        end 
    end)
end)
local theme = menu:addPage("Settings", 5012544693)
local colors = theme:addSection("Colors")

for theme, color in pairs(themes) do 
    colors:addColorPicker(theme, color, function(color3)
        menu:setTheme(theme, color3)
    end)
end

local misc = theme:addSection("misc")
misc:addKeybind("Toggle Keybind", Enum.KeyCode.RightControl, function()
    print("Activated Keybind")
    menu:toggle()
end, function()
    print("Changed Keybind")
end)

for _,v in next, getconnections(game.Players.LocalPlayer.Idled) do 
    v:Disable()
end

function pickup() 
    for i,v in pairs(game.Workspace.PickupParts:GetChildren()) do
        if v.Name:sub(1,game.Players.LocalPlayer.Name:len()) == game.Players.LocalPlayer.Name  and v:FindFirstChild("Part") then
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.BlocksService.RF.tryPickUpBlock:InvokeServer(v.Name:split("#")[4])
        end
    end
end

local knit = require(game.ReplicatedStorage:WaitForChild("Modules"):WaitForChild("knit"));
local invUtil = require(game:GetService("ReplicatedStorage").Util.inventoryUtil)
dataController = knit.GetController("DataController");

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
    if not shouldSell() then return end
    local cf = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
    if not workspace:WaitForChild("Sell"):FindFirstChild("Zone1") then 
        game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("teleportToZone", 1)
        wait(2)
        game.Players.LocalPlayer.Character.PrimaryPart.CFrame = cf
    end
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = game:GetService("Workspace").Sell:WaitForChild("Zone1").CFrame
    wait(1)
    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = cf
end

wait(2)
--local pets = getpets()

function teleportFarm()
    for i,v in pairs(game.Workspace.Blocks:GetChildren()) do
        if not getgenv().autofarm then break end 
        if v.Name:sub(1,1) == getgenv().area then 
            repeat 
                task.wait()
                game.Players.LocalPlayer.Character.PrimaryPart.CFrame = v.CFrame
                v.CanCollide = false 
                pickup()
                if getgenv().autosell then 
                    sell()
                end
            until not v or not v.Parent or v.Parent.Name ~= "Blocks" or not getgenv().autofarm 
            task.spawn(function()
                pickup()
                if getgenv().autosell then 
                    sell()
                end
            end)
        end
    end
end

function closestBlock()
    local closest, block = math.huge, nil
    for _,v in next, workspace.Blocks:GetChildren() do 
        if not getgenv().autofarm then break end 
        if v.Name:sub(1,1) == getgenv().area then 
            local dist = (game.Players.LocalPlayer.Character.PrimaryPart.Position-v.Position).magnitude 
            if dist < closest and math.abs(game.Players.LocalPlayer.Character.PrimaryPart.Position.Y-v.Position.Y) < 14 then 
                closest = dist 
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
        if getgenv().autosell then 
            sell()
        end
        game.Players.LocalPlayer.Character.Humanoid:MoveTo(block.Position)
    end
    pickup()
    if getgenv().autosell then 
        sell()
    end
end

local old = getgenv().area
while task.wait() do 
    if getgenv().autofarm and getgenv().area then 
        if getgenv().area ~= old then 
            game:GetService("ReplicatedStorage").Modules._Index["sleitnick_knit@1.4.7"].knit.Services.PlayerService.RF.requestAction:InvokeServer("teleportToZone", tonumber(getgenv().area))
        end 
        old = getgenv().area
        if not getgenv().legit then 
            teleportFarm()
        else 
            walkFarm()
        end 
    end
    if getgenv().autopickup and not getgenv().autofarm then 
        task.spawn(function()
            pickup()
        end)
    end
    if getgenv().autosell and not getgenv().autofarm then 
        task.spawn(function()
            sell()
        end)
    end 
end

--[[

for _,v in next, getgc() do 
    if type(v) == 'function' and debug.getinfo(v).name == 'GetPlayerData' then 
        local old = v 
        old  = hookfunction(v, function(...)
            local args = {...}
            if args[2] == "Zone.current" then 
                return 69 
            else 
                return old(...)
            end
        end)
    end 
end

]]
