

function CORRUPT.GetWarnings(user_id, source)
    local frwarningstables = exports['corrupt']:executeSync("SELECT * FROM corrupt_warnings WHERE user_id = @uid", { uid = user_id })
    for warningID, warningTable in pairs(frwarningstables) do
        local date = warningTable["warning_date"]
        local newdate = tonumber(date) / 1000
        newdate = os.date('%Y-%m-%d', newdate)
        warningTable["warning_date"] = newdate
		local points = warningTable["point"]
    end
    return frwarningstables
end




function CORRUPT.AddWarnings(target_id, adminName, warningReason, warning_duration, point)
    if warning_duration == -1 then
        warning_duration = 0
    end
    exports['corrupt']:execute("INSERT INTO corrupt_warnings (`user_id`, `warning_type`, `duration`, `admin`, `warning_date`, `reason`, `point`) VALUES (@user_id, @warning_type, @duration, @admin, @warning_date, @reason, @point);", { user_id = target_id, warning_type = "Ban", admin = adminName, duration = warning_duration, warning_date = os.date("%Y/%m/%d"), reason = warningReason, point = point })
end



RegisterServerEvent("CORRUPT:refreshWarningSystem")
AddEventHandler("CORRUPT:refreshWarningSystem", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local frwarningstables = CORRUPT.GetWarnings(user_id, source)
    local a = exports['corrupt']:executeSync("SELECT * FROM corrupt_bans_offenses WHERE UserID = @uid", { uid = user_id })
    for k, v in pairs(a) do
        if v.UserID == user_id then
            for warningID, warningTable in pairs(frwarningstables) do
                warningTable["points"] = v.points
            end
            local info = { user_id = user_id, playtime = CORRUPT.GetPlayTime(user_id) }
            TriggerClientEvent("CORRUPT:recievedRefreshedWarningData", source, frwarningstables, v.points, info)
        end
    end
end)

RegisterCommand('sw', function(source, args)
    local user_id = CORRUPT.getUserId(source)
    local permID = tonumber(args[1])
    if permID then
        if CORRUPT.hasPermission(user_id, "admin.tickets") then
            local frwarningstables = CORRUPT.GetWarnings(permID, source)
            local a = exports['corrupt']:executeSync("SELECT * FROM corrupt_bans_offenses WHERE UserID = @uid", { uid = permID })
            for k, v in pairs(a) do
                if v.UserID == permID then
                    for warningID, warningTable in pairs(frwarningstables) do
                        warningTable["points"] = v.points
                    end
                    local info = { user_id = permID, playtime = CORRUPT.GetPlayTime(permID) }
                    TriggerClientEvent("CORRUPT:showWarningsOfUser", source, frwarningstables, v.points, info)
                end
            end
        end
    end
end)
