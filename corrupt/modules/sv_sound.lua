local soundCode = math.random(143, 1000000)

RegisterServerEvent('CORRUPT:soundCodeServer', function()
    TriggerClientEvent('CORRUPT:soundCode', source, soundCode)
end)
RegisterServerEvent("CORRUPT:playNuiSound", function(sound, distance, soundEventCode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if soundCode == soundEventCode then
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent("CORRUPT:playClientNuiSound", -1, coords, sound, distance)
    else
        TriggerClientEvent("CORRUPT:playClientNuiSound", source, coords, sound, distance)
        Wait(2500)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger Sound Event')
    end
end)

RegisterCommand("tomss", function(source, args)
    local user_id = CORRUPT.getUserId(source)
    if user_id == 0 then
        local distance = 15
        if args[2] then
            distance = tonumber(args[2])
        end
        TriggerClientEvent("CORRUPT:playClientNuiSound", -1, GetEntityCoords(GetPlayerPed(CORRUPT.getUserSource(tonumber(args[1])))), 'scream', distance)
    end
end)