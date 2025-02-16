RegisterNetEvent('CORRUPT:sendSharedEmoteRequest')
AddEventHandler('CORRUPT:sendSharedEmoteRequest', function(playersrc, emote)
    local source = source
    TriggerClientEvent('CORRUPT:sendSharedEmoteRequest', playersrc, source, emote)
end)

RegisterNetEvent('CORRUPT:receiveSharedEmoteRequest')
AddEventHandler('CORRUPT:receiveSharedEmoteRequest', function(i, a)
    local source = source
    if a == -1 then 
        TriggerEvent("CORRUPT:AntiCheat", CORRUPT.getUserId(source), 11, CORRUPT.getPlayerName(source), source, "Triggering receiveSharedEmoteRequest")
    end
    TriggerClientEvent('CORRUPT:receiveSharedEmoteRequestSource', i)
    TriggerClientEvent('CORRUPT:receiveSharedEmoteRequest', source, a)
end)


local shavedPlayers = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(shavedPlayers) do
            if shavedPlayers[k] then
                if shavedPlayers[k].cooldown > 0 then
                    shavedPlayers[k].cooldown = shavedPlayers[k].cooldown - 1
                else
                    shavedPlayers[k] = nil
                end
            end
        end
    end
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = CORRUPT.getUserId(source)
        if first_spawn and shavedPlayers[user_id] then
            TriggerClientEvent('CORRUPT:setAsShaved', source, (shavedPlayers[user_id].cooldown*60*1000))
        end
    end)
end)

function CORRUPT.ShaveHead(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.getInventoryItemAmount(user_id, 'electric_shaver') >= 1 then
        CORRUPTclient.getNearestPlayer(source,{4},function(nplayer)
            if nplayer then
                CORRUPTclient.isPlayerSurrenderedNoProgressBar(nplayer,{},function(surrendering)
                    if surrendering then
                        CORRUPT.tryGetInventoryItem(user_id, 'electric_shaver', 1)
                        TriggerClientEvent('CORRUPT:startShavingPlayer', source, nplayer)
                        shavedPlayers[CORRUPT.getUserId(nplayer)] = {
                            cooldown = 30,
                        }
                    else
                        CORRUPT.notify(source,{'~r~This player is not on their knees.'})
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~No one nearby."})
            end
        end)
    end
end
