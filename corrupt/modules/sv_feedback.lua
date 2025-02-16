RegisterServerEvent("CORRUPT:adminTicketFeedback")
AddEventHandler("CORRUPT:adminTicketFeedback", function(AdminID, FeedBackType, Message)
    local AdminID = CORRUPT.getUserId(AdminID)
    local AdminSource = CORRUPT.getSourceFromUserId(AdminID)
    local AdminName = CORRUPT.getPlayerName(AdminSource)

    local FeedBackType = FeedBackType
    local PlayerName = CORRUPT.getPlayerName(source) -- source now refers to the player
    local PlayerID = CORRUPT.getUserId(source) -- source now refers to the player

    -- Check and replace nil values with "N/A" for local variables
    local AdminID = AdminID or "N/A"
    local AdminName = AdminName or "N/A"
    local PlayerName = PlayerName or "N/A"
    local PlayerID = PlayerID or "N/A"
    local FeedBackType = FeedBackType or "N/A"

    if Message == "" then
        Message = "No Feedback Provided."
    end

    local feedbackInfo = "> Player Name: **" .. PlayerName .. "**\n" ..
                         "> Player PermID: **" .. PlayerID .. "**\n" ..
                         "> Feedback Type: **" .. FeedBackType .. "**\n" ..
                         "> Admin Perm ID**: " .. AdminID .. "**\n" ..
                         "> Admin Name**: " .. AdminName .. "**\n" ..
                         "> Message: **" .. Message .. "**\n"

    CORRUPT.sendWebhook('feedback', 'Corrupt Feedback Logs', feedbackInfo)

    if FeedBackType == "good" then
        CORRUPT.giveBankMoney(AdminID, 25000)
        CORRUPT.notify(AdminSource, {"~g~You have received £25000 for a good feedback."})
        CORRUPT.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        CORRUPT.giveBankMoney(AdminID, 10000)
        CORRUPT.notify(AdminSource, {"~g~You have received £10000 for a neutral feedback."})
        CORRUPT.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        CORRUPT.giveBankMoney(AdminID, 5000)
        CORRUPT.notify(AdminSource, {"~g~You have received £5000 for a bad feedback."})
        CORRUPT.notify(source, {"~r~You have given a Bad feedback."})
    end
end)



RegisterServerEvent("CORRUPT:adminTicketNoFeedback")
AddEventHandler("CORRUPT:adminTicketNoFeedback", function(PlayerSource, AdminPermID)
    if PlayerSource == nil then
        return
    end
    local PlayerName = CORRUPT.getPlayerName(PlayerSource)
    local AdminID = CORRUPT.getUserId(source) -- 'source' here is the admin who receives the feedback
    local AdminName = CORRUPT.getPlayerName(AdminID)
    local AdminPermID = CORRUPT.getUserId(AdminID)
    local PlayerID = CORRUPT.getUserId(PlayerSource)
    if FeedBackType == "good" then
        CORRUPT.giveBankMoney(AdminPermID, 25000)
        CORRUPT.notify(AdminID, {"~g~You have received £25000 for a good feedback."})
        CORRUPT.notify(source, {"~g~You have given a Good feedback."})
    elseif FeedBackType == "neutral" then
        CORRUPT.giveBankMoney(AdminPermID, 10000)
        CORRUPT.notify(AdminID, {"~g~You have received £10000 for a good feedback."})
        CORRUPT.notify(source, {"~y~You have given a Neutral feedback."})
    elseif FeedBackType == "bad" then
        CORRUPT.giveBankMoney(AdminPermID, 5000)
        CORRUPT.notify(AdminID, {"~g~You have received £5000 for a good feedback."})
        CORRUPT.notify(source, {"~r~You have given a Bad feedback."})
    end
    CORRUPT.sendWebhook('feedback', 'Corrupt Feedback Logs', "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> **Feedback Type**"..FeedbackType.."\n> **Admin Perm ID: **"..AdminPermID)
end)