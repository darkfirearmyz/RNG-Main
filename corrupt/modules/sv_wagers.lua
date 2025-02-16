local cfg = module("cfg/cfg_wagers").settings
local weapons = module("corrupt-assets", "cfg/weapons").weapons
local wagerTeam = {}
local wagerCurrentlyIn = {}

local function getOwnerDetails(id)
    if wagerTeam[id] then
        return wagerTeam[id]
    end
    return false
end

RegisterServerEvent("CORRUPT:createWager", function(bestOf, wagerWeapon, wagerWeaponCategory, betAmount, armourValues,teamALoc,teamBLoc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(wagerTeam) do
        if v.teamA.players[user_id] then
            v.teamA.players[user_id] = nil
        elseif v.teamB.players[user_id] then
            v.teamB.players[user_id] = nil
        end
        if v.owner_id == user_id then
            wagerTeam[user_id] = nil
        end
    end
    wagerTeam[user_id] = {
        teamA = {
            players = {
                [user_id] = {source = source, user_id = user_id, name = CORRUPT.getPlayerName(source)}
            }, 
            wins = 0
        }, 
        teamB = {
            players = {}, 
            wins = 0
        }, 
        name = CORRUPT.getPlayerName(source), 
        source = source, 
        user_id = user_id, 
        currentRound = 0, 
        owner = true, 
        owner_id = user_id,
        bestOf = bestOf, 
        armourValues = armourValues, 
        wagerWeapon = wagerWeapon, 
        wagerWeaponCategory = wagerWeaponCategory, 
        betAmount = betAmount, 
        teamALoc = teamALoc, 
        teamBLoc = teamBLoc,
        inProgress = false
    }
    TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
end)

RegisterServerEvent("CORRUPT:joinWager", function(wager_owner, team)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ownerDetails = getOwnerDetails(wager_owner)
    if ownerDetails then
        if ownerDetails.inProgress then
            CORRUPT.notify(source, "~r~You cannot join a Wager that is in progress!")
            return
        end
        for k,v in pairs(wagerTeam) do
            if v.teamA.players[user_id] then
                v.teamA.players[user_id] = nil
            elseif v.teamB.players[user_id] then
                v.teamB.players[user_id] = nil
            end
            if v.owner_id == user_id then
                wagerTeam[user_id] = nil
            end
        end
        local isOwner = user_id == wager_owner
        local otherTeam = team == "teamA" and "teamB" or "teamA"
        if ownerDetails[otherTeam].players[user_id] then
            ownerDetails[otherTeam].players[user_id] = nil
        end
        wagerTeam[wager_owner][team].players[user_id] = {
            source = source,
            user_id = user_id,
            name = CORRUPT.getPlayerName(source),
            owner = isOwner
        }
        TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
    else
        CORRUPT.notify(source, "~r~No owner found for the Wager!")
    end
end)

RegisterServerEvent("CORRUPT:leaveTeam", function(wager_owner, team)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ownerDetails = getOwnerDetails(wager_owner)
    if ownerDetails and ownerDetails[team] and ownerDetails[team].players[user_id] then
        wagerTeam[wager_owner][team].players[user_id] = nil
        if ownerDetails.owner_id == user_id then
            wagerTeam[user_id] = nil
        end
        TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
    else
        CORRUPT.notify(source, "~r~A Wager is already in progress or you are not in a Wager!")
    end
end)

RegisterServerEvent("CORRUPT:cancelWager", function(wager_owner)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ownerDetails = getOwnerDetails(wager_owner)
    if ownerDetails and ownerDetails.owner_id == user_id then
        wagerTeam[user_id] = nil
        TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
    end
end)

RegisterServerEvent("CORRUPT:startWager", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ownerDetails = getOwnerDetails(user_id)
    if wagerTeam[user_id] then
        wagerTeam[user_id].inProgress = true
        local allPlayersInRadius = true
        local allPlayersCanAfford = true
        local playerTables = {
            ownerDetails.teamA.players,
            ownerDetails.teamB.players
        }
        for a,b in pairs(playerTables) do
            for _, playerDetails in pairs(b) do
                if #(GetEntityCoords(GetPlayerPed(playerDetails.source)) - cfg.wagerStartLoc) > 10.0 then
                    allPlayersInRadius = false
                end
                if CORRUPT.getAllMoney(CORRUPT.getUserId(playerDetails.source)) < tonumber(ownerDetails.betAmount) then
                    allPlayersCanAfford = false
                end
            end
        end
        if not allPlayersInRadius then
            CORRUPT.notify(source, "~r~Not all players are close enough to start the Wager!")
            wagerTeam[user_id].inProgress = false
            return
        end
        if not allPlayersCanAfford then
            CORRUPT.notify(source, "~r~Not all players are can afford to start the Wager!")
            wagerTeam[user_id].inProgress = false
            return
        end
        local function preparePlayerForWager(playerDetails, location)
            CORRUPT.tryFullPayment(playerDetails.user_id, tonumber(ownerDetails.betAmount))
            CORRUPT.setBucket(playerDetails.source, 5555+ownerDetails.owner_id)
            CORRUPTclient.getWeapons(playerDetails.source,{true})
            CORRUPTclient.teleport(playerDetails.source, {location.x, location.y, location.z})
            Citizen.Wait(50)
            FreezeEntityPosition(GetPlayerPed(playerDetails.source), true)
            CORRUPTclient.playAnim(playerDetails.source, {true, {{'mini@triathlon', 'idle_d', 1}}, false})
            CORRUPTclient.GiveWeaponsToPlayer(playerDetails.source, {{[ownerDetails.wagerWeapon] = {ammo = 250}}, true})
            SetCurrentPedWeapon(GetPlayerPed(playerDetails.source), GetHashKey(ownerDetails.wagerWeapon), true)
            local armourValue = ownerDetails.armourValues and (ownerDetails.armourValues):gsub("%%", "") or 0
            CORRUPT.setArmour(playerDetails.source, tonumber(armourValue), true)
            TriggerClientEvent("CORRUPT:countdownTimer", playerDetails.source, 3)
            SetTimeout(4000, function()  
                wagerCurrentlyIn[playerDetails.source] = ownerDetails.owner_id
                local inTeam = ownerDetails.teamA.players[playerDetails.user_id] and "teamA" or "teamB"     
                TriggerClientEvent('CORRUPT:startWager', playerDetails.source, inTeam)
                TriggerClientEvent('CORRUPT:smallAnnouncement', playerDetails.source, "~r~Round " .. ownerDetails.currentRound + 1 .. "/" .. ownerDetails.bestOf, "", 2, 3000) 
            end)
        end
        for _, playerDetails in pairs(ownerDetails.teamA.players) do
            preparePlayerForWager(playerDetails, ownerDetails.teamALoc)
        end
        for _, playerDetails in pairs(ownerDetails.teamB.players) do
            preparePlayerForWager(playerDetails, ownerDetails.teamBLoc)
        end
        TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
    else
        CORRUPT.notify(source, "~r~Only the leader can start the Wager!")
    end
end)

function CORRUPT.inWager(source)
    local user_id = CORRUPT.getUserId(source)
    for _, details in pairs(wagerTeam) do
        if details.teamA.players[user_id] or details.teamB.players[user_id] then
            return true
        end
    end
    return false
end

local function EndEvent(owner_id, win, cancelled)
    local user_id = CORRUPT.getUserId(owner_id)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[owner_id])
    CORRUPT.setBucket(owner_id, 0)
    CORRUPTclient.getWeapons(owner_id,{true})
    if cancelled then
        CORRUPT.notify(owner_id, {"~r~Wager has been cancelled as the leader has left!"})
    else
        TriggerClientEvent('CORRUPT:smallAnnouncement', owner_id, win and "WAGER WON " or "WAGER LOST ", "", win and 33 or 6, 5000)
    end
    CORRUPTclient.teleport(owner_id, {cfg.wagerStartLoc.x,cfg.wagerStartLoc.y,cfg.wagerStartLoc.z})
    TriggerClientEvent("Corrupt:Revive", owner_id)
    CORRUPTclient.setPlayerCombatTimer(owner_id, {0, false})
    CORRUPT.setArmour(owner_id, 0, false)
    Wait(50)
    CORRUPTclient.GiveWeaponsToPlayer(owner_id, {CORRUPT.user_tables[user_id].weapons,true})
    TriggerClientEvent("CORRUPT:endWager", owner_id)
    Wait(1000)
    wagerCurrentlyIn[owner_id] = nil
    TriggerClientEvent("CORRUPT:sendWagerData", owner_id, wagerTeam, true)
