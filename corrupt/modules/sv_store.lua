local cfg = module("cfg/cfg_store")
MySQL.createCommand("CORRUPT/add_store_item", "INSERT IGNORE INTO corrupt_store_data (uuid, user_id, store_item) VALUES (@uuid, @user_id, @store_item)")
MySQL.createCommand("CORRUPT/update_store_item", "UPDATE corrupt_store_data SET user_id = @user_id WHERE uuid = @uuid")
MySQL.createCommand("CORRUPT/delete_store_item", "DELETE FROM corrupt_store_data WHERE uuid = @uuid")
MySQL.createCommand("CORRUPT/get_item_data", "SELECT * FROM corrupt_store_data WHERE uuid = @uuid")
MySQL.createCommand("CORRUPT/get_store_data", "SELECT * FROM corrupt_store_data WHERE user_id = @user_id")

function CORRUPT.generatePackageUUID()
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
    local firstString = ""
    local secondString = ""
    for i = 1, 4 do
        local randomString = math.random(#chars)
        firstString = firstString .. string.sub(chars, randomString, randomString)
    end
    for i = 1, 4 do
        local randomString = math.random(#chars)
        secondString = secondString .. string.sub(chars, randomString, randomString)
    end
    local UUID = firstString..'-'..secondString
    local checkUUID = exports["corrupt"]:executeSync("SELECT * FROM corrupt_store_data WHERE uuid = @uuid", {uuid = UUID})
    if #checkUUID > 0 then
        CORRUPT.generatePackageUUID()
    else
        return UUID
    end
end

function CORRUPT.createConsoleCommand(command, callback)
    RegisterCommand(command, function(source, args)
        if source ~= 0 then
            return
        end
        callback(source, args)
    end)
end

CORRUPT.createConsoleCommand('addpackage', function(source, args)
    local user_id = tonumber(args[1])
    local package = args[2]
    local uuid = CORRUPT.generatePackageUUID()
    CORRUPT.addPackage(user_id,package,uuid)
end)

function CORRUPT.addPackage(user_id,package)
    local source = CORRUPT.getUserSource(user_id)
    local uuid = CORRUPT.generatePackageUUID()
    MySQL.execute("CORRUPT/add_store_item", {user_id = user_id, uuid = uuid, store_item = package})
    CORRUPT.sendWebhook('add-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Added Package: **"..package.."**\n> UUID: **"..uuid.."**")
    Wait(100)
    if source ~= nil then
        CORRUPT.getStoreOwned(user_id, function(storeOwned)
            TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
        end)
    end
end

function CORRUPT.deletePackage(user_id, uuid)
    local source = CORRUPT.getUserSource(user_id)
    MySQL.execute("CORRUPT/delete_store_item", {uuid = uuid})
    TriggerClientEvent('CORRUPT:storeDrawEffects', source)
    TriggerClientEvent('CORRUPT:storeCloseMenu', source)
end

function CORRUPT.getStoreOwned(user_id, cb)
    local ownedItems = {}
    MySQL.query("CORRUPT/get_store_data", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            for k,v in pairs(rows) do
                ownedItems[v.uuid] = v.store_item
            end
            cb(ownedItems)
        end
    end)
end

function CORRUPT.sellStoreItem(id1, id2, uuid, item, amount, cb)
    local amount = tonumber(amount)
    MySQL.query("CORRUPT/get_item_data", {uuid = uuid}, function(rows, affected)
        if #rows > 0 then
            if rows[1].user_id == id1 then
                if CORRUPT.tryFullPayment(id2, amount) then
                    CORRUPT.giveBankMoney(id1, amount)
                    local source1 = CORRUPT.getUserSource(id1)
                    local source2 = CORRUPT.getUserSource(id2)
                    MySQL.execute("CORRUPT/update_store_item", {user_id = id2, uuid = uuid})
                    TriggerClientEvent('CORRUPT:storeCloseMenu', source1)
                    TriggerClientEvent('CORRUPT:storeCloseMenu', source2)
                    Wait(100)
                    CORRUPT.getStoreOwned(id1, function(storeOwned)
                        CORRUPT.getStoreOwned(id2, function(storeOwned2)
                            TriggerClientEvent('CORRUPT:sendStoreItems', source1, storeOwned)
                            TriggerClientEvent('CORRUPT:sendStoreItems', source2, storeOwned2)
                        end)
                    end)
                    CORRUPT.sendWebhook('sell-packages',"Store Logs", "> Seller ID: **"..id1.."**\n> Buyer ID: **"..id2.."**\n> Package: **"..item.."**\n> UUID: **"..uuid.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**")
                    cb(true)
                end
            end
        end
    end)
end

function CORRUPT.addImportSlots(user_id, storeItem, tableOfItems)
    local ranks = {
        -- Baller
        ['baller'] = 5,
        ['supporter_to_baller'] = 4,
        ['premium_to_baller'] = 4,
        ['supreme_to_baller'] = 4,
        ['kingpin_to_baller'] = 3,
        ['rainmaker_to_baller'] = 1,
        -- Rainmaker
        ['rainmaker'] = 3,
        ['supporter_to_rainmaker'] = 3,
        ['premium_to_rainmaker'] = 3,
        ['supreme_to_rainmaker'] = 3,
        ['kingpin_to_rainmaker'] = 2,
        -- Kingpin
        ['kingpin'] = 1,
        ['supporter_to_kingpin'] = 1,
        ['premium_to_kingpin'] = 1,
        ['supreme_to_kingpin'] = 1,
    }
    local importSlots = ranks[storeItem] or 0
    if importSlots > 0 then
        for k,v in pairs(tableOfItems) do
            if string.match(k, "customCar") then
                importSlots = importSlots - 1
                MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = v, registration = 'P'..math.random(10000,99999)})
            end
        end
        if importSlots >= 0 then
            for i = 1, importSlots do
                CORRUPT.addPackage(user_id,"import_slot")
                Wait(200)
            end
        end
    end
end

function CORRUPT.addVipCars(user_id, tableOfItems)
    for k,v in pairs(tableOfItems) do
        if string.match(k, "vipCar") then
            MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = v, registration = 'P'..math.random(10000,99999)})
        end
    end
