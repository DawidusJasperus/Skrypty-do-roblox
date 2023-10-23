-- Tworzenie interfejsu użytkownika
local ScreenGui = Instance.new("ScreenGui")
local ScrollingFrame = Instance.new("ScrollingFrame")
local StopButton = Instance.new("TextButton")
local RefreshButton = Instance.new("TextButton")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
ScrollingFrame.Parent = ScreenGui
StopButton.Parent = ScreenGui
RefreshButton.Parent = ScreenGui

-- Zmiana koloru tła na czarny i koloru czcionki na zielony
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RefreshButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

StopButton.TextColor3 = Color3.fromRGB(153, 51, 255)
RefreshButton.TextColor3 = Color3.fromRGB(153, 51, 255)

-- Ramki i odstępy 
ScrollingFrame.Position = UDim2.new(0, 10, 0, 10)
ScrollingFrame.Size = UDim2.new(0, 200, 0, 300)
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #game.Players:GetPlayers() * 60)

StopButton.Position = UDim2.new(0, 10, 0, 310)
StopButton.Size = UDim2.new(0, 200, 0, 50)
StopButton.Text = "Stop observe"

RefreshButton.Position = UDim2.new(0, 10, 0, 361)
RefreshButton.Size = UDim2.new(0, 200, 0, 50)
RefreshButton.Text = "Refresh list"

-- Funkcja do obserwacji gracza
function observePlayer(playerName)
    local player = game.Players:FindFirstChild(playerName)
    if player then
        game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    else
        print("Gracz o nazwie " .. playerName .. " nie został znaleziony.")
    end
end

-- Funkcja do przestania obserwacji gracza
function stopObserving()
    game.Workspace.CurrentCamera.CameraSubject = game.Players.LocalPlayer.Character.Humanoid
end

-- Funkcja do odświeżania listy graczy
function refreshList()
    for i, v in pairs(ScrollingFrame:GetChildren()) do
        if v:IsA("TextButton") then
            v:Destroy()
        end
    end

    ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #game.Players:GetPlayers() * 60)

    for i, player in ipairs(game.Players:GetPlayers()) do
        local Button = Instance.new("TextButton")
        Button.Parent = ScrollingFrame
        Button.Position = UDim2.new(0, 0, 0, (i - 1) * 60)
        Button.Size = UDim2.new(1, 0, 0, 50)
        Button.Text = player.Name
        -- Kolory na kafelkach z graczami
        Button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        Button.TextColor3 = Color3.fromRGB(255, 154, 0)

        -- Dodanie zdarzenia do przycisku
        Button.MouseButton1Click:Connect(function()
            observePlayer(player.Name)
        end)
    end
end

-- Dodanie zdarzeń do przycisków "Stop observe" i "Refresh list"
StopButton.MouseButton1Click:Connect(stopObserving)
RefreshButton.MouseButton1Click:Connect(refreshList)

-- Tworzenie przycisków dla każdego gracza
refreshList()