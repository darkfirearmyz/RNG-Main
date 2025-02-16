RegisterCommand('k9', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('CORRUPT:policeDogMenu', source)
    end
end)

RegisterCommand('k9attack', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('CORRUPT:policeDogAttack', source)
    end
end)

RegisterNetEvent("CORRUPT:serverDogAttack")
AddEventHandler("CORRUPT:serverDogAttack", function(player)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'K9 Trained') then
        TriggerClientEvent('CORRUPT:sendClientRagdoll', player)
    end
end)

RegisterNetEvent("CORRUPT:policeDogSniffPlayer")
AddEventHandler("CORRUPT:policeDogSniffPlayer", function(playerSrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'K9 Trained') then
       -- check for drugs
        local player_id = CORRUPT.getUserId(playerSrc)
        local cdata = CORRUPT.getUserDataTable(player_id)
        for a,b in pairs(cdata.inventory) do
            for c,d in pairs(seizeDrugs) do
                if a == c then
                    TriggerClientEvent('CORRUPT:policeDogIndicate', source, playerSrc)
                end
            end
        end
    end
end)

RegisterNetEvent("CORRUPT:performDogLog")
AddEventHandler("CORRUPT:performDogLog", function(text)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'K9 Trained') then
        CORRUPT.sendWebhook('police-k9', 'Corrupt Police Dog Logs',"> Officer Name: **"..CORRUPT.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Info: **"..text.."**")
    end
end)