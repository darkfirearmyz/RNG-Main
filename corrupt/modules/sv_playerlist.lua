local pdGroups = {
    ["Commissioner Clocked"]=true,
    ["Deputy Commissioner Clocked"] =true,
    ["Assistant Commissioner Clocked"]=true,
    ["Dep. Asst. Commissioner Clocked"] =true,
    ["GC Advisor Clocked"] =true,
    ["Commander Clocked"]=true,
    ["Chief Superintendent Clocked"]=true,
    ["Superintendent Clocked"]=true,
    ["Chief Inspector Clocked"]=true,
    ["Inspector Clocked"]=true,
    ["Sergeant Clocked"]=true,
    ["Senior Constable Clocked"]=true,
    ["PC Clocked"]=true,
    ["PCSO Clocked"]=true,
    ["Special Constable Clocked"]=true,
    ["NPAS Clocked"]=true,
}
local nhsGroups = {
    ["NHS Trainee Paramedic Clocked"] = true,
    ["NHS Paramedic Clocked"] = true,
    ["NHS Critical Care Paramedic Clocked"] = true,
    ["NHS Junior Doctor Clocked"] = true,
    ["NHS Doctor Clocked"] = true,
    ["NHS Senior Doctor Clocked"] = true,
    ["NHS Specialist Doctor Clocked"] = true,
    ["NHS Surgeon Clocked"] = true,
    ["NHS Specialist Surgeon Clocked"] = true,
    ["NHS Assistant Medical Director Clocked"] = true,
    ["NHS Deputy Medical Director Clocked"] = true,
    ["NHS Head Chief Clocked"] = true,
    ["HEMS Clocked"]=true,
}
local lfbGroups = {
    ["Provisional Firefighter Clocked"] = true,
    ["Junior Firefighter Clocked"] = true,
    ["Firefighter Clocked"] = true,
    ["Senior Firefighter Clocked"] = true,
    ["Advanced Firefighter Clocked"] = true,
    ["Specalist Firefighter Clocked"] = true,
    ["Leading Firefighter Clocked"] = true,
    ["Sector Command Clocked"] = true,
    ["Divisional Command Clocked"] = true,
    ["Chief Fire Command Clocked"] = true
}
local hmpGroups = {
    ["Governor Clocked"] = true,
    ["Deputy Governor Clocked"] = true,
    ["Divisional Commander Clocked"] = true,
    ["Custodial Supervisor Clocked"] = true,
    ["Custodial Officer Clocked"] = true,
    ["Honourable Guard Clocked"] = true,
    ["Supervising Officer Clocked"] = true,
    ["Principal Officer Clocked"] = true,
    ["Specialist Officer Clocked"] = true,
    ["Senior Officer Clocked"] = true,
    ["Prison Officer Clocked"] = true,
    ["Trainee Prison Officer Clocked"] = true
}
local defaultGroups = {
    ["Royal Mail Driver"] = true,
    ["Bus Driver"] = true,
    ["Deliveroo"] = true,
    ["Scuba Diver"] = true,
    ["G4S Driver"] = true,
    ["Taco Seller"] = true,
}
local tridentGroups = {
    ["Trident Officer Clocked"] = true,
    ["Trident Command Clocked"] = true,
}
function getGroupInGroups(id, type)
    if type == 'Police' then
        for k,v in pairs(CORRUPT.getUserGroups(id)) do
            if pdGroups[k] or tridentGroups[k] then
                k = string.gsub(k, ' Clocked', '')
                return k
            end 
        end
    elseif type == 'NHS' then
        for k,v in pairs(CORRUPT.getUserGroups(id)) do
            if nhsGroups[k] then
                k = string.gsub(k, ' Clocked', '')
                return k
            end 
        end
    elseif type == 'LFB' then
        for k,v in pairs(CORRUPT.getUserGroups(id)) do
            if lfbGroups[k] then 
                k = string.gsub(k, ' Clocked', '')
                return k
            end 
        end
    elseif type == 'HMP' then
        for k,v in pairs(CORRUPT.getUserGroups(id)) do
            if hmpGroups[k] then 
                k = string.gsub(k, ' Clocked', '')
                return k
            end 
        end
    elseif type == 'Default' then
        for k,v in pairs(CORRUPT.getUserGroups(id)) do
            if defaultGroups[k] then 
                return k
            end 
        end
        return "Unemployed"
    end
end

local hiddenUsers = {}
RegisterNetEvent("CORRUPT:setUserHidden")
AddEventHandler("CORRUPT:setUserHidden",function(state)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.isDeveloper(user_id) then
        if state then
            hiddenUsers[user_id] = true
        else
            hiddenUsers[user_id] = nil
        end
    end
end)

