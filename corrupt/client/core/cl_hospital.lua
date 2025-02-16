local a = GetGameTimer() - 30000
local b = {
    ["city"] = vector3(309.04260253906, -592.22509765625, 42.284008026123),
    ["sandy"] = vector3(1833.0328369141, 3682.8110351563, 33.270057678223),
    ["paleto"] = vector3(-251.9546661377, 6334.146484375, 31.427177429199),
    ["london"] = vector3(355.45614624023, -1416.0190429688, 32.510429382324),
    ["mountzenah"] = vector3(-436.04296875, -326.27416992188, 33.910766601562),
    ["VIP"] = vector3(-2158.9055175781,5235.1123046875,18.765625)
}
Citizen.CreateThread(
    function()
        if true then
            local c = function(d)
                CORRUPT.drawNativeNotification("Press ~INPUT_PICKUP~ to receive medical attention.")
            end
            local e = function(d)
            end
            local f = function(d)
                if IsControlJustPressed(1, 51) then
                    local g = CORRUPT.getPlayerPed()
                    if not tvRP.isInComa() then
                        if CORRUPT.getPlayerVehicle() == 0 then
                            if tvRP.getPlayerCombatTimer() == 0 then
                                if GetGameTimer() > a + 30000 then
                                    CORRUPT.setHealth(200)
                                    tvRP.notify("~g~Healed, free of charge by the NHS.")
                                    a = GetGameTimer()
                                else
                                    tvRP.notify("~r~Healing cooldown, come back later.")
                                end
                            else
                                tvRP.notify("~r~You can not heal whilst in combat.")
                            end
                        else
                            tvRP.notify("~r~You can not heal whilst in a vehicle.")
                        end
                    else
                        tvRP.notify("~r~You are bleeding out, call a doctor ASAP!")
                    end
                end
            end
            for h, i in pairs(b) do
                tvRP.addMarker(i.x, i.y, i.z, 1.0, 1.0, 1.0, 0, 0, 255, 100, 50, 27, false, false, true)
                CORRUPT.createArea(h .. "_hospital", i, 1.5, 6, c, e, f, {})
            end
        end
    end
)
RegisterNetEvent("CORRUPT:setHealthClient",function(j)
    CORRUPT.setHealth(j)
end)

achealth = false
local j = 0
function CORRUPT.setHealth(k)
    if k ~= nil then
        if CORRUPT.isPedScriptGuidChanging() and k < 200 then
            return
        end
        local l = math.floor(k)
        j = l
        achealth = true
        SetEntityHealth(PlayerPedId(), l)
    end
end
function CORRUPT.getHealth()
    return GetEntityHealth(PlayerPedId())
end
Citizen.CreateThread(
    function()
        Wait(60000)
        while true do
            if not spawning then
                if CORRUPT.getHealth() > j then
                    if CORRUPT.getHealth() - 2 == j then
                        return
                    end
                    CORRUPT.setHealth(j)
                end
            end
            Wait(0)
        end
    end
)
