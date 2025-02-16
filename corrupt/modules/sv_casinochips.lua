MySQL.createCommand("casinochips/add_id", "INSERT IGNORE INTO corrupt_casino_chips SET user_id = @user_id")
MySQL.createCommand("casinochips/get_chips","SELECT * FROM corrupt_casino_chips WHERE user_id = @user_id")
MySQL.createCommand("casinochips/add_chips", "UPDATE corrupt_casino_chips SET chips = (chips + @amount) WHERE user_id = @user_id")
MySQL.createCommand("casinochips/remove_chips", "UPDATE corrupt_casino_chips SET chips = CASE WHEN ((chips - @amount)>0) THEN (chips - @amount) ELSE 0 END WHERE user_id = @user_id")


AddEventHandler("playerJoining", function()
    local user_id = CORRUPT.getUserId(source)
    MySQL.execute("casinochips/add_id", {user_id = user_id})
end)

RegisterNetEvent("CORRUPT:enterDiamondCasino")
AddEventHandler("CORRUPT:enterDiamondCasino", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.setBucket(source, 777)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('CORRUPT:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("CORRUPT:exitDiamondCasino")
AddEventHandler("CORRUPT:exitDiamondCasino", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.setBucket(source, 0)
end)

RegisterNetEvent("CORRUPT:getChips")
AddEventHandler("CORRUPT:getChips", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            TriggerClientEvent('CORRUPT:setDisplayChips', source, rows[1].chips)
            return
        end
    end)
end)

RegisterNetEvent("CORRUPT:buyChips")
AddEventHandler("CORRUPT:buyChips", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not amount then amount = CORRUPT.getMoney(user_id) end
    if CORRUPT.tryPayment(user_id, amount) then
        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
        TriggerClientEvent('CORRUPT:chipsUpdated', source)
        CORRUPT.sendWebhook('purchase-chips',"Corrupt Chip Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
        return
    else
        CORRUPT.notify(source,{"You don't have enough money."})
        return
    end
end)

local sellingChips = {}
RegisterNetEvent("CORRUPT:sellChips")
AddEventHandler("CORRUPT:sellChips", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local chips = nil
    if not sellingChips[source] then
        sellingChips[source] = true
        MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
            if #rows > 0 then
                local chips = rows[1].chips
                if not amount then amount = chips end
                if amount > 0 and chips > 0 and chips >= amount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = amount})
                    TriggerClientEvent('CORRUPT:chipsUpdated', source)
                    CORRUPT.sendWebhook('sell-chips',"Corrupt Chip Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(amount).."**")
                    CORRUPT.giveMoney(user_id, amount)
                else
                    CORRUPT.notify(source,{"You don't have enough chips."})
                end
                sellingChips[source] = nil
            end
        end)
    end
end)