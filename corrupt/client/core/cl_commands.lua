Citizen.CreateThread(
    function()
        AddTextEntry("FE_THDR_GTAO", "CORRUPT British RP - discord.gg/corrupt5m")
        AddTextEntry("PM_PANE_CFX", "CORRUPT")
    end
)
RegisterCommand(
    "discord",
    function()
        TriggerEvent("chatMessage", "^1[CORRUPT]^1  ", {128, 128, 128}, "^0Discord: discord.gg/corrupt5m", "ooc")
        tvRP.notify("~g~discord Copied to Clipboard.")
        tvRP.copyToClipboard("https://discord.gg/corrupt5m")
    end
)
RegisterCommand(
    "getid",
    function(a, b)
        if b and b[1] then
            if CORRUPT.clientGetUserIdFromSource(tonumber(b[1])) ~= nil then
                if CORRUPT.clientGetUserIdFromSource(tonumber(b[1])) ~= CORRUPT.getUserId() then
                    TriggerEvent(
                        "chatMessage",
                        "^1[CORRUPT]^1  ",
                        {128, 128, 128},
                        "This Users Perm ID is: " .. CORRUPT.clientGetUserIdFromSource(tonumber(b[1])),
                        "alert"
                    )
                else
                    TriggerEvent(
                        "chatMessage",
                        "^1[CORRUPT]^1  ",
                        {128, 128, 128},
                        "This Users Perm ID is: " .. CORRUPT.getUserId(),
                        "alert"
                    )
                end
            else
                TriggerEvent("chatMessage", "^1[CORRUPT]^1  ", {128, 128, 128}, "Invalid Temp ID", "alert")
            end
        else
            TriggerEvent(
                "chatMessage",
                "^1[CORRUPT]^1  ",
                {128, 128, 128},
                "Please specify a user eg: /getid [tempid]",
                "alert"
            )
        end
    end
)
