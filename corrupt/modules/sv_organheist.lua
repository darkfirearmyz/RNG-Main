local cfg = module('cfg/cfg_organheist')
local organlocationcfg = {}
local organlocation = {["police"] = {}, ["civ"] = {}}
local playersInOrganHeist = {}
organlocationname = ""
local organroom = {["police"] = 0, ["civ"] = 0}
local timeTillOrgan = 0
local inWaitingStage = false
local inGamePhase = false
local policeInGame = 0
local civsInGame = 0

function CORRUPT.SetOrganLocations()
    if tonumber(os.date("%j")) % 2 == 1 then
        organlocationcfg = cfg.locations["Morgue"]
        organlocationname = "Morgue"
    else
        organlocationcfg = cfg.locations["Abandoned Silo"]
        organlocationname = "Abandoned Silo"
    end    
    TriggerEvent("CORRUPT:organHeistSet", organlocationname)
    local mathrandom = math.random(2)
    local side1 = organlocationcfg.sides[1]
    local side2 = organlocationcfg.sides[2]
    if mathrandom == 1 then
        organlocation["police"] = side1.safePositions[math.random(#side1.safePositions)]
        organlocation["civ"] = side2.safePositions[math.random(#side2.safePositions)]
        organroom["police"] = 1
        organroom["civ"] = 2
    else
        organlocation["police"] = side2.safePositions[math.random(#side2.safePositions)]
        organlocation["civ"] = side1.safePositions[math.random(#side1.safePositions)]
        organroom["police"] = 2
        organroom["civ"] = 1
    end
end
CORRUPT.SetOrganLocations()

RegisterNetEvent("CORRUPT:joinOrganHeist")
AddEventHandler("CORRUPT:joinOrganHeist", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not playersInOrganHeist[source] then
        if inWaitingStage then
            if CORRUPT.hasPermission(user_id, 'police.armoury') then
                playersInOrganHeist[source] = {type = 'police'}
                policeInGame = policeInGame+1
                TriggerClientEvent('CORRUPT:addOrganHeistPlayer', -1, source, 'police')
                TriggerClientEvent('CORRUPT:teleportToOrganHeist', source, organlocation["police"], timeTillOrgan, 'police', organlocationname, organroom["police"])
            elseif CORRUPT.hasPermission(user_id, 'nhs.menu') then
                CORRUPT.notify(source, {'~r~You cannot enter Organ Heist whilst clocked on NHS.'})
            else
                playersInOrganHeist[source] = {type = 'civ'}
                civsInGame = civsInGame+1
                TriggerClientEvent('CORRUPT:addOrganHeistPlayer', -1, source, 'civ')
                TriggerClientEvent('CORRUPT:teleportToOrganHeist', source, organlocation["civ"], timeTillOrgan, 'civ', organlocationname, organroom["civ"])
                if CORRUPT.hasPermission(user_id, 'vip.gunstore') then
                    CORRUPTclient.GiveWeaponsToPlayer(source, {{['WEAPON_UMP45'] = {ammo = 250}}, false})
                else
                    CORRUPTclient.GiveWeaponsToPlayer(source, {{['WEAPON_ROOK'] = {ammo = 250}}, false})
                end
            end
            CORRUPT.setBucket(source, 15)
            CORRUPT.setArmour(source, 100, true)
        else
            CORRUPT.notify(source, {'The organ heist has already started.'})
        end
    end
end)



RegisterNetEvent("CORRUPT:diedInOrganHeist")
AddEventHandler("CORRUPT:diedInOrganHeist", function(killer)
    local source = source
    if playersInOrganHeist[source] then
        if CORRUPT.getUserId(killer) ~= nil then
            local killerID = CORRUPT.getUserId(killer)
            CORRUPT.giveBankMoney(killerID, 50000)
            TriggerClientEvent('CORRUPT:organHeistKillConfirmed', killer, CORRUPT.getPlayerName(source))
        end
        TriggerClientEvent('CORRUPT:endOrganHeist', source)
        TriggerClientEvent('CORRUPT:removeFromOrganHeist', -1, source)
        CORRUPT.setBucket(source, 0)
        CORRUPTclient.setPlayerCombatTimer(source, {0})
        playersInOrganHeist[source] = nil
    end
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    if playersInOrganHeist[source] then
        playersInOrganHeist[source] = nil
        TriggerClientEvent('CORRUPT:removeFromOrganHeist', -1, source)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        TriggerEvent("CORRUPT:OrganGreenzone")
        if inGamePhase then
            local policeAlive = 0
            local civAlive = 0
            for k,v in pairs(playersInOrganHeist) do
                if v.type == 'police' then
                    policeAlive = policeAlive + 1
                elseif v.type == 'civ' then
                    civAlive = civAlive +1
                end
            end
            if policeAlive == 0 or civAlive == 0 then
                for k,v in pairs(playersInOrganHeist) do
                    if policeAlive == 0 then
                        TriggerClientEvent('CORRUPT:endOrganHeistWinner', k, 'Civillians')
                    elseif civAlive == 0 then
                        TriggerClientEvent('CORRUPT:endOrganHeistWinner', k, 'Police')
                    end
                    TriggerClientEvent('CORRUPT:endOrganHeist', k)
                    CORRUPT.setBucket(k, 0)
                    CORRUPT.giveBankMoney(CORRUPT.getUserId(k), 250000)
                    CORRUPTclient.setPlayerCombatTimer(k, {0})
                end
                playersInOrganHeist = {}
                inWaitingStage = false
                inGamePhase = false
            end
        else
            if timeTillOrgan > 0 then
                timeTillOrgan = timeTillOrgan - 1
            end
            if tonumber(time["hour"]) == 18 and tonumber(time["min"]) >= 50 and tonumber(time["sec"]) == 0 then
                inWaitingStage = true
                timeTillOrgan = ((60-tonumber(time["min"]))*60)
                TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in "..math.floor((timeTillOrgan/60)).." minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
            elseif tonumber(time["hour"]) == 19 and tonumber(time["min"]) == 00 and tonumber(time["sec"]) == 0 then
                if civsInGame > 0 and policeInGame > 0 then
                    TriggerClientEvent('CORRUPT:startOrganHeist', -1)
                    inGamePhase = true
                    inWaitingStage = false
                else
                    for k,v in pairs(playersInOrganHeist) do
                        TriggerClientEvent('CORRUPT:endOrganHeist', k)
                        CORRUPT.notify(k, {'Organ Heist was cancelled as not enough players joined.'})
                        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                        CORRUPT.setBucket(k, 0)
                    end
                end
            end
        end
    end
end)
local greenzone = false

RegisterServerEvent("CORRUPT:OrganGreenzone", function()
    if greenzone then
        return
    end
    if inGamePhase then
        TriggerClientEvent("CORRUPT:createOrganHeistGreenzone", -1, false)
        greenzone = false
    elseif inWaitingStage and not greenzone then
        TriggerClientEvent("CORRUPT:createOrganHeistGreenzone", -1, true)
        greenzone = true
    end
end)



RegisterCommand('skiporgan', function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.isDeveloper(user_id) then end;
    if not inGamePhase then
        if civsInGame > 0 and policeInGame > 0 then
            TriggerClientEvent('CORRUPT:startOrganHeist', -1)
            inGamePhase = true
            inWaitingStage = false
        else
            for k,v in pairs(playersInOrganHeist) do
                TriggerClientEvent('CORRUPT:endOrganHeist', k)
                CORRUPT.notify(k, {'Organ Heist was cancelled as not enough players joined.'})
                SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
                CORRUPT.setBucket(k, 0)
            end
        end
    end
end)

RegisterCommand('startorgan', function(source, args, rawCommand)
    local time = os.date("*t")
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.isDeveloper(user_id) then return end;
    if inGamePhase or inWaitingStage then
        CORRUPT.notify(source, {'~r~Organ Heist is already in progress.'})
        return
    end
    timeTillOrgan = 60 * 10
    print(timeTillOrgan)
    inWaitingStage = true
    for i = 10, 1, -1 do
        if inGamePhase then
            return
        end
        TriggerClientEvent('chatMessage', -1, "^7Organ Heist begins in "..i.." minutes! Make your way to the Morgue with a weapon!", { 128, 128, 128 }, message, "alert")
        timeTillOrgan = timeTillOrgan - 60
        print(timeTillOrgan)
        Citizen.Wait(60 * 1000) 
    end
    inWaitingStage = false
    if civsInGame > 0 and policeInGame > 0 then
        TriggerClientEvent('CORRUPT:startOrganHeist', -1)
        inGamePhase = true
    else
        for k,v in pairs(playersInOrganHeist) do
            TriggerClientEvent('CORRUPT:endOrganHeist', k)
            CORRUPT.notify(k, {'Organ Heist was cancelled as not enough players joined.'})
            SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
            CORRUPT.setBucket(k, 0)
        end
    end
end)

RegisterCommand('endorgan', function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.isDeveloper(user_id) then return end;
    for k,v in pairs(playersInOrganHeist) do
        TriggerClientEvent('CORRUPT:endOrganHeist', k)
        CORRUPT.notify(k, {'Organ Heist was ended by an admin.'})
        SetEntityCoords(GetPlayerPed(k), 240.31098937988, -1379.8699951172, 33.741794586182)
        CORRUPT.setBucket(k, 0)
    end
    playersInOrganHeist = {}
    inWaitingStage = false
    inGamePhase = false
end)