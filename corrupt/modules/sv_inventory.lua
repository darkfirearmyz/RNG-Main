

local Inventory = module("corrupt-assets", "cfg/cfg_inventory")
local Housing = module("cfg/homes")
local InventorySpamTrack = {}
local LootBagEntities = {}
local InventoryCoolDown = {}
local a = module("corrupt-assets", "cfg/weapons")
local WeaponConfig = a.weapons
local AmmoItems = {
    ["9mm"] = true,
    ["12gauge"] = true,
    [".308"] = true,
    ["7.62"] = true,
    ["5.56"] = true,
    [".357"] = true,
    ["p5.56mm"] = true,
    ["p.308"] = true,
    ["p9mm"] = true,
    ["p12gauge"] = true
}


function weaponclass(name)
    name = string.gsub(name, "wbody|", "")
    if name == "WEAPON_MOSIN" then
        return "Heavy"
    end
    local weapon = WeaponConfig[name]
    return weapon.class or "none"
end

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        if not InventorySpamTrack[source] then
            InventorySpamTrack[source] = true;
            local user_id = CORRUPT.getUserId(source) 
            local data = CORRUPT.getUserDataTable(user_id)
            if data and data.inventory then
                local FormattedInventoryData = {}
                for i,v in pairs(data.inventory) do
                    FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                end
                TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
                InventorySpamTrack[source] = false;
            end
        end
    end
end)

RegisterNetEvent('CORRUPT:FetchPersonalInventory')
AddEventHandler('CORRUPT:FetchPersonalInventory', function()
    local source = source
    if not InventorySpamTrack[source] then
        InventorySpamTrack[source] = true;
        local user_id = CORRUPT.getUserId(source) 
        local data = CORRUPT.getUserDataTable(user_id)
        if data and data.inventory then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
            end
            TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
            InventorySpamTrack[source] = false;
        end
    end
end)


AddEventHandler('CORRUPT:RefreshInventory', function(source)
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
        end
        TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    end
end)

RegisterNetEvent('CORRUPT:GiveItem')
AddEventHandler('CORRUPT:GiveItem', function(itemId, itemLoc)
    local source = source
    if not itemId then  CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        CORRUPT.RunGiveTask(source, itemId)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)
RegisterNetEvent('CORRUPT:GiveItemAll')
AddEventHandler('CORRUPT:GiveItemAll', function(itemId, itemLoc)
    local source = source
    if not itemId then  CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        CORRUPT.RunGiveAllTask(source, itemId)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to give it.'})
    end
end)

RegisterNetEvent('CORRUPT:TrashItem')
AddEventHandler('CORRUPT:TrashItem', function(itemId, itemLoc)
    local source = source
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before trashing more items.'}) return end
    if not itemId then  CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if not CORRUPT.isDeveloper(CORRUPT.getUserId(source)) then
        InventoryCoolDown[source] = true;
    end
    if itemLoc == "Plr" then
        CORRUPT.RunTrashTask(source, itemId)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
    Wait(5000)
    InventoryCoolDown[source] = false;
end)
RegisterNetEvent('CORRUPT:TrashItemAll')
AddEventHandler('CORRUPT:TrashItemAll', function(itemId, itemLoc)
    local source = source
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before dropping more items.'}) return end
    if not itemId then  CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if not CORRUPT.isDeveloper(CORRUPT.getUserId(source)) then
        InventoryCoolDown[source] = true;
    end
    if itemLoc == "Plr" then
        CORRUPT.RunTrashAllTask(source, itemId)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
    Wait(5000)
    InventoryCoolDown[source] = false;
end)



