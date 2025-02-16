local cfg = module("cfg/cfg_kits")
local kitCooldowns = {}
local redeemingKit = {}

RegisterNetEvent("cnr_kits:getKitCooldown", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if kitCooldowns[user_id] then
        TriggerClientEvent("cnr_kits:sendKitCooldowns", source, kitCooldowns[user_id]-os.time())
    else
        TriggerClientEvent("cnr_kits:sendKitCooldowns", source, 0)
    end
end)

RegisterNetEvent("cnr_kits:redeemKit", function(kit, weapon)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if kitCooldowns[user_id] and kitCooldowns[user_id] > os.time() then return end
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end 
    if cfg.kits[kit] then
        local kit = cfg.kits[kit]
        if not kit.weapons[weapon] then return end
        if not redeemingKit[source] then
            redeemingKit[source] = true
            kitCooldowns[user_id] = os.time() + kit.cooldown*60
            CORRUPTclient.GiveWeaponsToPlayer(source, {{[weapon] = {ammo =  kit.categoryAmmo}}, false})
            TriggerClientEvent("cnr_kits:sendKitCooldowns", source, kitCooldowns[user_id]-os.time())
            CORRUPT.notify(source, "~g~"..kit.name.." loaded! Given weapon + armour.")
            CORRUPT.setArmour(source, kit.armour, true)
        end
        redeemingKit[source] = nil
    end
end)