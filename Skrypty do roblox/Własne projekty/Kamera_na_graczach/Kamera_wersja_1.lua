-- Tworzenie interfejsu użytkownika
local ScreenGui = Instance.new("ScreenGui")
local TextBox = Instance.new("TextBox")

ScreenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
TextBox.Parent = ScreenGui

TextBox.Position = UDim2.new(0, 10, 0, 10)
TextBox.Size = UDim2.new(0, 200, 0, 50)
TextBox.PlaceholderText = "Wpisz nazwę gracza"

-- Funkcja do obserwacji gracza
function observePlayer()
    local playerName = TextBox.Text
    local player = game.Players:FindFirstChild(playerName)
    if player then
        game.Workspace.CurrentCamera.CameraSubject = player.Character.Humanoid
    else
        print("Gracz o nazwie " .. playerName .. " nie został znaleziony.")
    end
end

-- Dodanie zdarzenia do pola tekstowego
TextBox.FocusLost:Connect(observePlayer)