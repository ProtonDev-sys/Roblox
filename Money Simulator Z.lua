loadstring(game:HttpGet("https://raw.githubusercontent.com/ProtonDev-sys/Roblox/main/linkvertise.lua"))()
local repo = 'https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/'

local Library = loadstring(game:HttpGet(repo .. 'Library.lua'))()
local ThemeManager = loadstring(game:HttpGet(repo .. 'addons/ThemeManager.lua'))()
local SaveManager = loadstring(game:HttpGet(repo .. 'addons/SaveManager.lua'))()

local player = game:GetService("Players").LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local events = ReplicatedStorage:WaitForChild("Events")
Window = Library:CreateWindow({
    Title = 'Money Simulator Z',
    Center = true,
    AutoShow = true,
    TabPadding = 8,
    MenuFadeTime = 0.2
})

local Tabs = {
    Factory = Window:AddTab("Factory"),
    Mining = Window:AddTab("Mining"),
    Teleports = Window:AddTab("Teleports"),
    ["Auto Buy"] = Window:AddTab("Auto Buy"),
    miscellaneous = Window:AddTab("Misc"),
    ['UI Settings'] = Window:AddTab('UI Settings'),
}


local FactoryLeftBox = Tabs.Factory:AddLeftGroupbox('Clicking')
local FactoryRightBox = Tabs.Factory:AddRightGroupbox('Factory Upgrades')

FactoryLeftBox:AddToggle('BoostMachines', {
    Text = 'Boost Machines',
    Default = false, 
    Tooltip = 'Automatically boosts machines for you.',

    Callback = function(Value)
        while Toggles.BoostMachines.Value do 
            wait() 
            fireclickdetector(workspace.MachineBoost["MachineBoost1"].ClickDetector)
        end
    end
})

FactoryLeftBox:AddToggle('BoostGems', {
    Text = 'Boost Gems',
    Default = false, 
    Tooltip = 'Automatically boosts gems for you.',

    Callback = function(Value)
        while Toggles.BoostGems.Value do 
            wait() 
            for _,v in next, game:GetService("Workspace").Factory.Gems:GetChildren() do 
                fireclickdetector(v.ClickDetector)
            end
        end
    end
})

FactoryLeftBox:AddToggle("CollectGems", {
    Text = 'Collect Gems',
    Default = false,
    Tooltip = 'Automatically collects gems for you (no need to use if you have the research)',

    Callback = function(value)
        while Toggles.CollectGems.Value do 
            task.wait() 
            for _,v in next, game:GetService("Workspace").Factory.Gems:GetChildren() do 
                fireclickdetector(v.ClickDetector)
            end
        end 
    end
})

local function formatGrid()
    local grid = {}

    local gridValue = player.Stats.GemGrid.Value 

    for _,v in next, gridValue:split(":") do 
        table.insert(grid, v)
    end
	return grid
end

FactoryLeftBox:AddToggle('MergeGems', {
    Text = 'Merge Gems',
    Default = false, 
    Tooltip = 'Automatically merges gems for you.',

    Callback = function(Value)
        while Toggles.MergeGems.Value do 
            wait() 
            local grid = formatGrid()
            for i = 1, #grid do
                for j = i + 1, #grid do
                    if i ~= j and grid[i] == grid[j] then
                        events.GemGrid:FireServer(i, j)
						wait(.1)
                        break
                    end
                end
            end
        end
    end
})

FactoryLeftBox:AddToggle("PrestigeUpgrades", {
    Text = "Purchase Prestige Upgrades",
    Default = false,
    Tooltip = "Automatically buys prestige upgrades for you.",

    Callback = function(value)
        while Toggles.PrestigeUpgrades.Value do 
            wait(.25)
            for _,v in next, ReplicatedStorage.PrestigeData:GetChildren() do 
                if not player.Stats:FindFirstChild("PrestigeUpgrade"..v.NeedToUnlock.Value) or player.Stats:FindFirstChild("PrestigeUpgrade"..v.Name) and player.Stats["PrestigeUpgrade"..v.Name].Value < v.UpgradeLimit.Value or player.Stats["PrestigeUpgrade"..v.NeedToUnlock.Value].Value > 0 and player.Stats["PrestigeUpgrade"..v.Name].Value < v.UpgradeLimit.Value then 
                    events.PrestigeUpgrade:FireServer(tonumber(v.Name), 50)
                end
            end
        end
    end
})

