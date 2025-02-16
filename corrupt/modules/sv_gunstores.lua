local cfg = module("cfg/gunstores")
local organheist = module('cfg/cfg_organheist')

MySQL.createCommand("CORRUPT/get_weapons", "SELECT weapon_info FROM corrupt_weapon_whitelists WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/set_weapons", "UPDATE corrupt_weapon_whitelists SET weapon_info = @weapon_info WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/add_user", "INSERT IGNORE INTO corrupt_weapon_whitelists SET user_id = @user_id")
MySQL.createCommand("CORRUPT/get_all_weapons", "SELECT * FROM corrupt_weapon_whitelists")
MySQL.createCommand("CORRUPT/create_weapon_code", "INSERT IGNORE INTO corrupt_weapon_codes SET user_id = @user_id, spawncode = @spawncode, weapon_code = @weapon_code")
MySQL.createCommand("CORRUPT/remove_weapon_code", "DELETE FROM corrupt_weapon_codes WHERE weapon_code = @weapon_code")
MySQL.createCommand("CORRUPT/get_weapon_codes", "SELECT * FROM corrupt_weapon_codes")

AddEventHandler("playerJoining", function()
    local user_id = CORRUPT.getUserId(source)
    MySQL.execute("CORRUPT/add_user", {user_id = user_id})
end)

function deepcopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[deepcopy(orig_key)] = deepcopy(orig_value)
        end
        setmetatable(copy, deepcopy(getmetatable(orig)))
    else -- number, string, boolean, etc
        copy = orig
    end
    return copy
end

RegisterNetEvent("CORRUPT:getCustomWeaponsOwned")
AddEventHandler("CORRUPT:getCustomWeaponsOwned",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ownedWhitelists = {}
    MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            data = json.decode(weaponWhitelists[1]['weapon_info'])
            for k,v in pairs(data) do
                for a,b in pairs(v) do
                    for c,d in pairs(cfg.whitelistedGuns) do
                        for e,f in pairs(d) do
                            if e == a then
                                ownedWhitelists[a] = b[1]
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('CORRUPT:gotCustomWeaponsOwned', source, ownedWhitelists)
        end
    end)
end)

function weaponWhitelistsredeem(user_id, code)
    local user_id = user_id
    local code = code
    local ownedWhitelists = {}
    MySQL.query("CORRUPT/get_weapon_codes", {}, function(weaponCodes)
        if #weaponCodes > 0 then
            for e,f in pairs(weaponCodes) do
                if f['user_id'] == user_id and f['weapon_code'] == code then
                    MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                        if next(weaponWhitelists) then
                            ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
                        end
                        for a,b in pairs(cfg.whitelistedGuns) do
                            for c,d in pairs(b) do
                                if c == f['spawncode'] then
                                    if not ownedWhitelists[a] then
                                        ownedWhitelists[a] = {}
                                    end
                                    ownedWhitelists[a][c] = d
                                end
                            end
                        end
                        MySQL.execute("CORRUPT/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
                        MySQL.execute("CORRUPT/remove_weapon_code", {weapon_code = code})
                    end)
                end
            end
        end
    end)
end

RegisterCommand("redeemweaponwl", function(_, arg)
    if _ ~= 0 then return end
    local user_id = tonumber(arg[1])
    local code = tonumber(arg[2])
    local ownedWhitelists = {}
    MySQL.query("CORRUPT/get_weapon_codes", {}, function(weaponCodes)
        if #weaponCodes > 0 then
            for e,f in pairs(weaponCodes) do
                if f['user_id'] == user_id and f['weapon_code'] == code then
                    MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                        if next(weaponWhitelists) then
                            ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
                        end
                        for a,b in pairs(cfg.whitelistedGuns) do
                            for c,d in pairs(b) do
                                if c == f['spawncode'] then
                                    if not ownedWhitelists[a] then
                                        ownedWhitelists[a] = {}
                                    end
                                    ownedWhitelists[a][c] = d
                                end
                            end
                        end
                        MySQL.execute("CORRUPT/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
                        MySQL.execute("CORRUPT/remove_weapon_code", {weapon_code = code})
                        CORRUPT.sendWebhook('donation',"CORRUPT Donation Logs", "> Player PermID: **"..user_id.."**\n> Package: **Weapon Access**\n> Access code: **"..code.."**")
                    end)
                end
            end
        end
    end)
end)

