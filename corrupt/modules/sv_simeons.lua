local cfg = module("cfg/cfg_simeons")
local inventory=module("corrupt-assets", "cfg/cfg_inventory")
local startercars = {}
RegisterNetEvent("CORRUPT:refreshSimeonsPermissions")
AddEventHandler("CORRUPT:refreshSimeonsPermissions",function()
    local source=source
    local simeonsCategories={}
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(cfg.simeonsCategories) do
        for a,b in pairs(v) do
            if a == "_config" then
                if b.permissionTable[1] ~= nil then
                    if CORRUPT.hasPermission(CORRUPT.getUserId(source),b.permissionTable[1])then
                        for c,d in pairs(v) do
                            if inventory.vehicle_chest_weights[c] then
                                table.insert(v[c],inventory.vehicle_chest_weights[c])
                            else
                                table.insert(v[c],30)
                            end
                        end
                        simeonsCategories[k] = v
                    end
                else
                    for c,d in pairs(v) do
                        if inventory.vehicle_chest_weights[c] then
                            table.insert(v[c],inventory.vehicle_chest_weights[c])
                        else
                            table.insert(v[c],30)
                        end
                    end
                    simeonsCategories[k] = v
                end
            end
        end
    end
    TriggerClientEvent("CORRUPT:gotCarDealerInstances",source,cfg.simeonsInstances)
    TriggerClientEvent("CORRUPT:gotCarDealerCategories",source,simeonsCategories)
end)

RegisterNetEvent('CORRUPT:purchaseCarDealerVehicle')
AddEventHandler('CORRUPT:purchaseCarDealerVehicle', function(vehicleclass, vehicle)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local playerName = CORRUPT.getPlayerName(source)   

    local alreadyOwnsStarterVehicle = false

    for k, v in pairs(cfg.simeonsCategories[vehicleclass]) do
        if k == vehicle then
            local vehicle_name = v[1]
            local vehicle_price = v[2]

            if vehicle == "tundranw" or vehicle == "4x4range" or vehicle == "4x4bmwx6" then 
                MySQL.query("CORRUPT/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
                    for i, pvehicle in ipairs(pvehicles) do
                        if pvehicle.vehicle == "tundranw" or pvehicle.vehicle == "4x4range" or pvehicle.vehicle == "4x4bmwx6" then
                            alreadyOwnsStarterVehicle = true
                            break
                        end
                    end
                end)

                if alreadyOwnsStarterVehicle then
                    CORRUPT.notify(source, {"~r~You already own a starter vehicle."})
                    return
                end
            end

            MySQL.query("CORRUPT/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pvehicle, affected)
                if #pvehicle > 0 then
                    CORRUPT.notify(source, {"Vehicle already owned."})
                else
                    if CORRUPT.tryFullPayment(user_id, vehicle_price) then
                        local uuid = string.upper(generateUUID("plate", 5, "alphanumeric"))
                        MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = vehicle, registration = 'P'..uuid})
                        CORRUPT.notify(source, {"~g~You paid £"..vehicle_price.." for "..vehicle_name.."."})
                        TriggerClientEvent("CORRUPT:PlaySound", source, "playMoney")
                    else
                        CORRUPT.notify(source, {"Not enough money."})
                        TriggerClientEvent("CORRUPT:PlaySound", source, 2)
                    end
                end
            end)
        end
    end
end)
