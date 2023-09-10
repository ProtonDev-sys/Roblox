local esp = {}

esp.Boxes = {}

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

function esp:createBoxDrawing()
    local box = {}
    for i = 1 , 4 , 1 do
        box[i] = Drawing.new("Line")
        box[i].Color = Color3.fromRGB(255,255,255)
        box[i].Thickness = 2
    end
    return box
end

function esp:removeBox(player)

end

function esp:Box(player, part, colour)
    if not player.Parent or not part.Parent then return true end
    local TL = Camera:WorldToViewportPoint(part.CFrame * CFrame.new(-3,3,0).p)
    local TR = Camera:WorldToViewportPoint(part.CFrame * CFrame.new(3,3,0).p)
    local BL = Camera:WorldToViewportPoint(part.CFrame * CFrame.new(-3,-3,0).p)
    local BR = Camera:WorldToViewportPoint(part.CFrame * CFrame.new(3,-3,0).p)
    local box
    if not esp.Boxes[player.UserId] then
        box = esp:createBoxDrawing()
        esp.Boxes[player.UserId] = box
        box[1].Color = colour
        box[2].Color = colour
        box[3].Color = colour
        box[4].Color = colour
    else
        box = esp.Boxes[player.UserId]
    end

    local _,Visible = Camera:WorldToScreenPoint(part.Position)
    if Visible then
        box[1].From =  Vector2.new(TL.X, TL.Y) 
        box[1].To = Vector2.new(BL.X, BL.Y)
        box[1].Visible = true

        box[2].To = Vector2.new(TR.X, TR.Y)
        box[2].From = Vector2.new(TL.X, TL.Y)
        box[2].Visible = true

        box[3].To = Vector2.new(BR.X, BR.Y)
        box[3].From = Vector2.new(TR.X, TR.Y)
        box[3].Visible = true

        box[4].To = Vector2.new(BR.X, BR.Y)
        box[4].From = Vector2.new(BL.X, BL.Y)
        box[4].Visible = true
    else
        box[1].Visible = false
        box[2].Visible = false
        box[3].Visible = false
        box[4].Visible = false
    end
end

function esp:createBox(player, part, colour)
    warn(player)
    esp:Box(player, part, colour)
    local id = player.UserId
    local connection
    connection = RunService.RenderStepped:Connect(function()
        if esp:Box(player, part) then
            warn("delete")
            for _,line in next, esp.Boxes[id] do
                line.Remove()
            end
            esp.Boxes[id] = nil
            connection:Disconnect()
        end
    end)
end

function esp:changeBoxColour(player, colour)
    if esp.Boxes[player.UserId] then
        warn(colour)
        for _,line in next, esp.Boxes[player.UserId] do
            line.Color = colour
        end
    else 
        error("ESP BOX DOESN'T EXIST")
    end
end

function esp:boxExists(player)
    if esp.Boxes[player.UserId] then
        return true
    else
        return false
    end
end

return esp
