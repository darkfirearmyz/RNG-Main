local battleroyale = module("cfg/events/cfg_battleroyale")
local a = module("corrupt-assets", "cfg/weapons")
local weapons = battleroyale.lootTable
local eventstarted = false
local currentEvent = {
    players = {},
    isActive = false,
    data = {},
    eventId = 0,
    eventName = "",
    drawPlayersTimeBar = true,
    minPlayers = 5,
    maxPlayers = 50,
}
local servermaxplayers = #GetPlayers()
local playernormaltable = {}

local LootBoxData = {}
local ArmourPlateData = {}
local plateId = 1
local boxId = 1
local coordstoplateid = {}
local coordstoboxid = {}

function CORRUPT.Event()
    return currentEvent.isActive
end
local eventtableplayers = {}


RegisterServerEvent("CORRUPT:requestIsAnyEventActive", function()
    local source = source
    TriggerClientEvent("CORRUPT:syncPlayers", source, currentEvent.players, currentEvent.eventId)
    TriggerClientEvent("CORRUPT:setIsAnyEventActive", source, currentEvent.isActive)
    TriggerClientEvent("CORRUPT:setMaxPlayers", source, servermaxplayers)
end)



Citizen.CreateThread(function()
    while currentEvent.isActive do
        Citizen.Wait(1000)
        -- check if > 1 player is active
        players = currentEvent.players
        if players == nil or next(players) == nil then
            TriggerClientEvent("CORRUPT:eventCleanup", -1, true, currentEvent.eventName)
            currentEvent.isActive = false
            currentEvent.eventId = 0
            currentEvent.eventName = ""
            currentEvent.data = {}
            currentEvent.players = {}
            TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
            TriggerClientEvent("CORRUPT:setIsAnyEventActive", -1, false)
        end
    end
end)




RegisterServerEvent("CORRUPT:startEventFully", function(eventId)
    local source = source
    if currentEvent.eventId == eventId then
        if #currentEvent.players < currentEvent.data.minPlayers then
            for k, v in pairs(currentEvent.players) do
                TriggerClientEvent("CORRUPT:startEventFully", k, currentEvent.data)
                if currentEvent.eventName == "Corrupt Battlegrounds" then
                    CORRUPT.setBucket(source, currentEvent.eventId)
                    TriggerClientEvent("CORRUPT:startBattlegrounds", k, currentEvent.data.info.locationIndex)
                    TriggerEvent("CORRUPT:startBattleGrounds", currentEvent)
                end
            end
        else
            for k, v in pairs(currentEvent.players) do
                currentEvent.isActive = false
                currentEvent.eventId = 0
                currentEvent.eventName = ""
                currentEvent.data = {}
                currentEvent.players = {}
                for k, v in pairs(playernormaltable) do
                    local cdata = CORRUPT.getUserDataTable(CORRUPT.getUserId(k))
                    cdata.inventory = v.inv
                    cdata.weapons = v.invweapons
                    TriggerEvent('CORRUPT:RefreshInventory', k)
                    CORRUPTclient.GiveWeaponsToPlayer(k, {v.weapons, true})
                    CORRUPT.setBucket(k, 0)
                end
                playernormaltable = {}
                TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
                TriggerClientEvent("CORRUPT:eventCleanup", -1, false, currentEvent.eventName)
            end
        end
    end
end)


RegisterServerEvent("CORRUPT:startEvent", function(eventtype, eventtitle, minPlayers, maxPlayers, info)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        TriggerClientEvent("CORRUPT:announceEventJoinable", -1, eventtype, maxPlayers)
        currentEvent.isActive = true
        currentEvent.eventId = math.random(10000, 1000000)
        currentEvent.eventName = eventtitle
        currentEvent.data = {minPlayers = minPlayers, maxPlayers = maxPlayers, info = {locationIndex = info.locationIndex, locationName = info.name, minPlayers = minPlayers, maxPlayers = maxPlayers}}
        TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
    end
end)

