local cfg = module("cfg/cfg_lscustoms")
local LockedGarages = {}
for i = 1, 14 do
    LockedGarages[i] = {locked = false, player = nil}
end
local UserCooldowns = {}
MySQL.createCommand("CORRUPT/get_vehicle_modifications", "SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode")
MySQL.createCommand("CORRUPT/get_vehicle_modifications_by_savekey", "SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND savekey = @savekey AND spawncode = @spawncode")
MySQL.createCommand("CORRUPT/add_vehicle_modifications", "INSERT IGNORE INTO corrupt_user_vehicle_modifications (user_id, spawncode, savekey, `mod`, current) VALUES (@user_id, @spawncode, @savekey, @mod, @current)")
MySQL.createCommand("CORRUPT/set_vehicle_modifications", "UPDATE corrupt_user_vehicle_modifications SET current = @current WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey")
RegisterServerEvent("CORRUPT:setBiometricUsersState")
AddEventHandler("CORRUPT:setBiometricUsersState", function(networkid, tbl)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local entity = NetworkGetEntityFromNetworkId(networkid)
    if not entity then return end
    local newtable = {}
    for i,v in pairs(tbl) do
        if v == true then
            table.insert(newtable, tonumber(i))
        end
    end
    Entity(entity).state.biometricUsers = newtable
end)

RegisterServerEvent("CORRUPT:updateNitro")
AddEventHandler("CORRUPT:updateNitro", function(uuid, value)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = "nitro"}, function(result)
        if result and #result > 0 then
            exports['corrupt']:execute("UPDATE corrupt_user_vehicle_modifications SET `mod` = @mod WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = "nitro", ['@mod'] = value})
        end
    end)
end)
local function inputtoatable(input)
    if not input then
        return false
    end
    local inputtable = {}
    for i in string.gmatch(input, "([^,]+)") do
        i = string.gsub(i, "%s+", "")
        table.insert(inputtable, i)
    end
    if #inputtable == 0 then
        return false
    end
    return inputtable
end
globalUpgrades = {}
function CORRUPT.UpdateAllMods(user_id, source, spawncode)
    exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode", {['@user_id'] = user_id, ['@spawncode'] = spawncode}, function(result)
        local upgrades = {}
        globalUpgrades[spawncode] = globalUpgrades[spawncode] or {}
        globalUpgrades[spawncode][user_id] = globalUpgrades[spawncode][user_id] or {}
        if result and #result > 0 then
            if globalUpgrades[spawncode] and globalUpgrades[spawncode][user_id] and result == globalUpgrades[spawncode][user_id]["ownedUpgrades"] then 
                TriggerClientEvent("CORRUPT:gotBoughtUpgrades", source, globalUpgrades[spawncode][user_id]["All"])
                return
            end
            for _, v in ipairs(result) do
                if v.savekey == "nitro" then
                    upgrades["nitro"] = v.mod
                else
                    upgrades[v.savekey] = upgrades[v.savekey] or {}
                    upgrades[v.savekey][v.mod] = v.current == 1
                end
            end
            
            globalUpgrades[spawncode][user_id]["ownedUpgrades"] = upgrades
        end

        exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle", {['@user_id'] = user_id, ['@vehicle'] = spawncode}, function(vehicleinfo)
            if not vehicleinfo or #vehicleinfo == 0 then 
                return 
            end

            upgrades["vehicle_plate"] = vehicleinfo[1].vehicle_plate

            for notowned, v in pairs(cfg.categoryToIndentifier) do
                if notowned.saveKey and not upgrades[notowned.saveKey] then
                    if notowned.saveKey == "nitro" then
                        upgrades[notowned.saveKey] = 0
                    elseif notowned.saveKey == "biometric_users" then
                        upgrades[notowned.saveKey] = false
                    else
                        upgrades[notowned.saveKey] = {}
                    end
                end
            end
            if not upgrades["plate_colour"] then
                upgrades["plate_colour"] = {}
                upgrades["plate_colour"][1] = true
            end                        
            globalUpgrades[spawncode][user_id]["All"] = upgrades
            TriggerClientEvent("CORRUPT:gotBoughtUpgrades", source, upgrades)
        end)
    end)