FactoryLeftBox:AddToggle("RebirthUpgrades", {
    Text = "Purchase Rebirth Upgrades",
    Default = false,
    Tooltip = "Automatically buys rebirth upgrades for you.",

    Callback = function(value)
        while Toggles.RebirthUpgrades.Value do 
            wait(.25)
            for _,v in next, ReplicatedStorage.RebirthData:GetChildren() do 
                if not player.Stats:FindFirstChild("RebirthUpgrade"..v.NeedToUnlock.Value) or player.Stats:FindFirstChild("RebirthUpgrade"..v.Name) and player.Stats["RebirthUpgrade"..v.Name].Value < v.UpgradeLimit.Value or player.Stats["RebirthUpgrade"..v.NeedToUnlock.Value].Value > 0 and player.Stats["RebirthUpgrade"..v.Name].Value < v.UpgradeLimit.Value then 
                    events.RebirthUpgrade:FireServer(tonumber(v.Name), 50)
                end
            end
        end
    end
})

local factoryUpgradeLimits = {
    [1] = 20,
    [2] = 18,
    [3] = math.huge,
    [4] = 9,
	[5] = 20,
}


FactoryRightBox:AddToggle("UpgradeFactory", {
    Text = 'Upgrade Factory',
    Default = false,
    Tooltip = 'Automatically upgrades everything in the "Factory" tab.',

    Callback = function(value)
        while Toggles.UpgradeFactory.Value do 
            wait() 
            for i = 1 , 5 , 1 do 
                if player.Stats["FactoryUpgrade"..tostring(i)].Value < factoryUpgradeLimits[i] then
                    events.FactoryUpgrade:FireServer(i,true)
                    wait(.5)
                end
            end
        end
    end
})

FactoryRightBox:AddToggle("UpgradeMachines", {
    Text = 'Upgrade Machines',
    Default = false,
    Tooltip = 'Automatically upgrades all your machines.',

    Callback = function(value)
        while Toggles.UpgradeMachines.Value do 
            wait() 
            for i = 1 , 10 ,1 do 
                events.UpgradeMachine:FireServer(i,2,true)
            end 
        end
    end
})

FactoryRightBox:AddToggle("BuyMachines", {
    Text = 'Buy machines',
    Default = false,
    Tooltip = 'Automatically buys all machines possible.',

    Callback = function(value)
        while Toggles.BuyMachines.Value do 
            wait() 
            for i = 1 , 5 , 1 do 
                if player.Stats["FactoryUpgrade"..tostring(i)].Value < factoryUpgradeLimits[i] then
                    events.FactoryUpgrade:FireServer(i,true)
                    wait(.5)
                end
            end
        end
    end
})



local MiningLeftBox = Tabs.Mining:AddLeftGroupbox('Mining')
local MiningRightBox = Tabs.Mining:AddRightGroupbox('Crafting')

function getNextOre()
    local ores = {}

    for _, ore in next, workspace.Ores:GetChildren() do
        local oreName = ore:FindFirstChild("OreName")
        if oreName and not getgenv().miningBlacklist[oreName.Value] then
            local priority = getgenv().miningPriority[oreName.Value] or 0
            table.insert(ores, {ore = ore, priority = priority})
        end
    end

	
    table.sort(ores, function(a, b)
        return a.priority > b.priority
    end)

	if ores[1] then 
    	return ores[1].ore
	else
		return false
	end
end


MiningLeftBox:AddToggle('AutoMine', {
    Text = 'Auto Mine',
    Default = false,
    Tooltip = 'Automatically mines rocks for you.',

    Callback = function(Value)
        while Toggles.AutoMine.Value do 
            task.wait() 
            local ore = getNextOre() 
            if ore then 
                local oldParent = ore.Parent
                events.MineOre:FireServer(tonumber(ore.Name))
                local t = tick()
                repeat 
                    task.wait() 
                    if tick() - t > 1 then 
                        t = tick() 
                        events.MineOre:FireServer(tonumber(ore.Name))
                    end
                until ore.Parent ~= oldParent or not Toggles.AutoMine.Value
            end
        end
    end
})