RegisterNetEvent('CORRUPT:TrashItemAllNui')
AddEventHandler('CORRUPT:TrashItemAllNui', function(itemId, itemLoc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if InventoryCoolDown[source] then
        CORRUPT.notify(source, {'~r~Please wait before dropping more items.'})
        return
    end
    if not itemId then
        CORRUPT.notify(source, {'~r~You need to select an item, first!'})
        return
    end
    if not CORRUPT.isDeveloper(CORRUPT.getUserId(source)) then
        InventoryCoolDown[source] = true
    end
    if itemLoc == "Plr" then
        if CORRUPT.getInventoryItemAmount(user_id, idname) > 1 then 
            local amount = CORRUPT.getInventoryItemAmount(user_id, idname)
            if CORRUPT.tryGetInventoryItem(user_id, idname, amount, false) then
                TriggerEvent('CORRUPT:RefreshInventory', source)
                CORRUPT.TrashLootBag(idname, amount, source)
                CORRUPT.notify(source, {lang.inventory.trash.done({CORRUPT.getItemName(idname), amount})})
                CORRUPTclient.playAnim(source, {true, {{"pickup_object", "pickup_low", 1}}, false})
            else
                CORRUPT.notify(source, {lang.common.invalid_value()})
            end
        end
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
    Wait(5000)
    InventoryCoolDown[source] = false
end)

RegisterNetEvent('CORRUPT:TrashItemNui')
AddEventHandler('CORRUPT:TrashItemNui', function(itemId, itemLoc, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if InventoryCoolDown[source] then
        CORRUPT.notify(source, {'~r~Please wait before dropping more items.'})
        return
    end
    if not itemId then
        CORRUPT.notify(source, {'~r~You need to select an item, first!'})
        return
    end
    if not CORRUPT.isDeveloper(CORRUPT.getUserId(source)) then
        InventoryCoolDown[source] = true
    end
    if itemLoc == "Plr" then
        if CORRUPT.getInventoryItemAmount(user_id, idname) > 1 then 
            local amount = parseInt(amount)
            if CORRUPT.tryGetInventoryItem(user_id, idname, amount, false) then
                TriggerEvent('CORRUPT:RefreshInventory', source)
                CORRUPT.TrashLootBag(idname, amount, source)
                CORRUPT.notify(source, {lang.inventory.trash.done({CORRUPT.getItemName(idname), amount})})
                CORRUPTclient.playAnim(source, {true, {{"pickup_object", "pickup_low", 1}}, false})
            else
                CORRUPT.notify(source, {lang.common.invalid_value()})
            end
        end
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to drop it.'})
    end
    Wait(5000)
    InventoryCoolDown[source] = false
end)


function CORRUPT.TrashLootBag(item, amount, source)
    local model = `xs_prop_arena_bag_01` -- change to trash bag
    local coords = GetEntityCoords(GetPlayerPed(source))
    local closestBag = nil
    local closestDistance = 4.0 
    for netId, bag in pairs(LootBagEntities) do
        if bag.isTrashbag then
            local bagCoords = GetEntityCoords(bag[1])
            local distance = #(coords - bagCoords)
            if distance < closestDistance then
                closestBag = netId
                closestDistance = distance
            end
        end
    end
    if closestBag == nil then
        local lootbag = CreateObjectNoOffset(`xm_prop_x17_bag_01a`, coords - 0.9, true, true, false)
        local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
        TriggerClientEvent("CORRUPT:floatTrashBag", -1, lootbagnetid)
        SetEntityRoutingBucket(lootbag, GetPlayerRoutingBucket(source))
        LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source, isTrashbag = true}
        LootBagEntities[lootbagnetid].Items = {}
        LootBagEntities[lootbagnetid].Items[item] = {amount = amount}
        LootBagEntities[lootbagnetid].name = CORRUPT.getPlayerName(source)
    else
        if LootBagEntities[closestBag].Items[item] then
            LootBagEntities[closestBag].Items[item].amount = LootBagEntities[closestBag].Items[item].amount + amount
        else
            LootBagEntities[closestBag].Items[item] = {amount = amount}
        end
    end
end

RegisterServerEvent("CORRUPT:LootBagCallBackEntity")
AddEventHandler("CORRUPT:LootBagCallBackEntity", function(ServerSideID, EntityID)
    local source = source
    local entity = NetworkGetEntityFromNetworkId(EntityID)
end)

RegisterNetEvent('CORRUPT:RequestGive')
AddEventHandler('CORRUPT:RequestGive', function(itemId, amount)
    print(itemId, amount)
    local source = source
    if not itemId then  
        CORRUPT.notify(source, {'~r~You need to select an item first!'}) 
        return 
    end
    local user_id = CORRUPT.getUserId(source)
    if amount == nil then 
        amount = CORRUPT.getInventoryItemAmount(user_id, itemId)
    end
    if CORRUPT.getInventoryItemAmount(user_id, itemId) >= amount then
        CORRUPTclient.getNearestPlayers(source, {10}, function(nearbyPlayers)
            local numPlayers = 0
            local user_list = {}
            for k, v in pairs(nearbyPlayers) do
                numPlayers = numPlayers + 1
                user_list[#user_list + 1] = {permId = CORRUPT.getUserId(k), name = CORRUPT.getPlayerName(k), source = k}
            end
            if numPlayers == 0 then
                CORRUPT.notify(source, {'~r~No players nearby.'})
            else
                TriggerClientEvent('CORRUPT:OpenGiveNui', source, itemId, amount, user_list)
            end
        end)
    else
        CORRUPT.notify(source, {'~r~Invalid amount.'})
    end
end)

RegisterServerEvent("CORRUPT:GiveItemNui")
AddEventHandler("CORRUPT:GiveItemNui", function(target_user_id, item, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_user_id)
    if target_user_id == user_id then
        CORRUPT.notify(source, {'~r~You cannot give items to yourself.'})
        return
    end
    if CORRUPT.tryGetInventoryItem(user_id, item, amount, true) then
        CORRUPT.giveInventoryItem(target_user_id, item, amount, true)
        TriggerEvent('CORRUPT:RefreshInventory', source)
        TriggerEvent('CORRUPT:RefreshInventory', target_source)
        CORRUPTclient.playAnim(source, { true, { { "mp_common", "givetake1_a", 1 } }, false })
        CORRUPTclient.playAnim(target_source, { true, { { "mp_common", "givetake2_a", 1 } }, false })
    else
        CORRUPT.notify(source, {'~r~You do not have enough of this item.'})
    end
end)






RegisterNetEvent('CORRUPT:FetchTrunkInventory')
AddEventHandler('CORRUPT:FetchTrunkInventory', function(spawnCode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before moving more items.'}) return end
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    CORRUPT.getSData(carformat, function(cdata)
        local processedChest = {};
        cdata = json.decode(cdata) or {}
        local FormattedInventoryData = {}
        for i, v in pairs(cdata) do
            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    end)
end)


RegisterNetEvent('CORRUPT:viewTrunk')
AddEventHandler('CORRUPT:viewTrunk', function(spawnCode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    CORRUPT.getSData(carformat, function(cdata)
        cdata = json.decode(cdata) or {}
        local AmmoTable = {}
        local OtherTable = {}
        local WeaponTable = {}
        
        for i, v in pairs(cdata) do
            local itemName = CORRUPT.getItemName(i)
            if string.find(i, "wbody") then
                table.insert(WeaponTable, {
                    amount = v.amount,
                    WeaponName = itemName
                })
            elseif AmmoItems[itemName] then
                table.insert(AmmoTable, {
                    amount = v.amount,
                    AmmoName = itemName
                })
            else
                table.insert(OtherTable, {
                    amount = v.amount,
                    name = itemName
                })
            end
        end
        local maxVehKg = Inventory.vehicle_chest_weights[spawnCode] or Inventory.default_vehicle_chest_weight
        local totalWeight = CORRUPT.computeItemsWeight(cdata)
        
        local viewTrunk = {
            Ammo = AmmoTable,
            Weapons = WeaponTable,
            Other = OtherTable,
        }
        
        TriggerClientEvent("CORRUPT:ReturnFetchedCarsBoot", source, viewTrunk)
    end)
end)


RegisterNetEvent('CORRUPT:WipeBoot')
AddEventHandler('CORRUPT:WipeBoot', function(spawnCode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local carformat = "chest:u1veh_" .. spawnCode .. '|' .. user_id
    CORRUPT.prompt(source, "Please replace text with YES or NO to confirm", "Wipe Boot For Vehicle: " .. spawnCode, function(source, wipeboot)
        if string.upper(wipeboot) == 'YES' then
            CORRUPT.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                for i, v in pairs(cdata) do
                    cdata[i] = nil
                end
                CORRUPT.setSData(carformat, json.encode(cdata))
                TriggerEvent('CORRUPT:RefreshInventory', source)
                CORRUPT.notify(source, {'~g~You have wiped the boot of this vehicle.'})
            end)
        else
            CORRUPT.notify(source, {'~r~You did not confirm the wipe.'})
        end
    end)
end)








local inHouse = {}
RegisterNetEvent('CORRUPT:FetchHouseInventory')
AddEventHandler('CORRUPT:FetchHouseInventory', function(nameHouse)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    getUserByAddress(nameHouse, 1, function(huser_id)
        if huser_id == user_id then
            inHouse[user_id] = nameHouse
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            CORRUPT.getSData(homeformat, function(cdata)
                local processedChest = {};
                cdata = json.decode(cdata) or {}
                local FormattedInventoryData = {}
                for i, v in pairs(cdata) do
                    FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                end
                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
            end)
        else
            CORRUPT.notify(player,{"~r~You do not own this house!"})
        end
    end)
end)

local currentlySearching = {}

RegisterNetEvent('CORRUPT:cancelPlayerSearch')
AddEventHandler('CORRUPT:cancelPlayerSearch', function()
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    if currentlySearching[user_id] ~= nil then
        TriggerClientEvent('CORRUPT:cancelPlayerSearch', currentlySearching[user_id])
    end
end)

RegisterNetEvent('CORRUPT:searchPlayer')
AddEventHandler('CORRUPT:searchPlayer', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)
    local their_id = CORRUPT.getUserId(playersrc) 
    local their_data = CORRUPT.getUserDataTable(their_id)
    if data and data.inventory and not currentlySearching[user_id] then
        currentlySearching[user_id] = playersrc
        TriggerClientEvent('CORRUPT:startSearchingSuspect', source)
        TriggerClientEvent('CORRUPT:startBeingSearching', playersrc, source)
        CORRUPT.notify(playersrc, {'~b~You are being searched.'})
        Wait(10000)
        if currentlySearching[user_id] then
            local FormattedInventoryData = {}
            for i,v in pairs(data.inventory) do
                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
            end
            exports['corrupt']:execute("SELECT * FROM corrupt_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                if #vipClubData > 0 then
                    if their_data and their_data.inventory then
                        local FormattedSecondaryInventoryData = {}
                        for i,v in pairs(their_data.inventory) do
                            FormattedSecondaryInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        if CORRUPT.getMoney(their_id) then
                            FormattedSecondaryInventoryData['cash'] = {amount = CORRUPT.getMoney(their_id), name = 'Cash', weight = 0.00}
                        end
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedSecondaryInventoryData, CORRUPT.computeItemsWeight(their_data.inventory), 200)
                    end
                    if vipClubData[1].plathours > 0 then
                        TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id)+20)
                    elseif vipClubData[1].plushours > 0 then
                        TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id)+10)
                    else
                        TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
                    end
                    TriggerClientEvent('CORRUPT:InventoryOpen', source, true)
                    currentlySearching[user_id] = nil
                end
            end)
        end
    end
