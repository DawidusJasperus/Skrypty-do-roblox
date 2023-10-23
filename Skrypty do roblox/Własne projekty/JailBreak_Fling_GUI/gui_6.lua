local Library = loadstring(game:HttpGet('https://raw.githubusercontent.com/bloodball/-back-ups-for-libs/main/Shaman.lua'))()
local Flags = Library.Flags

local Window = Library:Window({
    Text = "Moje GUI"
})

local Tab = Window:Tab({
    Text = "Pierwszy"
})

local Section = Tab:Section({
    Text = "Lista graczy"
})

local Section3 = Tab:Section({
    Text = "Opcje",
    Side = "Right"
})

-- Dodaj nową sekcję "Cel ataku"
local Section4 = Tab:Section({
    Text = "Cel ataku",
    Side = "Right"
})

-- Pobierz listę graczy
local players = game:GetService("Players")

local playerList = {}
for i, player in pairs(players:GetPlayers()) do
    table.insert(playerList, player.Name)
end

-- Dodaj listę graczy do rozwijanego menu
local dropdown = Section:Dropdown({
    Text = "Gracze",
    List = playerList,
    Flag = "SelectedPlayer",
    Callback = function(v)
        local selectedPlayer = players:FindFirstChild(v)
        if selectedPlayer then
            -- Zmień kamerę na wybranego gracza
            game.Workspace.CurrentCamera.CameraSubject = selectedPlayer.Character.Humanoid
        end
    end
})

Section3:Input({
    Placeholder = "Webhook URL",
    Flag = "URL"
})

-- Dodaj przycisk do odświeżania listy graczy
Section3:Button({
    Text = "Odśwież listę graczy",
    Callback = function()
        playerList = {}
        for i, player in pairs(players:GetPlayers()) do
            table.insert(playerList, player.Name)
        end
        dropdown:Refresh({ List = playerList })
    end
})

-- Dodaj przycisk do zatrzymania obserwacji gracza
Section3:Button({
    Text = "Zatrzymaj obserwację gracza",
    Callback = function()
        -- Zmień kamerę z powrotem na lokalnego gracza
        game.Workspace.CurrentCamera.CameraSubject = players.LocalPlayer.Character.Humanoid
    end
})

-- Dodaj przycisk Aktywacja
Section3:Button({
    Text = "Aktywacja",
    Callback = function()
        print("Przycisk Aktywacja został naciśnięty")
    end
})

-- Dodaj listę graczy do sekcji "Cel ataku"
Section4:Dropdown({
    Text = "Gracze",
    List = playerList,
    Flag = "AttackTarget",
    Callback = function(v)
        print("Wybrano cel ataku: " .. v)
    end
})

Tab:Select()