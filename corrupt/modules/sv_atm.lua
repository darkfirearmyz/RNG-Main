local cfg = module("cfg/atms")
local organcfg = module("cfg/cfg_organheist")

local robbedAtms = {}
local usersWireCutting = {}

RegisterServerEvent("CORRUPT:Withdraw")
AddEventHandler('CORRUPT:Withdraw', function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if CORRUPT.tryWithdraw(user_id, amount) then
                    CORRUPT.notify(source, {"You have withdrawn £"..getMoneyStringFormatted(amount)})
                else 
                    CORRUPT.notify(source, {"You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)
RegisterServerEvent("CORRUPT:Deposit")
AddEventHandler('CORRUPT:Deposit', function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = tonumber(amount)
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if CORRUPT.tryDeposit(user_id, amount) then
                    CORRUPT.notify(source, {"You have deposited £"..getMoneyStringFormatted(amount)})
                else 
                    CORRUPT.notify(source, {"You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

RegisterServerEvent("CORRUPT:WithdrawAll")
AddEventHandler('CORRUPT:WithdrawAll', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = CORRUPT.getBankMoney(CORRUPT.getUserId(source))
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if CORRUPT.tryWithdraw(user_id, amount) then
                    CORRUPT.notify(source, {"You have withdrawn £"..getMoneyStringFormatted(amount)})
                else 
                    CORRUPT.notify(source, {"You do not have enough money to withdraw."})
                end
            end
        else 
            TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger ATM Withdraw When Not Near ATM')
        end
    end
end)

RegisterServerEvent("CORRUPT:DepositAll")
AddEventHandler('CORRUPT:DepositAll', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local amount = CORRUPT.getMoney(CORRUPT.getUserId(source))
    if amount > 0 then  
        if CloseToATM(GetEntityCoords(GetPlayerPed(source))) then
            if user_id ~= nil then
                if CORRUPT.tryDeposit(user_id, amount) then
                    CORRUPT.notify(source, {"You have deposited £"..getMoneyStringFormatted(amount)})
                else 
                    CORRUPT.notify(source, {"You do not have enough money to deposit."})
                end
            end
        else 
            TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger ATM Deposit When Not Near ATM')
        end
    end
end)

function CloseToATM(coords)
    local checks = 0
    
    -- Check proximity to ATMs
    for _, location in ipairs(cfg.atms) do
        if #(coords - location) <= 15.0 then
            checks = checks + 1
            break  -- No need to continue if one ATM is found nearby
        end
    end
    
    -- Check proximity to gun stores in "Morgue" and "Abandoned Silo" locations
    local locations_to_check = {
        organcfg.locations["Morgue"],
        organcfg.locations["Abandoned Silo"]
    }
    
    for _, location in ipairs(locations_to_check) do
        for _, side in ipairs(location.sides) do
            for _, gunStore in pairs(side.gunStores) do
                for _, storeLocation in ipairs(gunStore) do
                    if #(coords - storeLocation[3]) <= 15.0 then
                        checks = checks + 1
                        break  -- No need to continue if one store is found nearby
                    end
                end
            end
        end
    end
    
    return checks >= 1
end



RegisterNetEvent('CORRUPT:getAtmHasBeenRobbed')
AddEventHandler('CORRUPT:getAtmHasBeenRobbed', function(atmId)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if robbedAtms[atmId] then
        local timeUntil = robbedAtms[atmId] + 900 - os.time()
        TriggerClientEvent('CORRUPT:setAtmHasBeenRobbed', source, timeUntil)
    end
end)

RegisterNetEvent('CORRUPT:startAtmWireCutting')
AddEventHandler('CORRUPT:startAtmWireCutting', function(atmId)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not usersWireCutting[source] and #(GetEntityCoords(GetPlayerPed(source)) - vector3(cfg.robberyAtms[atmId].x, cfg.robberyAtms[atmId].y, cfg.robberyAtms[atmId].z)) < 2.0 then
        if not robbedAtms[atmId] then
            TriggerClientEvent('CORRUPT:startAtmWireCutting', source, atmId)
            TriggerClientEvent('CORRUPT:atmWireCutSparks', source, atmId)
            usersWireCutting[source] = atmId
            robbedAtms[atmId] = os.time()
            local atmPosition = vector3(cfg.robberyAtms[atmId].x, cfg.robberyAtms[atmId].y, cfg.robberyAtms[atmId].z)
            TriggerEvent('CORRUPT:PDRobberyCall', source, "Automatic ATM Alarm", atmPosition, true)
        else
            CORRUPT.notify(source, {"~r~Failed, the ATM has been robbed recently."})
        end
    end
end)

RegisterNetEvent('CORRUPT:atmWireCutSparks')
AddEventHandler('CORRUPT:atmWireCutSparks', function(atmId, idkWhatThisIs)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if usersWireCutting[source] == atmId then
        TriggerClientEvent('CORRUPT:atmWireCutSparks', source, atmId)
    end
end)

RegisterNetEvent('CORRUPT:returnAtmWireCutting')
AddEventHandler('CORRUPT:returnAtmWireCutting', function(atmId, success)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if robbedAtms[atmId] and usersWireCutting[source] == atmId then
        if success then
            CORRUPT.notify(source, {"~g~You have successfully cut the wires!"})
            TriggerClientEvent('CORRUPT:atmWireCuttingSuccess', source)
            TriggerClientEvent('CORRUPT:atmWireCuttingSuccessSync', -1, atmId)
            TriggerClientEvent('CORRUPT:atmGenericAlarm', -1, atmId)
            local randomInkChance = math.random(1,5)
            if randomInkChance == 1 then
                TriggerClientEvent('CORRUPT:atmInkArea', -1, atmId)
                CORRUPT.notify(source, {"~r~Failed to pick up money. A fail safe has covered it in ink."})
            else
                local cash = grindBoost*math.random(65000,125000)*2
                TriggerClientEvent("CORRUPT:atmRobberyFakeMoney", source, CORRUPT.getInventoryItemAmount(user_id, "dirtycash"), cash)
                CORRUPT.giveDirtyMoney(user_id, cash)
            end
        else
            CORRUPT.notify(source, {"~r~You have failed to cut the wires."})
        end
        usersWireCutting[source] = nil
    end
end)

RegisterNetEvent('CORRUPT:atmStopWireCutting')
AddEventHandler('CORRUPT:atmStopWireCutting', function(atmId)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    usersWireCutting[source] = nil
end)