end)

RegisterNetEvent('CORRUPT:robPlayer')
AddEventHandler('CORRUPT:robPlayer', function(playersrc)
    local source = source
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    CORRUPTclient.isPlayerSurrendered(playersrc, {}, function(is_surrendering) 
        if is_surrendering then
            if not InventorySpamTrack[source] then
                InventorySpamTrack[source] = true;
                local user_id = CORRUPT.getUserId(source) 
                local data = CORRUPT.getUserDataTable(user_id)
                local their_id = CORRUPT.getUserId(playersrc) 
                local their_data = CORRUPT.getUserDataTable(their_id)
                if data and data.inventory then
                    local FormattedInventoryData = {}
                    for i,v in pairs(data.inventory) do
                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                    end
                    exports['corrupt']:execute("SELECT * FROM corrupt_subscriptions WHERE user_id = @user_id", {user_id = user_id}, function(vipClubData)
                        if #vipClubData > 0 then
                            if their_data and their_data.inventory then
                                local FormattedSecondaryInventoryData = {}
                                for i,v in pairs(their_data.inventory) do
                                    CORRUPT.giveInventoryItem(user_id, i, v.amount)
                                    CORRUPT.tryGetInventoryItem(their_id, i, v.amount)
                                end
                            end
                            if CORRUPT.getMoney(their_id) > 0 then
                                CORRUPT.giveMoney(user_id, CORRUPT.getMoney(their_id))
                                CORRUPT.tryPayment(their_id, CORRUPT.getMoney(their_id))
                            end
                            if vipClubData[1].plathours > 0 then
                                TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id)+20)
                            elseif vipClubData[1].plushours > 0 then
                                TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id)+10)
                            else
                                TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
                            end
                            TriggerClientEvent('CORRUPT:InventoryOpen', source, true)
                            InventorySpamTrack[source] = false;
                        end
                    end)
                end
            end
        end
    end)
end)
RegisterNetEvent('CORRUPT:UseItem')
AddEventHandler('CORRUPT:UseItem', function(itemId, itemLoc, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    local data = CORRUPT.getUserDataTable(user_id)
    if not itemId then CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                local invcap = 30
                if CORRUPT.isDeveloper(user_id) then
                    invcap = 1000
                elseif plathours > 0 then
                    invcap = 50
                elseif plushours > 0 then
                    invcap = 40
                end
                if CORRUPT.getInventoryMaxWeight(user_id) ~= nil then
                    if CORRUPT.getInventoryMaxWeight(user_id) > invcap then
                        return
                    end
                end
                if itemId == "Off White Bag (+15kg)" then
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+15)
                    TriggerClientEvent('CORRUPT:boughtBackpack', source, 5, 92, 0,40000,15, 'Off White Bag (+15kg)')
                elseif itemId == "Gucci Bag (+20kg)" then 
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+20)
                    TriggerClientEvent('CORRUPT:boughtBackpack', source, 5, 94, 0,60000,20, 'Gucci Bag (+20kg)')
                elseif itemId == "Nike Bag (+30kg)" then 
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+30)
                elseif itemId == "Hunting Backpack (+35kg)" then 
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+35)
                    TriggerClientEvent('CORRUPT:boughtBackpack', source, 5, 91, 0,100000,35, 'Hunting Backpack (+35kg)')
                elseif itemId == "Green Hiking Backpack (+40kg)" then 
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+40)
                elseif itemId == "Rebel Backpack (+70kg)" then 
                    CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true)
                    CORRUPT.updateInvCap(user_id, invcap+70)
                    TriggerClientEvent('CORRUPT:boughtBackpack', source, 5, 90, 0,250000,70, 'Rebel Backpack (+70kg)')
                elseif itemId == "electric_shaver" then 
                    CORRUPT.ShaveHead(source)
                elseif itemId == "keys" then 
                    CORRUPT.handcuffKeys(source)
                elseif itemId == "cuffs" then 
                    CORRUPT.handcuff(source)
                elseif itemId == "burner_phone" then
                    CORRUPT.BurnerPhone(source)
                elseif itemId == "armourplate" then 
                    CORRUPT.ArmourPlate(source)
                end
                TriggerEvent('CORRUPT:RefreshInventory', source)
            end
        end)  
    end
    if itemLoc == "Plr" then
        CORRUPT.RunInventoryTask(source, itemId, amount)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)

RegisterNetEvent('CORRUPT:UseAllItem')
AddEventHandler('CORRUPT:UseAllItem', function(itemId, itemLoc)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if not itemId then CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if itemLoc == "Plr" then
        CORRUPT.LoadAllTask(source, itemId)
        TriggerEvent('CORRUPT:RefreshInventory', source)
    else
        CORRUPT.notify(source, {'~r~You need to have this item on you to use it.'})
    end
end)