end

function CORRUPT.redeemRankMoney(user_id, rank, rank2)
    local source = CORRUPT.getUserSource(user_id)
    local rankMoney = {["Supporter"] = 500000,["Premium"] = 1500000,["Supreme"] = 2500000,["Kingpin"] = 5000000,["Rainmaker"] = 10000000,["Baller"] = 25000000}
    local money = rankMoney[rank]
    if rank2 then
        money = money - rankMoney[rank2]
    end
    CORRUPT.giveBankMoney(user_id, money)
    CORRUPT.notify(source, {'~g~Received £'..getMoneyStringFormatted(money)..' for redeeming '..rank..' rank'})
    if rank == "Baller" then
        CORRUPT.addPackage(user_id, "baller_id")
        CORRUPT.addPackage(user_id, "lock_slot")
    end
end

function CORRUPT.getStoreRankName(user_id)
    local ranks = {[1] = 'Baller',[2] = 'Rainmaker',[3] = 'Kingpin',[4] = 'Supreme',[5] = 'Premium',[6] = 'Supporter'}
    for k,v in ipairs(ranks) do
        if CORRUPT.hasGroup(user_id, v) then
            return v
        end
    end
    return "None"
end

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('CORRUPT:setStoreRankName', source, CORRUPT.getStoreRankName(user_id))
        CORRUPT.getStoreOwned(user_id, function(storeOwned)
            TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
        end)
    end
end)

RegisterNetEvent("CORRUPT:getStoreLockedVehicleCategories")
AddEventHandler("CORRUPT:getStoreLockedVehicleCategories", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local lockedCategories = {}
    for k,v in pairs(cfg.vehicleCategoryToPermissionLookup) do
        if not CORRUPT.hasPermission(user_id, v) then
            lockedCategories[k] = true
        end
        TriggerClientEvent('CORRUPT:setStoreLockedVehicleCategories', source, lockedCategories)
    end
end)

