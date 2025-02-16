local a = module("cfg/atms")
local b = false
RMenu.Add(
    "corruptatm",
    "mainmenu",
    RageUI.CreateMenu("", "", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_atmui", "corrupt_atmui")
)
RMenu:Get("corruptatm", "mainmenu"):SetSubtitle("~b~ATM")
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corruptatm", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corruptatm", "mainmenu"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Deposit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(c, d, e)
                        if e then
                            local f = getAtmAmount()
                            if tonumber(f) then
                                if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                                    if a then
                                        tvRP.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                        TriggerServerEvent("CORRUPT:Deposit", tonumber(f))
                                    else
                                        tvRP.notify("~r~Not near ATM.")
                                    end
                                else
                                    tvRP.notify("~r~Get out your vehicle to use the ATM")
                                end
                            else
                                tvRP.notify("~r~Invalid amount.")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Withdraw",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(c, d, e)
                        if e then
                            local f = getAtmAmount()
                            if tonumber(f) then
                                if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                                    if a then
                                        tvRP.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                        TriggerServerEvent("CORRUPT:Withdraw", tonumber(f))
                                    else
                                        tvRP.notify("~r~Not near ATM.")
                                    end
                                else
                                    tvRP.notify("~r~Get out your vehicle to use the ATM")
                                end
                            else
                                tvRP.notify("~r~Invalid amount.")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Deposit All",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(c, d, e)
                        if e then
                            if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                                if a then
                                    tvRP.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                    TriggerServerEvent("CORRUPT:DepositAll")
                                else
                                    tvRP.notify("~r~Not near ATM.")
                                end
                            else
                                tvRP.notify("~r~Get out your vehicle to use the ATM")
                            end
                        end
                    end,
                    nil
                )
                RageUI.ButtonWithStyle(
                    "Withdraw All",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(c, d, e)
                        if e then
                            if GetVehiclePedIsIn(PlayerPedId(), false) == 0 then
                                if a then
                                    tvRP.playAnim(false, {{"amb@prop_human_atm@male@exit", "exit"}}, false)
                                    TriggerServerEvent("CORRUPT:WithdrawAll")
                                else
                                    tvRP.notify("~r~Not near ATM.")
                                end
                            else
                                tvRP.notify("~r~Get out your vehicle to use the ATM")
                            end
                        end
                    end,
                    nil
                )
            end,
            function()
            end
        )
    end
)
local function g()
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("corruptatm", "mainmenu"), true)
end
local function h()
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("corruptatm", "mainmenu"), false)
end
Citizen.CreateThread(
    function()
        local i = function(j)
            tvRP.setCanAnim(false)
            g()
            b = true
        end
        local k = function(j)
            h()
            tvRP.setCanAnim(true)
            b = false
        end
        local l = function(j)
        end
        for m, n in pairs(a.atms) do
            CORRUPT.createArea("atm_" .. m, n, 1.5, 6, i, k, l, {atmId = m})
            local o = tvRP.addBlip(n.x, n.y, n.z, 108, 4, "ATM", 0.8, true)
            tvRP.addMarker(n.x, n.y, n.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 29, false, false, true)
            for p, q in pairs(a.robberyAtms) do
                if #(n - q.xyz) < 5.0 then
                    SetBlipColour(o, 1)
                end
            end
        end
    end
)
function getAtmAmount()
    AddTextEntry("FMMC_MPM_NA", "Enter amount")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local r = GetOnscreenKeyboardResult()
        if r then
            return r
        end
    end
    return false
end
local s = {}
function CORRUPT.createAtm(t, u)
    local i = function()
        tvRP.setCanAnim(false)
        g()
        b = true
    end
    local k = function()
        h()
        tvRP.setCanAnim(true)
        b = false
    end
    local v = string.format("atm_%s", t)
    CORRUPT.createArea(
        v,
        u,
        1.5,
        6,
        i,
        k,
        function()
        end
    )
    local w = tvRP.addMarker(u.x, u.y, u.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 29, false, false, true)
    s[t] = {area = v, marker = w}
end
function CORRUPT.deleteAtm(t)
    local x = s[t]
    if x then
        tvRP.removeMarker(x.marker)
        tvRP.removeArea(x.area)
        s[t] = nil
    end
end
local y = false
local function z(A)
    local B = true
    local C = false
    Citizen.CreateThread(
        function()
            while not C do
                drawNativeNotification("Press ~INPUT_JUMP~ in the correct area to cut the wire.")
                Citizen.Wait(0)
            end
        end
    )
    for p = 1, math.random(3, 4) do
        local D = math.random(1, 4) <= 3 and "Easy" or "Medium"
        local E = true
        CORRUPT.minigameCircularProgressBar(
            {Difficulty = D, Timeout = 25000, onComplete = function(F)
                    B = F
                    E = false
                end, onTimeout = function()
                    B = false
                    E = false
                end}
        )
        while E do
            drawNativeText("Cut the wires")
            Citizen.Wait(0)
        end
        tvRP.setPlayerCombatTimer(30, false)
        if not B then
            PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
            break
        else
            PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)
            Citizen.Wait(2000)
            PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
            tvRP.startCircularProgressBar(
                "",
                2000,
                nil,
                function()
                end
            )
            TriggerServerEvent("CORRUPT:atmWireCutSparks", A, false)
            Citizen.Wait(2000)
        end
    end
    C = true
    return B
