local library = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()
local w1 = library:Window("Kamera GUI")

w1:Button(
    "              Zniszcz GUI",
    function()
        for i, v in pairs(game.CoreGui:GetChildren()) do
            if v:FindFirstChild("Top") then
                v:Destroy()
            end
        end
    end
)

w1:Button(
    "         Przestań oglądać",
    function()
        stopObserving()
    end
)

w1:Button(
    "         ROZPIERDOL",
    function()
        trackPlayer()
    end
)

function trackPlayer()
    local players = game:GetService("Players")
    local lp = players.LocalPlayer
    local heli = lp.Character.HumanoidRootPart.Weld.Part1.Parent
    local grabber = heli.Preset.RopePull
    local car = grabber.BallSocketConstraint.Attachment1.Parent

    grabber.CanCollide = false

    for i,v in pairs(car.Parent:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end

    -- Wprowadź nazwę gracza, którego chcesz obserwować.
    local playerName = "NazwaGracza"

    local targetPlayer = players:FindFirstChild(playerName)
    if targetPlayer then
        target = targetPlayer.Character:WaitForChild("HumanoidRootPart")
    else
        print("Nie znaleziono gracza o nazwie " .. playerName)
        return
    end

    local speed = 15
    local range = 100
    local LastPosition = target.Position
    local c = game:GetService("RunService").Heartbeat:Connect(function()

        if math.floor(LastPosition.X*100) == math.floor(target.Position.X*100) and math.floor(LastPosition.Y*100) == math.floor(target.Position.Y*100) and math.floor(LastPosition.Z*100) == math.floor(target.Position.Z*100) then do
                car.CFrame = target.CFrame
            end else
            local BackAndForth = math.sin(tick()*speed)*range/2+range/2
            car.CFrame = target.CFrame + CFrame.lookAt(LastPosition, target.Position).LookVector*BackAndForth
        end
        
        LastPosition = target.Position
        
        car.Velocity = Vector3.new(0,1000,0)
        for i,v in pairs(heli:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(0,0,0)
            end
        end
        
        grabber.CFrame = heli.BoundingBox.CFrame
    end)

    workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid -- Obserwuj wybranego gracza.

    while car:FindFirstAncestorOfClass("Workspace") and lp.Character.Humanoid.Health ~= 0 do
        task.wait()
    end

    c:Disconnect()
    workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid
end

w1:Label("______________________________________")
w1:Label("             Lista Graczy             ")

local buttons = {}

function observePlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    else
        print("Gracz o nazwie " .. playerName .. " nie został znaleziony.")
    end
end

function stopObserving()
    game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end

function addPlayerButtons()
    for i, button in ipairs(buttons) do
        button:Destroy()
    end

    buttons = {}

    for i, player in pairs(game.Players:GetPlayers()) do
        local button = w1:Button(
            player.Name,
            function()
                observePlayer(player.Name)
            end
        )
        table.insert(buttons, button)
    end
end

addPlayerButtons()