local map = {} 

local _ind = 1
for _,v in next, game:GetService("Players").LocalPlayer.PlayerGui.PlacePane.PlacePane.wrapper.container.ColorSelection.wrapper.contents:GetChildren() do 
    if v:FindFirstChild("button") then 
        map[_ind] = v.wrapper.container.inner.BackgroundColor3 
        _ind ++ 
    end
end


local t = workspace.Chunks:GetDescendants()
local pixels = {}
for _,v in next, t do 
    if v:IsA("BasePart") then 
        local x = v.Position.X - 1 
        local y = v.Position.Z -1 
        if not pixels[x] then 
            pixels[x] = {}
        end 
        pixels[x][y] = v
    end
end

local httpService = game:GetService("HttpService")

function buildBlueprint(name)
    local blueprint
    if string.find(name,'.') then 
        blueprint = readfile(name)
    else 
        blueprint = game:HttpGet("https://raw.githubusercontent.com/ProtonDev-sys/Roblox/main/Color%20Place/Blueprints/"..name..".txt")
    end
    local blueprintJSON = httpService:JSONDecode(blueprint)
    local metadata = blueprintJSON['dimensions']
    local pixels = blueprintJSON['pixels']
    task.spawn(function()
        previewPixel(pixels, metadata['sizeX'], metadata['sizeY'], metadata['startX'], metadata['startX'], metadata['ox1'], metadata['ox2'], metadata['oy1'], metadata['oy2'], metadata['bg'])

    end)
end

local function getPixel(x,y)
    return pixels[x][y]
end


local change = game:GetService("ReplicatedStorage").Remotes.ChangeColor


function placePixel(imagePixels, sizex, sizey, startx, starty, ox1, ox2, oy1, oy1, bg) 
    for pxl, col in next, imagePixels do 
        local split = string.split(pxl,' ')
        local x,y = tonumber(split[1]) + startx, tonumber(split[2]) + starty 
        local part = getPixel(x,y)
        if part.Color ~= map[tonumber(col)] then 
            print('Placing color '..col..' ('..tostring(map[tonumber(col)])..') at '..x..' '..y)
            change:FireServer(part, tonumber(col))
            return
        end
    end
    if not bg then return end
    for x = startx + ox1, startx + sizex + ox2, 1 do 
        for y = starty + oy1, sy + sizey + oy2, 1 do 
            if not pixels[x-startx..' '..y-starty] then 
                local part = getPixel(x,y)
                if part.Color ~= map[bg] then 
                    print('Placing color 2('..tostring(map[bg])..') at '..x..' '..y)
                    change:FireServer(part, bg)
                    return
                end
            end
        end
    end
end

function previewPixel(imagePixels, sizex, sizey, startx, starty, ox1, ox2, oy1, oy2, bg)
    for pxl, col in next, imagePixels do 
        local split = string.split(pxl,' ')
        local x,y = tonumber(split[1]) + startx, tonumber(split[2]) + starty
        local part = getPixel(x,y)
        local clo = part:Clone()
        clo.Parent = workspace 
        clo.Anchored = true 
        clo.Color = map[tonumber(col)]
    end
    if not bg then return end
    for x = startx + ox1, startx + sizex + ox2, 1 do 
        for y = starty + oy1, starty + sizey + oy2, 1 do 
            if not imagePixels[x-startx..' '..y-starty] then 
                local part = getPixel(x,y)
                local col = part:Clone()
                col.Parent = workspace 
                col.Anchored = true 
                col.Color = map[tonumber(bg)]
            end
        end
    end
end

for _,v in next, getconnections(game.Players.LocalPlayer.Idled) do 
    v:Disable()
end