RegisterNetEvent('CORRUPT:MoveItem')
AddEventHandler('CORRUPT:MoveItem', function(inventoryType, itemId, inventoryInfo, Lootbag)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if CORRUPT.isPurge() then return end
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            CORRUPT.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+CORRUPT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        CORRUPT.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = false;
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = false;
                end
            end)
        elseif inventoryType == "LootBag" then  
            if itemId ~= nil then  
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+CORRUPT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > 1 then
                            LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - 1 
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        end
                        local FormattedInventoryData = {}
                        for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        local maxVehKg = 200
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        InventoryCoolDown[source] = false
                        if not next(LootBagEntities[inventoryInfo].Items) then
                            CloseInv(source)
                        end
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            InventoryCoolDown[source] = true
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            CORRUPT.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount >= 1 then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+CORRUPT.getItemWeight(itemId)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if cdata[itemId].amount > 1 then
                            cdata[itemId].amount = cdata[itemId].amount - 1; 
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        else 
                            cdata[itemId] = nil;
                            CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
                        end 
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        InventoryCoolDown[source] = false;
                        CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end)
        elseif inventoryType == "Crate" then
            if CrateDropItems[itemId] and 1 <= CrateDropItems[itemId].amount  then
            local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * 1)
            if weightCalculation == nil then return end
            if CrateDropItems[itemId].amount > 1 then
                CrateDropItems[itemId] = {amount = CrateDropItems[itemId].amount - 1}
                CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
            else 
                CrateDropItems[itemId] = nil;
                CORRUPT.giveInventoryItem(user_id, itemId, 1, true)
            end 
            local FormattedInventoryData = {}
            for i, v in pairs(CrateDropItems) do
                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
            end
            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
            TriggerEvent('CORRUPT:RefreshInventory', source)
            if not next(CrateDropItems) then
                TriggerClientEvent("CORRUPT:removeLootcrate", -1, getNearestactiveCratesID(source))
                TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
                CloseInv(source)
            end
            InventoryCoolDown[source] = false;
        else 
            CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
        end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitem)
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        CORRUPT.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = CORRUPT.computeItemsWeight(cdata)+CORRUPT.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('CORRUPT:RefreshInventory', source)
                                    CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                    InventoryCoolDown[source] = false;
                                else 
                                    CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            end
                        end) --end of housing intergration (moveitem)
                    elseif inventoryInfo == "crate" then
                        if data.inventory[itemId] and 1 <= data.inventory[itemId].amount  then
                            local weightCalculation = CORRUPT.computeItemsWeight(CrateDropItems)+(CORRUPT.getItemWeight(itemId) * 1)
                            if weightCalculation == nil then return end
                            if CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true) then
                                if CrateDropItems[itemId] then
                                    CrateDropItems[itemId] = {amount = CrateDropItems[itemId].amount + 1}
                                else 
                                    CrateDropItems[itemId] = {}
                                    CrateDropItems[itemId] = {amount = 1}
                                end
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(CrateDropItems) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            InventoryCoolDown[source] = false;
                        else 
                            CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        CORRUPT.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount >= 1 then
                                local weightCalculation = CORRUPT.computeItemsWeight(cdata)+CORRUPT.getItemWeight(itemId)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if CORRUPT.tryGetInventoryItem(user_id, itemId, 1, true) then
                                        if cdata[itemId] then
                                        cdata[itemId].amount = cdata[itemId].amount + 1
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = 1
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('CORRUPT:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    CORRUPT.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
    end
end)



