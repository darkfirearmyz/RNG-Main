local verifyCodes = {}

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        for k, v in pairs(verifyCodes) do
            if verifyCodes[k] ~= nil then
                verifyCodes[k] = nil
            end
        end
    end
end)

RegisterServerEvent('CORRUPT:changeLinkedDiscord', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.prompt(source, "Enter Discord Id:", "", function(source, discordid)
        if discordid ~= nil and (tonumber(discordid) ~= nil or discordid == "") then
            TriggerClientEvent('CORRUPT:gotDiscord', source)
            local code = generateUUID("linkcode", 5, "alphanumeric")
            verifyCodes[user_id] = { code = code, discordid = discordid, timestamp = os.time() }
            exports['corrupt']:dmUser(source, { discordid, code, user_id }, function() end)
        else
            CORRUPT.notify(source, { '~r~You need to enter a valid discord id!' })
        end
    end)
end)



RegisterServerEvent('CORRUPT:enterDiscordCode', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local currentTimestamp = os.time()
    local verification = verifyCodes[user_id]

    if verification and currentTimestamp - verification.timestamp <= 300 then
        CORRUPT.prompt(source, "Enter Code:", "", function(source, code)
            if code and code ~= "" then
                if verification.code == code then
                    exports['corrupt']:execute("UPDATE `corrupt_verification` SET discord_id = @discord_id WHERE user_id = @user_id", { user_id = user_id, discord_id = verification.discordid }, function() end)
                    CORRUPT.notify(source, { '~g~Your discord has been successfully updated.' })
                else
                    CORRUPT.notify(source, { '~r~Invalid code.' })
                end
            else
                CORRUPT.notify(source, { '~r~You need to enter a code!' })
            end
        end)
    else
        CORRUPT.notify(source, { '~r~Your code has expired.' })
    end
end)
