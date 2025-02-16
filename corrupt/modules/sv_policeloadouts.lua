loadouts = {
    ['Basic'] = {
        permission = "police.armoury",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_GLOCK",
        },
    },
    ['SCO-19'] = {
        permission = "police.loadshop2",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_GLOCK",
            "WEAPON_G36K",
        },
    },
    ['CTSFO'] = {
        permission = "police.maxarmour",
        weapons = {
            "WEAPON_NIGHTSTICK",
            "WEAPON_STUNGUN",
            "WEAPON_FLASHLIGHT",
            "WEAPON_GLOCK",
            "WEAPON_SPAR17",
            "WEAPON_MSR2",
            "WEAPON_FLASHBANG",
        },
    }
}


RegisterNetEvent('CORRUPT:getPoliceLoadouts')
AddEventHandler('CORRUPT:getPoliceLoadouts', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local loadoutsTable = {}
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        for k,v in pairs(loadouts) do
            v.hasPermission = CORRUPT.hasPermission(user_id, v.permission) 
            loadoutsTable[k] = v
        end
        TriggerClientEvent('CORRUPT:gotLoadouts', source, loadoutsTable)
    end
end)

RegisterNetEvent('CORRUPT:selectLoadout')
AddEventHandler('CORRUPT:selectLoadout', function(loadout)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(loadouts) do
        if k == loadout then
            if CORRUPT.hasPermission(user_id, 'police.armoury') and CORRUPT.hasPermission(user_id, v.permission) then
                for a,b in pairs(v.weapons) do
                    CORRUPTclient.GiveWeaponsToPlayer(source, {{[b] = {ammo = 250}}, false})
                    CORRUPT.setArmour(source, 100, true)
                end
                CORRUPT.notify(source, {"~g~Received "..loadout.." loadout."})
            else
                CORRUPT.notify(source, {"You do not have permission to select this loadout"})
            end
        end
    end
end)