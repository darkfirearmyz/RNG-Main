MySQL.createCommand("CORRUPT/add_jail_stats","UPDATE corrupt_fine_hours SET total_player_fined = (total_player_fined+1) WHERE user_id = @user_id")

RegisterServerEvent('CORRUPT:checkForPolicewhitelist')
AddEventHandler('CORRUPT:checkForPolicewhitelist', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        if CORRUPT.hasPermission(user_id, 'police.announce') then
            TriggerClientEvent('CORRUPT:openPNC', source, true, {}, {})
        else
            TriggerClientEvent('CORRUPT:openPNC', source, false, {}, {})
        end
    end
end)

RegisterServerEvent('CORRUPT:searchPerson')
AddEventHandler('CORRUPT:searchPerson', function(firstname, lastname)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_identities WHERE firstname = @firstname AND name = @lastname", {firstname = firstname, lastname = lastname}, function(result) 
            if result ~= nil then
                local returnedUsers = {}
                for k,v in pairs(result) do
                    local user_id = result[k].user_id
                    local firstname = result[k].firstname
                    local lastname = result[k].name
                    local age = result[k].age
                    local phone = result[k].phone
                    local data = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    local licence = data.licence
                    local points = data.points
                    local ownedVehicles = exports['corrupt']:executeSync("SELECT * FROM corrupt_user_vehicles WHERE user_id = @user_id", {user_id = user_id})
                    local actualVehicles = {}
                    for a,b in pairs(ownedVehicles) do 
                        table.insert(actualVehicles, b.vehicle)
                    end
                    local ownedProperties = exports['corrupt']:executeSync("SELECT * FROM corrupt_user_homes WHERE user_id = @user_id", {user_id = user_id})
                    local actualHouses = {}
                    for a,b in pairs(ownedProperties) do 
                        table.insert(actualHouses, b.home)
                    end
                    table.insert(returnedUsers, {user_id = user_id, firstname = firstname, lastname = lastname, age = age, phone = phone, licence = licence, points = points, vehicles = actualVehicles, playerhome = actualHouses, warrants = {}, warning_markers = {}})
                end
                if next(returnedUsers) then
                    TriggerClientEvent('CORRUPT:sendSearcheduser', source, returnedUsers)
                else
                    TriggerClientEvent('CORRUPT:noPersonsFound', source)
                end
            end
        end)
    end
end)

RegisterServerEvent('CORRUPT:finePlayer')
AddEventHandler('CORRUPT:finePlayer', function(id, charges, amount, notes)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local corruptuntNum = tonumber(amount)
    
    if corruptuntNum > 250000 then
        corruptuntNum = 250000
    end
    
    if next(charges) then
        local chargesList = ""
        for k, v in pairs(charges) do
            chargesList = chargesList .. "\n> - **" .. v.fine .. "**"
        end
        
        if CORRUPT.hasPermission(user_id, 'police.armoury') then
            if id == user_id then
                TriggerClientEvent('CORRUPT:verifyFineSent', source, false, "Can't fine yourself!")
                return
            end
            
            if CORRUPT.tryBankPayment(id, corruptuntNum) then
                local officerReward = math.floor(corruptuntNum * 0.1)
                CORRUPT.giveBankMoney(user_id, officerReward)
                CORRUPT.notify(CORRUPT.getUserSource(id), {'You have been fined £' .. getMoneyStringFormatted(corruptuntNum) .. '.'})
                CORRUPT.notify(source, {'~g~You have received £' .. getMoneyStringFormatted(officerReward) .. ' for fining ' .. CORRUPT.getPlayerName(CORRUPT.getUserSource(id)) .. '.'})
                CORRUPT.AddStats("amount_fined", user_id, corruptuntNum)
                TriggerEvent('CORRUPT:addToCommunityPot', corruptuntNum)
                TriggerClientEvent('CORRUPT:verifyFineSent', source, true)
                
                local criminalName = CORRUPT.getPlayerName(CORRUPT.getUserSource(id))
                local criminalPermID = id
                local criminalTempID = CORRUPT.getUserSource(id)
                local formattedAmount = '£' .. getMoneyStringFormatted(corruptuntNum)
                
                exports['corrupt']:execute("SELECT * FROM `corrupt_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.user_id == user_id then
                                exports['corrupt']:execute("UPDATE corrupt_police_hours SET total_players_fined = @total_players_fined WHERE user_id = @user_id", {user_id = user_id, total_players_fined = v.total_players_fined + 1}, function() end)
                                return
                            end
                        end
                        exports['corrupt']:execute("INSERT INTO corrupt_police_hours (`user_id`, `total_players_fined`, `username`) VALUES (@user_id, @total_players_fined, @username);", {user_id = user_id, total_players_fined = 1}, function() end) 
                    end
                end)
                CORRUPT.sendWebhook('fine-player', 'Corrupt Fine Logs', "> Officer Name: **" .. CORRUPT.getPlayerName(source) .. "**\n> Officer TempID: **" .. source .. "**\n> Officer PermID: **" .. user_id .. "**\n> Criminal Name: **" .. criminalName .. "**\n> Criminal PermID: **" .. criminalPermID .. "**\n> Criminal TempID: **" .. criminalTempID .. "**\n> Amount: **" .. formattedAmount .. "**\n> Charges: " .. chargesList)
            else
                TriggerClientEvent('CORRUPT:verifyFineSent', source, false, 'The player does not have enough money.')
            end
        end
    end
end)



RegisterServerEvent('CORRUPT:addPoints')
AddEventHandler('CORRUPT:addPoints', function(charges, id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        local totalPoints = 0 
        for i, v in pairs(charges) do
            local point = v.points 
            local reason = v.name
            totalPoints = totalPoints + point 
        end
        if totalPoints > 12 then
            totalPoints = 12
        end
        exports['corrupt']:execute("UPDATE corrupt_dvsa SET points = points + @newpoints WHERE user_id = @user_id", {user_id = id, newpoints = totalPoints})
        exports['corrupt']:execute('SELECT * FROM corrupt_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(licenceInfo)
            local licenceType = licenceInfo[1].licence
            local userPoints = tonumber(licenceInfo[1].points)
            if (licenceType == "active" or licenceType == "full") and userPoints > 12 then
                CORRUPT.notify(CORRUPT.getUserSource(id), {'~r~You have received '..totalPoints..' on your licence. You now have '..userPoints..'/12 points. Your licence has been suspended.'})
                exports['corrupt']:execute("UPDATE corrupt_dvsa SET licence = 'banned' WHERE user_id = @user_id", {user_id = id})
                Wait(100)
                dvsaUpdate(user_id)
            else
                CORRUPT.notify(CORRUPT.getUserSource(id), {'~r~You have received '..totalPoints..' on your licence. You now have '..userPoints..'/12 points.'})
            end
            if userPoints > 12 then
                exports['corrupt']:execute("UPDATE corrupt_dvsa SET points = @points WHERE user_id = @user_id", {user_id = id, points = 12})
            end
        end)
    end
end)