local uptime = 0
local function playerListMetaUpdates()
    local uptimemessage = ''
    if uptime < 60 then
        uptimemessage = math.floor(uptime) .. ' seconds'
    elseif uptime >= 60 and uptime < 3600 then
        uptimemessage = math.floor(uptime/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    elseif uptime >= 3600 then
        uptimemessage = math.floor(uptime/3600) .. ' hours and ' .. math.floor((uptime%3600)/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    end
    local numplayers = 0
    for i, v in pairs(CORRUPT.getUsers()) do
        if not hiddenUsers[i] then
            numplayers = numplayers + 1
        end
    end
    return {uptimemessage, numplayers, 0, GetConvarInt("sv_maxclients",64), 1}
end


function getuptime()
    local uptimemessage = ''
    if uptime < 60 then
        uptimemessage = math.floor(uptime) .. ' seconds'
    elseif uptime >= 60 and uptime < 3600 then
        uptimemessage = math.floor(uptime/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    elseif uptime >= 3600 then
        uptimemessage = math.floor(uptime/3600) .. ' hours and ' .. math.floor((uptime%3600)/60) .. ' minutes and ' .. math.floor(uptime%60) .. ' seconds'
    end
    return uptimemessage
end

Citizen.CreateThread(function()
    while true do
        local time = os.date("*t")
        uptime = uptime + 1
        TriggerClientEvent('CORRUPT:setHiddenUsers', -1, hiddenUsers)
        TriggerClientEvent('CORRUPT:updatePlayerListUpTime', -1, getuptime())
        if os.date('%A') == 'Sunday' and tonumber(time["hour"]) == 23 and tonumber(time["min"]) == 0 and tonumber(time["sec"]) == 0 then
            exports['corrupt']:execute("UPDATE corrupt_police_hours SET weekly_hours = 0")
            exports['corrupt']:execute("DELETE FROM corrupt_staff_tickets")
            exports['corrupt']:execute("UPDATE corrupt_dvsa SET points = 0")
        end
        Citizen.Wait(1000)
    end
end)

function CORRUPT.GetPlayerJob(user_id)
    local job = 'Default'
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        job = 'Police'
    elseif CORRUPT.hasPermission(user_id, 'nhs.menu') then
        job = 'NHS'
    elseif CORRUPT.hasPermission(user_id, 'lfb.onduty.permission') then
        job = 'LFB'
    elseif CORRUPT.hasPermission(user_id, 'hmp.menu') then
        job = 'HMP'
    end
    return job
end

function CORRUPT.IsUserStaff(user_id)
    if CORRUPT.hasPermission(user_id, 'admin.tickets') then
        return true
    else
        return false
    end
end

local fullPlayerListData = {}
RegisterNetEvent("CORRUPT:requestFullPlayerListData")
AddEventHandler("CORRUPT:requestFullPlayerListData", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    fullPlayerListData["_meta"] = playerListMetaUpdates()
    TriggerClientEvent('CORRUPT:playerListMetaUpdate', source, playerListMetaUpdates())
    TriggerClientEvent('CORRUPT:gotFullPlayerListData', source, fullPlayerListData)
end)


local paycheckscfg = module('cfg/cfg_factiongroups')

local function paycheck(tempid, permid, money)
    local pay = grindBoost*money
    CORRUPT.giveBankMoney(permid, pay)
    CORRUPT.notify(tempid, {'Payday: ~g~£'..getMoneyStringFormatted(tostring(pay))})
end

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000*60*30)
        for k,v in pairs(CORRUPT.getUsers()) do
            if CORRUPT.hasPermission(k, "police.armoury") then
                for a,b in pairs(paycheckscfg.metPoliceRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'Police'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif CORRUPT.hasPermission(k, "nhs.menu") then
                for a,b in pairs(paycheckscfg.nhsRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'NHS'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            elseif CORRUPT.hasPermission(k, "hmp.menu") then
                for a,b in pairs(paycheckscfg.hmpRanks) do
                    if b[1] == string.gsub(getGroupInGroups(k, 'HMP'), ' Clocked', '') then
                        paycheck(v, k, b[2])
                    end
                end
            end
        end
    end
end)

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not fullPlayerListData[user_id] then
        fullPlayerListData[user_id] = {source, CORRUPT.getPlayerName(source), getGroupInGroups(user_id, CORRUPT.GetPlayerJob(user_id)), CORRUPT.GetPlayTime(user_id), CORRUPT.IsUserStaff(user_id)}
        TriggerClientEvent('CORRUPT:playerListPlayerJoin', -1, {user_id, source, CORRUPT.getPlayerName(source), getGroupInGroups(user_id, CORRUPT.GetPlayerJob(user_id)), CORRUPT.GetPlayTime(user_id), CORRUPT.IsUserStaff(user_id)})
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(60000)
        for k, v in pairs(fullPlayerListData) do
            if CORRUPT.getUserId(v[1]) == nil then
                fullPlayerListData[k] = nil
                TriggerClientEvent('CORRUPT:playerListPlayerLeave', -1, k)
            end
        end
    end
end)





AddEventHandler("playerDropped", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if fullPlayerListData[user_id] then
        fullPlayerListData[user_id] = nil
        TriggerClientEvent('CORRUPT:playerListMetaUpdate', -1, playerListMetaUpdates())
        TriggerClientEvent('CORRUPT:playerListPlayerLeave', -1, user_id)
    end
end)

function CORRUPT.RefreshUserJob(user_id)
    local source = source
    if fullPlayerListData[user_id] then
        fullPlayerListData[user_id] = nil
    end
    fullPlayerListData[user_id] = {source, CORRUPT.getPlayerName(source), getGroupInGroups(user_id, CORRUPT.GetPlayerJob(user_id)), CORRUPT.GetPlayTime(user_id), CORRUPT.IsUserStaff(user_id)}
    TriggerClientEvent('CORRUPT:playerListMetaUpdate', -1, playerListMetaUpdates())
    TriggerClientEvent('CORRUPT:playerListPlayerJoin', -1, {user_id, source, CORRUPT.getPlayerName(source), getGroupInGroups(user_id, CORRUPT.GetPlayerJob(user_id)), CORRUPT.GetPlayTime(user_id), CORRUPT.IsUserStaff(user_id)})
end