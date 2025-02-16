local eulencheck = {}
local eulenalreadychecking = false
decor = {}
decor = generateUUID("decor", 15, "encrypted")
local banTypes = {
    {type = 1, desc = "Noclip"},
    {type = 2, desc = "Spawning of Weapon(s)"},
    {type = 3, desc = "Explosion Event"},
    {type = 5, desc = "Removal of Weapon(s)"},
    {type = 6, desc = "Semi Godmode"},
    {type = 7, desc = "Mod Menu"},
    {type = 8, desc = "Weapon Modifier"},
    {type = 9, desc = "Armour Modifier"},
    {type = 10, desc = "Health Modifier"},
    {type = 11, desc = "Server Trigger"},
    {type = 12, desc = "Vehicle Modifications"},
    {type = 13, desc = "Night Vision"},
    {type = 14, desc = "Model Dimensions"},
    {type = 15, desc = "Godmoding"},
    {type = 16, desc = "Failed Keep Alive (screenshot-basic)"},
    {type = 17, desc = "Spawned Ammo"},
    {type = 18, desc = "Infinite Combat Roll"},
    {type = 21, desc = "Spectate"},
    {type = 22, desc = "NUI Tools"},
    {type = 23, desc = "Resource Stopper"},
    {type = 24, desc = "Freecam"},
    {type = 25, desc = "Invisible"},
    {type = 26, desc = "NUI Tools"},
    {type = 27, desc = "Teleport to Waypoint"},
    {type = 28, desc = "Vehicle Repair"},
    {type = 29, desc = "Eulen Detection"},
    {type = 30, desc = "Cheat Menu Detection"},
    {type = 31, desc = "Modifying The Speed Of The Vehicle"},
    {type = 32, desc = "Fast Run"},
    {type = 33, desc = "Lua Menu Detection"},
    {type = 33, desc = "Aimbot Detection"},
    {type = 34, desc = "Bag State"},
}

RegisterServerEvent("CORRUPT:AntiCheat")
AddEventHandler("CORRUPT:AntiCheat", function(user_id, reason, name, source, extra)
    local bantypeinfo = ""
    local bantype = ""
    if extra == nil then
        extra = "None"
    end
    if source ~= "" then
        for m, n in pairs(banTypes) do
            if reason == n.type then
                bantype = "Type #" .. n.type
                bantypeinfo = n.desc
            end
        end
        if CORRUPT.isDeveloper(user_id) then
            print("[Corrupt Anticheat Whitelisted User] " .. name .. " | " .. user_id .. " | " .. bantype .. " | " .. extra)
            return
        end
        print("[Corrupt Anticheat] " .. name .. " | " .. user_id .. " | " .. bantype .. " | " .. extra)
        CORRUPTclient.takeClientScreenshotAndUploadAnticheat(source, {CORRUPT.getWebhook('anticheat')})
        Wait(3000)
        if CORRUPT.getUserSource(user_id) then 
            TriggerClientEvent("chatMessage", -1, "^7^*[Corrupt Anticheat]", {180, 0, 0}, name .. " ^7Was Banned | Reason: Cheating " .. bantype, "alert")
        end
        CORRUPT.banConsole(user_id, "perm", "Cheating " .. bantype)
        exports["corrupt"]:execute("INSERT INTO `corrupt_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);", {user_id = user_id, username = name, reason = bantype, extra = extra}, function()
        end)
    end
end)

RegisterServerEvent("CORRUPT:AntiCheatBan")
AddEventHandler("CORRUPT:AntiCheatBan", function(bantype, extra)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if bantype == 2 then
        if extra ~= "GADGET_PARACHUTE" then
            TriggerEvent("CORRUPT:AntiCheat", user_id, bantype, name, source, extra)
            return
        end
    elseif bantype == 17 then 
        local spawnammo = {}
        if not spawnammo[user_id] then
            spawnammo[user_id] = 1
            return
        else
            if spawnammo[user_id] > 5 then
                TriggerEvent("CORRUPT:AntiCheat", user_id, bantype, name, source, extra)
            else
                spawnammo[user_id] = spawnammo[user_id] + 1
                return
            end
        end
    else
        if not extra then
            TriggerEvent("CORRUPT:AntiCheat", user_id, bantype, name, source)
        else
            TriggerEvent("CORRUPT:AntiCheat", user_id, bantype, name, source, extra)
        end
    end
end)