end

local function preparePlayerForDuel(playerDetails, teleportLocation, wagerOwner)
    local ownerDetails = getOwnerDetails(wagerOwner)
    if ownerDetails then
        TriggerClientEvent("Corrupt:Revive", playerDetails.source)
        CORRUPTclient.teleport(playerDetails.source, teleportLocation)
        FreezeEntityPosition(GetPlayerPed(playerDetails.source), true)
        CORRUPTclient.GiveWeaponsToPlayer(playerDetails.source, {{[ownerDetails.wagerWeapon] = {ammo = 250}}, true})
        SetCurrentPedWeapon(GetPlayerPed(playerDetails.source), GetHashKey(ownerDetails.wagerWeapon), true)
        CORRUPTclient.playAnim(playerDetails.source, {true, {{"mini@triathlon", "idle_d", 1}}, true})
        local armourValue = ownerDetails.armourValues and (ownerDetails.armourValues):gsub("%%", "") or 0
        CORRUPT.setArmour(playerDetails.source, tonumber(armourValue), true)
        TriggerClientEvent("CORRUPT:countdownTimer", playerDetails.source, 3)
        SetTimeout(4000, function()      
            TriggerClientEvent('CORRUPT:startWager', playerDetails.source)
            TriggerClientEvent('CORRUPT:smallAnnouncement', playerDetails.source, "~r~Round " .. ownerDetails.currentRound + 1 .. "/" .. ownerDetails.bestOf, "", 2, 3000) 
        end)
    end
