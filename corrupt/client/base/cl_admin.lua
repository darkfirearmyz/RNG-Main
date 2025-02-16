noclipActive = false
local a = nil
local b = 1
local c = 0
local d = false
local e = false
local f = {
    controls = {
        goForward = 32,
        goBackward = 33,
        reduceSpeed = 19,
        increaseSpeed = 21
    },
    speeds = {
        {label = "Very Slow", speed = 0.1},
        {label = "Slow", speed = 0.5},
        {label = "Normal", speed = 2},
        {label = "Fast", speed = 4},
        {label = "Very Fast", speed = 6},
        {label = "Extremely Fast", speed = 10},
        {label = "Extremely Fast v2.0", speed = 20},
        {label = "Max Speed", speed = 25}
    },
    bgR = 0,
    bgG = 0,
    bgB = 0,
    bgA = 80
}
local function g(h)
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay(h)
    EndTextCommandScaleformString()
end
local function i(j)
    ScaleformMovieMethodAddParamPlayerNameString(j)
end
local function k(l)
    local l = RequestScaleformMovie(l)
    while not HasScaleformMovieLoaded(l) do
        Citizen.Wait(1)
    end
    BeginScaleformMovieMethod(l, "CLEAR_ALL")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_CLEAR_SPACE")
    ScaleformMovieMethodAddParamInt(200)
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(1)
    i(GetControlInstructionalButton(1, f.controls.goBackward, true))
    i(GetControlInstructionalButton(1, f.controls.goForward, true))
    g("Go Forwards/Backwards")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    i(GetControlInstructionalButton(2, f.controls.reduceSpeed, true))
    i(GetControlInstructionalButton(2, f.controls.increaseSpeed, true))
    g("Increase/Decrease Speed (" .. f.speeds[b].label .. ")")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()
    BeginScaleformMovieMethod(l, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(f.bgR)
    ScaleformMovieMethodAddParamInt(f.bgG)
    ScaleformMovieMethodAddParamInt(f.bgB)
    ScaleformMovieMethodAddParamInt(f.bgA)
    EndScaleformMovieMethod()
    return l
end
local noclipCheck = false
function tvRP.toggleNoclip()
    if not noclipCheck and CORRUPT.getStaffLevel() >= 4 then
        noclipCheck = true
    end
    noclipActive = not noclipActive
    if IsPedInAnyVehicle(CORRUPT.getPlayerPed(), false) then
        c = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
    else
        c = CORRUPT.getPlayerPed()
    end
    SetEntityCollision(c, not noclipActive, not noclipActive)
    FreezeEntityPosition(c, noclipActive)
    SetEntityInvincible(c, noclipActive)
    SetVehicleRadioEnabled(c, not noclipActive)
    if noclipActive then
        SetEntityVisible(CORRUPT.getPlayerPed(), false, false)
        tvRP.setCanAnim(false)
    else
        SetEntityVisible(CORRUPT.getPlayerPed(), true, false)
        tvRP.setCanAnim(true)
    end
end

RegisterKeyMapping("noclip", "Staff Noclip", "keyboard", "F4")
RegisterCommand("noclip",function()
    if CORRUPT.getStaffLevel() >= 4 then
        if not noclipCheck then
            TriggerServerEvent("CORRUPT:noClip")
        else
            tvRP.toggleNoclip()
            TriggerServerEvent("CORRUPT:noClipVerify")
        end
    end
end,false)


Citizen.CreateThread(
    function()
        local m = k("instructional_buttons")
        local n = f.speeds[b].speed
        while true do
            if noclipActive then
                DrawScaleformMovieFullscreen(m, 0, 0, 0, 0, 0)
                local o = 0.0
                local p = 0.0
                local q = CORRUPT.getPosition()
                local r, s, t = q.x, q.y, q.z
                local u, v, w = CORRUPT.getCamDirection()
                if IsDisabledControlJustPressed(1, f.controls.reduceSpeed) then
                    if b ~= 1 then
                        b = b - 1
                        n = f.speeds[b].speed
                    end
                    k("instructional_buttons")
                end
                if IsDisabledControlJustPressed(1, f.controls.increaseSpeed) then
                    if b ~= 8 then
                        b = b + 1
                        n = f.speeds[b].speed
                    end
                    k("instructional_buttons")
                end
                if IsControlPressed(0, f.controls.goForward) then
                    r = r + n * u
                    s = s + n * v
                    t = t + n * w
                end
                if IsControlPressed(0, f.controls.goBackward) then
                    r = r - n * u
                    s = s - n * v
                    t = t - n * w
                end
                if IsControlPressed(0, f.controls.goUp) then
                    p = f.offsets.z
                end
                if IsControlPressed(0, f.controls.goDown) then
                    p = -f.offsets.z
                end
                local x = GetEntityHeading(c)
                SetEntityVisible(PlayerPedId(), false, 0)
                SetEntityVelocity(c, 0.0, 0.0, 0.0)
                SetEntityRotation(c, u, v, w, 0, false)
                SetEntityHeading(c, x)
                SetEntityCoordsNoOffset(c, r, s, t, noclipActive, noclipActive, noclipActive)
            end
            Wait(0)
        end
    end
)
function tvRP.isStaffedOn()
    return e
end
local function y()
    local z = 0
    local A = CORRUPT.getStaffRank()
    if A == "founder" then
        z = 12
    elseif A == "leaddeveloper" then
        z = 11
    elseif A == "developer" then
        z = 10
    elseif A == "communitymanager" then
        z = 9
    elseif A == "staffmanager" then
        z = 8
    elseif A == "headadmin" then
        z = 7
    elseif A == "senioradmin" then
        z = 6
    elseif A == "admin" then
        z = 5
    elseif A == "seniormod" then
        z = 4
    elseif A == "mod" then
        z = 3
    elseif A == "support" then
        z = 2
    elseif A == "trial" then
        z = 1
    end
    local B = GetPedDrawableVariation(PlayerPedId(), 11)
    SetPedComponentVariation(PlayerPedId(), 11, B, z, 0)
end
RegisterNetEvent(
    "CORRUPT:OMioDioMode",
    function(C)
        if CORRUPT.getStaffLevel() > 0 then
            if not C then
                if tvRP.isStaffedOn() then
                    e = false
                    CORRUPT.setRedzoneTimerDisabled(false)
                    SetEntityInvincible(CORRUPT.getPlayerPed(), false)
                    SetPlayerInvincible(PlayerId(), false)
                    SetPedCanRagdoll(CORRUPT.getPlayerPed(), true)
                    ClearPedBloodDamage(CORRUPT.getPlayerPed())
                    ResetPedVisibleDamage(CORRUPT.getPlayerPed())
                    ClearPedLastWeaponDamage(CORRUPT.getPlayerPed())
                    SetEntityProofs(CORRUPT.getPlayerPed(), false, false, false, false, false, false, false, false)
                    SetEntityCanBeDamaged(CORRUPT.getPlayerPed(), true)
                    if not CORRUPT.isPurge() then
                        CORRUPT.setHealth(200)
                    end
                    tvRP.setCustomization(a)
                end
            else
                if not tvRP.isStaffedOn() then
                    e = true
                    CORRUPT.setRedzoneTimerDisabled(true)
                    a = tvRP.getCustomization()
                    if GetEntityHealth(PlayerPedId()) <= 102 then
                        TriggerEvent("Corrupt:Revive")
                    end
                    if CORRUPT.getModelGender() == "male" then
                        CORRUPT.loadCustomisationPreset("StaffMale")
                        if CORRUPT.isHalloween() then
                            CORRUPT.loadCustomisationPreset("StaffHalloweenMale")
                        end
                        if CORRUPT.isChristmas() then
                            CORRUPT.loadCustomisationPreset("StaffChristmasMale")
                        end
                    else
                        CORRUPT.loadCustomisationPreset("StaffFemale")
                        if CORRUPT.isHalloween() then
                            CORRUPT.loadCustomisationPreset("StaffHalloweenFemale")
                        end
                        if CORRUPT.isChristmas() then
                            CORRUPT.loadCustomisationPreset("StaffChristmasFemale")
                        end
                    end
                    y()
                end
            end
        end
    end
)
function CORRUPT.getModelGender()
    local D = CORRUPT.getPlayerPed()
    if GetEntityModel(D) == "mp_f_freemode_01" then
        return "female"
    else
        return "male"
    end
end

Citizen.CreateThread(
    function()
        while true do
            if tvRP.isStaffedOn() then
                local D = CORRUPT.getPlayerPed()
                SetEntityInvincible(D, true)
                SetPlayerInvincible(PlayerId(), true)
                SetPedCanRagdoll(D, false)
                ClearPedBloodDamage(D)
                ResetPedVisibleDamage(D)
                ClearPedLastWeaponDamage(D)
                SetEntityProofs(D, true, true, true, true, true, true, true, true)
                SetEntityCanBeDamaged(D, false)
                if not CORRUPT.isPurge() then
                    CORRUPT.setHealth(200)
                end
                if not CORRUPT.isPlayerInAdminTicket() then
                    drawNativeText("~r~Reminder: You are /staffon'd.")
                end
            end
            Wait(0)
        end
    end
)


RegisterCommand("fix", function()
    if tvRP.isStaffedOn() or CORRUPT.getStaffLevel() >= 6 then
        local p = PlayerPedId()
        if IsPedInAnyVehicle(p) then
            local E = GetVehiclePedIsIn(p)
            SetVehicleEngineHealth(E, 9999)
            SetVehiclePetrolTankHealth(E, 9999)
            SetVehicleFixed(E)
            tvRP.notify("~g~Fixed Vehicle")
        end
    end
end)


RegisterCommand("staffmode", function()
    if CORRUPT.getStaffLevel() > 0 and not CORRUPT.playerInWager() then
        if tvRP.isStaffedOn() then
            TriggerEvent("CORRUPT:OMioDioMode", false)
        else
            TriggerEvent("CORRUPT:OMioDioMode", true)
        end
    end
end)

globalIgnoreDeathSound = false
RegisterNetEvent(
    "CORRUPT:deathSound",
    function(E)
        local F = GetEntityCoords(CORRUPT.getPlayerPed())
        local G = #(F - E)
        if not globalIgnoreDeathSound and G <= 15 then
            SendNUIMessage({transactionType = CORRUPT.getDeathSound()})
        end
    end
)

RegisterNetEvent("CORRUPT:tpToWaypoint",function()
        local I = CORRUPT.getPlayerPed()
        local J = GetVehiclePedIsUsing(I)
        if IsPedInAnyVehicle(I) then
            I = J
        end
        if not IsWaypointActive() then
            tvRP.notify("~r~ Map Marker not found.")
            return
        end
        local K = GetFirstBlipInfoId(8)
        local r, s, t = table.unpack(GetBlipInfoIdCoord(K))
        local L
        local M = false
        local N = {
            100.0,
            150.0,
            50.0,
            0.0,
            200.0,
            250.0,
            300.0,
            350.0,
            400.0,
            450.0,
            500.0,
            550.0,
            600.0,
            650.0,
            700.0,
            750.0,
            800.0
        }
        for H, O in ipairs(N) do
            SetEntityCoordsNoOffset(I, r, s, O, 0, 0, 1)
            Wait(10)
            L, t = GetGroundZFor_3dCoord(r, s, O, 0.0, false)
            if L then
                t = t + 3
                M = true
                break
            end
        end
        if not M then
            t = 1000
            CORRUPT.allowweapon("GADGET_PARACHUTE")
            GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
        end
        SetEntityCoordsNoOffset(I, r, s, t, 0, 0, 1)
        tvRP.notify("~g~ Teleported to waypoint.")
    end)


RegisterNetEvent("CORRUPT:showBlips",function(P)
        if CORRUPT.getStaffLevel() >= 6 then
            d = P
            if d then
                tvRP.notify("~g~Blips enabled")
            else
                tvRP.notify("~r~Blips disabled")
                for Q, R in ipairs(GetActivePlayers()) do
                    local S = GetPlayerPed(R)
                    if GetPlayerPed(R) ~= CORRUPT.getPlayerPed() then
                        S = GetPlayerPed(R)
                        blip = GetBlipFromEntity(S)
                        RemoveBlip(blip)
                    end
                end
            end
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if d then
                for Q, R in ipairs(GetActivePlayers()) do
                    local I = GetPlayerPed(R)
                    if I ~= GetPlayerPed(-1) then
                        local blip = GetBlipFromEntity(I)
                        local T = GetPlayerServerId(R)
                        local U = CORRUPT.clientGetUserIdFromSource(T)
                        if not DoesBlipExist(blip) and not CORRUPT.isUserHidden(U) then
                            blip = AddBlipForEntity(I)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            local V = GetVehiclePedIsIn(I, false)
                            SetBlipSprite(blip, 1)
                            ShowHeadingIndicatorOnBlip(blip, true)
                            SetBlipRotation(blip, math.ceil(GetEntityHeading(V)))
                            SetBlipNameToPlayerName(blip, R)
                            SetBlipScale(blip, 0.85)
                            SetBlipAlpha(blip, 255)
                        end
                    end
                end
            end
            Wait(1000)
        end
    end
)
function CORRUPT.hasStaffBlips()
    return d
end
