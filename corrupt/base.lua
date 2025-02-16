MySQL = module("modules/MySQL")

Proxy = module("lib/Proxy")
Tunnel = module("lib/Tunnel")
Lang = module("lib/Lang")

local config = module("cfg/base")
local verify_card = {["type"]="AdaptiveCard",["$schema"]="http://adaptivecards.io/schemas/adaptive-card.json",["version"]="1.3",["backgroundImage"]={["url"]=""},["body"]={{["type"]="TextBlock",["text"]="Corrupt Public",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=true,["weight"]="Bolder"},{["type"]="Container",["horizontalAlignment"]="Center",["size"]="Large",["items"]={{["type"]="TextBlock",["text"]="In order to connect to Corrupt you must be in our discord and verify your account",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="Join the Corrupt discord (discord.gg/corrupt5m)",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="In the #verify channel, click the button and enter the code below",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["color"]="Attention",["horizontalAlignment"]="Center",["size"]="Large",["text"]="NULL",["wrap"]=false},{["type"]="TextBlock",["color"]="Attention",["horizontalAlignment"]="Center",["size"]="Large",["text"]="Your account has not beem verified yet. (Attempt 0)",["wrap"]=false}}},{["type"]="ActionSet",["horizontalAlignment"]="Center",["size"]="Large",["actions"]={{["type"]="Action.Submit",["title"]="Enter Corrupt",["horizontalAlignment"]="Center",["size"]="Large",["id"]="connectButton",["data"]={["action"]="connectClicked"}}}}}}
local ban_card = {["type"]="AdaptiveCard",["$schema"]="http://adaptivecards.io/schemas/adaptive-card.json",["version"]="1.3",["backgroundImage"]={["url"]=""},["body"]={{["type"]="TextBlock",["text"]="Corrupt Public",["highlight"]=true,["horizontalAlignment"]="Center",["size"]="Medium",["wrap"]=true,["weight"]="Bolder"},{["type"]="Container",["horizontalAlignment"]="Center",["items"]={{["type"]="TextBlock",["text"]="Ban expires in NULL",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="Your ID: NULL",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["horizontalAlignment"]="Center",["size"]="Large",["text"]="Reason: NULL",["wrap"]=false},{["type"]="TextBlock",["color"]="Attention",["horizontalAlignment"]="Center",["size"]="Medium",["color"]="Warning",["text"]="If you believe this ban is invalid, please appeal on our discord",["wrap"]=false,["isSubtle"]=true}}},{['type']='ActionSet',["horizontalAlignment"]="Center",["size"]="Large",['actions']={{['type']='Action.OpenUrl',['title']='Corrupt Discord',["horizontalAlignment"]="Center",["size"]="Large",["url"]="https://discord.gg/corrupt5m"},{['type']='Action.OpenUrl',['title']='Corrupt Support',["horizontalAlignment"]="Center",["size"]="Large",["url"]="https://discord.gg/TpGbCTVvsa"}}}}}
local connecting_card = {["type"]="AdaptiveCard",["$schema"]="http://adaptivecards.io/schemas/adaptive-card.json",["version"]="1.3",["backgroundImage"]={["url"]=""},["body"]={{["type"]="TextBlock",["text"]="Corrupt Public",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=true,["weight"]="Bolder"},{["type"]="Container",["horizontalAlignment"]="Center",["size"]="Large",["items"]={{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="Welcome To Corrupt",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false}}}}}
local whitelist_card = {["type"]="AdaptiveCard",["$schema"]="http://adaptivecards.io/schemas/adaptive-card.json",["version"]="1.3",["backgroundImage"]={["url"]=""},["body"]={{["type"]="TextBlock",["text"]="Corrupt Public",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=true,["weight"]="Bolder"},{["type"]="Container",["horizontalAlignment"]="Center",["size"]="Large",["items"]={{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["color"]="Attention",["text"]="Server is currently in maintenance",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false},{["type"]="TextBlock",["text"]="  ",["horizontalAlignment"]="Center",["size"]="Large",["wrap"]=false}}}}}

tvRP = {}
encrypted_proxy = {}
encrypted_proxy = generateUUID("proxy", 15, "encrypted")

Tunnel.bindInterface(encrypted_proxy,tvRP)
local dict = module("cfg/lang/"..config.lang) or {}
CORRUPT.lang = Lang.new(dict)
CORRUPTclient = Tunnel.getInterface(encrypted_proxy,encrypted_proxy) 

CORRUPT.users = {}
CORRUPT.rusers = {}
CORRUPT.user_tables = {} 
CORRUPT.user_tmp_tables = {} 
CORRUPT.user_sources = {} 

MySQL.createCommand('CORRUPT/CreateUser', 'INSERT INTO corrupt_users(license,banned) VALUES(@license,false)')
MySQL.createCommand('CORRUPT/GetUserByLicense', 'SELECT id FROM corrupt_users WHERE license = @license')
MySQL.createCommand("CORRUPT/AddIdentifier", "INSERT INTO corrupt_user_ids (identifier, user_id, banned) VALUES(@identifier, @user_id, false)")
MySQL.createCommand("CORRUPT/GetUserByIdentifier", "SELECT * FROM corrupt_user_ids WHERE identifier = @identifier")
MySQL.createCommand("CORRUPT/GetIdentifiers", "SELECT identifier FROM corrupt_user_ids WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/BanIdentifier", "UPDATE corrupt_user_ids SET banned = @banned WHERE identifier = @identifier")

MySQL.createCommand("CORRUPT/identifier_all","SELECT * FROM corrupt_user_ids WHERE identifier = @identifier")
MySQL.createCommand("CORRUPT/select_identifier_byid_all","SELECT * FROM corrupt_user_ids WHERE user_id = @id")

MySQL.createCommand("CORRUPT/set_userdata","REPLACE INTO corrupt_user_data(user_id,dkey,dvalue) VALUES(@user_id,@key,@value)")
MySQL.createCommand("CORRUPT/get_userdata","SELECT dvalue FROM corrupt_user_data WHERE user_id = @user_id AND dkey = @key")

MySQL.createCommand("CORRUPT/set_srvdata","REPLACE INTO CORRUPT_srv_data(dkey,dvalue) VALUES(@key,@value)")
MySQL.createCommand("CORRUPT/get_srvdata","SELECT dvalue FROM CORRUPT_srv_data WHERE dkey = @key")

MySQL.createCommand("CORRUPT/get_banned","SELECT banned FROM corrupt_users WHERE id = @user_id")
MySQL.createCommand("CORRUPT/set_banned","UPDATE corrupt_users SET banned = @banned, bantime = @bantime,  banreason = @banreason,  banadmin = @banadmin, baninfo = @baninfo WHERE id = @user_id")
MySQL.createCommand("CORRUPT/set_identifierbanned","UPDATE corrupt_user_ids SET banned = @banned WHERE identifier = @iden")
MySQL.createCommand("CORRUPT/getbanreasontime", "SELECT * FROM corrupt_users WHERE id = @user_id")