do 
    getgenv().miningBlacklist = {}
    getgenv().miningPriority = {}
    local prioritySlider 
    local blacklistedToggle
    local MiningDropdown 
    MiningDropdown = MiningLeftBox:AddDropdown('MiningDropdown', {
        Values = {},
        Default = 1,
        Multi = false,

        Text = 'Ore Priority',
        Tooltip = 'Allows you to change the priority of attacking ores.',
        Callback = function(value)
            getgenv().selectedOre = value 
            local priority = getgenv().miningPriority[value] or 0
            local blacklisted = getgenv().miningBlacklist[value] or false
            prioritySlider:SetValue(priority)
            blacklistedToggle:SetValue(blacklisted)
        end
    })

    prioritySlider = MiningLeftBox:AddSlider('MiningPriority', {
        Text = 'Priority', 
        Default = 0,
        Min = 0,
        Max = 5,
        Rounding = 0,
        Compact = false,
        HideMax = true, 

        Callback = function(value)
            if not getgenv().selectedOre and value > 0 then 
                prioritySlider:SetValue(0)
            else 
                getgenv().miningPriority[getgenv().selectedOre] = value 
            end 
        end
    })

    blacklistedToggle = MiningLeftBox:AddToggle('MiningBlacklist', {
        Text = 'Blacklist Ore',
        Default = false, 

        Callback = function(value)
            if not getgenv().selectedOre and value then 
                blacklistedToggle:SetValue(false)
            else 
                getgenv().miningBlacklist[getgenv().selectedOre] = value
            end
        end
    })

    local tree = {
        [0] = {
    
        },
        [1] = {
            "Coal",
            "RuneStone",
            "OreEssence"
        },
        [2] = {
            "Iron",
            "RuneStone",
            "OreEssence"
        },
        [3] = {
            "Copper",
            "RuneStone",
            "OreEssence"
        },
        [4] = {
            "Silver",
            "RuneStone",
            "OreEssence"
        },
        [5] = {
            "Gold",
            "RuneStone",
            "OreEssence"
        },
        [6] = {
            "Crystal",
            "Opal",
            "Lapis",
            "Jasper",
            "Jade",
            "Topaz",
            "RuneStone",
            "OreEssence"
        },
        [7] = {
            "Silicon",
            "RuneStone",
            "OreEssence"
        },
        [8] = {
            "Diamond",
            "RedDiamond",
            "GreenDiamond",
            "YellowDiamond",
            "BlackDiamond",
            "RuneStone",
            "OreEssence"
        }
    }

    if game.Players.LocalPlayer.Stats.Mine.Value ~= 0 then
        MiningDropdown:SetValues(tree[game.Players.LocalPlayer.Stats.Mine.Value])
    end
    game.Players.LocalPlayer.Stats.Mine.Changed:Connect(function()
        MiningDropdown:SetValues(tree[game.Players.LocalPlayer.Stats.Mine.Value])
    end)
end

local function getCraftRequirements(itemName, amount)
    local requirements = {}
    
    local itemFolder = ReplicatedStorage.CraftData.CraftList:FindFirstChild(itemName)
    if not itemFolder then
        return requirements
    end

    for _, child in ipairs(itemFolder:GetChildren()) do
        if child:IsA("NumberValue") then
            requirements[child.Name] = child.Value * amount
        end
    end

    return requirements
end

local function topologicalSort(itemName, visited, stack, result)
    if visited[itemName] then
        return
    end
    
    visited[itemName] = true
    local requirements = getCraftRequirements(itemName, 1) 

    for ingredient, _ in pairs(requirements) do
        topologicalSort(ingredient, visited, stack, result)
    end

    table.insert(stack, itemName)
end

local function calculateCrafting(itemName, amount, result)
    local requirements = getCraftRequirements(itemName, amount)

    for ingredient, requiredAmount in pairs(requirements) do
        if ReplicatedStorage.CraftData.CraftList:FindFirstChild(ingredient) then
            calculateCrafting(ingredient, requiredAmount, result)
        end

        result[ingredient] = (result[ingredient] or 0) + requiredAmount
    end
end

local function getCraftingOrderAndAmount(itemName, amount)
    local result = {}
    calculateCrafting(itemName, amount, result)
    local visited = {}
    local stack = {}
    topologicalSort(itemName, visited, stack, result)

    return result, stack
