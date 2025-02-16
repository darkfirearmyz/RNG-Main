local a = GetGameTimer()
RegisterNetEvent(
    "CORRUPT:spawnNitroBMX",
    function()
        if not tvRP.isInComa() and not tvRP.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tvRP.notify("~g~Crafting a BMX")
                local b = CORRUPT.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                CORRUPT.spawnVehicle("bmx", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tvRP.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tvRP.notify("~r~Cannot craft a BMX right now.")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:spawnMoped",
    function()
        if not tvRP.isInComa() and not tvRP.isHandcuffed() and not insideDiamondCasino then
            if GetTimeDifference(GetGameTimer(), a) > 10000 then
                a = GetGameTimer()
                tvRP.notify("~g~Crafting a Moped")
                local b = CORRUPT.getPlayerPed()
                TaskStartScenarioInPlace(b, "WORLD_HUMAN_HAMMERING", 0, true)
                Wait(5000)
                ClearPedTasksImmediately(b)
                local c = GetEntityCoords(b)
                CORRUPT.spawnVehicle("faggio", c.x, c.y, c.z, GetEntityHeading(b), true, true, true)
            else
                tvRP.notify("~r~Nitro BMX cooldown, please wait.")
            end
        else
            tvRP.notify("~r~Cannot craft a Moped right now.")
        end
    end
)
