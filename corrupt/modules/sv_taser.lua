RegisterServerEvent('CORRUPT:playTaserSound')
AddEventHandler('CORRUPT:playTaserSound', function(coords, sound)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
        TriggerClientEvent('playTaserSoundClient', -1, coords, sound)
    end
end)

RegisterServerEvent('CORRUPT:reactivatePed')
AddEventHandler('CORRUPT:reactivatePed', function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('CORRUPT:receiveActivation', id)
      TriggerClientEvent('TriggerTazer', id)
    end
end)

RegisterServerEvent('CORRUPT:arcTaser')
AddEventHandler('CORRUPT:arcTaser', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
      CORRUPTclient.getNearestPlayer(source, {3}, function(nplayer)
        local nuser_id = CORRUPT.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('CORRUPT:receiveBarbs', nplayer, source)
            TriggerClientEvent('TriggerTazer', id)
        end
      end)
    end
end)

RegisterServerEvent('CORRUPT:barbsNoLongerServer')
AddEventHandler('CORRUPT:barbsNoLongerServer', function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('CORRUPT:barbsNoLonger', id)
    end
end)

RegisterServerEvent('CORRUPT:barbsRippedOutServer')
AddEventHandler('CORRUPT:barbsRippedOutServer', function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent('CORRUPT:barbsRippedOut', id)
end)

RegisterCommand('rt', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('CORRUPT:reloadTaser', source)
  end
end)