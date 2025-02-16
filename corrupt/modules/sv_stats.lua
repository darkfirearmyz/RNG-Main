-- Client  Event To Send The Data
-- CORRUPTUI:setStatistics (stats, userId, statsCount)
MySQL.createCommand("CORRUPT/setusername_stats_month", "UPDATE `corrupt_users_stats_month` SET `name` = @name WHERE `user_id` = @user_id")
MySQL.createCommand("CORRUPT/setusername_stats_all", "UPDATE `corrupt_users_stats_all` SET `name` = @name WHERE `user_id` = @user_id")




AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        local name = CORRUPT.getPlayerName(source)
        local playtime = CORRUPT.GetPlayTime(user_id)
        local ThisMonth = {}
        local AllTime = {}
        local checkeduseridmonth = {}
        local checkeduseridall = {}
        
        exports['corrupt']:execute("SELECT * FROM `corrupt_users_stats_month` WHERE `user_id` = @user_id", {['@user_id'] = user_id}, function(result_month)
            if not next(result_month) then
                exports['corrupt']:execute("INSERT INTO `corrupt_users_stats_month` (user_id, name) VALUES (@user_id, @name)", {['@user_id'] = user_id, ['@name'] = name}, function()
                    FetchAllTimeData()
                end)
            else
                exports['corrupt']:execute("UPDATE `corrupt_users_stats_month` SET `name` = @name WHERE `user_id` = @user_id", {['@name'] = name, ['@user_id'] = user_id})
                FetchAllTimeData()
            end
        end)

        function FetchAllTimeData()
            exports['corrupt']:execute("SELECT * FROM `corrupt_users_stats_all` WHERE `user_id` = @user_id", {['@user_id'] = user_id}, function(result_all)
                if not next(result_all) then
                    exports['corrupt']:execute("INSERT INTO `corrupt_users_stats_all` (user_id, playtime, name) VALUES (@user_id, @playtime, @name)", {['@user_id'] = user_id, ['@playtime'] = playtime, ['@name'] = name}, function()
                        FetchData()
                    end)
                else
                    exports['corrupt']:execute("UPDATE `corrupt_users_stats_all` SET `name` = @name WHERE `user_id` = @user_id", {['@name'] = name, ['@user_id'] = user_id})
                    FetchData()
                end
            end)
        end

        function FetchData()
            exports['corrupt']:execute("SELECT * FROM `corrupt_users_stats_month`", function(result_month)
                if next(result_month) then
                    for k, v in pairs(result_month) do
                        if not checkeduseridmonth[v.user_id] then
                            table.insert(ThisMonth, v)
                            checkeduseridmonth[v.user_id] = true
                        end
                    end
                end
            end)
            exports['corrupt']:execute("SELECT * FROM `corrupt_users_stats_all`", function(result_all)
                if next(result_all) then
                    for k, v in pairs(result_all) do
                        if not checkeduseridall[v.user_id] then
                            table.insert(AllTime, v)
                            checkeduseridall[v.user_id] = true
                        end
                    end
                end
            end)
            Wait(1000)
            TriggerClientEvent("CORRUPT:Stats:FullData", source, ThisMonth, AllTime)
        end
    end
end)


AddEventHandler("playerDropped", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local SessionPlayTime = CORRUPT.SessionPlayTime(user_id)
    local SessionPlayTimeInHours = math.floor(SessionPlayTime/60)
    exports['corrupt']:execute("UPDATE `corrupt_users_stats_month` SET `playtime` = `playtime` + @playtime WHERE `user_id` = @user_id", {['@playtime'] = SessionPlayTimeInHours, ['@user_id'] = user_id})
end)

-- function for adding certain stats to the database
function CORRUPT.AddStats(stats, user_id, amount)
    exports['corrupt']:execute("UPDATE `corrupt_users_stats_month` SET `"..stats.."` = `"..stats.."` + @amount WHERE `user_id` = @user_id", {['@amount'] = amount, ['@user_id'] = user_id})
    exports['corrupt']:execute("UPDATE `corrupt_users_stats_all` SET `"..stats.."` = `"..stats.."` + @amount WHERE `user_id` = @user_id", {['@amount'] = amount, ['@user_id'] = user_id})
