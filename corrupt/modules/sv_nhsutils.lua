local bodyBags = {}

RegisterServerEvent("CORRUPT:requestBodyBag")
AddEventHandler('CORRUPT:requestBodyBag', function(playerToBodyBag)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:placeBodyBag', playerToBodyBag)
    end
end)

RegisterServerEvent("CORRUPT:removeBodybag")
AddEventHandler('CORRUPT:removeBodybag', function(bodybagObject)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent('CORRUPT:removeIfOwned', -1, NetworkGetEntityFromNetworkId(bodybagObject))
end)

RegisterServerEvent("CORRUPT:playNhsSound")
AddEventHandler('CORRUPT:playNhsSound', function(sound)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        TriggerClientEvent('CORRUPT:clientPlayNhsSound', -1, GetEntityCoords(GetPlayerPed(source)), sound)
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger Play NHS Sound')
    end
end)


-- a = coma
-- c = userid
-- b = permid
-- 4th ready to revive
-- name

local lifePaksConnected = {}

RegisterServerEvent("CORRUPT:attachLifepakServer")
AddEventHandler('CORRUPT:attachLifepakServer', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        CORRUPTclient.getNearestPlayer(source, {3}, function(nplayer)
            local nuser_id = CORRUPT.getUserId(nplayer)
            if nuser_id ~= nil then
                CORRUPTclient.isInComa(nplayer, {}, function(in_coma)
                    TriggerClientEvent('CORRUPT:attachLifepak', source, in_coma, nuser_id, nplayer, CORRUPT.getPlayerName(nplayer))
                    lifePaksConnected[user_id] = {permid = nuser_id} 
                end)
            else
                CORRUPT.notify(source, {"There is no player nearby"})
            end
        end)
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger Attack Lifepak')
    end
end)


RegisterServerEvent("CORRUPT:finishRevive")
AddEventHandler('CORRUPT:finishRevive', function(perm_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then 
        for k,v in pairs(lifePaksConnected) do
            if k == user_id and v.permid == perm_id then
                local player_source = CORRUPT.getUserSource(perm_id)
                TriggerClientEvent('CORRUPT:returnRevive', source)
                CORRUPT.giveBankMoney(user_id, 5000)
                CORRUPT.notify(source, {"~g~You have been paid £5,000 for reviving this person."})
                lifePaksConnected[k] = nil
                Wait(15000)
                TriggerClientEvent("Corrupt:Revive", player_source)
            end
        end
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger Finish Revive')
    end
end)


RegisterServerEvent("CORRUPT:nhsRevive") -- nhs radial revive
AddEventHandler('CORRUPT:nhsRevive', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'nhs.menu') then
        CORRUPTclient.isInComa(playersrc, {}, function(in_coma)
            if in_coma then
                TriggerClientEvent('CORRUPT:beginRevive', source, in_coma, CORRUPT.getUserId(playersrc), playersrc, CORRUPT.getPlayerName(playersrc))
                lifePaksConnected[user_id] = {permid = CORRUPT.getUserId(playersrc)} 
            end
        end)
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger NHS Revive')
    end
end)

local playersInCPR = {}

RegisterServerEvent("CORRUPT:attemptCPR")
AddEventHandler('CORRUPT:attemptCPR', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)

    CORRUPTclient.getNearestPlayers(source, {15}, function(nplayers)
        local targetPlayer = nplayers[playersrc]

        if targetPlayer then
            local targetPed = GetPlayerPed(playersrc)
            local targetHealth = GetEntityHealth(targetPed)

            if targetHealth > 102 then
                CORRUPT.notify(source, {"This person is already healthy."})
            else
                playersInCPR[user_id] = true
                TriggerClientEvent('CORRUPT:attemptCPR', source)

                Citizen.Wait(15000) -- Wait for 15 seconds

                if playersInCPR[user_id] then
                    local cprChance = math.random(1, 10)

                    if cprChance == 1 then
                        TriggerClientEvent("Corrupt:Revive", playersrc)
                        CORRUPT.notify(playersrc, {"~b~Your life has been saved."})
                        CORRUPT.notify(source, {"~b~You have saved this person's life."})
                    else
                        CORRUPT.notify(source, {'~r~Failed to perform CPR.'})
                    end

                    playersInCPR[user_id] = nil
                    CORRUPT.notify(source, {"~r~CPR has been canceled."})
                    TriggerClientEvent('CORRUPT:cancelCPRAttempt', source)
                end
            end
        else
            CORRUPT.notify(source, {"Player not found."})
        end
    end)
end)


RegisterServerEvent("CORRUPT:cancelCPRAttempt")
AddEventHandler('CORRUPT:cancelCPRAttempt', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if playersInCPR[user_id] then
        playersInCPR[user_id] = nil
        CORRUPT.notify(source, {"~r~CPR has been canceled."})
        TriggerClientEvent('CORRUPT:cancelCPRAttempt', source)
    end
end)

RegisterServerEvent("CORRUPT:syncWheelchairPosition")
AddEventHandler('CORRUPT:syncWheelchairPosition', function(netid, coords, heading)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    entity = NetworkGetEntityFromNetworkId(netid)
    SetEntityCoords(entity, coords.x, coords.y, coords.z)
    SetEntityHeading(entity, heading)
end)

RegisterServerEvent("CORRUPT:wheelchairAttachPlayer")
AddEventHandler('CORRUPT:wheelchairAttachPlayer', function(entity)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent('CORRUPT:wheelchairAttachPlayer', -1, entity, source)
end)