local tickets = {}
local callID = 0
local cooldown = {}
local permid = nil

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(60000)
        for k,v in pairs(cooldown) do
            if cooldown[k].time > 0 then
                cooldown[k].time = cooldown[k].time - 1
            end
        end
    end
end)

RegisterCommand("calladmin", function(source)
    local user_id = CORRUPT.getUserId(source)
    local user_source = CORRUPT.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            CORRUPT.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    CORRUPT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = CORRUPT.getPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(CORRUPT.getUsers({})) do
                    TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, CORRUPT.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                CORRUPT.notify(user_source,{"~b~Your request has been sent."})
            else
                CORRUPT.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            CORRUPT.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)
RegisterCommand("calladmin", function(source)
    local user_id = CORRUPT.getUserId(source)
    local user_source = CORRUPT.getUserSource(user_id)
    for k,v in pairs(cooldown) do
        if k == user_id and v.time > 0 then
            CORRUPT.notify(user_source,{"~r~You have already called an admin, please wait 5 minutes before calling again."})
            return
        end
    end
    CORRUPT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            if #reason >= 5 then
                callID = callID + 1
                tickets[callID] = {
                    name = CORRUPT.getPlayerName(user_source),
                    permID = user_id,
                    tempID = user_source,
                    reason = reason,
                    type = 'admin',
                }
                cooldown[user_id] = {time = 5}
                for k, v in pairs(CORRUPT.getUsers({})) do
                    TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, CORRUPT.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'admin')
                end
                CORRUPT.notify(user_source,{"~b~Your request has been sent."})
            else
                CORRUPT.notify(user_source,{"~r~Please enter a minimum of 5 characters."})
            end
        else
            CORRUPT.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("999", function(source)
    local user_id = CORRUPT.getUserId(source)
    local user_source = CORRUPT.getUserSource(user_id)
    CORRUPT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = CORRUPT.getPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'met'
            }
            for k, v in pairs(CORRUPT.getUsers({})) do
                TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, CORRUPT.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'met')
            end
            CORRUPT.notify(user_source,{"~b~Sent Police Call."})
        else
            CORRUPT.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

RegisterCommand("111", function(source)
    local user_id = CORRUPT.getUserId(source)
    local user_source = CORRUPT.getUserSource(user_id)
    CORRUPT.prompt(user_source, "Please enter call reason: ", "", function(player, reason)
        if reason ~= "" then
            callID = callID + 1
            tickets[callID] = {
                name = CORRUPT.getPlayerName(user_source),
                permID = user_id,
                tempID = user_source,
                reason = reason,
                type = 'nhs'
            }
            for k, v in pairs(CORRUPT.getUsers({})) do
                TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, CORRUPT.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
            end
            CORRUPT.notify(user_source,{"~g~Sent NHS Call."})
        else
            CORRUPT.notify(user_source,{"~r~Please enter a valid reason."})
        end
    end)
end)

local savedPositions = {}
RegisterCommand("return", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerEvent('CORRUPT:Return', source)
    end
end)
local adminFeedback = {} 
AddEventHandler("CORRUPT:Return", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        local v = adminFeedback[user_id]
        if savedPositions[user_id] then
            CORRUPT.setBucket(source, savedPositions[user_id].bucket)
            CORRUPTclient.teleport(source, {table.unpack(savedPositions[user_id].coords)})
            CORRUPT.notify(source, {'~g~Returned to position.'})
            savedPositions[user_id] = nil
        else
            CORRUPT.notify(source, {"~r~Unable to find last location."})
        end
        TriggerClientEvent('CORRUPT:sendTicketInfo', source)
        TriggerClientEvent("CORRUPT:OMioDioMode", source, false)
        SetTimeout(1000, function() 
            CORRUPTclient.setPlayerCombatTimer(source, {0}) 
        end)
    end
end)

