-- local playersinMosinCity = {}

-- RegisterNetEvent("CORRUPT:MosinCity:Enter")
-- AddEventHandler("CORRUPT:MosinCity:Enter", function()
--     local source = source
--     local found = false

--     -- Check if the player is already in the list
--     for _, player in ipairs(playersinMosinCity) do
--         if player.id == source then
--             found = true
--             break
--         end
--     end

--     -- If not found, add the player
--     if not found then
--         local player = {
--             id = source,
--             kills = 0,
--             headshots = 0
--         }
--         table.insert(playersinMosinCity, player)
--     end
-- end)

-- RegisterNetEvent("CORRUPT:MosinCity:Exit")
-- AddEventHandler("CORRUPT:MosinCity:Exit", function()
--     local source = source

--     -- Remove the player from the list
--     for i = #playersinMosinCity, 1, -1 do
--         if playersinMosinCity[i].id == source then
--             table.remove(playersinMosinCity, i)
--             break
--         end
--     end
-- end)

-- RegisterNetEvent("CORRUPT:MosinCity:Killed")
-- AddEventHandler("CORRUPT:MosinCity:Killed", function(killerId)
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     local killerUserId = CORRUPT.getUserId(killerId)

--     local foundKiller = false
--     local foundVictim = false
--     local victimPlayer

--     -- Loop through players to find the killer and victim
--     for _, player in ipairs(playersinMosinCity) do
--         if player.id == killerId then
--             foundKiller = true
--             player.kills = player.kills + 1  -- Increment the killer's kill count
--         end
--         if player.id == source then
--             foundVictim = true
--             victimPlayer = player
--         end
--     end

--     if foundVictim then
--         local amountEarned = victimPlayer.kills * 5000
--         CORRUPT.giveBankMoney(user_id, amountEarned)
--         CORRUPT.notify(source, "~r~You have been killed by " .. CORRUPT.getPlayerName(killerId) .. " in Mosin City.")
--     end

--     if foundKiller and foundVictim then
--         local killerAmountEarned = (math.floor(playersinMosinCity[killerId].kills / 5) * 50000)
--         CORRUPT.giveBankMoney(killerUserId, killerAmountEarned)
--         CORRUPT.notify(killerId, "~g~You have earned £" .. getMoneyStringFormatted(killerAmountEarned) .. " for killing " .. CORRUPT.getPlayerName(source) .. " in Mosin City.")
--         TriggerClientEvent("CORRUPT:MosinCity:UpdateKills", killerId, playersinMosinCity)
--     end
-- end)
