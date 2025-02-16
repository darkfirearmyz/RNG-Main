local a = false
local b = 1
local c = nil
local d = 0
local e = 90
local f = -5.0
local g = nil
local h = 50
local i = {}
local function j(k, f, d, e)
    local l = d * math.pi / 180.0
    local m = e * math.pi / 180.0
    local n = {
        x = k.x + f * math.sin(m) * math.cos(l),
        y = k.y - f * math.sin(m) * math.sin(l),
        z = k.z - f * math.cos(m)
    }
    return n
end
local function o(p)
    if not DoesCamExist(g) then
        g = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    end
    SetCamActive(g, true)
    RenderScriptCams(true, false, 0, true, true)
    c = p
end
local function q()
    c = nil
    SetCamActive(g, false)
    RenderScriptCams(false, false, 0, true, true)
    local r = CORRUPT.getPlayerPed()
    SetEntityCollision(r, true, true)
    SetEntityVisible(r, true, false)
    FreezeEntityPosition(r, false)
end
function CORRUPT.setEventSpectatorMode(s)
    a = s
    if a then
        b = 0
        if CORRUPT.getActiveEventPlayers()[1] then
            b = 1
            o(CORRUPT.getActiveEventPlayers()[1].source)
        end
    else
        SetEntityProofs(PlayerPedId(), false, false, false, false, false, false, false, false)
        q()
        ClearFocus()
    end
end
RegisterNetEvent(
    "CORRUPT:spectateClient",
    function(t)
        a = true
        o(t)
    end
)
function CORRUPT.isSpectatingEvent()
    return a
end
local function u(v)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay(v)
    EndTextCommandScaleformString()
end
local function w(x)
    ScaleformMovieMethodAddParamPlayerNameString(x)
