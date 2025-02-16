local otheropen = false
local PlayTime = 0
local Employment = "Unemployed"
local playercount = 0
local lastCheck = 0

RegisterNetEvent("CORRUPT:PauseMenu:ReturnData", function(job, playtime)
    Employment = job
    PlayTime = playtime
end)

RegisterKeyMapping('pausemenu', 'Open Pause Menu', 'keyboard', 'ESCAPE')

RegisterCommand("pausemenu", function()
    if GetEntityHealth(PlayerPedId()) <= 102 then
        return
    end
    if lastCheckControl() then
        lastCheck = GetGameTimer() + 15000
        TriggerServerEvent("CORRUPT:PauseMenu:GetData")
    end
    exports["corruptui"]:sendMessage({
        type = "PAUSE_MENU_SET_DATA",
        info = {
            name = CORRUPT.getPlayerName(CORRUPT.getPlayerId()),
            permId = CORRUPT.getUserId(),
            playtime = PlayTime,
            employment = Employment,
            playerCount = CORRUPT.GetNumPlayers(),
            minigamesPlayerCount = CORRUPT.GetNumPlayers(),
        }
    })
    
    if not otheropen then
        exports["corruptui"]:sendMessage({
            app = "pausemenu",
            type = "APP_TOGGLE",
        })
        CORRUPT.hideUI()
        TriggerScreenblurFadeIn(100.0)
        exports["corruptui"]:setFocus(true, true, false)
    else
        otheropen = false
    end
end, false)

local function closeMenu()
    exports["corruptui"]:sendMessage({
        app = "",
        type = "APP_TOGGLE",
    })
    CORRUPT.showUI()
    TriggerScreenblurFadeOut(100.0)
    exports["corruptui"]:setFocus(false, false, false)
end

exports["corruptui"]:registerCallback("pauseMenuClosed", function(data)
    closeMenu()
end)

exports["corruptui"]:registerCallback("settingsButtonClicked", function(data)
    closeMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_LANDING_MENU'), 0, -1)
    otheropen = true
end)

exports["corruptui"]:registerCallback("mapsButtonClicked", function(data)
    closeMenu()
    ActivateFrontendMenu(GetHashKey('FE_MENU_VERSION_MP_PAUSE'), 0, -1)
    otheropen = true
end)

exports["corruptui"]:registerCallback("disconnectButtonClicked", function(data)
    closeMenu()
    ForceSocialClubUpdate()
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        SetPauseMenuActive(false)
    end
end)

function lastCheckControl()
    if lastCheck <= GetGameTimer() then 
        return true 
    else
        return false
    end
end







-- [Pause Menu]
-- minigamesIP