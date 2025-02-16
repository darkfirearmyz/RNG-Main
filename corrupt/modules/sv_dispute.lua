function CORRUPT.GetOfflinePlayerName(id)
    exports['corrupt']:execute("SELECT * FROM `corrupt_users` WHERE `id` = @id", {['@id'] = id}, function(result)
        print(json.encode(result))
        return result[1].username
    end)
end





RegisterServerEvent("CORRUPT:Dispute:SendMessage")
AddEventHandler("CORRUPT:Dispute:SendMessage", function(data)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local date = os.date("%Y-%m-%d %H:%M")
    local target_id = data.targetUserId
    local message = data.content
    local target_source = CORRUPT.getUserSource(target_id)
    TriggerClientEvent("CORRUPT:Dispute:Message", source, {message = message, date = date, name = "KrepZz", localUserId = user_id, target_id = target_id, isOwner = true})
    if target_source then
        TriggerClientEvent("CORRUPT:Dispute:Message", target_source, {message = message, date = date, name = name, localUserId = user_id, target_id = user_id, isOwner = false})
    end
end)



RegisterCommand("AddRecent", function(source)
    local targetUserId = 1
    local name = "KrepZz"
    TriggerClientEvent("CORRUPT:Dispute:AddRecent", source, {targetUserId = targetUserId, name = name})
end)


RegisterCommand("SendMessage", function(source)
    local user_id = 1
    local name = "KrepZz"
    local date = os.date("%Y-%m-%d %H:%M")
    local targetUserId = CORRUPT.getUserId(source)
    local message = "Test Message"

    TriggerClientEvent("CORRUPT:Dispute:SendMessage", source, {message = message, date = date, name = name, localUserId = user_id, target_id = target_id, isOwner = false})
end)
    










