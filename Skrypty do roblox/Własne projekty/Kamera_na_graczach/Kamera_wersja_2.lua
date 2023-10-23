-- Tworzenie interfejsu użytkownika
local ScreenGui = Instance.new("ScreenGui")
local ScrollingFrame = Instance.new("ScrollingFrame")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScrollingFrame.Parent = ScreenGui

ScrollingFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollingFrame.Size = UDim2.new(0, 200, 0, 300)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #game.Players:GetPlayers() * 60)

-- Funkcja do obserwacji gracza
function observePlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    else
        print("Gracz o nazwie " .. playerName .. " nie został znaleziony.")
    end
end

-- Tworzenie przycisków dla każdego gracza
for i, player in ipairs(game.Players:GetPlayers()) do
    local Button = Instance.new("TextButton")
    Button.Parent = ScrollingFrame
    Button.Position = UDim2.new(0, 0, 0, (i - 1) * 60)
    Button.Size = UDim2.new(1, 0, 0, 50)
    Button.Text = player.Name

    -- Dodanie zdarzenia do przycisku
    Button.MouseButton1Click:Connect(function()
        observePlayer(player.Name)
    end)
end