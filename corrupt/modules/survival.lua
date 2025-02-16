local cfg = module("cfg/survival")
local lang = CORRUPT.lang


-- handlers

-- init values
AddEventHandler("CORRUPT:playerJoin", function(user_id, source, name, last_login)
    local data = CORRUPT.getUserDataTable(user_id)
end)


---- revive
local revive_seq = {{"amb@medic@standing@kneel@enter", "enter", 1}, {"amb@medic@standing@kneel@idle_a", "idle_a", 1},
                    {"amb@medic@standing@kneel@exit", "exit", 1}}

local choice_revive = {function(player, choice)
    local user_id = CORRUPT.getUserId(player)
    if user_id ~= nil then
        CORRUPTclient.getNearestPlayer(player, {10}, function(nplayer)
            local nuser_id = CORRUPT.getUserId(nplayer)
            if nuser_id ~= nil then
                CORRUPTclient.isInComa(nplayer, {}, function(in_coma)
                    if in_coma then
                        if CORRUPT.tryGetInventoryItem(user_id, "medkit", 1, true) then
                            CORRUPTclient.playAnim(player, {false, revive_seq, false}) -- anim
                            SetTimeout(15000, function()
                                CORRUPTclient.varyHealth(nplayer, {50}) -- heal 50
                            end)
                        end
                    else
                        tvRP.notify(player, {lang.emergency.menu.revive.not_in_coma()})
                    end
                end)
            else
                tvRP.notify(player, {lang.common.no_player_near()})
            end
        end)
    end
end, lang.emergency.menu.revive.description()}

RegisterNetEvent('CORRUPT:SearchForPlayer')
AddEventHandler('CORRUPT:SearchForPlayer', function()
    TriggerClientEvent('CORRUPT:ReceiveSearch', -1, source)
end)


