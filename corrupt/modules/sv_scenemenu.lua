local spikes = 0
local speedzones = 0

RegisterNetEvent("CORRUPT:placeSpike")
AddEventHandler("CORRUPT:placeSpike", function(heading, coords)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('CORRUPT:addSpike', -1, coords, heading)
    end
end)

RegisterNetEvent("CORRUPT:removeSpike")
AddEventHandler("CORRUPT:removeSpike", function(entity)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('CORRUPT:deleteSpike', -1, entity)
        TriggerClientEvent("CORRUPT:deletePropClient", -1, entity)
    end
end)

RegisterNetEvent("CORRUPT:requestSceneObjectDelete")
AddEventHandler("CORRUPT:requestSceneObjectDelete", function(prop)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent("CORRUPT:deletePropClient", -1, prop)
    end
end)

RegisterNetEvent("CORRUPT:createSpeedZone")
AddEventHandler("CORRUPT:createSpeedZone", function(coords, radius, speed)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
        speedzones = speedzones + 1
        TriggerClientEvent('CORRUPT:createSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

RegisterNetEvent("CORRUPT:deleteSpeedZone")
AddEventHandler("CORRUPT:deleteSpeedZone", function(speedzone)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('CORRUPT:deleteSpeedZone', -1, speedzones, coords, radius, speed)
    end
end)

