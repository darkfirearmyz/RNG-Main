RegisterCommand('craftbmx', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("CORRUPT:spawnNitroBMX", source)
    else
        if CORRUPT.checkForRole(user_id, '1150496514985173082') then
            TriggerClientEvent("CORRUPT:spawnNitroBMX", source)
        end
    end
end)

RegisterCommand('craftmoped', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    CORRUPTclient.isPlatClub(source, {}, function(isPlatClub)
        if isPlatClub then
            TriggerClientEvent("CORRUPT:spawnMoped", source)
        end
    end)
end)