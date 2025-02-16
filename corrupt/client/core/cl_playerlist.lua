local a = false
fullPlayerListData = {}
sortedFullPlayerListData = {}
local b = {}
local c = 0
SetNuiFocus(false, false)
local d = {
    ["NHS Trainee Paramedic"] = true,
    ["NHS Paramedic"] = true,
    ["NHS Critical Care Paramedic"] = true,
    ["NHS Junior Doctor"] = true,
    ["NHS Doctor"] = true,
    ["NHS Senior Doctor"] = true,
    ["NHS Specialist Doctor"] = true,
    ["NHS Surgeon"] = true,
    ["NHS Specialist Surgeon"] = true,
    ["NHS Assistant Medical Director"] = true,
    ["NHS Deputy Medical Director"] = true,
    ["NHS Head Chief"] = true,
    ["HEMS"]=true,
}
local e = {
    ["Provisional Firefighter"] = true,
    ["Junior Firefighter"] = true,
    ["Firefighter"] = true,
    ["Senior Firefighter"] = true,
    ["Advanced Firefighter"] = true,
    ["Specalist Firefighter"] = true,
    ["Leading Firefighter"] = true,
    ["Sector Command"] = true,
    ["Divisional Command"] = true,
    ["Chief Fire Command"] = true
}
local f = {
    ["Commissioner"]=true,
    ["Deputy Commissioner"] =true,
    ["Assistant Commissioner"]=true,
    ["Dep. Asst. Commissioner"] =true,
    ["GC Advisor"] =true,
    ["Commander"]=true,
    ["Chief Superintendent"]=true,
    ["Superintendent"]=true,
    ["Chief Inspector"]=true,
    ["Inspector"]=true,
    ["Sergeant"]=true,
    ["Senior Constable"]=true,
    ["PC"]=true,
    ["PCSO"]=true,
    ["Special Constable"]=true,
    ["NPAS"]=true,
}
local g = {
    ["Governor"] = true,
    ["Deputy Governor"] = true,
    ["Divisional Commander"] = true,
    ["Custodial Supervisor"] = true,
    ["Custodial Officer"] = true,
    ["Honourable Guard"] = true,
    ["Supervising Officer"] = true,
    ["Principal Officer"] = true,
    ["Specialist Officer"] = true,
    ["Senior Officer"] = true,
    ["Prison Officer"] = true,
    ["Trainee Prison Officer"] = true
}
function CORRUPT.clientGetUserIdFromSource(h)
    return b[h] or 0
end
function CORRUPT.clientGetPlayerIsStaff(h)
    local i = b[h]
    if i and fullPlayerListData[i] then
        return fullPlayerListData[i][5]
    end
    return false
end
function CORRUPT.getJobType(i)
    if fullPlayerListData[i] then
        local j = fullPlayerListData[i][3]
        if d[j] then
            return "nhs", j
        elseif e[j] then
            return "lfb", j
        elseif g[j] then
            return "hmp", j
        elseif f[j] then
            return "metpd", j
        else
            if j == "CID Constable" then
                return "metpd", j
            else
                return "", j
            end
        end
    else
        return "", ""
    end
end
function func_playerlistControl()
    if IsUsingKeyboard(2) then
        if IsControlJustPressed(0, 212) and GetGameTimer() - c > 1000 and not CORRUPT.inEvent() then
            a = not a
            sendFullPlayerListData()
            SetNuiFocus(true, true)
            SendNUIMessage({showPlayerList = true})
            c = GetGameTimer()
        end
    end
