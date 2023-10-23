-- Tworzenie interfejsu użytkownika
local ScreenGui = Instance.new("ScreenGui")
local DragFrame = Instance.new("Frame") -- Nowa ramka do przeciągania
local ScrollingFrame = Instance.new("ScrollingFrame")
local StopButton = Instance.new("TextButton")
local RefreshButton = Instance.new("TextButton")
local ToggleListButton = Instance.new("TextButton") -- Nowy przycisk do zwijania/rozwijania listy

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
DragFrame.Parent = ScreenGui -- Ustawienie DragFrame jako dziecko ScreenGui
ScrollingFrame.Parent = DragFrame -- Zmiana rodzica ScrollingFrame na DragFrame
StopButton.Parent = DragFrame -- Zmiana rodzica StopButton na DragFrame
RefreshButton.Parent = DragFrame -- Zmiana rodzica RefreshButton na DragFrame
ToggleListButton.Parent = DragFrame -- Ustawienie ToggleListButton jako dziecko DragFrame

-- Ustawienie właściwości DragFrame
DragFrame.Size = UDim2.new(0, 210, 0, 410) -- Powinno być nieco większe niż ScrollingFrame
DragFrame.Position = UDim2.new(0, 10, 0, 10)
DragFrame.BackgroundTransparency = 1 -- Ustawienie na 1 sprawia, że jest niewidoczne
DragFrame.Active = true -- Pozwala na interakcje z myszą
DragFrame.Draggable = true -- Umożliwia przeciąganie

-- Ustawienie właściwości ToggleListButton
ToggleListButton.Size = UDim2.new(0, 200, 0, 50)
ToggleListButton.Position = UDim2.new(0, 10, 0, 110) -- Przesunięcie w dół o 110 jednostek
ToggleListButton.Text = "Zwiń listę"
ToggleListButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
ToggleListButton.TextColor3 = Color3.fromRGB(153, 51, 255)

-- Zmiana koloru tła na czarny i koloru czcionki na zielony
ScrollingFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
StopButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
RefreshButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

StopButton.TextColor3 = Color3.fromRGB(153, 51, 255)
RefreshButton.TextColor3 = Color3.fromRGB(153, 51, 255)

-- Ramki i odstępy 
ScrollingFrame.Position = UDim2.new(0, 10, 0 ,160) -- Przesunięcie w dół o jednostkę
ScrollingFrame.Size=UDim2.new(0 ,200 ,0 ,250)
ScrollingFrame.CanvasSize=UDim2.new(0 ,0 ,0 ,#game.Players:GetPlayers() *60)

StopButton.Position=UDim2.new(0 ,10 ,0 ,60) -- Przesunięcie w dół o jednostkę
StopButton.Size=UDim2.new(0 ,200 ,0 ,50)
StopButton.Text="Stop observe"

RefreshButton.Position=UDim2.new(0 ,10 ,0 ,10) -- Przesunięcie w górę o jednostkę
RefreshButton.Size=UDim2.new(0 ,200 ,0 ,50)
RefreshButton.Text="Refresh list"

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

-- Dodanie zdarzenia do przycisku ToggleListButton
local isListVisible = true
ToggleListButton.MouseButton1Click:Connect(function()
    isListVisible = not isListVisible
    ScrollingFrame.Visible = isListVisible
    if isListVisible then
        ToggleListButton.Text = "Zwiń listę"
    else
        ToggleListButton.Text = "Rozwiń listę"
    end
end)

-- Dodanie zdarzeń do przycisków "Stop observe" i "Refresh list"
StopButton.MouseButton1Click:Connect(stopObserving)
RefreshButton.MouseButton1Click:Connect(refreshList)

-- Tworzenie przycisków dla każdego gracza
refreshList()