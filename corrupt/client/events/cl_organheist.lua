local a = module("cfg/cfg_organheist")
inOrganHeist = false
local b = vector3(240.31098937988, -1379.8699951172, 33.741794586182)
local c = vector3(231.51065063477, -1360.6903076172, 28.651802062988)
local d = 600
local e = false
local f = false
local g = false
local h = ""
local i = {}
local j = {}
local k = nil
local l, m = AddRelationshipGroup("ORGANHEIST_POLICE")
local l, n = AddRelationshipGroup("ORGANHEIST_CRIMINAL")
local o = {}
local p = {
    ["civs"] = {
        objectHash = `prop_gate_military_01`,
        objectPos = vector3(251.2504, -1361.306, 23.54731),
        objectHeading = 322.19732666016,
        objectHandler = 0
    },
    ["cops"] = {
        objectHash = `prop_gate_military_01`,
        objectPos = vector3(251.1472, -1361.884, 38.54385),
        objectHeading = 318.79,
        objectHandler = 0
    }
}
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(q, r)
        if r then
            tvRP.addMarker(b.x, b.y, b.z, 0.7, 0.7, 0.5, 0, 125, 255, 125, 150, 20, false, false, true)
            tvRP.addBlip(b.x, b.y, b, 378, 3, "Organ Heist Police")
            tvRP.addMarker(c.x, c.y, c.z, 0.7, 0.7, 0.5, 255, 0, 0, 125, 150, 20, false, false, true)
            tvRP.addBlip(c.x, c.y, c.z, 378, 1, "Organ Heist Criminals")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            local s = GetPlayerPed(-1)
            local t = GetEntityCoords(s)
            if #(t - c) < 1.0 then
                f = true
            else
                f = false
            end
            if #(t - b) < 1.0 then
                e = true
            else
                e = false
            end
            Wait(250)
        end
    end
)
local function u()
    if k.interiorId and k.roomKey then
        PinInteriorInMemory(k.interiorId)
        ForceRoomForEntity(PlayerPedId(), k.interiorId, k.roomKey)
        ForceRoomForGameViewport(k.interiorId, k.roomKey)
    end
