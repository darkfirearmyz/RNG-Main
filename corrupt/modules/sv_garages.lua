local lang = CORRUPT.lang
local cfg = module("corrupt-assets", "cfg/cfg_garages")
local cfg_inventory = module("corrupt-assets", "cfg/cfg_inventory")
local lsccfg = module("cfg/cfg_lscustoms")
local vehicle_groups = cfg.garages
local limit = cfg.limit or 100000000
MySQL.createCommand("CORRUPT/add_vehicle","INSERT IGNORE INTO corrupt_user_vehicles(user_id,vehicle,vehicle_plate,locked) VALUES(@user_id,@vehicle,@registration,@locked)")
MySQL.createCommand("CORRUPT/remove_vehicle","DELETE FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/get_vehicles", "SELECT vehicle, rentedtime, vehicle_plate, fuel_level, impounded FROM corrupt_user_vehicles WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/get_rented_vehicles_in", "SELECT vehicle, rentedtime, user_id, rentedid FROM corrupt_user_vehicles WHERE user_id = @user_id AND rented = 1")
MySQL.createCommand("CORRUPT/get_rented_vehicles_out", "SELECT vehicle, rentedtime, user_id, rentedid FROM corrupt_user_vehicles WHERE rentedid = @user_id AND rented = 1")
MySQL.createCommand("CORRUPT/get_vehicle","SELECT vehicle FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/get_vehicle_fuellevel","SELECT fuel_level FROM corrupt_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("CORRUPT/check_rented","SELECT * FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle AND rented = 1")
MySQL.createCommand("CORRUPT/sell_vehicle_player","UPDATE corrupt_user_vehicles SET user_id = @user_id, vehicle_plate = @registration WHERE user_id = @oldUser AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/rentedupdate", "UPDATE corrupt_user_vehicles SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND vehicle = @veh")
MySQL.createCommand("CORRUPT/fetch_rented_vehs", "SELECT * FROM corrupt_user_vehicles WHERE rented = 1")
MySQL.createCommand("CORRUPT/get_vehicle_count","SELECT * FROM corrupt_user_vehicles WHERE vehicle = @vehicle")
MySQL.createCommand("CORRUPT/get_vehicle_lock_state", "SELECT * FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/get_vehicle_miles", "SELECT miles FROM corrupt_user_vehicles WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/add_vehicle_miles", "INSERT INTO corrupt_user_vehicles (miles) VALUES (@miles) WHERE user_id = @user_id AND vehicle = @vehicle")


local ownedVehicles = {}


function CORRUPT.getOwnedVehicles(source)
    return ownedVehicles[source]
end

function CORRUPT.getOwnedVehicleByUUID(source, uuid)
    local vehicles = ownedVehicles[source]
    if vehicles then
        for k,v in pairs(vehicles) do
            if v.uuid == uuid then
                return v.vehicleId
            end
        end
    end
end

function CORRUPT.setOwnedVehicles(source, vehicles)
    ownedVehicles[source] = {}
    for J, O in pairs(vehicles) do
        local W = {uuid = J, vehicleId = O.vehicleId, fuel = O.fuel}
        table.insert(ownedVehicles[source], W)
    end
end

function CORRUPT.getUUIDByVehicleId(source, vehicleId)
    local vehicles = ownedVehicles[source]
    if vehicles then
        for k,v in pairs(vehicles) do
            if v.vehicleId == vehicleId then
                return v.uuid
            end
        end
    end
end


RegisterServerEvent("CORRUPT:spawnPersonalVehicle")
AddEventHandler('CORRUPT:spawnPersonalVehicle', function(uuid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if spawncode then
        MySQL.query("CORRUPT/get_vehicles", {user_id = user_id}, function(result)
            if result ~= nil then 
                for k,v in pairs(result) do
                    if v.vehicle == spawncode then
                        if v.impounded then
                            CORRUPT.notify(source, {'~r~This vehicle is currently impounded.'})
                        else
                            exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode", {['@user_id'] = user_id, ['@spawncode'] = spawncode}, function(ownedUpgrades)
                                local upgrades = {}
                                if ownedUpgrades and #ownedUpgrades > 0 then
                                    for _, owned in ipairs(ownedUpgrades) do
                                        if owned.savekey == "nitro" then
                                            upgrades["nitro"] = tonumber(owned.mod)
                                        else
                                            upgrades[owned.savekey] = upgrades[owned.savekey] or {}
                                            upgrades[owned.savekey][owned.mod] = owned.current == 1
                                        end
                                    end
                                end
                                upgrades["vehicle_plate"] = v.vehicle_plate
                    
                                for notowned, v in pairs(lsccfg.categoryToIndentifier) do
                                    if notowned.saveKey and not upgrades[notowned.saveKey] then
                                        if notowned.saveKey == "nitro" and not upgrades["nitro"] then
                                            upgrades["nitro"] = 0
                                        elseif notowned.saveKey == "biometric_users" and not upgrades["biometric_users"] then
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
                                CORRUPT.PayVehicleTax(user_id, source)
                                TriggerClientEvent('CORRUPT:spawnPersonalVehicle', source, uuid, upgrades, user_id, false, GetEntityCoords(GetPlayerPed(source)))
                            end)
                        end
                    end
                end
            end
        end)
    else
        CORRUPT.notify(source, {"~r~Unable to get the ownership of this vehicle."})
    end
end)

valetCooldown = {}
RegisterServerEvent("CORRUPT:valetSpawnVehicle")
AddEventHandler('CORRUPT:valetSpawnVehicle', function(uuid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local spawncode = CORRUPT.getOwnedVehicleByUUID(source, uuid)
    if CORRUPT.inWager(source) then CORRUPT.notify(source, {"~r~You cannot use this feature whilst in a wager."}) return end
    CORRUPTclient.isPlusClub(source,{},function(plusclub)
        CORRUPTclient.isPlatClub(source,{},function(platclub)
            if plusclub or platclub then
                if valetCooldown[source] and not (os.time() > valetCooldown[source]) then
                    return CORRUPT.notify(source,{"~r~Please wait before using this again."})
                else
                    valetCooldown[source] = nil
                end
                MySQL.query("CORRUPT/get_vehicles", {user_id = user_id}, function(result)
                    if result ~= nil then 
                        for k,v in pairs(result) do
                            if v.vehicle == spawncode then
                                exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode", {['@user_id'] = user_id, ['@spawncode'] = spawncode}, function(ownedUpgrades)
                                    local upgrades = {}
                                    if ownedUpgrades and #ownedUpgrades > 0 then
                                        for _, owned in ipairs(ownedUpgrades) do
                                            if owned.savekey == "nitro" and owned.current == 1 then
                                                upgrades[owned.savekey] = owned.mod
                                            else
                                                upgrades[owned.savekey] = upgrades[owned.savekey] or {}
                                                upgrades[owned.savekey][owned.mod] = owned.current == 1
                                            end
                                        end
                                    end
                                    upgrades["vehicle_plate"] = v.vehicle_plate
                        
                                    for notowned, v in pairs(lsccfg.categoryToIndentifier) do
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
                                    CORRUPT.PayVehicleTax(user_id, source)
                                    TriggerClientEvent('CORRUPT:spawnPersonalVehicle', source, v.vehicle, upgrades, user_id, false, GetEntityCoords(GetPlayerPed(source)))
                                    valetCooldown[source] = os.time() + 60
                                end)
                            end
                        end
                    end
                end)
            else
                CORRUPT.notify(source, {"~y~You need to be a subscriber of Corrupt Plus or Corrupt Platinum to use this feature."})
                CORRUPT.notify(source, {"~y~Available @ corrupt.tebex.io"})
            end
        end)
    end)
end)



RegisterServerEvent("CORRUPT:getVehicleRarity")
AddEventHandler('CORRUPT:getVehicleRarity', function(spawncode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    MySQL.query("CORRUPT/get_vehicle_lock_state", {user_id = user_id, vehicle = spawncode}, function(results)
        if results ~= nil then
            MySQL.query("CORRUPT/get_vehicle_count", {vehicle = spawncode}, function(result)
                if result ~= nil then
                    TriggerClientEvent('CORRUPT:setVehicleRarity', source, spawncode, #result, tobool(results[1].locked))
                end
            end)
        end
    end)
end)


RegisterServerEvent("CORRUPT:setVehicleLock")
AddEventHandler('CORRUPT:setVehicleLock', function(netid, lock)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerClientEvent("CORRUPT:setVehicleLock", -1, netid, lock)
end)

RegisterServerEvent("CORRUPT:displayVehicleBlip")
AddEventHandler('CORRUPT:displayVehicleBlip', function(spawncode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = "security_blips"}, function(rows)
        if rows and #rows > 0 then
            CORRUPTclient.getOwnedVehiclePosition(source, spawncode, function(x,y,z)
                if vector3(x,y,z) ~= vector3(0,0,0) then
                    if rows[1].current == 1 and rows[1].mod == 11 then
                        local position = {}
                        position.x, position.y, position.z = x, y, z
                        if next(position) then
                            TriggerClientEvent('CORRUPT:displayVehicleBlip', source, position)
                            CORRUPT.notify(source, {"~g~Vehicle blip enabled."})
                            return
                        end
                    else
                        CORRUPT.notify(source, {"~r~This vehicle does not have a remote vehicle blip installed, Head to LSC to install one."})
                    end
                else
                    CORRUPT.notify(source, {"~r~Cannot locate this vehicle"})
                end
            end)
        else
            CORRUPT.notify(source, {"~r~This vehicle does not have a remote vehicle blip installed, Head to LSC to install one."})
        end
    end)
end)


RegisterServerEvent("CORRUPT:viewRemoteDashcam")
AddEventHandler('CORRUPT:viewRemoteDashcam', function(spawncode)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicle_modifications WHERE user_id = @user_id AND spawncode = @spawncode AND savekey = @savekey", {['@user_id'] = user_id, ['@spawncode'] = spawncode, ['@savekey'] = "security_dashcam"}, function(rows) 
        if rows and #rows > 0 then
            CORRUPTclient.getOwnedVehiclePosition(source, spawncode, function(x,y,z)
                if vector3(x,y,z) ~= vector3(0,0,0) then
                    if rows[1].current == 1 and rows[1].mod == 1 then
                        local netObjects = GetGamePool('CObject')
                        if next(netObjects) ~= nil then
                            for k,v in pairs(netObjects) do
                                local objCoords = GetEntityCoords(v)
                                if objCoords.x == x and objCoords.y == y and objCoords.z == z then
                                    TriggerClientEvent('CORRUPT:viewRemoteDashcam', source, {x,y,z}, k)
                                    return
                                end
                            end
                        end
                    end
                    CORRUPT.notify(source, {"~r~This vehicle does not have a remote dashcam installed."})
                else
                    CORRUPT.notify(source, {"~r~Cannot locate this vehicle"})
                end
            end)
        else
            CORRUPT.notify(source, {"~r~This vehicle does not have a remote dashcam installed."})
        end
    end)
end)


RegisterServerEvent("CORRUPT:updateFuel")
AddEventHandler('CORRUPT:updateFuel', function(vehicle, fuel_level)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports["corrupt"]:execute("UPDATE corrupt_user_vehicles SET fuel_level = @fuel_level WHERE user_id = @user_id AND vehicle = @vehicle", {fuel_level = fuel_level, user_id = user_id, vehicle = vehicle}, function() end)
end)

RegisterServerEvent("CORRUPT:getCustomFolders")
AddEventHandler('CORRUPT:getCustomFolders', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports["corrupt"]:execute("SELECT * from `corrupt_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            TriggerClientEvent("CORRUPT:sendFolders", source, json.decode(Result[1].folder))
        end
    end)
end)


RegisterServerEvent("CORRUPT:updateFolders")
AddEventHandler('CORRUPT:updateFolders', function(FolderUpdated)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports["corrupt"]:execute("SELECT * from `corrupt_custom_garages` WHERE user_id = @user_id", {user_id = user_id}, function(Result)
        if #Result > 0 then
            exports['corrupt']:execute("UPDATE corrupt_custom_garages SET folder = @folder WHERE user_id = @user_id", {folder = json.encode(FolderUpdated), user_id = user_id}, function() end)
        else
            exports['corrupt']:execute("INSERT INTO corrupt_custom_garages (`user_id`, `folder`) VALUES (@user_id, @folder);", {user_id = user_id, folder = json.encode(FolderUpdated)}, function() end)
        end
    end)
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        MySQL.query('CORRUPT/fetch_rented_vehs', {}, function(pvehicles)
            for i,v in pairs(pvehicles) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('CORRUPT/rentedupdate', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, veh = v.vehicle})
                  CORRUPT.TransferVehicleMods(v.user_id, v.vehicle, v.rentedid)
                  if CORRUPT.getUserSource(v.rentedid) ~= nil then
                    CORRUPT.notify(CORRUPT.getUserSource(v.rentedid), {"~r~Your rented vehicle has been returned."})
                  end
               end
            end
        end)
    end
end)

