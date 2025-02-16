local cfg = module("cfg/player_state")
local a = module("corrupt-assets", "cfg/weapons")
local lang = CORRUPT.lang

baseplayers = {}
proplist = {
    "prop_fire_hydrant_1",
    "prop_fire_hydrant_2",
    "prop_bin_01a",
    "prop_postbox_01a",
    "prop_phonebox_04",
    "prop_sign_road_03m",
    "prop_sign_road_05e",
    "prop_sign_road_03g",
    "prop_sign_road_04a",
    "prop_consign_01a",
    "prop_barrier_work01d",
    "prop_sign_road_05a",
    "prop_bin_05a",
    "prop_sign_road_05za",
    "prop_sign_road_02a",
    "prop_bin_05a",
    "prop_sign_road_01a",
    "prop_sign_road_03e",
    "prop_forsalejr1",
    "prop_letterbox_01",
    "prop_sign_road_03",
    "prop_parknmeter_02",
    "prop_rub_binbag_03d",
    "prop_elecbox_08",
    "prop_rub_binbag_04",
    "prop_rub_binbag_05",
    "prop_cratepile_03a",
    "prop_crate_01a",
    "prop_sign_road_07a",
    "prop_rub_trolley_01a",
    "prop_highway_paddle",
    "prop_barrier_work06a",
    "prop_cactus_01d",
    "prop_generator_03a",
    "prop_bin_06a",
    "prop_food_bs_juice03",
    "prop_bollard_02a",
    "prop_rub_cardpile_03",
    "prop_bin_07c",
    "prop_rub_cage01e",
    "prop_rub_cage01c",
    "prop_rub_binbag_03b",
    "prop_bin_08a",
    "prop_barrel_02a",
    "prop_rub_binbag_06",
    "prop_pot_plant_04b",
    "prop_rub_cage01a",
    "prop_rub_cage01c",
    "prop_bin_03a",
    "prop_afsign_amun",
    "prop_bin_07a",
    "prop_pallet_pile_01",
    "prop_shopsign_01",
    "prop_traffic_01a",
    "prop_rub_binbag_03",
    "prop_rub_boxpile_04",
}
AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    CORRUPT.getFactionGroups(source)
    local data = CORRUPT.getUserDataTable(user_id)
    local tmpdata = CORRUPT.getUserTmpTable(user_id)
    local playername = CORRUPT.getPlayerName(source)
    TriggerEvent("CORRUPT:AddChatModes", source)
    if first_spawn then
        if data.customization == nil then
            data.customization = cfg.default_customization
        end
        if data.invcap == nil then
            data.invcap = 30
        end
        CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
            if cb then
                if CORRUPT.isDeveloper(user_id) then
                    data.invcap = 1000
                elseif plathours > 0 and data.invcap < 50 then
                    data.invcap = 50
                elseif plushours > 0 and data.invcap < 40 then
                    data.invcap = 40
                else
                    data.invcap = 30
                end
            end
        end)        
        if data.position == nil and cfg.spawn_enabled then
            local x = cfg.spawn_position[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_position[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_position[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
        end
        if data.customization ~= nil then
            if CORRUPT.isPurge() then
                TriggerClientEvent("CORRUPT:purgeSpawnClient", source)
            else
                TriggerClientEvent("CORRUPT:spawnAnim", source)
            end
            if data.weapons ~= nil then
                CORRUPTclient.GiveWeaponsToPlayer(source, {data.weapons, true})
            end
            TriggerClientEvent("CORRUPT:setUserId", source, user_id)
            CORRUPTclient.setdecor(source, {decor, proplist})
            if CORRUPT.hasPermission(user_id, 'cardev.menu') then
                TriggerClientEvent('CORRUPT:setCarDev', source)
            end
            if CORRUPT.hasPermission(user_id, 'police.armoury') then
                CORRUPTclient.setPolice(source, {true})
                TriggerClientEvent('CORRUPT:globalOnPoliceDuty', source, true)
            end
            if CORRUPT.hasPermission(user_id, 'nhs.menu') then
                CORRUPTclient.setNHS(source, {true})
                TriggerClientEvent('CORRUPT:globalOnNHSDuty', source, true)
            end
            if CORRUPT.hasPermission(user_id, 'hmp.menu') then
                CORRUPTclient.setHMP(source, {true})
                TriggerClientEvent('CORRUPT:globalOnPrisonDuty', source, true)
            end
            if CORRUPT.hasGroup(user_id, 'Taco Seller') then
                TriggerClientEvent('CORRUPT:toggleTacoJob', source, true)
            end
            if CORRUPT.hasGroup(user_id, 'Police Horse Trained') then
                CORRUPTclient.setglobalHorseTrained(source, {})
            end
                
            local adminlevel = 0
            local adminrank = "none"
            if CORRUPT.hasGroup(user_id,"Founder") then
                adminlevel = 12
                adminrank = "founder"
            elseif CORRUPT.hasGroup(user_id,"Lead Developer") then
                adminlevel = 11
                adminrank = "leaddeveloper"
            elseif CORRUPT.hasGroup(user_id,"Developer") then
                adminlevel = 10
                adminrank = "developer"
            elseif CORRUPT.hasGroup(user_id,"Operations Manager") then
                adminlevel = 10
                adminrank = "operationsmanager"
            elseif CORRUPT.hasGroup(user_id,"Community Manager") then
                adminlevel = 9
                adminrank = "communitymanager"
            elseif CORRUPT.hasGroup(user_id,"Staff Manager") then    
                adminlevel = 8
                adminrank = "staffmanager"
            elseif CORRUPT.hasGroup(user_id,"Head Administrator") then
                adminlevel = 7
                adminrank = "headadmin"
            elseif CORRUPT.hasGroup(user_id,"Senior Administrator") then
                adminlevel = 6
                adminrank = "senioradmin"
            elseif CORRUPT.hasGroup(user_id,"Administrator") then
                adminlevel = 5
                adminrank = "admin"
            elseif CORRUPT.hasGroup(user_id,"Senior Moderator") then
                adminlevel = 4
                adminrank = "seniormod"
            elseif CORRUPT.hasGroup(user_id,"Moderator") then
                adminlevel = 3
                adminrank = "mod"
            elseif CORRUPT.hasGroup(user_id,"Support Team") then
                adminlevel = 2
                adminrank = "support"
            elseif CORRUPT.hasGroup(user_id,"Trial Staff") then
                adminlevel = 1
                adminrank = "trial"
            end
            TriggerClientEvent("CORRUPT:sendAdminperks", source, adminlevel, adminrank)
            TriggerClientEvent('CORRUPT:sendGarageSettings', source)
            TriggerEvent("CORRUPT:DVSASpawned", source, user_id)
            if CORRUPT.hasGroup(user_id, "NewPlayer") then
                if CORRUPT.GetPlayTime(user_id) > 48 then
                    CORRUPT.removeUserGroup(user_id, "NewPlayer")
                else
                    TriggerClientEvent("CORRUPT:setIsNewPlayer", source)
                end
            end
            players = CORRUPT.getUsers({})
            for k,v in pairs(players) do
                baseplayers[v] = CORRUPT.getUserId(v)
            end
            TriggerClientEvent("CORRUPT:setBasePlayers", source, baseplayers)
        else
            if data.weapons ~= nil then -- load saved weapons
                CORRUPTclient.GiveWeaponsToPlayer(source, {data.weapons, true})
            end
        end

    else -- not first spawn (player died), don't load weapons, empty wallet, empty inventory
        CORRUPT.clearInventory(user_id) 
        CORRUPT.setMoney(user_id, 0)
        if cfg.spawn_enabled then -- respawn (CREATED SPAWN_DEATH)
            local x = cfg.spawn_death[1] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local y = cfg.spawn_death[2] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            local z = cfg.spawn_death[3] + math.random() * cfg.spawn_radius * 2 - cfg.spawn_radius
            data.position = {
                x = x,
                y = y,
                z = z
            }
            CORRUPTclient.teleport(source, {x, y, z})
        end
    end
end)
RegisterServerEvent("CORRUPT:updateWeapons")
AddEventHandler("CORRUPT:updateWeapons", function(weapons)
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        local data = CORRUPT.getUserDataTable(user_id)
        if data ~= nil and not CORRUPT.inWager(source) then
            data.weapons = weapons
        end
    end
end)

local SessionPlayTime = {}
function CORRUPT.SessionPlayTime(user_id)
    return SessionPlayTime[user_id] or 0
end
Citizen.CreateThread(function()
    while true do
        Wait(60000)
        for k, v in pairs(CORRUPT.getUsers()) do
            local data = CORRUPT.getUserDataTable(k)
            if data ~= nil then
                if data.PlayerTime ~= nil then
                    if not SessionPlayTime[k] then
                        SessionPlayTime[k] = 0
                    else
                        SessionPlayTime[k] = SessionPlayTime[k] + 1
                    end
                    data.PlayerTime = tonumber(data.PlayerTime) + 1
                else
                    data.PlayerTime = 1
                end
            end
            if CORRUPT.hasPermission(k, 'police.armoury') then
                local lastClockedRank = string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '')
                local total_players_fined = exports['corrupt']:execute("SELECT total_players_fined FROM corrupt_police_hours WHERE user_id = @user_id", {user_id = k}) or 0
                local total_players_jailed = exports['corrupt']:execute("SELECT total_players_jailed FROM corrupt_police_hours WHERE user_id = @user_id", {user_id = k}) or 0
                exports['corrupt']:execute(
                    "INSERT INTO corrupt_police_hours (user_id, username, weekly_hours, total_hours, last_clocked_rank, last_clocked_date, total_players_fined, total_players_jailed) VALUES (@user_id, @username, @weekly_hours, @total_hours, @last_clocked_rank, @last_clocked_date, @total_players_fined, @total_players_jailed) ON DUPLICATE KEY UPDATE weekly_hours = weekly_hours + 1/60, total_hours = total_hours + 1/60, username = @username, last_clocked_rank = @last_clocked_rank, last_clocked_date = @last_clocked_date, total_players_fined = @total_players_fined, total_players_jailed = @total_players_jailed",
                    {
                        user_id = k,
                        username = CORRUPT.getPlayerName(v,k),
                        weekly_hours = 1/60,
                        total_hours = 1/60,
                        last_clocked_rank = lastClockedRank,
                        last_clocked_date = os.date("%d/%m/%Y"),
                        total_players_fined = total_players_fined,
                        total_players_jailed = total_players_jailed
                    }
                )                
            end
        end
    end
end)





function CORRUPT.updateInvCap(user_id, invcap)
    if user_id ~= nil then
        local data = CORRUPT.getUserDataTable(user_id)
        if data ~= nil then
            if data.invcap ~= nil then
                data.invcap = invcap
                if CORRUPT.isDeveloper(user_id) then
                    data.invcap = 1000
                end
            else
                data.invcap = 30
            end
        end
    end
end


function CORRUPT.setBucket(source, bucket)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    SetPlayerRoutingBucket(source, bucket)
    TriggerClientEvent('CORRUPT:setBucket', source, bucket)
end

local isStoring = {}
AddEventHandler('CORRUPT:StoreWeaponsRequest', function(source)
    local player = source 
    local user_id = CORRUPT.getUserId(player)
	CORRUPTclient.getWeapons(player,{},function(weapons)
        if not isStoring[player] then
            isStoring[player] = true
            CORRUPTclient.GiveWeaponsToPlayer(player,{{},true}, function(removedwep)
                for k,v in pairs(weapons) do
                    if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k~= 'WEAPON_SMOKEGRENADE' and k~= 'WEAPON_FLASHBANG' then
                        if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                            for i,c in pairs(a.weapons) do
                                if i == k then
                                    CORRUPT.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                end   
                            end
                        end
                    end
                end
                CORRUPT.notify(player,{"~g~Weapons Stored"})
                SetTimeout(3000,function()
                      isStoring[player] = nil 
                end)
            end)
        else
            CORRUPT.notify(player,{"~o~Your weapons are already being stored hmm..."})
        end
    end)
end)
function CORRUPT.isPurge()
    return purgeActive
end
RegisterNetEvent('CORRUPT:forceStoreWeapons')
AddEventHandler('CORRUPT:forceStoreWeapons', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local data = CORRUPT.getUserDataTable(user_id)
    Wait(3000)
    if data ~= nil then
        data.inventory = {}
    end
    CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
        if cb then
            local invcap = 30
            if CORRUPT.isDeveloper(user_id) then
                invcap = 1000
            elseif plathours > 0 then
                invcap = invcap + 20
            elseif plushours > 0 then
                invcap = invcap + 10
            end
            if invcap == 30 then
            return
            end
            if data.invcap - 15 == invcap then
            CORRUPT.giveInventoryItem(user_id, "Off White Bag (+15kg)", 1, false)
            elseif data.invcap - 20 == invcap then
            CORRUPT.giveInventoryItem(user_id, "Gucci Bag (+20kg)", 1, false)
            elseif data.invcap - 30 == invcap  then
            CORRUPT.giveInventoryItem(user_id, "Nike Bag (+30kg)", 1, false)
            elseif data.invcap - 35 == invcap  then
            CORRUPT.giveInventoryItem(user_id, "Hunting Backpack (+35kg)", 1, false)
            elseif data.invcap - 40 == invcap  then
            CORRUPT.giveInventoryItem(user_id, "Green Hiking Backpack (+40kg)", 1, false)
            elseif data.invcap - 70 == invcap  then
            CORRUPT.giveInventoryItem(user_id, "Rebel Backpack (+70kg)", 1, false)
            end
            CORRUPT.updateInvCap(user_id, invcap)
        end
    end)
end)



RegisterServerEvent("CORRUPT:AddChatModes", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local main = {
        name = "Global",
        displayName = "Global",
        isChannel = "Global",
        color = "#0078ff",
        isGlobal = true,
    }
    local ooc = {
        name = "OOC",
        displayName = "OOC",
        isChannel = "OOC",
        color = "#0078ff",
        isGlobal = false,
    }
    local adminchat = {
        name = "Admin",
        displayName = "Admin",
        isChannel = "Admin",
        color = "#FFEB3B",
        isGlobal = false,
    }
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent('chat:addMode', source, adminchat)
    end
    TriggerClientEvent('chat:addMode', source, main)
    TriggerClientEvent('chat:addMode', source, ooc)
end)