RegisterServerEvent("CORRUPT:cancelEvent", function(eventId)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        if currentEvent.eventId == eventId then
            currentEvent.isActive = false
            currentEvent.eventId = 0
            currentEvent.eventName = ""
            currentEvent.data = {}
            currentEvent.players = {}
            -- give back weapons and inventory
            for k, v in pairs(playernormaltable) do
                local cdata = CORRUPT.getUserDataTable(CORRUPT.getUserId(k))
                cdata.inventory = v.inv
                cdata.weapons = v.invweapons
                TriggerEvent('CORRUPT:RefreshInventory', k)
                CORRUPTclient.GiveWeaponsToPlayer(k, {v.weapons, true})
                CORRUPT.setBucket(k, 0)
            end
            playernormaltable = {}
            TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
            TriggerClientEvent("CORRUPT:eventCleanup", -1, false, currentEvent.eventName)
        end
    end
end)
RegisterServerEvent("CORRUPT:joinEventServer")
AddEventHandler("CORRUPT:joinEventServer", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        if #currentEvent.players >= currentEvent.data.maxPlayers then
            CORRUPT.notify(source, {"~r~The event is full"})
            return
        end
        if currentEvent.isActive then
            local name = CORRUPT.getPlayerName(source)
            CORRUPTclient.getWeapons(source, {}, function(weapons)
                local cdata = CORRUPT.getUserDataTable(user_id)
                playernormaltable[source] = {inv = cdata.inventory, invweapons = cdata.weapons, coords = GetEntityCoords(GetPlayerPed(source)), health = GetEntityHealth(GetPlayerPed(source)), armour = GetPedArmour(GetPlayerPed(source)), weapons = weapons}
                cdata.inventory = {}
                cdata.weapons = {}
                Citizen.Wait(500)
                TriggerEvent('CORRUPT:RefreshInventory', source)
                playernormaltable[source].weapons = weapons
                RemoveAllPedWeapons(GetPlayerPed(source), true)
            end)
            currentEvent.players[source] = {source = source, user_id = user_id, name = name, active = true}
            TriggerClientEvent("CORRUPT:startEventSequence", source)
            CORRUPT.setBucket(source, currentEvent.eventId) 
            TriggerClientEvent("CORRUPT:addEventPlayer", -1, {source = source, user_id = user_id, name = name, active = true})
            TriggerClientEvent("CORRUPT:syncPlayers", source, currentEvent.players, currentEvent.eventId)
            RemoveAllPedWeapons(GetPlayerPed(source), true)
            if CORRUPT.isDeveloper(user_id) then
                TriggerClientEvent("CORRUPT:startHostEventMenu", source)
            end
        else
            CORRUPT.notify(source, {"~r~No event is active at the moment"})
        end
    end
end)

RegisterCommand("leaveevent", function(source)
    local user_id = CORRUPT.getUserId(source)
    if currentEvent.players[source] then
        TriggerClientEvent("CORRUPT:removeEventPlayer", -1, currentEvent.players[source])
        TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
        -- CORRUPTclient.teleport(source, {table.unpack(playernormaltable[source].coords)})
        TriggerClientEvent("CORRUPT:tpcoordsevent", source, playernormaltable[source].coords.x, playernormaltable[source].coords.y, playernormaltable[source].coords.z)
        TriggerClientEvent("CORRUPT:eventCleanup", source, false, currentEvent.eventName)
        CORRUPT.setBucket(source, 0)
        local cdata = CORRUPT.getUserDataTable(user_id)
        cdata.inventory = playernormaltable[source].inv
        cdata.weapons = playernormaltable[source].invweapons
        CORRUPTclient.GiveWeaponsToPlayer(source, {playernormaltable[source].weapons, true})
        Citizen.Wait(1000)
        TriggerEvent('CORRUPT:RefreshInventory', source)
        TriggerClientEvent("CORRUPT:setHealthClient", source, playernormaltable[source].health)
        CORRUPT.setArmour(source, playernormaltable[source].armour)
        currentEvent.players[source] = nil
        playernormaltable[source] = nil
    else
        CORRUPT.notify(source, {"~r~You are not in an event"})
    end
end)


