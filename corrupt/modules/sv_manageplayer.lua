local function getPlayerInfo(id, cb)
    MySQL.query("casinochips/get_chips", {user_id = id}, function(rows, affected)
        if #rows > 0 then
            local chips = rows[1].chips
            local data = CORRUPT.getUserDataTable(id)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, ItemName = CORRUPT.getItemName(i), Weight = CORRUPT.getItemWeight(i)}
                end
                local inventory = {
                    data = FormattedInventoryData,
                    weight = CORRUPT.computeItemsWeight(data.inventory),
                    maxWeight = CORRUPT.getInventoryMaxWeight(id)
                }
                local moneyStuff = {
                    {ItemName = "Cash", Weight = 0.0, amount = CORRUPT.getMoney(id)},
                    {ItemName = "Bank", Weight = 0.0, amount = CORRUPT.getBankMoney(id)},
                    {ItemName = "Casino Chips", Weight = 0.0, amount = chips}
                }
                cb(moneyStuff, inventory)
            end
        end
    end)
end

local function getUserInformation(source, id)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.moneymenu') then
        if CORRUPT.getUserSource(id) then
            getPlayerInfo(id, function(moneyStuff, inventory)
                TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
            end)
        else
            CORRUPT.notify(source, {'~r~Player is not online.'})
        end
    end
end


RegisterServerEvent("CORRUPT:getUserinformation")
AddEventHandler("CORRUPT:getUserinformation",function(id)
    local source = source
    getUserInformation(source, id)
end)

RegisterServerEvent("CORRUPT:ManagePlayerBank")
AddEventHandler("CORRUPT:ManagePlayerBank",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local userstemp = CORRUPT.getUserSource(id)
    if CORRUPT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            CORRUPT.giveBankMoney(id, amount)
            CORRUPT.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Bank Balance.'})
        elseif cashtype == 'Decrease' then
            CORRUPT.tryBankPayment(id, amount)
            CORRUPT.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Bank Balance.'})
        end
        getPlayerInfo(id, function(moneyStuff, inventory)
            TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
        end)
    end
end)

RegisterServerEvent("CORRUPT:ManagePlayerCash")
AddEventHandler("CORRUPT:ManagePlayerCash",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local userstemp = CORRUPT.getUserSource(id)
    if CORRUPT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            CORRUPT.giveMoney(id, amount)
            CORRUPT.notify(source, {'~g~Added £'..getMoneyStringFormatted(amount)..' to players Cash Balance.'})
        elseif cashtype == 'Decrease' then
            CORRUPT.tryPayment(id, amount)
            CORRUPT.notify(source, {'~r~Removed £'..getMoneyStringFormatted(amount)..' from players Cash Balance.'})
        end
        getPlayerInfo(id, function(moneyStuff, inventory)
            TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
        end)
    end
end)

RegisterServerEvent("CORRUPT:ManagePlayerChips")
AddEventHandler("CORRUPT:ManagePlayerChips",function(id, amount, cashtype)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local userstemp = CORRUPT.getUserSource(id)
    if CORRUPT.hasPermission(user_id, 'admin.moneymenu') then
        if cashtype == 'Increase' then
            giveChips(userstemp,amount)
            CORRUPT.notify(source, {'~g~Added '..getMoneyStringFormatted(amount)..' to players Casino Chips.'})
            getPlayerInfo(id, function(moneyStuff, inventory)
                TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
            end)
        elseif cashtype == 'Decrease' then
            MySQL.execute("casinochips/remove_chips", {user_id = id, amount = amount})
            CORRUPT.notify(source, {'~r~Removed '..getMoneyStringFormatted(amount)..' from players Casino Chips.'})
            getPlayerInfo(id, function(moneyStuff, inventory)
                TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
            end)
        end
    end
end)

RegisterServerEvent("CORRUPT:ManagePlayerItem")
AddEventHandler("CORRUPT:ManagePlayerItem",function(id)
    local amount = tonumber(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local userstemp = CORRUPT.getUserSource(id)
    if CORRUPT.hasPermission(user_id, 'admin.moneymenu') then
        CORRUPT.prompt(source,"Item:","",function(player,item)
            local item = item
            if string.find(string.lower(item), "weapon_") then
                item = "wbody|"..string.upper(item)
            end
            CORRUPT.prompt(source,"Amount:","",function(player,amount)
                local amount = tonumber(amount)
                local data = CORRUPT.getUserDataTable(id)
                if data.inventory then
                    if data.inventory[item] then
                        data.inventory[item].amount = data.inventory[item].amount + amount
                    else
                        data.inventory[item] = {amount = amount}
                    end
                    if data.inventory[item].amount <= 0 then
                        data.inventory[item] = nil
                    end
                end
                getPlayerInfo(id, function(moneyStuff, inventory)
                    TriggerClientEvent('CORRUPT:receivedUserInformation', source, moneyStuff, inventory, id)
                end)
            end)
        end)
    end
end)