RegisterNetEvent("CORRUPT:TakeTicket")
AddEventHandler("CORRUPT:TakeTicket", function(ticketID)
    local user_id = CORRUPT.getUserId(source)
    local admin_source = CORRUPT.getUserSource(user_id)
    if tickets[ticketID] ~= nil then
        for k, v in pairs(tickets) do
            if ticketID == k then
                if tickets[ticketID].type == 'admin' and CORRUPT.hasPermission(user_id, "admin.tickets") then
                    if CORRUPT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            local tempID = v.tempID
                            local adminbucket = GetPlayerRoutingBucket(admin_source)
                            local playerbucket = GetPlayerRoutingBucket(v.tempID)
                            savedPositions[user_id] = {bucket = adminbucket, coords = GetEntityCoords(GetPlayerPed(admin_source))}
                            if adminbucket ~= playerbucket then
                                CORRUPT.setBucket(admin_source, playerbucket)
                                CORRUPT.notify(admin_source, {'~g~Player was in another bucket, you have been set into their bucket.'})
                            end
                            local coords = GetEntityCoords(GetPlayerPed(v.tempID))
                            adminFeedback[user_id] = {playersource = tempID, ticketID = ticketID}
                            local tickettext = v.name.." - "..v.permID
                            TriggerClientEvent('CORRUPT:sendTicketInfo', admin_source, v.permID, v.name, v.reason, ticketID)
                            local ticketPay = 0
                            if os.date('%A') == 'Saturday' or os.date('%A') == 'Sunday' then
                                ticketPay = 30000
                            else
                                ticketPay = 20000
                            end
                            exports['corrupt']:execute("SELECT * FROM `corrupt_staff_tickets` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                if result ~= nil then 
                                    for k,v in pairs(result) do
                                        if v.user_id == user_id then
                                            exports['corrupt']:execute("UPDATE corrupt_staff_tickets SET ticket_count = @ticket_count, username = @username WHERE user_id = @user_id", {user_id = user_id, ticket_count = v.ticket_count + 1, username = CORRUPT.getPlayerName(admin_source)}, function() end)
                                            return
                                        end
                                    end
                                    exports['corrupt']:execute("INSERT INTO corrupt_staff_tickets (`user_id`, `ticket_count`, `username`) VALUES (@user_id, @ticket_count, @username);", {user_id = user_id, ticket_count = 1, username = CORRUPT.getPlayerName(admin_source)}, function() end) 
                                end
                            end)
                            CORRUPT.giveBankMoney(user_id, ticketPay)
                            CORRUPT.notify(admin_source,{"~g~£"..getMoneyStringFormatted(ticketPay).." earned for taking a ticket."})
                            CORRUPT.notify(v.tempID,{"~g~An admin has taken your ticket."})
                            TriggerClientEvent('CORRUPT:smallAnnouncement', v.tempID, 'ticket accepted', "Your admin ticket has been accepted by "..CORRUPT.getPlayerName(admin_source), 33, 10000)
                            CORRUPT.sendWebhook('ticket-logs',"Corrupt Ticket Logs", "> Admin Name: **"..CORRUPT.getPlayerName(admin_source).."**\n> Admin TempID: **"..admin_source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..v.name.."**\n> Player PermID: **"..v.permID.."**\n> Player TempID: **"..v.tempID.."**\n> Reason: **"..v.reason.."**")
                            CORRUPTclient.teleport(admin_source, {table.unpack(coords)})
                            TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                            tickets[ticketID] = nil
                        else
                            CORRUPT.notify(admin_source,{"~r~You can't take your own ticket!"})
                        end
                    else
                        CORRUPT.notify(admin_source,{"You cannot take a ticket from an offline player."})
                        TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'met' and CORRUPT.hasPermission(user_id, "police.armoury") then
                    if CORRUPT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            if v.tempID ~= nil then
                                CORRUPT.notify(v.tempID,{"~b~Your MET Police call has been accepted!"})
                            end
                            tickets[ticketID] = nil
                            TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                        else
                            CORRUPT.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                    end
                elseif tickets[ticketID].type == 'nhs' and CORRUPT.hasPermission(user_id, "nhs.menu") then
                    if CORRUPT.getUserSource(v.permID) ~= nil then
                        if user_id ~= v.permID then
                            CORRUPT.notify(v.tempID,{"~g~Your NHS call has been accepted!"})
                            tickets[ticketID] = nil
                            TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                        else
                            CORRUPT.notify(admin_source,{"~r~You can't take your own call!"})
                        end
                    else
                        TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, ticketID)
                    end
                end
            end
        end
    end         
end)

AddEventHandler("CORRUPT:PDRobberyCall", function(source, store, position)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    callID = callID + 1
    tickets[callID] = {
        name = 'Store Robbery',
        permID = 999,
        tempID = nil,
        reason = 'Robbery in progress at '..store,
        type = 'met'
    }
    for k, v in pairs(CORRUPT.getUsers({})) do
        TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, 'Store Robbery', 999, position, 'Robbery in progress at '..store, 'met')
    end
end)

RegisterNetEvent("CORRUPT:NHSComaCall")
AddEventHandler("CORRUPT:NHSComaCall", function()
    local user_id = CORRUPT.getUserId(source)
    local user_source = CORRUPT.getUserSource(user_id)
    if CORRUPT.getUsersByPermission("nhs.menu") == nil then
        CORRUPT.notify(user_source,{"~r~There are no NHS on duty."})
        return
    end
    CORRUPT.notify(user_source,{"~g~NHS have been notified."})
    callID = callID + 1
    tickets[callID] = {
        name = CORRUPT.getPlayerName(user_source),
        permID = user_id,
        tempID = user_source,
        reason = "Immediate Attention",
        type = 'nhs'
    }
    for k, v in pairs(CORRUPT.getUsers({})) do
        TriggerClientEvent("CORRUPT:addEmergencyCall", v, callID, CORRUPT.getPlayerName(user_source), user_id, GetEntityCoords(GetPlayerPed(user_source)), reason, 'nhs')
    end
end)

AddEventHandler("playerDropped",function(reason)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        local missedTicket = false
        for k, v in pairs(tickets) do
            if v.permID == user_id and v.type == 'admin' then
                tickets[k] = nil
                TriggerClientEvent("CORRUPT:removeEmergencyCall", -1, k)
                missedTicket = true
            end
        end
        if missedTicket then
            local discord_id = exports['corrupt']:executeSync("SELECT discord_id FROM `corrupt_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
            local message = "Hey, sorry we couldn't get to your admin ticket in time. If you're facing a game issue or if you're reporting a player rule break, you can do so in the support discord https://discord.gg/sRQFnBAAmu\n\nWe appreciate your patience."
            exports['corrupt']:dmUserText(source, {discord_id, message})
        end
    end
end)