end
function CORRUPT.UpdateCertianMods(user_id, source, spawncode, saveKey, mod)
    local function processMods(result)
        if result and #result > 0 then
            local upgrades = {}
            for _, v in ipairs(result) do
                if saveKey ~= "nitro" then
                    upgrades[v.mod] = v.current == 1
                else
                    if UserCooldowns[source] then
                        UserCooldowns[source] = false
                    end
                    TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, saveKey, v.mod)
                    return
                end
            end
            TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, saveKey, upgrades)
            if UserCooldowns[source] then
                UserCooldowns[source] = false
            end
        end
    end
    if not mod then
        exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, saveKey}, function(result)
            processMods(result)
            if not result or #result == 0 then
                exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, saveKey}, processMods)
            end
        end)
    else
        exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ? AND `mod` = ?", {user_id, spawncode, saveKey, mod}, function(modresult)
            if modresult and #modresult > 0 then
                exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, saveKey}, processMods)
            else
                Wait(200)
                exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ? AND `mod` = ?", {user_id, spawncode, saveKey, mod}, function(modresult)
                    exports["corrupt"]:execute("SELECT `mod`, `current` FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, saveKey}, processMods)
                end)
            end
        end)
    end
end
function CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, mod, callback)
    exports["corrupt"]:execute("SELECT `mod`, `current`, `savekey` FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey AND `mod` = @mod", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = mod}, function(result)
        if result and #result > 0 then
            callback(true)
        else
            callback(false)
        end
    end)
end
function CORRUPT.TransferVehicleMods(current_user_id,spawncode,new_user_id)
    exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode", {['@user_id'] = current_user_id, ['@spawncode'] = spawncode}, function(result)
        if result and #result > 0 then
            for i = 1, #result do
                exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET user_id = @new_user_id WHERE user_id = @current_user_id AND spawncode = @spawncode", {['@new_user_id'] = new_user_id, ['@current_user_id'] = current_user_id, ['@spawncode'] = spawncode})
            end
        end
    end)
end
function CORRUPT.SetAllPrimaryColoursFalse(user_id, source, spawncode, callback)
    local modificationTypes = {"chrome", "classic", "matte", "metals", "metallic", "util", "chameleon"}
    for i = 1, #modificationTypes do
        savekey = modificationTypes[i]
        exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
        CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
    end
    callback(true)
end
function CORRUPT.SetAllSecondaryColoursFalse(user_id, source, spawncode, callback)
    local modificationTypes = {"chrome2", "classic2", "matte2", "metals2", "metallic2", "util2", "chameleon2"}
    for i = 1, #modificationTypes do
        savekey = modificationTypes[i]
        exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
        CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
    end
    callback(true)
end
function CORRUPT.SetAllWheelsFalse(user_id, source, spawncode, callback)
    local modificationTypes = {"musclewheels", "lowriderwheels", "suvwheels", "offroadwheels", "tunerwheels", "highendwheels", "sportwheels"}
    for i = 1, #modificationTypes do
        local savekey = modificationTypes[i]
        exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
        CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
    end
    callback(true)