RegisterNetEvent('CORRUPT:MoveItemX')
AddEventHandler('CORRUPT:MoveItemX', function(inventoryType, itemId, inventoryInfo, Lootbag, Quantity)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if CORRUPT.isPurge() then return end
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before moving more items.'}) return end
    if not itemId then  CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            if Quantity >= 1 then
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                CORRUPT.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            CORRUPT.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        InventoryCoolDown[source] = nil;
                        CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else
                InventoryCoolDown[source] = nil;
                CORRUPT.notify(source, {'~r~Invalid Amount!'})
            end
        elseif inventoryType == "LootBag" then    
            if LootBagEntities[inventoryInfo].Items[itemId] then 
                Quantity = parseInt(Quantity)
                if Quantity then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * Quantity)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if Quantity <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            if LootBagEntities[inventoryInfo].Items[itemId] and LootBagEntities[inventoryInfo].Items[itemId].amount > Quantity then
                                LootBagEntities[inventoryInfo].Items[itemId].amount = LootBagEntities[inventoryInfo].Items[itemId].amount - Quantity
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                LootBagEntities[inventoryInfo].Items[itemId] = nil;
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            end
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    CORRUPT.notify(source, {'~r~Invalid input!'})
                end
            end
        elseif inventoryType == "Housing" then
            Quantity = parseInt(Quantity)
            if Quantity then
                local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                CORRUPT.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    if cdata[itemId] and Quantity <= cdata[itemId].amount  then
                        local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * Quantity)
                        if weightCalculation == nil then return end
                        if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                            if cdata[itemId].amount > Quantity then
                                cdata[itemId].amount = cdata[itemId].amount - Quantity; 
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            else 
                                cdata[itemId] = nil;
                                CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                            InventoryCoolDown[source] = false;
                        else 
                            CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    else 
                        CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                    end
                end)
            else 
                CORRUPT.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Crate" then
            Quantity = parseInt(Quantity)
            if Quantity then
                if CrateDropItems[itemId] and Quantity <= CrateDropItems[itemId].amount  then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * Quantity)
                if weightCalculation == nil then return end
                    if CrateDropItems[itemId].amount > Quantity then
                        CrateDropItems[itemId] = {amount = CrateDropItems[itemId].amount - Quantity}
                        CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                    else 
                        CrateDropItems[itemId] = nil;
                        CORRUPT.giveInventoryItem(user_id, itemId, Quantity, true)
                    end 
                    local FormattedInventoryData = {}
                    for i, v in pairs(CrateDropItems) do
                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                    end
                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
                    TriggerEvent('CORRUPT:RefreshInventory', source)
                    if not next(CrateDropItems) then
                        TriggerClientEvent("CORRUPT:removeLootcrate", -1, getNearestactiveCratesID(source))
                        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
                        CloseInv(source)
                    end
                    InventoryCoolDown[source] = false;
                else 
                    CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            else 
                CORRUPT.notify(source, {'~r~Invalid input!'})
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then --start of housing intergration (moveitemx)
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                            CORRUPT.getSData(homeFormat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = CORRUPT.computeItemsWeight(cdata)+(CORRUPT.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    if weightCalculation <= maxVehKg then
                                        if CORRUPT.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                        end
                                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('CORRUPT:RefreshInventory', source)
                                        CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                        InventoryCoolDown[source] = false;
                                    else 
                                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            CORRUPT.notify(source, {'~r~Invalid input!'})
                        end
                    elseif inventoryInfo == "crate" then
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                local weightCalculation = CORRUPT.computeItemsWeight(CrateDropItems)+(CORRUPT.getItemWeight(itemId) * Quantity)
                                if weightCalculation == nil then return end
                                if CORRUPT.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                    if CrateDropItems[itemId] then
                                        CrateDropItems[itemId] = {amount = CrateDropItems[itemId].amount + Quantity}
                                    else 
                                        CrateDropItems[itemId] = {}
                                        CrateDropItems[itemId] = {amount = Quantity}
                                    end
                                end 
                                local FormattedInventoryData = {}
                                for i, v in pairs(CrateDropItems) do
                                    FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                end
                                TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
                                TriggerEvent('CORRUPT:RefreshInventory', source)
                                InventoryCoolDown[source] = false;
                            else 
                                CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        else 
                            CORRUPT.notify(source, {'~r~Invalid input!'})
                        end
                    else
                        InventoryCoolDown[source] = true;
                        Quantity = parseInt(Quantity)
                        if Quantity then
                            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                            CORRUPT.getSData(carformat, function(cdata)
                                cdata = json.decode(cdata) or {}
                                if data.inventory[itemId] and Quantity <= data.inventory[itemId].amount  then
                                    local weightCalculation = CORRUPT.computeItemsWeight(cdata)+(CORRUPT.getItemWeight(itemId) * Quantity)
                                    if weightCalculation == nil then return end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    if weightCalculation <= maxVehKg then
                                        if CORRUPT.tryGetInventoryItem(user_id, itemId, Quantity, true) then
                                            if cdata[itemId] then
                                                cdata[itemId].amount = cdata[itemId].amount + Quantity
                                            else 
                                                cdata[itemId] = {}
                                                cdata[itemId].amount = Quantity
                                            end
                                        end 
                                        local FormattedInventoryData = {}
                                        for i, v in pairs(cdata) do
                                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                        end
                                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                        TriggerEvent('CORRUPT:RefreshInventory', source)
                                        InventoryCoolDown[source] = nil;
                                        CORRUPT.setSData(carformat, json.encode(cdata))
                                    else 
                                        InventoryCoolDown[source] = nil;
                                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                    end
                                else 
                                    InventoryCoolDown[source] = nil;
                                    CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                                end
                            end)
                        else 
                            CORRUPT.notify(source, {'~r~Invalid input!'})
                        end
                    end
                end
            end
        end
    end
end)


RegisterNetEvent('CORRUPT:MoveItemAll')
AddEventHandler('CORRUPT:MoveItemAll', function(inventoryType, itemId, inventoryInfo, vehid)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    local data = CORRUPT.getUserDataTable(user_id)
    if CORRUPT.isPurge() then return end
    if not itemId then CORRUPT.notify(source, {'~r~You need to select an item, first!'}) return end
    if InventoryCoolDown[source] then CORRUPT.notify(source, {'~r~Please wait before moving more items.'}) return end
    if data and data.inventory then
        if inventoryInfo == nil then return end
        if inventoryType == "CarBoot" then
            InventoryCoolDown[source] = true;
            local idz = NetworkGetEntityFromNetworkId(vehid)
            local user_id = CORRUPT.getUserId(NetworkGetEntityOwner(idz))
            local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
            CORRUPT.getSData(carformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    local amount = cdata[itemId].amount
                    if weightCalculation > CORRUPT.getInventoryMaxWeight(user_id) and CORRUPT.getInventoryWeight(user_id) ~= CORRUPT.getInventoryMaxWeight(user_id) then
                        amount = math.floor((CORRUPT.getInventoryMaxWeight(user_id)-CORRUPT.getInventoryWeight(user_id)) / CORRUPT.getItemWeight(itemId))
                    end
                    if math.floor(amount) > 0 or (weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id)) then
                        CORRUPT.giveInventoryItem(user_id, itemId, amount, true)
                        local FormattedInventoryData = {}
                        if (cdata[itemId].amount - amount) > 0 then
                            cdata[itemId].amount = cdata[itemId].amount - amount
                        else
                            cdata[itemId] = nil
                        end
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        InventoryCoolDown[source] = nil;
                        CORRUPT.setSData(carformat, json.encode(cdata))
                    else 
                        InventoryCoolDown[source] = nil;
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    InventoryCoolDown[source] = nil;
                    CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "LootBag" then
            if itemId ~= nil then    
                if LootBagEntities[inventoryInfo].Items[itemId] then 
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) *  LootBagEntities[inventoryInfo].Items[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if  LootBagEntities[inventoryInfo].Items[itemId].amount <= LootBagEntities[inventoryInfo].Items[itemId].amount then 
                            CORRUPT.giveInventoryItem(user_id, itemId, LootBagEntities[inventoryInfo].Items[itemId].amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), maxVehKg)                
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else 
                            CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Housing" then
            local homeformat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
            CORRUPT.getSData(homeformat, function(cdata)
                cdata = json.decode(cdata) or {}
                if cdata[itemId] and cdata[itemId].amount <= cdata[itemId].amount  then
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) * cdata[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        CORRUPT.giveInventoryItem(user_id, itemId, cdata[itemId].amount, true)
                        cdata[itemId] = nil;
                        local FormattedInventoryData = {}
                        for i, v in pairs(cdata) do
                            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                        end
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                else 
                    CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                end
            end)
        elseif inventoryType == "Crate" then
            if itemId ~= nil then
                if CrateDropItems[itemId] then 
                    local weightCalculation = CORRUPT.getInventoryWeight(user_id)+(CORRUPT.getItemWeight(itemId) *  CrateDropItems[itemId].amount)
                    if weightCalculation == nil then return end
                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        if  CrateDropItems[itemId].amount <= CrateDropItems[itemId].amount then 
                            CORRUPT.giveInventoryItem(user_id, itemId, CrateDropItems[itemId].amount, true)
                            CrateDropItems[itemId] = nil;
                            local FormattedInventoryData = {}
                            for i, v in pairs(CrateDropItems) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = 200
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), maxVehKg)                
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            if not next(CrateDropItems) then
                                TriggerClientEvent("CORRUPT:removeLootcrate", -1, getNearestactiveCratesID(source))
                                TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "Crate drop has been looted.", "alert")
                                CloseInv(source)
                            end
                        else 
                            CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                        end 
                    else 
                        CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                    end
                end
            end
        elseif inventoryType == "Plr" then
            if not Lootbag then
                if data.inventory[itemId] then
                    if inventoryInfo == "home" then
                        local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                        CORRUPT.getSData(homeFormat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = CORRUPT.computeItemsWeight(cdata)+(CORRUPT.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                if weightCalculation <= maxVehKg then
                                    if CORRUPT.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end 
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('CORRUPT:RefreshInventory', source)
                                    CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                                else 
                                    CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    elseif inventoryInfo == "crate" then
                        if data.inventory[itemId] and data.inventory[itemId].amount > 0 then
                            local itemAmount = data.inventory[itemId].amount
                        
                            if CORRUPT.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                CrateDropItems[itemId] = {
                                    amount = (CrateDropItems[itemId] and CrateDropItems[itemId].amount or 0) + itemAmount
                                }
                        
                                local FormattedInventoryData = {}
                                for i, v in pairs(CrateDropItems) do
                                    FormattedInventoryData[i] = {amount = v.amount,name = CORRUPT.getItemName(i),weight = CORRUPT.getItemWeight(i)}
                                end
                                TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
                                TriggerEvent('CORRUPT:RefreshInventory', source)
                            else
                                CORRUPT.notify(source, {'~r~You are trying to move more than there actually is!'})
                            end
                        end        
                    else 
                        InventoryCoolDown[source] = true;
                        local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                        CORRUPT.getSData(carformat, function(cdata)
                            cdata = json.decode(cdata) or {}
                            if data.inventory[itemId] and data.inventory[itemId].amount <= data.inventory[itemId].amount  then
                                local itemAmount = data.inventory[itemId].amount
                                local weightCalculation = CORRUPT.computeItemsWeight(cdata)+(CORRUPT.getItemWeight(itemId) * itemAmount)
                                if weightCalculation == nil then return end
                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                if weightCalculation <= maxVehKg then
                                    if CORRUPT.tryGetInventoryItem(user_id, itemId, itemAmount, true) then
                                        if cdata[itemId] then
                                            cdata[itemId].amount = cdata[itemId].amount + itemAmount
                                        else 
                                            cdata[itemId] = {}
                                            cdata[itemId].amount = itemAmount
                                        end
                                    end 
                                    local FormattedInventoryData = {}
                                    for i, v in pairs(cdata) do
                                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                                    end
                                    local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                    TriggerEvent('CORRUPT:RefreshInventory', source)
                                    InventoryCoolDown[source] = nil;
                                    CORRUPT.setSData(carformat, json.encode(cdata))
                                else 
                                    InventoryCoolDown[source] = nil;
                                    CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                                end
                            else 
                                InventoryCoolDown[source] = nil;
                                CORRUPT.notify(source, {'~r~You are trying to move more then there actually is!'})
                            end
                        end)
                    end
                else
                    InventoryCoolDown[source] = nil;
                end
            end
        end
    else 
        InventoryCoolDown[source] = nil;
    end
end)
RegisterNetEvent('CORRUPT:LootAll')
AddEventHandler('CORRUPT:LootAll', function(inventoryType, inventoryInfo, vehid)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)

    if CORRUPT.isPurge() then 
        return 
    end

    if InventoryCoolDown[source] then 
        CORRUPT.notify(source, {'~r~Please wait before moving more items.'})
        return 
    end

    if data and data.inventory then
        if inventoryInfo == nil then 
            return 
        end

        if data.inventory then
            if inventoryType == "CarBoot" then
                InventoryCoolDown[source] = true;
                local idz = NetworkGetEntityFromNetworkId(vehid)
                local owner_id = CORRUPT.getUserId(NetworkGetEntityOwner(idz))
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. owner_id

                CORRUPT.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}

                    for itemId, itemData in pairs(cdata) do
                        local weightCalculation = CORRUPT.getInventoryWeight(owner_id) + (CORRUPT.getItemWeight(itemId) * itemData.amount)

                        if weightCalculation == nil then 
                            return 
                        end

                        if weightCalculation <= CORRUPT.getInventoryMaxWeight(owner_id) then
                            for k, v in pairs(cdata) do
                                CORRUPT.giveInventoryItem(owner_id, k, v.amount, true)
                                cdata[k] = nil;

                                local FormattedInventoryData = {}

                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = { amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i) }
                                end

                                local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                                TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                TriggerEvent('CORRUPT:RefreshInventory', source)
                                Wait(250)
                            end

                            InventoryCoolDown[source] = nil;
                            CORRUPT.setSData(carformat, json.encode(cdata))
                        else 
                            InventoryCoolDown[source] = nil;
                            CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    end
                end)
            elseif inventoryType == "LootBag" then   
                if LootBagEntities[inventoryInfo] and LootBagEntities[inventoryInfo].Items then
                    local weightCalculation = 0

                    for k, v in pairs(LootBagEntities[inventoryInfo].Items) do
                        weightCalculation = weightCalculation + (CORRUPT.getItemWeight(k) * v.amount)
                    end

                    if weightCalculation == nil then 
                        return 
                    end

                    if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                        for itemId, itemData in pairs(LootBagEntities[inventoryInfo].Items) do
                            local amount = itemData.amount

                            if weightCalculation > CORRUPT.getInventoryMaxWeight(user_id) and CORRUPT.getInventoryWeight(user_id) ~= CORRUPT.getInventoryMaxWeight(user_id) then
                                amount = math.floor((CORRUPT.getInventoryMaxWeight(user_id) - CORRUPT.getInventoryWeight(user_id)) / CORRUPT.getItemWeight(itemId))
                            end

                            CORRUPT.giveInventoryItem(user_id, itemId, amount, true)
                            LootBagEntities[inventoryInfo].Items[itemId] = nil;

                            local FormattedInventoryData = {}

                            for i, v in pairs(LootBagEntities[inventoryInfo].Items) do
                                FormattedInventoryData[i] = { amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i) }
                            end

                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(LootBagEntities[inventoryInfo].Items), 200)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            Wait(250)
                        end

                        TriggerClientEvent('CORRUPT:closeSecondaryInventory', source)
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                        if LootBagEntities[inventoryInfo] and LootBagEntities[inventoryInfo].Items then
                            if not next(LootBagEntities[inventoryInfo].Items) then
                                CloseInv(source)
                            end
                        else
                            CloseInv(source)
                        end
                    else 
                        CORRUPT.notify(source, {'~r~You are trying to move more than there actually is!'})
                    end 
                else 
                    CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                end
            elseif inventoryType == "Housing" then
                local homeformat = "chest:u" .. user_id .. "home" .. inHouse[user_id]
                CORRUPT.getSData(homeformat, function(cdata)
                    cdata = json.decode(cdata) or {}

                    for itemID, itemData in pairs(cdata) do
                        local weightCalculation = CORRUPT.getInventoryWeight(user_id) + (CORRUPT.getItemWeight(itemID) * itemData.amount)

                        if weightCalculation == nil then 
                            return 
                        end

                        if weightCalculation <= CORRUPT.getInventoryMaxWeight(user_id) then
                            for k, v in pairs(cdata) do
                                CORRUPT.giveInventoryItem(user_id, k, v.amount, true)
                                cdata[k] = nil;

                                local FormattedInventoryData = {}

                                for i, v in pairs(cdata) do
                                    FormattedInventoryData[i] = { amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i) }
                                end

                                local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                                TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                                TriggerEvent('CORRUPT:RefreshInventory', source)
                                Wait(250)
                            end

                            CORRUPT.setSData("chest:u" .. user_id .. "home" .. inHouse[user_id], json.encode(cdata))
                        else 
                            CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    end
                end)
            end
        else
            InventoryCoolDown[source] = nil;
        end
    else 
        InventoryCoolDown[source] = nil;
    end
