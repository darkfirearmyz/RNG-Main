local a = 0
local b = 0
local c = 0
local d = vector3(0, 0, 0)
local e = false
local f = PlayerPedId
function savePlayerInfo()
    a = f()
    b = GetVehiclePedIsIn(a, false)
    c = PlayerId()
    d = GetEntityCoords(a)
    local g = GetPedInVehicleSeat(b, -1)
    e = g == a
end
_G["PlayerPedId"] = function()
    return a
end
function CORRUPT.getPlayerPed()
    return a
end
function CORRUPT.getPlayerVehicle()
    return b, e
end
function CORRUPT.getPlayerId()
    return c
end
function CORRUPT.getPlayerCoords()
    return d
end
Citizen.CreateThread(
    function()
        CORRUPT.createThreadOnTick(savePlayerInfo)
    end
)
