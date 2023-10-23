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

Tab:Select()