end)


RegisterNetEvent('CORRUPT:TransferAll')
AddEventHandler('CORRUPT:TransferAll', function(inventoryInfo, vehid)
    local source = source
    local user_id = CORRUPT.getUserId(source) 
    local data = CORRUPT.getUserDataTable(user_id)
    if CORRUPT.isPurge() then return end;
    if InventoryCoolDown[source] then 
        CORRUPT.notify(source, {'~r~Please wait before moving more items.'}) 
        return 
    end
    if data and data.inventory then
        if inventoryInfo == nil then return end;
        if data.inventory then
            if inventoryInfo == "home" then
                local homeFormat = "chest:u" .. user_id .. "home" ..inHouse[user_id]
                CORRUPT.getSData(homeFormat, function(cdata)
                    cdata = json.decode(cdata) or {}

                    for itemID, itemData in pairs(data.inventory) do
                        local itemAmount = itemData.amount
                        local weightCalculation = CORRUPT.computeItemsWeight(cdata) + (CORRUPT.getItemWeight(itemID) * itemAmount)
                        if weightCalculation == nil then return end;
                        local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                        if weightCalculation <= maxVehKg then
                            if CORRUPT.tryGetInventoryItem(user_id, itemID, itemAmount, true) then
                                if cdata[itemID] then
                                    cdata[itemID].amount = cdata[itemID].amount + itemAmount
                                else 
                                    cdata[itemID] = {}
                                    cdata[itemID].amount = itemAmount
                                end 
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = Housing.chestsize[inHouse[user_id]] or 500
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            CORRUPT.setSData("chest:u" .. user_id .. "home" ..inHouse[user_id], json.encode(cdata))
                            Wait(250)
                        end
                    end
                end)
            elseif inventoryInfo == "crate" then
                for itemID, itemData in pairs(data.inventory) do
                    local itemAmount = itemData.amount
                    local weightCalculation = CORRUPT.computeItemsWeight(CrateDropItems) + (CORRUPT.getItemWeight(itemID) * itemAmount)
                    if weightCalculation == nil then return end;
                    if CORRUPT.tryGetInventoryItem(user_id, itemID, itemAmount, true) then
                        if CrateDropItems[itemID] then
                            CrateDropItems[itemID].amount = CrateDropItems[itemID].amount + itemAmount
                        else 
                            CrateDropItems[itemID] = {}
                            CrateDropItems[itemID] = {amount = itemAmount}
                        end 
                    end 
                    local FormattedInventoryData = {}
                    for i, v in pairs(CrateDropItems) do
                        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                    end
                    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(CrateDropItems), 200)
                    TriggerEvent('CORRUPT:RefreshInventory', source)
                    Wait(250)
                end
            else
                InventoryCoolDown[source] = true;
                local carformat = "chest:u1veh_" .. inventoryInfo .. '|' .. user_id
                CORRUPT.getSData(carformat, function(cdata)
                    cdata = json.decode(cdata) or {}
                    for itemID, itemData in pairs(data.inventory) do
                        local itemAmount = itemData.amount
                        local weightCalculation = CORRUPT.computeItemsWeight(cdata) + (CORRUPT.getItemWeight(itemID) * itemAmount)
                        if weightCalculation == nil then return end;
                        local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                        if weightCalculation <= maxVehKg then
                            if CORRUPT.tryGetInventoryItem(user_id, itemID, itemAmount, true) then
                                if cdata[itemID] then
                                    cdata[itemID].amount = cdata[itemID].amount + itemAmount
                                else 
                                    cdata[itemID] = {}
                                    cdata[itemID].amount = itemAmount
                                end
                            end 
                            local FormattedInventoryData = {}
                            for i, v in pairs(cdata) do
                                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
                            end
                            local maxVehKg = Inventory.vehicle_chest_weights[inventoryInfo] or Inventory.default_vehicle_chest_weight
                            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            InventoryCoolDown[source] = nil;
                            CORRUPT.setSData(carformat, json.encode(cdata))
                            Wait(250)
                        else 
                            InventoryCoolDown[source] = nil;
                            CORRUPT.notify(source, {'~r~You do not have enough inventory space.'})
                        end
                    end
                end)
            end
        else
            InventoryCoolDown[source] = nil
        end
    else 
        InventoryCoolDown[source] = nil
    end