end
RegisterServerEvent("CORRUPT:lscustomsRepairVehicle")
AddEventHandler("CORRUPT:lscustomsRepairVehicle", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.tryFullPayment(user_id, 1000) then
        TriggerClientEvent("CORRUPT:lscustomsRepairVehicle", source)
    else
        CORRUPT.notify(source, {"You don't have enough money to repair your vehicle."})
    end
end)
RegisterServerEvent("CORRUPT:getBoughtUpgrades")
AddEventHandler("CORRUPT:getBoughtUpgrades", function(uuid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if spawncode then
        CORRUPT.UpdateAllMods(user_id, source, spawncode)
    end
end)
AddEventHandler('playerDropped', function()
    for k, v in pairs(LockedGarages) do
        if v.player then
            if source == v.player then
                v.locked = false
                v.player = nil
                TriggerClientEvent("CORRUPT:setCustomsGarageStatus", -1, k, false)
            end
        end
    end
end)
function CORRUPT.SetModCurrent(user_id, spawncode, savekey, mod, current)
    if user_id and spawncode and savekey and mod and current then
        exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = @current WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey AND `mod` = @mod", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = mod, ['@current'] = current})
    end
end
Citizen.CreateThread(function()
    while true do 
        Wait(60000)
        for k, v in pairs(LockedGarages) do
            if v.player then
                if not GetPlayerName(v.player) then
                    v.locked = false
                    v.player = nil
                    TriggerClientEvent("CORRUPT:setCustomsGarageStatus", -1, k, false)
                end
            end
        end
    end
end)
RegisterServerEvent("CORRUPT:setCustomsGarageStatus")
AddEventHandler("CORRUPT:setCustomsGarageStatus", function(garage, status)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if garage then
        LockedGarages[garage].locked = status
        LockedGarages[garage].player = status and source or nil
        TriggerClientEvent("CORRUPT:setCustomsGarageStatus", -1, garage, status)
    end
end)
RegisterServerEvent("CORRUPT:setActiveStaticList")
AddEventHandler("CORRUPT:setActiveStaticList", function(uuid, value, mod)
    if not uuid or not value or not mod then return end;
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    local cfgValue = cfg.identifierToCategory[value]
    if not cfgValue then return end;
    local savekey = cfgValue.saveKey
    local modData = cfgValue.items[mod]
    if not modData then return end;
    local modindex = modData.index or modData.mod or modData.tint or modData.colour or modData.saveValue
    local unapply = inputtoatable(cfgValue.unapply)
    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, modindex, function(owned)
        if owned then
            if unapply then
                if table.find(unapply, "classic") or table.find(unapply, "matte") then
                    CORRUPT.SetAllPrimaryColoursFalse(user_id, source, spawncode, function(done)
                        if done then 
                            CORRUPT.SetModCurrent(user_id, spawncode, savekey, modindex, 1)
                            UserCooldowns[source] = true
                            Wait(100)
                            CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
                        end
                    end)
                elseif table.find(unapply, "classic2") or table.find(unapply, "matte2") then
                    CORRUPT.SetAllSecondaryColoursFalse(user_id, source, spawncode, function(done)
                        if done then 
                            CORRUPT.SetModCurrent(user_id, spawncode, savekey, modindex, 1)
                            UserCooldowns[source] = true
                            Wait(100)
                            CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
                        end
                    end)
                elseif table.find(unapply, "musclewheels") or table.find(unapply, "lowriderwheels") then
                    CORRUPT.SetAllWheelsFalse(user_id, source, spawncode, function(done)
                        if done then 
                            CORRUPT.SetModCurrent(user_id, spawncode, savekey, modindex, 1)
                            UserCooldowns[source] = true
                            Wait(100)
                            CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey)
                        end
                    end)
                end
            else
                exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
                CORRUPT.SetModCurrent(user_id, spawncode, savekey, modindex, 1)
                UserCooldowns[source] = true
                Wait(100)
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                    if result and #result > 0 then
                        local currentupgrades = {}
                        for _, v in pairs(result) do
                            local resultmods = tonumber(v.mod)
                            if modindex == resultmods then
                                currentupgrades[v.mod] = true
                            else
                                currentupgrades[v.mod] = false
                            end
                        end
                        UserCooldowns[source] = false
                        TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                    else
                        UserCooldowns[source] = false
                    end
                end)
            end
        else
            CORRUPT.notify(source, {"~r~You have not purchased this mod"})
        end
    end)
end)
RegisterServerEvent("CORRUPT:purchaseStaticList")
AddEventHandler("CORRUPT:purchaseStaticList", function(uuid, value, mod)
    if not uuid or not value or not mod then return end;
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    local cfgValue = cfg.identifierToCategory[value]
    if not cfgValue then return end;
    local savekey = cfgValue.saveKey
    local modData = cfgValue.items[mod]
    local price = modData.price or cfgValue.price
    local modindex = modData.index or modData.mod or modData.tint or modData.colour or modData.saveValue
    local modname = modData.name or " "
    if not price then return end;
    if not modData then return end;
    if type(modindex) == "table" then 
        modindex = ""..modindex[1]..","..modindex[2]..","..modindex[3]..""
    end    
    local unapply = inputtoatable(cfgValue.unapply)
    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, modindex, function(owned)
        if owned then
            CORRUPT.notify(source, {"~r~You have already applied this mod"})
            return
        else
            if CORRUPT.tryFullPayment(user_id, price) then
                CORRUPT.notify(source, {"~g~You have purchased the ~w~"..modname.."~g~ upgrade for £"..getMoneyStringFormatted(price)})
                if unapply then
                    if table.find(unapply, "classic") or table.find(unapply, "matte") then
                        CORRUPT.SetAllPrimaryColoursFalse(user_id, source, spawncode, function(done)
                            if done then
                                MySQL.asyncQuery("CORRUPT/add_vehicle_modifications",{user_id = user_id, spawncode = spawncode, savekey = savekey, mod = modindex, current = 1})
                                UserCooldowns[source] = true
                                CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey, modindex)
                            end
                        end)
                    elseif table.find(unapply, "classic2") or table.find(unapply, "matte2") then
                        CORRUPT.SetAllSecondaryColoursFalse(user_id, source, spawncode, function(done)
                            if done then 
                                MySQL.asyncQuery("CORRUPT/add_vehicle_modifications",{user_id = user_id, spawncode = spawncode, savekey = savekey, mod = modindex, current = 1})
                                UserCooldowns[source] = true
                                CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey, modindex)
                            end
                        end)
                    elseif table.find(unapply, "musclewheels") or table.find(unapply, "lowriderwheels") then
                        CORRUPT.SetAllWheelsFalse(user_id, source, spawncode, function(done)
                            if done then 
                                MySQL.asyncQuery("CORRUPT/add_vehicle_modifications",{user_id = user_id, spawncode = spawncode, savekey = savekey, mod = modindex, current = 1})
                                UserCooldowns[source] = true
                                CORRUPT.UpdateCertianMods(user_id, source, spawncode, savekey, modindex)
                            end
                        end)
                    end
                else
                    exports['corrupt']:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
                    exports["corrupt"]:execute("INSERT INTO corrupt_user_vehicle_modifications (user_id, spawncode, savekey, `mod`, current) VALUES (@user_id, @spawncode, @savekey, @mod, @current)", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = modindex, ['@current'] = 1})
                    UserCooldowns[source] = true
                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                        if result and #result > 0 then
                            local currentupgrades = {}
                            for i,v in pairs(result) do
                                local resultmods = tonumber(v.mod)
                                if modindex == resultmods then
                                    currentupgrades[v.mod] = true
                                else
                                    currentupgrades[v.mod] = false
                                end
                            end
                            UserCooldowns[source] = false
                            TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                        else
                            UserCooldowns[source] = false
                        end
                    end)
                end
            else
                CORRUPT.notify(source, {"~r~You don't have enough money to purchase this upgrade."})
            end
        end
    end)
