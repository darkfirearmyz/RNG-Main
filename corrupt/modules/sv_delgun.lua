netObjects = {}

RegisterServerEvent("CORRUPT:spawnVehicleCallback")
AddEventHandler('CORRUPT:spawnVehicleCallback', function(user_id, object)
    netObjects[object] = {source = CORRUPT.getUserSource(user_id), id = user_id, name = CORRUPT.getPlayerName(CORRUPT.getUserSource(user_id))}
end)



RegisterServerEvent("CORRUPT:delGunDelete")
AddEventHandler("CORRUPT:delGunDelete", function(object)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("CORRUPT:deletePropClient", -1, object)
        if netObjects[object] then
            TriggerClientEvent("CORRUPT:returnObjectDeleted", source, 'This object was created by ~b~'..netObjects[object].name..'~w~. Temp ID: ~b~'..netObjects[object].source..'~w~.\nPerm ID: ~b~'..netObjects[object].id..'~w~.')
        end
    end
end)

