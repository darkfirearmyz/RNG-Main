local function a()
    local b = CORRUPT.getPlayerPed()
    if GetEntityHealth(b) > 102 then
        local c, d = tvRP.getNearestOwnedVehicle(8)
        if d ~= nil then
            if c then
                tvRP.vc_toggleLock(d)
                CORRUPT.playSound("HUD_MINI_GAME_SOUNDSET", "5_SEC_WARNING")
                Citizen.Wait(1000)
            else
                Citizen.Wait(1000)
            end
        else
            tvRP.notify("~r~No owned vehicle found nearby to lock/unlock")
        end
    else
        tvRP.notify("~r~You may not lock/unlock your vehicle whilst dead.")
    end
end
RegisterCommand("lockvehicle", a, false)
RegisterKeyMapping("lockvehicle", "Lock Vehicle", "KEYBOARD", "COMMA")
AddEventHandler(
    "CORRUPT:lockNearestVehicle",
    function()
        a()
    end
)