MySQL.createCommand("CORRUPT/set_last_login","UPDATE corrupt_users SET last_login = @last_login WHERE id = @user_id")
MySQL.createCommand("CORRUPT/get_last_login","SELECT last_login FROM corrupt_users WHERE id = @user_id")

--Token Banning 
MySQL.createCommand("CORRUPT/add_token","INSERT INTO corrupt_user_tokens(token,user_id) VALUES(@token,@user_id)")
MySQL.createCommand("CORRUPT/check_token","SELECT user_id, banned FROM corrupt_user_tokens WHERE token = @token")
MySQL.createCommand("CORRUPT/check_token_userid","SELECT token FROM corrupt_user_tokens WHERE user_id = @id")
MySQL.createCommand("CORRUPT/ban_token","UPDATE corrupt_user_tokens SET banned = @banned WHERE token = @token")
MySQL.createCommand("CORRUPT/delete_token","DELETE FROM corrupt_user_tokens WHERE token = @token")
--Device Banning
MySQL.createCommand("ac/delete_ban","DELETE FROM corrupt_anticheat WHERE @user_id = user_id")

function CORRUPT.getUsers()
    local users = {}
    for k,v in pairs(CORRUPT.user_sources) do
        users[k] = v
    end
    return users
end

discordnames = {}
function CORRUPT.GetDiscordName(source, user_id)
    local discord_id = exports["corrupt"]:executeSync("SELECT discord_id FROM `corrupt_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
    local nickname = Get_Guild_Nickname(1271575952115368008, discord_id)
    if nickname then
        discordnames[user_id] = nickname
    end
end

RegisterServerEvent("CORRUPT:SetDiscordName")
AddEventHandler("CORRUPT:SetDiscordName", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    while user_id == nil do
        Citizen.Wait(0)
        user_id = CORRUPT.getUserId(source)
    end
    CORRUPT.GetDiscordName(source, user_id)
    TriggerClientEvent("CORRUPT:setDiscordNames", source, discordnames)
end)

function CORRUPT.getPlayerName(source, user_id)
    if not user_id then
        user_id = CORRUPT.getUserId(source)
    end
    if user_id == nil or discordnames[user_id] == nil then
        return GetPlayerName(source)
    end
	return discordnames[user_id] or GetPlayerName(source)
end


exports('GetDiscordName', function(source)
    return CORRUPT.getPlayerName(source)
end)


function CORRUPT.checkidentifiers(userid, identifiers, cb)
    for _, identifier in pairs(identifiers) do
        MySQL.query("CORRUPT/GetUserByIdentifier", {identifier = identifier}, function(rows, affected)
            if rows[1] then
                local otheruserid = rows[1].user_id
                if otheruserid ~= userid then
                    if rows[1].banned then
                        cb(true, otheruserid, "Ban Evading", identifier)
                    else
                        cb(false, otheruserid, "Multi Accounting", identifier)
                    end
                end
            else
                MySQL.query("CORRUPT/AddIdentifier", {identifier = identifier, user_id = userid})
            end
        end)
    end
end


function CORRUPT.getUserByLicense(license, cb)
    MySQL.query('CORRUPT/GetUserByLicense', {license = license}, function(rows, affected)
        if rows[1] then
            cb(rows[1].id)
        else
            MySQL.query('CORRUPT/CreateUser', {license = license}, function(rows, affected)
                if rows.affectedRows > 0 then
                    CORRUPT.getUserByLicense(license, cb)
                end
            end)
            for k, v in pairs(CORRUPT.getUsers()) do
                if CORRUPT.hasGroup(k, "TutorialDone") then
                    CORRUPT.notify(v, {'~g~You have received £50,000 as someone new has joined the server.'})
                    CORRUPT.giveBankMoney(k, 50000)
                end
            end
        end
    end)
end


function CORRUPT.SetIdentifierban(user_id,banned)
    MySQL.query("CORRUPT/GetIdentifiers", {user_id = user_id}, function(rows)
        if banned then
            for i=1, #rows do
                MySQL.query("CORRUPT/BanIdentifier", {identifier = rows[i].identifier, banned = true})
                Wait(50)
            end
        else
            for i=1, #rows do
                MySQL.query("CORRUPT/BanIdentifier", {identifier = rows[i].identifier, banned = false})
            end
        end
    end)
end
function CORRUPT.getSourceIdKey(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local idk = "idk_"
    for k,v in pairs(Identifiers) do
        idk = idk..v
    end
    return idk
end

function CORRUPT.getPlayerIP(player)
    return GetPlayerEP(player) or "0.0.0.0"
end
local file = LoadResourceFile(GetCurrentResourceName(), "whitelist.json")
local whitelist = json.decode(file) or { whitelisted = false }

function CORRUPT.SetWhiteList(state)
    state = tostring(state)
    whitelist.whitelisted = (state == "true")
    SaveResourceFile(GetCurrentResourceName(), "whitelist.json", json.encode(whitelist), -1)
end

function CORRUPT.getWhitelisted()
    return whitelist.whitelisted
end

exports("getWhitelisted", function(params, cb)
    return whitelist.whitelisted
end)

RegisterCommand("whitelist", function(source, args)
    local source = source
    if source == 0 then
        CORRUPT.SetWhiteList(not CORRUPT.getWhitelisted())
        print("Whitelist now set to "..CORRUPT.getWhitelisted())
    end
end)



function CORRUPT.ReLoadChar(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if ids.license then
        CORRUPT.getUserByLicense(ids.license, function(user_id)
            CORRUPT.GetDiscordName(source, user_id)
            Wait(100)
            if user_id ~= nil then
                local name = CORRUPT.getPlayerName(source, user_id) or discordnames[user_id]
                CORRUPT.StoreTokens(source, user_id) 
                if CORRUPT.rusers[user_id] == nil then
                    CORRUPT.users[Identifiers[1]] = user_id
                    CORRUPT.rusers[user_id] = Identifiers[1]
                    CORRUPT.user_tables[user_id] = {}
                    CORRUPT.user_tmp_tables[user_id] = {}
                    CORRUPT.user_sources[user_id] = source
                    CORRUPT.getUData(user_id, "CORRUPT:datatable", function(sdata)
                        local data = json.decode(sdata)
                        if type(data) == "table" then CORRUPT.user_tables[user_id] = data end
                        local tmpdata = CORRUPT.getUserTmpTable(user_id)
                        CORRUPT.getLastLogin(user_id, function(last_login)
                            tmpdata.last_login = last_login or ""
                            tmpdata.spawns = 0
                            local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                            MySQL.execute("CORRUPT/set_last_login", {user_id = user_id, last_login = last_login_stamp})
                            print("[CORRUPT] "..name.." ^2Joined^0 | Perm ID: "..user_id)
                            TriggerEvent("CORRUPT:playerJoin", user_id, source, name, tmpdata.last_login)
                            TriggerClientEvent("CORRUPT:CheckIdRegister", source)
                        end)
                    end)
                else 
                    print("[CORRUPT] "..name.." ^2Re-Joined^0 | Perm ID: "..user_id)
                    TriggerEvent("CORRUPT:playerRejoin", user_id, source, name)
                    TriggerClientEvent("CORRUPT:CheckIdRegister", source)
                    local tmpdata = CORRUPT.getUserTmpTable(user_id)
                    tmpdata.spawns = 0
                end
            end
        end)
    end
end

exports("corruptbot", function(method_name, params, cb)
    if cb then 
        cb(CORRUPT[method_name](table.unpack(params)))
    else 
        return CORRUPT[method_name](table.unpack(params))
    end
end)

RegisterNetEvent("CORRUPT:ReloadUser")
AddEventHandler("CORRUPT:ReloadUser", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not user_id then
        CORRUPT.ReLoadChar(source)
    end
end)

function CORRUPT.isBanned(user_id, cbr)
    local task = Task(cbr, {false})
    MySQL.query("CORRUPT/get_banned", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].banned})
        else
            task()
        end
    end)
