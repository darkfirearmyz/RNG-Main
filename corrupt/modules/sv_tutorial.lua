RegisterNetEvent('CORRUPT:checkTutorial')
AddEventHandler('CORRUPT:checkTutorial', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'TutorialDone') or CORRUPT.isPurge() then
        TriggerClientEvent('CORRUPT:setCompletedTutorial', source)
    else
        if CORRUPT.isDeveloper(user_id) then
            CORRUPT.addUserGroup(user_id, 'TutorialDone')
            return
        end
        TriggerClientEvent('CORRUPT:playTutorial', source)
        CORRUPT.setBucket(source, user_id)
        TriggerClientEvent('CORRUPT:setBucket', source, user_id)
        TriggerClientEvent('CORRUPT:setIsNewPlayer', source)
    end
end)

RegisterNetEvent('CORRUPT:setCompletedTutorial')
AddEventHandler('CORRUPT:setCompletedTutorial', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local ped = GetPlayerPed(source)
    local playerCoords = GetEntityCoords(ped)
    if #(playerCoords - vector3(-566.48754882812,-194.36938476562,39.146049499512)) <= 50.0 then
        if not CORRUPT.hasGroup(user_id, 'TutorialDone') then
            CORRUPT.addUserGroup(user_id, 'TutorialDone')
            CORRUPT.addUserGroup(user_id, 'NewPlayer')
            CORRUPT.setBucket(source, 0)
            TriggerClientEvent('CORRUPT:setBucket', source, 0)
        end
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Trigger Tutorial Done'.. ' | ' ..playerCoords)
    end
end)