end
CORRUPT.createThreadOnTick(func_playerlistControl)
RegisterNUICallback(
    "closeCORRUPTPlayerList",
    function(k, l)
        SetNuiFocus(false, false)
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(i, m)
        if m then
            TriggerServerEvent("CORRUPT:requestFullPlayerListData")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:gotFullPlayerListData",
    function(n)
        fullPlayerListData = n
        for i, o in pairs(n) do
            if i ~= "_meta" then
                b[o[1]] = i
            end
        end
        sortedFullPlayerListData = sortPlayerListByUserIDs(fullPlayerListData)
        sendFullPlayerListData()
    end
)
RegisterNetEvent(
    "CORRUPT:playerListPlayerJoin",
    function(p)
        local i, h, q, j, r, s = table.unpack(p)
        fullPlayerListData[i] = {h, q, j, r, s}
        b[h] = i
        sortedFullPlayerListData = sortPlayerListByUserIDs(fullPlayerListData)
    end
)
RegisterNetEvent(
    "CORRUPT:playerListPlayerLeave",
    function(t)
        fullPlayerListData[t] = nil
        sortedFullPlayerListData = sortPlayerListByUserIDs(fullPlayerListData)
    end
)
RegisterNetEvent(
    "CORRUPT:playerListMetaUpdate",
    function(u)
        local v, w, x, y, z = table.unpack(u)
        fullPlayerListData["_meta"] = {v, w, x, y, z}
        SendNUIMessage({wipeFooterPlayerList = true})
        SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #' .. tostring(z) .. " | </span>"})
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                    tostring(v) .. "</span>"
            }
        )
        SendNUIMessage(
            {
                appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                    tostring(w) .. "/" .. tostring(y) .. "(Queue: " .. tostring(x) .. ")</span>"
            }
        )
    end
)
RegisterNetEvent(
    "CORRUPT:updatePlayerListUpTime",
    function(A)
        if fullPlayerListData ~= nil then
            if fullPlayerListData["_meta"] ~= nil then
                local v, w, x, y, z = table.unpack(fullPlayerListData["_meta"])
                fullPlayerListData["_meta"] = {A, w, x, y, z}
                SendNUIMessage({wipeFooterPlayerList = true})
                SendNUIMessage(
                    {appendToFooterPlayerList = '<span class="foot">Server #' .. tostring(z) .. " | </span>"}
                )
                SendNUIMessage(
                    {
                        appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                            tostring(A) .. "</span>"
                    }
                )
                SendNUIMessage(
                    {
                        appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                            tostring(w) .. "/" .. tostring(y) .. "(Queue: " .. tostring(x) .. ")</span>"
                    }
                )
            end
        end
    end
)
function sendFullPlayerListData()
    local B, C, D, E, F, G, H = sortPlayerListByGroup(fullPlayerListData)
    sortedPlayersStaff = sortPlayerListByUserIDs(B)
    sortedPlayersPolice = sortPlayerListByUserIDs(C)
    sortedPlayersNHS = sortPlayerListByUserIDs(D)
    sortedPlayersLFB = sortPlayerListByUserIDs(E)
    sortedPlayersHMP = sortPlayerListByUserIDs(F)
    sortedPlayersCivillians = sortPlayerListByUserIDs(G)
    local I = #sortedPlayersStaff
    local J = #sortedPlayersPolice
    local K = #sortedPlayersNHS
    local L = #sortedPlayersLFB
    local M = #sortedPlayersHMP
    local N = #sortedPlayersCivillians
    local O = 0
    local P = 0
    local Q = 0
    local R = 0
    local S = 0
    for T, U in ipairs(sortedPlayersStaff) do
        local h, q, group, r, s = table.unpack(B[U])
        if d[group] then
            P = P + 1
        end
        if e[group] then
            Q = Q + 1
        end
        if g[group] then
            R = R + 1
        end
        if f[group] then
            O = O + 1
        else
            S = S + 1
        end
    end
    SendNUIMessage({wipePlayerList = true})
    SendNUIMessage({clearServerMetaData = true})
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/corrupt.png" align="top" width="20px",height="20px"><span class="staff">' ..
                tostring(I) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/nhs.png" align="top" width="20",height="20"><span class="nhs">' ..
                tostring(K) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/lfb.png" align="top" width="20",height="20"><span class="lfb">' ..
                tostring(L) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/met.png" align="top"  width="24",height="24"><span class="police">' ..
                tostring(J) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/hmp.png" align="top"  width="24",height="24"><span class="hmp">' ..
                tostring(M) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            setServerMetaData = '<img src="playerlist_images/danny.png" align="top" width="20",height="20"><span class="aa">' ..
                tostring(N) .. "</span>"
        }
    )
    local v, w, x, y, z = table.unpack(H)
    SendNUIMessage({wipeFooterPlayerList = true})
    SendNUIMessage({appendToFooterPlayerList = '<span class="foot">Server #' .. tostring(z) .. " | </span>"})
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot" style="color: rgb(0, 255, 20);">Server uptime ' ..
                tostring(v) .. "</span>"
        }
    )
    SendNUIMessage(
        {
            appendToFooterPlayerList = '<span class="foot">  |  Number of players ' ..
                tostring(w) .. "/" .. tostring(y) .. "(Queue: " .. tostring(x) .. ")</span>"
        }
    )
    if I >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_staff">Staff</span>'})
    end
    for T, U in ipairs(sortedPlayersStaff) do
        local h, q, group, r, s = table.unpack(B[U])
        if group == "CID Constable" then
            group = "Unemployed"
        end
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
    if J >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_police">MET Police</span>'})
    end
    for T, U in ipairs(sortedPlayersPolice) do
        local h, q, group, r, s = table.unpack(C[U])
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
    if K >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_nhs">NHS</span>'})
    end
    for T, U in ipairs(sortedPlayersNHS) do
        local h, q, group, r, s = table.unpack(D[U])
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
    if L >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_lfb">LFB</span>'})
    end
    for T, U in ipairs(sortedPlayersLFB) do
        local h, q, group, r, s = table.unpack(E[U])
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
    if M >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_hmp">HMP</span>'})
    end
    for T, U in ipairs(sortedPlayersHMP) do
        local h, q, group, r, s = table.unpack(F[U])
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
    if N >= 1 then
        SendNUIMessage({appendToContentPlayerList = '<span id="playerlist_seperator_civs">Civilians</span>'})
    end
    for T, U in ipairs(sortedPlayersCivillians) do
        local h, q, group, r, s = table.unpack(G[U])
        if group == "CID Constable" then
            group = "Unemployed"
        end
        SendNUIMessage(
            {
                appendToContentPlayerList = '<span class="username">' ..
                    tostring(q) ..
                        '</span><span class="job">' ..
                            tostring(group) .. '</span><span class="playtime">' .. tostring(r) .. "hrs</span><br/>"
            }
        )
    end