end
function CORRUPT.getLastLogin(user_id, cbr)
    local task = Task(cbr,{""})
    MySQL.query("CORRUPT/get_last_login", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].last_login})
        else
            task()
        end
    end)
end

function CORRUPT.fetchBanReasonTime(user_id,cbr)
    MySQL.query("CORRUPT/getbanreasontime", {user_id = user_id}, function(rows, affected)
        if #rows > 0 then 
            cbr(rows[1].bantime, rows[1].banreason, rows[1].banadmin)
        end
    end)
end

function CORRUPT.setUData(user_id,key,value)
    MySQL.execute("CORRUPT/set_userdata", {user_id = user_id, key = key, value = value})
end

function CORRUPT.getUData(user_id,key,cbr)
    local task = Task(cbr,{""})
    MySQL.query("CORRUPT/get_userdata", {user_id = user_id, key = key}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function CORRUPT.setSData(key,value)
    MySQL.execute("CORRUPT/set_srvdata", {key = key, value = value})
end

function CORRUPT.getSData(key, cbr)
    local task = Task(cbr,{""})
    MySQL.query("CORRUPT/get_srvdata", {key = key}, function(rows, affected)
        if rows and #rows > 0 then
            task({rows[1].dvalue})
        else
            task()
        end
    end)
end

function CORRUPT.getUserDataTable(user_id)
    return CORRUPT.user_tables[user_id]
end

function CORRUPT.getUserTmpTable(user_id)
    return CORRUPT.user_tmp_tables[user_id]
end

function CORRUPT.isConnected(user_id)
    return CORRUPT.rusers[user_id] ~= nil
end

function CORRUPT.isFirstSpawn(user_id)
    local tmp = CORRUPT.getUserTmpTable(user_id)
    return tmp and tmp.spawns == 1
end

function CORRUPT.getUserId(source)
    if source ~= nil then
        local Identifiers = GetPlayerIdentifiers(source)
        if Identifiers ~= nil and #Identifiers > 0 then
            return CORRUPT.users[Identifiers[1]]
        end
    end
    return nil
end

function CORRUPT.getUserSource(user_id)
    return CORRUPT.user_sources[user_id]
end

function CORRUPT.IdentifierBanCheck(source,user_id,cb)
    for i,v in pairs(GetPlayerIdentifiers(source)) do 
        MySQL.query('CORRUPT/identifier_all', {identifier = v}, function(rows)
            for i = 1,#rows do 
                if rows[i].banned then 
                    if user_id ~= rows[i].user_id then 
                        cb(true, rows[i].user_id, v)
                    end 
                end
            end
        end)
    end
end

function CORRUPT.BanIdentifiers(user_id, value)
    MySQL.query('CORRUPT/select_identifier_byid_all', {id = user_id}, function(rows)
        for i = 1, #rows do 
            MySQL.execute("CORRUPT/set_identifierbanned", {banned = value, iden = rows[i].identifier })
        end
    end)
end

function calculateTimeRemaining(expireTime)
    local datetime = ''
    local expiry = os.date("%d/%m/%Y at %H:%M", tonumber(expireTime))
    local hoursLeft = ((tonumber(expireTime)-os.time()))/3600
    local minutesLeft = nil
    if hoursLeft < 1 then
        minutesLeft = hoursLeft * 60
        minutesLeft = string.format("%." .. (0) .. "f", minutesLeft)
        datetime = minutesLeft .. " mins" 
        return datetime
    else
        hoursLeft = string.format("%." .. (0) .. "f", hoursLeft)
        datetime = hoursLeft .. " hours" 
        return datetime
    end
    return datetime
end

function CORRUPT.setBanned(user_id,banned,time,reason,admin,baninfo)
    if banned then 
        MySQL.execute("CORRUPT/set_banned", {user_id = user_id, banned = banned, bantime = time, banreason = reason, banadmin = admin, baninfo = baninfo})
        CORRUPT.BanIdentifiers(user_id, true)
        CORRUPT.BanTokens(user_id, true)
        exports["corrupt"]:executeSync("UPDATE corrupt_user_info SET banned = @banned WHERE user_id = @user_id", {banned = true, user_id = user_id})
        local discord_id = exports['corrupt']:executeSync("SELECT discord_id FROM `corrupt_verification` WHERE user_id = @user_id", {user_id = user_id})[1].discord_id
        local message = string.format("You have been banned on CORRUPT for %s. Your ban will %s.",reason, time == "perm" and "not expire" or string.format("expire in %s hours", calculateTimeRemaining(time)))
        exports['corrupt']:dmUserText(source, {discord_id, message})
    else 
        MySQL.execute("CORRUPT/set_banned", {user_id = user_id, banned = banned, bantime = "", banreason =  "", banadmin =  "", baninfo = ""})
        CORRUPT.BanIdentifiers(user_id, false)
        CORRUPT.BanTokens(user_id, false)
        exports["corrupt"]:executeSync("UPDATE corrupt_user_info SET banned = @banned WHERE user_id = @user_id", {banned = false, user_id = user_id})
        MySQL.execute("ac/delete_ban", {user_id = user_id})
    end 
end

function CORRUPT.ban(adminsource,permid,time,reason,baninfo)
    local adminPermID = CORRUPT.getUserId(adminsource)
    local PlayerSource = CORRUPT.getUserSource(tonumber(permid))
    local getBannedPlayerSrc = CORRUPT.getUserSource(tonumber(permid))
    local adminname = CORRUPT.getPlayerName(adminsource, adminPermID) or discordnames[adminPermID]
    if getBannedPlayerSrc then 
        if tonumber(time) then
            CORRUPT.setBucket(PlayerSource, permid)
            CORRUPT.setBanned(permid,true,time,reason,adminname,baninfo)
            CORRUPT.kick(getBannedPlayerSrc,"Ban expires in: "..calculateTimeRemaining(time).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/corrupt5m") 
        else
            CORRUPT.setBucket(PlayerSource, permid)
            CORRUPT.setBanned(permid,true,"perm",reason,adminname,baninfo)
            CORRUPT.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/corrupt5m") 
        end
        CORRUPT.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    else 
        if tonumber(time) then 
            CORRUPT.setBanned(permid,true,time,reason,adminname,baninfo)
        else 
            CORRUPT.setBanned(permid,true,"perm",reason,adminname,baninfo)
        end
        CORRUPT.notify(adminsource,{"~g~Success banned! User PermID: " .. permid})
    end
end

function CORRUPT.banConsole(permid,time,reason)
    local adminPermID = "CORRUPT"
    local getBannedPlayerSrc = CORRUPT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            CORRUPT.setBanned(permid,true,banTime,reason, adminPermID)
            CORRUPT.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by CORRUPT \nAppeal @ discord.gg/corrupt5m") 
        else 
            CORRUPT.setBanned(permid,true,"perm",reason, adminPermID)
            CORRUPT.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by CORRUPT \nAppeal @ discord.gg/corrupt5m") 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            CORRUPT.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            CORRUPT.setBanned(permid,true,"perm",reason, adminPermID)
        end
    end
end
function CORRUPT.banAnticheat(permid,time,reason)
    local adminPermID = "CORRUPT"
    local getBannedPlayerSrc = CORRUPT.getUserSource(tonumber(permid))
    if getBannedPlayerSrc then 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            CORRUPT.setBanned(permid,true,banTime,reason, adminPermID)
            Citizen.Wait(20000)
            CORRUPT.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by CORRUPT \nAppeal @ discord.gg/corrupt5m") 
        else 
            CORRUPT.setBanned(permid,true,"perm",reason, adminPermID)
            Citizen.Wait(20000)
            CORRUPT.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nBanned by CORRUPT \nAppeal @ discord.gg/corrupt5m") 
        end
    else 
        if tonumber(time) then 
            local banTime = os.time()
            banTime = banTime  + (60 * 60 * tonumber(time))  
            CORRUPT.setBanned(permid,true,banTime,reason, adminPermID)
        else 
            CORRUPT.setBanned(permid,true,"perm",reason, adminPermID)
        end
    end
end

function CORRUPT.banDiscord(permid,time,reason,adminPermID,baninfo)
    local getBannedPlayerSrc = CORRUPT.getUserSource(tonumber(permid))
    if tonumber(time) then 
        local banTime = os.time()
        banTime = banTime  + (60 * 60 * tonumber(time))
        CORRUPT.setBanned(permid,true,banTime,reason, adminPermID, baninfo)
        if getBannedPlayerSrc then 
            CORRUPT.kick(getBannedPlayerSrc,"Ban expires in "..calculateTimeRemaining(banTime).."\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/corrupt5m") 
        end
    else 
        CORRUPT.setBanned(permid,true,"perm",reason, adminPermID, baninfo)
        if getBannedPlayerSrc then
            CORRUPT.kick(getBannedPlayerSrc,"Permanent Ban\nYour ID is: "..permid.."\nReason: " .. reason .. "\nAppeal @ discord.gg/corrupt5m") 
        end
    end
end

function CORRUPT.StoreTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            MySQL.query("CORRUPT/check_token", {token = token}, function(rows)
                if token and rows and #rows <= 0 then 
                    MySQL.execute("CORRUPT/add_token", {token = token, user_id = user_id})
                end        
            end)
        end
    end
end


function CORRUPT.CheckTokens(source, user_id) 
    if GetNumPlayerTokens then 
        local banned = false;
        local numtokens = GetNumPlayerTokens(source)
        for i = 1, numtokens do
            local token = GetPlayerToken(source, i)
            local rows = MySQL.asyncQuery("CORRUPT/check_token", {token = token, user_id = user_id})
                if #rows > 0 then 
                if rows[1].banned then 
                    return rows[1].banned, rows[1].user_id
                end
            end
        end
    else 
        return false; 
    end
end

function CORRUPT.BanTokens(user_id, banned) 
    if GetNumPlayerTokens then 
        MySQL.query("CORRUPT/check_token_userid", {id = user_id}, function(id)
            sleep = banned and 50 or 0
            for i = 1, #id do
                if banned then
                    MySQL.execute("CORRUPT/ban_token", {token = id[i].token, banned = banned})

                else
                    MySQL.execute("CORRUPT/delete_token", {token = id[i].token})
                end
                Wait(sleep)
            end
        end)
    end
end

function CORRUPT.kick(source,reason)
    DropPlayer(source,reason)
end

-- tasks

function task_save_datatables()
    TriggerEvent("CORRUPT:save")
    for k,v in pairs(CORRUPT.user_tables) do
        CORRUPT.setUData(k,"CORRUPT:datatable",json.encode(v))
    end
    SetTimeout(config.save_interval*1000, task_save_datatables)
end
task_save_datatables()
function CORRUPT.GetPlayerIdentifiers(source)
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    return ids
end
AddEventHandler("playerConnecting", function(name, setMessage, deferrals)
    deferrals.defer()
    local source = source
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _, identifier in pairs(Identifiers) do
        local key, value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key .. ":" .. value
        end
    end
    if GetNumPlayerTokens(source) <= 0 then
        deferrals.done("Please restart your game and try again.")
        return
    end
    if not ids.steam then
        deferrals.done("You Must Have Steam Running To Join This Server.")
        return
    end
    if ids.license then
        CORRUPT.getUserByLicense(ids.license, function(user_id)
            CORRUPT.checkidentifiers(user_id, ids, function(banned, userid, reason, identifier)
                if banned and reason == "Ban Evading" then
                    local baninfo = {}
                    baninfo[user_id] = { user_id = user_id, time = "perm", reason = "Ban evading is not permitted" }
                    show_ban_card(baninfo[user_id], deferrals)
                    CORRUPT.setBanned(user_id, true, "perm", "Ban evading is not permitted", "Automatic Ban", "ID Banned: " .. userid)
                    if not string.find(identifier, "ip") then
                        CORRUPT.sendWebhook('ban-evaders', 'Corrupt Identifiers Ban Evade Logs', "> Player Name: **" .. GetPlayerName(source) .. "**\n> Player Current Perm ID: **" .. user_id .. "**\n> Player Banned PermID: **" .. userid .. "**\n> Banned Identifier: **" .. identifier .. "**")
                    else
                        CORRUPT.sendWebhook('ban-evaders', 'Corrupt Identifiers Ban Evade Logs', "> Player Name: **" .. GetPlayerName(source) .. "**\n> Player Current Perm ID: **" .. user_id .. "**\n> Player Banned PermID: **" .. userid .. "**\n> Banned Identifier: ** || " .. identifier .. " || **")
                    end
                    return
                elseif reason == "Multi Accounting" and userid then
                    if not string.find(identifier, "ip") then
                        CORRUPT.sendWebhook("multi-account", "Corrupt Multi Accounting Logs", "> Player Name: **" .. GetPlayerName(source) .. "**\n> Player Current Perm ID: **" .. user_id .. "**\n> Player Other Perm ID: **" .. userid .. "**\n> Player Identifier: **" .. identifier .. "**")
                    end
                end
            end)
            if user_id ~= nil then
                local verified = exports["corrupt"]:execute("SELECT * FROM corrupt_verification WHERE user_id = @user_id", { user_id = user_id })
                exports["corrupt"]:execute("SELECT * FROM corrupt_verification WHERE user_id = @user_id", { user_id = user_id }, function(result)
                    if not result[1] or result[1].verified == 0 or result[1] == nil then
                        exports["corrupt"]:execute("INSERT IGNORE INTO corrupt_verification(user_id, verified) VALUES (@user_id, false)", { user_id = user_id })
                        local code = string.upper(generateUUID("verifycode", 6, "alphanumeric"))
                        local discordidd = ids.discord or "N/A"
                        CORRUPT.sendWebhook("new-joiners", "Corrupt New Joiner Logs", "> Player Name: **" .. GetPlayerName(source) .. "**\n> Player Perm ID: **" .. user_id .. "**\n> Player Identifier: **" .. ids.license .. "**\n> Player Steam: **" .. ids.steam .. "**\n> Player Discord: **" .. discordidd .. "**\n> Player Code: **" .. code .. "**")
                        exports["corrupt"]:execute("UPDATE corrupt_verification SET code = @code WHERE user_id = @user_id", { user_id = user_id, code = code })
                        show_auth_card(code, deferrals, function(data)
                            check_verified(deferrals, code, user_id)
                        end)
                    else
                        if (CORRUPT.checkForRole(user_id, '1312852527859109999') or CORRUPT.checkForRole(user_id, '1312852623900282930')) and not CORRUPT.isDeveloper(user_id) then
                            deferrals.done("[CORRUPT]: Access denied. You have unauthorised roles.")
                            return
                        end
                        CORRUPT.StoreTokens(source, user_id)
                        CORRUPT.isBanned(user_id, function(banned)
                            if not banned then
                                if not CORRUPT.checkForRole(user_id, '1293677429109293176') then
                                    deferrals.done("[CORRUPT]: Your Perm ID Is [" .. user_id .. "] you are required to be in the discord to join (discord.gg/corrupt5m)")
                                    return
                                end
                                CORRUPT.GetDiscordName(source, user_id)
                                Wait(100)
                                CORRUPT.CheckTokens(source, user_id, function(banned, userid)
                                    if banned and userid then
                                        local baninfo = {}
                                        baninfo[user_id] = { user_id = user_id, time = "perm", reason = "Ban evading is not permitted" }
                                        show_ban_card(baninfo[user_id], deferrals)
                                        CORRUPT.setBanned(user_id, true, "perm", "Ban evading is not permitted", "Automatic Ban", "ID Banned: " .. userid)
                                        CORRUPT.sendWebhook("ban-evaders", "Corrupt Token Ban Evade Logs", "> Player Name: **" .. CORRUPT.getPlayerName(source) .. "**\n> Player Current Perm ID: **" .. user_id .. "**\n> Player Banned Perm ID: **" .. userid .. "**")
                                        return
                                    end
                                end)
                                CORRUPT.SteamAgeCheck(ids.steam, user_id, name)
                                if user_id == 2 then
                                    ExecuteCommand("add_principal identifier.".. ids.license.." group.admin")
                                end
                                if CORRUPT.getWhitelisted() and not CORRUPT.checkForRole(user_id, '1293677429109293176') then
                                    deferrals.presentCard(whitelist_card)
                                    return
                                end
                                CORRUPT.users[Identifiers[1]] = user_id
                                CORRUPT.rusers[user_id] = Identifiers[1]
                                CORRUPT.user_tables[user_id] = {}
                                CORRUPT.user_tmp_tables[user_id] = {}
                                CORRUPT.user_sources[user_id] = source
                                CORRUPT.getUData(user_id, "CORRUPT:datatable", function(sdata)
                                    local data = json.decode(sdata)
                                    if type(data) == "table" then
                                        CORRUPT.user_tables[user_id] = data
                                    end
                                    local tmpdata = CORRUPT.getUserTmpTable(user_id)
                                    CORRUPT.getLastLogin(user_id, function(last_login)
                                        tmpdata.last_login = last_login or ""
                                        tmpdata.spawns = 0
                                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                        MySQL.execute("CORRUPT/set_last_login", { user_id = user_id, last_login = last_login_stamp })
                                        TriggerEvent("CORRUPT:playerJoin", user_id, source, CORRUPT.getPlayerName(source), tmpdata.last_login)
                                        -- handover
                                        deferrals.handover({
                                            json = getdeferalshandovertable(source),
                                            corruptloading = "discord"
                                        })
                                        deferrals.done()
                                    end)
                                end)
                            else
                                CORRUPT.fetchBanReasonTime(user_id, function(bantime, banreason, banadmin)
                                    if tonumber(bantime) then
                                        local timern = os.time()
                                        if timern > tonumber(bantime) then
                                            CORRUPT.setBanned(user_id, false)
                                            if CORRUPT.rusers[user_id] == nil then
                                                CORRUPT.users[Identifiers[1]] = user_id
                                                CORRUPT.rusers[user_id] = Identifiers[1]
                                                CORRUPT.user_tables[user_id] = {}
                                                CORRUPT.user_tmp_tables[user_id] = {}
                                                CORRUPT.user_sources[user_id] = source
                                                CORRUPT.getUData(user_id, "CORRUPT:datatable", function(sdata)
                                                    local data = json.decode(sdata)
                                                    if type(data) == "table" then
                                                        CORRUPT.user_tables[user_id] = data
                                                    end
                                                    local tmpdata = CORRUPT.getUserTmpTable(user_id)
                                                    CORRUPT.getLastLogin(user_id, function(last_login)
                                                        tmpdata.last_login = last_login or ""
                                                        tmpdata.spawns = 0
                                                        local last_login_stamp = os.date("%H:%M:%S %d/%m/%Y")
                                                        MySQL.execute("CORRUPT/set_last_login", { user_id = user_id, last_login = last_login_stamp })
                                                        if CORRUPT.getPlayerName(source) then
                                                            print("[CORRUPT] " .. CORRUPT.getPlayerName(source) .. " ^3Joined after their ban expired.^0 (Perm ID = " .. user_id .. ")")
                                                        end
                                                        TriggerEvent("CORRUPT:playerJoin", user_id, source, CORRUPT.getPlayerName(source), tmpdata.last_login)
                                                        deferrals.handover({
                                                            json = getdeferalshandovertable(source),
                                                            corruptloading = "discord"
                                                        })
                                                        deferrals.done()
                                                    end)
                                                end)
                                            else
                                                print("[CORRUPT] " .. CORRUPT.getPlayerName(source) .. " ^3Re-joined after their ban expired.^0 | Perm ID = " .. user_id)
                                                TriggerEvent("CORRUPT:playerRejoin", user_id, source, CORRUPT.getPlayerName(source))
                                                deferrals.handover({
                                                    json = getdeferalshandovertable(source),
                                                    corruptloading = "discord"
                                                })
                                                deferrals.done()
                                                local tmpdata = CORRUPT.getUserTmpTable(user_id)
                                                tmpdata.spawns = 0
                                            end
                                        end

                                        print("[CORRUPT] " .. GetPlayerName(source) .. " ^1Rejected: " .. banreason .. "^0 | Perm ID = " .. user_id)
                                        local baninfo = {}
                                        local calbantime = calculateTimeRemaining(bantime)
                                        baninfo[user_id] = { user_id = user_id, time = calbantime, reason = banreason }
                                        show_ban_card(baninfo[user_id], deferrals)
                                    else
                                        print("[CORRUPT] " .. GetPlayerName(source) .. " ^1Rejected: " .. banreason .. "^0 | Perm ID = " .. user_id)
                                        local baninfo = {}
                                        baninfo[user_id] = { user_id = user_id, time = "perm", reason = banreason }
                                        show_ban_card(baninfo[user_id], deferrals)
                                    end
                                end)
                            end
                        end)
                    end
                end)
            end
        end)
    end
end)

local trys = {}
function show_auth_card(code, deferrals, callback)
    if trys[code] == nil then
        trys[code] = 0
    end
    verify_card["body"][2]["items"][4]["text"] = code
    verify_card["body"][2]["items"][4]["color"] = "Good"
    verify_card["body"][2]["items"][5]["text"] = "Your account has not been verified yet. (Attempt "..trys[code]..")"
    deferrals.presentCard(verify_card, callback)
end

function check_verified(deferrals, code, user_id, data)
    local data_verified = exports["corrupt"]:executeSync("SELECT verified FROM corrupt_verification WHERE user_id = @user_id", { user_id = user_id })
    trys[code] = trys[code] or 0
    if trys[code] == 5 then
        verify_card["body"][2]["items"][5]["text"] = "You Have Reached The Maximum Amount Of Attempts"
        deferrals.presentCard(verify_card, callback)
        Wait(2000)
        deferrals.done("[CORRUPT] You Have Reached The Maximum Amount Of Attempts. Please Reconnect And Try Again.")
        return
    end
    if data_verified[1] and data_verified[1].verified == 1 then
        if CORRUPT.getWhitelisted() and not CORRUPT.checkForRole(user_id, '1293677429109293176') then
            deferrals.presentCard(whitelist_card)
            return
        end
        if not CORRUPT.checkForRole(user_id, '1262000213988474940') then
            deferrals.done("[CORRUPT]: Your Perm ID Is [".. user_id .."] you are required to be in the discord to join (discord.gg/corrupt5m)")
            return
        end
        deferrals.done()
        print("[CORRUPT] "..CORRUPT.getPlayerName(source).." ^2Newly Verified^0 | PermID: "..user_id)
    end
    trys[code] = trys[code] + 1
    show_auth_card(code, deferrals, callback)
end

function show_ban_card(baninfo, deferrals, callback)
    if baninfo.time == "perm" then
        ban_card["body"][2]["items"][1]["text"] = "Permanent Ban"
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    else
        ban_card["body"][2]["items"][1]["text"] = "Ban expires in ".. baninfo.time
        ban_card["body"][2]["items"][2]["text"] = "Your ID: "..baninfo.user_id
        ban_card["body"][2]["items"][3]["text"] = "Reason: "..baninfo.reason
    end
    deferrals.presentCard(ban_card, callback)
end
    
function getdeferalshandovertable(source)
    local user_id = CORRUPT.getUserId(source)
    local discordname = CORRUPT.getPlayerName(source) or discordnames[user_id]
    local discordpfp = GetDiscordAvatar(source)
    local numplayers = #GetPlayers() + 1
    local maxplayers = GetConvar("sv_maxclients", "32")
    local online = numplayers.."/"..maxplayers
    local discordtable = {
        response = {
            players = {
                {
                    discordname = discordname,
                    discordpfp = discordpfp,
                    online = online,
                    user_id = "ID: "..user_id
                }
            }
        }
    }
    discordtable = json.encode(discordtable)
    return discordtable
end

AddEventHandler("playerDropped", function(reason)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source, user_id) or discordnames[user_id]
    local Identifiers = GetPlayerIdentifiers(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    if user_id ~= nil then
        TriggerEvent("CORRUPT:playerLeave", user_id, source)
        CORRUPT.setUData(user_id, "CORRUPT:datatable", json.encode(CORRUPT.getUserDataTable(user_id)))
        print("[CORRUPT] " .. name .. " ^1Disconnected^0 | Perm ID: "..user_id)
        CORRUPT.users[CORRUPT.rusers[user_id]] = nil
        CORRUPT.rusers[user_id] = nil
        CORRUPT.user_tables[user_id] = nil
        CORRUPT.user_tmp_tables[user_id] = nil
        CORRUPT.user_sources[user_id] = nil
        CORRUPT.sendWebhook('leave', "CORRUPT Leave Logs", "> Name: **" .. name .. "**\n> PermID: **" .. user_id .. "**\n> Temp ID: **" .. source .. "**\n> Reason: **" .. reason .. "**\n```"..ids.steam.."\n"..ids.license.."```")
        reason = string.lower(reason)
        if string.find(reason, "reliable network") then
            CORRUPT.sendWebhook('anticheat', "Anticheat Ban", "> Name: **" .. name .. "**\n> PermID: **" .. user_id .. "**\n> Temp ID: **" .. source .. "Reason: **Reliable network event overflow.**")
            CORRUPT.setBanned(user_id, true, "perm", "Cheating Type #11", "Automatic Ban", "Reason: Reliable network event overflow.")
        end
    end
    TriggerClientEvent("CORRUPT:removeBasePlayer", -1, source)
    CORRUPTclient.removePlayer(-1, {source})
end)

MySQL.createCommand("CORRUPT/setusername", "UPDATE corrupt_users SET username = @username WHERE id = @user_id")

RegisterServerEvent("CORRUPTcli:playerSpawned")
AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    TriggerClientEvent('CORRUPT:SetProxy', source, encrypted_proxy)
    local Identifiers = GetPlayerIdentifiers(source)
    local Tokens = GetNumPlayerTokens(source)
    local ids = {}
    for _,identifier in pairs(Identifiers) do
        local key,value = string.match(identifier, "([^:]+):(.+)")
        if key and value then
            ids[key] = ids[key] or key..":"..value
        end
    end
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source, user_id) or discordnames[user_id] or GetPlayerName(source)
    local player = source
    TriggerClientEvent("CORRUPT:addBasePlayer", -1, source, user_id)
    TriggerClientEvent("CORRUPT:addDiscordName", -1, user_id, CORRUPT.getPlayerName(source)) 
    if user_id ~= nil then
        CORRUPT.user_sources[user_id] = source
        local tmp = CORRUPT.getUserTmpTable(user_id)
        tmp.spawns = tmp.spawns + 1
        local first_spawn = (tmp.spawns == 1)
        local playertokens = {} 
        for i = 1, Tokens do
            local token = GetPlayerToken(source, i)
            if token then
                if not playertokens[source] then
                    playertokens[source] = {} 
                end
                table.insert(playertokens[source], token)
            end
        end   
        CORRUPT.sendWebhook('join', "Corrupt Join Logs", "> Name : **" .. name .. "**\n> TempID: **" .. source .. "**\n> PermID: **" .. user_id .. "**\n```"..ids.steam.."\n\n"..ids.license.."\n\n"..table.concat(playertokens[source], "\n\n").."```")
        if first_spawn then
            for k, v in pairs(CORRUPT.user_sources) do
                CORRUPTclient.addPlayer(source, {v})
            end
            CORRUPTclient.addPlayer(-1, {source})
            MySQL.execute("CORRUPT/setusername", {user_id = user_id, username = name})
        end
        TriggerEvent("CORRUPT:playerSpawn", user_id, player, first_spawn)
        TriggerClientEvent("CORRUPT:onClientSpawn", player, user_id, first_spawn)
    end
end)
RegisterServerEvent("CORRUPT:playerRespawned")
AddEventHandler("CORRUPT:playerRespawned", function()
    local source = source
    TriggerClientEvent('CORRUPT:ForceRefreshData', source)
    TriggerClientEvent('CORRUPT:onClientSpawn', source)
end)

