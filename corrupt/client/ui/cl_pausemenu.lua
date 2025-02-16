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
    if tvRP.isInComa() and tvRP.isHandcuffed() then
        return
    end
    if GetCurrentFrontendMenuVersion() == -1 and not IsNuiFocused() then
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

local thismonth = {}
local alltime = {}

exports["corruptui"]:registerCallback("requestStatisticsPage", function(data)
    local timeframe = string.lower(data.timeframe)
    local sortingBy = string.lower(data.sortingBy)
    if timeframe == "this month" then
        TriggerEvent("CORRUPTUI:setStatistics", StatsSortingBy(sortingBy, timeframe, thismonth), CORRUPT.getUserId(), #thismonth)
    else
        TriggerEvent("CORRUPTUI:setStatistics", StatsSortingBy(sortingBy, timeframe, alltime), CORRUPT.getUserId(), #alltime)
    end
end)

RegisterNetEvent("CORRUPT:Stats:FullData", function(month, all)
    thismonth = month
    alltime = all
end)

function StatsSortingBy(sortingBy, timeframe, data)
    if timeframe == "this month" then
        data = thismonth
    else
        data = alltime
    end
    if string.find(sortingBy, "_reverse") then
        sortingBy = string.gsub(sortingBy, "_reverse", "")
        table.sort(data, function(a, b)
            return a[sortingBy] < b[sortingBy]
        end)
    else
        table.sort(data, function(a, b)
            return a[sortingBy] > b[sortingBy]
        end)
    end
    return data
end


Citizen.CreateThread(function()
    Wait(1000)
    TriggerServerEvent("CORRUPT:PauseMenu:GetData")
end)