end
function sortPlayerListByGroup(V)
    local B = {}
    local C = {}
    local D = {}
    local E = {}
    local F = {}
    local G = {}
    local H = {}
    if group == nil or group == "" then
        group = "Unemployed"
    end
    for U, W in pairs(V) do
        if U == "_meta" then
            H = W
        elseif not CORRUPT.isUserHidden(U) then
            local h, q, group, r, s = table.unpack(W)
            if d[group] then
                D[U] = W
            elseif e[group] then
                E[U] = W
            elseif g[group] then
                F[U] = W
            elseif f[group] then
                C[U] = W
            else
                G[U] = W
            end
            if s then
                B[U] = W
            end
        end
    end
    return B, C, D, E, F, G, H
end
function sortPlayerListByUserIDs(X)
    local Y = {}
    for U, T in pairs(X) do
        if type(U) == "number" then
            table.insert(Y, U)
        end
    end
    table.sort(Y)
    return Y
end
function CORRUPT.GetNumPlayers()
    if fullPlayerListData ~= nil then
        local Z = fullPlayerListData["_meta"]
        if Z then
            local v, w, x, y, z = table.unpack(Z)
            return w
        end
    end
    return 0
end

Citizen.CreateThread(
    function()
        while true do
            Wait(5000)
            if fullPlayerListData ~= nil then
                local Z = fullPlayerListData["_meta"]
                if Z then
                    local v, w, x, y, z = table.unpack(Z)
                    SetDiscordAppId(1182066124792275075)
                    SetDiscordRichPresenceAsset("corrupt")
                    SetDiscordRichPresenceAssetText("CORRUPT British RP")
                    SetDiscordRichPresenceAssetSmall("corrupt")
                    SetDiscordRichPresenceAssetSmallText("CORRUPT British Roleplay")
                    SetDiscordRichPresenceAction(0, "Join Server", "fivem://connect/qmj35v")
                    SetDiscordRichPresenceAction(1, "Discord", "https://discord.gg/corrupt5m")
                    SetRichPresence("[ID:" .. tostring(CORRUPT.getUserId()) .. "] | " .. tostring(w) .. "/" .. tostring(y))
                end
            end
            Wait(15000)
        end
    end
)
function CORRUPT.getPlayerName(_)
    local a0 = GetPlayerServerId(_)
    if a0 > 0 then
        local i = CORRUPT.clientGetUserIdFromSource(a0)
        if i and fullPlayerListData[i] then
            return fullPlayerListData[i][2]
        end
    end
    return GetPlayerName(_)
end