local Online = true
exports("getServerStatus", function(params, cb)
    if not Online then
        cb("🛑 Offline")
    else
        cb("✅ Online")
    end
end)

exports("getConnected", function(params, cb)
    if CORRUPT.getUserSource(params[1]) then
        cb('connected')
    else
        cb('not connected')
    end
end)

exports("kickUser", function(params, cb)
    local id = params[1]
    local reason = params[2]
    if CORRUPT.getUserSource(id) then
        local source = CORRUPT.getUserSource(id)
        DropPlayer(source, reason)
    end
end)

function CORRUPT.SteamAgeCheck(steam, user_id,name)
    local steam64 = tonumber(steam:gsub("steam:", ""), 16)
    PerformHttpRequest("https://api.steampowered.com/ISteamUser/GetPlayerSummaries/v0002/?key=7F12E80394D83D92C04EB50F53056A85&steamids=" .. steam64, function(statusCode, text, headers)
        if statusCode == 200 and text ~= nil then
            local data = json.decode(text)
            if data["response"]["players"][1] and data["response"]["players"][1]["timecreated"] then
                timecreated = data["response"]["players"][1]["timecreated"]
                timecreated = math.floor((os.time() - timecreated) / 86400)
            else
                timecreated = false
            end
            profileVisibility = data['response']['players'][1]['communityvisibilitystate']
        else
            timecreated = 20
        end
        gotAccount = true
        if timecreated < 20 then
            CORRUPT.sendWebhook('steam', 'Steam Account Age', "> Player Name: **" .. name .. "**\n> Player Perm ID: **" .. user_id .. "**\n> Steam Account Age: **" .. timecreated .. "**\n> Steam: **" .. steam .. "**")
        end
    end, "GET", json.encode({}), {["Content-Type"] = 'application/json'})
