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

tab1:addToggle("Autofarm",false,function(value) 
   getgenv().autofarm = value
end)

tab1:addToggle("Autosell",false,function(value)
    getgenv().autosell = value
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
            v.Part.Position = game.Players.LocalPlayer.Character.HumanoidRootPart.Position
        end
    end
end

function sell()
    local cf = game:GetService("Workspace").Sell:WaitForChild("Zone1").CFrame
    game:GetService("Workspace").Sell.Zone1.CFrame = game.Players.LocalPlayer.Character.PrimaryPart.CFrame
    wait(1)
    game:GetService("Workspace").Sell.Zone1.CFrame = cf
end

wait(2)
local pets = getpets()
while task.wait() do 
    if getgenv().autofarm and getgenv().area then 
        for i,v in pairs(game.Workspace.Blocks:GetChildren()) do
            if not getgenv().autofarm then break end 
            if v.Name:sub(1,1) == getgenv().area then 
                repeat 
                    task.wait()
                    game.Players.LocalPlayer.Character.PrimaryPart.CFrame = v.CFrame
                    v.CanCollide = false 
                until not v or not v.Parent or v.Parent.Name ~= "Blocks" or not getgenv().autofarm 
                task.spawn(function()
                    pickup()
                    sell()
                end)
            end
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
