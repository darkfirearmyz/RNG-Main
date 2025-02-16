-- function CORRUPT.updateCurrentPlayerInfo()
--   local currentPlayersInformation = {}
--   local playersJobs = {}
--   for k,v in pairs(CORRUPT.getUsers()) do
--     table.insert(playersJobs, {user_id = k, jobs = CORRUPT.getUserGroups(k)})
--   end
--   currentPlayersInformation['currentStaff'] = CORRUPT.getUsersByPermission('admin.tickets')
--   currentPlayersInformation['jobs'] = playersJobs
--   TriggerClientEvent("CORRUPT:receiveCurrentPlayerInfo", -1, currentPlayersInformation)
-- end


-- AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
--   if first_spawn then
--     CORRUPT.updateCurrentPlayerInfo()
--   end
-- end)