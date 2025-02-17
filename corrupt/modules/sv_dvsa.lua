local currenttests = {}
local dvscorruptdule = module("cfg/cfg_dvsa")


local dvsaAlerts = {
    --{title = 'DVSA', message = 'No current alerts.', date = 'Wednesday 7th September 2022'},
}

RegisterServerEvent("CORRUPT:DVSASpawned", function(source, user_id)
    if source == nil then return end
    if user_id == nil then return end
    exports['corrupt']:execute("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if next(result) then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    local data1 = {}
                    local licence = {}
                    local date = os.date("%d/%m/%Y")
                    local updateddata = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
                    if updateddata ~= nil then
                        licence = {
                            ["banned"] = updateddata.licence == "banned",
                            ["full"] = updateddata.licence == "full",
                            ["active"] = updateddata.licence == "active",
                            ["points"] = updateddata.points or 0,
                            ["id"] = updateddata.id or "No Licence",
                            ["date"] = date or os.date("%d/%m/%Y")
                        }
                    end
                    if updateddata.penalties == nil then
                        updateddata.penalties = {}
                    end
                    if updateddata.testsaves == nil then
                        updateddata.testsaves = {}
                    end
                    TriggerClientEvent('CORRUPT:dvsaData',source,licence,updateddata.penalties,updateddata.testsaves,dvsaAlerts)
                    return
                end
            end
        else
            exports['corrupt']:execute("INSERT INTO corrupt_dvsa (user_id,licence,datelicence) VALUES (@user_id, 'none',"..os.date("%d/%m/%Y")..")", {user_id = user_id})
            local data1 = {}
            local licence = {}
            local date = os.date("%d/%m/%Y")
            local updateddata = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
            if updateddata ~= nil then
                licence = {
                    ["banned"] = updateddata.licence == "banned",
                    ["full"] = updateddata.licence == "full",
                    ["active"] = updateddata.licence == "active",
                    ["points"] = updateddata.points or 0,
                    ["id"] = updateddata.id or "No Licence",
                    ["date"] = date or os.date("%d/%m/%Y")
                }
            end
            TriggerClientEvent('CORRUPT:dvsaData',source,licence,{},{},dvsaAlerts)
            return
        end
    end)
end)

function dvsaUpdate(user_id)
    local source = CORRUPT.getUserSource(user_id)
    local data = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    local licence = {}
    local date = os.date("%d/%m/%Y")
    if data ~= nil then
        licence = {
            ["banned"] = data.licence == "banned",
            ["full"] = data.licence == "full",
            ["active"] = data.licence == "active",
            ["points"] = data.points or 0,
            ["id"] = data.id or "No Licence",
            ["date"] = date or os.date("%d/%m/%Y")
        }
    end
    TriggerClientEvent('CORRUPT:updateDvsaData',source,licence,json.decode(data.penalties),json.decode(data.testsaves),dvsaAlerts)
end
RegisterServerEvent("CORRUPT:dvsaBucket")
AddEventHandler("CORRUPT:dvsaBucket", function(bool)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if bool then
        if currenttests[user_id] ~= nil then
            currenttests[user_id] = nil
        end
        CORRUPT.setBucket(source, 0)
    elseif not bool then
        if currenttests[user_id] ~= nil then
            CORRUPT.notify(source,{'You already have a test in progress.'})
            return
        end
        local bucket = math.random(21,300)
        local highestcount = 21
        if table.count(currenttests) > 0 then
            for k,v in pairs(currenttests) do
                if v.bucket == bucket then
                    repeat highestcount = math.random(21,300) until highestcount ~= bucket
                end
            end
        end
        currenttests[user_id] = {
            ["bucket"] = highestcount
        }
        CORRUPT.setBucket(source, currenttests[user_id].bucket)
    end
end)

