RegisterCommand('cinematicmenu', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Cinematic') then
        TriggerClientEvent('CORRUPT:openCinematicMenu', source)
    end
end)