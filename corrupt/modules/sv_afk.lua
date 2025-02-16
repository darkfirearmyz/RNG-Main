function getPlayerFaction(user_id)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        return 'pd'
    elseif CORRUPT.hasPermission(user_id, 'nhs.menu') then
        return 'nhs'
    elseif CORRUPT.hasPermission(user_id, 'hmp.menu') then
        return 'hmp'
    elseif CORRUPT.hasPermission(user_id, 'lfb.onduty.permission') then
        return 'lfb'
    end
    return nil
end

RegisterServerEvent('CORRUPT:factionAfkAlert')
AddEventHandler('CORRUPT:factionAfkAlert', function(text)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        CORRUPT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'Corrupt AFK Logs', "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('CORRUPT:setNoLongerAFK')
AddEventHandler('CORRUPT:setNoLongerAFK', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if getPlayerFaction(user_id) ~= nil then
        CORRUPT.sendWebhook(getPlayerFaction(user_id)..'-afk', 'Corrupt AFK Logs', "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)

RegisterServerEvent('kick:AFK')
AddEventHandler('kick:AFK', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.hasPermission(user_id, 'group.add') then
        DropPlayer(source, 'You have been kicked for being AFK for too long.')
    end
end)