local redeemingStore = {}
RegisterNetEvent("CORRUPT:redeemStoreItem")
AddEventHandler("CORRUPT:redeemStoreItem", function(d, e)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    d = tostring(d)
    if redeemingStore[source] then return end
    redeemingStore[source] = true
    CORRUPT.getStoreOwned(user_id, function(storeOwned)
        local storeItem = storeOwned[d]
        local manuallyRedeemable = cfg.items[storeItem].manuallyRedeemable
        local itemName = cfg.items[storeItem].name
        if storeItem and manuallyRedeemable then
            if storeItem == "halloween_bundle_2024" then
                -- 90 days of platinum
                CORRUPT.addPackage(user_id, "corrupt_platinum")
                CORRUPT.addPackage(user_id, "corrupt_platinum")
                CORRUPT.addPackage(user_id, "corrupt_platinum")

                CORRUPT.addPackage(user_id, "30_money_bag")
                CORRUPT.addPackage(user_id, "pistol_whitelist") -- change this to whatever package idk if u wanted pistol, melee, smg etc you just put "Weapon WL Slot"

                -- once you lmk the car spawncode I can make it so it gives them it
                MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = "x3gemwb", registration = 'P'..math.random(10000,99999)})

                TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "You have redeemed the 2024 halloween bundle", 33, 10000)
                CORRUPT.deletePackage(user_id, d)
                CORRUPT.sendWebhook('redeem-packages',"CORRUPT Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                Wait(100)
                CORRUPT.getStoreOwned(user_id, function(storeOwned)
                    TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                end)
            elseif string.match(storeItem, "money_bag") then
                local item = storeItem:gsub("_money_bag", "")
                local amount = tonumber(item)*1000000
                CORRUPT.giveBankMoney(user_id, amount)
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "You have redeemed a £"..getMoneyStringFormatted(amount).." money bag", 33, 10000)
                CORRUPT.deletePackage(user_id, d)
                CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                Wait(100)
                CORRUPT.getStoreOwned(user_id, function(storeOwned)
                    TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                end)
            elseif string.match(storeItem, "_whitelist") then
                local code = tonumber(e.accessCode)
                local ownedWhitelists = {}
                MySQL.query("CORRUPT/get_weapon_codes", {}, function(weaponCodes)
                    if #weaponCodes > 0 then
                        local spawncode = nil
                        for e,f in pairs(weaponCodes) do
                            if f['user_id'] == user_id and f['weapon_code'] == code then
                                MySQL.query("CORRUPT/get_weapons", {user_id = user_id}, function(weaponWhitelists)
                                    if next(weaponWhitelists) then
                                        ownedWhitelists = json.decode(weaponWhitelists[1]['weapon_info'])
                                    end
                                    for a,b in pairs(whitelistedGuns) do
                                        for c,d in pairs(b) do
                                            if c == f['spawncode'] then
                                                spawncode = c
                                                if not ownedWhitelists[a] then
                                                    ownedWhitelists[a] = {}
                                                end
                                                ownedWhitelists[a][c] = d
                                            end
                                        end
                                    end
                                    MySQL.execute("CORRUPT/set_weapons", {user_id = user_id, weapon_info = json.encode(ownedWhitelists)})
                                    MySQL.execute("CORRUPT/remove_weapon_code", {weapon_code = code})
                                    CORRUPT.deletePackage(user_id, d)
                                    CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**\n> Access Code: **"..code.."**\n> Weapon: **"..spawncode.."**")
                                    TriggerClientEvent("CORRUPT:refreshGunStorePermissions", source)
                                    TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "Whitelist access granted", 33, 10000)
                                    Wait(100)
                                    CORRUPT.getStoreOwned(user_id, function(storeOwned)
                                        TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                                    end)
                                end)
                            end
                        end
                    end
                end)
            elseif string.match(storeItem, "corrupt_") then
                local subscription = storeItem:sub(6)
                CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
                    if cb then
                        if subscription == "platinum" then
                            CORRUPT.GivePlatinumDays(user_id, 30)
                        end
                        CORRUPT.deletePackage(user_id, d)
                        CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                        TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "You have redeemed an "..itemName.." subscription", 33, 10000)
                        Wait(100)
                        CORRUPT.getStoreOwned(user_id, function(storeOwned)
                            TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                        end)
                    end
                end)
            elseif string.match(storeItem, "_to_") then
                local parts = {}
                for part in string.gmatch(storeItem, "([^_]+)") do
                    table.insert(parts, part:sub(1, 1):upper() .. part:sub(2))
                end
                local from = parts[1]
                local to = parts[3]
                if CORRUPT.hasGroup(user_id, from) then
                    if CORRUPT.hasGroup(user_id, to) then
                        CORRUPT.notify(source, {"~r~You already have this rank!"})
                        return
                    end
                    CORRUPT.addUserGroup(user_id, to)
                    CORRUPT.addImportSlots(user_id, storeItem, e)
                    CORRUPT.addVipCars(user_id, e)
                    TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "You have upgraded your rank to "..to, 33, 10000)
                    CORRUPT.redeemRankMoney(user_id, to, from)
                    CORRUPT.deletePackage(user_id, d)
                    CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                    Wait(100)
                    CORRUPT.getStoreOwned(user_id, function(storeOwned)
                        TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                    end)
                else
                    CORRUPT.notify(source, {"~r~You do not have the required rank to upgrade!"})
                end
            elseif storeItem == "import_slot" then
                local vehicle = e.customCar
                MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..math.random(10000,99999)})
                CORRUPT.deletePackage(user_id, d)
                CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**\n> Vehicle: **"..vehicle.."**")
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "The import vehicle is now in your garage", 33, 10000)
                Wait(100)
                CORRUPT.getStoreOwned(user_id, function(storeOwned)
                    TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                end)
            elseif storeItem == "vip_car" then
                CORRUPT.addVipCars(user_id, e)
                CORRUPT.deletePackage(user_id, d)
                CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "The VIP vehicle is now in your garage", 33, 10000)
                Wait(100)
                CORRUPT.getStoreOwned(user_id, function(storeOwned)
                    TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                end)
            else
                local rank = storeItem:sub(1,1):upper()..storeItem:sub(2)
                CORRUPT.redeemRankMoney(user_id, rank)
                CORRUPT.addUserGroup(user_id, rank)
                CORRUPT.addImportSlots(user_id, storeItem, e)
                CORRUPT.addVipCars(user_id, e)
                CORRUPT.deletePackage(user_id, d)
                CORRUPT.sendWebhook('redeem-packages',"Store Logs", "> Player PermID: **"..user_id.."**\n> Redeemed Package: **"..itemName.."**\n> UUID: **"..d.."**")
                TriggerClientEvent('CORRUPT:smallAnnouncement', source, itemName, "You have redeemed a "..itemName.." rank", 33, 10000)
                Wait(100)
                CORRUPT.getStoreOwned(user_id, function(storeOwned)
                    TriggerClientEvent('CORRUPT:sendStoreItems', source, storeOwned)
                end)
            end
        end
        redeemingStore[source] = nil
    end)
