local cfg=module("cfg/cfg_respawn")

RegisterNetEvent("CORRUPT:SendSpawnMenu")
AddEventHandler("CORRUPT:SendSpawnMenu",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawnTable={}
    for k,v in pairs(cfg.spawnLocations)do
        if v.permission[1] ~= nil then
            if CORRUPT.hasPermission(CORRUPT.getUserId(source),v.permission[1])then
                table.insert(spawnTable, k)
            end
        else
            table.insert(spawnTable, k)
        end
    end
    exports['corrupt']:execute("SELECT * FROM `corrupt_user_homes` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for a,b in pairs(result) do
                table.insert(spawnTable, b.home)
            end
            if CORRUPT.isPurge() then
                TriggerClientEvent("CORRUPT:purgeSpawnClient",source)
            else
                TriggerClientEvent("CORRUPT:OpenSpawnMenu",source,spawnTable)
                CORRUPT.clearInventory(user_id) 
                CORRUPTclient.setPlayerCombatTimer(source, {0})
            end
        end
    end)
end)