local a = module("cfg/cfg_scubadiving")
local currentDivers = {}
local scubaLocations = {
    'Heroin Tunnel',
    'Plane Crash',
    'Boat Crash',
}

RegisterNetEvent("CORRUPT:requestScubaJob")
AddEventHandler("CORRUPT:requestScubaJob", function()
    local source=source
    local user_id=CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id,"Scuba Diver")then
        if currentDivers[user_id]==nil then
            currentDivers[user_id]={currentJob=""}
            currentDivers[user_id].currentJob={jobActive = true}
            local randomJob = math.random(1,#scubaLocations)
            for k,v in pairs(a.locations)do
                if v.name==scubaLocations[randomJob] then
                    local jobInfo={
                        name=v.name,
                        position=v.position,
                        dinghySpawnPositions=v.dinghySpawnPositions,
                        dinghySpawnHeading=v.dinghySpawnHeading,
                        blipId=v.blipId,
                        blipColour=v.blipColour,
                        rewardObjects=v.rewardObjects,
                    }
                    TriggerClientEvent("CORRUPT:createScubaJob",source,jobInfo,CORRUPT.getUserId(source))
                end
            end
        end
    else
        CORRUPT.notify(source,{"~r~You are not clocked on as a Scuba Diver."})
    end
end)

RegisterNetEvent("CORRUPT:scubaSetVehicle")
AddEventHandler("CORRUPT:scubaSetVehicle", function(PermID,Vehicle)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if PermID == user_id then
        if currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==true then
            currentDivers[PermID].currentJob.dinghy=Vehicle
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(currentDivers)do
            if v.currentJob.jobActive then
                local userSource = CORRUPT.getUserSource(k)
                if userSource then
                    if v.currentJob.dinghy~=nil then
                        local entity = NetworkGetEntityFromNetworkId(v.currentJob.dinghy)
                        if not DoesEntityExist(entity) then
                            TriggerClientEvent("CORRUPT:ScubaBoatDestroyed", userSource, k)
                        end
                    end
                end
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterNetEvent("CORRUPT:finishScubaJob")
AddEventHandler("CORRUPT:finishScubaJob", function(PermID,CollectedPackages)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CollectedPackages > 6 then
        CollectedPackages = 6
    end
    if PermID == user_id then
        if currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==true then
            currentDivers[PermID].currentJob.jobActive=false
            currentDivers[PermID].currentJob.collectedPackages=CollectedPackages
        end
    end
end)

RegisterNetEvent("CORRUPT:claimScubaReward")
AddEventHandler("CORRUPT:claimScubaReward", function(PermID)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if PermID == user_id then
        if #(GetEntityCoords(GetPlayerPed(source)) - cfg.jobPosition) < 5.0 and currentDivers[PermID]~=nil and currentDivers[PermID].currentJob.jobActive==false then
            local reward = grindBoost*math.random(a.payPerItemMin*currentDivers[PermID].currentJob.collectedPackages,a.payPerItemMax*currentDivers[PermID].currentJob.collectedPackages)
            CORRUPT.giveBankMoney(PermID,reward)
            CORRUPT.notify(source, {"~g~You have been paid £"..getMoneyStringFormatted(reward).." for collecting "..currentDivers[PermID].currentJob.collectedPackages.." treasures."})
            currentDivers[PermID]=nil
        end
    end
end)