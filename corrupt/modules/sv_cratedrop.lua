local crateLocations = {
    vector3(2558.714, 6155.399, 161.8665), -- Rebel 
    vector3(375.0662, 6852.992, 4.083869), -- Paleto 
    vector3(-880.6389, 4414.064, 20.36799), -- Large arms
    vector3(-3032.489, 3402.802, 8.417397), -- mil base 
    vector3(-119.2925, 3022.1, 32.18053), -- diamond mine river
    vector3(36.50002, 4344.443, 41.47789), -- Large arms bridge
    vector3(499.4316, 5536.806, 777.696), -- mount chilliad
    vector3(-1518.191, 2140.92, 55.53791), -- wine mansion
    vector3(-191.0104, 1477.419, 288.4325), -- Vinewood 1
    vector3(828.4253, 1300.878, 363.6823), -- Vinewood sign
    vector3(2348.622, 2138.061, 104.3607), -- wind turbines
    1875.8035888672,344.11486816406,162.74827575684, -- Vinewood lake
    vector3(2836.016, -1447.626, 10.45845), -- island near lsd
    vector3(2543.626, 3615.884, 96.89672), -- Youtool hill
    vector3(2856.744, 4631.319, 48.39237), -- H Bunker
    vector3(4784.917, -5530.945, 19.46264), -- Cayo Perico
    vector3(254.3428, 3583.882, 33.73079), -- Biker city
}
local rigLocations = {
    vector3(-1716.5004882812,8886.94921875,27.144144058228), -- oil rig
}
local activeCrates = {}
local spawnTime = 20*60 -- Time between each airdrop (Its a 20min timer)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(activeCrates) do
            if activeCrates[k].timeTillOpen > 0 then
                activeCrates[k].timeTillOpen = activeCrates[k].timeTillOpen - 1
            end
        end
    end
end)
CrateDropItems = {}
local weapons = {
    -- Pistols
    -- 9mm
    ["wbody|WEAPON_BLACKICEGLOCK"] = { ammoType = "9mm" },
    ["wbody|WEAPON_ROOK"] = { ammoType = "9mm" },
    ["wbody|WEAPON_M1911"] = { ammoType = "9mm" },
    -- .357 Bullets
    ["wbody|WEAPON_PYTHON"] = { ammoType = ".357" },
    ["wbody|WEAPON_SUPDEAGLE"] = { ammoType = ".357" },
    ["wbody|WEAPON_REVOLVER357"] = { ammoType = ".357" },
    -- SMG
    ["wbody|WEAPON_UMP45"] = { ammoType = "9mm" },
    ["wbody|WEAPON_TEC9"] = { ammoType = "9mm" },
    ["wbody|WEAPON_MPX"] = { ammoType = "9mm" },
    ["wbody|WEAPON_UZI"] = { ammoType = "9mm" },
    -- AR
    -- 7.62mm
    ["wbody|WEAPON_AK200"] = { ammoType = "7.62mm" },
    ["wbody|WEAPON_MXM"] = { ammoType = "7.62mm" },
    ["wbody|WEAPON_GOLDAK"] = { ammoType = "7.62mm" },
    -- 5.56 Nato
    ["wbody|WEAPON_CMPCARBINE"] = { ammoType = "5.56mm" },
    -- Mosin
    ["wbody|WEAPON_MOSIN"] = { ammoType = "7.62mm" },
    -- ShotGuns
    ["wbody|WEAPON_WINCHESTER12"] = { ammoType = "12G" },
    ["wbody|WEAPON_SPAZ"] = { ammoType = "12G" },
    ["wbody|WEAPON_OLYMPIA"] = { ammoType = "12G" },
    -- Sniper
    ["wbody|WEAPON_MK14"] = { ammoType = ".308" },
    ["wbody|WEAPON_SVD"] = { ammoType = ".308" },
}

local ammoTypes = {
    ["9mm"] = "9mm",
    ["7.62mm"] = "7.62",
    ["5.56mm"] = "5.56",
    [".357"] = ".357",
    ["12G"] = "12gauge",
    [".308"] = ".308",
}

function GetCrateItem()
    local itemProbabilities = {
        { itemName = "sapphire", probability = 10 },
        { itemName = "cocaine", probability = 20 },
        { itemName = "lsd", probability = 40 },
        { itemName = "morphine", probability = 30 },
    }

    local randNum = math.random(1, 100)
    local cumulativeProbability = 0

    for _, itemData in ipairs(itemProbabilities) do
        cumulativeProbability = cumulativeProbability + itemData.probability
        if randNum <= cumulativeProbability then
            return { spawnName = itemData.itemName, itemCount = math.random(1, 2) }
        end
    end
