globalBlips = {}
function tvRP.addBlip(a, b, c, d, e, f, g, h)
    local i = AddBlipForCoord(a + 0.001, b + 0.001, c + 0.001)
    SetBlipSprite(i, d)
    SetBlipAsShortRange(i, true)
    SetBlipColour(i, e)
    if d == 403 or d == 431 or d == 365 or d == 85 or d == 140 or d == 60 or d == 44 or d == 110 or d == 315 then
        SetBlipScale(i, 1.1)
    elseif d == 50 then
        SetBlipScale(i, 0.7)
    else
        SetBlipScale(i, 0.8)
    end
    SetBlipScale(i, g or 0.8)
    if h then
        SetBlipDisplay(i, 5)
    end
    if f ~= nil then
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentSubstringPlayerName(f)
        EndTextCommandSetBlipName(i)
    end
    table.insert(globalBlips, i)
    return i
end
function tvRP.removeBlip(j)
    RemoveBlip(j)
end
local k = {}
function tvRP.setNamedBlip(l, a, b, c, d, e, f, g)
    tvRP.removeNamedBlip(l)
    k[l] = tvRP.addBlip(a, b, c, d, e, f, g)
    return k[l]
end
function tvRP.removeNamedBlip(l)
    if k[l] ~= nil then
        tvRP.removeBlip(k[l])
        k[l] = nil
    end
end
function tvRP.setGPS(a, b)
    SetNewWaypoint(a + 0.0001, b + 0.0001)
end
function tvRP.setBlipRoute(j)
    SetBlipRoute(j, true)
end
local m = {}
local n = Tools.newIDGenerator()
local o = {}
local p = {}
local q = {}
function tvRP.addMarker(a, b, c, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H)
    local I = {
        position = vector3(a, b, c),
        sx = r,
        sy = s,
        sz = t,
        r = u,
        g = v,
        b = w,
        a = x,
        visible_distance = y,
        mtype = z,
        faceCamera = A,
        bopUpAndDown = B,
        rotate = C,
        textureDict = D,
        textureName = E,
        xRot = F,
        yRot = G,
        zRot = H
    }
    if I.sx == nil then
        I.sx = 2.0
    end
    if I.sy == nil then
        I.sy = 2.0
    end
    if I.sz == nil then
        I.sz = 0.7
    end
    if I.r == nil then
        I.r = 0
    end
    if I.g == nil then
        I.g = 155
    end
    if I.b == nil then
        I.b = 255
    end
    if I.a == nil then
        I.a = 200
    end
    I.sx = I.sx + 0.001
    I.sy = I.sy + 0.001
    I.sz = I.sz + 0.001
    if I.visible_distance == nil then
        I.visible_distance = 150
    end
    local j = n:gen()
    m[j] = I
    q[j] = I
    return j
end
function tvRP.removeMarker(j)
    if m[j] ~= nil then
        m[j] = nil
        n:free(j)
    end
    if q[j] then
        q[j] = nil
    end
end
function tvRP.setNamedMarker(l, a, b, c, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H)
    tvRP.removeNamedMarker(l)
    o[l] = tvRP.addMarker(a, b, c, r, s, t, u, v, w, x, y, z, A, B, C, D, E, F, G, H)
    return o[l]
end
function tvRP.removeNamedMarker(l)
    if o[l] ~= nil then
        tvRP.removeMarker(o[l])
        o[l] = nil
    end