RegisterServerEvent("CORRUPT:candidatePassed")
AddEventHandler("CORRUPT:candidatePassed", function(seriousissues,minorissues,minorreasons)
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT * FROM corrupt_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, minor = minorissues, minorsReason = minorreasons, pass = true}) 
        else
            table.insert(previoustests, {date = localday, serious = seriousissues,  minor = minorissues, minorsReason = minorreasons, pass = true})
        end
        if licence == "active" then
            exports['corrupt']:execute("UPDATE corrupt_dvsa SET licence = 'full', testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("CORRUPT:candidateFailed")
AddEventHandler("CORRUPT:candidateFailed", function(seriousissues,minorissues,seriousreasons,minorreasons)    
    local localday = os.date("%A (%d/%m/%Y) at %X")
    local source = source
    local licence
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute('SELECT * FROM corrupt_dvsa WHERE user_id = @user_id', {user_id = user_id}, function(GotLicence)
        licence = GotLicence[1].licence
        local previoustests = {}
        local testsaves = json.decode(GotLicence[1].testsaves)
        if testsaves ~= nil then
            previoustests = testsaves
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        else
            table.insert(previoustests, {date = localday, serious = seriousissues, seriousReason = seriousreasons, minor = minorissues, minorsReason = minorreasons})
        end
        if licence == "active" then
            exports['corrupt']:execute("UPDATE corrupt_dvsa SET testsaves = @testsaves WHERE user_id = @user_id", {user_id = user_id,testsaves=json.encode(previoustests)}, function() end)
            Wait(100)
            dvsaUpdate(user_id)
        end
    end)
end)

RegisterServerEvent("CORRUPT:beginTest")
AddEventHandler("CORRUPT:beginTest", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local data = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == ("full" or "banned") then
        TriggerClientEvent('CORRUPT:beginTestClient', source, false)
        return
    end
    if data.licence == "active" then
        TriggerClientEvent('CORRUPT:beginTestClient', source,true,math.random(1,3))
    else
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to Trigger Driving Test with a non-active licence.')
    end
end)

RegisterServerEvent("CORRUPT:surrenderLicence")
AddEventHandler("CORRUPT:surrenderLicence", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data.licence == "banned" then
        CORRUPT.notify(source,{'You are already banned from driving.'})
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to surrender licence when already banned.')
        return
    end
    if data.licence == "active" or data.licence == "full" then
        exports['corrupt']:execute("UPDATE corrupt_dvsa SET licence = @licence WHERE user_id = @user_id", {licence = "none", user_id = user_id})
        exports['corrupt']:execute("UPDATE corrupt_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("CORRUPT:activateLicence")
AddEventHandler("CORRUPT:activateLicence", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local uuid = math.random(1,9999999999)
    local data = exports['corrupt']:executeSync("SELECT * FROM corrupt_dvsa WHERE user_id = @user_id", {user_id = user_id})[1]
    if data == nil then return end
    if data.licence == "none" then
        exports['corrupt']:execute("UPDATE corrupt_dvsa SET licence = @licence, datelicence = @datelicense WHERE user_id = @user_id", {licence = "active", datelicense = os.date("%d/%m/%Y"), user_id = user_id})
        exports['corrupt']:execute("UPDATE corrupt_dvsa SET id = @id WHERE user_id = @user_id", {id = uuid, user_id = user_id})
        Wait(100)
        dvsaUpdate(user_id)
    end
end)

RegisterServerEvent("CORRUPT:speedCameraFlashServer",function(speed)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local name = CORRUPT.getPlayerName(source)
    local bank = CORRUPT.getBankMoney(user_id)
    local speed = tonumber(speed)
    local overspeed = speed-100
    local fine = 10000
    if CORRUPT.hasPermission(user_id,"police.armoury") then
        return
    end
    if tonumber(bank) > fine then
        CORRUPT.setBankMoney(user_id,bank-fine)
        TriggerEvent('CORRUPT:addToCommunityPot', fine)
        TriggerClientEvent('CORRUPT:dvsaMessage', source,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..overspeed.."MPH over the speed limit.")
        return
    else
        CORRUPT.notify(source,{'You could not afford the fine. Benefits paid.'})
        return
    end
end)

RegisterServerEvent('CORRUPT:speedGunFinePlayer')
AddEventHandler('CORRUPT:speedGunFinePlayer', function(temp, speed)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
      local fine = speed*100
      CORRUPT.tryBankPayment(CORRUPT.getUserId(temp), fine)
      TriggerClientEvent('CORRUPT:speedGunPlayerFined', temp)
      TriggerClientEvent('CORRUPT:dvsaMessage', temp,"DVSA","UK Government","You were fined £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit.")
      CORRUPT.notify(source, { "Fined "..CORRUPT.getPlayerName(temp).." £"..getMoneyStringFormatted(fine).." for going "..speed.."MPH over the speed limit."})
    end
end)

local speedTraps = {}
RegisterCommand('setup', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        if speedTraps[user_id] then
            CORRUPTclient.removeBlipAtCoords(-1,speedTraps[user_id])
            speedTraps[user_id] = nil
            CORRUPT.notify(source,{'Speed Trap Removed.'})
        else
            local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(source)))
            CORRUPTclient.addBlip(-1,{x,y,z,419,0,"Speed Camera",2.5})
            speedTraps[user_id] = {x,y,z}
            CORRUPT.notify(source,{'~g~Speed Trap Setup.'})
        end
    end
end)