local f = module("corrupt-assets", "cfg/weapons")
f = f.weapons
illegalWeapons = f.nativeWeaponModelsToNames

function getWeaponName(weapon)
    for k,v in pairs(f) do
        if weapon == 'Mosin Nagant' then
            return 'Heavy'
        elseif weapon == 'Nerf Mosin' then
            return 'Heavy'
        elseif weapon == 'CB Mosin' then
            return 'Heavy'
        elseif weapon == 'Fists' then
            return 'Fist'
        elseif weapon == 'Fire' then
            return 'Fire'
        elseif weapon == 'Explosion' then
            return 'Explode'
        elseif weapon == 'Suicide' then
            return 'Suicide'
        end
        if v.name == weapon then
            return v.class
        end
    end
    return "Unknown"
end

function getweaponnames(weapon)
    for k,v in pairs(f) do
        if v.name == weapon then
            return v.name
        end
    end
    return "Unknown"
end

local function checkIfMosin(weapon)
    for k, v in pairs(f) do
        if v.name == weapon and string.find(weapon, "mosin") then
            return true
        end
    end
end
local KD = {
    [102] = {
        kills = 100,
        deaths = 5,
    }
}


function CORRUPT.getKd(user_id)
    local source = CORRUPT.getUserSource(user_id)
    local kills = KD[source] and KD[source].kills or 0
    local deaths = KD[source] and KD[source].deaths or 0
    local kdratio = 0.0
    if deaths ~= 0 then
        kdratio = string.format("%.1f", kills/deaths)
    end
    return {kills = kills, deaths = deaths, kdratio = kdratio}
end


function CORRUPT.getUsersByKD(kd)
    local users = {}
    kd = tonumber(kd)
    for k,v in pairs(KD) do
        local ratio = v.kills / v.deaths
        if ratio >= kd then
            local userId = CORRUPT.getUserId(k)
            if userId then
                table.insert(users, userId)
            end
        end
    end
    Wait(100)
    return users
end





RegisterNetEvent('CORRUPT:onPlayerKilled')
AddEventHandler('CORRUPT:onPlayerKilled', function(killtype, killer, weaponhash, suicide, distance, head)
    local source = source
    local killergroup = 'none'
    local killedgroup = 'none'
    local killer_id = CORRUPT.getUserId(killer)
    local user_id = CORRUPT.getUserId(source)
    local weaponhash = weaponhash or "Undefined"
    local distance = distance and math.floor(distance) or 0
    if not user_id then return end;
    if not KD[source] then
        KD[source] = {kills = 0, deaths = 0}
    end
    KD[source].deaths = KD[source].deaths + 1
    if CORRUPT.inWager(source) then
        CORRUPT.handleWagerDeath(source, killer)
    end
    if killtype == 'killed' then
        if CORRUPT.hasPermission(user_id, 'police.armoury') then
            killedgroup = 'police'
        elseif CORRUPT.hasPermission(user_id, 'nhs.menu') then
            killedgroup = 'nhs'
        end

        if CORRUPT.hasPermission(killer_id, 'police.armoury') then
            killergroup = 'police'
        elseif CORRUPT.hasPermission(killer_id, 'nhs.menu') then
            killergroup = 'nhs'
        end

        if killer ~= nil then
            if not KD[killer] then
                KD[killer] = {kills = 0, deaths = 0}
            end
            KD[killer].kills = KD[killer].kills + 1
            TriggerClientEvent('CORRUPT:newKillFeed', -1, CORRUPT.getPlayerName(killer), CORRUPT.getPlayerName(source), getWeaponName(weaponhash), suicide, distance, killedgroup, killergroup, head)
            TriggerClientEvent('CORRUPT:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
            CORRUPT.sendWebhook("kills", "CORRUPT Kill Logs", "> Killer Name: **"..CORRUPT.getPlayerName(killer).."**\n> Killer ID: **"..killer_id.."**\n> Victim Name: **"..CORRUPT.getPlayerName(source).."**\n> Victim ID: **"..CORRUPT.getUserId(source).."**\n> Weapon Used: **"..weaponhash.."**\n> Distance: **"..distance.."m**\n> Kill Type: **"..killtype.."**\n> Headshot: **"..tostring(head).."**")
            CORRUPT.addPlayerKillToVideoQueue(killer_id)
            if CORRUPT.isPurge() then
                CORRUPT.addPurgeKill(killer_id, CORRUPT.getPlayerName(killer))
            end
            CORRUPT.AddStats("kills", killer_id, 1)
            CORRUPT.AddStats("deaths", user_id, 1)
            CORRUPTclient.isStaffedOn(source, {}, function(staffedOn)
                if not staffedOn and not CORRUPT.hasPermission(killer_id, "police.armoury") and not CORRUPT.isDeveloper(killer_id) then
                    CORRUPTclient.getPlayerCombatTimer(killer, {}, function(timer)
                        if timer < 57 then
                            CORRUPTclient.takeClientScreenshotAndUploadAnticheat(source, {CORRUPT.getWebhook("trigger-bot")})
                        end
                    end)
                end
            end)
            if CORRUPT.getPlayerName(killer) and CORRUPT.getPlayerName(source) and killer_id and user_id and getweaponnames(weaponhash) and distance then
                CORRUPT.addPlayerKillToVideoQueue(killer_id)
            end
        else
            TriggerClientEvent('CORRUPT:newKillFeed', -1, CORRUPT.getPlayerName(source), CORRUPT.getPlayerName(source), 'suicide', suicide, distance, killedgroup, killergroup)
            TriggerClientEvent('CORRUPT:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
        end
    end
end)

AddEventHandler('weaponDamageEvent', function(source, data)
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if user_id == nil then return end;
    local weaponType = data.weaponType

    if (weaponType == 911657153 or weaponType == 3452007600) and not (CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu')) then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 8, name, source, "Using a weapon that is not allowed" .. weaponType)
    end
    if weaponType == 2725352035 and data.silenced and data.weaponDamage == 0 then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 8, name, source, "Skript fold option (Edging)")
    end
    if weaponType == 3452007600 and data.silenced and data.weaponDamage == 0 then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 8, name, source, "Skript fold option (Edging) (2)")
    end
    CORRUPT.sendWebhook('damage', "Corrupt Damage Logs",
        "> Player Name: **" .. name .. "**\n" ..
        "> Player Temp ID: **" .. source .. "**\n" ..
        "> Player Perm ID: **" .. user_id .. "**\n" ..
        "> Damage: **" .. data.weaponDamage .. "**\n" ..
        "> Weapon Type: **" .. weaponType .. "**"
    )
end)
