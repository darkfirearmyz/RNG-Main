RegisterServerEvent('CORRUPT:saveTattoos')
AddEventHandler('CORRUPT:saveTattoos', function(tattooData, price)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.tryFullPayment(user_id, price) then
        CORRUPT.setUData(user_id, "CORRUPT:Tattoo:Data", json.encode(tattooData))
    end
end)

RegisterServerEvent('CORRUPT:getPlayerTattoos')
AddEventHandler('CORRUPT:getPlayerTattoos', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id, "CORRUPT:Tattoo:Data", function(data)
        if data ~= nil or data ~= 0 then
            TriggerClientEvent('CORRUPT:setTattoos', source, json.decode(data))
        end
    end)
end)
