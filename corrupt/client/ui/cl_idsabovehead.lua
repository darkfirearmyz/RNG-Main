local a = 7.0
local b = {}
local c = {}
local d = true
local e = {}
local f = {}
local g = false
local h = 30.0
local function i(j, k)
    if k < a then
        return true
    elseif g and CORRUPT.isPlayerInSelectedGang(j) then
        if k < h then
            return true
        end
    end
    return false
end
Citizen.CreateThread(
    function()
        Wait(500)
        while true do
            if not globalHideUi and not CORRUPT.isEventPlayerTagEnabled() and not CORRUPT.playerInWager() then
                if d then
                    local l = CORRUPT.getPlayerPed()
                    for m, n in ipairs(GetActivePlayers()) do
                        local o = GetPlayerPed(n)
                        if o ~= l then
                            if b[n] then
                                local j = GetPlayerServerId(n)
                                if i(j, b[n]) then
                                    local p = e[n]
                                    if NetworkIsPlayerTalking(n) then
                                        SetMpGamerTagAlpha(p, 4, 255)
                                        SetMpGamerTagColour(p, 0, 9)
                                        SetMpGamerTagColour(p, 4, 0)
                                        SetMpGamerTagVisibility(p, 4, true)
                                    else
                                        local q, r = CORRUPT.isPlayerInSelectedGang(j)
                                        if g and q then
                                            SetMpGamerTagColour(p, 0, r.hud)
                                        else
                                            SetMpGamerTagColour(p, 0, 0)
                                        end
                                        SetMpGamerTagColour(p, 4, 0)
                                        SetMpGamerTagVisibility(p, 4, false)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Citizen.Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            b = {}
            c = {}
            if not CORRUPT.isEventPlayerTagEnabled() then
                local l = CORRUPT.getPlayerPed()
                local s = CORRUPT.getPlayerCoords()
                if CORRUPT.isInSpectate() then
                    s = GetFinalRenderedCamCoord()
                end
                for m, n in ipairs(GetActivePlayers()) do
                    local t = GetPlayerPed(n)
                    local u = GetPlayerServerId(n)
                    if t ~= l and (IsEntityVisible(t) or not CORRUPT.clientGetPlayerIsStaff(u) and not CORRUPT.inEvent()) then
                        local v = GetEntityCoords(t)
                        b[n] = #(s - v)
                        if DecorGetBool(t, "cinematicMode") then
                            c[n] = true
                        end
                    end
                end
                if not tvRP.isStaffedOn() then
                    a = 7.0
                end
            end
            Citizen.Wait(1000)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            g = CORRUPT.hasGangNamesEnabled() and not CORRUPT.isEmergencyService()
            for m, n in ipairs(GetActivePlayers()) do
                local k = b[n]
                local j = GetPlayerServerId(n)
                local playeruserid = CORRUPT.getUserId(j)
                local playername = CORRUPT.getPlayerName(n)
                if k and i(j, k) and d then
                    local w = nil
                    if g and CORRUPT.isPlayerInSelectedGang(j) then
                        w = playername
                    elseif CORRUPT.getStaffLevel() > 2 and tvRP.isStaffedOn() then
                        if playername and playeruserid and j then
                            w = "[Name: "..playername .. " - Perm ID: " ..playeruserid.." - Temp ID: " ..j.."]"
                        else
                            w = j
                        end
                    else
                        w = tostring(j)
                        if c[n] then
                            w = w .. " [cinematic mode]"
                        end
                    end
                    if f[n] ~= w and e[n] then
                        RemoveMpGamerTag(e[n])
                    end
                    e[n] = CreateFakeMpGamerTag(GetPlayerPed(n), w, false, false, "", 0)
                    SetMpGamerTagVisibility(e[n], 3, true)
                    f[n] = w
                elseif e[n] then
                    RemoveMpGamerTag(e[n])
                    e[n] = nil
                    f[n] = nil
                end
                Wait(0)
            end
            Wait(0)
        end
    end
)
SetMpGamerTagsUseVehicleBehavior(false)
function CORRUPT.setPlayerNameDistance(k)
    if k == -1 then
        SetMpGamerTagsVisibleDistance(100.0)
        a = 7.0
    else
        SetMpGamerTagsVisibleDistance(k)
        a = k
    end
end
function CORRUPT.getPlayerNameDistance()
    return a
end
RegisterCommand(
    "farids",
    function(x, y, z)
        if CORRUPT.getStaffLevel() > 2 and tvRP.isStaffedOn() then
            local A = y[1]
            if A ~= nil and tonumber(A) then
                a = tonumber(A) + 000.1
                CORRUPT.setPlayerNameDistance(a)
            else
                tvRP.notify("~r~Please enter a valid range! (/farids [range])")
            end
        end
    end,
    false
)
RegisterCommand(
    "faridsreset",
    function(x, y, z)
        if CORRUPT.getStaffLevel() > 2 then
            CORRUPT.setPlayerNameDistance(-1)
        end
    end,
    false
)
RegisterCommand(
    "hideids",
    function()
        d = false
    end,
    false
)
RegisterCommand(
    "showids",
    function()
        d = true
    end,
    false
)
AddEventHandler(
    "CORRUPT:setGangNameDistance",
    function(k)
        h = k
    end
)
