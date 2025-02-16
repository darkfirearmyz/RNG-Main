local a = false
local b = {}
local c = {}
local function d()
    for e, f in pairs(b) do
        if DoesBlipExist(f) then
            RemoveBlip(f)
        end
    end
    b = {}
end
local function g()
    for e, f in pairs(c) do
        if DoesBlipExist(f) then
            RemoveBlip(f)
        end
    end
    c = {}
end
local function h(i, j, k)
    if not DoesBlipExist(i) then
        local l = AddBlipForEntity(j)
        table.insert(b, l)
        SetBlipSprite(l, 1)
        SetBlipScale(i, 0.85)
        SetBlipAlpha(i, 255)
        SetBlipColour(i, k)
        ShowHeadingIndicatorOnBlip(i, true)
    else
        if GetEntityHealth(j) > 102 then
            SetBlipSprite(i, 1)
        else
            SetBlipSprite(i, 274)
        end
        SetBlipScale(i, 0.85)
        SetBlipAlpha(i, 255)
        SetBlipColour(i, k)
        ShowHeadingIndicatorOnBlip(i, true)
    end
end
local function m(n, o)
    return IsEntityVisible(n) or not CORRUPT.clientGetPlayerIsStaff(o)
end
local function p(q, r, k)
    local l = AddBlipForCoord(q.x, q.y, q.z)
    table.insert(c, l)
    if r == 0 then
        SetBlipSprite(l, 1)
    else
        SetBlipSprite(l, 274)
    end
    SetBlipScale(l, 0.85)
    SetBlipAlpha(l, 255)
    SetBlipColour(l, k)
end
RegisterCommand(
    "blipson",
    function()
        if globalOnPoliceDuty or globalNHSOnDuty or globalOnPrisonDuty then
            a = true
        end
    end,
    false
)
RegisterCommand(
    "blipsoff",
    function()
        if a then
            a = false
            d()
        end
    end,
    false
)
RegisterNetEvent(
    "CORRUPT:disableFactionBlips",
    function()
        if a then
            tvRP.setPolice(false)
            tvRP.setHMP(false)
            tvRP.setNHS(false)
            a = false
            d()
            g()
        end
    end
)
AddEventHandler(
    "CORRUPT:deleteGangBlips",
    function()
        d()
        g()
    end
)
function tvRP.copBlips()
    return a
end
Citizen.CreateThread(
    function()
        while true do
            if a or tvRP.isInComa() or CORRUPT.hasGangBlipsEnabled() then
                local s = CORRUPT.hasGangBlipsEnabled()
                local t = CORRUPT.isEmergencyService()
                local n = CORRUPT.getPlayerPed()
                for e, f in ipairs(GetActivePlayers()) do
                    local j = GetPlayerPed(f)
                    if j ~= n then
                        local i = GetBlipFromEntity(j)
                        local u = GetPlayerServerId(f)
                        if u ~= -1 then
                            local v = CORRUPT.clientGetUserIdFromSource(u)
                            local w, x = CORRUPT.getJobType(v)
                            if v ~= CORRUPT.getUserId() then
                                local y = false
                                if m(j, u) then
                                    if a then
                                        if w == "metpd" and x == "CID Constable" then
                                            h(i, j, 27)
                                            y = true
                                        elseif w == "metpd" and x == "NPAS" then
                                            h(i, j, 5)
                                            y = true
                                        elseif w == "metpd" then
                                            h(i, j, 3)
                                            y = true
                                        elseif w == "hmp" then
                                            h(i, j, 29)
                                            y = true
                                        elseif w == "lfb" then
                                            h(i, j, 1)
                                            y = true
                                        elseif w == "nhs" and x == "HEMS" then
                                            h(i, j, 44)
                                            y = true
                                        elseif w == "nhs" then
                                            h(i, j, 2)
                                            y = true
                                        end
                                    elseif tvRP.isInComa() then
                                        if w == "nhs" then
                                            h(i, j, 2)
                                            y = true
                                        end
                                    elseif s and not t then
                                        local z, A = CORRUPT.isPlayerInSelectedGang(u)
                                        if z and w == "" then
                                            h(i, j, A.blip)
                                            y = true
                                        end
                                    end
                                end
                                if not y then
                                    local B = GetBlipFromEntity(j)
                                    if B ~= 0 then
                                        RemoveBlip(B)
                                    end
                                end
                            end
                        end
                    end
                end
            end
            Wait(100)
        end
    end
)
local C = true
local D = GetPlayerServerId(PlayerId())
CreateThread(
    function()
        Wait(20000)
        C = false
    end
)
RegisterNetEvent(
    "CORRUPT:sendFarBlips",
    function(E, F)
        if not C then
            if F then
                a = true
            elseif CORRUPT.isEmergencyService() or not CORRUPT.hasGangBlipsEnabled() then
                return
            end
            g()
            for e, G in pairs(E) do
                if G.source ~= D and GetPlayerFromServerId(G.source) == -1 and G.bucket == CORRUPT.getPlayerBucket() then
                    p(G.position, G.dead, G.colour)
                end
            end
        end
    end
)