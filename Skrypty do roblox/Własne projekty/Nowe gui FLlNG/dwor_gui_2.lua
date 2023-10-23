-- Tworzymy nową ramkę do przeciągania
local ScreenGui = Instance.new("ScreenGui")
local DragFrame = Instance.new("Frame")
DragFrame.Size = UDim2.new(0, 200, 0, 50)
DragFrame.Position = UDim2.new(0.5, -100, 0.5, -25)
DragFrame.BackgroundColor3 = Color3.new(1, 1, 1)

-- Tworzymy nowe okno do wpisywania
local oknodowpisywania = Instance.new("TextBox")
oknodowpisywania.Size = UDim2.new(1, 0, 0.8, 0)
oknodowpisywania.Text = ""
oknodowpisywania.PlaceholderText = "Wpisz coś tutaj..."
oknodowpisywania.Parent = DragFrame

-- Tworzymy przycisk do przeciągania
local dragButton = Instance.new("TextButton")
dragButton.Size = UDim2.new(1, 0, 0.2, 0)
dragButton.Position = UDim2.new(0, 0, 0.8, 0)
dragButton.Text = "Przeciągnij mnie"
dragButton.Parent = DragFrame

-- Dodajemy funkcję przeciągania
local UIS = game:GetService("UserInputService")
local dragging = false
local dragInput
local dragStart
local startPos

local function update(input)
    if dragging then
        local delta = input.Position - dragStart
        DragFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end

dragButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = DragFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

dragButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

-- Dodajemy DragFrame do ScreenGui
if DragFrame then
    DragFrame.Parent = ScreenGui
end

-- Dodajemy ScreenGui do gracza
if ScreenGui and game.Players.LocalPlayer:FindFirstChild("PlayerGui") then
    ScreenGui.Parent = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
end

local library = loadstring(game:HttpGet("https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()
local w1 = library:CreateWindow("Kamera GUI")

w1:Button(
    "Zniszcz GUI",
    function()
        for i, v in pairs(game.CoreGui:GetChildren()) do
            if v:FindFirstChild("Top") then
                v:Destroy()
            end
        end
        ScreenGui:Destroy()
    end
)

w1:Button(
    "Przestań oglądać",
    function()
        stopObserving()
    end
)

w1:Button(
    "ROZPIERDOL",
    function()
        trackPlayer(oknodowpisywania.Text)
    end
)

function trackPlayer(playerName)
    local players = game:GetService("Players")
    local lp = players.LocalPlayer
    local heli = lp.Character.HumanoidRootPart.Weld.Part1.Parent
    local grabber = heli.Preset.RopePull
    local car = grabber.BallSocketConstraint.Attachment1.Parent

    grabber.CanCollide = false

    for i, v in pairs(car.Parent:GetDescendants()) do
        if v:IsA("BasePart") then
            v.CanCollide = false
        end
    end

    local targetPlayer = players:FindFirstChild(playerName)
    if targetPlayer then
        local target = targetPlayer.Character:WaitForChild("HumanoidRootPart")
    else
        print("Nie znaleziono gracza o nazwie " .. playerName)
        return
    end

    local speed = 15
    local range = 100
    local LastPosition = target.Position
    local c = game:GetService("RunService").Heartbeat:Connect(function()
        if math.floor(LastPosition.X * 100) == math.floor(target.Position.X * 100) and math.floor(LastPosition.Y * 100) == math.floor(target.Position.Y * 100) and math.floor(LastPosition.Z * 100) == math.floor(target.Position.Z * 100) then
            car.CFrame = target.CFrame
        else
            local BackAndForth = math.sin(tick() * speed) * range / 2 + range / 2
            car.CFrame = target.CFrame + CFrame.lookAt(LastPosition, target.Position).LookVector * BackAndForth
        end

        LastPosition = target.Position

        car.Velocity = Vector3.new(0, 1000, 0)
        for i, v in pairs(heli:GetDescendants()) do
            if v:IsA("BasePart") then
                v.Velocity = Vector3.new(0, 0, 0)
            end
        end

        grabber.CFrame = heli.BoundingBox.CFrame

        workspace.CurrentCamera.CameraSubject = targetPlayer.Character.Humanoid

        while car:FindFirstAncestorOfClass("Workspace") and lp.Character.Humanoid.Health ~= 0 do
            wait()
        end

        if c then
            c:Disconnect()
        end
    end)
end

w1:Label("______________________________________")
w1:Label("Lista Graczy")

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
