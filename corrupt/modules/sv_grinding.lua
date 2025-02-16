local grindingData = {
    ['Copper'] = {
        license = 'Copper', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'copperore', 
        secondItem = 'Copper', 
        pickaxe = true
    },
    ['Limestone'] = {
        license = 'Limestone', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'limestoneore',
        secondItem = 'Limestone', 
        pickaxe = true
    },
    ['Gold'] = {
        license = 'Gold', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'goldore', 
        secondItem = 'Gold', 
        pickaxe = true
    },
    ['Weed'] = {
        license = 'Weed', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'dirtyweed', 
        secondItem = 'Weed'
    },
    ['Cocaine'] = {
        license = 'Cocaine', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'dirtycocaine', 
        secondItem = 'Cocaine'
    },
    ['Meth'] = {
        license = 'Meth', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'dirtymeth', 
        secondItem = 'meth'
    },
    ['Diamond'] = {
        license = 'Diamond', 
        processingScenario = 'WORLD_HUMAN_WELDING', 
        firstItem = 'uncutdiamond', 
        secondItem = 'Diamond', 
        pickaxe = true
    },
    ['Heroin'] = {
        license = 'Heroin', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'dirtyheroin', 
        secondItem = 'Heroin'
    },
    ['LSD'] = {
        license = 'LSD', 
        miningScenario = 'WORLD_HUMAN_GARDENER_PLANT', 
        processingScenario = 'WORLD_HUMAN_CLIPBOARD', 
        firstItem = 'dirtylsd', 
        secondItem = 'refinedlsd', 
        thirdItem = 'LSD'
    },
}

RegisterNetEvent('CORRUPT:requestGrinding')
AddEventHandler('CORRUPT:requestGrinding', function(drug, grindingtype)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local delay = 10000
    if GetPlayerRoutingBucket(source) ~= 0 then
        CORRUPT.notify(source, {"You cannot grind in this bucket."})
        return
    end
    for k,v in pairs(grindingData) do
        if k == drug then
            if CORRUPT.hasGroup(user_id, v.license) then
                MySQL.query("subscription/get_subscription", {user_id = user_id}, function(rows, affected)
                    if #rows > 0 then
                        if rows[1].plathours > 0 then
                           delay = 7500
                        end
                        if grindingtype == 'mining' then
                            if v.pickaxe then
                                TriggerClientEvent('CORRUPT:playGrindingPickaxe', source)  
                            else
                                TriggerClientEvent('CORRUPT:playGrindingScenario', source, v.miningScenario, false) 
                            end
                            Citizen.Wait(delay)
                            if CORRUPT.getInventoryWeight(user_id)+(1*4) > CORRUPT.getInventoryMaxWeight(user_id) then
                                CORRUPT.notify(source,{"Not enough space in inventory."})
                            else    
                                CORRUPT.giveInventoryItem(user_id, v.firstItem, 4, true)
                            end
                        elseif grindingtype == 'processing' then
                            if CORRUPT.getInventoryItemAmount(user_id, v.firstItem) >= 4 then
                                CORRUPT.tryGetInventoryItem(user_id, v.firstItem, 4, true)
                                TriggerClientEvent('CORRUPT:playGrindingScenario', source, v.processingScenario, false)
                                Citizen.Wait(delay)
                                if CORRUPT.getInventoryWeight(user_id)+(4*1) > CORRUPT.getInventoryMaxWeight(user_id) then
                                    CORRUPT.notify(source,{"Not enough space in inventory."})
                                else   
                                    if drug == 'LSD' then 
                                        CORRUPT.giveInventoryItem(user_id, v.secondItem, 4, true)
                                    else
                                        CORRUPT.giveInventoryItem(user_id, v.secondItem, 1, true)
                                    end
                                end
                            else
                                CORRUPT.notify(source, {"You do not have enough "..v.firstItem.."."})
                            end
                        elseif grindingtype == 'refinery' then
                            if CORRUPT.getInventoryItemAmount(user_id, v.secondItem) >= 4 then
                                CORRUPT.tryGetInventoryItem(user_id, v.secondItem, 4, true)
                                TriggerClientEvent('CORRUPT:playGrindingScenario', source, 'WORLD_HUMAN_CLIPBOARD', false)
                                Citizen.Wait(delay)
                                if CORRUPT.getInventoryWeight(user_id)+(4*1) > CORRUPT.getInventoryMaxWeight(user_id) then
                                    CORRUPT.notify(source,{"Not enough space in inventory."})
                                else    
                                    CORRUPT.giveInventoryItem(user_id, v.thirdItem, 1, true)
                                end
                            else
                                CORRUPT.notify(source, {"You do not have enough "..v.secondItem.."."})
                            end
                        end
                        TriggerEvent('CORRUPT:RefreshInventory', source)
                    end
                end)
            end
        end
    end
end)