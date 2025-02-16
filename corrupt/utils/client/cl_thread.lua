local a = {}
Citizen.CreateThread(
    function()
        while true do
            local b = {}
            b.playerPed = CORRUPT.getPlayerPed()
            b.playerCoords = CORRUPT.getPlayerCoords()
            b.playerId = CORRUPT.getPlayerId()
            b.vehicle = CORRUPT.getPlayerVehicle()
            b.weapon = GetSelectedPedWeapon(b.playerPed)
            for c = 1, #a do
                local d = a[c]
                local e, f = pcall(d, b)
                if not e then
                    print(f)
                end
            end
            Wait(0)
        end
    end
)
function CORRUPT.createThreadOnTick(d)
    a[#a + 1] = d
end
