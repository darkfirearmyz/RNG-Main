local coords = {
    vector3(-224.8747253418,6559.0815429688,10.997802734375),
    vector3(-207.38900756836,6576.2373046875,11.0146484375),
    vector3(-51.942855834961,6649.4638671875,30.054931640625),
    vector3(164.20219421387,6653.5913085938,31.571411132812),
    vector3(2893.7407226562,4487.5913085938,48.151611328125),
    vector3(2673.9956054688,3501.2702636719,53.290893554688),
    vector3(2379.82421875,3349.5297851562,47.949462890625),
    vector3(2145.71875,4774.6943359375,41.00732421875)
}

local peds = {
    "a_m_m_business_01",
    "a_m_m_hasjew_01",
    "a_f_y_femaleagent"
}

local currentlyusing = {}


function CORRUPT.BurnerPhone(source)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.tryGetInventoryItem(user_id, "burner_phone", 1, false) then
        CORRUPT.giveInventoryItem(user_id, "burner_phone", 1, false)
        local getrandomcoords = coords[math.random(1, #coords)]
        local getrandomped = peds[math.random(1, #peds)]
        local TableForClient = {x = getrandomcoords.x, y = getrandomcoords.y, z = getrandomcoords.z, xyz = getrandomcoords, blip = 57}
        currentlyusing[user_id] = {}
        currentlyusing[user_id].table = TableForClient
        TriggerClientEvent("CORRUPT:addDirtyCashDealer", -1, source, TableForClient, getrandomped)
        TriggerClientEvent("CORRUPT:routeDirtyCashDealer", source, TableForClient)
    end
end

RegisterServerEvent("CORRUPT:startHandingDirtyCash",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local dirtycash = CORRUPT.getDirtyMoney(user_id)
    if dirtycash > 0 and currentlyusing[user_id] then
        local time = math.floor(dirtycash / 100)
        TriggerClientEvent("CORRUPT:startHandingDirtyCash", source, time)
        TriggerClientEvent("CORRUPT:startHandingDirtyCashAnim", -1, currentlyusing[user_id].table)
        currentlyusing[user_id].HandingOver = true
        Wait(time)
        if currentlyusing[user_id].HandingOver then
            if CORRUPT.tryGetInventoryItem(user_id, "dirtycash", dirtycash, false) then
                CORRUPT.giveMoney(user_id, dirtycash)
                CORRUPT.notify(source, {"~g~Your funds have been cleaned: £" .. getMoneyStringFormatted(dirtycash)})
            else
                CORRUPT.notify(source, {"~r~You no longer have the dirty cash."})
            end
        end
        TriggerClientEvent("CORRUPT:stopHandingDirtyCash", source)
        TriggerClientEvent("CORRUPT:stopHandingDirtyCashAnim", -1, currentlyusing[user_id].table)
        TriggerClientEvent("CORRUPT:removeDirtyCashDealer", -1, source)
        currentlyusing[user_id] = nil
    end
end)

RegisterServerEvent("CORRUPT:stopHandingDirtyCash",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if currentlyusing[user_id] then
        currentlyusing[user_id].HandingOver = false
        TriggerClientEvent("CORRUPT:stopHandingDirtyCashAnim", -1, currentlyusing[user_id].table)
        TriggerClientEvent("CORRUPT:stopHandingDirtyCash", source)
    end
end)


function CORRUPT.giveDirtyMoney(user_id, amount)
    CORRUPT.giveInventoryItem(user_id, "dirtycash", amount, false)
end

function CORRUPT.removeDirtyMoney(user_id, amount)
    CORRUPT.giveInventoryItem(user_id, "dirtycash", -amount, false)
end

function CORRUPT.getDirtyMoney(user_id)
    local data = CORRUPT.getUserDataTable(user_id)
    if data and data.inventory then
        for k, v in pairs(data.inventory) do
            if k == "dirtycash" then
                return v.amount
            end
        end
    end
    return 0
end