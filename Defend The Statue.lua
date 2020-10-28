spawn(function()
getgenv().on = true;
getgenv().name = game.Players.LocalPlayer.Name;
game.Players.LocalPlayer.Name = 'Script made by ProtonDev-Sys#4419'
for i , v in pairs(game:GetDescendants()) do
    if v.ClassName == 'TextLabel' and v.Text == getgenv().name then
        v.Text = 'Script made by ProtonDev-Sys#4419'
    end;
end;
while wait() do
    for i , v in pairs(game.Players.LocalPlayer:GetDescendants()) do
        if v.ClassName == 'TextLabel' and string.find(getgenv().name,v.Text) then
            v.Text = 'Script made by ProtonDev-Sys#4419'
        end;
    end;
end;
while getgenv().on == true do
game:GetService("RunService").Heartbeat:wait();
for i , v in pairs(game.Workspace.Enemies:GetChildren()) do
pcall(function()
game:GetService("Players").LocalPlayer.Character:FindFirstChildOfClass("Tool").Resources.Hit:FireServer(v)
end);
end;
end;
end);

spawn(function()
local plr = game.Players.LocalPlayer;
local target = game.Players['SheetOfPaper2'];

getgenv().on2  = true;

while getgenv().on2 do
    game:GetService("RunService").Heartbeat:wait();
    local t = plr.Character:FindFirstChildOfClass("Tool");
    if t then
        for i , v in pairs(game.Players:GetChildren()) do
            if v ~= game.Players.LocalPlayer and v.Character then
                t.Resources.Hit:FireServer(v.Character);
            end;
        end;
    end;
end;
end);