end)

RegisterNetEvent('CORRUPT:InComa')
AddEventHandler('CORRUPT:InComa', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local getPlayerBucket = GetPlayerRoutingBucket(source) or 0
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    CORRUPTclient.isInComa(source, {}, function(in_coma) 
        if in_coma then
            Wait(1500)
            local weight = CORRUPT.getInventoryWeight(user_id)
            if weight == 0 and CORRUPT.getInventoryItemAmount(user_id, "dirtycash") == 0 then return end
            local model = `xs_prop_arena_bag_01`
            local name1 = CORRUPT.getPlayerName(source)
            local lootbag = CreateObjectNoOffset(model, GetEntityCoords(GetPlayerPed(source)) + 0.5, true, true, false)
            local lootbagnetid = NetworkGetNetworkIdFromEntity(lootbag)
            TriggerClientEvent("CORRUPT:floatInvBag", -1, lootbagnetid)
            SetEntityRoutingBucket(lootbag, getPlayerBucket)
            local ndata = CORRUPT.getUserDataTable(user_id)
            if ndata ~= nil and ndata.inventory ~= nil then
                TriggerEvent('CORRUPT:StoreWeaponsRequest', source)
                LootBagEntities[lootbagnetid] = {lootbag, lootbag, false, source, Items = {}, name = name1}
                local stored_inventory = ndata.inventory
                CORRUPT.clearInventory(user_id)
                for k, v in pairs(stored_inventory) do
                    LootBagEntities[lootbagnetid].Items[k] = {amount = v.amount}
                end
            end
        end
    end)
end)

local EquipAllBullets = {
    ["9mm"] = true,
    ["12gauge"] = true,
    [".308"] = true,
    ["7.62"] = true,
    ["5.56"] = true,
    [".357"] = true,
    ["p5.56mm"] = true,
    ["p.308"] = true,
    ["p9mm"] = true,
    ["p12gauge"] = true
}
local alreadyEquiping = {}
RegisterNetEvent('CORRUPT:EquipAll')
AddEventHandler('CORRUPT:EquipAll', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    if alreadyEquiping[user_id] then
        CORRUPT.notify(source, {'~r~You are already equipping all items'})
        return
    end
    alreadyEquiping[user_id] = true
    local data = CORRUPT.getUserDataTable(user_id)
    local sortedTable = {}
    for item, _ in pairs(data.inventory) do
        if string.find(item, 'wbody|') or EquipAllBullets[item] then
            table.insert(sortedTable, item)
        end
    end
    table.sort(sortedTable, function(a, b)
        local aIsWeapon = string.find(a, 'wbody|')
        local bIsWeapon = string.find(b, 'wbody|')
        
        if aIsWeapon and bIsWeapon then
            return a < b
        elseif aIsWeapon then
            return true
        elseif bIsWeapon then
            return false
        else
            return a < b
        end
    end)
    for _, item in ipairs(sortedTable) do
        if string.find(item:lower(), 'wbody|') then
            CORRUPT.RunInventoryTask(source, item)
        elseif EquipAllBullets[item] then
            CORRUPT.LoadAllTask(source, item)
        end
        Wait(500)
    end
    TriggerEvent('CORRUPT:RefreshInventory', source)
    alreadyEquiping[user_id] = false
end)