end

function getAmount(name)
	if game.Players.LocalPlayer.Stats:FindFirstChild(name) then
		return game.Players.LocalPlayer.Stats:FindFirstChild(name).Value 
	else 
		local craftInventory = game.Players.LocalPlayer.Stats.CraftInventory.Value
		for _,v in next, craftInventory:split(":") do
			local split = v:split(">")
			local n,am = split[1], split[2]
			if n == name then 
				return tonumber(am)
			end
		end
	end
	return 0
end

local function craft(itemName, amount)
	local pos = player.PlayerGui.GameGui.CraftFrame.Content.CraftList.CraftList:FindFirstChild(itemName).Position
	local itemIndex = math.floor(pos.X.Scale / 0.333) + (math.floor(pos.Y.Scale / 0.1) * 3) + 1
	local ownedAmount = getAmount(itemName)
	amount = math.max(amount-ownedAmount, 0)
	if amount > 0 then
		game:GetService("ReplicatedStorage").Events.Craft:FireServer(itemIndex, amount)
	end
end

function getOrderedCraftingItems()
    local items = {}
    for _,item in next, ReplicatedStorage.CraftData.CraftList:GetChildren() do 
        local pos = player.PlayerGui.GameGui.CraftFrame.Content.CraftList.CraftList:FindFirstChild(item.Name).Position
        local itemIndex = math.floor(pos.X.Scale / 0.333) + (math.floor(pos.Y.Scale / 0.1) * 3) + 1
        items[itemIndex] = item.Name 
    end

    return items
end

MiningRightBox:AddDropdown('CraftItems', {
    Values = getOrderedCraftingItems(),
    Default = 1,
    Multi = false,

    Text = 'Select Items To Craft',
    Tooltip = 'Allows you to automatically craft everything needed for certain items.',
    Callback = function(value)
        getgenv().craftingItem = value
    end
})


getgenv().craftAmount = 1
MiningRightBox:AddSlider('CraftAmount', {
    Text = 'Craft Amount', 
    Default = 1,
    Min = 1,
    Max = 1000,
    Rounding = 0,
    Compact = false,
    HideMax = true,

    Callback = function(value)
        getgenv().craftAmount = value 
    end
})

MiningRightBox:AddButton('Craft', function()
    local craftBlacklist = {
        ["OreEssence"] = true,
        ["RedDiamond"] = true,
        ["ResearchPoints"] = true
    }

    local craftAmounts, craftOrder = getCraftingOrderAndAmount(getgenv().craftingItem, getgenv().craftAmount)

    pcall(function()
        for _, ingredient in ipairs(craftOrder) do
            if not rawget(craftBlacklist, ingredient) and not ReplicatedStorage.Ores:FindFirstChild(ingredient.."1") then
                craft(ingredient, craftAmounts[ingredient] + 1)
            end
        end
    end)
    craft(getgenv().craftingItem, getAmount(getgenv().craftingItem) + getgenv().craftAmount)
end)

do
    local box = Tabs.Teleports:AddLeftGroupbox('Teleports')

    box:AddButton('Factory', function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.SpawnLocation.CFrame + Vector3.new(0,2,0)
    end)

    box:AddButton('City', function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(704.513245, 7.64234734, 134.697647, 0.955939233, -4.1481659e-08, 0.293564647, 4.18234904e-08, 1, 5.11283016e-09, -0.293564647, 7.390343e-09, 0.955939233)
    end)

    box:AddButton('Mine', function()
        events.EnterMine:FireServer(1)
    end)

    box:AddButton('Exit Mine', function()
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(704.513245, 7.64234734, 134.697647, 0.955939233, -4.1481659e-08, 0.293564647, 4.18234904e-08, 1, 5.11283016e-09, -0.293564647, 7.390343e-09, 0.955939233)
        ReplicatedStorage.Events.EnterMine:FireServer(0)
    end)
end

