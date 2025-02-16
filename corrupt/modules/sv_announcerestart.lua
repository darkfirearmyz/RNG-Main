RegisterCommand('restartserver', function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Lead Developer') or source == '' then
        if args[1] ~= nil then
            timeLeft = args[1]
            local shutdownTime = timeLeft - 10
            print(shutdownTime)
            TriggerClientEvent('CORRUPT:announceRestart', -1, tonumber(timeLeft), false)
            TriggerEvent('CORRUPT:restartTime', timeLeft)
            TriggerClientEvent('CORRUPT:CloseToRestart', -1)
            Online = false
        end
    end
end)
RegisterCommand('consolerestart', function(source, args)
    local source = source
    if source == 0 then
        timeLeft = args[1]
        local shutdownTime = timeLeft - 10
        print('Restarting in ' .. timeLeft .. ' seconds.')
        TriggerClientEvent('CORRUPT:announceRestart', -1, tonumber(timeLeft), false)
        TriggerEvent('CORRUPT:restartTime', timeLeft)
        TriggerClientEvent('CORRUPT:CloseToRestart', -1)
        Online = false
    end
end)
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        local time = os.date("*t")
        local hour = tonumber(time["hour"])
        local firstDayOfMonth = os.date("%d", os.time{year=os.date("%Y"), month=os.date("%m")+1, day=0})
        if hour == 10 then
            if tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
                TriggerClientEvent('CORRUPT:announceRestart', -1, 60, true)
                TriggerClientEvent('CORRUPT:CloseToRestart', -1)
                if time.day == tonumber(firstDayOfMonth) then
                    TriggerEvent('CORRUPT:endmonth', 60)
                else
                    TriggerEvent('CORRUPT:restartTime', 60)
                end
                
                Online = false
            end
        end
    end
end)
RegisterServerEvent("CORRUPT:endmonth")
AddEventHandler("CORRUPT:endmonth", function(time)
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(CORRUPT.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                CORRUPT.EndBootWipe()
                Wait(5000)
                os.exit()
            end
        end
    end)
end)
RegisterServerEvent("CORRUPT:restartTime")
AddEventHandler("CORRUPT:restartTime", function(time)
    -- trigger bot status embed
    time = tonumber(time)
    if source ~= '' then return end
    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(1000)
            time = time - 1
            if time == 0 then
                for k,v in pairs(CORRUPT.getUsers({})) do
                    DropPlayer(v, "Server restarting, please join back in a few minutes.")
                end
                os.exit()
            end
        end
    end)
end)
-- purge restart

function CORRUPT.RestartServer(time)
    timeLeft = time
    TriggerClientEvent('CORRUPT:announceRestart', -1, tonumber(timeLeft), false)
    TriggerEvent('CORRUPT:restartTime', timeLeft)
    TriggerClientEvent('CORRUPT:CloseToRestart', -1)
end




function CORRUPT.EndBootWipe()
    local bootscleared = 0
    local playersCleared = 0
    local f10pointsremoved = 0
    exports['corrupt']:execute("SELECT * FROM corrupt_srv_data", function(boots)
        bootscleared = #boots
        exports['corrupt']:execute("SELECT dvalue FROM corrupt_user_data WHERE dkey = 'CORRUPT:datatable'", function(players)
            playersCleared = #players
            exports['corrupt']:execute("SELECT points FROM corrupt_bans_offenses", function(f10points)
                if f10points and #f10points > 0 then
                    for _, offense in ipairs(f10points) do
                        f10pointsremoved = f10pointsremoved + offense.points
                    end
                    exports['corrupt']:execute("DELETE FROM corrupt_bans_offenses")
                end
                exports['corrupt']:execute("DELETE FROM corrupt_srv_data")
                exports['corrupt']:execute("UPDATE corrupt_user_data SET dvalue = JSON_REMOVE(JSON_REMOVE(dvalue, '$.weapons'), '$.inventory') WHERE dkey = 'CORRUPT:datatable'")

                CORRUPT.sendWebhook('new-month', 'Boot wipe is complete', "**Boots Wiped:** "..bootscleared.."\n**Players Wiped:** "..playersCleared.."\n**F10 Points Removed:** "..f10pointsremoved, true)
            end)
        end)
    end)
end