RegisterNetEvent('CORRUPT:LootBag')
AddEventHandler('CORRUPT:LootBag', function(netid)
    local source = source
    CORRUPTclient.isInComa(source, {}, function(in_coma) 
        if not in_coma and not CORRUPT.createCamera then
            if LootBagEntities[netid] then
                LootBagEntities[netid][3] = true;
                local user_id = CORRUPT.getUserId(source)
                local coords = GetEntityCoords(GetPlayerPed(source))
                TriggerClientEvent("CORRUPT:playZipperSound", -1, coords)
                if user_id ~= nil then
                    LootBagEntities[netid][5] = source
                    if CORRUPT.hasPermission(user_id, "police.armoury") then
                        local bagData = LootBagEntities[netid].Items
                        if bagData == nil then return end
                        for a,b in pairs(bagData) do
                            if string.find(a, 'wbody|') then
                                c = a:gsub('wbody|', '')
                                bagData[c] = b
                                bagData[a] = nil
                            end
                        end
                        for k,v in pairs(a.weapons) do
                            if bagData[k] ~= nil then
                                if not v.policeWeapon then
                                    CORRUPT.notify(source, {'~r~Seized '..v.name..' x'..bagData[k].amount..'.'})
                                    bagData[k] = nil
                                end
                            end
                        end
                        for c,d in pairs(bagData) do
                            if seizeBullets[c] then
                                CORRUPT.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                bagData[c] = nil
                            end
                        end
                        LootBagEntities[netid].Items = bagData
                        CORRUPT.notify(source,{"~r~You have seized " .. LootBagEntities[netid].name .. "'s items"})
                        if table.count(LootBagEntities[netid].Items) > 0 then
                            OpenInv(source, netid, LootBagEntities[netid].Items)
                        end
                    else
                        OpenInv(source, netid, LootBagEntities[netid].Items)
                    end  
                end
            else
                local bagEntity = NetworkGetEntityFromNetworkId(netid)
                if DoesEntityExist(bagEntity) then
                    DeleteEntity(bagEntity)
                    LootBagEntities[netid] = nil
                end
            end
        else 
            CORRUPT.notify(source, {'~r~You cannot open this while dead silly.'})
        end
    end)
end)

RegisterNetEvent('CORRUPT:CloseLootbag')
AddEventHandler('CORRUPT:CloseLootbag', function()
    local source = source
    for i,v in pairs(LootBagEntities) do 
        if v[5] and v[5] == source then 
            CloseInv(v[5])
            Wait(3000)
            v[3] = false; 
            v[5] = nil;
        end
    end
end)

function CloseInv(source)
    TriggerClientEvent('CORRUPT:InventoryOpen', source, false, false)
end

function OpenInv(source, netid, LootBagItems, inventoryInfo)
    local user_id = CORRUPT.getUserId(source)
    local data = CORRUPT.getUserDataTable(user_id)
    if data and data.inventory then
        local FormattedInventoryData = {}
        for i,v in pairs(data.inventory) do
            FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
        end
        TriggerClientEvent('CORRUPT:FetchPersonalInventory', source, FormattedInventoryData, CORRUPT.computeItemsWeight(data.inventory), CORRUPT.getInventoryMaxWeight(user_id))
        InventorySpamTrack[source] = false;
    end
    if inventoryInfo then
        TriggerClientEvent('CORRUPT:InventoryOpen', source, true, true, netid, true)
    else
        TriggerClientEvent('CORRUPT:InventoryOpen', source, true, true, netid)
    end
    local FormattedInventoryData = {}
    for i, v in pairs(LootBagItems) do
        FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
    end
    local maxVehKg = 200
    TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(LootBagItems), maxVehKg)
end


-- Garabge collector for empty lootbags.
Citizen.CreateThread(function()
    while true do 
        Wait(500)
        for i,v in pairs(LootBagEntities) do 
            local itemCount = 0
            for a,b in pairs(v.Items) do
                itemCount = itemCount + 1
            end
            if itemCount == 0  then
                if DoesEntityExist(v[1]) then 
                    DeleteEntity(v[1])
                    LootBagEntities[i] = nil
                end
            end
        end
    end
end)


local usersLockpicking = {}
local lockpickingtrue = {}
RegisterNetEvent('CORRUPT:attemptLockpick')
AddEventHandler('CORRUPT:attemptLockpick', function(veh, netveh)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local chance = math.random(1, 10)
    TriggerClientEvent('CORRUPT:playLockpickAlarm', -1, netveh)
    if CORRUPT.tryGetInventoryItem(user_id, 'lockpick', 1, false) then
        TriggerClientEvent('CORRUPT:playLockpickAlarm', -1, netveh)
        if chance == 1 then
            usersLockpicking[user_id] = true
            TriggerClientEvent('CORRUPT:lockpickClient', source, veh, true)
            lockpickingtrue[user_id] = true
        else
            TriggerClientEvent('CORRUPT:lockpickClient', source, veh, false)
        end
    end
end)

RegisterNetEvent('CORRUPT:lockpickVehicle')
AddEventHandler('CORRUPT:lockpickVehicle', function(spawncode, ownerid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if lockpickingtrue[user_id] then
        local carformat = "chest:u1veh_" .. spawncode .. '|' .. ownerid
        CORRUPT.getSData(carformat, function(cdata)
            local processedChest = {};
            cdata = json.decode(cdata) or {}
            local FormattedInventoryData = {}
            for i, v in pairs(cdata) do
                FormattedInventoryData[i] = {amount = v.amount, name = CORRUPT.getItemName(i), weight = CORRUPT.getItemWeight(i)}
            end
            local maxVehKg = Inventory.vehicle_chest_weights[spawncode] or Inventory.default_vehicle_chest_weight
            TriggerClientEvent('CORRUPT:SendSecondaryInventoryData', source, FormattedInventoryData, CORRUPT.computeItemsWeight(cdata), maxVehKg)
            TriggerEvent('CORRUPT:RefreshInventory', source)
            lockpickingtrue[user_id] = nil
        end)
    else
        CORRUPT.notify(source, {'~r~You are not lockpicking this vehicle.'})
    end
end)

RegisterNetEvent('CORRUPT:setVehicleLock')
AddEventHandler('CORRUPT:setVehicleLock', function(netid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if usersLockpicking[user_id] then
        usersLockpicking[user_id] = nil
        SetVehicleDoorsLocked(NetworkGetEntityFromNetworkId(netid), false)
    end
end)    