do 
    local leftAutoBuyGroup = Tabs["Auto Buy"]:AddLeftGroupbox('Factory')
    local tmp = function(aa, name)
        local arr = {}
        for _,v in next, aa:GetChildren() do 
            if v:FindFirstChild(name) then 
                table.insert(arr, v[name].Text)
            end
        end 
        return arr
    end
    leftAutoBuyGroup:AddDropdown('Factory', {
        Values = tmp(game.Players.LocalPlayer.PlayerGui.GameGui.UpgradesFrame.Content.FactoryUpgrades.List, "UpgradeName"),
        Default = 0,
        Multi = true,

        Text = 'Upgrade Factory',
        Tooltip = 'Automatically upgrade the factory for you.',
        Callback = function(value)
            local ind = 0 
            for _,v in next, Options.Factory.Value do 
                ind += 1 
            end
            while Options.Factory.Value == value and ind > 0 do 
                task.wait()

                for _,v in next, Options.Factory.Value do 
                    local ind 
                    for _2,v2 in next, game.Players.LocalPlayer.PlayerGui.GameGui.UpgradesFrame.Content.FactoryUpgrades.List:GetChildren() do 
                        if v2:FindFirstChild("UpgradeName") and v2.UpgradeName.Text == _ then 
                            ind = tonumber(string.split(v2.Name, "Upgrade")[2])
                            break 
                        end
                    end 
                    warn(ind)
                    events.FactoryUpgrade:FireServer(ind)
                    wait(.4)
                end 
            end
        end
    })

    leftAutoBuyGroup:AddDropdown('Gems', {
        Values = tmp(game.Players.LocalPlayer.PlayerGui.GameGui.UpgradesFrame.Content.GemsFrame.List, "UpgradeName"),
        Default = 0,
        Multi = true,

        Text = 'Upgrade Gems',
        Tooltip = 'Automatically upgrade the gem upgrades for you.',
        Callback = function(value)
            local ind = 0 
            for _,v in next, Options.Gems.Value do 
                ind += 1 
            end
            while Options.Gems.Value == value and ind > 0 do 
                task.wait()

                for _,v in next, Options.Gems.Value do 
                    local ind 
                    for _2,v2 in next, game.Players.LocalPlayer.PlayerGui.GameGui.UpgradesFrame.Content.GemsFrame.List:GetChildren() do 
                        if v2:FindFirstChild("UpgradeName") and v2.UpgradeName.Text == _ then 
                            ind = tonumber(string.split(v2.Name, "Upgrade")[2])
                            break 
                        end
                    end 
                    warn(ind)
                    events.GemUpgrade:FireServer(ind)
                    wait(.4)
                end 
            end
        end
    })

    leftAutoBuyGroup:AddDropdown('MergeGems', {
        Values = tmp(player.PlayerGui.GameGui.GridUpgrades.Content.List1, "UpgradeName"),
        Default = 0,
        Multi = true,

        Text = 'Upgrade Merge Gems',
        Tooltip = 'Automatically upgrade the merge gem upgrades for you.',
        Callback = function(value)
            local ind = 0 
            for _,v in next, Options.MergeGems.Value do 
                ind += 1 
            end
            while Options.MergeGems.Value == value and ind > 0 do 
                task.wait()

                for _,v in next, Options.MergeGems.Value do 
                    local ind 
                    for _2,v2 in next, player.PlayerGui.GameGui.GridUpgrades.Content.List1:GetChildren() do 
                        if v2:FindFirstChild("UpgradeName") and v2.UpgradeName.Text == _ then 
                            ind = tonumber(string.split(v2.Name, "Upgrade")[2])
                            break 
                        end
                    end 
                    warn(ind)
                    events.UpgradeGemGrid:FireServer(ind)
                    wait(.4)
                end 
            end
        end
    })

    leftAutoBuyGroup:AddDropdown('OreUpgrades', {
        Values = tmp(player.PlayerGui.GameGui.OresUpgrades.Content.List1, "UpgradeName"),
        Default = 0,
        Multi = true,

        Text = 'Upgrade Ore Upgrades',
        Tooltip = 'Automatically upgrade the ore upgrades for you.',
        Callback = function(value)
            local ind = 0 
            for _,v in next, Options.OreUpgrades.Value do 
                ind += 1 
            end
            while Options.OreUpgrades.Value == value and ind > 0 do 
                task.wait()

                for _,v in next, Options.OreUpgrades.Value do 
                    local ind 
                    for _2,v2 in next, player.PlayerGui.GameGui.OresUpgrades.Content.List1:GetChildren() do 
                        if v2:FindFirstChild("UpgradeName") and v2.UpgradeName.Text == _ then 
                            ind = tonumber(string.split(v2.Name, "Upgrade")[2])
                            break 
                        end
                    end 
                    warn(ind)
                    events.OreUpgrade:FireServer(ind, 999)
                    wait(.4)
                end 
            end
        end
    })

    leftAutoBuyGroup:AddDropdown('RareDiamonds', {
        Values = tmp(player.PlayerGui.GameGui.RareDiamonds.Content.List1, "UpgradeName"),
        Default = 0,
        Multi = true,

        Text = 'Upgrade Rare Diamonds',
        Tooltip = 'Automatically upgrade the rare diamonds upgrades for you.',
        Callback = function(value)
            local ind = 0 
            for _,v in next, Options.RareDiamonds.Value do 
                ind += 1 
            end
            while Options.RareDiamonds.Value == value and ind > 0 do 
                task.wait()

                for _,v in next, Options.RareDiamonds.Value do 
                    local ind 
                    for _2,v2 in next, player.PlayerGui.GameGui.RareDiamonds.Content.List1:GetChildren() do 
                        if v2:FindFirstChild("UpgradeName") and v2.UpgradeName.Text == _ then 
                            ind = tonumber(string.split(v2.Name, "Upgrade")[2])
                            break 
                        end
                    end 
                    warn(ind)
                    events.RareDiamond:FireServer(ind)
                    wait(.4)
                end 
            end
        end
    })

