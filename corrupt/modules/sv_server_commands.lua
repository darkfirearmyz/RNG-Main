RegisterCommand('addgroup', function(source, args)
    if source ~= 0 then return end -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = table.concat(args, " ", 2) -- Concatenate args starting from index 2
        CORRUPT.addUserGroup(userid, group)
        print('Added Group: ' .. group .. ' to UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)


RegisterCommand('removegroup', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local group = args[2]
        CORRUPT.removeUserGroup(userid,group)
        print('Removed Group: ' .. group .. ' from UserID: ' .. userid)
    else 
        print('Incorrect usage: addgroup [permid] [group]')
    end
end)

RegisterCommand('ban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1]) and args[2] then
        local userid = tonumber(args[1])
        local hours = args[2]
        local reason = table.concat(args," ", 3)
        if reason then 
            CORRUPT.banConsole(userid,hours,reason)
        else 
            print('Incorrect usage: ban [permid] [hours] [reason]')
        end 
    else 
        print('Incorrect usage: ban [permid] [hours] [reason]')
    end
end)

RegisterCommand('unban', function(source, args)
    if source ~= 0 then return end; -- Stops anyone other than the console running it.
    if tonumber(args[1])  then
        local userid = tonumber(args[1])
        CORRUPT.setBanned(userid,false)
        print('Unbanned user: ' .. userid )
    else 
        print('Incorrect usage: unban [permid]')
    end
end)


RegisterCommand('cashtoall', function(source, args)
    if source ~= 0 then return end;
    if tonumber(args[1])  then
        local amount = tonumber(args[1])
        print('Giving £' .. getMoneyStringFormatted(amount) .. ' to all users')
        for k,v in pairs(CORRUPT.getUsers()) do
            CORRUPT.notify(v, {'~g~You have received £' .. getMoneyStringFormatted(amount) .. ' from the server'})
            CORRUPT.giveBankMoney(k, amount)
        end
    else 
        print('Incorrect usage: cashtoall [amount]')
    end
end)

function CORRUPT.CashToAll(amount)
    print("^1[CORRUPT] ^7Giving £" .. getMoneyStringFormatted(amount) .. " to all users.")
    for k,v in pairs(CORRUPT.getUsers()) do
        CORRUPT.notify(v, {'~g~You have received £' .. getMoneyStringFormatted(amount) .. ' from the server'})
        CORRUPT.giveBankMoney(k, amount)
    end
end

function CORRUPT.GunToAll(spawncode)
    local name 
    if spawncode == "WEAPON_NERFMOSIN" then
        name = "Nerf Mosin"
    elseif spawncode == "WEAPON_ANONMOUSSNIPER" then
        name = "Anonmous Sniper"
    end 

    print("^1[CORRUPT] ^7Giving " .. spawncode .. " to all users.")
    for k,v in pairs(CORRUPT.getUsers()) do
        CORRUPT.notify(v, {'~g~You have received a ' .. name .. ' from the server'})
        CORRUPTclient.GiveWeaponsToPlayer(v, {{[spawncode] = {ammo = 250}}, false})
    end
end

-- RegisterCommand('beta', function(source, args)
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     if not CORRUPT.hasGroup(user_id, "supporter") then 
--         CORRUPT.addUserGroup(user_id, "supporter")
--         CORRUPT.notify(source, {'~g~Thank you for participating in the beta ❤'})
--         CORRUPT.notify(source, {'~g~Enjoy Supporter!'})
--     end
-- end)

-- RegisterCommand('newbie', function(source, args)
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     local AlreadyClaimed = CORRUPT.hasGroup(user_id, 'AlreadyClaimed')
--     if not AlreadyClaimed then
--         CORRUPT.giveBankMoney(user_id, 2000000)
--         TriggerClientEvent('CORRUPT:smallAnnouncement', source, 'Welcome To CORRUPT', "You have received 2 Million because your a newbie, We appreciate your support!\n", 18, 10000)
--         CORRUPT.addUserGroup(user_id, 'AlreadyClaimed')
--     else 
--         CORRUPTclient.notify(source, {'~r~You Have Already Claimed this!'})   
--     end
-- end)

-- RegisterCommand('beta', function(source, args, rawCommand) 
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     if not CORRUPT.hasGroup(user_id, 'AlreadyClaimedBeta') then
--         CORRUPT.addUserGroup(user_id, "Supporter")
--         CORRUPT.addUserGroup(user_id, "Gang")
--         CORRUPT.addUserGroup(user_id, "AlreadyClaimedBeta")
--         CORRUPT.giveBankMoney(user_id, 5000000)

--         CORRUPTclient.notify(source, {'~o~Received Gang License'})
--         CORRUPTclient.notify(source, {'~o~Received Supporter'})
--         CORRUPTclient.notify(source, {'~o~Received £5000000'})

--         TriggerClientEvent('CORRUPT:ForceRefreshData', -1)
--         TriggerServerEvent("CORRUPT:refreshGaragePermissions")
--         TriggerClientEvent('CORRUPT:onClientSpawn', source)
        
--         -- TriggerClientEvent('CORRUPT:smallAnnouncement', source, 'CORRUPT', "You have now Claimed /beta ❤", 18, 10000)
--         Wait(100)
--     else
--         CORRUPTclient.notify(source, {'You have already claimed /beta!'})
--     end
-- end)

local cooldowns = {}
local cooldownTime = 60 --

RegisterCommand('mosin', function(source)
    local user_id = CORRUPT.getUserId(source)
    local currentTime = os.time()

    if cooldowns[user_id] and (currentTime - cooldowns[user_id]) < cooldownTime then
        local remainingTime = cooldownTime - (currentTime - cooldowns[user_id])
        TriggerClientEvent('chat:addMessage', source, { args = { "^1[ERROR]^0 You must wait " .. remainingTime .. " seconds before using this command again." } })
        return
    end

    if CORRUPTclient.GiveWeaponsToPlayer(user_id, 'WEAPON_NERFMOSIN') then
        TriggerClientEvent('chat:addMessage', source, { args = { "^1[ERROR]^0 You already have a Mosin!" } })
    else
        CORRUPTclient.GiveWeaponsToPlayer(user_id, { ['WEAPON_MOSIN'] = 30 })
        TriggerClientEvent('chat:addMessage', source, { args = { "^2[INFO]^0 You received a Nerf Mosin rifle with 30 rounds." } })

        cooldowns[user_id] = currentTime
    end
end, false)

RegisterCommand('cartoall', function(source, args)
    if source == 0 then
        if tostring(args[1]) then
            local car = tostring(args[1])
            for k, v in pairs(CORRUPT.getUsers()) do
                local plate = string.upper(generateUUID("plate", 5, "alphanumeric"))
                local locked = true -- You should define 'locked' here or retrieve it from somewhere
                MySQL.execute("CORRUPT/add_vehicle", {user_id = permid, vehicle = car, registration = uuid, locked = locked})
                print('Added Car To ' .. k .. ' With Plate: ' .. plate)
            end
        else
            print('Incorrect usage: cartoall [spawncode]')
        end
    end
end)

