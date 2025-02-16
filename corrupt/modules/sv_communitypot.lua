RegisterServerEvent("CORRUPT:getCommunityPotAmount")
AddEventHandler("CORRUPT:getCommunityPotAmount", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute("SELECT value FROM corrupt_community_pot", function(potbalance)
        if potbalance[1] then
            TriggerClientEvent('CORRUPT:gotCommunityPotAmount', source, parseInt(potbalance[1].value))
        else
            print("ERROR: No value for corrupt_community_pot")
        end
    end)    
end)

RegisterServerEvent("CORRUPT:tryDepositCommunityPot")
AddEventHandler("CORRUPT:tryDepositCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['corrupt']:execute("SELECT value FROM corrupt_community_pot", function(potbalance)
            if CORRUPT.tryFullPayment(user_id,amount) then
                local newpotbalance = parseInt(potbalance[1].value) + amount
                exports['corrupt']:execute("UPDATE corrupt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('CORRUPT:gotCommunityPotAmount', source, newpotbalance)
                CORRUPT.sendWebhook('com-pot', 'Corrupt Community Pot Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Deposit**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)

RegisterServerEvent("CORRUPT:tryWithdrawCommunityPot")
AddEventHandler("CORRUPT:tryWithdrawCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['corrupt']:execute("SELECT value FROM corrupt_community_pot", function(potbalance)
            if parseInt(potbalance[1].value) >= amount then
                local newpotbalance = parseInt(potbalance[1].value) - amount
                exports['corrupt']:execute("UPDATE corrupt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('CORRUPT:gotCommunityPotAmount', source, newpotbalance)
                CORRUPT.prompt(source, "How would you like this?", "Replace this with cash or bank", function(player, result)
                    local result = string.lower(result)
                    if result == "cash" then
                        CORRUPT.giveMoney(user_id, amount)
                    elseif result == "bank" then
                        CORRUPT.giveBankMoney(user_id, amount)
                    else
                        CORRUPT.notify(source, {"~r~Invalid option"})
                    end
                end)
                CORRUPT.sendWebhook('com-pot', 'Corrupt Community Pot Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Withdraw**\n> Amount: £**"..getMoneyStringFormatted(amount).."**")
            end
        end)
    end
end)


RegisterServerEvent("CORRUPT:trydistributionCommunityPot")
AddEventHandler("CORRUPT:trydistributionCommunityPot", function(amount)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    
    if amount < 1000000 then
        CORRUPT.notify(source, {"~r~You must distribute at least £1,000,000"})
        return
    end

    if CORRUPT.hasPermission(user_id, 'admin.managecommunitypot') then
        exports['corrupt']:execute("SELECT value FROM corrupt_community_pot", function(potbalance)
            if tonumber(potbalance[1].value) >= amount then
                local newpotbalance = tonumber(potbalance[1].value) - amount
                local players = #GetPlayers()
                local amountperplayer = math.floor(amount / players)  -- Round down to the nearest whole number
                exports['corrupt']:execute("UPDATE corrupt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
                TriggerClientEvent('CORRUPT:gotCommunityPotAmount', source, newpotbalance)

                for k, v in pairs(CORRUPT.getUsers()) do
                    CORRUPT.giveBankMoney(k, amountperplayer)
                    CORRUPT.notify(v, {"~g~You have been given £"..getMoneyStringFormatted(amountperplayer).." from the Community Pot"})
                end

                CORRUPT.sendWebhook('com-pot', 'Corrupt Community Pot Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Type: **Distribute**\n> Amount: £**"..getMoneyStringFormatted(amount).."**\n> Amount Per Player: £**"..getMoneyStringFormatted(amountperplayer).."**")
            end
        end)
    end
end)




RegisterServerEvent("CORRUPT:addToCommunityPot")
AddEventHandler("CORRUPT:addToCommunityPot", function(amount)
    if source ~= '' then return end
    exports['corrupt']:execute("SELECT value FROM corrupt_community_pot", function(potbalance)
        local newpotbalance = parseInt(potbalance[1].value) + amount
        exports['corrupt']:execute("UPDATE corrupt_community_pot SET value = @newpotbalance", {newpotbalance = newpotbalance})
    end)
end)

function getMoneyStringFormatted(cashString)
    local i, j, minus, int = tostring(cashString):find('([-]?)(%d+)%.?%d*')
    
    if int == nil then 
        return cashString
    else
        -- reverse the int-string and append a comma to all blocks of 3 digits
        int = int:reverse():gsub("(%d%d%d)", "%1,")
  
        -- reverse the int-string back, remove an optional comma, and put the optional minus back
        return minus .. int:reverse():gsub("^,", "")
    end
  end
  