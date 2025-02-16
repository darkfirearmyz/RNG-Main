local weapons = module("corrupt-assets", "cfg/weapons")
local purge = module("cfg/cfg_purge")
purgeActive = purge.active
local purgeLB = {
    -- [user_id] = {
    --     name = "name",
    --     user_id = user_id,
    --     kills = 0
    -- }
}
local gunsSorted = {}
for k,v in pairs(weapons.weapons) do
    if v.class ~= "Melee" and v.class ~= "Pistol" and not v.policeWeapon then
        table.insert(gunsSorted, k)
    end
end
function CORRUPT.addPurgeKill(user_id, name)
    for k,v in pairs(purgeLB) do
        if v.user_id == user_id then
            purgeLB[k].kills = purgeLB[k].kills + 1
            return
        end
    end
    table.insert(purgeLB, {name = name, user_id = user_id, kills = 1})
end

RegisterNetEvent("CORRUPT:purgeClientHasSpawned")
AddEventHandler("CORRUPT:purgeClientHasSpawned",function()
    if purgeActive then
        local source = source
        local user_id = CORRUPT.getUserId(source)
        local randomWeapon = math.random(#gunsSorted)
        CORRUPTclient.GiveWeaponsToPlayer(source, {{[gunsSorted[randomWeapon]] = {ammo = 250}}, false})
        CORRUPT.setArmour(source, 100)
        TriggerClientEvent("CORRUPT:purgeGetWeapon", source)
    end
end)

RegisterNetEvent('CORRUPT:getTopFraggers')
AddEventHandler('CORRUPT:getTopFraggers', function()
    if purgeActive then
        local source = source
        local user_id = CORRUPT.getUserId(source)
        for k,v in pairs(purgeLB) do
            if v.user_id == user_id then
                TriggerClientEvent('CORRUPT:gotTopFraggers', source, purgeLB, v.kills)
                return
            end
        end
        TriggerClientEvent('CORRUPT:gotTopFraggers', source, purgeLB, 0)
    end
end)