end)

RegisterNetEvent("CORRUPT:startSellStoreItem")
AddEventHandler("CORRUPT:startSellStoreItem", function(d)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    d = tostring(d)
    CORRUPT.getStoreOwned(user_id, function(storeOwned)
        local storeItem = storeOwned[d]
        if storeItem then
            local itemName = cfg.items[storeItem].name
            local canTransfer = cfg.items[storeItem].canTransfer
            if canTransfer then
                CORRUPTclient.getNearestPlayers(source,{15},function(nplayers)
                    usrList = ""
                    for k, v in pairs(nplayers) do
                        usrList = usrList .. "[" .. k .. "]" .. CORRUPT.getPlayerName(k) .. " | "
                    end
                    if usrList ~= "" then
                        CORRUPT.prompt(source,"Players Nearby: " .. usrList .. "","",function(source, tempid)
                            local target_id = CORRUPT.getUserId(tonumber(tempid))
                            if target_id ~= nil and target_id ~= "" then 
                                local target = tonumber(tempid)
                                if target ~= nil then
                                    CORRUPT.prompt(source,"Price £: ","",function(source, amount)
                                        if tonumber(amount) and tonumber(amount) >= 0 then
                                            CORRUPT.request(target,CORRUPT.getPlayerName(source).." wants to sell a " ..itemName.. " for £"..getMoneyStringFormatted(amount), 30, function(target,ok)
                                                if ok then
                                                    CORRUPT.sellStoreItem(user_id, target_id, d, storeItem, amount, function(itemSold)
                                                        if itemSold then
                                                            CORRUPT.notify(source,{"~g~"..CORRUPT.getPlayerName(target).." has bought a " ..itemName.. " for £"..getMoneyStringFormatted(amount)})
                                                            CORRUPT.notify(target,{"~g~You have bought a " ..itemName.. " for £"..getMoneyStringFormatted(amount)})
                                                        end
                                                    end)
                                                else
                                                    CORRUPT.notify(source,{"~r~"..CORRUPT.getPlayerName(target).." has refused to buy a " ..itemName.. " for £"..getMoneyStringFormatted(amount)})
                                                    CORRUPT.notify(target,{"~r~You have refused to buy a " ..itemName.. " for £"..getMoneyStringFormatted(amount)})
                                                end
                                            end)
                                        else
                                            CORRUPT.notify(source,{"~r~Price of item must be a number."})
                                        end
                                    end)
                                else
                                    CORRUPT.notify(source,{"~r~That Perm ID seems to be invalid!"})
                                end
                            else
                                CORRUPT.notify(source,{"~r~No Perm ID selected!"})
                            end
                        end)
                    else
                        CORRUPT.notify(source,{"~r~No players nearby!"})
                    end
                end)
            end
        end
    end)
end)

RegisterNetEvent("CORRUPT:setInVehicleTestingBucket")
AddEventHandler("CORRUPT:setInVehicleTestingBucket", function(state)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getStoreOwned(user_id, function(storeOwned)
        if storeOwned then
            if state then 
                CORRUPT.setBucket(source, 200)
            else
                CORRUPT.setBucket(source, 0)
            end
        end
    end)
end)