RegisterNetEvent('CORRUPT:crushVehicle')
AddEventHandler('CORRUPT:crushVehicle', function(vehicle)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id then 
        MySQL.query("CORRUPT/check_rented", {user_id = user_id, vehicle = vehicle}, function(pvehicles)
            MySQL.query("CORRUPT/get_vehicle", {user_id = user_id, vehicle = vehicle}, function(pveh)
                if #pveh < 0 then 
                    CORRUPT.notify(source,{"~r~You cannot destroy a vehicle you do not own"})
                    return
                end
                if #pvehicles > 0 then 
                    CORRUPT.notify(source,{"~r~You cannot destroy a rented vehicle!"})
                    return
                end
                MySQL.execute('CORRUPT/remove_vehicle', {user_id = user_id, vehicle = vehicle})
                CORRUPT.sendWebhook('crush-vehicle', "Corrupt Crush Vehicle Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Vehicle: **"..vehicle.."**")
                TriggerEvent("CORRUPT:refreshGaragePermissions", source)
            end)
        end)
    end
end)
RegisterNetEvent('CORRUPT:beginSellVehicleToPlayer')
AddEventHandler('CORRUPT:beginSellVehicleToPlayer', function(veh)
    local name = veh
    local player = source
    local playerID = CORRUPT.getUserId(source)
    if playerID ~= nil then
        CORRUPTclient.getNearestPlayers(player, {15}, function(nplayers)
            usrList = ""
            for k, v in pairs(nplayers) do
                usrList = usrList .. "[" .. CORRUPT.getUserId(k) .. "]" .. CORRUPT.getPlayerName(k) .. " | "
            end
            if usrList ~= "" then
                CORRUPT.prompt(player, "Players Nearby: " .. usrList .. "", "", function(player, user_id)
                    user_id = user_id
                    if user_id ~= nil and user_id ~= "" then
                        local target = CORRUPT.getUserSource(tonumber(user_id))
                        if target ~= nil then
                            CORRUPT.prompt(player, "Price £: ", "", function(player, amount)
                                if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                    MySQL.query("CORRUPT/get_vehicle", { user_id = user_id, vehicle = name }, function(pvehicle, affected)
                                        if #pvehicle > 0 then
                                            CORRUPT.notify(player, {"~r~The player already has this vehicle type."})
                                        else
                                            local tmpdata = CORRUPT.getUserTmpTable(playerID)
                                            MySQL.query("CORRUPT/check_rented", { user_id = playerID, vehicle = veh }, function(pvehicles)
                                                if #pvehicles > 0 then
                                                    CORRUPT.notify(player, {"~r~You cannot sell a rented vehicle!"})
                                                    return
                                                else
                                                    CORRUPT.prompt(player, "Please replace text with YES or NO to confirm", "Sell Details:\nVehicle: " .. name .. "\nPrice: £" .. getMoneyStringFormatted(amount) .. "\nSelling to player: " .. CORRUPT.getPlayerName(target) .. "(" .. CORRUPT.getUserId(target) .. ")", function(player, details)
                                                        if string.upper(details) == 'YES' then
                                                            CORRUPT.notify(player, {'~g~Sell offer sent!'})
                                                            CORRUPT.request(target, CORRUPT.getPlayerName(player) .. " wants to sell: " .. name .. " Price: £" .. getMoneyStringFormatted(amount), 10, function(target, ok)
                                                                if ok then
                                                                    local pID = CORRUPT.getUserId(target)
                                                                    amount = tonumber(amount)
                                                                    if CORRUPT.tryFullPayment(pID, amount) then
                                                                        CORRUPTclient.despawnGarageVehicle(player, {'car', 15})
                                                                        CORRUPT.getUserIdentity(pID, function(identity)
                                                                            MySQL.execute("CORRUPT/sell_vehicle_player", { user_id = user_id, registration = "P " .. identity.registration, oldUser = playerID, vehicle = name })
                                                                        end)
                                                                        CORRUPT.TransferVehicleMods(pID, name, playerID)
                                                                        CORRUPT.giveBankMoney(playerID, amount)
                                                                        CORRUPT.notify(player, {"~g~You have successfully sold the vehicle to " .. CORRUPT.getPlayerName(target) .. " for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        CORRUPT.notify(target, {"~g~" .. CORRUPT.getPlayerName(player) .. " has successfully sold you the car for £" .. getMoneyStringFormatted(amount) .. "!"})
                                                                        CORRUPT.sendWebhook('sell-vehicle', "Corrupt Sell Vehicle Logs", "> Seller Name: **" .. CORRUPT.getPlayerName(player) .. "**\n> Seller TempID: **" .. player .. "**\n> Seller PermID: **" .. playerID .. "**\n> Buyer Name: **" .. CORRUPT.getPlayerName(target) .. "**\n> Buyer TempID: **" .. target .. "**\n> Buyer PermID: **" .. user_id .. "**\n> Amount: **£" .. getMoneyStringFormatted(amount) .. "**\n> Vehicle: **" .. name .. "**")
                                                                        TriggerEvent("CORRUPT:refreshGaragePermissions", target)
                                                                        TriggerEvent("CORRUPT:refreshGaragePermissions", player)
                                                                    else
                                                                        CORRUPT.notify(player, {"~r~" .. CORRUPT.getPlayerName(target) .. " doesn't have enough money!"})
                                                                        CORRUPT.notify(target, {"~r~You don't have enough money!"})
                                                                    end
                                                                else
                                                                    CORRUPT.notify(player, {"~r~" .. CORRUPT.getPlayerName(target) .. " has refused to buy the car."})
                                                                    CORRUPT.notify(target, {"~r~You have refused to buy " .. CORRUPT.getPlayerName(player) .. "'s car."})
                                                                end
                                                            end)
                                                        else
                                                            CORRUPT.notify(player, {'~r~Sell offer cancelled!'})
                                                        end
                                                    end)
                                                end
                                            end)
                                        end
                                    end)
                                else
                                    CORRUPT.notify(player, {"~r~The price of the car has to be a number."})
                                end
                            end)
                        else
                            CORRUPT.notify(player, {"~r~That ID seems invalid."})
                        end
                    else
                        CORRUPT.notify(player, {"~r~No player ID selected."})
                    end
                end)
            else
                CORRUPT.notify(player, {"~r~No players nearby."})
            end
        end)
    end
end)



RegisterNetEvent('CORRUPT:beginRentVehicleToPlayer')
AddEventHandler('CORRUPT:beginRentVehicleToPlayer', function(veh)
    local name = veh
    local player = source 
    local playerID = CORRUPT.getUserId(source)
    if playerID ~= nil then
		CORRUPTclient.getNearestPlayers(player,{15},function(nplayers)
			usrList = ""
			for k,v in pairs(nplayers) do
				usrList = usrList .. "[" .. CORRUPT.getUserId(k) .. "]" .. CORRUPT.getPlayerName(k) .. " | "
			end
			if usrList ~= "" then
				CORRUPT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player,user_id) 
					user_id = user_id
					if user_id ~= nil and user_id ~= "" then 
						local target = CORRUPT.getUserSource(tonumber(user_id))
						if target ~= nil then
							CORRUPT.prompt(player,"Price £: ","",function(player,amount)
                                CORRUPT.prompt(player,"Rent time (in hours): ","",function(player,rent)
                                    if tonumber(rent) and tonumber(rent) >  0 then 
                                        if tonumber(amount) and tonumber(amount) > 0 and tonumber(amount) < limit then
                                            MySQL.query("CORRUPT/get_vehicle", {user_id = user_id, vehicle = name}, function(pvehicle, affected)
                                                if #pvehicle > 0 then
                                                    CORRUPT.notify(player,{"~r~The player already has this vehicle."})
                                                else
                                                    local tmpdata = CORRUPT.getUserTmpTable(playerID)
                                                    MySQL.query("CORRUPT/check_rented", {user_id = playerID, vehicle = veh}, function(pvehicles)
                                                        if #pvehicles > 0 then 
                                                            return
                                                        else
                                                            CORRUPT.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nVehicle: "..name.."\nRent Cost: "..getMoneyStringFormatted(amount).."\nDuration: "..rent.." hours\nRenting to player: "..CORRUPT.getPlayerName(target).."("..CORRUPT.getUserId(target)..")",function(player,details)
                                                                if string.upper(details) == 'YES' then
                                                                    CORRUPT.notify(player, {'~g~Rent offer sent!'})
                                                                    CORRUPT.request(target,CORRUPT.getPlayerName(player).." wants to rent: " ..name.. " Price: £"..getMoneyStringFormatted(amount) .. ' | for: ' .. rent .. 'hours', 10, function(target,ok)
                                                                        if ok then
                                                                            local pID = CORRUPT.getUserId(target)
                                                                            amount = tonumber(amount)
                                                                            if CORRUPT.tryFullPayment(pID,amount) then
                                                                                CORRUPTclient.despawnGarageVehicle(player,{'car',15}) 
                                                                                CORRUPT.getUserIdentity(pID, function(identity)
                                                                                    local rentedTime = os.time()
                                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(rent)) 
                                                                                    MySQL.execute("CORRUPT/rentedupdate", {user_id = playerID, veh = name, id = pID, rented = 1, rentedid = playerID, rentedunix =  rentedTime }) 
                                                                                end)
                                                                                CORRUPT.TransferVehicleMods(pID, veh, playerID)
                                                                                CORRUPT.giveBankMoney(playerID, amount)
                                                                                CORRUPT.notify(player,{"~g~You have successfully rented the vehicle to "..CORRUPT.getPlayerName(target).." for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                CORRUPT.notify(target,{"~g~"..CORRUPT.getPlayerName(player).." has successfully rented you the car for £"..getMoneyStringFormatted(amount)..' for ' ..rent.. 'hours'})
                                                                                CORRUPT.sendWebhook('rent-vehicle', "Corrupt Rent Vehicle Logs", "> Renter Name: **"..CORRUPT.getPlayerName(player).."**\n> Renter TempID: **"..player.."**\n> Renter PermID: **"..playerID.."**\n> Rentee Name: **"..CORRUPT.getPlayerName(target).."**\n> Rentee TempID: **"..target.."**\n> Rentee PermID: **"..pID.."**\n> Amount: **£"..getMoneyStringFormatted(amount).."**\n> Duration: **"..rent.." hours**\n> Vehicle: **"..veh.."**")
                                                                                TriggerEvent("CORRUPT:refreshGaragePermissions", player)
                                                                                TriggerEvent("CORRUPT:refreshGaragePermissions", target)
                                                                            else
                                                                                CORRUPT.notify(player,{"~r~".. CORRUPT.getPlayerName(target).." doesn't have enough money!"})
                                                                                CORRUPT.notify(target,{"~r~You don't have enough money!"})
                                                                            end
                                                                        else
                                                                            CORRUPT.notify(player,{"~r~"..CORRUPT.getPlayerName(target).." has refused to rent the car."})
                                                                            CORRUPT.notify(target,{"~r~You have refused to rent "..CORRUPT.getPlayerName(player).."'s car."})
                                                                        end
                                                                    end)
                                                                else
                                                                    CORRUPT.notify(player, {'~r~Rent offer cancelled!'})
                                                                end
                                                            end)
                                                        end
                                                    end)
                                                end
                                            end) 
                                        else
                                            CORRUPT.notify(player,{"~r~The price of the car has to be a number."})
                                        end
                                    else 
                                        CORRUPT.notify(player,{"~r~The rent time of the car has to be in hours and a number."})
                                    end
                                end)
							end)
						else
							CORRUPT.notify(player,{"~r~That ID seems invalid."})
						end
					else
						CORRUPT.notify(player,{"~r~No player ID selected."})
					end
				end)
			else
				CORRUPT.notify(player,{"~r~No players nearby."})
			end
		end)
    end
end)



