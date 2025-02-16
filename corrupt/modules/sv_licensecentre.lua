
local cfg = module("cfg/cfg_licensecentre")

RegisterServerEvent("CORRUPT:buyLicense")
AddEventHandler('CORRUPT:buyLicense', function(job, name)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if not CORRUPT.hasGroup(user_id, "Rebel") and job == "AdvancedRebel" then
        CORRUPT.notify(source, {"You need to have Rebel License."})
        return
    end
    if #(playerCoords - coords) <= 15.0 then
        if CORRUPT.hasGroup(user_id, job) then 
            CORRUPT.notify(source, {"~o~You have already purchased this license!"})
            TriggerClientEvent("CORRUPT:PlaySound", source, 2)
        else
            for k,v in pairs(cfg.licenses) do
                if v.group == job then
                    if CORRUPT.tryFullPayment(user_id, v.price) then
                        CORRUPT.addUserGroup(user_id,job)
                        CORRUPT.notify(source, {"~g~Purchased " .. name .. " for ".. '£' ..tostring(getMoneyStringFormatted(v.price)) .. " ❤️"})
                        CORRUPT.sendWebhook('purchases',"Corrupt License Centre Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Purchased: **"..name.."**")
                        TriggerClientEvent("CORRUPT:PlaySound", source, "playMoney")
                        TriggerClientEvent("CORRUPT:gotOwnedLicenses", source, getLicenses(user_id))
                        TriggerClientEvent("CORRUPT:refreshGunStorePermissions", source)
                    else 
                        CORRUPT.notify(source, {"You do not have enough money to purchase this license!"})
                        TriggerClientEvent("CORRUPT:PlaySound", source, 2)
                    end
                end
            end
        end
    else 
        TriggerEvent("CORRUPT:AntiCheat", userid, 11, CORRUPT.getPlayerName(source), source, 'Trigger License Menu Purchase')
    end
end)

RegisterServerEvent("CORRUPT:refundLicense")
AddEventHandler('CORRUPT:refundLicense', function(job, name)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local coords = cfg.location
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - coords) <= 15.0 then
        local refundPercentage = 0.25
        for k, v in pairs(cfg.licenses) do
            if v.group == job then
                local refundAmount = v.price * refundPercentage
                CORRUPT.setBankMoney(user_id, CORRUPT.getBankMoney(user_id) + refundAmount)
                CORRUPT.removeUserGroup(user_id, job)
                CORRUPT.notify(source, {"~g~Refunded " .. name .. " for " .. '£' .. tostring(getMoneyStringFormatted(refundAmount))})
                CORRUPT.sendWebhook('purchases', "Corrupt License Centre Logs Refund", "> Player Name: **" .. CORRUPT.getPlayerName(source) .. "**\n> Player TempID: **" .. source .. "**\n> Player PermID: **" .. user_id .. "**\n> Refund: **" .. name .. "**")
                TriggerClientEvent("CORRUPT:PlaySound", source, "playMoney")
                TriggerClientEvent("CORRUPT:gotOwnedLicenses", source, getLicenses(user_id))
                TriggerClientEvent("CORRUPT:refreshGunStorePermissions", source)
            end
        end
    else 
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger License Menu Refund')
    end
end)







function getLicenses(user_id)
    local licenses = {}
    if user_id ~= nil then
        for k, v in pairs(cfg.licenses) do
            if CORRUPT.hasGroup(user_id, v.group) then
                table.insert(licenses, v.name)
            end
        end
        return licenses
    end
end

RegisterNetEvent("CORRUPT:GetLicenses")
AddEventHandler("CORRUPT:GetLicenses", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("CORRUPT:ReceivedLicenses", source, getLicenses(user_id))
    end
end)

RegisterNetEvent("CORRUPT:getOwnedLicenses")
AddEventHandler("CORRUPT:getOwnedLicenses", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        TriggerClientEvent("CORRUPT:gotOwnedLicenses", source, getLicenses(user_id))
    end
end)