RegisterCommand("addweaponwl", function(source, args)
    if source ~= 0 then return end
    local user_id = tonumber(args[1])
    local spawncode = args[2]
    local code = math.random(100000, 999999)
    MySQL.execute("CORRUPT/create_weapon_code", {user_id = user_id, spawncode = spawncode, weapon_code = code})
    print("Code: "..code)
end)



RegisterNetEvent("CORRUPT:requestWhitelistedUsers")
AddEventHandler("CORRUPT:requestWhitelistedUsers",function(spawncode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local whitelistOwners = {}
    MySQL.query("CORRUPT/get_all_weapons", {}, function(weaponWhitelists)
        for k,v in pairs(weaponWhitelists) do
            if v['weapon_info'] ~= nil then
                data = json.decode(v['weapon_info'])
                for a,b in pairs(data) do
                    if b[spawncode] then
                        whitelistOwners[v['user_id']] = (exports['corrupt']:executeSync("SELECT username FROM corrupt_users WHERE id = @user_id", {user_id = v['user_id']})[1]).username
                    end
                end
            end
        end
        TriggerClientEvent('CORRUPT:getWhitelistedUsers', source, whitelistOwners)
    end)
end)

RegisterNetEvent("CORRUPT:generateWeaponAccessCode")
AddEventHandler("CORRUPT:generateWeaponAccessCode", function(spawncode, id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local code = math.random(100000, 999999)
    MySQL.execute("CORRUPT/create_weapon_code", {user_id = id, spawncode = spawncode, weapon_code = code})
    TriggerClientEvent('CORRUPT:generatedAccessCode', source, code)
end)


RegisterNetEvent("CORRUPT:requestNewGunshopData")
AddEventHandler("CORRUPT:requestNewGunshopData",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if plathours > 0 and CORRUPT.hasPermission(user_id, "vip.gunstore") then
                    for k,v in pairs(cfg.VIPWithPlat) do
                        gunstoreData["VIP"][k] = v
                    end
                end
            end
            if CORRUPT.hasPermission(user_id, 'advancedrebel.license') then
                for k,v in pairs(cfg.RebelWithAdvanced) do
                    gunstoreData["Rebel"][k] = v
                end
            end
            TriggerClientEvent('CORRUPT:recieveFilteredGunStoreData', source, gunstoreData)
        end)
    end)
end)

function gunStoreLogs(weaponshop, webhook, title, text)
    if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' then
        CORRUPT.sendWebhook('pd-armoury', 'Corrupt Police Armoury Logs', text)
    elseif weaponshop == 'NHS' then
        CORRUPT.sendWebhook('nhs-armoury', 'Corrupt NHS Armoury Logs', text)
    elseif weaponshop == 'prisonArmoury' then
        CORRUPT.sendWebhook('hmp-armoury', 'Corrupt HMP Armoury Logs', text)
    elseif weaponshop == 'LFB' then
        CORRUPT.sendWebhook('lfb-armoury', 'Corrupt LFB Armoury Logs', text)
    end
    CORRUPT.sendWebhook(webhook,title,text)
end

