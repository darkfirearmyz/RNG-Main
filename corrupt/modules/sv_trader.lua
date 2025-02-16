grindBoost = 5.0

local defaultPrices = {
    ["Weed"] = math.floor(1500*grindBoost),
    ["Cocaine"] = math.floor(2500*grindBoost),
    ["Meth"] = math.floor(3000*grindBoost),
    ["Heroin"] = math.floor(10000*grindBoost),
    ["LSDNorth"] = math.floor(15000*grindBoost),
    ["LSDSouth"] = math.floor(15000*grindBoost),
    ["Copper"] = math.floor(1000*grindBoost),
    ["Limestone"] = math.floor(2000*grindBoost),
    ["Gold"] = math.floor(4000*grindBoost),
    ["Diamond"] = math.floor(6000*grindBoost),
}

function CORRUPT.getCommissionPrice(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            if v.commission == nil then
                v.commission = 0
            end
            if v.commission == 0 then
                return defaultPrices[drugtype]
            else
                return defaultPrices[drugtype]-defaultPrices[drugtype]*v.commission/100
            end
        end
    end
end

function CORRUPT.getCommission(drugtype)
    for k,v in pairs(turfData) do
        if v.name == drugtype then
            return v.commission
        end
    end
end

function CORRUPT.updateTraderInfo()
    TriggerClientEvent('CORRUPT:updateTraderCommissions', -1, 
    CORRUPT.getCommission('Weed'),
    CORRUPT.getCommission('Cocaine'),
    CORRUPT.getCommission('Meth'),
    CORRUPT.getCommission('Heroin'),
    CORRUPT.getCommission('LargeArms'),
    CORRUPT.getCommission('LSDNorth'),
    CORRUPT.getCommission('LSDSouth'))
    TriggerClientEvent('CORRUPT:updateTraderPrices', -1, 
    CORRUPT.getCommissionPrice('Weed'), 
    CORRUPT.getCommissionPrice('Cocaine'),
    CORRUPT.getCommissionPrice('Meth'),
    CORRUPT.getCommissionPrice('Heroin'),
    CORRUPT.getCommissionPrice('LSDNorth'),
    CORRUPT.getCommissionPrice('LSDSouth'),
    defaultPrices['Copper'],
    defaultPrices['Limestone'],
    defaultPrices['Gold'],
    defaultPrices['Diamond'])
end

RegisterNetEvent('CORRUPT:requestDrugPriceUpdate')
AddEventHandler('CORRUPT:requestDrugPriceUpdate', function()
    local source = source
	local user_id = CORRUPT.getUserId(source)
    CORRUPT.updateTraderInfo()
end)

local function checkTraderBucket(source)
    if GetPlayerRoutingBucket(source) ~= 0 then
        CORRUPT.notify(source, {'You cannot sell drugs in this dimension.'})
        return false
    end
    return true
end

RegisterNetEvent('CORRUPT:sellCopper')
AddEventHandler('CORRUPT:sellCopper', function()
    local source = source
	local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Copper') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Copper', 1, false)
            CORRUPT.notify(source, {'~g~Sold Copper for £'..getMoneyStringFormatted(defaultPrices['Copper'])})
            CORRUPT.giveBankMoney(user_id, defaultPrices['Copper'])
        else
            CORRUPT.notify(source, {'You do not have Copper.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellLimestone')
AddEventHandler('CORRUPT:sellLimestone', function()
    local source = source
	local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Limestone') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Limestone', 1, false)
            CORRUPT.notify(source, {'~g~Sold Limestone for £'..getMoneyStringFormatted(defaultPrices['Limestone'])})
            CORRUPT.giveBankMoney(user_id, defaultPrices['Limestone'])
        else
            CORRUPT.notify(source, {'You do not have Limestone.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellGold')
AddEventHandler('CORRUPT:sellGold', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Gold') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Gold', 1, false)
            CORRUPT.notify(source, {'~g~Sold Gold for £'..getMoneyStringFormatted(defaultPrices['Gold'])})
            CORRUPT.giveBankMoney(user_id, defaultPrices['Gold'])
            CORRUPT.AddStats("gold_sales", user_id, defaultPrices['Gold'])
        else
            CORRUPT.notify(source, {'You do not have Gold.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellDiamond')
AddEventHandler('CORRUPT:sellDiamond', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Diamond') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Diamond', 1, false)
            CORRUPT.notify(source, {'~g~Sold Diamond for £'..getMoneyStringFormatted(defaultPrices['Diamond'])})
            CORRUPT.giveBankMoney(user_id, defaultPrices['Diamond'])
            CORRUPT.AddStats("diamond_sales", user_id, defaultPrices['Diamond'])
        else
            CORRUPT.notify(source, {'You do not have Diamond.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellWeed')
AddEventHandler('CORRUPT:sellWeed', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Weed') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Weed', 1, false)
            CORRUPT.notify(source, {'~g~Sold Weed for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('Weed'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('Weed'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('Weed'), 'Weed')
            CORRUPT.AddStats("weed_sales", user_id, CORRUPT.getCommissionPrice('Weed'))
        else
            CORRUPT.notify(source, {'You do not have Weed.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellCocaine')
AddEventHandler('CORRUPT:sellCocaine', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Cocaine') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Cocaine', 1, false)
            CORRUPT.notify(source, {'~g~Sold Cocaine for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('Cocaine'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('Cocaine'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('Cocaine'), 'Cocaine')
            CORRUPT.AddStats("cocaine_sales", user_id, CORRUPT.getCommissionPrice('Cocaine'))
        else
            CORRUPT.notify(source, {'You do not have Cocaine.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellMeth')
AddEventHandler('CORRUPT:sellMeth', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Meth') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Meth', 1, false)
            CORRUPT.notify(source, {'~g~Sold Meth for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('Meth'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('Meth'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('Meth'), 'Meth')
            CORRUPT.AddStats("meth_sales", user_id, CORRUPT.getCommissionPrice('Meth'))
        else
            CORRUPT.notify(source, {'You do not have Meth.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellHeroin')
AddEventHandler('CORRUPT:sellHeroin', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'Heroin') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'Heroin', 1, false)
            CORRUPT.notify(source, {'~g~Sold Heroin for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('Heroin'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('Heroin'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('Heroin'), 'Heroin')
            CORRUPT.AddStats("heroin_sales", user_id, CORRUPT.getCommissionPrice('Heroin'))
        else
            CORRUPT.notify(source, {'You do not have Heroin.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellLSDNorth')
AddEventHandler('CORRUPT:sellLSDNorth', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            CORRUPT.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('LSDNorth'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('LSDNorth'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('LSDNorth'), 'LSDNorth')
            CORRUPT.AddStats("lsd_sales", user_id, CORRUPT.getCommissionPrice('LSDNorth'))
        else
            CORRUPT.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellLSDSouth')
AddEventHandler('CORRUPT:sellLSDSouth', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        if CORRUPT.getInventoryItemAmount(user_id, 'LSD') > 0 then
            CORRUPT.tryGetInventoryItem(user_id, 'LSD', 1, false)
            CORRUPT.notify(source, {'~g~Sold LSD for £'..getMoneyStringFormatted(CORRUPT.getCommissionPrice('LSDSouth'))})
            CORRUPT.giveDirtyMoney(user_id, CORRUPT.getCommissionPrice('LSDSouth'))
            CORRUPT.turfSaleToGangFunds(CORRUPT.getCommissionPrice('LSDSouth'), 'LSDSouth')
            CORRUPT.AddStats("lsd_sales", user_id, CORRUPT.getCommissionPrice('LSDSouth'))
        else
            CORRUPT.notify(source, {'You do not have LSD.'})
        end
    end
end)

RegisterNetEvent('CORRUPT:sellAll')
AddEventHandler('CORRUPT:sellAll', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if checkTraderBucket(source) then
        for k,v in pairs(defaultPrices) do
            if k == 'Copper' or k == 'Limestone' or k == 'Gold' then
                if CORRUPT.getInventoryItemAmount(user_id, k) > 0 then
                    local amount = CORRUPT.getInventoryItemAmount(user_id, k)
                    CORRUPT.tryGetInventoryItem(user_id, k, amount, false)
                    CORRUPT.notify(source, {'~g~Sold '..k..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    CORRUPT.giveBankMoney(user_id, defaultPrices[k]*amount)
                    CORRUPT.AddStats(string.lower(k)..'_sales', user_id, defaultPrices[k]*amount)
                end
            elseif k == 'Diamond' then
                if CORRUPT.getInventoryItemAmount(user_id, 'Diamond') > 0 then
                    local amount = CORRUPT.getInventoryItemAmount(user_id, 'Diamond')
                    CORRUPT.tryGetInventoryItem(user_id, 'Diamond', amount, false)
                    CORRUPT.notify(source, {'~g~Sold '..'Diamond'..' for £'..getMoneyStringFormatted(defaultPrices[k]*amount)})
                    CORRUPT.giveBankMoney(user_id, defaultPrices[k]*amount)
                    CORRUPT.AddStats('diamond_sales', user_id, defaultPrices[k]*amount)
                end
            end
        end
    end
end)