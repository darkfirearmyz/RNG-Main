RegisterCommand("a", function(source,args, rawCommand)
    if #args <= 0 then return end
	local name = CORRUPT.getPlayerName(source)
    local message = table.concat(args, " ")
    local user_id = CORRUPT.getUserId(source)

    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        CORRUPT.sendWebhook('staff', "Corrupt Chat Logs", "```"..message.."```".."\n> Admin Name: **"..name.."**\n> Admin PermID: **"..user_id.."**\n> Admin TempID: **"..source.."**")
        for k, v in pairs(CORRUPT.getUsers({})) do
            if CORRUPT.hasPermission(k, 'admin.tickets') then
                TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. name..": " , { 128, 128, 128 }, message, "ooc")
            end
        end
    end
end)
RegisterServerEvent("CORRUPT:PoliceChat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = CORRUPT.getUserId(source)   
    local message = args
    if CORRUPT.hasPermission(user_id, "police.armoury") then
        local callsign = ""
        if getCallsign('Police', source, user_id, 'Police') then
            callsign = "["..getCallsign('Police', source, user_id, 'Police').."]"
        end
        local playerName =  "^4Police Chat | "..callsign.." "..CORRUPT.getPlayerName(source)..": "
        for k, v in pairs(CORRUPT.getUsers({})) do
            if CORRUPT.hasPermission(k, 'police.armoury') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "Police")
            end
        end
    end
end)

RegisterCommand("p", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("CORRUPT:PoliceChat", source, message)
end)
RegisterServerEvent("CORRUPT:Nchat", function(source, args, rawCommand)
    if #args <= 0 then return end
    local source = source
    local user_id = CORRUPT.getUserId(source)   
    local message = args
    if CORRUPT.hasPermission(user_id, "nhs.menu") then
        local playerName =  "^2NHS Chat | "..CORRUPT.getPlayerName(source)..": "
        for k, v in pairs(CORRUPT.getUsers({})) do
            if CORRUPT.hasPermission(k, 'nhs.menu') then
                TriggerClientEvent('chatMessage', v, playerName , { 128, 128, 128 }, message, "ooc", "NHS")
            end
        end
    end
end)
RegisterCommand("n", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("CORRUPT:Nchat", source, message)
end)

RegisterCommand("g", function(source, args)
    local message = table.concat(args, " ")
    TriggerEvent("CORRUPT:GangChat", source, message)
end)
RegisterServerEvent("CORRUPT:GangChat", function(source, message)
    local source = source
    local user_id = CORRUPT.getUserId(source)   
    local msg = message
    if CORRUPT.hasGroup(user_id,"Gang") then
        local gang = exports['corrupt']:executeSync('SELECT gangname FROM corrupt_user_gangs WHERE user_id = @user_id', {user_id = user_id})[1].gangname
        if gang then
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {gangname = gang},function(ganginfo)
                for A,B in pairs(ganginfo) do
                    local playersource = CORRUPT.getUserSource(B.user_id)
                    if playersource then
                        TriggerClientEvent('chatMessage',playersource,"^2[Gang Chat] " .. CORRUPT.getPlayerName(source)..": ",{ 128, 128, 128 },msg,"ooc", "Gang")
                    end
                end
                CORRUPT.sendWebhook('gang', "Corrupt Chat Logs", "```"..msg.."```".."\n> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
            end)
        end
    end
end)

RegisterCommand('testitem', function(source,args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Founder') then
        if tonumber(args[2]) then
            CORRUPT.giveInventoryItem(user_id, args[1], tonumber(args[2]), true)
        else
            CORRUPT.giveInventoryItem(user_id, args[1], 1, true)
        end
    end
end)