end
local function y(z, A)
    local z = RequestScaleformMovie(z)
    while not HasScaleformMovieLoaded(z) do
        Wait(0)
    end
    BeginScaleformMovieMethod(z, "CLEAR_ALL")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(z, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    w(GetControlInstructionalButton(2, 15, true))
    w(GetControlInstructionalButton(1, 16, true))
    u("Zoom")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(z, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    w(GetControlInstructionalButton(2, 175, true))
    w(GetControlInstructionalButton(1, 174, true))
    u("Switch player")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(z, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(2)
    u("[" .. b .. "/" .. #A .. "]")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(z, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(z, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()
    return z
end
local function B()
    local C = 0.3
    local D = 0.075
    local E = 0.0
    local F = 0.7
    local G = GetSafeZoneSize()
    local H = G - E
    local I = G - F
    DrawSprite("timerbars", "all_black_bg", H, I, C, D, 0, 0, 0, 0, 200)
end
local function J()
    local A = CORRUPT.getActiveEventPlayers()
    if A[b + 1] then
        b = b + 1
        if A[b] then
            c = A[b].source
        end
    else
        if A[1] then
            b = 1
            c = A[b].source
        else
            b = 0
            c = nil
        end
    end
end
local function K()
    local A = CORRUPT.getActiveEventPlayers()
    if A[b - 1] then
        b = b - 1
        if A[b] then
            c = A[b].source
        end
    else
        b = #A
        if A[b] then
            c = A[b].source
        end
    end
end
CreateThread(
    function()
        RequestStreamedTextureDict("mphud", false)
        while not HasStreamedTextureDictLoaded("mphud") do
            Wait(0)
        end
        while true do
            if a then
                local A = CORRUPT.getActiveEventPlayers()
                local L = y("instructional_buttons", A)
                DrawScaleformMovieFullscreen(L, 0, 0, 0, 0, 0)
                B()
                DrawAdvancedTextNoOutline(
                    1.054,
                    0.247,
                    0.005,
                    0.0028,
                    0.45,
                    "SPECTATING",
                    255,
                    255,
                    255,
                    255,
                    CORRUPT.getFontId("Akrobat-Regular"),
                    0
                )
                local M = "N/A"

                if A[b] then
                    if A[b].name then
                        M = A[b].name
                    end
                    c = A[b].source
                end
                local N = string.gsub(M, "[^%a%d%p%s]", "")
                DrawAdvancedTextNoOutline(
                    1.025,
                    0.27,
                    0.005,
                    0.0028,
                    0.71,
                    N,
                    255,
                    255,
                    255,
                    255,
                    CORRUPT.getFontId("Akrobat-Regular"),
                    0
                )
                SetScriptGfxDrawOrder(7)
                DrawRect(0.999, 0.27, -0.003, 0.075, 198, 167, 73, 255)
                DrawSprite("mphud", "spectating", 0.915, 0.249, 0.018, 0.036, 0.0, 255, 255, 255, 255)
                if IsControlJustPressed(0, 174) then
                    K()
                elseif IsControlJustPressed(0, 175) then
                    J()
                end
                if b ~= 1 then
                    if not A[b] then
                        K()
                    end
                end
                local r = CORRUPT.getPlayerPed()
                FreezeEntityPosition(r, true)
                SetEntityCollision(r, false, false)
                SetEntityVisible(r, false, false)
                SetEntityProofs(r, true, true, true, true, true, true, true, true)
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        local O = GetGameTimer()
        while true do
            Wait(0)
            if a then
                DisableControlAction(0, 37, false)
                drawNativeNotification("To stop spectating and return to the main world run /leaveevent.")
                local P = GetPlayerFromServerId(c)
                if P ~= -1 then
                    local r = CORRUPT.getPlayerPed()
                    local Q = GetPlayerPed(P)
                    local R = GetEntityCoords(Q)
                    local S = GetActivePlayers()
                    for T, U in pairs(S) do
                        local V = GetPlayerPed(U)
                        SetEntityNoCollisionEntity(r, V, true)
                    end
                    if IsDisabledControlPressed(0, 261) then
                        f = f + 0.5
                    end
                    if IsDisabledControlPressed(0, 262) then
                        f = f - 0.5
                    end
                    if f > -1 then
                        f = -1
                    end
                    if f < -50 then
                        f = -50
                    end
                    local W = -GetDisabledControlNormal(0, 1)
                    local X = GetDisabledControlNormal(0, 2)
                    d = d + W * 10
                    if d >= 360 then
                        d = 0
                    end
                    e = e + X * 10
                    if e >= 360 then
                        e = 0
                    end
                    local Y = j(R, f, d, e)
                    if not DoesCamExist(g) or not IsCamActive(g) or not IsCamRendering(g) then
                        g = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                        SetCamActive(g, true)
                        RenderScriptCams(true, false, 0, true, true)
                    end
                    SetCamCoord(g, Y.x, Y.y, Y.z)
                    PointCamAtEntity(g, Q, 0.0, 0.0, 0.0, false)
                    SetFocusPosAndVel(R.x, R.y, R.z, 0.0, 0.0, 0.0)
                    SetEntityCoordsNoOffset(r, R.x, R.y, R.z - h)
                else
                    if i[c] then
                        DoScreenFadeOut(250)
                        local Z = i[c]
                        SetFocusPosAndVel(Z.x, Z.y, Z.z, 0.0, 0.0, 0.0)
                        SetEntityCoords(PlayerPedId(), Z.x, Z.y, Z.z - h)
                        Wait(250)
                        DoScreenFadeIn(250)
                    end
                    if GetGameTimer() - O > 5000 then
                        TriggerServerEvent("CORRUPT:requestActiveEventPlayerPositions")
                        O = GetGameTimer()
                    end
                    notify("~r~Couldn't spectate, person not in your zone")
                end
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:gotPlayerPositions",
    function(_)
        i = _
    end
)
RegisterNetEvent("CORRUPT:enterSpectator",function()
    local a0 = CORRUPT.getPlayerVehicle()
    if a0 ~= 0 then
        DeleteEntity(a0)
    end
    CORRUPT.setEventSpectatorMode(true)
end)

