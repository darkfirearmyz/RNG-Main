RegisterNetEvent("CORRUPTELS:changeStage", function(stage)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('CORRUPTELS:changeStage', -1, vehicleNetId, stage)
end)

RegisterNetEvent("CORRUPTELS:toggleSiren", function(tone)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('CORRUPTELS:toggleSiren', -1, vehicleNetId, tone)
end)

RegisterNetEvent("CORRUPTELS:toggleBullhorn", function(enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('CORRUPTELS:toggleBullhorn', -1, vehicleNetId, enabled)
end)

RegisterNetEvent("CORRUPTELS:patternChange", function(patternIndex, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('CORRUPTELS:patternChange', -1, vehicleNetId, patternIndex, enabled)
end)

RegisterNetEvent("CORRUPTELS:vehicleRemoved", function(stage)
	TriggerClientEvent('CORRUPTELS:vehicleRemoved', -1, stage)
end)

RegisterNetEvent("CORRUPTELS:indicatorChange", function(indicator, enabled)
    local source = source
    local vehicleNetId = NetworkGetNetworkIdFromEntity(GetVehiclePedIsIn(GetPlayerPed(source)))
	TriggerClientEvent('CORRUPTELS:indicatorChange', -1, vehicleNetId, indicator, enabled)
end)