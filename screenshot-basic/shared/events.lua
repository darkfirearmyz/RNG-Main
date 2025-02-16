local lookup = {
    ["CORRUPTELS:changeStage"] = "CORRUPTELS:1",
    ["CORRUPTELS:toggleSiren"] = "CORRUPTELS:2",
    ["CORRUPTELS:toggleBullhorn"] = "CORRUPTELS:3",
    ["CORRUPTELS:patternChange"] = "CORRUPTELS:4",
    ["CORRUPTELS:vehicleRemoved"] = "CORRUPTELS:5",
    ["CORRUPTELS:indicatorChange"] = "CORRUPTELS:6"
}

local origRegisterNetEvent = RegisterNetEvent
RegisterNetEvent = function(name, callback)
    origRegisterNetEvent(lookup[name], callback)
end

if IsDuplicityVersion() then
    local origTriggerClientEvent = TriggerClientEvent
    TriggerClientEvent = function(name, target, ...)
        origTriggerClientEvent(lookup[name], target, ...)
    end

    TriggerClientScopeEvent = function(name, target, ...)
        exports["rage"]:TriggerClientScopeEvent(lookup[name], target, ...)
    end
else
    local origTriggerServerEvent = TriggerServerEvent
    TriggerServerEvent = function(name, ...)
        origTriggerServerEvent(lookup[name], ...)
    end
end