end)
RegisterServerEvent("CORRUPT:purchaseStaticValueList", function(uuid, value, mod)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;

    local cfgValue = cfg.identifierToCategory[value]
    if not cfgValue then 
        return 
    end
    local savekey = cfgValue.saveKey
    local modData = cfgValue.items[mod]
    local price = modData.price
    local modname = modData.name or " "
    if not modData then 
        return 
    end
    local modindex = modData.index or modData.mod or modData.tint or modData.colour or modData.saveValue
    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, modindex, function(owned)
        if owned then
            CORRUPT.notify(source, {"~r~You have already applied this mod"})
            return
        else
            if CORRUPT.tryFullPayment(user_id, price) then
                CORRUPT.notify(source, {"~g~You have purchased the ~w~"..modname.."~g~ upgrade for £"..getMoneyStringFormatted(price)})
                exports['corrupt']:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
                exports["corrupt"]:execute("INSERT INTO corrupt_user_vehicle_modifications (user_id, spawncode, savekey, `mod`, current) VALUES (@user_id, @spawncode, @savekey, @mod, @current)", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = modindex, ['@current'] = 1})
                UserCooldowns[source] = true
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                    if result and #result > 0 then
                        local currentupgrades = {}
                        if savekey ~= "nitro" then
                            for i,v in pairs(result) do
                                local resultmods = tonumber(v.mod)
                                if modindex == resultmods then
                                    currentupgrades[v.mod] = true
                                else
                                    currentupgrades[v.mod] = false
                                end
                            end
                            UserCooldowns[source] = false
                            TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                        else
                            UserCooldowns[source] = false
                            TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, result[1].mod)
                        end
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~You don't have enough money to purchase this upgrade."})
            end
        end
    end)
end)
RegisterServerEvent("CORRUPT:setActiveModList", function(uuid,value,mod)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;


    local cfgValue = cfg.identifierToCategory[value]

    if not cfgValue then return end;

    local savekey = cfgValue.saveKey

    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, mod, function(owned)
        if owned then
            CORRUPT.notify(source, {"~g~You have applied the mod."})
            exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey})
            exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 1 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey AND `mod` = @mod", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = mod})
            UserCooldowns[source] = true
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                if result and #result > 0 then
                    local currentupgrades = {}
                    for i,v in pairs(result) do
                        local resultmods = tonumber(v.mod)
                        if mod == resultmods then
                            currentupgrades[v.mod] = true
                        else
                            currentupgrades[v.mod] = false
                        end
                    end
                    UserCooldowns[source] = false
                    TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                else
                    UserCooldowns[source] = false
                end
            end)
        else
            CORRUPT.notify(source, {"~r~You have not purchased this mod"})
        end
    end)
