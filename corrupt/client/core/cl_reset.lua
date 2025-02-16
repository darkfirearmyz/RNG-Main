local resetCooldown = 0
RegisterCommand("reset", function(q,r,s)
    local h = CORRUPT.getPlayerPed()
    local t = tvRP.getPlayerCombatTimer() > 0 or CORRUPT.isPlayerInRedZone() or GetRoomKeyFromEntity(CORRUPT.getPlayerPed()) ~= 0 or IsEntityInWater(h) or IsPedInAnyVehicle(h, false) or inOrganHeist or IsNuiFocused() or tvRP.isHandcuffed()
    if resetCooldown < GetGameTimer() then
        if t then
            tvRP.notifyPicture("CHAR_BLOCKED","CHAR_BLOCKED","You are unable to use this right now.","CORRUPT","Utilities",nil,nil)
        else
            local originalPosition = CORRUPT.getPlayerCoords()
            tvRP.teleport(3094.446, -4811.093, 15.26162)
            Wait(500)
            tvRP.teleport(originalPosition.x,originalPosition.y,originalPosition.z)
            resetCooldown = GetGameTimer() + 60000
        end
    else
        tvRP.notifyPicture("CHAR_BLOCKED","CHAR_BLOCKED","You must wait 60 seconds before using this again.","CORRUPT","Utilities",nil,nil)
    end
end)