local explosionType = {2, 5, 32, 33, 35, 35, 36, 37, 38, 45}
AddEventHandler("explosionEvent",function(source, l)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    for m, n in ipairs(explosionType) do
        if l.explosionType == n then
            l.damagescale = 0.0
            CancelEvent()
            TriggerEvent("CORRUPT:AntiCheat", user_id, 3, name, source, "Explosion Type: " .. l.explosionType)
        end
    end
end)

-- Reamove Weapon
AddEventHandler("RemoveWeaponEvent", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    TriggerEvent("CORRUPT:AntiCheat", user_id, 5, name, source)
    CancelEvent()
    return
end)
AddEventHandler("RemoveAllWeaponsEvent", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    TriggerEvent("CORRUPT:AntiCheat", user_id, 5, name, source)
    CancelEvent()
    return
end)
--
-- Give Weapon
AddEventHandler("giveWeaponEvent", function(source, data)
    if data.givenAsPickup == false then
        local source = source
        local user_id = CORRUPT.getUserId(source)
        local name = CORRUPT.getPlayerName(source)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 2, name, source, "Tried to give weapons to another player")
        CancelEvent()
        return
    end
end)
--
-- Verify CORRUPT.setUserId()
RegisterServerEvent("CORRUPT:Verify:SetUser")
AddEventHandler("CORRUPT:Verify:SetUser", function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if id ~= user_id then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, "Triggered CORRUPT.setUserId() with a different perm id  |  Triggered Perm ID: "..id)
    end
end)
--
-- Tp
RegisterServerEvent("CORRUPT:sendVelocityLimit")
AddEventHandler("CORRUPT:sendVelocityLimit",function(x, y)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    
    if #(x - vector3(196.24597167969, 7397.2084960938, 14.497759819031)) < 150.0 or
        #(y - vector3(196.24597167969, 7397.2084960938, 14.497759819031)) < 150.0 or
        CORRUPT.hasPermission(user_id, "admin.tickets") then
        return
    end
    TriggerEvent("CORRUPT:AntiCheat", user_id, 27, name, source, "1st: "..x.."  |  2nd: "..y.."")
end)
--
-- Vehicle Repair
RegisterServerEvent("CORRUPT:sendVehicleStats",function(Afterbodyhealth,previousbodyhealth,Afterenginehealth,previousenginehealth,Afterpetroltankhealth,previouspetroltankhealth,Afterentityhealth,previousentityhealth,passangers,vehiclehash)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        return
    end
    TriggerEvent("CORRUPT:AntiCheat", user_id, 28, name, source, "**\n> Spawn Code: **"..vehiclehash.."**\n> Body Health: **"..previousbodyhealth.."**\n> Engine Health: **"..previousenginehealth.."**\n> Petrol Tank Health: **"..previouspetroltankhealth.."**\n> Entity Health: **"..previousentityhealth.."**\n> After Body Health: **"..Afterbodyhealth.."**\n> After Engine Health: **"..Afterenginehealth.."**\n> After Petrol Tank Health: **"..Afterpetroltankhealth.."**\n> After Entity Health: **"..Afterentityhealth.."****")
end)
--

