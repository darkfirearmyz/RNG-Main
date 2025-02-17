local lang = CORRUPT.lang

local dumpsterItems = {
    [1] = {chance = 2, id = 'shaver', name = 'Shaver', quantity = math.random(1,3)},
    -- ... other existing items with unique indices

    -- New items from your list with random quantities
    [2] = {chance = 3, id = 'repairkit', name = 'Repair Kit', quantity = math.random(1,3)},
    [3] = {chance = 2, id = 'Headbag', name = 'Head Bag', quantity = math.random(1,3)},
    [4] = {chance = 4, id = 'Wallet', name = 'Wallet', quantity = math.random(1,3)},
    [5] = {chance = 3, id = 'Shaver', name = 'Shaver', quantity = math.random(1,3)},
    [6] = {chance = 3, id = 'handcuffkeys', name = 'Handcuff Keys', quantity = math.random(1,3)},
    [7] = {chance = 3, id = 'handcuff', name = 'Handcuff', quantity = math.random(1,3)},
    [8] = {chance = 1, id = 'rock', name = 'Rock', quantity = math.random(1,3)},
    [9] = {chance = 5, id = 'hackingDevice', name = 'Hacking Device', quantity = math.random(1,3)},
    -- [10] = {chance = 3, id = 'sapphire', name = 'Sapphire', quantity = math.random(1,3)},
    -- [11] = {chance = 3, id = 'jewelry_ring', name = 'Gold Ring', quantity = math.random(1,3)},
    -- [12] = {chance = 3, id = 'jewelry_watch', name = 'Gold Watch', quantity = math.random(1,3)},
    -- [13] = {chance = 3, id = 'jewelry_necklace', name = 'Gold Necklace', quantity = math.random(1,3)},
    [14] = {chance = 2, id = 'armourplate', name = 'Armour Plate', quantity = math.random(1,3)},
    [15] = {chance = 1, id = 'wbody|WEAPON_MOSIN', name = 'Mosin', quantity = math.random(1,2)}

    -- Add other items as needed
}

local function getRandomQuantity(min, max)
    return math.random(min, max)
end

RegisterServerEvent('corrupt:item')
AddEventHandler('corrupt:item', function(source)
    local user_id = CORRUPT.getUserId(tonumber(source))
    local cash = getRandomQuantity(3000, 5000)
    local chance = math.random(1, 2)

    if chance == 2 then
        CORRUPT.notify(source, {"You find £" .. cash .. " inside the wallet"})
        corrupt.giveMoney(user_id, 20000)
        if math.random(1, 40) == 20 then
            CORRUPT.notify(source, {"You find a Green Keycard inside the wallet"})
            CORRUPT.giveInventoryItem(user_id, "green_keycard", 1, true) 
        end
    else
        CORRUPT.notify(source, {"The wallet was empty"})
    end
    CORRUPT.tryGetInventoryItem(user_id, "wallet", 1, false)
end)

RegisterServerEvent('corrupt:startDumpsterTimer')
AddEventHandler('corrupt:startDumpsterTimer', function(dumpster)
    if dumpster == nil then
        print("Error: No dumpster provided for corrupt:startDumpsterTimer")
        return
    end

    SetTimeout(10 * 60000, function()
        if source then
            TriggerClientEvent('corrupt:removeDumpster', source, dumpster)
        else
            print("Error: 'source' is null in corrupt:startDumpsterTimer")
        end
    end)
end)



RegisterServerEvent('corrupt:giveDumpsterReward')
AddEventHandler('corrupt:giveDumpsterReward', function()
    local user_id = CORRUPT.getUserId(source)
    local gotID = {}
    local rolls = math.random(1, 2)

    for i = 1, rolls do
        local item = dumpsterItems[math.random(1, #dumpsterItems)]
        if math.random(1, 10) >= item.chance and not gotID[item.id] then
            gotID[item.id] = true
            CORRUPT.notify(source, {"You find " .. item.quantity .. "x " .. item.name})
            CORRUPT.giveInventoryItem(user_id, item.id, item.quantity, true)
        end
    end

    if not next(gotID) then
        CORRUPT.notify(source, {"You find nothing"})
    end
end)

