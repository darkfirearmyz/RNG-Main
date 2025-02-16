RegisterNetEvent("CORRUPT:getArmour")
AddEventHandler("CORRUPT:getArmour",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "police.armoury") or CORRUPT.hasPermission(user_id, "hmp.menu") then
        if CORRUPT.hasPermission(user_id, "hmp.menu") then
            CORRUPT.setArmour(source, 100, true)
        elseif CORRUPT.hasPermission(user_id, "police.maxarmour") then
            CORRUPT.setArmour(source, 100, true)
        elseif CORRUPT.hasGroup(user_id, "Inspector Clocked") then
            CORRUPT.setArmour(source, 75, true)
        elseif CORRUPT.hasGroup(user_id, "Senior Constable Clocked") or CORRUPT.hasGroup(user_id, "Sergeant Clocked") then
            CORRUPT.setArmour(source, 50, true)
        elseif CORRUPT.hasGroup(user_id, "PCSO Clocked") or CORRUPT.hasGroup(user_id, "PC Clocked") then
            CORRUPT.setArmour(source, 25, true)
        end
        TriggerClientEvent("CORRUPT:PlaySound", source, "playMoney")
        CORRUPT.notify(source, {"~g~You have received your armour."})
    else
        local player = CORRUPT.getUserSource(user_id)
        local name = CORRUPT.getPlayerName(source)
        Wait(500)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, player, 'Attempted to use pd armour trigger')
    end
end)

local equipingplates = {}
local source = source

function CORRUPT.ArmourPlate(source)
    local user_id = CORRUPT.getUserId(source)
    if GetPedArmour(GetPlayerPed(source)) < 100 then
        if not equipingplates[user_id] then
            if CORRUPT.tryGetInventoryItem(user_id,"armourplate",1) or CORRUPT.tryGetInventoryItem(user_id,"pd_armourplate",1) then
                equipingplates[user_id] = true
                TriggerClientEvent("CORRUPT:playArmourApplyAnim",source)
                Wait(5000)
                CORRUPT.setArmour(source, 100, true)
                equipingplates[user_id] = false
                CORRUPTclient.notify(source, {"~g~You have equipped an armour plate."})
            else
                CORRUPTclient.notify(source, {"~r~You do not have any armour plates."})
            end
        else
            CORRUPTclient.notify(source, {"~r~You are already equipping armour plates."})
        end
    else
        CORRUPTclient.notify(source, {"~r~You already have 100% armour."})
    end
end

function CORRUPT.setArmour(source, amount, sound)
    TriggerClientEvent("CORRUPT:setArmourClient", source, amount, sound)
end