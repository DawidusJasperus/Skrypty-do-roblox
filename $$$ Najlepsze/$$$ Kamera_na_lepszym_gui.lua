local library = loadstring(game.HttpGet(game, "https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/0x"))()

local w1 = library:Window("Kamera GUI") -- Text

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


w1:Label("______________________________________") -- Text
w1:Label("             Lista Graczy             ") -- Text

-- Przechowujemy referencje do przycisków
local buttons = {}

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

-- Funkcja do dodawania przycisków dla graczy
function addPlayerButtons()
    -- Usuwamy stare przyciski
    for i, button in ipairs(buttons) do
        button:Destroy()
    end

    -- Czyścimy listę przycisków
    buttons = {}

    -- Dodajemy nowe przyciski
    for i, player in pairs(game.Players:GetPlayers()) do
        local button = w1:Button(
            player.Name,
            function()
                observePlayer(player.Name)
            end
        )

        -- Dodajemy przycisk do listy
        table.insert(buttons, button)
    end
end

-- Dodajemy listę graczy na początku
addPlayerButtons()