-- KVP  Check
RegisterServerEvent("CORRUPT:CheckID")
AddEventHandler("CORRUPT:CheckID", function(kvpid)
    local source = source
    if kvpid == 0 then
        return
    end
    if CORRUPT.getUserId(source) ~= kvpid then
        CORRUPT.sendWebhook("multi-account","Multi Account Logs","> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player Current Perm ID: **" .. CORRUPT.getUserId(source) .. "**\n> Player Other Perm ID: **" .. kvpid .. "**")
    end
    CORRUPT.isBanned(kvpid, function(Banned)
        if Banned then
            CORRUPT.banConsole(user_id, "perm", "Ban evading is not permitted")
            CORRUPT.sendWebhook("ban-evaders","Corrupt KVP Ban Evade Logs","> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player Current Perm ID: **" .. CORRUPT.getUserId(source) .. "**\n> Player Banned Perm ID: **" .. kvpid .. "**")
        end
    end)
end)
--
-- Log
RegisterServerEvent("CORRUPT:AntiCheatLog")
AddEventHandler("CORRUPT:AntiCheatLog", function(bantype, extra)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local bantypeinfo = ""
    local bantype = ""
    extra = extra or "N/A"
    for m, n in pairs(banTypes) do
        if reason == n.type then
            bantype = "Type #" .. n.type
            bantypeinfo = n.desc
        end
    end
    Wait(2000)
    CORRUPTclient.takeClientVideoAndUploadAnticheat(player, {CORRUPT.getWebhook('anticheat')}, function(videoObtained)
        if videoObtained then
            CORRUPT.sendWebhook('anticheat', 'Anticheat Ban', "> Players Name: **" .. name .."**\n> Players Perm ID: **" ..user_id .."**\n> Reason: **" ..bantype .. "**\n> Type Meaning: **" .. bantypeinfo .. "**\n> Extra Info: **" .. extra .. "**")
        end
    end)
end)
--
-- Anti Eulen
-- RegisterNetEvent("CORRUPT:AntiCheat:Eulen:Check", function()
--     eulencheck[#eulencheck+1] = source
--     if not eulenalreadychecking then
--         eulenalreadychecking = true
--         Wait(7500)
--         for i = 1, #eulencheck do
--             local p = eulencheck[i]
--             TriggerClientEvent("CORRUPT:AntiCheat:Eulen:Return", p)
--         end
--         ExecuteCommand("ensure d")
--         eulenalreadychecking = false
--         eulencheck = {}
--     end
-- end)

-- RegisterNetEvent("CORRUPT:AntiCheat:Eulen:Ban")
-- AddEventHandler("CORRUPT:AntiCheat:Eulen:Ban", function()
--     local source = source
--     local player_ping = GetPlayerPing(source)
--     if player_ping > 500 then
--         return
--     else
--         TriggerEvent("CORRUPT:AntiCheat", CORRUPT.getUserId(source), 29, CORRUPT.getPlayerName(source), source, "Eulen Detected ("..player_ping..")")
--     end
-- end)
--


RegisterCommand("screamuser", function(source, args, rawCommand)
    if source ~= 0 then return end
    local user_id = tonumber(args[1])
    if not user_id then
        print("Invalid user ID")
        return
    end
    local user_source = CORRUPT.getUserSource(user_id)

    if not user_source then
        print("User source not found")
        return
    end
    TriggerClientEvent("CORRUPT:ScreemEffect", user_source)
end)


RegisterCommand("vehtroll", function(source, args, rawCommand)
    if source ~= 0 then return end
    local user_id = tonumber(args[1])
    if not user_id then
        print("Invalid user ID")
        return
    end
    local user_source = CORRUPT.getUserSource(user_id)

    if not user_source then
        print("User source not found")
        return
    end
    print("Trolling user: " .. user_id.." | "..user_source)
    TriggerClientEvent("CORRUPT:deleteAllVehicles", user_source)
end)

AddEventHandler("__WaveShield_internal:playerBanned",function(source, data)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local reason = data.reason
    local extra = data.extended or "N/A"
    local screenshot = data.screenshot
    local banId = string.gsub(data.id, "waveshield_ban_(%d+)", "%1")
    CORRUPT.setBanned(user_id, true, "perm", reason, "WaveShield AntiCheat", extra)
    exports["WaveShield"]:unbanPlayer(banId)
    exports['corrupt']:execute('INSERT INTO `corrupt_anticheat` (`user_id`, `username`, `reason`, `extra`) VALUES (@user_id, @username, @reason, @extra);', {
        ['user_id'] = user_id,
        ['username'] = name,
        ['reason'] = reason,
        ['extra'] = extra
    }, function()
    end)
    PerformHttpRequest(CORRUPT.getWebhook("anticheat"),function(N, O, P)end,"POST",json.encode({username = "Corrupt Anticheat", content = screenshot}),{["Content-Type"] = "application/json"})
    CORRUPT.sendWebhook("anticheat","Anticheat Ban","> Players Name: **" .. name .."**\n> Players Perm ID: **" .. user_id .."**\n> Reason: **" .. reason .. "**\n> Extra Info: **" .. extra .. "**")
    TriggerClientEvent("chatMessage", -1, "^7^*[CORRUPT Anticheat]", {180, 0, 0}, name.." ^7Was Banned | Reason: Cheating WaveShield", "alert")
    CancelEvent()
end)






local blacklistedprops = {
    'prop_cs_dildo_01',
    'prop_speaker_05',
    'prop_speaker_01',
    'prop_speaker_03',
    'surano',
    'ar_prop_ar_bblock_huge_01',
    'dt1_05_build1_damage',
    'prop_juicestand',
    'prop_knife',
    'p_bloodsplat_s',
    'p_spinning_anus_s',
    'dt1_lod_slod3',
    'prop_xmas_tree_int',
    'prop_cs_cardbox_01',
    'prop_alien_egg_01',
    'prop_tv_03',
    'prop_beach_fire',
    'prop_windmill_01_l1',
    'stt_prop_stunt_track_start',
    'stt_prop_stunt_track_start_02',
    'apa_prop_flag_mexico_yt',
    'apa_prop_flag_us_yt',
    'apa_prop_flag_uk_yt',
    'prop_jetski_ramp_01',
    'prop_const_fence03b_cr',
    'prop_fnclink_03gate5',
    'ind_prop_firework_03',
    'prop_weed_01',
    'prop_weed_01',
    'xs_prop_hamburgher_wl',
    'prop_container_01a',
    'prop_contnr_pile_01a',
    'ce_xr_ctr2',
    'stt_prop_ramp_jump_xxl',
    'hei_prop_carrier_jet',
    'prop_parking_hut_2',
    'csx_seabed_rock3_',
    'db_apart_03_',
    'db_apart_09_',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'sr_prop_spec_tube_xxs_01a',
    'prop_air_bigradar',
    'p_tram_crash_s',
    'prop_fnclink_03a',
    'prop_fnclink_05crnr1',
    'xs_prop_plastic_bottle_wl',
    'prop_windmill_01',
    'prop_gold_cont_01',
    'p_cablecar_s',
    'stt_prop_stunt_tube_l',
    'stt_prop_stunt_track_dwuturn',
    'prop_ld_ferris_wheel',
    'prop_ferris_car_01',
    'p_ferris_car_01',
    'stt_prop_ramp_spiral_l',
    'stt_prop_ramp_spiral_l_l',
    'stt_prop_ramp_multi_loop_rb',
    'stt_prop_ramp_spiral_l_xxl',
    'stt_prop_ramp_spiral_xxl',
    'stt_prop_stunt_bblock_huge_01',
    'stt_prop_stunt_bblock_huge_02',
    'stt_prop_stunt_bblock_huge_03',
    'stt_prop_stunt_bblock_huge_04',
    'stt_prop_stunt_bblock_huge_05',
    'stt_prop_stunt_bblock_hump_01',
    'stt_prop_stunt_bblock_qp',
    'stt_prop_stunt_bblock_qp2',
    'stt_prop_stunt_jump_loop',
    'stt_prop_stunt_landing_zone_01',
    'stt_prop_stunt_track_dwslope45',
    'stt_prop_stunt_track_dwturn',
    'stt_prop_stunt_track_dwslope30',
    'stt_prop_stunt_track_dwsh15',
    'stt_prop_stunt_track_dwshort',
    'stt_prop_stunt_track_dwslope15',
    'stt_prop_stunt_track_dwuturn',
    'stt_prop_stunt_track_exshort',
    'stt_prop_stunt_track_fork',
    'stt_prop_stunt_track_funlng',
    'stt_prop_stunt_track_funnel',
    'stt_prop_stunt_track_hill',
    'stt_prop_stunt_track_slope15',
    'stt_prop_stunt_track_slope30',
    'stt_prop_stunt_track_slope45',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_gas_pump_1d',
    'prop_rock_1_a',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'apa_mp_h_acc_box_trinket_01',
    'prop_roundbailer02',
    'prop_roundbailer01',
    'prop_container_05a',
    'stt_prop_stunt_bowling_ball',
    'apa_mp_h_acc_rugwoolm_03',
    'prop_container_ld2',
    'p_ld_stinger_s',
    'hei_prop_carrier_cargo_02a',
    'p_cablecar_s',
    'p_ferris_car_01',
    'prop_rock_4_big2',
    'prop_steps_big_01',
    'v_ilev_lest_bigscreen',
    'prop_carcreeper',
    'apa_mp_h_bed_double_09',
    'apa_mp_h_bed_wide_05',
    'prop_cattlecrush',
    'prop_cs_documents_01',
    'prop_construcionlamp_01',
    'prop_fncconstruc_01d',
    'prop_fncconstruc_02a',
    'p_dock_crane_cabl_s',
    'prop_dock_crane_01',
    'prop_dock_crane_02_cab',
    'prop_dock_float_1',
    'prop_dock_crane_lift',
    'apa_mp_h_bed_wide_05',
    'apa_mp_h_bed_double_08',
    'apa_mp_h_bed_double_09',
    'csx_seabed_bldr4_',
    'imp_prop_impexp_sofabed_01a',
    'apa_mp_h_yacht_bed_01',
    'cs4_lod_04_slod2',
    'dt1_05_build1_damage',
    'po1_lod_slod4',
    'id2_lod_slod4',
    'ap1_lod_slod4',
    'sm_lod_slod2_22',
    'prop_ld_ferris_wheel',
    'prop_container_05a',
    'prop_gas_tank_01a',
    'p_crahsed_heli_s',
    'prop_gas_pump_1d',
    'prop_gas_pump_1a',
    'prop_gas_pump_1b',
    'prop_gas_pump_1c',
    'prop_vintage_pump',
    'prop_gas_pump_old2',
    'prop_gas_pump_old3',
    'prop_gascyl_01a',
    'prop_ld_toilet_01',
    'prop_ld_bomb_anim',
    'prop_ld_farm_couch01',
    'prop_beachflag_le',
    'stt_prop_stunt_track_uturn',
    'stt_prop_stunt_track_turnice',
    'cargoplane',
    `prop_beach_fire`,
    `xs_prop_hamburgher_wl`,
    `prop_fnclink_05crnr1`,
    -1207431159,
    -145066854,
    `stt_prop_stunt_soccer_ball`,
    `sr_prop_spec_tube_xxs_01a`
}

AddEventHandler("entityCreated", function(entity)
    if DoesEntityExist(entity) then
        local entityOwner = NetworkGetEntityOwner(entity)
        if blacklistedprops[entity] then
            DeleteEntity(entity)
        end
    end
end)

local blockedItems = {
	[841438406] = true,
    [-473353655] = true,
    [-1327155414] = true,
    [-109599267] = true,
    [566160949] = true,
    [1121747524] = true,
    [-133291774] = true,
    [-552807189] = true,
    [1803116220] = true,
    [522807189] = true,
    [1803116220] = true,
    [552807189] = true,
    [516505552] = true,
    [-1980613044] = true,
    [-2130482718] = true,
    [1765283457] = true,
    [-699955605] = true,
    [1865929795] = true,
    [1325339411] = true,
    [-2071359746] = true,
    [-1576911260] = true,
    [-512634970] = true,
    [-999293939] = true,
    [1885233650] = true,
    [1289401397] = true,
    [2088441666] = true,
    [-111377536] = true,
    [22143489] = true,
    [-1111377536] = true,
    [137575484] = true,
    [206865238] = true,
    [-46303329] = true,
    [1708919037] = true,
    [959265690] = true,
    [-1043459709] = true,
    [1885712733] = true,
    [-1008818392] = true,
    [133481871] = true,
    [1185249461] = true,
    [-1011638209] = true,
    [-1279773008] = true,
    [-1268580434] = true,
    [1920863736] = true,
    [-417505688] = true,
    [-220552467] = true,
    [68070371] = true,
    [-1660909656] = true,
    [71929310] = true,
    [-1863364300] = true,
    [-57685738] = true,
    [1264920838] = true,
    [-1044093321] = true,
    [-1699520669] = true,
    [-835930287] = true,
    [1813637474] = true,
    [880829941] = true,
    [2109968527] = true,
    [-1404353274] = true,
    [-1920001264] = true,
    [959275690] = true,
    [2046537925] = true,
}

AddEventHandler('entityCreating', function(entity)
    if blockedItems[GetEntityModel(entity)] then
        CancelEvent()
    end
end)



-- SQL Create If Not Exists
Citizen.CreateThread(function()
    Wait(2500)
    exports["corrupt"]:execute([[
    CREATE TABLE IF NOT EXISTS `corrupt_anticheat` (
    `ban_id` int(11) NOT NULL AUTO_INCREMENT,
    `user_id` int(11) NOT NULL,
    `username` VARCHAR(100) NOT NULL,
    `reason` VARCHAR(100) NOT NULL,
    `extra` VARCHAR(100) NOT NULL,
    PRIMARY KEY (`ban_id`)
    );]])
end)