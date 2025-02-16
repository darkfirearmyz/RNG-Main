RegisterServerEvent("CORRUPT:stretcherAttachPlayer")
AddEventHandler('CORRUPT:stretcherAttachPlayer', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:stretcherAttachPlayer', source, playersrc)
    end
end)

RegisterServerEvent("CORRUPT:toggleAmbulanceDoors")
AddEventHandler('CORRUPT:toggleAmbulanceDoors', function(stretcherNetid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:toggleAmbulanceDoorStatus', -1, stretcherNetid)
    end
end)

RegisterServerEvent("CORRUPT:updateHasStretcherInsideDecor")
AddEventHandler('CORRUPT:updateHasStretcherInsideDecor', function(stretcherNetid, status)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:setHasStretcherInsideDecor', -1, stretcherNetid, status)
    end
end)

RegisterServerEvent("CORRUPT:updateStretcherLocation")
AddEventHandler('CORRUPT:updateStretcherLocation', function(a,b)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:CORRUPT:setStretcherInside', -1, a,b)
    end
end)

RegisterServerEvent("CORRUPT:removeStretcher")
AddEventHandler('CORRUPT:removeStretcher', function(stretcher)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:deletePropClient', -1, stretcher)
    end
end)

RegisterServerEvent("CORRUPT:forcePlayerOnToStretcher")
AddEventHandler('CORRUPT:forcePlayerOnToStretcher', function(id, stretcher)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:forcePlayerOnToStretcher', id, stretcher)
    end
end)