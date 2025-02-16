local lang = CORRUPT.lang
local MoneydropEntities = {}

RegisterServerEvent("CORRUPT:MoneyDrops")
AddEventHandler("CORRUPT:MoneyDrops", function()
    local source = source
    Wait(100)
    local user_id = CORRUPT.getUserId(source)
    local money = CORRUPT.getMoney(user_id)

    if money > 0 then
        local moneydropnetid = math.random(1023000, 10232000)
        local coords = GetEntityCoords(GetPlayerPed(source))
        TriggerClientEvent("CORRUPT:createCashBag", -1, moneydropnetid, coords)

        MoneydropEntities[moneydropnetid] = {
            isPickedUp = false,
            source = source,
            money = money
        }

        if CORRUPT.tryPayment(user_id, money) then
            -- Payment successful; money is already set above
        else
            CORRUPT.notify(source, {"Payment failed; unable to create money drop."})
        end
    else
        CORRUPT.notify(source, {"You do not have enough money to drop."})
    end
end)

RegisterNetEvent('CORRUPT:Moneydrop')
AddEventHandler('CORRUPT:Moneydrop', function(netid)
    local source = source
    if MoneydropEntities[netid] and not MoneydropEntities[netid].isPickedUp then
        MoneydropEntities[netid].isPickedUp = true
        local user_id = CORRUPT.getUserId(source)

        if user_id ~= nil then
            local moneyToGive = MoneydropEntities[netid].money
            if moneyToGive > 0 then
                CORRUPT.giveMoney(user_id, moneyToGive)
                CORRUPT.notify(source, {"~g~You have picked up £" .. getMoneyStringFormatted(moneyToGive)})
                MoneydropEntities[netid].money = 0 -- Reset money after pickup
            else
                CORRUPT.notify(source, {"The money has already been picked up by someone else."})
            end
        else
            CORRUPT.notify(source, {"You must be logged in to pick up money."})
        end
    end
end)

Citizen.CreateThread(function()
    while true do 
        Wait(100)
        for netid, entity in pairs(MoneydropEntities) do 
            if entity.money == 0 then
                TriggerClientEvent("CORRUPT:removeLootbag", -1, netid)
                MoneydropEntities[netid] = nil
            end
        end
    end
end)
