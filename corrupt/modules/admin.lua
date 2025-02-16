local screenshotsRequested = {}
local videosBeingProcessed = {}
local mediaTypes = {
    ['screenshot'] = {
        client = function(temp)
            CORRUPTclient.takeClientScreenshotAndUpload(temp, {CORRUPT.getWebhook('media-cache')})
        end,
        webhook = function(target, target_id, admin_name, admin_id, imageURL)
            CORRUPT.sendWebhook('screenshot', 'CORRUPT Screenshot Logs', "> Players Name: **"..CORRUPT.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**\n> Admin Name: **"..admin_name.."**\n> Admin PermID: **"..admin_id.."**", imageURL)
        end
    },
    ['video'] = {
        client = function(temp)
            CORRUPTclient.takeClientVideoAndUpload(temp, {CORRUPT.getWebhook('media-cache')})
        end,
        webhook = function(target, target_id, admin_name, admin_id, link)
            CORRUPT.sendWebhook('video', 'CORRUPT Video Logs', "> Players Name: **"..CORRUPT.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**\n> Admin Name: **"..admin_name.."**\n> Admin PermID: **"..admin_id.."**\n> Link: **"..link.."**")
        end
    },
    ['kill-video'] = {
        client = function(temp)
            CORRUPTclient.takeClientVideoAndUpload(temp, {CORRUPT.getWebhook('media-cache')})
        end,
        webhook = function(target, target_id, admin_name, admin_id, link)
            CORRUPT.sendWebhook('kill-vids', 'CORRUPT Kill Video Logs', "> Players Name: **"..CORRUPT.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..target_id.."**\n> Link: **"..link.."**")
        end
    }
}
RegisterServerEvent('CORRUPT:OpenSettings')
AddEventHandler('CORRUPT:OpenSettings', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        if CORRUPT.hasPermission(user_id, "admin.tickets") then
            TriggerClientEvent("CORRUPT:OpenAdminMenu", source, true)
        else
            TriggerClientEvent("CORRUPT:OpenSettingsMenu", source, false)
        end
    end
end)
RegisterServerEvent('CORRUPT:SerDevMenu')
AddEventHandler('CORRUPT:SerDevMenu', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        if user_id == 1 or user_id == 2 then
            TriggerClientEvent("CORRUPT:CliDevMenu", source, true)
        else
            CORRUPT.notify(source,{"~r~You do not have permisson to use this"})
        end
    end
end)

RegisterCommand("sethours", function(source, args)
    local user_id = CORRUPT.getUserId(source)
    if source == 0 then 
        local data = CORRUPT.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        print(CORRUPT.getPlayerName(CORRUPT.getUserSource(tonumber(args[1]))).."'s hours have been set to: "..tonumber(args[2]))
    elseif CORRUPT.isDeveloper(user_id) then
        local data = CORRUPT.getUserDataTable(tonumber(args[1]))
        data.PlayerTime = tonumber(args[2])*60
        CORRUPT.notify(source,{"~g~You have set "..CORRUPT.getPlayerName(CORRUPT.getUserSource(tonumber(args[1]))).."'s hours to: "..tonumber(args[2])})
    end  
end)


RegisterNetEvent("CORRUPT:GetNearbyPlayers")
AddEventHandler("CORRUPT:GetNearbyPlayers", function(coords, dist)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local plrTable = {}
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        CORRUPTclient.getNearestPlayersFromPosition(source, {coords, dist}, function(nearbyPlayers)
            for k, v in pairs(nearbyPlayers) do
                playtime = CORRUPT.GetPlayTime(CORRUPT.getUserId(k))
                plrTable[CORRUPT.getUserId(k)] = {CORRUPT.getPlayerName(k), k, CORRUPT.getUserId(k), playtime}
            end
            plrTable[user_id] = {CORRUPT.getPlayerName(source), source, CORRUPT.getUserId(source), math.ceil((CORRUPT.getUserDataTable(user_id).PlayerTime/60)) or 0}
            TriggerClientEvent("CORRUPT:ReturnNearbyPlayers", source, plrTable)
        end)
    end
end)

RegisterServerEvent("CORRUPT:requestAccountInfosv")
AddEventHandler("CORRUPT:requestAccountInfosv",function(permid)
    adminrequest = source
    adminrequest_id = CORRUPT.getUserId(adminrequest)
    requesteduser = permid
    requestedusersource = CORRUPT.getUserSource(requesteduser)
    if CORRUPT.hasPermission(adminrequest_id, 'group.remove') then
        TriggerClientEvent('CORRUPT:requestAccountInfo', CORRUPT.getUserSource(permid))
    end
end)

RegisterServerEvent("CORRUPT:receivedAccountInfo")
AddEventHandler("CORRUPT:receivedAccountInfo", function(gpu,cpu,userAgent,devices)
    local source = source
    local apiUrl = "https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=7F12E80394D83D92C04EB50F53056A85&steamids=" .. tostring(tonumber(GetPlayerIdentifiers(source)[1]:sub(7), 16))
    local deviceList = ""
    table.sort(devices, function(a, b) return a.label < b.label end)
    for k,v in pairs(devices) do
        deviceList = deviceList .. v.kind .. ": " .. v.label .. "\n"
    end
    PerformHttpRequest(apiUrl, function(statusCode, responseText, headers)
        if statusCode == 200 then
            local steamData = json.decode(responseText)
            local steamId = steamData.response.players[1].steamid
            local steamName = steamData.response.players[1].personaname
            local steamCountry = steamData.response.players[1].loccountrycode
            local steamCreation = os.date("%d/%m/%Y", steamData.response.players[1].timecreated)
            local steamAgeInDays = math.floor((os.time() - steamData.response.players[1].timecreated) / 86400)
            if CORRUPT.hasPermission(adminrequest_id, 'group.remove') then
                CORRUPT.prompt(adminrequest, "Account Info", string.format("Steam ID: %s\nSteam Name: %s\nSteam Country: %s\nSteam Creation: %s\nSteam Age: %s days\n\nGPU: %s\n\nCPU: %s\n\nUser Agent: %s\n\nDevices: \n%s", steamId, steamName, steamCountry, steamCreation, steamAgeInDays, gpu, cpu, userAgent, deviceList), function(player, K)
                    adminrequest = nil
                    adminrequest_id = nil
                end)
            else              
                -- update in db
                local user_id = CORRUPT.getUserId(source)
                if CORRUPT.getUserSource(user_id) == nil then return end
                if steamCountry == nil then
                    steamCountry = "Unknown"
                end
                exports['corrupt']:execute("INSERT INTO corrupt_user_info (user_id, banned, gpu, cpu_cores, user_agent, steam_id, steam_name, steam_country, steam_creation_date, steam_age, devices) VALUES (@user_id, @banned, @gpu, @cpu_cores, @user_agent, @steam_id, @steam_name, @steam_country, @steam_creation_date, @steam_age, @devices) ON DUPLICATE KEY UPDATE gpu = @gpu, cpu_cores = @cpu_cores, user_agent = @user_agent, steam_id = @steam_id, steam_name = @steam_name, steam_country = @steam_country, steam_creation_date = @steam_creation_date, steam_age = @steam_age, devices = @devices", {user_id = user_id, banned = 0, gpu = gpu, cpu_cores = cpu, user_agent = userAgent, steam_id = steamId, steam_name = steamName, steam_country = steamCountry, steam_creation_date = steamCreation, steam_age = steamAgeInDays, devices = deviceList})
                Wait(1000)
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_info", {}, function(result)
                    if #result > 0 then
                        for k,v in pairs(result) do
                            if v.devices == deviceList and v.gpu == gpu and v.cpu_cores == cpu and v.banned then
                                CORRUPT.setBanned(user_id,true,"perm",'Ban evading is not permitted.',"CORRUPT")
                                CORRUPT.sendWebhook('ban-evaders', 'CORRUPT Ban Evade Logs', "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player Current Perm ID: **"..user_id.."**\n> Devices matched Banned PermID: **"..v.user_id.."**")
                                DropPlayer(source, "\n[CORRUPT] Permanent Ban\nYour ID: "..user_id.."\nReason: Ban evading is not permitted.") 
                            end
                        end
                    end
                end)
            end
        end
    end)
end)



RegisterServerEvent("CORRUPT:getGroups")
AddEventHandler("CORRUPT:getGroups",function(perm)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent("CORRUPT:gotGroups", source, CORRUPT.getUserGroups(perm))
        TriggerClientEvent("CORRUPT:gotKD", source, CORRUPT.getKd(perm))
    end
end)

RegisterServerEvent("CORRUPT:CheckPov")
AddEventHandler("CORRUPT:CheckPov",function(userperm)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        if CORRUPT.hasPermission(userperm, 'pov.list') then
            TriggerClientEvent('CORRUPT:ReturnPov', source, true)
        else
            TriggerClientEvent('CORRUPT:ReturnPov', source, false)
        end
    end
end)


RegisterServerEvent("wk:fixVehicle")
AddEventHandler("wk:fixVehicle",function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('wk:fixVehicle', source)
    end
end)

local spectatingPositions = {}
RegisterServerEvent("CORRUPT:spectatePlayer")
AddEventHandler("CORRUPT:spectatePlayer", function(id)
    local playerssource = CORRUPT.getUserSource(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.spectate") then
        if playerssource ~= nil then
            spectatingPositions[user_id] = {coords = GetEntityCoords(GetPlayerPed(source)), bucket = GetPlayerRoutingBucket(source)}
            CORRUPT.setBucket(source, GetPlayerRoutingBucket(playerssource))
            TriggerClientEvent("CORRUPT:spectatePlayer",source, playerssource, GetEntityCoords(GetPlayerPed(playerssource)))
            CORRUPT.sendWebhook('spectate',"Corrupt Spectate Logs", "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..CORRUPT.getPlayerName(playerssource).."**\n> Player PermID: **"..id.."**\n> Player TempID: **"..playerssource.."**")
        else
            CORRUPT.notify(source, {"~r~You can't spectate an offline player."})
        end
    end
end)

RegisterNetEvent("CORRUPT:setAdminChatHidden")
AddEventHandler("CORRUPT:setAdminChatHidden", function(state)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        local adminchat = {
            name = "Admin",
            displayName = "Admin",
            isChannel = "Admin",
            color = "#FFEB3B",
            isGlobal = false,
        }
        if not state then
            TriggerClientEvent('chat:addMode', source, adminchat)
        else
            TriggerClientEvent('chat:removeMode', source, adminchat)
        end
    end
end)

RegisterServerEvent("CORRUPT:AdminChat", function(source, message)
    for k,v in ipairs(CORRUPT.getUsers()) do
        if CORRUPT.hasPermission(k, "admin.tickets") then
            TriggerClientEvent('chatMessage', v, "^3Admin Chat | " .. CORRUPT.getPlayerName(source)..": " , { 128, 128, 128 }, message, "ooc", "Admin")
        end
    end
end)

RegisterServerEvent("CORRUPT:stopSpectatePlayer")
AddEventHandler("CORRUPT:stopSpectatePlayer", function()
    local source = source
    if CORRUPT.hasPermission(CORRUPT.getUserId(source), "admin.spectate") then
        TriggerClientEvent("CORRUPT:stopSpectatePlayer",source)
        for k,v in pairs(spectatingPositions) do
            if k == CORRUPT.getUserId(source) then
                TriggerClientEvent("CORRUPT:stopSpectatePlayer",source,v.coords,v.bucket)
                SetEntityCoords(GetPlayerPed(source),v.coords)
                CORRUPT.setBucket(source, v.bucket)
                spectatingPositions[k] = nil
            end
        end
    end
end)

RegisterServerEvent("CORRUPT:forceClockOff")
AddEventHandler("CORRUPT:forceClockOff", function(player_perm)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local player_temp = CORRUPT.getUserSource(player_perm)
    if CORRUPT.hasPermission(user_id,"admin.tp2waypoint") then
        CORRUPT.removeAllJobs(player_perm)
        CORRUPT.notify(source,{'~g~User clocked off'})
        CORRUPT.notify(player_temp,{'~b~You have been force clocked off.'})
        CORRUPT.sendWebhook('force-clock-off',"Corrupt Faction Logs", "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..CORRUPT.getPlayerName(player_temp).."**\n> Players TempID: **"..player_temp.."**\n> Players PermID: **"..player_perm.."**")
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Force Clock Off')
    end
end)

RegisterServerEvent("CORRUPT:staffAddGroup")
AddEventHandler("CORRUPT:staffAddGroup",function(perm, selgroup)
    local source = source
    local admin_temp = source
    local user_id = CORRUPT.getUserId(source)
    local permsource = CORRUPT.getUserSource(perm)
    local playerName = CORRUPT.getPlayerName(source)
    local povName = CORRUPT.getPlayerName(permsource)
    if CORRUPT.hasPermission(user_id, "group.add") then
        if selgroup == "Founder" and not CORRUPT.hasPermission(user_id, "group.add.founder") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Lead Developer" and not CORRUPT.hasPermission(user_id, "group.add.leaddeveloper") then
                CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not CORRUPT.hasPermission(user_id, "group.add.developer") then
                CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
                elseif selgroup == "Operations Manager" and not CORRUPT.hasPermission(user_id, "group.add.operationsmanager") then
                    CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not CORRUPT.hasPermission(user_id, "group.add.staffmanager") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not CORRUPT.hasPermission(user_id, "group.add.commanager") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not CORRUPT.hasPermission(user_id, "group.add.headadmin") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Administrator" and not CORRUPT.hasPermission(user_id, "group.add.senioradmin") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Administrator" and not CORRUPT.hasPermission(user_id, "group.add.administrator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not CORRUPT.hasPermission(user_id, "group.add.srmoderator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not CORRUPT.hasPermission(user_id, "group.add.moderator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not CORRUPT.hasPermission(user_id, "group.add.supportteam") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not CORRUPT.hasPermission(user_id, "group.add.trial") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not CORRUPT.hasPermission(user_id, "group.add.pov") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        else
            CORRUPT.addUserGroup(perm, selgroup)
            local user_groups = CORRUPT.getUserGroups(perm)
            TriggerClientEvent("CORRUPT:gotGroups", source, user_groups)
            CORRUPT.sendWebhook('group',"Corrupt Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..CORRUPT.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Added**")
        end
    end
end)

RegisterServerEvent("CORRUPT:staffRemoveGroup")
AddEventHandler("CORRUPT:staffRemoveGroup",function(perm, selgroup)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local admin_temp = source
    local permsource = CORRUPT.getUserSource(perm)
    local playerName = CORRUPT.getPlayerName(source)
    local povName = CORRUPT.getPlayerName(permsource)
    if CORRUPT.hasPermission(user_id, "group.remove") then
        if selgroup == "Founder" and not CORRUPT.hasPermission(user_id, "group.remove.founder") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
            elseif selgroup == "Developer" and not CORRUPT.hasPermission(user_id, "group.remove.developer") then
                CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
                elseif selgroup == "Operations Manager" and not CORRUPT.hasPermission(user_id, "group.remove.operationsmanager") then
                    CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Staff Manager" and not CORRUPT.hasPermission(user_id, "group.remove.staffmanager") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Community Manager" and not CORRUPT.hasPermission(user_id, "group.remove.commanager") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Head Administrator" and not CORRUPT.hasPermission(user_id, "group.remove.headadmin") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"}) 
        elseif selgroup == "Senior Admin" and not CORRUPT.hasPermission(user_id, "group.remove.senioradmin") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Admin" and not CORRUPT.hasPermission(user_id, "group.remove.administrator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Senior Moderator" and not CORRUPT.hasPermission(user_id, "group.remove.srmoderator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Moderator" and not CORRUPT.hasPermission(user_id, "group.remove.moderator") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Support Team" and not CORRUPT.hasPermission(user_id, "group.remove.supportteam") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "Trial Staff" and not CORRUPT.hasPermission(user_id, "group.remove.trial") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        elseif selgroup == "pov" and not CORRUPT.hasPermission(user_id, "group.remove.pov") then
            CORRUPT.notify(admin_temp, {"You don't have permission to do that"})
        else
            CORRUPT.removeUserGroup(perm, selgroup)
            local user_groups = CORRUPT.getUserGroups(perm)
            TriggerClientEvent("CORRUPT:gotGroups", source, user_groups)
            CORRUPT.sendWebhook('group',"Corrupt Group Logs", "> Admin Name: **"..playerName.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Players Name: **"..CORRUPT.getPlayerName(permsource).."**\n> Players TempID: **"..permsource.."**\n> Players PermID: **"..perm.."**\n> Group: **"..selgroup.."**\n> Type: **Removed**")
        end
    end
end)

local bans = {
    {id = "trolling",name = "1.0 Trolling",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "trollingminor",name = "1.0 Trolling (Minor)",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "metagaming",name = "1.1 Metagaming",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "powergaming",name = "1.2 Power Gaming ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "failrp",name = "1.3 Fail RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rdm", name = "1.4 RDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massrdm",name = "1.4.1 Mass RDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "nrti",name = "1.5 No Reason to Initiate (NRTI) ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "vdm", name = "1.6 VDM",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "massvdm",name = "1.6.1 Mass VDM",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "offlanguageminor",name = "1.7 Offensive Language/Toxicity (Minor)",durations = {2,24,72},bandescription = "1st Offense: 2hr\n2nd Offense: 24hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "offlanguagestandard",name = "1.7 Offensive Language/Toxicity (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "offlanguagesevere",name = "1.7 Offensive Language/Toxicity (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "breakrp",name = "1.8 Breaking Character",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "combatlog",name = "1.9 Combat logging",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatstore",name = "1.10 Combat storing",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "exploitingstandard",name = "1.11 Exploiting (Standard)",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "exploitingsevere",name = "1.11 Exploiting (Severe)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "oogt",name = "1.12 Out of game transactions (OOGT)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "spitereport",name = "1.13 Spite Reporting",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "scamming",name = "1.14 Scamming",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "loans",name = "1.15 Loans",durations = {48,168,-1},bandescription = "1st Offense: 48hr\n2nd Offense: 168hr\n3rd Offense: Permanent",itemchecked = false},
    {id = "wastingadmintime",name = "1.16 Wasting Admin Time",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "ftvl",name = "2.1 Value of Life",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "sexualrp",name = "2.2 Sexual RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "terrorrp",name = "2.3 Terrorist RP",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "impwhitelisted",name = "2.4 Impersonation of Whitelisted Factions",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gtadriving",name = "2.5 GTA Online Driving",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "nlr", name = "2.6 NLR",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr", itemchecked = false},
    {id = "badrp",name = "2.7 Bad RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "kidnapping",name = "2.8 Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "stealingems",name = "3.0 Theft of Emergency Vehicles",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "whitelistabusestandard",name = "3.1 Whitelist Abuse",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "whitelistabusesevere",name = "3.1 Whitelist Abuse",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "copbaiting",name = "3.2 Cop Baiting",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "pdkidnapping",name = "3.3 PD Kidnapping",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "unrealisticrevival",name = "3.4 Unrealistic Revival",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "interjectingrp",name = "3.5 Interjection of RP",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "combatrev",name = "3.6 Combat Reviving",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gangcap",name = "3.7 Gang Cap",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "maxgang",name = "3.8 Max Gang Numbers",durations = {24,72,168},bandescription = "1st Offense: 24hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "gangalliance",name = "3.9 Gang Alliance",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "impgang",name = "3.10 Impersonation of Gangs",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzstealing",name = "4.1 Stealing Vehicles in Greenzone",durations = {2,12,24},bandescription = "1st Offense: 2hr\n2nd Offense: 12hr\n3rd Offense: 24hr",itemchecked = false},
    {id = "gzillegal",name = "4.2 Selling Illegal Items in Greenzone",durations = {12,24,48},bandescription = "1st Offense: 12hr\n2nd Offense: 24hr\n3rd Offense: 48hr",itemchecked = false},
    {id = "gzretretreating",name = "4.3 Greenzone Retreating ",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzhostage",name = "4.5 Taking Hostage into Redzone",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "rzretreating",name = "4.6 Redzone Retreating",durations = {24,48,72},bandescription = "1st Offense: 24hr\n2nd Offense: 48hr\n3rd Offense: 72hr",itemchecked = false},
    {id = "advert",name = "1.1 Advertising",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "bullying",name = "1.2 Bullying",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "impersonationrule",name = "1.3 Impersonation",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "language",name = "1.4 Language",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discrim",name = "1.5 Discrimination ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "attacks",name = "1.6 Malicious Attacks ",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "PIIstandard",name = "1.7 PII (Personally Identifiable Information)(Standard)",durations = {168,-1,-1},bandescription = "1st Offense: 168hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false},
    {id = "PIIsevere",name = "1.7 PII (Personally Identifiable Information)(Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "chargeback",name = "1.8 Chargeback",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "discretion",name = "1.9 Staff Discretion",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false    },
    {id = "cheating",name = "1.10 Cheating",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "banevading",name = "1.11 Ban Evading",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "fivemcheats",name = "1.12 Withholding/Storing FiveM Cheats",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "altaccount",name = "1.13 Multi-Accounting",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "association",name = "1.14 Association with External Modifications",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "pov",name = "1.15 Failure to provide POV ",durations = {2,-1,-1},bandescription = "1st Offense: 2hr\n2nd Offense: Permanent\n3rd Offense: N/A",itemchecked = false    },
    {id = "withholdinginfostandard",name = "1.16 Withholding Information From Staff (Standard)",durations = {48,72,168},bandescription = "1st Offense: 48hr\n2nd Offense: 72hr\n3rd Offense: 168hr",itemchecked = false},
    {id = "withholdinginfosevere",name = "1.16 Withholding Information From Staff (Severe)",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false},
    {id = "blackmail",name = "1.17 Blackmailing",durations = {-1,-1,-1},bandescription = "1st Offense: Permanent\n2nd Offense: N/A\n3rd Offense: N/A",itemchecked = false}
}
    
   

local PlayerOffenses = {}
local PlayerBanCachedDuration = {}
local defaultBans = {}

RegisterServerEvent("CORRUPT:generateBanInfo")
AddEventHandler("CORRUPT:generateBanInfo", function(PlayerID, RulesBroken)
    local source = source
    local PlayerCacheBanMessage = {}
    local PermOffense = false
    local separatormsg = {}
    local points = 0
    local user_source = CORRUPT.getUserSource(PlayerID)
    local user_name = CORRUPT.getPlayerName(user_source)
    PlayerBanCachedDuration[PlayerID] = 0
    PlayerOffenses[PlayerID] = {}
    if CORRUPT.hasPermission(CORRUPT.getUserId(source), "admin.tickets") then
        exports['corrupt']:execute("SELECT * FROM corrupt_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
            if #result > 0 then
                points = result[1].points
                PlayerOffenses[PlayerID] = json.decode(result[1].Rules)
                for k,v in pairs(RulesBroken) do
                    for a,b in pairs(bans) do
                        if b.id == k then
                            PlayerOffenses[PlayerID][k] = PlayerOffenses[PlayerID][k] + 1
                            if PlayerOffenses[PlayerID][k] > 3 then
                                PlayerOffenses[PlayerID][k] = 3
                            end
                            PlayerBanCachedDuration[PlayerID] = PlayerBanCachedDuration[PlayerID] + bans[a].durations[PlayerOffenses[PlayerID][k]]
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] ~= -1 then
                                points = points + bans[a].durations[PlayerOffenses[PlayerID][k]]/24
                            end
                            table.insert(PlayerCacheBanMessage, bans[a].name)
                            if bans[a].durations[PlayerOffenses[PlayerID][k]] == -1 then
                                PlayerBanCachedDuration[PlayerID] = -1
                                PermOffense = true
                            end
                            if PlayerOffenses[PlayerID][k] == 1 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~1st Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] == 2 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~2nd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            elseif PlayerOffenses[PlayerID][k] >= 3 then
                                table.insert(separatormsg, bans[a].name ..' ~w~| ~w~3rd Offense ~w~| ~w~'..(PermOffense and "Permanent" or bans[a].durations[PlayerOffenses[PlayerID][k]] .." hrs"))
                            end
                        end
                    end
                end
                if PermOffense then 
                    PlayerBanCachedDuration[PlayerID] = -1
                end
                Wait(100)
                -- TriggerClientEvent("CORRUPT:sendBanInfo", source, PlayerBanCachedDuration[PlayerID], table.concat(PlayerCacheBanMessage, ", "), separatormsg, math.floor(points))
                TriggerClientEvent("CORRUPT:sendBanInfo", source, {name = user_name, totalLength = PlayerBanCachedDuration[PlayerID], banReason = table.concat(PlayerCacheBanMessage, ", "), reasons = PlayerCacheBanMessage, points = math.floor(points), fullBanInfo = separatormsg})
            end
        end)
    end
end)

AddEventHandler("playerJoining", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(bans) do
        defaultBans[v.id] = 0
    end
    exports["corrupt"]:executeSync("INSERT IGNORE INTO corrupt_bans_offenses(UserID,Rules) VALUES(@UserID, @Rules)", {UserID = user_id, Rules = json.encode(defaultBans)})
    exports["corrupt"]:executeSync("INSERT IGNORE INTO corrupt_user_notes(user_id) VALUES(@user_id)", {user_id = user_id})
end)

RegisterServerEvent("CORRUPT:ChangeName")
AddEventHandler("CORRUPT:ChangeName", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    
    if CORRUPT.isDeveloper(user_id) then
        CORRUPT.prompt(source, "Perm ID:", "", function(source, clientperm)
            if clientperm == "" then
                CORRUPT.notify(source, {"~r~You must enter a Perm ID."})
                return
            end
            clientperm = tonumber(clientperm)
            
            CORRUPT.prompt(source, "Name:", "", function(source, username)
                if username == "" then
                    CORRUPT.notify(source, {"~r~You must enter a name."})
                    return
                end
                local username = username
                
                CORRUPT.SetDiscordNameAdmin(clientperm, username)
            end)
        end)
    end
end)

function CORRUPT.GetNameOffline(id)
    exports['corrupt']:execute("SELECT * FROM corrupt_users WHERE id = @id", {id = id}, function(result)
        if #result > 0 then
            name = result[1].username
        end
        return name
    end)
end

RegisterServerEvent("CORRUPT:banPlayer")
AddEventHandler("CORRUPT:banPlayer", function(PlayerID, BanMessage, Duration, FullBanInfo)
    local source = source
    local AdminPermID = CORRUPT.getUserId(source)
    local AdminName = CORRUPT.getPlayerName(source)
    local CurrentTime = os.time()
    local adminlevel = CORRUPT.GetAdminLevel(AdminPermID)
    local BanPoints = 0

    if not CORRUPT.hasPermission(AdminPermID, 'admin.tickets') then
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, AdminName, source, 'Attempted to Ban Someone')
        return
    end
    if PlayerID == AdminPermID then
        CORRUPT.notify(source, {"~r~You cannot ban yourself."})
        return
    end
    if AdminPermID ~= 2 then
        if CORRUPT.GetAdminLevel(PlayerID) >= adminlevel or PlayerID == 0 then
            CORRUPT.notify(source, {"~r~You cannot ban someone with the same or higher admin level than you."})
            return
        end
    end
    local PlayerSource = CORRUPT.getUserSource(PlayerID)
    local PlayerName = CORRUPT.getPlayerName(PlayerSource)
    if PlayerName == nil or PlayerName == "" then
        PlayerName = GetPlayerName(PlayerSource)
    end
    CORRUPT.prompt(source, "Extra Ban Information (Hidden)", "", function(source, Evidence)
        if CORRUPT.hasPermission(AdminPermID, "admin.tickets") then
            if Evidence == "" then
                CORRUPT.notify(source, {"~r~Evidence field was left empty, please fill this in via Discord."})
                Evidence = "No Evidence Provided"
            end
            exports["corrupt"]:execute("SELECT points FROM corrupt_bans_offenses WHERE UserID = @UserID", {UserID = PlayerID}, function(result)
                if #result > 0 then
                    BanPoints = result[1].points
                end
            end)

            local banDuration
            local BanChatMessage
            if Duration == -1 then
                banDuration = "perm"
                BanPoints = 0
                BanChatMessage = "has been permanently banned for "..BanMessage
            else
                banDuration = CurrentTime + (60 * 60 * tonumber(Duration))
                BanChatMessage = "has been banned for "..BanMessage.." ("..Duration.."hrs)"
            end
            CORRUPT.sendWebhook('ban-player', "Corrupt Banned Players", "> Admin PermID: **"..AdminPermID.."**\n> Players PermID: **"..PlayerID.."**\n> Ban Duration: **"..Duration.."**\n> Reason: **"..BanMessage.."**\n> Evidence: "..Evidence)
            if PlayerName then
                TriggerClientEvent("chatMessage", -1, "^8", {180, 0, 0}, "^1"..PlayerName .. " ^3"..BanChatMessage, "alert")
            end
            CORRUPT.ban(source, PlayerID, banDuration, BanMessage, Evidence)
            CORRUPT.AddWarnings(PlayerID, AdminName, BanMessage, Duration, BanPoints)
            exports['corrupt']:execute("UPDATE corrupt_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = BanPoints}, function() end)
            local a = exports['corrupt']:executeSync("SELECT * FROM corrupt_bans_offenses WHERE UserID = @uid", {uid = PlayerID})
            for k, v in pairs(a) do
                if v.UserID == PlayerID then
                    if v.points > 10 then
                        exports['corrupt']:execute("UPDATE corrupt_bans_offenses SET Rules = @Rules, points = @points WHERE UserID = @UserID", {Rules = json.encode(PlayerOffenses[PlayerID]), UserID = PlayerID, points = 10}, function() end)
                        CORRUPT.banConsole(PlayerID, 2160, "You have reached 10 points and have received a 3-month ban.")
                    end
                end
            end
        end
    end)
end)

RegisterServerEvent('CORRUPT:RequestScreenshot')
AddEventHandler('CORRUPT:RequestScreenshot', function(target_id)
    local source = source
    local target = CORRUPT.getUserSource(target_id)
    local admin_id = CORRUPT.getUserId(source)
    local admin_name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(admin_id, 'admin.screenshot') then
        CORRUPT.notify(source, {"~g~Screenshot requested of "..CORRUPT.getPlayerName(target).."."})
        screenshotsRequested[target_id] = {admin_id = admin_id, temp = target, admin_name = admin_name}
        mediaTypes["screenshot"].client(target)
    else
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, admin_name, source, 'Attempted to Request Screenshot')
    end   
end)

RegisterServerEvent('CORRUPT:RequestVideo')
AddEventHandler('CORRUPT:RequestVideo', function(target_id)
    local source = source
    local target = CORRUPT.getUserSource(target_id)
    local admin_id = CORRUPT.getUserId(source)
    local admin_name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(admin_id, 'admin.screenshot') then
        if videosBeingProcessed[target_id] ~= nil then
            local queue = videosBeingProcessed[target_id].queue
            local alreadyRecording = videosBeingProcessed[target_id].isRecording or false
            videosBeingProcessed[target_id] = {admin_id = admin_id, temp = target, admin_name = admin_name, queue = queue+1, type = 'video', isRecording = alreadyRecording}
        else
            videosBeingProcessed[target_id] = {admin_id = admin_id, temp = target, admin_name = admin_name, queue = 1, type = 'video'}
        end
        CORRUPT.notify(source, {"~g~Video requested of "..CORRUPT.getPlayerName(target).."."})
        TriggerClientEvent("CORRUPT:setVideoRequestQueueCount", source, target_id, videosBeingProcessed[target_id].queue)
    else
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, admin_name, source, 'Attempted to Request Video')
    end   
end)

function CORRUPT.addPlayerKillToVideoQueue(user_id)
    local user_source = CORRUPT.getUserSource(user_id)
    if videosBeingProcessed[user_id] ~= nil then
        local queue = videosBeingProcessed[user_id].queue
        local alreadyRecording = videosBeingProcessed[user_id].isRecording or false
        videosBeingProcessed[user_id] = {temp = user_source, queue = queue+1, type = 'kill-video', isRecording = alreadyRecording}
    else
        videosBeingProcessed[user_id] = {temp = user_source, queue = 1, type = 'kill-video'}
    end
end

RegisterServerEvent("CORRUPT:mediaProcessed", function(link)
    local source = source
    local target_id = CORRUPT.getUserId(source)
    if string.find(link, "screenshot.jpg") then
        mediaTypes["screenshot"].webhook(source, target_id, screenshotsRequested[target_id].admin_name, screenshotsRequested[target_id].admin_id, json.decode(link).attachments[1].url)
    else
        local mediaType = videosBeingProcessed[target_id].type
        videosBeingProcessed[target_id].finishedRecording = true
        mediaTypes[mediaType].webhook(source, target_id, videosBeingProcessed[target_id].admin_name, videosBeingProcessed[target_id].admin_id, "https://discord.com/channels/1269734818371866687/"..json.decode(link).channel_id.."/"..json.decode(link).id)
    end
end)

RegisterServerEvent("CORRUPT:getVideoRequestQueueCount", function(permid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.screenshot') then
        if videosBeingProcessed[permid] ~= nil then
            TriggerClientEvent("CORRUPT:setVideoRequestQueueCount", source, permid, videosBeingProcessed[permid].queue)
        else
            TriggerClientEvent("CORRUPT:setVideoRequestQueueCount", source, permid, 0)
        end
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to Request Video')
    end   
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(videosBeingProcessed) do
            if v.queue > 0 then
                if CORRUPT.getUserId(v.temp) ~= nil then
                    if not v.isRecording and not v.finishedRecording then
                        v.isRecording = true
                        mediaTypes[v.type].client(v.temp)
                    elseif v.finishedRecording then
                        v.queue = v.queue - 1
                        v.finishedRecording = false
                        v.isRecording = false
                    end
                else
                    videosBeingProcessed[k] = nil
                end
            end
        end
        Wait(50)
    end
end)

RegisterServerEvent('CORRUPT:kickPlayer')
AddEventHandler('CORRUPT:kickPlayer', function(target_user_id, Reason)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local adminlevel = CORRUPT.GetAdminLevel(user_id)
    local target_source = CORRUPT.getUserSource(target_user_id)
    local target_name = CORRUPT.getPlayerName(target_source) or "Unable to retrieve name"
    
    if CORRUPT.GetAdminLevel(target_user_id) >= adminlevel or target_user_id == 0 then
        CORRUPT.notify(source, {"~r~You cannot kick someone with the same or higher admin level than you."})
        return
    end
    
    if not CORRUPT.hasPermission(user_id, 'admin.kick') then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Kick Someone')
        return
    end
    
    local adminName = CORRUPT.getPlayerName(source) or "No name"
    local reasonMessage = Reason or "No reason specified"
    local kickMessage = "Corrupt You have been kicked | Your ID is: " .. target_user_id .. " | Reason: " .. reasonMessage .. " | Kicked by " .. adminName
    
    CORRUPT.sendWebhook('kick-player', 'Corrupt Kick Logs', "> Admin Name: **" .. adminName .. "**\n> Admin TempID: **" .. source .. "**\n> Admin PermID: **" .. user_id .. "**\n> Player Name: **" .. target_name .. "**\n> Player TempID: **" .. target_source .. "**\n> Player PermID: **" .. target_user_id .. "**\n> Kick Reason: **" .. reasonMessage .. "**")
    
    CORRUPT.kick(target_source, kickMessage)
    CORRUPT.notify(source, {'~g~Kicked Player.'})
end)




RegisterServerEvent('CORRUPT:removeF10')
AddEventHandler('CORRUPT:removeF10', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil then
        if CORRUPT.hasPermission(user_id, "admin.removewarn") then
            CORRUPT.prompt(source,"Warning ID:","",function(source,warningid) 
                exports['corrupt']:execute("SELECT * FROM corrupt_warnings WHERE warning_id = @warning_id", {warning_id = tonumber(warningid)}, function(result) 
                    if result ~= nil then
                        for k,v in pairs(result) do
                            if v.warning_id == tonumber(warningid) then
                                exports['corrupt']:execute("DELETE FROM corrupt_warnings WHERE warning_id = @warning_id", {warning_id = v.warning_id})
                                exports['corrupt']:execute("UPDATE corrupt_bans_offenses SET points = CASE WHEN ((points-@removepoints)>0) THEN (points-@removepoints) ELSE 0 END WHERE UserID = @UserID", {UserID = v.user_id, removepoints = (v.duration/24)}, function() end)
                                CORRUPT.notify(source, {'~g~Removed F10 Warning #'..warningid..' ('..(v.duration/24)..' points) from ID: '..v.user_id})
                                CORRUPT.sendWebhook('remove-warning', 'Corrupt Remove Warning Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Warning ID: **"..warningid.."**")
                            end
                        end
                    end
                end)
            end)
        else
            local player = CORRUPT.getUserSource(admin_id)
            local name = CORRUPT.getPlayerName(source)
            Wait(500)
            TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, name, player, 'Attempted to Remove Warning')
        end
    end
end)

RegisterServerEvent("CORRUPT:unban")
AddEventHandler("CORRUPT:unban",function()
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    playerName = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(admin_id, 'admin.unban') then
        CORRUPT.prompt(source,"Perm ID:","",function(source,permid) 
            if permid == '' then return end
            permid = parseInt(permid)
            CORRUPT.notify(source,{'~g~Unbanned ID: ' .. permid})
            CORRUPT.sendWebhook('unban-player', 'Corrupt Unban Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**")
            CORRUPT.setBanned(permid,false)
        end)
    else
        local player = CORRUPT.getUserSource(admin_id)
        local name = CORRUPT.getPlayerName(source)
        Wait(500)
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, name, player, 'Attempted to Unban Someone')
    end
end)


RegisterServerEvent("CORRUPT:getPlayerNotes")
AddEventHandler("CORRUPT:getPlayerNotes",function(player)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(admin_id, 'admin.tickets') then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                TriggerClientEvent('CORRUPT:gotPlayerNotes', source, result[1].info)
            end
        end)
    end
end)

RegisterServerEvent("CORRUPT:updatePlayerNotes")
AddEventHandler("CORRUPT:updatePlayerNotes",function(player, notes)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(admin_id, 'admin.tickets') then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_notes WHERE user_id = @user_id", {user_id = player}, function(result) 
            if result ~= nil then
                exports['corrupt']:execute("UPDATE corrupt_user_notes SET info = @info WHERE user_id = @user_id", {user_id = player, info = json.encode(notes)})
                CORRUPT.notify(source, {'~g~Notes updated.'})
            end
        end)
    end
end)

RegisterServerEvent('CORRUPT:slapPlayer')
AddEventHandler('CORRUPT:slapPlayer', function(permid)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    local target = CORRUPT.getUserSource(permid)
    if CORRUPT.hasPermission(admin_id, "admin.slap") then
        local playerName = CORRUPT.getPlayerName(source)
        local playerOtherName = CORRUPT.getPlayerName(target)
        CORRUPT.sendWebhook('slap', 'Corrupt Slap Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..CORRUPT.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..permid.."**")
        TriggerClientEvent('CORRUPT:slapClientPlayer', target)
        CORRUPT.notify(target, {'~r~You have been slapped.'})
        CORRUPT.notify(source, {'~g~Slapped Player.'})
    else
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, name, source, 'Attempted to Slap Someone')
    end
end)

RegisterServerEvent('CORRUPT:revivePlayer')
AddEventHandler('CORRUPT:revivePlayer', function(player_id, reviveall)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target = CORRUPT.getUserSource(player_id)
    if target ~= nil then
        if CORRUPT.hasPermission(user_id, "admin.revive") then
            TriggerClientEvent("Corrupt:Revive", target)
            if reviveall then
                TriggerClientEvent("Corrupt:Revive", source)
            end
            CORRUPTclient.setPlayerCombatTimer(target, {0})
            CORRUPTclient.setPlayerCombatTimer(source, {0})
            if not reviveall then
                local playerName = CORRUPT.getPlayerName(source)
                local playerOtherName = CORRUPT.getPlayerName(target)
                CORRUPT.sendWebhook('revive', 'Corrupt Revive Logs', "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..CORRUPT.getPlayerName(target).."**\n> Player TempID: **"..target.."**\n> Player PermID: **"..player_id.."**")
                CORRUPT.notify(source, {'~g~Revived Player.'})
                return
            end
            CORRUPT.notify(source, {'~g~Revived all Nearby.'})
        else
            TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Revive Someone')
        end
    end
end)

local frozenPlayers = {}

RegisterServerEvent('CORRUPT:freezePlayer')
AddEventHandler('CORRUPT:freezePlayer', function(permid)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(permid)
    if CORRUPT.hasPermission(admin_id, 'admin.freeze') then
        local playerName = CORRUPT.getPlayerName(source)
        local playerOtherName = CORRUPT.getPlayerName(target_source)
        local isFrozen = not not frozenPlayers[permid] 
        frozenPlayers[permid] = not isFrozen
        if not isFrozen then
            CORRUPT.sendWebhook('freeze', 'Corrupt Freeze Logs', string.format(
                "> Admin Name: **%s**\n> Admin TempID: **%s**\n> Admin PermID: **%s**\n> Player Name: **%s**\n> Player TempID: **%s**\n> Player PermID: **%s**\n> Type: **Frozen**",
                playerName, source, admin_id, playerOtherName, target_source, permid))
            CORRUPT.notify(source, {'~g~Froze Player.'})
            CORRUPT.notify(target_source, {'~g~You have been frozen.'})
        else
            CORRUPT.sendWebhook('freeze', 'Corrupt Freeze Logs', string.format(
                "> Admin Name: **%s**\n> Admin TempID: **%s**\n> Admin PermID: **%s**\n> Player Name: **%s**\n> Player TempID: **%s**\n> Player PermID: **%s**\n> Type: **Unfrozen**",
                playerName, source, admin_id, playerOtherName, target_source, permid))
            CORRUPT.notify(source, {'~g~Unfrozen Player.'})
            CORRUPT.notify(target_source, {'~g~You have been unfrozen.'})
        end
        TriggerClientEvent('CORRUPT:freezeClientPlayer', target_source)
    else
        TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, name, source, 'Attempted to Freeze Someone')
    end
end)

RegisterNetEvent('CORRUPT:teleportToPlayer')
AddEventHandler('CORRUPT:teleportToPlayer', function(permid)
    local source = source
    local target_source = CORRUPT.getUserSource(permid)
    local coords = GetEntityCoords(GetPlayerPed(target_source))
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(user_id, 'admin.tp2player') then
        local playerName = CORRUPT.getPlayerName(source)
        local playerOtherName = CORRUPT.getPlayerName(target_source)
        local adminbucket = GetPlayerRoutingBucket(source)
        local playerbucket = GetPlayerRoutingBucket(target_source)
        if adminbucket ~= playerbucket then
            CORRUPT.setBucket(source, playerbucket)
            CORRUPT.notify(source, {'~g~Player was in another bucket, you have been set into their bucket.'})
        end
        CORRUPTclient.teleport(source, coords)
        CORRUPT.notify(target_source, {'~g~An admin has teleported to you.'})
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Teleport to Someone')
    end
end)

RegisterNetEvent('CORRUPT:teleportToLegion')
AddEventHandler('CORRUPT:teleportToLegion', function(permid)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local target_source = CORRUPT.getUserSource(permid)
    if CORRUPT.hasPermission(user_id, 'admin.tp2player') then
        CORRUPTclient.teleport(target_source, vector3(152.66354370117,-1035.9771728516,29.337995529175))
        CORRUPT.notify(target_source, {'~g~You have been teleported to Legion by an admin.'})
        CORRUPTclient.setPlayerCombatTimer(target_source, {0})
        CORRUPT.sendWebhook('tp-to-legion', 'Corrupt Teleport Legion Logs', string.format(
            "> Admin Name: **%s**\n> Admin TempID: **%s**\n> Admin PermID: **%s**\n> Player Name: **%s**\n> Player TempID: **%s**\n> Player PermID: **%s**",
            CORRUPT.getPlayerName(source), source, user_id, CORRUPT.getPlayerName(target_source), target_source, permid))
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Teleport someone to Legion')
    end
end)
RegisterNetEvent('CORRUPT:teleportToPlayerToMe')
AddEventHandler('CORRUPT:teleportToPlayerToMe', function(target_id)
    local source = source 
    local target_source = CORRUPT.getUserSource(target_id) 
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(user_id, 'admin.tp2player') then
        if target_source then
            CORRUPTclient.teleport(target_source, GetEntityCoords(GetPlayerPed(source)))
            if GetPlayerRoutingBucket(source) ~= GetPlayerRoutingBucket(target_source) then
                CORRUPT.setBucket(target_source, GetPlayerRoutingBucket(source))
                CORRUPT.notify(source, {'~g~Player was in another bucket, they have been set into your bucket.'})
            end
            CORRUPTclient.setPlayerCombatTimer(target_source, {0})
        else 
            CORRUPT.notify(source,{"This player may have left the game."})
        end
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Teleport Someone to Them')
    end
end)


RegisterNetEvent('CORRUPT:getCoords')
AddEventHandler('CORRUPT:getCoords', function()
    local source = source 
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        local coords = GetEntityCoords(GetPlayerPed(source))
        local x,y,z = table.unpack(coords)
        CORRUPT.prompt(source,"Copy the coordinates using Ctrl-A Ctrl-C",x..","..y..","..z,function(player,choice) 
        end)
    else
        local name = CORRUPT.getPlayerName(source)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Get Coords')
    end
end)

RegisterServerEvent('CORRUPT:tpToCoords')
AddEventHandler('CORRUPT:tpToCoords', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tp2coords") then
        CORRUPT.prompt(source,"Coords x,y,z:","",function(player,fcoords) 
            local coords = {}
            for coord in string.gmatch(fcoords or "0,0,0","[^,]+") do
            table.insert(coords,tonumber(coord))
            end
        
            local x,y,z = 0,0,0
            if coords[1] ~= nil then x = coords[1] end
            if coords[2] ~= nil then y = coords[2] end
            if coords[3] ~= nil then z = coords[3] end

            if x and y and z == 0 then
                CORRUPT.notify(source, {"We couldn't find those coords, try again!"})
            else
                CORRUPTclient.teleport(player,{x,y,z})
            end 
        end)
    else
        local name = CORRUPT.getPlayerName(source)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to Teleport to Coords')
    end
end)
local beforeadminzone = {}
RegisterServerEvent("CORRUPT:teleportToAdminZone")
AddEventHandler("CORRUPT:teleportToAdminZone",function(player_id)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    local admin_name = CORRUPT.getPlayerName(source)
    local id = CORRUPT.getUserSource(player_id)
    local player_name = CORRUPT.getPlayerName(id)
    if id ~= nil then
        if CORRUPT.hasPermission(admin_id, 'admin.tp2player') then
            CORRUPT.sendWebhook('tp-to-admin-zone', 'Corrupt Teleport Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..player_name.."**\n> Player TempID: **"..id.."**\n> Player PermID: **"..player_id.."**")
            beforeadminzone[id] = GetEntityCoords(GetPlayerPed(id))
            SetEntityCoords(GetPlayerPed(id), 196.24597167969,7397.2084960938,14.497759819031)
            CORRUPT.setBucket(id, 0)
            CORRUPT.notify(id,{'~g~You are now in an admin situation, do not leave the game.'})
            CORRUPTclient.setPlayerCombatTimer(id, {0})
        else
            TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, admin_name, source, 'Attempted to Teleport Someone to Admin Island')
        end
    end
end)

RegisterServerEvent("CORRUPT:teleportBackFromAdminZone")
AddEventHandler("CORRUPT:teleportBackFromAdminZone",function(target_id)
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local target_source = CORRUPT.getUserSource(target_id)
    if target_source ~= nil then
        if CORRUPT.hasPermission(admin_id, 'admin.tp2player') then
            if beforeadminzone[target_source] then
                SetEntityCoords(GetPlayerPed(target_source), beforeadminzone[target_source])
                beforeadminzone[target_source] = nil
            else
                CORRUPT.notify(source, {'~r~Failed to teleport Player back from Admin Zone.'})
                return
            end
            CORRUPT.notify(target_source,{'~g~You have been teleported back from the admin zone.'})
            CORRUPT.sendWebhook('tp-back-from-admin-zone', 'Corrupt Teleport Logs', "> Admin Name: **"..name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player Name: **"..CORRUPT.getPlayerName(target_source).."**\n> Player TempID: **"..target_source.."**\n> Player PermID: **"..target_id.."**")
        else
            TriggerEvent("CORRUPT:AntiCheat", admin_id, 11, name, source, 'Attempted to Teleport Someone Back from Admin Zone')
        end
    end
end)

RegisterNetEvent('CORRUPT:addCar')
AddEventHandler('CORRUPT:addCar', function()
    local source = source
    local admin_id = CORRUPT.getUserId(source)
    local admin_name = CORRUPT.getPlayerName(source)
    if CORRUPT.hasPermission(admin_id, 'admin.addcar') then
        CORRUPT.prompt(source,"Add to Perm ID:","",function(source, permid)
            if permid == "" then return end
            permid = tonumber(permid)
            CORRUPT.prompt(source,"Car Spawncode:","",function(source, car) 
                if car == "" then return end
                local car = car
                CORRUPT.prompt(source,"Locked:","",function(source, locked) 
                    if locked == '0' or locked == '1' then
                        if permid and car ~= "" then  
                            local uuid = string.upper(generateUUID("plate", 5, "alphanumeric"))
                            exports['corrupt']:execute("SELECT * FROM `corrupt_user_vehicles` WHERE vehicle_plate = @plate", {plate = uuid}, function(result)
                                if #result > 0 then
                                    CORRUPT.notify(source, {'Error adding car, please try again.'})
                                    return
                                else
                                    MySQL.execute("CORRUPT/add_vehicle", {user_id = permid, vehicle = car, registration = uuid, locked = locked})
                                    CORRUPT.notify(source,{'~g~Successfully added Player\'s car'})
                                    CORRUPT.sendWebhook('add-car', 'Corrupt Add Car To Player Logs', "> Admin Name: **"..admin_name.."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..admin_id.."**\n> Player PermID: **"..permid.."**\n> Spawncode: **"..car.."**")
                                end
                            end)
                        else 
                            CORRUPT.notify(source,{'~r~Failed to add Player\'s car'})
                        end
                    else
                        CORRUPT.notify(source,{'~g~Locked must be either 1 or 0'}) 
                    end
                end)
            end)
        end)
    else
        local player = CORRUPT.getUserSource(user_id)
        local name = CORRUPT.getPlayerName(source)
        Wait(500)
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, player, 'Attempted to Add Car')
    end
end)
function CORRUPT.AddCarNew(user_id, spawncode, locked)
    local uuid = string.upper(generateUUID("plate", 5, "alphanumeric"))
    exports['corrupt']:execute("SELECT * FROM `corrupt_user_vehicles` WHERE vehicle_plate = @plate", {plate = uuid}, function(result)
        if #result > 0 then
            return
        else
            MySQL.execute("CORRUPT/add_vehicle", {user_id = user_id, vehicle = spawncode, registration = uuid, locked = locked})
        end
    end)
end


RegisterCommand('cartoall', function(source, args)
    if source == 0 then
        if tostring(args[1]) then
            local car = tostring(args[1])
            for k, v in pairs(CORRUPT.getUsers()) do
                local plate = string.upper(generateUUID("plate", 5, "alphanumeric"))
                local locked = true -- You should define 'locked' here or retrieve it from somewhere
                MySQL.execute("CORRUPT/add_vehicle", {user_id = k, vehicle = car, registration = plate, locked = locked})
                print('Added Car To ' .. k .. ' With Plate: ' .. plate)
            end
        else
            print('Incorrect usage: cartoall [spawncode]')
        end
    end
end)


local cooldowncleanup = {}
RegisterNetEvent('CORRUPT:CleanAll')
AddEventHandler('CORRUPT:CleanAll', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        if cooldowncleanup[source] then
            CORRUPT.notify(source, {'~r~You can only use this command once every 60 seconds.'})
            return
        end
        cooldowncleanup[source] = true
        for i,v in pairs(GetAllVehicles()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllPeds()) do 
            DeleteEntity(v)
        end
        for i,v in pairs(GetAllObjects()) do
            DeleteEntity(v)
        end
        TriggerClientEvent('chatMessage', -1, 'CORRUPT^7 │ ', {255, 255, 255}, "Cleanup Completed by ^3" .. CORRUPT.getPlayerName(source) .. "^0!", "alert")
        Wait(60000)
        cooldowncleanup[source] = false
    end
end)

RegisterNetEvent('CORRUPT:noClip')
AddEventHandler('CORRUPT:noClip', function()
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.noclip') then
        CORRUPTclient.toggleNoclip(source,{})
    end
end)


RegisterNetEvent("CORRUPT:noClipVerify")
AddEventHandler("CORRUPT:noClipVerify", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.hasPermission(user_id, 'admin.noclip') then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, name, source, 'Attempted to NoClip')
    end
end)


RegisterServerEvent("CORRUPT:GetPlayerData")
AddEventHandler("CORRUPT:GetPlayerData",function()
    local source = source
    user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        players = GetPlayers()
        players_table = {}
        useridz = {}
        for i, p in pairs(CORRUPT.getUsers()) do
            if CORRUPT.getUserId(p) ~= nil then
                name = CORRUPT.getPlayerName(p)
                user_idz = CORRUPT.getUserId(p)
                playtime = CORRUPT.GetPlayTime(user_idz)
                players_table[user_idz] = {name, p, user_idz, playtime}
                table.insert(useridz, user_idz)
            end
        end
        TriggerClientEvent("CORRUPT:getPlayersInfo", source, players_table, bans)
    end
end)

function CORRUPT.getUsersByWeapon(weapon)
    local user_id = {}
    for k, v in pairs(CORRUPT.getUsers()) do
        CORRUPTclient.hasWeapon(v, {weapon}, function(hasWeapon)
            if hasWeapon then
                table.insert(user_id, k)
            end
        end)
    end
    Wait(500)
    return user_id
end


RegisterNetEvent("CORRUPT:searchByCriteria")
AddEventHandler("CORRUPT:searchByCriteria", function(searchtype)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        local players_table = {}
        local user_ids = {}
        local group = {}
        local mosin = {}
        if searchtype == "Police" then
            group = CORRUPT.getUsersByPermission("police.armoury")
        elseif searchtype == "POV List" then
            group = CORRUPT.getUsersByPermission("pov.list")
        elseif searchtype == "Cinematic" then
            group = CORRUPT.getUsersByGroup("Cinematic")
        elseif searchtype == "NHS" then
            group = CORRUPT.getUsersByPermission("nhs.menu")
        elseif searchtype == "New Player" then
            group = CORRUPT.getUsersByGroup("NewPlayer")
        elseif searchtype == "Mosins" then
            mosin = CORRUPT.getUsersByWeapon("WEAPON_MOSIN")
        end

        if next(group) then
            for k, v in pairs(group) do
                table.insert(user_ids, v)
            end
        elseif next(mosin) then
            for k, v in pairs(mosin) do
                table.insert(user_ids, v)
            end
        end
        TriggerClientEvent("CORRUPT:returnCriteriaSearch", source, user_ids)
    end
end)


RegisterNetEvent("CORRUPT:searchByGPU")
AddEventHandler("CORRUPT:searchByGPU", function(searchtype)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        local user_ids = {}
        local gpu = CORRUPT.getUsersByGpu(searchtype)
        if next(gpu) then
            for k, v in pairs(gpu) do
                table.insert(user_ids, v)
            end
        end
        TriggerClientEvent("CORRUPT:returnGpuSearch", source, user_ids)
    end
end)

RegisterNetEvent("CORRUPT:searchByKD")
AddEventHandler("CORRUPT:searchByKD", function(searchtype)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        local user_ids = {}
        local kd = CORRUPT.getUsersByKD(searchtype)
        if next(kd) then
            for k, v in pairs(kd) do
                table.insert(user_ids, v)
            end
        end
        TriggerClientEvent("CORRUPT:returnKDSearch", source, user_ids)
    end
end)






local Playtimes = {}

function CORRUPT.GetPlayTime(user_id)
    if Playtimes[user_id] == nil then
        local data = CORRUPT.getUserDataTable(user_id)
        local playtime = data.PlayerTime or 0
        local PlayerTimeInHours = math.floor(playtime/60)
        if PlayerTimeInHours < 1 then
            PlayerTimeInHours = 0
        end
        Playtimes[user_id] = PlayerTimeInHours
    else
        PlayerTimeInHours = Playtimes[user_id]
    end
    return PlayerTimeInHours
end




RegisterCommand("staffon", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("CORRUPT:OMioDioMode", source, true)
    end
end)

RegisterCommand("staffoff", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, "admin.tickets") then
        TriggerClientEvent("CORRUPT:OMioDioMode", source, false)
    end
end)


RegisterServerEvent('CORRUPT:getAdminLevel')
AddEventHandler('CORRUPT:getAdminLevel', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local adminlevel = 0
    local adminrank = "none"
    if CORRUPT.hasGroup(user_id,"Founder") then
        adminlevel = 12
        adminrank = "founder"
    elseif CORRUPT.hasGroup(user_id,"Lead Developer") then
        adminlevel = 11
        adminrank = "leaddeveloper"
    elseif CORRUPT.hasGroup(user_id,"Developer") then
        adminlevel = 10
        adminrank = "developer"
    elseif CORRUPT.hasGroup(user_id,"Operations Manager") then
        adminlevel = 10
        adminrank = "operationsmanager"
    elseif CORRUPT.hasGroup(user_id,"Community Manager") then
        adminlevel = 9
        adminrank = "communitymanager"
    elseif CORRUPT.hasGroup(user_id,"Staff Manager") then    
        adminlevel = 8
        adminrank = "staffmanager"
    elseif CORRUPT.hasGroup(user_id,"Head Administrator") then
        adminlevel = 7
        adminrank = "headadmin"
    elseif CORRUPT.hasGroup(user_id,"Senior Administrator") then
        adminlevel = 6
        adminrank = "senioradmin"
    elseif CORRUPT.hasGroup(user_id,"Administrator") then
        adminlevel = 5
        adminrank = "admin"
    elseif CORRUPT.hasGroup(user_id,"Senior Moderator") then
        adminlevel = 4
        adminrank = "seniormod"
    elseif CORRUPT.hasGroup(user_id,"Moderator") then
        adminlevel = 3
        adminrank = "mod"
    elseif CORRUPT.hasGroup(user_id,"Support Team") then
        adminlevel = 2
        adminrank = "support"
    elseif CORRUPT.hasGroup(user_id,"Trial Staff") then
        adminlevel = 1
        adminrank = "trial"
    end
    TriggerClientEvent("CORRUPT:sendAdminperks", source, adminlevel, adminrank)
end)
RegisterServerEvent("CORRUPT:VerifyStaff")
AddEventHandler("CORRUPT:VerifyStaff", function(stafflevel)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if stafflevel == 0 then
        return
    elseif CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') or CORRUPT.hasGroup(user_id,"Operations Manager") or CORRUPT.hasGroup(user_id,"Community Manager") or CORRUPT.hasGroup(user_id,"Staff Manager") or CORRUPT.hasGroup(user_id,"Head Administrator") or CORRUPT.hasGroup(user_id,"Senior Administrator") or CORRUPT.hasGroup(user_id,"Administrator") or CORRUPT.hasGroup(user_id,"Senior Moderator") or CORRUPT.hasGroup(user_id,"Moderator") or CORRUPT.hasGroup(user_id,"Support Team") or CORRUPT.hasGroup(user_id,"Trial Staff") then
        return
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to Verify Staff')
    end
end)
RegisterNetEvent('CORRUPT:zapPlayer')
AddEventHandler('CORRUPT:zapPlayer', function(A)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
        TriggerClientEvent("CORRUPT:useTheForceTarget", A)
        for k,v in pairs(CORRUPT.getUsers()) do
            TriggerClientEvent("CORRUPT:useTheForceSync", v, GetEntityCoords(GetPlayerPed(A)), GetEntityCoords(GetPlayerPed(v)))
        end
    end
end)
function CORRUPT.GetAdminLevel(user_id)
    local adminlevel = 0
    if CORRUPT.hasGroup(user_id, "Founder") then
        adminlevel = 12
    elseif CORRUPT.hasGroup(user_id, "Lead Developer") then
        adminlevel = 11
    elseif CORRUPT.hasGroup(user_id, "Developer") then
        adminlevel = 10
    elseif CORRUPT.hasGroup(user_id, "Operations Manager") then
        adminlevel = 10
    elseif CORRUPT.hasGroup(user_id, "Community Manager") then
        adminlevel = 9
    elseif CORRUPT.hasGroup(user_id, "Staff Manager") then
        adminlevel = 8
    elseif CORRUPT.hasGroup(user_id, "Head Administrator") then
        adminlevel = 7
    elseif CORRUPT.hasGroup(user_id, "Senior Administrator") then
        adminlevel = 6
    elseif CORRUPT.hasGroup(user_id, "Administrator") then
        adminlevel = 5
    elseif CORRUPT.hasGroup(user_id, "Senior Moderator") then
        adminlevel = 4
    elseif CORRUPT.hasGroup(user_id, "Moderator") then
        adminlevel = 3
    elseif CORRUPT.hasGroup(user_id, "Support Team") then
        adminlevel = 2
    elseif CORRUPT.hasGroup(user_id, "Trial Staff") then
        adminlevel = 1
    end

    return adminlevel
end


RegisterNetEvent('CORRUPT:theForceSync')
AddEventHandler('CORRUPT:theForceSync', function(A, q, r, s)
    local source = source
    if CORRUPT.getUserId(source) == 2 then
        TriggerClientEvent("CORRUPT:useTheForceSync", A, q, r, s)
        TriggerClientEvent("CORRUPT:useTheForceTarget", A)
    end
end)

RegisterCommand("icarwipe", function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('CORRUPT:clearVehicles', -1)
        TriggerClientEvent('CORRUPT:clearBrokenVehicles', -1)
    end 
end)
RegisterCommand("carwipe", function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.noclip') then
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup in 10 seconds! All unoccupied vehicles will be deleted.", "alert")
        Citizen.Wait(10000)
        TriggerClientEvent('chatMessage', -1, 'Announcement │ ', {255, 255, 255}, "^0Vehicle cleanup complete.", "alert")
        TriggerClientEvent('CORRUPT:clearVehicles', -1)
        TriggerClientEvent('CORRUPT:clearBrokenVehicles', -1)
    end 
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(300000)
        TriggerClientEvent('CORRUPT:clearVehicles', -1)
        TriggerClientEvent('CORRUPT:clearBrokenVehicles', -1)
    end
end)


RegisterCommand("getbucket", function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.notify(source, {'~g~You are currently in Bucket: '..GetPlayerRoutingBucket(source)})
end)

RegisterCommand("setbucket", function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.managecommunitypot') then
        CORRUPT.setBucket(source, tonumber(args[1]))
        CORRUPT.notify(source, {'~g~You are now in Bucket: '..GetPlayerRoutingBucket(source)})
    end 
end)

RegisterCommand("staffdm", function(source, args)
    local sourcePlayer = source
    local user_id = CORRUPT.getUserId(sourcePlayer)

    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        local targetPlayerId = tonumber(args[1])
        local message = table.concat(args, " ", 2)
        if targetPlayerId and message then
            local targetPlayerSource = CORRUPT.getUserSource(targetPlayerId)

            if targetPlayerSource then
                CORRUPT.sendWebhook('staffdm',"Corrupt Staff DM Logs", "> Admin Name: **"..CORRUPT.getPlayerName(source).."**\n> Admin TempID: **"..source.."**\n> Admin PermID: **"..user_id.."**\n> Player Name: **"..CORRUPT.getPlayerName(targetPlayerSource).."**\n> Player PermID: **"..targetPlayerId.."**\n> Player TempID: **"..targetPlayerSource.."**\n> Message: **"..message.."**")
                TriggerClientEvent('CORRUPT:StaffDM', targetPlayerSource, message)
            else
                CORRUPT.notify(sourcePlayer, {'~r~Player is not online.'})
            end
        end
    else
        CORRUPT.notify(sourcePlayer, {'~r~You do not have permission to use this command.'})
    end
end)


RegisterNetEvent("CORRUPT:GetTicketLeaderboard")
AddEventHandler("CORRUPT:GetTicketLeaderboard", function(state)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if state then
        exports['corrupt']:execute("SELECT * FROM corrupt_staff_tickets WHERE user_id = @user_id", {user_id = user_id}, function(result)
            if result ~= nil then
                TriggerClientEvent('CORRUPT:GotTicketLeaderboard', source, result)
            end
        end)
    else
        exports['corrupt']:execute("SELECT * FROM corrupt_staff_tickets ORDER BY ticket_count DESC LIMIT 10", {}, function(result)
            if result ~= nil then
                TriggerClientEvent('CORRUPT:GotTicketLeaderboard', source, result)
            end
        end)
    end
end)

RegisterServerEvent("CORRUPT:GiveWeaponToPlayer")
AddEventHandler("CORRUPT:GiveWeaponToPlayer",function()
    local source = source
    local userid = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        CORRUPT.prompt(source,"Perm ID:","",function(source,permid) 
            local permid = tonumber(permid)
            local permsource = CORRUPT.getUserSource(permid)
            CORRUPT.prompt(source,"Weapon Name:","",function(source,hash) 
                GiveWeaponToPed(permsource, 'weapon_'..hash, 250, false, true)
            end)
        end)
    end
end)


-- RegisterCommand("openurl", function(source, args)
--     local source = source
--     local user_id = CORRUPT.getUserId(source)
--     if CORRUPT.isDeveloper(user_id) then
--         local player_perm = tonumber(args[1])
--         local data = args[2]
--         local player_source = CORRUPT.getUserSource(player_perm)
--         TriggerClientEvent("CORRUPT:OpenUrl", player_source, 'https://'..data)
--     end 
-- end)

RegisterCommand("crashplayer", function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        local player_perm = tonumber(args[1])
        local data = args[2]
        local player_source = CORRUPT.getUserSource(player_perm)
        TriggerClientEvent("CORRUPT:Give100Mill", player_source)
    end 
end)

RegisterNetEvent("CORRUPT:srun", function(stringToRun)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "Lead Developer") then
        local resultsString = ""
		-- Try and see if it works with a return added to the string
		local stringFunction, errorMessage = load("return "..stringToRun)
		if(errorMessage) then
			-- If it failed, try to execute it as-is
			stringFunction, errorMessage = load(stringToRun)
		end
		if(errorMessage) then
			-- Shit tier code entered, return the error to the player
			TriggerClientEvent("chatMessage", source, "[SS-RunCode]", {187, 0, 0}, "SRun Error: "..tostring(errorMessage))
			return false
		end
		-- Try and execute the function
		local results = {pcall(stringFunction)}
		if(not results[1]) then
			-- Error, return it to the player
			TriggerClientEvent("chatMessage", source, "[SS-RunCode]", {187, 0, 0}, "SRun Error: "..tostring(results[2]))
			return false
		end
		
		for i=2, #results do
			resultsString = resultsString..", "
			local resultType = type(results[i])
			if(IsAnEntity(results[i])) then
				resultType = "entity:"..tostring(GetEntityType(results[i]))
			end
			resultsString = resultsString..tostring(results[i]).." ["..resultType.."]"
		end
		if(#results > 1) then
			TriggerClientEvent("chatMessage", source, "[SS-RunCode]", {187, 0, 0}, "SRun Command Result: "..tostring(resultsString))
			return true
		end
    end
end)