end
-- List Of All Stats
-- arrests
-- searches
-- amount_fined
-- money_seized
-- revives
-- bodybagged
-- kills
-- deaths
-- amount_robbed
-- jailed_time
-- playtime
-- weed_sales
-- cocaine_sales
-- meth_sales
-- heroin_sales
-- lsd_sales
-- copper_sales
-- limestone_sales
-- gold_sales
-- diamond_sales
-- fish_sales






Citizen.CreateThread(function()
    Wait(2500)
    exports['corrupt']:execute([[
    CREATE TABLE IF NOT EXISTS `corrupt_users_stats_month` (
        user_id INTEGER,
        name TEXT NOT NULL DEFAULT "N/A",
        `arrests` bigint NOT NULL DEFAULT 0,
        `searches` bigint NOT NULL DEFAULT 0,
        `amount_fined` bigint NOT NULL DEFAULT 0,
        `money_seized` bigint NOT NULL DEFAULT 0,
        `revives` bigint NOT NULL DEFAULT 0,
        `bodybagged` bigint NOT NULL DEFAULT 0,
        `kills` bigint NOT NULL DEFAULT 0,
        `deaths` bigint NOT NULL DEFAULT 0,
        `amount_robbed` bigint NOT NULL DEFAULT 0,
        `jailed_time` bigint NOT NULL DEFAULT 0,
        `playtime` bigint NOT NULL DEFAULT 0,
        `weed_sales` bigint NOT NULL DEFAULT 0,
        `cocaine_sales` bigint NOT NULL DEFAULT 0,
        `meth_sales` bigint NOT NULL DEFAULT 0,
        `heroin_sales` bigint NOT NULL DEFAULT 0,
        `lsd_sales` bigint NOT NULL DEFAULT 0,
        `copper_sales` bigint NOT NULL DEFAULT 0,
        `limestone_sales` bigint NOT NULL DEFAULT 0,
        `gold_sales` bigint NOT NULL DEFAULT 0,
        `diamond_sales` bigint NOT NULL DEFAULT 0,
        `fish_sales` bigint NOT NULL DEFAULT 0,
        PRIMARY KEY (`user_id`)
    );]])
    exports['corrupt']:execute([[
    CREATE TABLE IF NOT EXISTS `corrupt_users_stats_all` (
        user_id INTEGER,
        name TEXT NOT NULL DEFAULT "N/A",
        `arrests` bigint NOT NULL DEFAULT 0,
        `searches` bigint NOT NULL DEFAULT 0,
        `amount_fined` bigint NOT NULL DEFAULT 0,
        `money_seized` bigint NOT NULL DEFAULT 0,
        `revives` bigint NOT NULL DEFAULT 0,
        `bodybagged` bigint NOT NULL DEFAULT 0,
        `kills` bigint NOT NULL DEFAULT 0,
        `deaths` bigint NOT NULL DEFAULT 0,
        `amount_robbed` bigint NOT NULL DEFAULT 0,
        `jailed_time` bigint NOT NULL DEFAULT 0,
        `playtime` bigint NOT NULL DEFAULT 0,
        `weed_sales` bigint NOT NULL DEFAULT 0,
        `cocaine_sales` bigint NOT NULL DEFAULT 0,
        `meth_sales` bigint NOT NULL DEFAULT 0,
        `heroin_sales` bigint NOT NULL DEFAULT 0,
        `lsd_sales` bigint NOT NULL DEFAULT 0,
        `copper_sales` bigint NOT NULL DEFAULT 0,
        `limestone_sales` bigint NOT NULL DEFAULT 0,
        `gold_sales` bigint NOT NULL DEFAULT 0,
        `diamond_sales` bigint NOT NULL DEFAULT 0,
        `fish_sales` bigint NOT NULL DEFAULT 0,
        PRIMARY KEY (`user_id`)
    );]])
end)