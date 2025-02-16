local tacoDrivers = {}

RegisterNetEvent('CORRUPT:addTacoSeller')
AddEventHandler('CORRUPT:addTacoSeller', function(coords, price)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    tacoDrivers[user_id] = {position = coords, amount = price}
    TriggerClientEvent('CORRUPT:sendClientTacoData', -1, tacoDrivers)
end)

RegisterNetEvent('CORRUPT:RemoveMeFromTacoPositions')
AddEventHandler('CORRUPT:RemoveMeFromTacoPositions', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    tacoDrivers[user_id] = nil
    TriggerClientEvent('CORRUPT:removeTacoSeller', -1, user_id)
end)

RegisterNetEvent('CORRUPT:payTacoSeller')
AddEventHandler('CORRUPT:payTacoSeller', function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if tacoDrivers[id] then
        if CORRUPT.getInventoryWeight(user_id)+1 <= CORRUPT.getInventoryMaxWeight(user_id) then
            if CORRUPT.tryFullPayment(user_id,15000) then
                CORRUPT.giveInventoryItem(user_id, 'taco', 1)
                CORRUPT.giveBankMoney(id, 15000)
                TriggerClientEvent("CORRUPT:PlaySound", source, "money")
            else
                CORRUPT.notify(source, {'You do not have enough money.'})
            end
        else
            CORRUPT.notify(source, {'Not enough inventory space.'})
        end
    end
end)