end

function addRandomItems()
    local numWeapons = math.random(2, 4)
    local weaponsList = {}
    for WeaponSpawnCode, _ in pairs(weapons) do
        table.insert(weaponsList, WeaponSpawnCode)
    end
    for i = 1, numWeapons do
        if #weaponsList == 0 then
            break
        end
        local randomIndex = math.random(#weaponsList)
        local selectedWeapon = weaponsList[randomIndex]
        table.remove(weaponsList, randomIndex)
        CrateDropItems[selectedWeapon] = { amount = 1 }
        local ammoType = weapons[selectedWeapon].ammoType
        local ammo = ammoTypes[ammoType]
        if ammo then
            CrateDropItems[ammo] = { amount = 250 }
        end
    end
    local item = GetCrateItem()
    CrateDropItems[item.spawnName] = { amount = item.itemCount }
end
function getNearestactiveCratesID(source)
    local playerCoords = GetEntityCoords(GetPlayerPed(source))
    local closest = nil
    local closestDistance = nil
    for k,v in pairs(activeCrates) do
        local distance = #(playerCoords - v.coords)
        if closestDistance == nil then
            closestDistance = distance
            closest = k
        elseif distance < closestDistance then
            closestDistance = distance
            closest = k
        end
    end
    return closest
end
AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
       if #activeCrates > 0 then
            for k,v in pairs(activeCrates) do
                TriggerClientEvent('CORRUPT:addCrateDropRedzone', source, v, crateLocations[v])
            end
       end
    end
end)
RegisterServerEvent('CORRUPT:openCrate', function(crateID, Event)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if Event then
        TriggerEvent("CORRUPT:openCrateBattle", source, crateID)
        return
    end
    if activeCrates[crateID] == nil then return end
    if CrateDropItems == nil then return end
    if (#(GetEntityCoords(GetPlayerPed(source)) - crateLocations[crateID]) < 2.0) or (#(GetEntityCoords(GetPlayerPed(source)) - rigLocations[crateID]) < 2.0) then
        if activeCrates[crateID].timeTillOpen > 0 then
            CORRUPT.notify(source, {'~r~Loot crate unlocking in '..activeCrates[crateID].timeTillOpen..' seconds.'})
        else
            OpenInv(source, crateID, CrateDropItems, true)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(30*60*1000)
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        TriggerClientEvent('CORRUPT:crateDrop', -1, crateCoords, crateID, true)
        addRandomItems(crateID)
        activeCrates[crateID] = {oilrig = false, timeTillOpen = 300, coords = crateCoords}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("CORRUPT:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)

RegisterCommand('startoildrop', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        local crateID = math.random(1, #rigLocations)
        local crateCoords = rigLocations[crateID]
        TriggerClientEvent('CORRUPT:crateDrop', -1, crateCoords, crateID, true)
        addRandomItems(crateID)
        activeCrates[crateID] = {oilrig = true, timeTillOpen = 300, coords = crateCoords}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "An Oil Rig off the coast of paleto is hiding a hidden cache of high tier weaponry and sapphires. Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Oil Rig has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("CORRUPT:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    else
        CORRUPT.notify(source, {'You do not have permission to do this.'})
    end
end)

RegisterCommand('startdrop', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        local crateID = math.random(1, #crateLocations)
        local crateCoords = crateLocations[crateID]
        TriggerClientEvent('CORRUPT:crateDrop', -1, crateCoords, crateID, false)
        addRandomItems(crateID)
        activeCrates[crateID] = {oilrig = false, timeTillOpen = 300, coords = crateCoords}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "A cartel plane carrying supplies has had to bail and is parachuting to the ground! Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The airdrop has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("CORRUPT:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    else
        CORRUPT.notify(source, {'You do not have permission to do this.'})
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(3*60*60*1000)
        local crateID = math.random(1, #rigLocations)
        local crateCoords = rigLocations[crateID]
        TriggerClientEvent('CORRUPT:crateDrop', -1, crateCoords, crateID, true)
        addRandomItems(crateID)
        activeCrates[crateID] = {oilrig = true, timeTillOpen = 300, coords = crateCoords}
        TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "An Oil Rig off the coast of paleto is hiding a hidden cache of high tier weaponry and sapphires. Get to it quick, check your GPS!", "alert")
        Wait(20*60*1000)
        if activeCrates[crateID] ~= nil then
            TriggerClientEvent('chatMessage', -1, "^0EVENT | ", {66, 72, 245}, "The Oil Rig has disappeared.", "alert")
            activeCrates[crateID] = nil
            TriggerClientEvent("CORRUPT:removeLootcrate", -1, crateID)
        end
        Wait(1000)
    end
end)