RegisterNetEvent("CORRUPT:buyWeapon")
AddEventHandler("CORRUPT:buyWeapon",function(spawncode, price, name, weaponshop, purchasetype, vipstore)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local hasPerm = false
    local gunstoreData = deepcopy(cfg.GunStores)
    MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
        local gunstoreData = deepcopy(cfg.GunStores)
        if weaponWhitelists[1]['weapon_info'] ~= nil then
            local data = json.decode(weaponWhitelists[1]['weapon_info'])
            for a,b in pairs(gunstoreData) do
                for c,d in pairs(data) do
                    if a == c then
                        for e,f in pairs(data[a]) do
                            gunstoreData[a][e] = f
                        end
                    end
                end
            end
        end
        for k,v in pairs(gunstoreData[weaponshop]) do
            if k == '_config' then
                local withinRadius = false
                for a,b in pairs(v[1]) do
                    if #(GetEntityCoords(GetPlayerPed(source)) - b) < 10 then
                        withinRadius = true
                    end
                end
                if vipstore then
                    if #(GetEntityCoords(GetPlayerPed(source)) - gunstoreData["VIP"]['_config'][1][1] ) < 10 then
                        withinRadius = true
                    end
                end
                local locations_to_check = {
                    organheist.locations["Morgue"],
                    organheist.locations["Abandoned Silo"]
                }
                for _, location in ipairs(locations_to_check) do
                    for _, side in ipairs(location.sides) do
                        for _, gunStore in pairs(side.gunStores) do
                            for _, storeLocation in ipairs(gunStore) do
                                if #(GetEntityCoords(GetPlayerPed(source) - storeLocation[3])) <= 15.0 then
                                    withinRadius = true
                                end
                            end
                        end
                    end
                end
                if not withinRadius then return end
                if json.encode(v[5]) ~= '[""]' then
                    local hasPermissions = 0
                    for a,b in pairs(v[5]) do
                        if CORRUPT.hasPermission(user_id, b) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #v[5] then
                        hasPerm = true
                    end
                else
                    hasPerm = true
                end
                CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
                    if cb then
                        if plathours > 0 and CORRUPT.hasPermission(user_id, "vip.gunstore") then
                            for k,v in pairs(cfg.VIPWithPlat) do
                                gunstoreData["VIP"][k] = v
                            end
                        end
                    end
                    if CORRUPT.hasPermission(user_id, 'advancedrebel.license') then
                        for k,v in pairs(cfg.RebelWithAdvanced) do
                            gunstoreData["Rebel"][k] = v
                        end
                    end
                    for c,d in pairs(gunstoreData[weaponshop]) do
                        if c ~= '_config' then
                            if hasPerm then
                                if c == spawncode then
                                    if name == d[1] then
                                        if purchasetype == 'armour' then
                                            for k,v in pairs(cfg.items) do
                                                if spawncode:sub(6) == v.item then
                                                    if CORRUPT.getInventoryWeight(user_id)+v.weight <= CORRUPT.getInventoryMaxWeight(user_id) then
                                                        if CORRUPT.tryGunStorePayment(user_id, price, weaponshop) then
                                                            CORRUPT.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(math.floor(price))..'.'})
                                                            CORRUPT.giveInventoryItem(user_id,v.item,1,true)
                                                            TriggerClientEvent("corrupt:PlaySound", source, "money")
                                                            gunStoreLogs(weaponshop, 'weapon-shops',"Corrupt Weapon Shop Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                            return
                                                        end
                                                    else
                                                        return CORRUPT.notify(source, {'~r~You do not have enough space in your inventory.'})
                                                    end
                                                end
                                            end
                                            if string.find(spawncode, "fillUp") then
                                                price = (100 - GetPedArmour(GetPlayerPed(source))) * 1000
                                                if CORRUPT.tryGunStorePayment(user_id, price, weaponshop) then
                                                    CORRUPT.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                                    TriggerClientEvent("corrupt:PlaySound", source, "playMoney")
                                                    CORRUPT.setArmour(source, 100, true)
                                                    gunStoreLogs(weaponshop, 'weapon-shops',"Corrupt Weapon Shop Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                    return
                                                end
                                            elseif GetPedArmour(GetPlayerPed(source)) >= (price/1000) then
                                                CORRUPT.notify(source, {'You already have '..GetPedArmour(GetPlayerPed(source))..'% armour.'})
                                                return
                                            end
                                            if CORRUPT.tryGunStorePayment(user_id, d[2], weaponshop) then
                                                CORRUPT.notify(source, {'~g~You bought '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                                TriggerClientEvent("corrupt:PlaySound", source, "playMoney")
                                                CORRUPT.setArmour(source, price/1000, true)
                                                gunStoreLogs(weaponshop, 'weapon-shops',"Corrupt Weapon Shop Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                if weaponshop == 'LargeArmsDealer' then
                                                    CORRUPT.turfSaleToGangFunds(price, 'LargeArms')
                                                end
                                            else
                                                CORRUPT.notify(source, {'You do not have enough money for this purchase.'})
                                                TriggerClientEvent("corrupt:PlaySound", source, 2)
                                            end
                                        elseif purchasetype == 'weapon' then
                                            CORRUPTclient.hasWeapon(source, {spawncode}, function(hasWeapon)
                                                if hasWeapon then
                                                    CORRUPT.notify(source, {'You must store your current '..name..' before purchasing another.'})
                                                else
                                                    if CORRUPT.tryGunStorePayment(user_id, d[2], weaponshop) then
                                                        if price > 0 then
                                                            CORRUPT.notify(source, {'~g~You bought a '..name..' for £'..getMoneyStringFormatted(price)..'.'})
                                                            if weaponshop == 'LargeArmsDealer' then
                                                                CORRUPT.turfSaleToGangFunds(price, 'LargeArms')
                                                            end
                                                        else
                                                            CORRUPT.notify(source, {'~g~'..name..' purchased.'})
                                                        end
                                                        TriggerClientEvent("corrupt:PlaySound", source, "playMoney")
                                                        CORRUPTclient.GiveWeaponsToPlayer(source, {{[spawncode] = {ammo = 250}}, false})
                                                        gunStoreLogs(weaponshop, 'weapon-shops',"Corrupt Weapon Shop Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                                    else
                                                        CORRUPT.notify(source, {'You do not have enough money for this purchase.'})
                                                        TriggerClientEvent("corrupt:PlaySound", source, 2)
                                                    end
                                                end
                                            end)
                                        elseif purchasetype == 'ammo' then
                                            price = price/2
                                            if CORRUPT.tryGunStorePayment(user_id, price, weaponshop) then
                                                if price > 0 then
                                                    CORRUPT.notify(source, {'~g~You bought 250x Ammo for £'..getMoneyStringFormatted(price)..'.'})
                                                    if weaponshop == 'LargeArmsDealer' then
                                                        CORRUPT.turfSaleToGangFunds(price, 'LargeArms')
                                                    end
                                                else
                                                    CORRUPT.notify(source, {'~g~250x Ammo purchased.'})
                                                end
                                                TriggerClientEvent("corrupt:PlaySound", source, "playMoney")
                                                CORRUPTclient.GiveWeaponsToPlayer(source, {{[spawncode] = {ammo = 250}}, false})
                                                gunStoreLogs(weaponshop, 'weapon-shops',"Corrupt Weapon Shop Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**\n> Price: **£"..getMoneyStringFormatted(price).."**\n> Weapon Shop: **"..weaponshop.."**\n> Purchase Type: **"..purchasetype.."**")
                                            else
                                                CORRUPT.notify(source, {'You do not have enough money for this purchase.'})
                                                TriggerClientEvent("corrupt:PlaySound", source, 2)
                                            end
                                        end
                                    end
                                end
                            else
                                if weaponshop == 'policeLargeArms' or weaponshop == 'policeSmallArms' then
                                    CORRUPT.notify(source, {"You shouldn't be in here, ALARM TRIGGERED!!!"})
                                else
                                    CORRUPT.notify(source, {"You do not have permission to access this store."})
                                end
                            end
                        end
                    end
                end)
            end
        end
    end)
end)


function CORRUPT.tryGunStorePayment(user_id, price, weaponshop)
    if weaponshop == 'VIP' then
        return CORRUPT.tryBankPayment(user_id, price)
    else
        return CORRUPT.tryPayment(user_id, price)
    end
end

function CORRUPT.tryGunStorePayment(user_id, price, weaponshop)
    if weaponshop == 'CorruptDealer' then
        return CORRUPT.tryBankPayment(user_id, price)
    else
        return CORRUPT.tryPayment(user_id, price)
    end
end