RegisterServerEvent("CORRUPT:kickPlayerFromEvent", function(PlayerSource, eventId)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        if currentEvent.eventId == eventId then
            CORRUPT.notify(PlayerSource, {"~r~You have been kicked from the event"})
            CORRUPT.notify(source, {"~r~You have kicked "..CORRUPT.getPlayerName(PlayerSource).." from the event"})
            TriggerClientEvent("CORRUPT:removeEventPlayer", -1, currentEvent.players[PlayerSource])
            TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
            TriggerClientEvent("CORRUPT:eventCleanup", PlayerSource, false, currentEvent.eventName)
            TriggerClientEvent("CORRUPT:removePlayerFromBR", -1, PlayerSource)
            TriggerClientEvent("CORRUPT:tpcoordsevent", source, playernormaltable[PlayerSource].coords.x, playernormaltable[PlayerSource].coords.y, playernormaltable[PlayerSource].coords.z)
            local cdata = CORRUPT.getUserDataTable(CORRUPT.getUserId(PlayerSource))
            cdata.inventory = playernormaltable[PlayerSource].inv
            cdata.weapons = playernormaltable[PlayerSource].invweapons
            CORRUPTclient.GiveWeaponsToPlayer(PlayerSource, {playernormaltable[PlayerSource].weapons, true})
            Citizen.Wait(1000)
            TriggerEvent('CORRUPT:RefreshInventory', PlayerSource)
            TriggerClientEvent("CORRUPT:setHealthClient", PlayerSource, playernormaltable[PlayerSource].health)
            CORRUPT.setArmour(PlayerSource, playernormaltable[PlayerSource].armour)
            CORRUPT.setBucket(PlayerSource, 0)
            currentEvent.players[PlayerSource] = nil
            playernormaltable[PlayerSource] = nil
        end
    end
end)


