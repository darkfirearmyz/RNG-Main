local playersFPS = {}
local playersPing = {}

local averageFPS = {
    World = 0,
    Rebel = 0,
    Sandy = 0,
    Casino = 0,
    Legion = 0
}

local averagePing = 0

function CORRUPT.GetAverageFPS()
    return averageFPS or 0
end

function CORRUPT.GetAveragePing()
    return math.floor(averagePing)
end

RegisterNetEvent("CORRUPT:submitFPS")
AddEventHandler("CORRUPT:submitFPS", function(location, fps)
    local source = source
    local ping = GetPlayerPing(source)
    playersFPS[source] = { location = location, fps = fps }
    playersPing[source] = math.floor(ping)
end)

Citizen.CreateThread(function()
    while true do
        local totalFPS = {
            World = 0,
            Rebel = 0,
            Sandy = 0,
            Casino = 0,
            Legion = 0
        }

        local totalPing = 0
        local playerCount = 0

        for _, data in pairs(playersFPS) do
            totalFPS[data.location] = totalFPS[data.location] + data.fps
            playerCount = playerCount + 1
        end

        for _, ping in pairs(playersPing) do
            totalPing = totalPing + ping
        end

        if playerCount > 0 then
            for location, fpsTotal in pairs(totalFPS) do
                averageFPS[location] = fpsTotal / playerCount
            end
            averagePing = totalPing / playerCount
        else
            for location, _ in pairs(averageFPS) do
                averageFPS[location] = 0
            end
            averagePing = 0
        end

        Citizen.Wait(1000)
    end
end)

AddEventHandler("playerDropped", function()
    local source = source
    playersFPS[source] = nil
    playersPing[source] = nil
end)
