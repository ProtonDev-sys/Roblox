local Title = "Generic Key - Key System"
local ProjectId = "4620d413fa24"
local HttpService = game:GetService("HttpService")
local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(game.CoreGui)

local Verified = false
Iris:Connect(function()
    if not Verified then
        Iris.Window({Title, [Iris.Args.Window.NoClose] = true, [Iris.Args.Window.NoResize] = true, [Iris.Args.Window.NoScrollbar] = true, [Iris.Args.Window.NoCollapse] = true}, {size = Iris.State(Vector2.new(500, 120))}) do
            local Key = Iris.InputText({"", [Iris.Args.InputText.TextHint] = "Your key here."}).text.value
            if Iris.Button({"Check key"}).clicked then
              task.spawn(function()
                local Response = game:HttpGet(("https://mikecash.co/api/keyverify?key=%s&project=%s"):format(Key, ProjectId))
                local Decode = HttpService:JSONDecode(Response)
                Verified = Decode.success
              end)
            end
            Iris.End()
        end
    end
end)

repeat task.wait() until Verified
