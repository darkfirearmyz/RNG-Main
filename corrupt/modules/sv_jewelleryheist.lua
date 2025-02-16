local jewelrycfg = module("cfg/cfg_jewelleryheist")
local facilityEmpty = true
local userInFacility = nil
local jewelryHeistReady = false
local isCooldownActive = false
local cooldownStartTime = 0
local cooldownDuration = 3600

AddEventHandler('CORRUPT:playerSpawn', function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent("CORRUPT:jewelrySyncDoor", source, jewelryHeistReady)
        TriggerClientEvent('CORRUPT:jewelrySyncSetupReady', source, facilityEmpty)
        if jewelryHeistReady then
            TriggerClientEvent("CORRUPT:jewelryHeistReady", source, true)
        end
    end
end)

RegisterNetEvent('CORRUPT:jewelrySetupHeistStart')
AddEventHandler('CORRUPT:jewelrySetupHeistStart', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if userInFacility == nil then
        userInFacility = user_id
        facilityEmpty = false

        TriggerClientEvent('CORRUPT:jewelrySyncSetupReady', source, facilityEmpty)
        for k, v in pairs(jewelrycfg.aiSpawnLocs) do
            local pos = v.coords
            local ped = CreatePed(4, "s_m_y_blackops_03", pos.x, pos.y, pos.z, v.heading, false, true)
            GiveWeaponToPed(ped, v.weaponHash, 999, false, true)
            TriggerClientEvent('CORRUPT:jewelryMakePedsAttack', source, NetworkGetNetworkIdFromEntity(ped))
        end
        Citizen.Wait(2000)
        for _, pickupLocation in pairs(jewelrycfg.hackingDevicePickupLocs) do
            TriggerClientEvent('CORRUPT:jewelryCreateDevicePickup', -1, pickupLocation)
        end
    end
end)

RegisterNetEvent('CORRUPT:jewelryCollectDevice')
AddEventHandler('CORRUPT:jewelryCollectDevice', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)

    TriggerClientEvent('CORRUPT:jewelrySyncSetupReady', -1, facilityEmpty)
    TriggerClientEvent('CORRUPT:jewelryRemoveDeviceArea', -1)
    CORRUPT.giveInventoryItem(user_id, "hackingDevice", 1, true)
end)

RegisterNetEvent('CORRUPT:jewelrySetupHeistleave')
AddEventHandler('CORRUPT:jewelrySetupHeistLeave', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if userInFacility == user_id then
        userInFacility = nil
        facilityEmpty = true
        TriggerClientEvent('CORRUPT:jewelrySyncSetupReady', -1, facilityEmpty)
        TriggerClientEvent('CORRUPT:jewelryRemoveDeviceArea', -1)
    end
end)


-- RegisterNetEvent("CORRUPT:jewelryHackDoor")
-- AddEventHandler('CORRUPT:jewelryHackDoor', function()
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     if CORRUPT.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
--         TriggerClientEvent('CORRUPT:jewelryStartDoorHackSf', source)
--         TriggerClientEvent("CORRUPT:jewelrySoundAlarm", -1, true)
--     else
--         CORRUPT.notify(source, {'You do not have a Hacking Device.'})
--     end
-- end)

RegisterNetEvent('CORRUPT:jewelryHackDoor')
AddEventHandler('CORRUPT:jewelryHackDoor', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    
    if not user_id then
        CORRUPT.notify(source, {'~r~Unable To Find User ID'})
        return
    end

    if isCooldownActive and os.time() - cooldownStartTime < cooldownDuration then
        local remainingCooldown = cooldownStartTime + cooldownDuration - os.time()
        TriggerClientEvent('chatMessage', source, "^7OOC ^1Jewelry Store Robbery ^7 - Jewelry Store was robbed too recently, "..remainingCooldown.." seconds remaining.", { 128, 128, 128 }, message, "alert")
        return
    end

    if CORRUPT.hasPermission(user_id, "police.armoury") then
        CORRUPT.notify(source, {'~r~You cannot rob a jewelry store as police.'})
    else
        local policeCount = #CORRUPT.getUsersByPermission('police.armoury')
        if policeCount > 0 then
            if CORRUPT.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
                TriggerClientEvent('CORRUPT:jewelryStartDoorHackSf', source)
                TriggerClientEvent("CORRUPT:jewelrySoundAlarm", -1, true)  
                for a, b in pairs(CORRUPT.getUsers({})) do
                    if CORRUPT.hasPermission(a, "police.armoury") then
                        TriggerClientEvent("CORRUPT:jewelryAlarmTriggered", a)
                    end
                end
            else
                CORRUPT.notify(source, {'You do not have a Hacking Device.'})
            end
            TriggerEvent('CORRUPT:PDRobberyCall', source, "Jewelry Store", vector3(-623.42156982422, -231.59411621094, 38.057064056396))
        else
            CORRUPT.notify(source, {'~r~There are not enough police on duty to rob a jewelry store.'})
        end
    end
end)




