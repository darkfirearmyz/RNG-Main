MySQL.createCommand("CORRUPT/get_prison_time","SELECT prison_time FROM corrupt_prison WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/set_prison_time","UPDATE corrupt_prison SET prison_time = @prison_time WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/add_prisoner", "INSERT IGNORE INTO corrupt_prison SET user_id = @user_id")
MySQL.createCommand("CORRUPT/get_current_prisoners", "SELECT * FROM corrupt_prison WHERE prison_time > 0")
MySQL.createCommand("CORRUPT/add_jail_stat","UPDATE corrupt_police_hours SET total_player_jailed = (total_player_jailed+1) WHERE user_id = @user_id")

local cfg = module("cfg/cfg_prison")
local newDoors = {}
for k,v in pairs(cfg.doors) do
    for a,b in pairs(v) do
        newDoors[b.doorHash] = b
        newDoors[b.doorHash].currentState = 0
    end
end  
local prisonItems = {"toothbrush", "blade", "rope", "metal_rod", "spring"}

local lastCellUsed = 0

AddEventHandler("playerJoining", function()
    local user_id = CORRUPT.getUserId(source)
    MySQL.execute("CORRUPT/add_prisoner", {user_id = user_id})
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        MySQL.query("CORRUPT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 0 then
                    if lastCellUsed == 27 then
                        lastCellUsed = 0
                    end
                    TriggerClientEvent('CORRUPT:putInPrisonOnSpawn', source, lastCellUsed+1)
                    TriggerClientEvent('CORRUPT:forcePlayerInPrison', source, true)
                    TriggerClientEvent('CORRUPT:prisonCreateBreakOutAreas', source)
                    TriggerClientEvent('CORRUPT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
                    local prisonItemsTable = {}
                    for k,v in pairs(cfg.prisonItems) do
                        local item = math.random(1, #prisonItems)
                        prisonItemsTable[prisonItems[item]] = v
                    end
                    TriggerClientEvent('CORRUPT:prisonCreateItemAreas', source, prisonItemsTable)
                end
            end
        end)
        TriggerClientEvent('CORRUPT:prisonUpdateGuardNumber', -1, #CORRUPT.getUsersByPermission('hmp.menu'))
        TriggerClientEvent('CORRUPT:prisonSyncAllDoors', source, newDoors)
    end
end)

RegisterNetEvent("CORRUPT:getNumOfNHSOnline")
AddEventHandler("CORRUPT:getNumOfNHSOnline", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("CORRUPT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then
            if prisontime[1].prison_time > 0 then
                TriggerClientEvent('CORRUPT:prisonSpawnInMedicalBay', source)
                TriggerClientEvent("Corrupt:Revive", source)
            else
                TriggerClientEvent('CORRUPT:getNumberOfDocsOnline', source, #CORRUPT.getUsersByPermission('nhs.menu'))
            end
        end
    end)
end)

RegisterServerEvent("CORRUPT:prisonArrivedForJail")
AddEventHandler("CORRUPT:prisonArrivedForJail", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("CORRUPT/get_prison_time", {user_id = user_id}, function(prisontime)
        if prisontime ~= nil then 
            if prisontime[1].prison_time > 0 then
                CORRUPT.setBucket(source, 0)
                TriggerClientEvent('CORRUPT:unHandcuff', source, false)
                TriggerClientEvent('CORRUPT:toggleHandcuffs', source, false)
                TriggerClientEvent('CORRUPT:forcePlayerInPrison', source, true)
                TriggerClientEvent('CORRUPT:prisonCreateBreakOutAreas', source)
                TriggerClientEvent('CORRUPT:prisonUpdateClientTimer', source, prisontime[1].prison_time)
            end
        end
    end)
end)

local prisonPlayerJobs = {}

RegisterServerEvent("CORRUPT:prisonStartJob")
AddEventHandler("CORRUPT:prisonStartJob", function(job)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    prisonPlayerJobs[user_id] = job
end)

RegisterServerEvent("CORRUPT:prisonEndJob")
AddEventHandler("CORRUPT:prisonEndJob", function(job)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if prisonPlayerJobs[user_id] == job then
        prisonPlayerJobs[user_id] = nil
        MySQL.query("CORRUPT/get_prison_time", {user_id = user_id}, function(prisontime)
            if prisontime ~= nil then 
                if prisontime[1].prison_time > 21 then
                    MySQL.execute("CORRUPT/set_prison_time", {user_id = user_id, prison_time = prisontime[1].prison_time - 20})
                    TriggerClientEvent('CORRUPT:prisonUpdateClientTimer', source, prisontime[1].prison_time - 20)
                    CORRUPT.notify(source, {"~g~Prison time reduced by 20s."})
                end
            end
        end)
    end
end)

RegisterServerEvent("CORRUPT:jailPlayer")
AddEventHandler("CORRUPT:jailPlayer", function(player)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        CORRUPTclient.getNearestPlayers(source,{15},function(nplayers)
            if nplayers[player] then
                CORRUPTclient.isHandcuffed(player,{}, function(handcuffed)  -- check handcuffed
                    if handcuffed then
                        -- check for gc in cfg 
                        MySQL.query("CORRUPT/get_prison_time", {user_id = CORRUPT.getUserId(player)}, function(prisontime)
                            if prisontime ~= nil then 
                                if prisontime[1].prison_time == 0 then
                                    CORRUPT.prompt(source,"Jail Time (in minutes):","",function(source,jailtime) 
                                        local jailtime = math.floor(tonumber(jailtime) * 60)
                                        if jailtime > 0 and jailtime <= cfg.maxTimeNotGc then
                                            CORRUPT.AddStats("arrests", user_id, 1)
                                            CORRUPT.AddStats("jailed_time", CORRUPT.getUserId(player), jailtime)
                                            MySQL.execute("CORRUPT/set_prison_time", {user_id = CORRUPT.getUserId(player), prison_time = jailtime})
                                            if lastCellUsed == 27 then
                                                lastCellUsed = 0
                                            end
                                            TriggerClientEvent('CORRUPT:prisonTransportWithBus', player, lastCellUsed+1)
                                            CORRUPT.setBucket(player, lastCellUsed+1)
                                            local prisonItemsTable = {}
                                            for k,v in pairs(cfg.prisonItems) do
                                                local item = math.random(1, #prisonItems)
                                                prisonItemsTable[prisonItems[item]] = v
                                            end
                                            exports['corrupt']:execute("SELECT * FROM `corrupt_police_hours` WHERE user_id = @user_id", {user_id = user_id}, function(result)
                                                if result ~= nil then 
                                                    for k,v in pairs(result) do
                                                        if v.user_id == user_id then
                                                            exports['corrupt']:execute("UPDATE corrupt_police_hours SET total_players_jailed = @total_players_jailed WHERE user_id = @user_id", {user_id = user_id, total_players_jailed = v.total_players_jailed + 1}, function() end)
                                                            return
                                                        end
                                                    end
                                                    exports['corrupt']:execute("INSERT INTO corrupt_police_hours (`user_id`, `total_players_jailed`, `username`) VALUES (@user_id, @total_players_jailed, @username);", {user_id = user_id, total_players_jailed = 1}, function() end) 
                                                end
                                            end)
                                            TriggerClientEvent('CORRUPT:prisonCreateItemAreas', player, prisonItemsTable)
                                            CORRUPT.notify(source, {"~g~Jailed Player."})
                                            CORRUPT.sendWebhook('jail-player', 'Corrupt Jail Logs',"> Officer Name: **"..CORRUPT.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Criminal Name: **"..CORRUPT.getPlayerName(player).."**\n> Criminal PermID: **"..CORRUPT.getUserId(player).."**\n> Criminal TempID: **"..player.."**\n> Duration: **"..math.floor(jailtime/60).." minutes**")
                                        else
                                            CORRUPT.notify(source, {"Invalid time."})
                                        end
                                    end)
                                else
                                    CORRUPT.notify(source, {"Player is already in prison."})
                                end
                            end
                        end)
                    else
                        CORRUPT.notify(source, {"You must have the player handcuffed."})
                    end
                end)
            else
                CORRUPT.notify(source, {"Player not found."})
            end
        end)
    end
end)


Citizen.CreateThread(function()
    while true do
        MySQL.query("CORRUPT/get_current_prisoners", {}, function(currentPrisoners)
            if #currentPrisoners > 0 then 
                for k,v in pairs(currentPrisoners) do
                    MySQL.execute("CORRUPT/set_prison_time", {user_id = v.user_id, prison_time = v.prison_time-1})
                    if v.prison_time-1 == 0 and CORRUPT.getUserSource(v.user_id) ~= nil then
                        TriggerClientEvent('CORRUPT:prisonStopClientTimer', CORRUPT.getUserSource(v.user_id))
                        TriggerClientEvent('CORRUPT:prisonReleased', CORRUPT.getUserSource(v.user_id))
                        TriggerClientEvent('CORRUPT:forcePlayerInPrison', CORRUPT.getUserSource(v.user_id), false)
                        CORRUPTclient.setHandcuffed(CORRUPT.getUserSource(v.user_id), {false})
                    end
                end
            end
        end)
        Citizen.Wait(2000)
    end
end)

RegisterCommand('unjail', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.noclip') then
        CORRUPT.prompt(source,"Enter Temp ID:","",function(source, player) 
            local player = tonumber(player)
            if player ~= nil then
                MySQL.execute("CORRUPT/set_prison_time", {user_id = CORRUPT.getUserId(player), prison_time = 0})
                TriggerClientEvent('CORRUPT:prisonStopClientTimer', player)
                TriggerClientEvent('CORRUPT:prisonReleased', player)
                TriggerClientEvent('CORRUPT:forcePlayerInPrison', player, false)
                CORRUPTclient.setHandcuffed(player, {false})
                CORRUPT.notify(source, {"~g~Target will be released soon."})
            else
                CORRUPT.notify(source, {"Invalid ID."})
            end
        end)
    end
end)


AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        TriggerClientEvent('CORRUPT:prisonUpdateGuardNumber', -1, #CORRUPT.getUsersByPermission('hmp.menu'))
    end
end)

local currentLockdown = false
RegisterServerEvent("CORRUPT:prisonToggleLockdown")
AddEventHandler("CORRUPT:prisonToggleLockdown", function(lockdownState)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'dev.menu') then -- change this to the hmp hq permission
        currentLockdown = lockdownState
        if currentLockdown then
            TriggerClientEvent('CORRUPT:prisonSetAllDoorStates', -1, 1)
        else
            TriggerClientEvent('CORRUPT:prisonSetAllDoorStates', -1)
        end
    end
end)

RegisterServerEvent("CORRUPT:prisonSetDoorState")
AddEventHandler("CORRUPT:prisonSetDoorState", function(doorHash, state)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent('CORRUPT:prisonSyncDoor', -1, doorHash, state)
end)

RegisterServerEvent("CORRUPT:enterPrisonAreaSyncDoors")
AddEventHandler("CORRUPT:enterPrisonAreaSyncDoors", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent('CORRUPT:prisonAreaSyncDoors', source, doors)
end)

-- on pickup 
-- CORRUPT:prisonRemoveItemAreas(item)

-- hmp should be able to see all prisoners
-- CORRUPT:requestPrisonerData