end
local J = {}
Citizen.CreateThread(
    function()
        while true do
            for K, L in pairs(p) do
                if J[K] then
                    if J[K] <= L.visible_distance then
                        if L.mtype == nil then
                            L.mtype = 1
                        end
                        DrawMarker(
                            L.mtype,
                            L.position.x,
                            L.position.y,
                            L.position.z,
                            0.0,
                            0.0,
                            0.0,
                            L.xRot,
                            L.yRot,
                            L.zRot,
                            L.sx,
                            L.sy,
                            L.sz,
                            L.r,
                            L.g,
                            L.b,
                            L.a,
                            L.bopUpAndDown,
                            L.faceCamera,
                            2,
                            L.rotate,
                            L.textureDict,
                            L.textureName,
                            false
                        )
                    end
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local M = CORRUPT.getPlayerCoords()
            J = {}
            for K, L in pairs(q) do
                J[K] = #(L.position - M)
                if J[K] <= L.visible_distance and (not L.textureDict or HasStreamedTextureDictLoaded(L.textureDict)) then
                    p[K] = L
                else
                    p[K] = nil
                end
            end
            Citizen.Wait(250)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            q = CORRUPT.getNearbyMarkers()
            Citizen.Wait(10000)
        end
    end
)
function CORRUPT.getNearbyMarkers()
    local N = {}
    local O = CORRUPT.getPlayerCoords()
    local P = 0
    for K, L in pairs(m) do
        if #(L.position - O) <= 250.0 then
            N[K] = L
        end
        P = P + 1
        if P % 25 == 0 then
            Wait(0)
        end
    end
    return N
end
local Q = {}
local R = {}
local S = false
function CORRUPT.getNearbyAreas()
    local T = {}
    local M = CORRUPT.getPlayerCoords()
    local P = 0
    for K, L in pairs(Q) do
        if #(L.position - M) <= 250.0 or L.radius > 250 then
            T[K] = L
        end
        P = P + 1
        if not S then
            if P % 25 == 0 then
                Wait(0)
            end
        end
    end
    return T
end
function tvRP.setArea(l, a, b, c, U, V)
    local W = {position = vector3(a + 0.001, b + 0.001, c + 0.001), radius = U, height = V}
    if W.height == nil then
        W.height = 6
    end
    Q[l] = W
end
function CORRUPT.createArea(l, X, U, V, Y, Z, _, a0)
    local W = {position = X, radius = U, height = V, enterArea = Y, leaveArea = Z, onTickArea = _, metaData = a0}
    if W.height == nil then
        W.height = 6
    end
    Q[l] = W
    R[l] = W
end
function tvRP.removeArea(l)
    if Q[l] then
        Q[l] = nil
    end
end
function CORRUPT.doesAreaExist(l)
    if Q[l] then
        return true
    end
    return false
end
function CORRUPT.setAreaMetaData(l, a0)
    if Q[l] then
        Q[l].metaData = a0
    end
end
function CORRUPT.getAreaMetaData(l)
    if Q[l] then
        return Q[l].metaData
    else
        return {}
    end
end
function CORRUPT.useIncreasedAreaRefreshRate(a1)
    S = a1
end
Citizen.CreateThread(
    function()
        while true do
            local M = CORRUPT.getPlayerCoords()
            for a2, a3 in pairs(R) do
                local a4 = #(a3.position - M)
                local a5 = a4 <= a3.radius and math.abs(M.z - a3.position.z) <= a3.height
                a3.distance = a4
                if a3.player_in and not a5 then
                    if a3.leaveArea then
                        if a3.metaData == nil then
                            a3.metaData = {}
                        end
                        a3.leaveArea(a3.metaData)
                    else
                        vRPserver.leaveArea({a2})
                    end
                elseif not a3.player_in and a5 then
                    if a3.enterArea then
                        if a3.metaData == nil then
                            a3.metaData = {}
                        end
                        a3.enterArea(a3.metaData)
                    else
                        vRPserver.enterArea({a2})
                    end
                end
                a3.player_in = a5
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            for a2, a3 in pairs(R) do
                if a3.player_in and a3.onTickArea then
                    if a3.metaData == nil then
                        a3.metaData = {}
                    end
                    a3.metaData.distance = a3.distance
                    a3.onTickArea(a3.metaData)
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            R = CORRUPT.getNearbyAreas()
            Citizen.Wait(S and 1000 or 5000)
        end
    end
)
local a6
local a7 = 617
RegisterCommand(
    "nextblip",
    function()
        a7 = a7 + 1
        if a6 then
            tvRP.removeBlip(a6)
        end
        print("creating blip", a7)
        a6 = tvRP.addBlip(1103.9739990234, 211.95138549805, -49.440101623535, a7, 0, "Chips Cashier", 0.8, true)
    end,
    false
)