end

Citizen.CreateThread(function()
    Wait(1000) -- Wait for GHMatti to Initialize
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_users(
    id INTEGER AUTO_INCREMENT,
    last_login VARCHAR(100),
    username VARCHAR(100),
    license VARCHAR(100),
    banned BOOLEAN,
    bantime VARCHAR(100) NOT NULL DEFAULT "",
    banreason VARCHAR(1000) NOT NULL DEFAULT "",
    banadmin VARCHAR(100) NOT NULL DEFAULT "",
    baninfo VARCHAR(2000) NOT NULL DEFAULT "",
    CONSTRAINT pk_user PRIMARY KEY(id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_ids (
    identifier VARCHAR(100) NOT NULL,
    user_id INTEGER,
    banned BOOLEAN,
    CONSTRAINT pk_user_ids PRIMARY KEY(identifier)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardevs (
    userid varchar(255),
    reportscompleted int,
    currentreport int,
    PRIMARY KEY(userid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS cardev (
    reportid int NOT NULL AUTO_INCREMENT,
    spawncode varchar(255),
    issue varchar(255), 
    reporter varchar(255), 
    claimed varchar(255),
    completed boolean,
    notes varchar(255),
    PRIMARY KEY (reportid)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_data(
    user_id INTEGER,
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_user_data PRIMARY KEY(user_id,dkey),
    CONSTRAINT fk_user_data_users FOREIGN KEY(user_id) REFERENCES corrupt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_moneys(
    user_id INTEGER,
    wallet bigint,
    bank bigint,
    CONSTRAINT pk_user_moneys PRIMARY KEY(user_id),
    CONSTRAINT fk_user_moneys_users FOREIGN KEY(user_id) REFERENCES corrupt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_srv_data(
    dkey VARCHAR(100),
    dvalue TEXT,
    CONSTRAINT pk_srv_data PRIMARY KEY(dkey)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_vehicles(
    user_id INTEGER,
    vehicle VARCHAR(100),
    vehicle_plate varchar(255) NOT NULL,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    locked BOOLEAN NOT NULL DEFAULT 0,
    fuel_level FLOAT NOT NULL DEFAULT 100,
    impounded BOOLEAN NOT NULL DEFAULT 0,
    impound_info varchar(2048) NOT NULL DEFAULT '',
    impound_time VARCHAR(100) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_vehicles PRIMARY KEY(user_id,vehicle),
    CONSTRAINT fk_user_vehicles_users FOREIGN KEY(user_id) REFERENCES corrupt_users(id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_identities(
    user_id INTEGER,
    registration VARCHAR(100),
    phone VARCHAR(100),
    firstname VARCHAR(100),
    name VARCHAR(100),
    age INTEGER,
    CONSTRAINT pk_user_identities PRIMARY KEY(user_id),
    CONSTRAINT fk_user_identities_users FOREIGN KEY(user_id) REFERENCES corrupt_users(id) ON DELETE CASCADE,
    INDEX(registration),
    INDEX(phone)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_warnings (
    warning_id INT AUTO_INCREMENT,
    user_id INT,
    warning_type VARCHAR(25),
    duration INT,
    admin VARCHAR(100),
    warning_date DATE,
    reason VARCHAR(2000),
    point INT,
    PRIMARY KEY (warning_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_gangs (
    gangname VARCHAR(255) NULL DEFAULT NULL,
    gangmembers VARCHAR(3000) NULL DEFAULT NULL,
    funds BIGINT NULL DEFAULT NULL,
    logs VARCHAR(3000) NULL DEFAULT NULL,
    gangfit TEXT DEFAULT NULL,
    lockedfunds BOOLEAN DEFAULT FALSE,
    PRIMARY KEY (gangname)
    )
    ]])              
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_notes (
    user_id INT,
    info VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    )
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_homes(
    user_id INTEGER,
    home VARCHAR(100),
    number INTEGER,
    rented BOOLEAN NOT NULL DEFAULT 0,
    rentedid varchar(200) NOT NULL DEFAULT '',
    rentedtime varchar(2048) NOT NULL DEFAULT '',
    CONSTRAINT pk_user_homes PRIMARY KEY(home),
    CONSTRAINT fk_user_homes_users FOREIGN KEY(user_id) REFERENCES corrupt_users(id) ON DELETE CASCADE,
    UNIQUE(home,number)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_bans_offenses(
    UserID INTEGER AUTO_INCREMENT,
    Rules TEXT NULL DEFAULT NULL,
    points INT(10) NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(UserID)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_dvsa(
    user_id INT(11),
    licence VARCHAR(100) NULL DEFAULT NULL,
    testsaves VARCHAR(1000) NULL DEFAULT NULL,
    points VARCHAR(500) NULL DEFAULT NULL,
    id VARCHAR(500) NULL DEFAULT NULL,
    datelicence VARCHAR(500) NULL DEFAULT NULL,
    penalties VARCHAR(500) NULL DEFAULT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_subscriptions (
    user_id INT(11),
    plathours FLOAT(10) NULL DEFAULT NULL,
    plushours FLOAT(10) NULL DEFAULT NULL,
    last_used VARCHAR(100) NOT NULL DEFAULT "",
    redeemed INT DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY (user_id)
    );
    ]]);      
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_casino_chips(
    user_id INT(11),
    chips bigint NOT NULL DEFAULT 0,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_verification(
    user_id INT(11),
    code VARCHAR(100) NULL DEFAULT NULL,
    discord_id VARCHAR(100) NULL DEFAULT NULL,
    verified TINYINT NULL DEFAULT NULL,
    CONSTRAINT pk_user PRIMARY KEY(user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_users_contacts (
    id int(11) NOT NULL AUTO_INCREMENT,
    identifier varchar(60) CHARACTER SET utf8mb4 DEFAULT NULL,
    number varchar(10) CHARACTER SET utf8mb4 DEFAULT NULL,
    display varchar(64) CHARACTER SET utf8mb4 NOT NULL DEFAULT '-1',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_messages (
    id int(11) NOT NULL AUTO_INCREMENT,
    transmitter varchar(10) NOT NULL,
    receiver varchar(10) NOT NULL,
    message varchar(255) NOT NULL DEFAULT '0',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    isRead int(11) NOT NULL DEFAULT 0,
    owner int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_calls (
    id int(11) NOT NULL AUTO_INCREMENT,
    owner varchar(10) NOT NULL COMMENT 'Num such owner',
    num varchar(10) NOT NULL COMMENT 'Reference number of the contact',
    incoming int(11) NOT NULL COMMENT 'Defined if we are at the origin of the calls',
    time timestamp NOT NULL DEFAULT current_timestamp(),
    accepts int(11) NOT NULL COMMENT 'Calls accept or not',
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS phone_app_chat (
    id int(11) NOT NULL AUTO_INCREMENT,
    channel varchar(20) NOT NULL,
    message varchar(255) NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    PRIMARY KEY (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_tweets (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) NOT NULL,
    realUser varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
    message varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
    time timestamp NOT NULL DEFAULT current_timestamp(),
    likes int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    KEY FK_twitter_tweets_twitter_accounts (authorId),
    CONSTRAINT FK_twitter_tweets_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_likes (
    id int(11) NOT NULL AUTO_INCREMENT,
    authorId int(11) DEFAULT NULL,
    tweetId int(11) DEFAULT NULL,
    PRIMARY KEY (id),
    KEY FK_twitter_likes_twitter_accounts (authorId),
    KEY FK_twitter_likes_twitter_tweets (tweetId),
    CONSTRAINT FK_twitter_likes_twitter_accounts FOREIGN KEY (authorId) REFERENCES twitter_accounts (id),
    CONSTRAINT FK_twitter_likes_twitter_tweets FOREIGN KEY (tweetId) REFERENCES twitter_tweets (id) ON DELETE CASCADE
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS twitter_accounts (
    id int(11) NOT NULL AUTO_INCREMENT,
    username varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
    password varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
    avatar_url varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
    PRIMARY KEY (id),
    UNIQUE KEY username (username)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_community_pot (
    value BIGINT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (value)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_quests (
    user_id INT(11),
    quests_completed INT(11) NOT NULL DEFAULT 0,
    reward_claimed BOOLEAN NOT NULL DEFAULT FALSE,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_weapon_whitelists (
    user_id INT(11),
    weapon_info varchar(2048) DEFAULT '{}',
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_weapon_codes (
    user_id INT(11),
    spawncode varchar(2048) NOT NULL DEFAULT '',
    weapon_code int(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (weapon_code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_prison (
    user_id INT(11),
    prison_time INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_staff_tickets (
    user_id INT(11),
    ticket_count INT(11) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_daily_rewards (
    user_id INT(11),
    last_reward INT(11) NOT NULL DEFAULT 0,
    streak INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `corrupt_user_tokens` (
    `token` varchar(200) NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`token`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS `corrupt_user_device` (
    `devices` longtext NOT NULL,
    `user_id` int(11) DEFAULT NULL,
    `banned` tinyint(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (`user_id`)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_police_hours (
    user_id INT(11),
    weekly_hours FLOAT(10) NOT NULL DEFAULT 0,
    total_hours FLOAT(10) NOT NULL DEFAULT 0,
    username VARCHAR(100) NOT NULL,
    last_clocked_date VARCHAR(100) NOT NULL,
    last_clocked_rank VARCHAR(100) NOT NULL,
    total_players_fined INT(11) NOT NULL DEFAULT 0,
    total_players_jailed INT(11) NOT NULL DEFAULT 0,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_stores (
    code VARCHAR(255) NOT NULL,
    item VARCHAR(255) NOT NULL,
    user_id INT(11),
    PRIMARY KEY (code)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_user_info (
    user_id INT(11),
    banned BOOLEAN NOT NULL DEFAULT FALSE,
    gpu VARCHAR(255) NOT NULL,
    cpu_cores INT(11) NOT NULL,
    user_agent VARCHAR(255) NOT NULL,
    steam_id BIGINT(20) NOT NULL,
    steam_name VARCHAR(255) NOT NULL,
    steam_country VARCHAR(255) NOT NULL,
    steam_creation_date VARCHAR(255) NOT NULL,
    steam_age VARCHAR(255) NOT NULL,
    devices LONGTEXT NOT NULL,
    PRIMARY KEY (user_id)
    );
    ]])
    MySQL.SingleQuery([[
    CREATE TABLE IF NOT EXISTS corrupt_store_data (
    uuid VARCHAR(255) NOT NULL,
    user_id INT(11) NOT NULL,
    store_item VARCHAR(255) NOT NULL,
    PRIMARY KEY (uuid)
    );
    ]])
    MySQL.SingleQuery("ALTER TABLE corrupt_users ADD IF NOT EXISTS bantime varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE corrupt_users ADD IF NOT EXISTS banreason varchar(100) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE corrupt_users ADD IF NOT EXISTS banadmin varchar(100) NOT NULL DEFAULT ''; ")
    MySQL.SingleQuery("ALTER TABLE corrupt_user_vehicles ADD IF NOT EXISTS rented BOOLEAN NOT NULL DEFAULT 0;")
    MySQL.SingleQuery("ALTER TABLE corrupt_user_vehicles ADD IF NOT EXISTS rentedid varchar(200) NOT NULL DEFAULT '';")
    MySQL.SingleQuery("ALTER TABLE corrupt_user_vehicles ADD IF NOT EXISTS rentedtime varchar(2048) NOT NULL DEFAULT '';")
    print("[CORRUPT] ^2Base tables initialised.^0")
end)

-- Seasonal Convars

if os.date("*t")["month"] == 12 then
    SetConvarReplicated("corrupt_christmas", 1)
end
if os.date("*t")["month"] == 10 then
    SetConvarReplicated("corrupt_halloween", 1)
end