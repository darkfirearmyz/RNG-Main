-- local price = 2500000

-- local function checkBoot(vehicle, userId, callback)
--     exports['corrupt']:executeSync('SELECT * FROM corrupt_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, callback)
-- end

-- local function handleBootCheckResult(source, result)
--     if result and result[1] then
--         if result[1].owned then
--             print("Sending boot data to client")
--             TriggerClientEvent("CORRUPT:VehicleBoot:Return", source, true, {})
--         end
--     else
--         TriggerClientEvent("CORRUPT:VehicleBoot:Return", source, false, {})
--     end
-- end

-- RegisterServerEvent('CORRUPT:VehicleBoot:Check')
-- AddEventHandler("CORRUPT:VehicleBoot:Check", function(vehicle)
--     local userId = CORRUPT.getUserId(source)
--     exports['corrupt']:executeSync('SELECT * FROM corrupt_user_vehicles WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(vehicleCheckResult)
        
--         if vehicleCheckResult and vehicleCheckResult[1] then
--             checkBoot(vehicle, userId, function(bootCheckResult)
--                 handleBootCheckResult(source, bootCheckResult)
--             end)
--         end
--     end)
-- end)

-- RegisterServerEvent('CORRUPT:VehicleBoot:Purchase')
-- AddEventHandler("CORRUPT:VehicleBoot:Purchase", function(vehicle)
--     local userId = CORRUPT.getUserId(source)
--     if CORRUPT.tryFullPayment(userId, price) then
--         checkBoot(vehicle, userId, function(result)
--             if not result[1] then
--                 exports['corrupt']:execute('INSERT INTO corrupt_user_boot (user_id, vehicle, owned) VALUES (@user_id, @vehicle, @owned)', 
--                     { user_id = userId, vehicle = vehicle, owned = true })

--                 TriggerClientEvent("CORRUPT:VehicleBoot:Return", source, true, {})
--                 CORRUPT.notify(source, {"~g~You have purchased a vehicle boot!"})
--             end
--         end)
--     else
--         CORRUPT.notify(source, {"~r~You don't have enough money!"})
--     end
-- end)

-- local function updateUserBoot(source, vehicle, userId, target_id, target_name, updateCallback)
--     exports['corrupt']:execute('SELECT * FROM corrupt_user_boot WHERE vehicle = @vehicle AND user_id = @user_id', 
--         { vehicle = vehicle, user_id = userId }, function(result)
--             if result and result[1] then
--                 local users = json.decode(result[1].users) or {}
--                 updateCallback(users, function(updatedUsers)e
--                     local updatedUsersJson = json.encode(updatedUsers)
--                     exports['corrupt']:execute('UPDATE corrupt_user_boot SET users = @users WHERE vehicle = @vehicle AND user_id = @user_id', 
--                         { users = updatedUsersJson, vehicle = vehicle, user_id = userId })
--                     TriggerClientEvent("CORRUPT:VehicleBoot:Return", source, true, updatedUsers)
--                 end)
--             else
--                 print("No result found for vehicle: " .. vehicle .. " and user_id: " .. userId)
--             end
--         end)
-- end

-- RegisterServerEvent("CORRUPT:VehicleBoot:Add")
-- AddEventHandler("CORRUPT:VehicleBoot:Add", function(vehicle)
--     local userId = CORRUPT.getUserId(source)
--     CORRUPT.prompt(source, "Enter Perm ID", "", function(source, target_id)
--         if CORRUPT.getUserSource(target_id) then
--             CORRUPT.notify(source, {"~r~Player is online!"})
--             return
--         end
--         local target_name = CORRUPT.getPlayerName(target_id)
--         if target_name then
--             updateUserBoot(source, vehicle, userId, target_id, target_name, function(users, commitChanges)
--                 if not users[target_id] then
--                     users[target_id] = { name = target_name, user_id = target_id }
--                     commitChanges(users)
--                     print("Added user_id: " .. target_id .. " to vehicle boot.")
--                 else
--                     print("User with ID " .. target_id .. " already exists in vehicle boot.")
--                 end
--             end)
--         else
--             CORRUPT.notify(source, {"~r~Player not found!"})
--         end
--     end)
-- end)


-- RegisterServerEvent("CORRUPT:VehicleBoot:Remove")
-- AddEventHandler("CORRUPT:VehicleBoot:Remove", function(vehicle, target_id)
--     local userId = CORRUPT.getUserId(source)
--     updateUserBoot(source, vehicle, userId, target_id, function(users, commitChanges)
--         if users[target_id] then
--             users[target_id] = nil
--             commitChanges(users)
--             print("Removed user_id: " .. target_id .. " from vehicle boot.")
--         else
--             print("User with ID " .. target_id .. " not found in vehicle boot.")
--         end
--     end)
-- end)


