local flaggedVehicles = {}

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if CORRUPT.hasPermission(user_id, 'police.armoury') then
            TriggerClientEvent('CORRUPT:setFlagVehicles', source, flaggedVehicles)
        end
    end
end)

RegisterServerEvent("CORRUPT:flagVehicleAnpr")
AddEventHandler("CORRUPT:flagVehicleAnpr", function(plate, reason)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        flaggedVehicles[plate] = reason
        TriggerClientEvent('CORRUPT:setFlagVehicles', -1, flaggedVehicles)
    end
end)