end)
RegisterServerEvent("CORRUPT:purchaseModList", function(uuid,value,mod)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    local cfgValue = cfg.identifierToCategory[value]
    if not cfgValue then 
        return 
    end
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    local savekey = cfgValue.saveKey
    local price = cfgValue.price
    local modname = cfgValue.name or " "
    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, mod, function(owned)
        if owned then
            CORRUPT.notify(source, {"~r~You have already applied this mod"})
            return
        else
            if CORRUPT.tryFullPayment(user_id, price) then
                CORRUPT.notify(source, {"~g~You have purchased the ~w~"..modname.."~g~ upgrade for £"..getMoneyStringFormatted(price)})
                exports["corrupt"]:execute("INSERT INTO corrupt_user_vehicle_modifications (user_id, spawncode, savekey, `mod`, current) VALUES (@user_id, @spawncode, @savekey, @mod, @current)", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = mod, ['@current'] = 1})
                UserCooldowns[source] = true
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                    if result and #result > 0 then
                        local currentupgrades = {}
                        for i,v in pairs(result) do
                            local resultmods = tonumber(v.mod)
                            if mod == resultmods then
                                currentupgrades[v.mod] = true
                            else
                                currentupgrades[v.mod] = false
                            end
                        end
                        UserCooldowns[source] = false
                        TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                    else
                        UserCooldowns[source] = false
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~You don't have enough money to purchase this upgrade."})
            end
        end
    end)
end)
RegisterServerEvent("CORRUPT:setValueInputList", function(uuid, value, old_value, new_value)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    local cfgValue = cfg.identifierToCategory[value]
    if not cfgValue then return end;
    local savekey = cfgValue.saveKey
    CORRUPT.CheckIfOwnedMod(user_id, spawncode, savekey, new_value, function(owned)
        if owned then
            CORRUPT.notify(source, {"~r~Setting this Perm ID to not active will remove it from your biometric lock."})
            exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET current = 0 WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey AND `mod` = @mod", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = new_value})
            return
        else
            CORRUPT.notify(source, {"~g~You updated the Perm ID: "..old_value.." to "..new_value.." in your biometric lock."})
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, savekey}, function(result)
                if result and #result > 0 then
                    for _, v in ipairs(result) do 
                        if v.mod == old_value then
                            exports["corrupt"]:execute("UPDATE corrupt_user_vehicle_modifications SET `mod` = ? WHERE user_id = ? AND spawncode = ? AND savekey = ? AND `mod` = ?", {new_value, user_id, spawncode, savekey, v.mod})
                            UserCooldowns[source] = true
                        end
                    end
                end
            end)
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = ? AND spawncode = ? AND savekey = ?", {user_id, spawncode, savekey}, function(result)
                if result and #result > 0 then
                    local currentupgrades = {}
                    for i,v in pairs(result) do
                        local resultmods = tonumber(v.mod)
                        if new_value == resultmods then
                            currentupgrades[v.mod] = true
                        else
                            currentupgrades[v.mod] = false
                        end
                    end
                    UserCooldowns[source] = false
                    TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                else
                    UserCooldowns[source] = false
                end
            end)
        end
    end)
end)
RegisterServerEvent("CORRUPT:purchaseValueInputList", function(uuid, value)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if not spawncode then return end;
    local cfgValue = cfg.identifierToCategory[value]
    if UserCooldowns[source] then CORRUPT.notify(source, {"~r~You are being rate limited."}) return end;
    if not cfgValue then 
        return 
    end
    local savekey = cfgValue.saveKey
    local price = cfgValue.price 
    if not price then 
        return 
    end
    local modname = cfgValue.name or " "
    if CORRUPT.tryFullPayment(user_id, price) then
        CORRUPT.prompt(source, "Enter Perm ID", "", function(source, permid)
            if permid then
                CORRUPT.notify(source, {"~g~You have purchased the ~w~"..modname.."~g~ upgrade for £"..getMoneyStringFormatted(price)})
                exports["corrupt"]:execute("INSERT INTO corrupt_user_vehicle_modifications (user_id, spawncode, savekey, `mod`, current) VALUES (@user_id, @spawncode, @savekey, @mod, @current)", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey, ['@mod'] = permid, ['@current'] = 1})
                UserCooldowns[source] = true
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = savekey}, function(result)
                    if result and #result > 0 then
                        local currentupgrades = {}
                        for i,v in pairs(result) do
                            local resultmods = tonumber(v.mod)
                            if permid == resultmods then
                                currentupgrades[v.mod] = true
                            else
                                currentupgrades[v.mod] = false
                            end
                        end
                        UserCooldowns[source] = false
                        TriggerClientEvent("CORRUPT:setSpecificOwnedUpgrade", source, savekey, currentupgrades)
                    else
                        UserCooldowns[source] = false
                    end
                end)
            else
                CORRUPT.giveBankMoney(user_id, price)
                CORRUPT.notify(source, {"~r~You have not entered a valid Perm ID"})
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You don't have enough money to purchase this upgrade."})
    end
end)