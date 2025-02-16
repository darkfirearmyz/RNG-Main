
RegisterServerEvent("CORRUPT:PauseMenu:GetData")
AddEventHandler("CORRUPT:PauseMenu:GetData", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local job = CORRUPT.GetPlayerJob(user_id)
    local Players = #GetPlayers()
    local PlayTime = CORRUPT.GetPlayTime(user_id)
    TriggerClientEvent("CORRUPT:PauseMenu:ReturnData", source, job, PlayTime)
end)


RegisterServerEvent("CORRUPT:PauseMenu:Exit")
AddEventHandler("CORRUPT:PauseMenu:Exit", function()
    local source = source
    DropPlayer(source, "You have left the server.")
end)