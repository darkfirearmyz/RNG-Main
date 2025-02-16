exports["corruptui"]:registerCallback("openDisputeUI", function(data)
    exports["corruptui"]:sendMessage({
        app = "dispute",
        type = "APP_TOGGLE",
    })
    CORRUPT.hideUI()
    TriggerScreenblurFadeIn(100.0)
    exports["corruptui"]:setFocus(true, true, false)
    -- -- set test data
    -- exports["corruptui"]:sendMessage({
    --     type = "DISPUTE_UI_SET_DATA",
    --     info = {
    --         disputesResult = {
    --             { user_id = "1", target_id = "2", muted = true, blocked = false },
    --             { user_id = "2", target_id = "1", muted = false, blocked = true },
    --         },
    --         messagesResult = {
    --             { user_id = "1", target_id = "2", name = "User 1", message = "Message 1 from User 1 to Target 1", date = "2024-02-25" },
    --             { user_id = "2", target_id = "1", name = "User 2", message = "Message 1 from User 2 to Target 2", date = "2024-02-25" },
    --         },
    --         localUserId = CORRUPT.getUserId(),
    --     }
    -- })

    -- -- DISPUTE_UI_CREATE_INBOX
    -- exports["corruptui"]:sendMessage({
    --     type = "DISPUTE_UI_CREATE_INBOX",
    --     info = {
    --         id = "dispute_id",
    --         name = "Dispute Name",
    --         localUserId = "2",
    --     }
    -- })

    -- -- DISPUTE_UI_ADD_RECENT
    -- exports["corruptui"]:sendMessage({
    --     type = "DISPUTE_UI_ADD_RECENT",
    --     info = {
    --         targetUserId = "2",
    --         name = "User 2",
    --     }
    -- })
end)

-- -- disputeSendMessage
-- exports["corruptui"]:registerCallback("disputeSendMessage", function(data)
--     print(json.encode(data))
--     exports["corruptui"]:sendMessage({
--         type = "DISPUTE_UI_ADD_MESSAGE",
--         info = {
--             localUserId = CORRUPT.getUserId(),
--             target_id = data.targetUserId,
--             message = data.content,
--             date = "2024-02-25",
--             isOwner = true,
--         }
--     })
-- end)

-- -- disputeSetMuted
-- exports["corruptui"]:registerCallback("disputeSetMuted", function(data)
--     print(json.encode(data))
--     exports["corruptui"]:sendMessage({
--         type = "DISPUTE_UI_SET_MUTED",
--         info = {
--             isMuted = data.muted,
--             targetUserId = data.targetUserId,
--         }
--     })
-- end)

-- -- disputeSetBlocked
-- exports["corruptui"]:registerCallback("disputeSetBlocked", function(data)
--     print(json.encode(data))
--     exports["corruptui"]:sendMessage({
--         type = "DISPUTE_UI_SET_BLOCKED",
--         info = {
--             isBlocked = data.blocked,
--             targetUserId = data.targetUserId,
--         }
--     })
-- end)

-- -- disputeDelete
-- exports["corruptui"]:registerCallback("disputeDelete", function(data)
--     print(json.encode(data))
--     exports["corruptui"]:sendMessage({
--         type = "DISPUTE_UI_DELETE_USER",
--         info = {
--             targetUserId = data.targetUserId,
--         }
--     })
-- end)

-- exports["corruptui"]:registerCallback("notification", function(data)
--     print(json.encode(data))
--     exports["corruptui"]:sendMessage({
--         type = "DISPUTE_UI_SET_NOTIFICATIONS",
--         info = {
--             makeNoise = true,
--             notifications = "test message",
--             name = "test",
--         }
--     })
-- end)
