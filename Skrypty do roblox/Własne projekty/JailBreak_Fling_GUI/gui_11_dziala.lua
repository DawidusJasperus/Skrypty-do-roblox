-- Ładowanie biblioteki
local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Shaman.lua'))()
local Flags = Library.Flags
local players = game:GetService("Players")

-- Tworzenie interfejsu użytkownika
local Window = Library:Window({Text = "Moje GUI"})
local Tab = Window:Tab({Text = "Pierwszy"})
local Section = Tab:Section({Text = "Lista graczy"})
local Section3 = Tab:Section({Text = "Opcje", Side = "Right"})
local Section4 = Tab:Section({Text = "Cel ataku", Side = "Right"})

-- Pobranie listy graczy
local playerList = {}
for _, player in pairs(players:GetPlayers()) do
    table.insert(playerList, player.Name)
end

-- Dropdown dla graczy
local dropdown = Section:Dropdown({
    Text = "Gracze",
    List = playerList,
    Flag = "SelectedPlayer",
    Callback = function(v)
        local selectedPlayer = players:FindFirstChild(v)
        if selectedPlayer then
            game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
        end
    end
})

-- Dropdown dla graczy do ataku
local attackTargetName
local dropdown2 = Section4:Dropdown({
    Text = "Gracze do ataku",
    List = playerList,
    Flag = "AttackTarget",
    Callback = function(v)
        print("Wybrano cel ataku: " .. v)
        attackTargetName = v
    end
})

-- Przyciski
Section3:Button({
    Text = "Przestań oglądać gracza",
    Callback = function()
        game.Workspace.CurrentCamera.CameraSubject = players.LocalPlayer.Character.Humanoid
    end
})

Section3:Button({
    Text = "Odśwież listę graczy",
    Callback = function()
        playerList = {}
        for _, player in pairs(players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        dropdown:Refresh({List = playerList})
        dropdown2:Refresh({List = playerList})
    end
})

Section3:Button({
    Text = "Aktywacja fling",
    Callback = function()
        print("Przycisk Aktywacja został naciśnięty")
        atak()
    end
})

-- Funkcja ataku
function atak()
    local lp = players.LocalPlayer
    local heli = lp.Character.HumanoidRootPart.Weld.Part1.Parent
    local grabber = heli.Preset.RopePull
    local car = grabber.BallSocketConstraint.Attachment1.Parent
    grabber.CanCollide = false

    for _, v in pairs(car.Parent:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end

    local playerName = attackTargetName
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
        if math.floor(LastPosition.X * 100) == math.floor(target.Position.X * 100) and
           math.floor(LastPosition.Y * 100) == math.floor(target.Position.Y * 100) and
           math.floor(LastPosition.Z * 100) == math.floor(target.Position.Z * 100) then
            car.CFrame = target.CFrame
        else
            local BackAndForth = math.sin(tick() * speed) * range / 2 + range / 2
            car.CFrame = target.CFrame + CFrame.lookAt(LastPosition, target.Position).LookVector * BackAndForth
        end

        LastPosition = target.Position
        car.Velocity = Vector3.new(0, 1000, 0)

        for _, v in pairs(heli:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end

        grabber.CFrame = heli.BoundingBox.CFrame
    end)

    workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid

    while car:FindFirstAncestorOfClass("Workspace") and lp.Character.Humanoid.Health ~= 0 do
        task.wait()
    end

    c:Disconnect()
    workspace.CurrentCamera.CameraSubject = lp.Character.Humanoid
end

-- Wybór zakładki na koniec
Tab:Select()