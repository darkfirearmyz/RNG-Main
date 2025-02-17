local lootableitems = {
    -- Vehicle Items
    {name = "Lock Slot", item = "lock_slot", chance = 1},
    {name = "Import Slot", item = "import_slot", chance = 5},
    -- Money Items
    {name = "£1,000,000", item = "1_money_bag", chance = 30},
    {name = "£2,000,000", item = "2_money_bag", chance = 25},
    {name = "£5,000,000", item = "5_money_bag", chance = 20},
    {name = "£10,000,000", item = "10_money_bag", chance = 15},
    {name = "£20,000,000", item = "20_money_bag", chance = 10},
    -- Weapon Import Items
    {name = "Melee Import", item = "melee_import", chance = 1},
    {name = "Pistol Import", item = "pistol_import", chance = 1},
    {name = "Shotgun Import", item = "shotgun_import", chance = 1},
    {name = "SMG Import", item = "smg_import", chance = 1},
    {name = "Assault Rifle Import", item = "ar_import", chance = 1},
    {name = "Sniper Import", item = "sniper_import", chance = 1},
    -- Weapon Whitelist Items
    {name = "Melee Whitelist", item = "melee_whitelist", chance = 1},
    {name = "Pistol Whitelist", item = "pistol_whitelist", chance = 1},
    {name = "Shotgun Whitelist", item = "shotgun_whitelist", chance = 1},
    {name = "SMG Whitelist", item = "smg_whitelist", chance = 1},
    {name = "Assault Rifle Whitelist", item = "ar_whitelist", chance = 1},
    {name = "Sniper Whitelist", item = "sniper_whitelist", chance = 1},
    -- Donator Ranks
    {name = "Supporter", item = "supporter", chance = 3},
    {name = "Premium", item = "premium", chance = 2},
    {name = "Supreme", item = "supreme", chance = 1},
    {name = "King Pin", item = "kingpin", chance = 1},
    {name = "Rainmaker", item = "rainmaker", chance = 1},
    {name = "Baller", item = "baller", chance = 1},
    -- Plat
    {name = "Corrupt Platinum (30 Days)", item = "corrupt_platinum", chance = 10},
}


local function GetRandomItem(key)
    local totalChances = 0
    local excludeItems = {
        "melee_import",
        "pistol_import",
        "shotgun_import",
        "smg_import",
        "ar_import",
        "sniper_import",
        "lock_slot",
        "melee_whitelist",
        "pistol_whitelist",
        "shotgun_whitelist",
        "smg_whitelist",
        "ar_whitelist",
        "sniper_whitelist",
        "import_slot",
        "supreme",
        "kingpin",
        "rainmaker",
        "baller",
    }
    
    local validItems = {}
    
    for _, item in pairs(lootableitems) do
        local chance = item.chance
        if key == "silver" and tableContains(excludeItems, item.item) then
            chance = 0 
        elseif key == "silver" then
            chance = math.floor(chance * 0.5)
        elseif key == "gold" then
            chance = math.floor(chance * 2)
        elseif key == "plat" then
            chance = math.floor(chance * 5)
        end
        
        if chance > 0 then
            table.insert(validItems, {item = item.item, name = item.name, chance = chance})
            totalChances = totalChances + chance
        end
    end
    
    if totalChances > 0 then
        local randomNumber = math.random(1, totalChances)
        for _, itemData in pairs(validItems) do
            if randomNumber <= itemData.chance then
                return itemData.item, itemData.name
            else
                randomNumber = randomNumber - itemData.chance
            end
        end
    end
end



function tableContains(table, element)
    for _, value in pairs(table) do
        if value == element then
            return true
        end
    end
    return false
end


RegisterNetEvent("CORRUPT:Crate:OpenMenu")
AddEventHandler("CORRUPT:Crate:OpenMenu", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT * FROM corrupt_crates WHERE user_id = @user_id', { ['@user_id'] = user_id }, function(result)
        local keys = {}
        if #result > 0 then
            keys.silver = result[1].silver
            keys.gold = result[1].gold
            keys.plat = result[1].plat
            TriggerClientEvent("CORRUPT:Crate:SendData", source, keys, lootableitems)
        else
            exports['corrupt']:execute('INSERT INTO corrupt_crates (user_id, silver, gold, plat) VALUES (@user_id, @silver, @gold, @plat)', { ['@user_id'] = user_id, ['@silver'] = 0, ['@gold'] = 0, ['@plat'] = 0 })
            keys.silver = 0
            keys.gold = 0
            keys.plat = 0
            TriggerClientEvent("CORRUPT:Crate:SendData", source, keys, lootableitems)
        end
    end)