end
Citizen.CreateThread(
    function()
        while true do
            if f then
                drawNativeNotification("~r~Press ~INPUT_PICKUP~ to play the Organ Heist!")
                if IsControlJustPressed(0, 38) then
                    if not globalOnPoliceDuty then
                        if not g then
                            TriggerServerEvent("CORRUPT:joinOrganHeist")
                            Wait(100)
                        else
                            tvRP.notify("~r~Already joined the Organ Heist!")
                        end
                    else
                        tvRP.notify("~r~You are police, please use the other entrance!")
                    end
                end
            elseif e then
                drawNativeNotification("~b~Press ~INPUT_PICKUP~ to play the Organ Heist!")
                if IsControlJustPressed(0, 38) then
                    if globalOnPoliceDuty then
                        if not g then
                            TriggerServerEvent("CORRUPT:joinOrganHeist")
                            Wait(100)
                        else
                            tvRP.notify("~r~Already joined the Organ Heist!")
                        end
                    else
                        tvRP.notify("~r~You are a civillian, please use the other entrance!")
                    end
                end
            end
            if inOrganHeist and inWaitingStage then
                DrawGTATimerBar("STARTS IN:", decimalsToMinutes(d), 1)
                DisablePlayerFiring(PlayerId(), true)
            end
            if inGamePhase or inWaitingStage then
                DrawGTATimerBar("~b~Police:", table.count(i), 3)
                DrawGTATimerBar("~r~Criminals:", table.count(j), 2)
                drawNativeText("~b~Kill the enemy team and survive.")
                RemoveWeaponFromPed(CORRUPT.getPlayerPed(), "WEAPON_MOLOTOV")
                RemoveWeaponFromPed(CORRUPT.getPlayerPed(), "WEAPON_FLASHBANG")
                RemoveWeaponFromPed(CORRUPT.getPlayerPed(), "WEAPON_SMOKEGRENADECORRUPT")
                RemoveWeaponFromPed(CORRUPT.getPlayerPed(), "WEAPON_SMOKEGRENADECORRUPTPD")
                RemoveWeaponFromPed(CORRUPT.getPlayerPed(), "WEAPON_STUNGUN")
                local s = PlayerPedId()
                local v = GetInteriorFromEntity(s)
                if v == 0 then
                    local w = k.safePositions[1]
                    DoScreenFadeOut(1000)
                    NetworkFadeOutEntity(PlayerPedId(), true, false)
                    Wait(1000)
                    SetEntityCoords(PlayerPedId(), w.x, w.y, w.z)
                    u()
                    NetworkFadeInEntity(PlayerPedId(), 0)
                    DoScreenFadeIn(1000)
                end
            end
            Wait(0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:teleportToOrganHeist",
    function(x, y, z, A, B)
        local s = PlayerPedId()
        d = y
        canPlayAnim = false
        h = z
        local C = a.locations[A]
        k = C.sides[B]
        g = true
        tvRP.setCanAnim(false)
        Citizen.CreateThread(
            function()
                while true do
                    d = d - 1
                    Wait(1000)
                end
            end
        )
        inOrganHeist = true
        inWaitingStage = true
        CORRUPT.deleteGreenzone("organ")
        SetRelationshipBetweenGroups(5, m, n)
        SetRelationshipBetweenGroups(5, n, m)
        if z == "civ" then
            SetPedRelationshipGroupHash(PlayerPedId(), n)
            CORRUPT.createAtm("Organ Heist", k.atmLocation)
        elseif z == "police" then
            SetPedRelationshipGroupHash(PlayerPedId(), m)
        end
        for l, D in pairs(k.gunStores[h]) do
            CORRUPT.createGunStore(D[1], D[2], D[3])
        end
        CORRUPT.setFriendlyFire(false)
        DoScreenFadeOut(1000)
        NetworkFadeOutEntity(s, true, false)
        Wait(1000)
        SetEntityCoords(s, x.x, x.y, x.z)
        u()
        NetworkFadeInEntity(s, 0)
        DoScreenFadeIn(1000)
        initializeOrganHeistScaleform()
        PrepareMusicEvent("AH3B_HALF_RAPPEL")
        TriggerMusicEvent("AH3B_HALF_RAPPEL")
        if C.fakeCollisions then
            for l, E in pairs(C.fakeCollisions) do
                CORRUPT.loadModel(E[1])
                local F = E[2]
                local G = E[3]
                local H = CreateObjectNoOffset(E[1], F.x, F.y, F.z, false, false, false)
                SetEntityQuaternion(H, G.x, G.y, G.z, G.w)
                FreezeEntityPosition(H, true)
                SetEntityVisible(H, false, false)
                table.insert(o, H)
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:addOrganHeistPlayer",
    function(I, z)
        if z == "civ" then
            j[I] = true
        elseif z == "police" then
            i[I] = true
        end
    end
)
RegisterNetEvent(
    "CORRUPT:organHeistKillConfirmed",
    function(J)
        PlaySoundFrontend(-1, "Weapon_Upgrade", "DLC_GR_Weapon_Upgrade_Soundset", true)
        CORRUPT.playScreenEffect("MP_Celeb_Win", 0.25)
        tvRP.notify("~g~Killed " .. J .. " received £25,000")
    end
)
local function K()
    local L = 1000.0
    local M = 0.0
    local t = GetEntityCoords(PlayerPedId())
    for l, N in pairs(k.pastGates) do
        local O = #(t - N)
        if O < L then
            L = O
        end
        if O > M then
            M = O
        end
    end
    return L, M
end
Citizen.CreateThread(
    function()
        while true do
            if inWaitingStage then
                local L = K()
                if L < 3.0 then
                    DoScreenFadeOut(1000)
                    NetworkFadeOutEntity(PlayerPedId(), true, false)
                    Wait(1000)
                    local w = k.safePositions[1]
                    SetEntityCoords(PlayerPedId(), w.x, w.y, w.z)
                    u()
                    NetworkFadeInEntity(PlayerPedId(), 0)
                    DoScreenFadeIn(1000)
                    tvRP.notify("~r~You got too far from the organ heist and have been teleported back.")
                end
            end
            if inGamePhase then
                local l, M = K()
                if M > 350.0 then
                    DoScreenFadeOut(1000)
                    NetworkFadeOutEntity(PlayerPedId(), true, false)
                    Wait(1000)
                    local w = k.safePositions[1]
                    SetEntityCoords(PlayerPedId(), w.x, w.y, w.z)
                    u()
                    NetworkFadeInEntity(PlayerPedId(), 0)
                    DoScreenFadeIn(1000)
                    tvRP.notify("~r~You got too far from the organ heist and have been teleported back.")
                end
            end
            Wait(0)
        end
    end
)
function createOrganHeistBarriers()
    for P, Q in pairs(p) do
        if not HasModelLoaded(Q.objectHash) then
            RequestModel(Q.objectHash)
            while not HasModelLoaded(Q.objectHash) do
                Wait(0)
            end
        end
        local R = CreateObject(Q.objectHash, Q.objectPos.x, Q.objectPos.y, Q.objectPos.z, false, false, true)
        p[P].objectHandler = R
        SetEntityHeading(R, p[P].objectHeading)
        SetEntityInvincible(R, true)
        FreezeEntityPosition(R, true)
        SetModelAsNoLongerNeeded(Q.objectHash)
    end
end
RegisterNetEvent(
    "CORRUPT:startOrganHeist",
    function()
        inWaitingStage = false
        inGamePhase = true
        PlaySoundFrontend(-1, "5s_To_Event_Start_Countdown", "GTAO_FM_Events_Soundset", 1)
        Wait(5000)
        DisablePlayerFiring(PlayerId(), false)
    end
)
RegisterNetEvent(
    "CORRUPT:removeFromOrganHeist",
    function(S)
        if i[S] then
            i[S] = nil
        end
        if j[S] then
            j[S] = nil
        end
    end
)
function moveUpGateObjects()
    Citizen.CreateThread(
        function()
            for P, Q in pairs(p) do
                DeleteObject(Q.objectHandler)
            end
        end
    )
end
function initializeOrganHeistScaleform()
    local T = true
    SetTimeout(
        5000,
        function()
            T = false
        end
    )
    Citizen.CreateThread(
        function()
            function Initialize(scaleform)
                local scaleform = RequestScaleformMovie(scaleform)
                while not HasScaleformMovieLoaded(scaleform) do
                    Citizen.Wait(0)
                end
                BeginScaleformMovieMethod(scaleform, "SHOW_SHARD_WASTED_MP_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString("~g~ORGAN HEIST!")
                ScaleformMovieMethodAddParamTextureNameString("Survive the Organ Heist and win £250,000")
                EndScaleformMovieMethod()
                return scaleform
            end
            scaleform = Initialize("mp_big_message_freemode")
            PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
            while T do
                local U = 0.5
                local V = 0.35
                local W = 1.0
                local X = W
                DrawScaleformMovie(scaleform, U, V, W, X, 0, 0, 0, 0, 0)
                Wait(0)
            end
        end
    )
end
function decimalsToMinutes(Y)
    local Z = tonumber(Y)
    if Z % 60 <= 9 then
        addonString = "0"
    else
        addonString = ""
    end
    return math.floor(Z / 60) .. ":" .. addonString .. Z % 60
end
AddEventHandler(
    "onResourceStop",
    function(_)
        if _ == GetCurrentResourceName() then
            for P, Q in pairs(p) do
                DeleteObject(p[P].objectHandler)
            end
        end
    end
)
local function a0()
    for l, H in pairs(o) do
        DeleteEntity(H)
    end
    o = {}
end
RegisterNetEvent(
    "CORRUPT:endOrganHeist",
    function()
        CORRUPT.createGreenzone("organ", vector3(236.02685546875, -1373.7049560547, 33.010623931885), 40.0)
        ClearRelationshipBetweenGroups(5, n, m)
        ClearRelationshipBetweenGroups(5, m, n)
        SetPedRelationshipGroupHash(PlayerPedId(), "PLAYER")
        i = {}
        j = {}
        g = false
        inOrganHeist = false
        inWaitingStage = false
        inGamePhase = false
        d = 600
        CORRUPT.deleteAtm("Organ Heist")
        for l, D in pairs(k.gunStores[h]) do
            CORRUPT.deleteGunStore(D[1])
        end
        h = ""
        k = nil
        tvRP.setCanAnim(true)
        CORRUPT.setFriendlyFire(true)
        PrepareMusicEvent("BST_STOP")
        TriggerMusicEvent("BST_STOP")
        ExecuteCommand("storeallweapons")
        Wait(10000)
        if GetEntityHealth(PlayerPedId()) <= 102 then
            TriggerEvent("Corrupt:Revive")
            local s = PlayerPedId()
            DoScreenFadeOut(1000)
            NetworkFadeOutEntity(s, true, false)
            Wait(1000)
            SetEntityCoords(s, 240.31098937988, -1379.8699951172, 33.741794586182)
            NetworkFadeInEntity(s, 0)
            DoScreenFadeIn(1000)
        end
        a0()
    end
)
RegisterNetEvent(
    "CORRUPT:endOrganHeistWinner",
    function(z)
        Wait(10000)
        winOrganHeist(z)
        local s = PlayerPedId()
        CORRUPT.setFriendlyFire(true)
        DoScreenFadeOut(1000)
        NetworkFadeOutEntity(s, true, false)
        Wait(1000)
        SetEntityCoords(s, 240.31098937988, -1379.8699951172, 33.741794586182)
        NetworkFadeInEntity(s, 0)
        DoScreenFadeIn(1000)
        a0()
    end
)
local function a1(a2, a3, a4, a5)
    ClearTimecycleModifier()
    local a6 = {
        handle = Scaleform("MP_CELEBRATION"),
        handle2 = Scaleform("MP_CELEBRATION_BG"),
        handle3 = Scaleform("MP_CELEBRATION_FG")
    }
    for a7, a8 in pairs(a6) do
        a8.RunFunction("CLEANUP", {"WINNER"})
        a8.RunFunction("CREATE_STAT_WALL", {"WINNER", "HUD_COLOUR_BLACK", "70.0"})
        a8.RunFunction(
            "SET_PAUSE_DURATION",
            {function()
                    ScaleformMovieMethodAddParamFloat(2.5)
                end}
        )
        if a5 ~= 0 then
            a8.RunFunction("ADD_CASH_TO_WALL", {"WINNER", a5, true})
        end
        a8.RunFunction("ADD_WINNER_TO_WALL", {"WINNER", "CELEB_WINNER", a2, "", 0, false, "", false})
        a8.RunFunction("ADD_BACKGROUND_TO_WALL", {"WINNER", 75, 0})
        a8.RunFunction("SHOW_STAT_WALL", {"WINNER"})
    end
    return a6.handle, a6.handle2, a6.handle3
end
function winOrganHeist(z)
    Citizen.CreateThread(
        function()
            local a9 = false
            local aa, ab, ac = a1(z, 2, 100, 250000)
            if not a9 then
                a9 = true
            end
            SetTimeout(
                10000,
                function()
                    a9 = false
                end
            )
            while a9 do
                Wait(0)
                HideHudAndRadarThisFrame()
                DrawScaleformMovieFullscreenMasked(ab.Handle, ac.Handle, 255, 255, 255, 255)
                aa.Render2D()
            end
        end
    )
end
function CORRUPT.setDeathInOrganHeist()
    inOrganHeist = false
    inWaitingStage = false
    inGamePhase = false
end
RegisterNetEvent(
    "CORRUPT:createOrganHeistGreenzone",
    function(ad)
        if ad then
            CORRUPT.createGreenzone("organ", vector3(236.02685546875, -1373.7049560547, 33.010623931885), 40.0)
        else
            CORRUPT.deleteGreenzone("organ")
        end
    end
)
