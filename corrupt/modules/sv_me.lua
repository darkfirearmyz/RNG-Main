RegisterCommand("me", function(source, args)
    local text = table.concat(args, " ")
    TriggerClientEvent('CORRUPT:sendLocalChat', -1, source, CORRUPT.getPlayerName(source), text)
end)