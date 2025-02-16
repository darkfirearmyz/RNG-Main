RegisterNetEvent("CORRUPT:saveFaceData")
AddEventHandler("CORRUPT:saveFaceData", function(faceSaveData)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if faceSaveData == 0 or faceSaveData == nil then
        return
    end
    CORRUPT.setUData(user_id,"CORRUPT:Face:Data",json.encode(faceSaveData))
end)

RegisterNetEvent("CORRUPT:saveClothingHairData") -- this updates hair from clothing stores
AddEventHandler("CORRUPT:saveClothingHairData", function(hairtype, haircolour)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local facesavedata = {}
    CORRUPT.getUData(user_id, "CORRUPT:Face:Data", function(data)
        if data ~= nil and data ~= 0 and hairtype ~= nil and haircolour ~= nil then
            facesavedata = json.decode(data)
            if facesavedata == nil then
                facesavedata = {}
            end
            facesavedata["hair"] = hairtype
            facesavedata["haircolor"] = haircolour
            CORRUPT.setUData(user_id,"CORRUPT:Face:Data",json.encode(facesavedata))
        end
    end)
end)

RegisterNetEvent("CORRUPT:getPlayerHairstyle")
AddEventHandler("CORRUPT:getPlayerHairstyle", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.getUData(user_id,"CORRUPT:Face:Data", function(data)
        if data ~= nil and data ~= 0 then
            TriggerClientEvent("CORRUPT:setHairstyle", source, json.decode(data))
        end
    end)
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    SetTimeout(1000, function() 
        local source = source
        local user_id = CORRUPT.getUserId(source)
        CORRUPT.getUData(user_id,"CORRUPT:Face:Data", function(data)
            if data ~= nil and data ~= 0 then
                TriggerClientEvent("CORRUPT:setHairstyle", source, json.decode(data))
            end
        end)
    end)
end)