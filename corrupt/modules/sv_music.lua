local current = {}
local currentvehicle = {}

RegisterCommand("djmenu", function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "DJ") then
        TriggerClientEvent('CORRUPT:toggleDjMenu', source)
    end
end)

RegisterCommand("djadmin", function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.noclip") then
        TriggerClientEvent('CORRUPT:toggleDjAdminMenu', source, current)
    end
end)

RegisterCommand("play", function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = CORRUPT.getPlayerName(source)
    
    if string.find(args[1], "https://www.youtube.com/watch?v=") then
        args[1] = string.gsub(args[1], "https://www.youtube.com/watch?v=", "")
    end

    if CORRUPT.hasGroup(user_id, "DJ") then
        if args[1] then
            TriggerClientEvent('CORRUPT:finaliseSong', source, args[1])
        else
            CORRUPT.notify(source, {"~r~No Video Id Was Entered!"})
        end
    else
        CORRUPT.notify(source, {"~r~You do not have permission to do this!"})
    end
end)

RegisterServerEvent("CORRUPT:promptPlaySong")
AddEventHandler("CORRUPT:promptPlaySong", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)
    local name = CORRUPT.getPlayerName(source)
    
    CORRUPT.prompt(source, "Youtube Video ID:", "", function(player, song)
        if CORRUPT.hasGroup(user_id, "DJ") then
            if song then
                TriggerClientEvent('CORRUPT:finaliseSong', source, song)
            else
                CORRUPT.notify(source, {"~r~No Video Id Was Entered!"})
            end
        else
            CORRUPT.notify(source, {"~r~You do not have permission to do this!"})
        end
    end)
end)

RegisterServerEvent("CORRUPT:djDeleteObject")
AddEventHandler("CORRUPT:djDeleteObject", function(entity)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "DJ") then
        TriggerClientEvent('CORRUPT:djDeleteObject', -1, entity)
    end
end)

RegisterServerEvent("CORRUPT:adminStopSong")
AddEventHandler("CORRUPT:adminStopSong", function(PARAM)
    local source = source
    for k,v in pairs(current) do
        if v[1] == PARAM then
            TriggerClientEvent('CORRUPT:stopSong', -1, v[2])
            current[k] = nil
            TriggerClientEvent('CORRUPT:toggleDjAdminMenu', source, current)
        end
    end
end)

RegisterServerEvent("CORRUPT:playDjSongServer")
AddEventHandler("CORRUPT:playDjSongServer", function(song, coords, invehicle, vehiclenetid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if invehicle then
        currentvehicle[vehiclenetid] = {song = song, coords = coords, user_id = user_id, name = name, invehicle = invehicle, startTime = GetGameTimer(), volume = 1.0}
        local entity = NetworkGetEntityFromNetworkId(vehiclenetid)
        Entity(entity).state:set('subwoofer', true)
        Entity(entity).state.subwoofer = currentvehicle[vehiclenetid]
    else
        current[source] = {song, coords, user_id, name, "true"}
        TriggerClientEvent('CORRUPT:playDjSong', -1, song, coords, user_id, name)
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        for k,v in pairs(currentvehicle) do
            local entity = NetworkGetEntityFromNetworkId(k)
            if entity then
                local entity = NetworkGetEntityFromNetworkId(k)
                local table = {id = v.song, name = v.name, volume = v.volume}
                Entity(entity).state.subwoofer = table
            end
        end
    end
end)

RegisterServerEvent("CORRUPT:requestVehicleStartTime")
AddEventHandler("CORRUPT:requestVehicleStartTime", function(veh)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    TriggerClientEvent('CORRUPT:setVehicleStartTime', -1, currentvehicle[veh].startTime, veh, currentvehicle[veh].id)
end)

RegisterServerEvent("CORRUPT:skipServer")
AddEventHandler("CORRUPT:skipServer", function(coords,param)
    local source = source
    TriggerClientEvent('CORRUPT:skipDj', -1,coords,param)
end)

RegisterServerEvent("CORRUPT:stopSongServer")
AddEventHandler("CORRUPT:stopSongServer", function(coords, isvehicle, vehiclenetid)
    local source = source
    current[source] = nil
    if isvehicle then
        currentvehicle[vehiclenetid] = nil
        Entity(NetworkGetEntityFromNetworkId(vehiclenetid)).state.subwoofer = nil
    end
    TriggerClientEvent('CORRUPT:stopSong', -1, coords)
end)

RegisterServerEvent("CORRUPT:adminStopVehicleSong")
AddEventHandler("CORRUPT:adminStopVehicleSong", function(vehiclenetid)
    local source = source
    currentvehicle[vehiclenetid] = nil
    Entity(NetworkGetEntityFromNetworkId(vehiclenetid)).state.subwoofer = nil
    TriggerClientEvent('CORRUPT:stopVehicleSong', -1, vehiclenetid)
end)

RegisterServerEvent("CORRUPT:updateVolumeServer")
AddEventHandler("CORRUPT:updateVolumeServer", function(coords, volume, isvehicle, vehiclenetid)
    local source = source
    if isvehicle then
        currentvehicle[vehiclenetid].volume = volume
    else
        TriggerClientEvent('CORRUPT:updateDjVolume', -1,coords, volume)
    end
end)