function CORRUPT.InitRentVehicle(source, user_id)
    local rentedin = {}
    local rentedout = {}

    MySQL.query("CORRUPT/get_rented_vehicles_in", {user_id = user_id}, function(pvehicles, affected)
        for _, veh in pairs(pvehicles) do
            for i, v in pairs(vehicle_groups) do
                local config = vehicle_groups[i]._config
                local perm = config.permissions or nil
                if perm then
                    for i, v in pairs(perm) do
                        if not CORRUPT.hasPermission(user_id, v) then
                            break
                        end
                    end
                end
                for a, z in pairs(v) do
                    if a ~= "_config" and veh.vehicle == a then
                        local hoursLeft = ((tonumber(veh.rentedtime) - os.time())) / 3600
                        local minutesLeft = nil
                        local datetime
                        if hoursLeft < 1 then
                            hoursLeft = 0
                        else
                            hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                        end
                        table.insert(rentedin, {vehicleName = z[1], hoursLeft = hoursLeft, rentedBy = veh.rentedid, vehicleId = a})
                    end
                end
            end
        end

        MySQL.query("CORRUPT/get_rented_vehicles_out", {user_id = user_id}, function(pvehicles, affected)
            for _, veh in pairs(pvehicles) do
                for i, v in pairs(vehicle_groups) do
                    local config = vehicle_groups[i]._config
                    local perm = config.permissions or nil
                    if perm then
                        for i, v in pairs(perm) do
                            if not CORRUPT.hasPermission(user_id, v) then
                                break
                            end
                        end
                    end
                    for a, z in pairs(v) do
                        if a ~= "_config" and veh.vehicle == a then
                            local hoursLeft = ((tonumber(veh.rentedtime) - os.time())) / 3600
                            local minutesLeft = nil
                            local datetime
                            if hoursLeft < 1 then
                                hoursLeft = 0
                            else
                                hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
                            end
                            table.insert(rentedout, {vehicleName = z[1], hoursLeft = hoursLeft, rentedBy = veh.rentedid, vehicleId = a})
                        end
                    end
                end
            end
            TriggerClientEvent("CORRUPT:initRentingVehicles", source, rentedin)
            TriggerClientEvent("CORRUPT:initRentedVehicles", source, rentedout)
        end)
    end)