end

local function isTeamDead(players)
    for _, playerDetails in pairs(players) do
        if GetEntityHealth(GetPlayerPed(playerDetails.source)) > 102 then
            return false
        end
    end
    return true
end

local function getPlayerNames(players)
    local names = ""
    for _, playerDetails in pairs(players) do
        names = names.." "..playerDetails.name
    end
    return names
end

function CORRUPT.handleWagerDeath(civsource, killersource)
    local killerID = CORRUPT.getUserId(killersource)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[civsource])
    local teamADead, teamBDead = false, false
    teamADead = isTeamDead(ownerDetails.teamA.players)
    teamBDead = isTeamDead(ownerDetails.teamB.players)
    if teamBDead or teamADead then
        if teamADead then
            ownerDetails.teamB.wins = ownerDetails.teamB.wins + 1
        elseif teamBDead then
            ownerDetails.teamA.wins = ownerDetails.teamA.wins + 1
        end
        ownerDetails.currentRound = ownerDetails.currentRound + 1
        if ownerDetails then
            if ownerDetails.teamA.wins > ownerDetails.bestOf/2 or ownerDetails.teamB.wins > ownerDetails.bestOf/2 or tonumber(ownerDetails.currentRound) >= tonumber(ownerDetails.bestOf) then
                local winningTeam = ownerDetails.teamA.wins > ownerDetails.teamB.wins and ownerDetails.teamA.players or ownerDetails.teamB.players
                local losingTeam = ownerDetails.teamA.wins > ownerDetails.teamB.wins and ownerDetails.teamB.players or ownerDetails.teamA.players
                for _, playerDetails in pairs(winningTeam) do
                    EndEvent(playerDetails.source, true)
                    CORRUPT.notify(playerDetails.source, "~g~Recevied £" .. getMoneyStringFormatted(ownerDetails.betAmount) .. " from the Wager!")
                    CORRUPT.giveBankMoney(playerDetails.user_id, tonumber(ownerDetails.betAmount*2))
                end
                for _, playerDetails in pairs(losingTeam) do
                    EndEvent(playerDetails.source, false)
                end
                Wait(1500)
                wagerTeam[ownerDetails.owner_id] = nil
                if ownerDetails.betAmount >= 1000000 then
                    TriggerClientEvent('chatMessage', -1, "^7CORRUPT Arena | " .. getPlayerNames(winningTeam) .. " has WON £" .. getMoneyStringFormatted(ownerDetails.betAmount) .. " from a wager!", "alert")
                end
            else
                for _, playerDetails in pairs(ownerDetails.teamA.players) do
                    preparePlayerForDuel(playerDetails, {ownerDetails.teamALoc.x,ownerDetails.teamALoc.y,ownerDetails.teamALoc.z}, ownerDetails.owner_id)
                end
                for _, playerDetails in pairs(ownerDetails.teamB.players) do
                    preparePlayerForDuel(playerDetails, {ownerDetails.teamBLoc.x,ownerDetails.teamBLoc.y,ownerDetails.teamBLoc.z}, ownerDetails.owner_id)
                end
            end
        end
    end
    TriggerClientEvent("CORRUPT:sendWagerData", -1, wagerTeam)
end
 
RegisterServerEvent("CORRUPT:getWagerData", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if wagerTeam then
        TriggerClientEvent("CORRUPT:sendWagerData", source, wagerTeam)
    end
end)

AddEventHandler("CORRUPT:playerLeave",function(user_id,source)
    local ownerDetails = getOwnerDetails(wagerCurrentlyIn[source])
    if ownerDetails then
        if ownerDetails.teamA.players[user_id] then
            ownerDetails.teamA.players[user_id] = nil
        elseif ownerDetails.teamB.players[user_id] then
            ownerDetails.teamB.players[user_id] = nil
        end
    end
    if wagerTeam[user_id] then 
        local function cancelPlayerWager(players)
            for _, playerDetails in pairs(players) do
                EndEvent(playerDetails.source, false, "", true)
            end
        end
        if wagerTeam[user_id] then
            cancelPlayerWager(wagerTeam[user_id].teamA.players)
            cancelPlayerWager(wagerTeam[user_id].teamB.players)
        end
        wagerTeam[user_id] = nil
    end
end)