end
local function G(H)
    local I = math.rad(-0.8738472)
    local J = math.rad(H.w)
    local K = vector3(-math.sin(J) * math.abs(math.cos(I)), math.cos(J) * math.abs(math.cos(I)), math.sin(I))
    return H.xyz + K * 0.65
end
RegisterNetEvent(
    "CORRUPT:atmWireCuttingSuccessSync",
    function(A)
        local L = a.robberyAtms[A]
        local M = G(L)
        CORRUPT.loadPtfx("core")
        StartParticleFxNonLoopedAtCoord(
            "ent_sht_electrical_box",
            M.x,
            M.y,
            M.z - 0.5,
            L.w,
            0.0,
            0.0,
            2.0,
            false,
            false,
            false
        )
        RemoveNamedPtfxAsset("core")
        CORRUPT.loadPtfx("scr_xs_celebration")
        local N =
            StartParticleFxLoopedAtCoord(
            "scr_xs_money_rain",
            M.x,
            M.y,
            M.z - 0.2,
            L.w + 90.0,
            0.0,
            0.0,
            1.0,
            false,
            false,
            false,
            0
        )
        RemoveNamedPtfxAsset("scr_xs_celebration")
        Citizen.Wait(15000)
        StopParticleFxLooped(N, false)
    end
)
RegisterNetEvent(
    "CORRUPT:atmWireCuttingSuccess",
    function()
        local O = GetGameTimer()
        local P = 0
        while true do
            local Q = GetGameTimer()
            if Q - O > 15000 then
                break
            elseif Q - P >= math.random(150, 650) then
                PlaySoundFrontend(-1, "Bus_Schedule_Pickup", "DLC_PRISON_BREAK_HEIST_SOUNDS", false)
                P = Q
            end
            Citizen.Wait(0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:atmWireCutSparks",
    function(A)
        local L = a.robberyAtms[A]
        local M = G(L)
        CORRUPT.loadPtfx("core")
        StartParticleFxNonLoopedAtCoord(
            "ent_dst_electrical",
            M.x,
            M.y,
            M.z - 0.5,
            L.w,
            0.0,
            0.0,
            2.0,
            false,
            false,
            false
        )
        RemoveNamedPtfxAsset("core")
    end
)
RegisterNetEvent(
    "CORRUPT:startAtmWireCutting",
    function(A)
        y = true
        local R = PlayerPedId()
        local L = a.robberyAtms[A]
        tvRP.setCanAnim(false)
        tvRP.setPlayerCombatTimer(30, false)
        CORRUPT.setWeapon(R, "WEAPON_UNARMED", true)
        ClearPedTasksImmediately(R)
        Citizen.Wait(1000)
        TaskGoStraightToCoord(R, L.x, L.y, L.z, 1.0, 5000, L.w, 0.1)
        while GetScriptTaskStatus(R, "SCRIPT_TASK_GO_STRAIGHT_TO_COORD") ~= 7 do
            Citizen.Wait(0)
        end
        CORRUPT.loadClipSet("move_ped_crouched")
        SetPedCanPlayAmbientAnims(R, false)
        SetPedCanPlayAmbientBaseAnims(R, false)
        SetPedMovementClipset(R, "move_ped_crouched", 0.35)
        SetPedStrafeClipset(R, "move_ped_crouched_strafing")
        RemoveClipSet("move_ped_crouched")
        CORRUPT.loadAnimDict("mini@repair")
        TaskPlayAnim(R, "mini@repair", "fixing_a_ped", 8.0, -8.0, -1, 17, 0, false, false, false)
        RemoveAnimDict("mini@repair")
        local S = z(A)
        TriggerServerEvent("CORRUPT:returnAtmWireCutting", A, S)
        StopAnimTask(R, "mini@repair", "fixing_a_ped", 1.0)
        ResetPedStrafeClipset(R)
        ResetPedMovementClipset(R, 0.0)
        SetPedCanPlayAmbientAnims(R, true)
        SetPedCanPlayAmbientBaseAnims(R, true)
        tvRP.setCanAnim(true)
        y = false
    end
)
RegisterNetEvent(
    "CORRUPT:atmInkArea",
    function(A)
        local L = a.robberyAtms[A]
        CORRUPT.loadPtfx("veh_xs_vehicle_mods")
        for p = 1, 10 do
            UseParticleFxAsset("veh_xs_vehicle_mods")
            StartParticleFxNonLoopedAtCoord(
                "exp_xs_mine_tar",
                L.x,
                L.y,
                L.z - 0.5,
                0.0,
                0.0,
                0.0,
                1.0,
                false,
                false,
                false
            )
            Citizen.Wait(50)
        end
        RemoveNamedPtfxAsset("veh_xs_vehicle_mods")
    end
)
RegisterNetEvent(
    "CORRUPT:atmGenericAlarm",
    function(A)
        local L = a.robberyAtms[A]
        while not RequestScriptAudioBank("Alarms", false) do
            Citizen.Wait(0)
        end
        local T = GetSoundId()
        PlaySoundFromCoord(T, "Burglar_Bell", L.x, L.y, L.z, "Generic_Alarms", false, 0.05, false)
        Citizen.Wait(60000)
        StopSound(T)
        ReleaseSoundId(T)
    end
)
local U = 0
local V = 0
local W = false
local X = 0
local function Y(j)
    U = math.random(6, 12)
    X = 0
    TriggerServerEvent("CORRUPT:getAtmHasBeenRobbed", j.robberyId)
end
local function Z(j)
    if y then
        TriggerServerEvent("CORRUPT:atmStopWireCutting", j.robberyId)
    end
    V = 0
end
local function _()
    RequestScriptAudioBank("NIGEL_02_CRASH_A", true, -1)
    RequestScriptAudioBank("NIGEL_02_CRASH_B", true, -1)
    Citizen.Wait(500)
    local a0 = CORRUPT.getPlayerCoords()
    local a1 = math.random(1, 10) >= 8 and "WINDOW_CRASH" or "WALL_CRASH"
    PlaySoundFromCoord(-1, a1, a0.x, a0.y, a0.z, "NIGEL_02_SOUNDSET", 0, 0, 0)
    Citizen.Wait(1500)
    ReleaseNamedScriptAudioBank("NIGEL_02_CRASH_B")
    ReleaseNamedScriptAudioBank("NIGEL_02_CRASH_A")
end
local a2 = {{"des_vaultdoor", "ent_ray_pro1_concrete_impacts"}, {"des_fib_glass", "ent_ray_fbi2_window_break"}}
local function a3()
    local a4 = a2[math.random(1, #a2)]
    CORRUPT.loadPtfx(a4[1])
    Citizen.Wait(500)
    UseParticleFxAsset(a4[1])
    local a0 = CORRUPT.getPlayerCoords() + GetEntityForwardVector(PlayerPedId()) * 1.0
    StartParticleFxNonLoopedAtCoord(a4[2], a0.x, a0.y, a0.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
    RemoveNamedPtfxAsset(a4[1])
end
local function a5(j)
    if y then
        return
    end
    local R = PlayerPedId()
    if select(2, GetCurrentPedWeapon(R)) == `WEAPON_CROWBAR` then
        if X > 0 then
            local a6 = X
            if a6 > 0 then
                local a7 = formatTimeString(formatTime(a6))
                drawNativeNotification("This ATM has been robbed recently. You can rob it in " .. a7, true)
            end
            return
        end
        drawNativeNotification("Hit the ATM with ~INPUT_ATTACK~ to begin breaking the door.")
        if V > 0 then
            local a8 = math.floor(V / U * 100)
            if a8 > 100 then
                a8 = 100
            end
            subtitleText("~r~ATM door damage " .. tostring(a8) .. "%")
        end
        if RageUI.Visible(RMenu:Get("corruptatm", "mainmenu")) then
            RageUI.Visible(RMenu:Get("corruptatm", "mainmenu"), false)
        end
        DisableControlAction(0, 24, true)
        if IsDisabledControlJustPressed(0, 24) and not W then
            Citizen.CreateThreadNow(
                function()
                    W = true
                    local L = a.robberyAtms[j.robberyId]
                    ClearPedTasks(R)
                    TaskGoStraightToCoord(R, L.x, L.y, L.z, 1.0, 3000, L.w, 0.35)
                    while GetScriptTaskStatus(R, "SCRIPT_TASK_GO_STRAIGHT_TO_COORD") ~= 7 do
                        Citizen.Wait(0)
                    end
                    CORRUPT.loadAnimDict("melee@small_wpn@streamed_core")
                    R = PlayerPedId()
                    TaskPlayAnim(
                        R,
                        "melee@small_wpn@streamed_core",
                        "ground_attack_on_spot",
                        8.0,
                        8.0,
                        -1,
                        1,
                        1.0,
                        false,
                        false,
                        false
                    )
                    RemoveAnimDict("melee@small_wpn@streamed_core")
                    Citizen.CreateThread(_)
                    Citizen.CreateThread(a3)
                    Citizen.Wait(2000)
                    ClearPedTasks(R)
                    V = V + 1
                    if V >= U then
                        TriggerServerEvent("CORRUPT:startAtmWireCutting", j.robberyId)
                    end
                    TaskPedSlideToCoord(R, L.x, L.y, L.z, L.w, 2000)
                    while GetScriptTaskStatus(R, "SCRIPT_TASK_PED_SLIDE_TO_COORD") ~= 7 do
                        Citizen.Wait(0)
                    end
                    W = false
                end
            )
        end
    end
end
Citizen.CreateThread(
    function()
        for A, L in pairs(a.robberyAtms) do
            CORRUPT.createArea("atmrobbery_" .. A, L.xyz, 1.5, 6, Y, Z, a5, {robberyId = A})
        end
    end
)
RegisterNetEvent(
    "CORRUPT:setAtmHasBeenRobbed",
    function(a9)
        X = a9
    end
)
