

local moneyitemtable = {
    ["100k"] = 100000,
    ["200k"] = 200000,
    ["300k"] = 300000,
    ["400k"] = 400000,
    ["500k"] = 500000,
    ["600k"] = 600000,
    ["700k"] = 700000,
    ["800k"] = 800000,
    ["900k"] = 900000,
    ["1m"] = 1000000,
    ["2m"] = 2000000,
    ["3m"] = 3000000,
    ["4m"] = 4000000,
    ["5m"] = 5000000,
    ["10m"] = 10000000,
    ["20m"] = 20000000,
    ["30m"] = 30000000,
    ["40m"] = 40000000,
    ["50m"] = 50000000,
    ["100m"] = 100000000,
    ["200m"] = 200000000,
    ["300m"] = 300000000,
    ["400m"] = 400000000,
    ["500m"] = 500000000,
}







RegisterNetEvent("CORRUPT:getCompensation")
AddEventHandler("CORRUPT:getCompensation", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT * FROM corrupt_users_commpensation WHERE user_id = @user_id', {user_id = user_id}, function(result)
        compitems = {}
        if #result > 0 then
            for a,b in pairs(result) do
                if tobool(b.money) then
                    compitems["£"..getMoneyStringFormatted(b.item)] = b.item
                elseif tobool(b.weapon) then
                    print(CORRUPT.getItemName(b.item))
                    compitems[CORRUPT.getItemName(b.item)] = b.item
                end
            end
            TriggerClientEvent('CORRUPT:gotCompensation', source, compitems)
        end
    end)
end)


RegisterNetEvent("CORRUPT:claimCompensation")
AddEventHandler("CORRUPT:claimCompensation", function(item)
    print(item)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT * FROM corrupt_users_commpensation WHERE user_id = @user_id AND item = @item', {user_id = user_id, item = item}, function(result)
        if #result > 0 then
            if tobool(result[1].money) then
                local money = tonumber(result[1].item)
                money = moneyitemtable[money]
                CORRUPT.giveBankMoney(user_id, money)
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, 'Corrupt Studios', "You have received a £"..money.." from your compensation!\n", 18, 10000)
            elseif tobool(result[1].weapon) then
                local spawncode = tostring(result[1].item)
                CORRUPTclient.GiveWeaponsToPlayer(source, {{[spawncode] = {ammo = 250}}, false})
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, 'Corrupt Studios', "You have received a "..CORRUPT.getItemName(result[1].item).." from your compensation!\n", 18, 10000)
            end
            exports['corrupt']:execute('DELETE FROM corrupt_users_commpensation WHERE user_id = @user_id AND item = @item', {user_id = user_id, item = item}, function() end)
        end
    end)
end)



RegisterCommand("addcomp", function(source, args)
    if source ~= 0 then return end
    print(json.encode(args))
    local user_id = tonumber(args[1])
    local item = args[2]
    local money = tobool(args[3])
    local weapon = tobool(args[4])
    if money then
        item = moneyitemtable[item]
    end
    exports['corrupt']:execute('INSERT INTO corrupt_users_commpensation (user_id, item, money, weapon) VALUES (@user_id, @item, @money, @weapon)', {user_id = user_id, item = item, money = money, weapon = weapon}, function() end)
end)

RegisterCommand("addcompmoney", function(source, args)
    if source ~= 0 then
        print("Unauthorized attempt to execute addcompmoney. Source: " .. source)
        return
    end

    if #args < 2 then
        print("Usage: /addcompmoney [user_id] [item]")
        return
    end

    local user_id = tonumber(args[1])
    if not user_id then
        print("Invalid user ID. Please provide a valid numeric user ID.")
        return
    end

    local item = tostring(args[2])
    if not moneyitemtable[item] then
        print("Invalid item. Please provide a valid item.")
        return
    end

    exports['corrupt']:execute('INSERT INTO corrupt_users_commpensation (user_id, item, money, weapon) VALUES (@user_id, @item, @money, @weapon)', {user_id = user_id, item = item, money = true, weapon = false}, function()
        print("Compensation money added successfully for user ID: " .. user_id)
    end)
end)

RegisterCommand("addcompweapon", function(source, args)
    if source ~= 0 then
        print("Unauthorized attempt to execute addcompweapon. Source: " .. source)
        return
    end

    if #args < 2 then
        print("Usage: /addcompweapon [user_id] [item]")
        return
    end

    local user_id = tonumber(args[1])
    if not user_id then
        print("Invalid user ID. Please provide a valid numeric user ID.")
        return
    end

    local item = tostring(args[2])
    item = string.upper(item)

    exports['corrupt']:execute('INSERT INTO corrupt_users_commpensation (user_id, item, money, weapon) VALUES (@user_id, @item, @money, @weapon)', {user_id = user_id, item = item, money = false, weapon = true}, function()
        print("Compensation weapon added successfully for user ID: " .. user_id)
    end)
end)