end


RegisterNetEvent('CORRUPT:requestRentCancellation')
AddEventHandler('CORRUPT:requestRentCancellation', function(VehicleName,spawncode, a)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if a == 'owner' then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local target = CORRUPT.getUserSource(result[i].user_id)
                        if target ~= nil then
                            CORRUPT.request(target,CORRUPT.getPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('CORRUPT/rentedupdate', {id = user_id, rented = 0, rentedid = "", rentedunix = "", user_id = result[i].user_id, veh = spawncode})
                                    CORRUPT.notify(target, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    CORRUPT.notify(source, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    CORRUPT.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            CORRUPT.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    elseif a == 'renter' then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicles WHERE user_id = @id", {id = user_id}, function(result)
            if #result > 0 then 
                for i = 1, #result do 
                    if result[i].vehicle == spawncode and result[i].rented then
                        local rentedid = tonumber(result[i].rentedid)
                        local target = CORRUPT.getUserSource(rentedid)
                        if target ~= nil then
                            CORRUPT.request(target,CORRUPT.getPlayerName(source).." would like to cancel the rent on the vehicle: ", 10, function(target,ok)
                                if ok then
                                    MySQL.execute('CORRUPT/rentedupdate', {id = rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = user_id, veh = spawncode})
                                    CORRUPT.notify(source, {"~r~" ..VehicleName.." has been returned to the vehicle owner."})
                                    CORRUPT.notify(target, {"~r~" ..VehicleName.." has been returned to your garage."})
                                else
                                    CORRUPT.notify(source, {"~r~User has declined the request to cancel the rental of vehicle: " ..VehicleName})
                                end
                            end)
                        else
                            CORRUPT.notify(source, {"~r~The player is not online."})
                        end
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent('CORRUPT:ExtendRent')
AddEventHandler('CORRUPT:ExtendRent', function(spawncode, VehicleName)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute("SELECT * FROM corrupt_user_vehicles WHERE rentedid = @id", {id = user_id}, function(result)
        if #result > 0 then 
            for i = 1, #result do 
                if result[i].vehicle == spawncode and result[i].rented then
                    CORRUPT.prompt(source,"Extend time (hours):","",function(source,extendRentTime) 
                        extendRentTime = tonumber(extendRentTime)
                        if extendRentTime > 0 then
                            exports["corrupt"]:executeSync("UPDATE corrupt_user_vehicles SET rentedtime = @extendRentTime WHERE user_id = @user_id AND vehicle = @vehicle", {extendRentTime = extendRentTime*3600+result[i].rentedtime, user_id = result[i].user_id, vehicle = spawncode})
                            CORRUPT.notify(source, {"~g~Extended rent time of "..VehicleName.." by "..extendRentTime.." hours."})
                        else
                            CORRUPT.notify(source, {"~r~Invalid time."})
                            return
                        end
                    end)
                end
            end
        end
    end)
end)

-- repair nearest vehicle
local function ch_repair(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    -- anim and repair
    if CORRUPT.tryGetInventoryItem(user_id,"repairkit",1,true) then
      CORRUPTclient.playAnim(player,{false,{task="WORLD_HUMAN_WELDING"},false})
      SetTimeout(15000, function()
        CORRUPTclient.fixeNearestVehicle(player,{7})
        CORRUPTclient.stopAnim(player,{false})
      end)
    end
  end
end

function CORRUPT.PayVehicleTax(user_id, source)
    if user_id ~= nil then
        local bank = CORRUPT.getBankMoney(user_id)
        local payment = bank / 10000
        if CORRUPT.tryBankPayment(user_id, payment) then
            CORRUPT.notify(source,{"~g~Paid £"..getMoneyStringFormatted(math.floor(payment)).." vehicle tax."})
            TriggerEvent('CORRUPT:addToCommunityPot', math.floor(payment))
        else
            CORRUPT.notify(source,{"~r~Its fine... Tax payers will pay your vehicle tax instead."})
        end
    end
end

RegisterNetEvent("CORRUPT:refreshGaragePermissions")
AddEventHandler("CORRUPT:refreshGaragePermissions",function(target)
    local source = source
    if target then source = target end
    local garageTable = {}
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(cfg.garages) do
        for a,b in pairs(v) do
            if a == "_config" then
                if json.encode(b.permissions) ~= '[""]' then
                    local hasPermissions = 0
                    for c,d in pairs(b.permissions) do
                        if CORRUPT.hasPermission(user_id, d) then
                            hasPermissions = hasPermissions + 1
                        end
                    end
                    if hasPermissions == #b.permissions then
                        garageTable[k] = true
                    end
                else
                    garageTable[k] = true
                end
            end
        end
    end
    local ownedVehicles = {}
    if user_id then
        local vehicleWeights = {}
        MySQL.query("CORRUPT/get_vehicles", {user_id = user_id}, function(pvehicles, affected)
            local numVehicles = 0
            for k,v in pairs(pvehicles) do
                table.insert(ownedVehicles, {vehicleId = v.vehicle, fuel = v.fuel_level})
                numVehicles = numVehicles + 1
                CORRUPT.getSData("chest:u1veh_" .. v.vehicle .. '|' .. user_id, function(cdata)
                    cdata = json.decode(cdata) or {}
                    local currentVehWeight = CORRUPT.computeItemsWeight(cdata) or 0
                    local maxVehKg = cfg_inventory.vehicle_chest_weights[a] or 30
                    local weightColour = "~g~"
                    local weightCalc = currentVehWeight / maxVehKg
                    if weightCalc > 0.9 then
                        weightColour = "~r~"
                    elseif weightCalc > 0.5 then
                        weightColour = "~o~"
                    elseif weightCalc > 0 then
                        weightColour = "~y~"
                    end
                    vehicleWeights[v.vehicle] =  weightColour.."Boot "..currentVehWeight.."/"..maxVehKg.."kg"
                    numVehicles = numVehicles - 1
                    if numVehicles == 0 then
                        TriggerClientEvent('CORRUPT:returnVehicleWeights', source, vehicleWeights)
                        CORRUPT.setOwnedVehicles(source, ownedVehicles)
                        TriggerClientEvent('CORRUPT:updateOwnedVehicles', source, ownedVehicles)
                        CORRUPT.InitRentVehicle(source, user_id)
                        TriggerClientEvent("CORRUPT:recieveRefreshedGaragePermissions", source, garageTable)
                    end
                end)
            end
        end)
    end
end)


RegisterNetEvent("CORRUPT:getGarageFolders")
AddEventHandler("CORRUPT:getGarageFolders",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local garageFolders = {}
    local addedFolders = {}
    MySQL.query("CORRUPT/get_vehicles", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                local spawncode = v.vehicle 
                for a,b in pairs(vehicle_groups) do
                    local hasPerm = true
                    if next(b._config.permissions) then
                        if not CORRUPT.hasPermission(user_id, b._config.permissions[1]) then
                            hasPerm = false
                        end
                    end
                    if hasPerm then
                        for c,d in pairs(b) do
                            if c == spawncode and not v.impounded then
                                if not addedFolders[a] then
                                    table.insert(garageFolders, {display = a})
                                    addedFolders[a] = true
                                end
                                for e,f in pairs (garageFolders) do
                                    if f.display == a then
                                        if f.vehicles == nil then
                                            f.vehicles = {}
                                        end
                                        table.insert(f.vehicles, {display = d[1], spawncode = spawncode})
                                    end
                                end
                            end
                        end
                    end
                end
            end
            TriggerClientEvent('CORRUPT:setVehicleFolders', source, garageFolders)
        end
    end)
end)

local cfg_weapons = module("corrupt-assets", "cfg/weapons")

RegisterServerEvent("CORRUPT:searchVehicle")
AddEventHandler('CORRUPT:searchVehicle', function(entity, permid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        if CORRUPT.getUserSource(permid) ~= nil then
            CORRUPTclient.getNetworkedVehicleInfos(CORRUPT.getUserSource(permid), {entity}, function(owner, spawncode)
                if spawncode and owner == permid then
                    local vehformat = 'chest:u1veh_'..spawncode..'|'..permid
                    CORRUPT.getSData(vehformat, function(cdata)
                        if cdata ~= nil then
                            cdata = json.decode(cdata)
                            if next(cdata) then
                                for a,b in pairs(cdata) do
                                    if string.find(a, 'wbody|') then
                                        c = a:gsub('wbody|', '')
                                        cdata[c] = b
                                        cdata[a] = nil
                                    end
                                end
                                for k,v in pairs(cfg_weapons.weapons) do
                                    if cdata[k] ~= nil then
                                        if not v.policeWeapon then
                                            CORRUPT.notify(source, {'~r~Seized '..v.name..' x'..cdata[k].amount..'.'})
                                            cdata[k] = nil
                                        end
                                    end
                                end
                                for c,d in pairs(cdata) do
                                    if seizeBullets[c] then
                                        CORRUPT.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                    if seizeDrugs[c] then
                                        CORRUPT.notify(source, {'~r~Seized '..c..' x'..d.amount..'.'})
                                        cdata[c] = nil
                                    end
                                end
                                CORRUPT.setSData(vehformat, json.encode(cdata))
                                CORRUPT.sendWebhook('seize-boot', 'Corrupt Seize Boot Logs', "> Officer Name: **"..CORRUPT.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Vehicle: **"..spawncode.."**\n> Owner ID: **"..permid.."**")
                            else
                                CORRUPT.notify(source, {'~r~This vehicle is empty.'})
                            end
                        else
                            CORRUPT.notify(source, {'~r~This vehicle is empty.'})
                        end
                    end)
                end
            end)
        end
    end
end)


Citizen.CreateThread(function()
    Wait(1500)
    exports['corrupt']:execute([[
        CREATE TABLE IF NOT EXISTS `corrupt_custom_garages` (
            `user_id` INT(11) NOT NULL AUTO_INCREMENT,
            `folder` TEXT NULL DEFAULT NULL COLLATE 'utf8mb4_general_ci',
            PRIMARY KEY (`user_id`) USING BTREE
        );
    ]])
end)