end)


RegisterNetEvent("CORRUPT:Crate:Redeem")
AddEventHandler("CORRUPT:Crate:Redeem", function(key)
    key = string.lower(key)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local item, name = GetRandomItem(key)
    exports['corrupt']:execute('SELECT ' .. key .. ' FROM corrupt_crates WHERE user_id = @user_id', { ['@user_id'] = user_id }, function(result)
        if result and result[1] then    
            local keys = result[1][key]
            if keys > 0 then
                keys = keys - 1
                exports['corrupt']:execute('UPDATE corrupt_crates SET ' .. key .. ' = @keys WHERE user_id = @user_id', { ['@keys'] = keys, ['@user_id'] = user_id })
                TriggerClientEvent("CORRUPT:Crate:StartRedeem", source, name)
                local code1, code2 = generateUUID("Items", 4, "alphanumeric"), generateUUID("Items", 4, "alphanumeric")
                local code = string.upper(code1 .. "-" .. code2)
                exports['corrupt']:execute("INSERT INTO corrupt_stores (code, item, user_id, date) VALUES (@code, @item, @user_id, @date)", {code = code, item = item, user_id = user_id, date = os.date("%d/%m/%Y")})
            else
                CORRUPT.notify(source, {"~r~You don not have that type of key!"})
            end
        end
    end)
end)
RegisterCommand("addkeys", function(source, args)
    if source == 0 then
        if not args[1] or not args[2] or not args[3] then
            print("Invalid arguments")
            return
        end
        local user_id = tonumber(args[1])
        local key = string.lower(args[2])
        local amount = tonumber(args[3])
        exports['corrupt']:execute('SELECT ?? FROM corrupt_crates WHERE user_id = ?', { key, user_id }, function(result)
            if result and result[1] then    
                local keys = result[1][key]
                keys = tonumber(keys) or 0
                keys = keys + amount
                exports['corrupt']:execute('UPDATE corrupt_crates SET ?? = ? WHERE user_id = ?', { key, keys, user_id })
                print("Corrupt - Added " .. amount .. " " .. key .. " keys to user_id: " .. user_id)
            else
                print("No record found for user_id:", user_id)
            end
        end)
    end
end)
RegisterNetEvent("CORRUPT:setPlayerKeys")
AddEventHandler("CORRUPT:setPlayerKeys", function(target_id, key, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "Founder") or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
        exports['corrupt']:execute('SELECT '.. key ..'  FROM corrupt_crates WHERE user_id = ?', { target_id }, function(result)
            if result and result[1] then    
                local keys = result[1][key]
                keys = tonumber(keys) or 0
                keys = keys + amount
                exports['corrupt']:execute('UPDATE corrupt_crates SET ?? = ? WHERE user_id = ?', { key, keys, target_id })
            end
        end)
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'CORRUPT:setPlayerKeys')
    end
end)

RegisterNetEvent("CORRUPT:getPlayerKeys")
AddEventHandler("CORRUPT:getPlayerKeys", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "Founder") or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
        exports['corrupt']:execute('SELECT * FROM corrupt_crates WHERE user_id = ?', { target_id }, function(result)
            if result and result[1] then    
                local keys = {}
                keys.silver = result[1].silver
                keys.gold = result[1].gold
                keys.plat = result[1].plat
                keys.userid = target_id
                print(json.encode(keys))
                TriggerClientEvent("CORRUPT:Crate:GotPlayerKeys", source, keys)
            end
        end)
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'CORRUPT:getPlayerKeys')
    end
end)



Citizen.CreateThread(function()
    Wait(2500)
    exports['corrupt']:execute([[
        CREATE TABLE IF NOT EXISTS `corrupt_crates` (
            `user_id` int(11) NOT NULL,
            `silver` int(11) NOT NULL,
            `gold` int(11) NOT NULL,
            `plat` int(11) NOT NULL,
            PRIMARY KEY (`user_id`)
        );
    ]])
end)