end

do 
    local leftMiscGroup = Tabs.miscellaneous:AddLeftGroupbox('Miscellaneous')

    leftMiscGroup:AddButton('Collect Secret Bucks', function()
        local cf = player.Character.HumanoidRootPart.CFrame 
        local defs = {}
        for _,v in next, workspace.SecretBucks:GetChildren() do 
            defs[v.Name] = v.CFrame
            v.CFrame = player.Character.HumanoidRootPart.CFrame
        end
        for _,v in next, workspace.SecretBucks:GetChildren() do 
            v.CFrame = defs[v.Name]
        end
    end)

    leftMiscGroup:AddSlider('Walkspeed', {
        Text = 'Walkspeed',
        Default = player.Character.Humanoid.WalkSpeed,
        Min = 16,
        Max = 200,
        Rounding = 0,
        Compact = false,
        HideMax = true, 

        Callback = function(value)
            while task.wait() and Options.Walkspeed.Value == value do
                if player.Character and player.Character:FindFirstChild("Humanoid") then
                    player.Character.Humanoid.WalkSpeed = value
                end
            end 
        end
    })

end 


Library:SetWatermarkVisibility(true)

local FrameTimer = tick()
local FrameCounter = 0;
local FPS = 60;

local WatermarkConnection = game:GetService('RunService').RenderStepped:Connect(function()
    FrameCounter += 1;

    if (tick() - FrameTimer) >= 1 then
        FPS = FrameCounter;
        FrameTimer = tick();
        FrameCounter = 0;
    end;

    Library:SetWatermark(('Protons Scripts | %s fps | %s ms'):format(
        math.floor(FPS),
        math.floor(game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue())
    ));
end);

Library.KeybindFrame.Visible = true; 

Library:OnUnload(function()
    WatermarkConnection:Disconnect()

    print('Unloaded!')
    Library.Unloaded = true
end)

local MenuGroup = Tabs['UI Settings']:AddLeftGroupbox('Menu')

MenuGroup:AddButton('Unload', function() Library:Unload() end)
MenuGroup:AddLabel('Menu bind'):AddKeyPicker('MenuKeybind', { Default = 'End', NoUI = true, Text = 'Menu keybind' })

Library.ToggleKeybind = Options.MenuKeybind 


ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)


SaveManager:IgnoreThemeSettings()


SaveManager:SetIgnoreIndexes({ 'MenuKeybind' })


ThemeManager:SetFolder('Proton')
SaveManager:SetFolder('Proton/Money-Simulator-Z')

SaveManager:BuildConfigSection(Tabs['UI Settings'])

ThemeManager:ApplyToTab(Tabs['UI Settings'])

SaveManager:LoadAutoloadConfig()