RegisterNetEvent('CORRUPT:jewelryDoorHackSuccess')
AddEventHandler('CORRUPT:jewelryDoorHackSuccess', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent("CORRUPT:jewelrySyncDoor", -1, false)
        TriggerClientEvent("CORRUPT:jewelryComputerHackArea", -1, true)
        CORRUPT.notify(source, {'~g~Now Go Hack The Computer!'})
    else
        CORRUPT.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("CORRUPT:jewelryHackComputer")
AddEventHandler('CORRUPT:jewelryHackComputer', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.getInventoryItemAmount(user_id, 'hackingDevice') > 0 then
        TriggerClientEvent('CORRUPT:jewelryStartComputerHackSf', source)
    else
        CORRUPT.notify(source, {'You do not have Hacking Device.'})
    end
end)


RegisterNetEvent("CORRUPT:heiststarten")
AddEventHandler('CORRUPT:heiststarten', function()
    TriggerClientEvent('CORRUPT:jewelryCreateTimer', -1)
    for caseID, caseData in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseID, U)
    end
    SetTimeout(600000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseID, U)
        end
    end)
end)
RegisterNetEvent("CORRUPT:jewelryComputerHackSuccess")
AddEventHandler('CORRUPT:jewelryComputerHackSuccess', function()
    local sourceCoords = GetEntityCoords(GetPlayerPed(-1))
    local storeMiddle = vector3(-623.42156982422, -231.59411621094, 38.057064056396)
    local radius = 9.086
    for i = 1, 31 do
        local targetCoords = GetEntityCoords(GetPlayerPed(i))
        local distance = #(storeMiddle - targetCoords)
        if distance <= radius then
            TriggerClientEvent('CORRUPT:jewelryCreateTimer', i)
        end
    end

    for caseID, _ in pairs(jewelrycfg.jewelryCases) do
        local U = true
        TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseID, U)
    end

    SetTimeout(100000, function()
        for caseID, _ in pairs(jewelrycfg.jewelryCases) do
            local U = false
            TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseID, U)
        end
        jewelryHeistReady = false
        TriggerClientEvent("CORRUPT:jewelryHeistReady", -1, false)
        TriggerClientEvent("CORRUPT:jewelrySyncDoor", -1, true)
    end)

    local user_id = CORRUPT.getUserId(source)
    cooldownStartTime = os.time()
    isCooldownActive = true
    CORRUPT.tryGetInventoryItem(user_id, 'hackingDevice', 1, false)
    SetTimeout(300000, function()
        TriggerClientEvent("CORRUPT:jewelryHeistReady", -1, true)
    end)
end)

function getRandomJewelryItem()
    local randNum = math.random(1, 100)
    if randNum <= 10 then
        return { spawnName = "sapphire", itemCount = 1 }
    elseif randNum <= 30 then
        local itemCount = math.random(1, 2)
        return { spawnName = "jewelry_necklace", itemCount = itemCount }
    elseif randNum <= 70 then
        local itemCount = math.random(1, 5)
        return { spawnName = "jewelry_watch", itemCount = itemCount }
    else
        local itemCount = math.random(2, 10)
        return { spawnName = "jewelry_ring", itemCount = itemCount }
    end
end


RegisterNetEvent("CORRUPT:jewelryGrabLoot")
AddEventHandler('CORRUPT:jewelryGrabLoot', function(caseId)
    local jewelryItem = getRandomJewelryItem()

    if not jewelryItem then
        return
    end

    local user_id = CORRUPT.getUserId(source)
    local spawnName = jewelryItem.spawnName
    local ItemWeight = CORRUPT.getItemWeight(spawnName)

    if not caseId or not jewelrycfg.jewelryCases[caseId] then
        return
    end

    local itemCount = jewelryItem.itemCount or 1

    if CORRUPT.hasPermission(userid, "police") then
        CORRUPT.notify(playerSource, { "Not enough space in inventory." })
    else
        local U = false
        TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseId, U)
        CORRUPT.giveInventoryItem(user_id, spawnName, itemCount, true)
        CORRUPT.notify(playerSource, { "You have recived " .. itemCount .. " " .. spawnName .. "!" })
    end
end)



RegisterNetEvent("CORRUPT:jewelryPoliceSeizeLoot")
AddEventHandler('CORRUPT:jewelryPoliceSeizeLoot', function(caseId)
    local U = false
    TriggerClientEvent("CORRUPT:jewelrySyncLootAreas", -1, caseId, U)
    CORRUPT.notify(source, {"~g~Recovered Jewelry"})
end)

local function checkBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        CORRUPT.notify(source, {'You cannot sell in this bucket.'})
        return false
    end
    return true
end


RegisterNetEvent('CORRUPT:sellJewelry')
AddEventHandler('CORRUPT:sellJewelry', function(spawnName, sellPrice, itemName)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, spawnName) > 0 then
            CORRUPT.tryGetInventoryItem(user_id, spawnName, 1, false)
            CORRUPT.notify(source, {itemName .. '~g~ Sold For £' .. getMoneyStringFormatted(sellPrice)})
            CORRUPT.giveDirtyMoney(user_id, sellPrice)
        else
            CORRUPT.notify(source, {'You don\'t have ' .. itemName})
        end
    end
end)