local function BattlegWeapons(crateID)
    local numWeapons = math.random(1, 2)
    LootBoxData[crateID].weapon = {}
    for i = 1, numWeapons do
        local weapon = weapons[math.random(1, #weapons)]
        if weapon[2] then
            LootBoxData[crateID].weapon[weapon[2]] = {amount = 250}
        end
        if weapon[1] then
            LootBoxData[crateID].weapon[weapon[1]] = { amount = 1 }
        end
    end
end


RegisterServerEvent("CORRUPT:startBattleGrounds", function()
    local location = battleroyale.locations[currentEvent.data.info.locationIndex]
    plateId, boxId = 0, 0
    ArmourPlateData, LootBoxData = {}, {}
    for i, location in pairs(location.armourLocations) do
        plateId = plateId + 1
        ArmourPlateData[plateId] = {coords = location, plateId = plateId}
    end
    for i, location in pairs(location.lootLocations) do
        boxId = boxId + 1
        LootBoxData[boxId] = {coords = location, box = boxId}
        BattlegWeapons(boxId)
    end
    battleroyale.lootBoxes, battleroyale.armourPlates = LootBoxData, ArmourPlateData
    local lootboxid = {}
    for k, v in pairs(LootBoxData) do
        table.insert(lootboxid, v.box)
    end

    local indexname = battleroyale.locations[currentEvent.data.info.locationIndex].name
    for k, v in pairs(currentEvent.players) do
        TriggerClientEvent("CORRUPT:syncLootboxesTable", k, lootboxid, indexname)
    end
end)

RegisterServerEvent("CORRUPT:removeArmourPlate", function(platid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if platid and currentEvent.players[source] then
        CORRUPT.setArmour(source, 100, true)
        TriggerClientEvent("CORRUPT:removeArmourPlateCl", -1, platid)
    end
end)

RegisterServerEvent("CORRUPT:openCrateBattle", function(source, crateID)
    if source and crateID and currentEvent.players[source] and LootBoxData[crateID] then
        local weapon = LootBoxData[crateID].weapon
        for i , v in pairs(weapon) do
            CORRUPT.notify(source, {"~g~You have received a Weapon!"})
            CORRUPTclient.GiveWeaponsToPlayer(source, {{[i] = {ammo = 250}}, false})
            LootBoxData[crateID].weapon[i] = nil
        end
        TriggerClientEvent("CORRUPT:removeLootBox", -1, crateID)
    end
end)

RegisterServerEvent("CORRUPT:eventPlayerDeath", function(killtype, weaponhash, distance, killer)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if distance ~= nil then
        distance = math.floor(distance)
    end
    RemoveAllPedWeapons(GetPlayerPed(source), true)
    if killer ~= nil then
        TriggerClientEvent('CORRUPT:newKillFeed', -1, CORRUPT.getPlayerName(killer), CORRUPT.getPlayerName(source), getWeaponName(weaponhash), false, distance, "none", "none")
    end
    if killer ~= nil then
        TriggerClientEvent("CORRUPT:addBRKill", -1, killer, CORRUPT.getPlayerName(killer))
    end
    TriggerClientEvent('CORRUPT:deathSound', -1, GetEntityCoords(GetPlayerPed(source)))
    TriggerClientEvent("CORRUPT:removePlayerFromBR", -1, source)
    TriggerClientEvent("CORRUPT:updatePlayerActive", -1, source, false)
    currentEvent.players[source].active = false
    eventtableplayers = currentEvent.players
    eventtableplayers[source] = nil
    TriggerClientEvent("CORRUPT:syncPlayers", -1, eventtableplayers, currentEvent.eventId)
    Citizen.Wait(3000)
    local activePlayers = 0
    local winner = nil
    for k, v in pairs(currentEvent.players) do
        if v.active then
            activePlayers = activePlayers + 1
            if activePlayers == 1 then
                winner = k
            end
        end
    end
    if activePlayers == 1 then
        for k, v in pairs(currentEvent.players) do
            if k == winner then
                CORRUPT.giveBankMoney(CORRUPT.getUserId(winner), 500000)
                TriggerClientEvent("CORRUPT:winBattleRoyale", winner)
            end
        end
        -- Cancel event
        for k, v in pairs(playernormaltable) do
            TriggerClientEvent("CORRUPT:setHealthClient", k, v.health)
            CORRUPT.setArmour(k, v.armour)
            RemoveAllPedWeapons(GetPlayerPed(k), true)
            local cdata = CORRUPT.getUserDataTable(CORRUPT.getUserId(k))
            cdata.inventory = v.inv
            cdata.weapons = v.invweapons
            Citizen.Wait(500)
            TriggerEvent('CORRUPT:RefreshInventory', k)
            TriggerClientEvent("CORRUPT:tpcoordsevent", k, v.coords.x, v.coords.y, v.coords.z)
            CORRUPTclient.GiveWeaponsToPlayer(k, {v.weapons, true})
            CORRUPT.setBucket(k, 0)
        end
        playernormaltable = {}
        TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
        TriggerClientEvent("CORRUPT:eventCleanup", -1, false, currentEvent.eventName)
        currentEvent.isActive = false
        currentEvent.eventId = 0
        currentEvent.eventName = ""
        currentEvent.data = {}
        currentEvent.players = {}
        eventtableplayers = {}
    else
        TriggerClientEvent("CORRUPT:enterSpectator", source)
    end
end)

RegisterServerEvent("CORRUPT:requestActiveEventPlayerPositions", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if currentEvent.players[source] then
        local playertable = {}
        for k, v in pairs(currentEvent.players) do
            playertable[k] = {name = v.name, coords = GetEntityCoords(GetPlayerPed(k))}
        end
        TriggerClientEvent("CORRUPT:gotPlayerPositions", source, playertable)
    end
end)

-- cleartables for the event
RegisterCommand("cleareventtables", function(source)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        currentEvent.isActive = false
        currentEvent.eventId = 0
        currentEvent.eventName = ""
        currentEvent.data = {}
        currentEvent.players = {}
        eventtableplayers = {}
        playernormaltable = {}
        TriggerClientEvent("CORRUPT:syncPlayers", -1, currentEvent.players, currentEvent.eventId)
        TriggerClientEvent("CORRUPT:eventCleanup", -1, false, currentEvent.eventName)
    end
end)