RMenu.Add("settingsmenu", "settings", RageUI.CreateMenu("", "~b~Settings Menu", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "graphicpresets", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Graphics Presets", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "changediscord", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Link Discord", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "compsettings", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Compensations", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "killeffects", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Kill Effects", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "bloodeffects", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Blood Effects", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "uisettings", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~UI Related Settings", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "weaponsettings", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Weapon Related Settings", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "weaponswhitelist", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Custom Weapons Owned", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "generateaccesscode", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "weaponswhitelist"), "", "~b~Generate Access Code", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "viewwhitelisted", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "generateaccesscode"), "", "~b~View Whitelisted Users", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "gangsettings", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Gang Related Settings", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))
RMenu.Add("settingsmenu", "miscsettings", RageUI.CreateSubMenu(RMenu:Get("settingsmenu", "settings"), "", "~b~Miscellaneous Settings", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_settingsui", "corrupt_settingsui"))

local a = module("cfg/cfg_settings")
local b = 0
local c = 0
local d = 0
local e = false
local g = false
local h = false
local i = false
local j = 1
local k = {30.0, 45.0, 60.0, 75.0, 90.0, 500.0}
local l = {"30m", "45m", "60m", "75m", "90m", "500m"}
local m = 1
local n = {"None", "1", "2", "3", "4", "5", "6", "7", "8"}
local o = 1
local p = {"10%", "20%", "30%", "40%", "50%", "60%", "70%", "80%", "90%", "100%"}
local q = 3
local gangmarkersize = 1
local r = 1
local s = {"1%"}
local t = 1
local u = {"1%"}
local v = {"Visible", "Muted", "Hidden"}
local w = 1
local x = true
local y = false
local z = false
local LegacyInventory = false
local A = 1
local djmusic = {volume = 100}
local B = {"CORRUPT", "GLife", "Fortnite"}
local C = {"Discord", "Custom", "None"}
local D = {"Smallest", "Small", "Medium", "Large"}
local E = {32, 40, 48, 56}
local timecycleIndex = 1
local weatherIndex = 1
for H = 20, 500, 20 do
    table.insert(s, string.format("%d%%", H))
end
for H = 5, 200, 5 do
    table.insert(u, string.format("%d%%", H))
end
Citizen.CreateThread(
    function()
        local I = GetResourceKvpString("corrupt_diagonalweapons") or "false"
        if I == "false" then
            b = false
            TriggerEvent("CORRUPT:setVerticalWeapons")
        else
            b = true
            TriggerEvent("CORRUPT:setDiagonalWeapons")
        end
        local J = GetResourceKvpString("corrupt_frontars") or "false"
        if J == "false" then
            c = false
            TriggerEvent("CORRUPT:setBackAR")
        else
            c = true
            TriggerEvent("CORRUPT:setFrontAR")
        end
        local K = GetResourceKvpString("corrupt_hitmarkersounds") or "false"
        if K == "false" then
            d = false
            TriggerEvent("CORRUPT:hsSoundsOff")
        else
            d = true
            TriggerEvent("CORRUPT:hsSoundsOn")
        end
        local L = GetResourceKvpString("corrupt_reducedchatopacity") or "false"
        if L == "false" then
            f = false
            TriggerEvent("CORRUPT:chatReduceOpacity", false)
        else
            f = true
            TriggerEvent("CORRUPT:chatReduceOpacity", true)
        end
        local legacy = GetResourceKvpString("corrupt_legacyinventory") or "false"
        if legacy == "false" then
            LegacyInventory = false
        else
            LegacyInventory = true
        end
        local M = GetResourceKvpString("corrupt_hideeventannouncement") or "false"
        if M == "false" then
            g = false
        else
            g = true
        end
        local N = GetResourceKvpString("corrupt_healthpercentage") or "false"
        if N == "false" then
            h = false
        else
            h = true
        end
        local O = GetResourceKvpString("corrupt_flashlightnotaiming") or "false"
        if O == "false" then
            i = false
        else
            i = true
            SetFlashLightKeepOnWhileMoving(true)
        end
        local P = GetResourceKvpInt("corrupt_gang_name_distance")
        if P > 0 then
            j = P
            if k[j] then
                TriggerEvent("CORRUPT:setGangNameDistance", k[j])
            end
        end
        local Q = GetResourceKvpInt("corrupt_gang_ping_sound")
        if Q > 0 then
            m = Q
        end
        local R = GetResourceKvpInt("corrupt_gang_ping_volume")
        if R > 0 then
            o = R
        end
        local S = GetResourceKvpInt("corrupt_gang_ping_marker")
        if S > 0 then
            q = S
        end
        local gngmarker = GetResourceKvpInt("corrupt_gang_ping_marker_size")
        if gngmarker > 0 then
            gangmarkersize = gngmarker
        end
        local T = GetResourceKvpInt("corrupt_gang_position_x")
        if T > 0 then
            r = T
            CORRUPT.setGangUIXPos(s[r])
        end
        local U = GetResourceKvpInt("corrupt_gang_position_y")
        if U > 0 then
            t = U
            CORRUPT.setGangUIYPos(u[t])
        end
        local V = GetResourceKvpInt("corrupt_doorbell_index")
        if V > 0 then
            w = V
        end
        local W = GetResourceKvpString("corrupt_gang_ping_minimap") or "false"
        if W == "false" then
            gangPingMinimap = false
        else
            gangPingMinimap = true
        end
        local X = GetResourceKvpString("corrupt_radio_anim") or "true"
        if X == "false" then
            x = false
        else
            x = true
        end
        local Y = GetResourceKvpString("corrupt_low_props") or "false"
        if Y == "false" then
            y = false
        else
            y = true
        end
        local Z = GetResourceKvpString("corrupt_frontsmgs") or "false"
        if Z == "false" then
            z = false
            TriggerEvent("CORRUPT:setBackSMG")
        else
            z = true
            TriggerEvent("CORRUPT:setFrontSMG")
        end
        local Z_timecycle = GetResourceKvpInt("corrupt_timecycle_index")
        if Z_timecycle > 0 then
            timecycleIndex = Z_timecycle
            SetTimecycleModifier(a.timecycles.values[timecycleIndex])
        end
        local I_weather = GetResourceKvpInt("corrupt_weather_index")
        if I_weather > 0 then
            weatherIndex = I_weather
            Wait(1000)
            CORRUPT.setWeather(a.weathers.values[weatherIndex])
        end
    end
)
function CORRUPT.setDiagonalWeaponSetting(i)
    SetResourceKvp("corrupt_diagonalweapons", tostring(i))
end
function CORRUPT.setFrontARSetting(i)
    SetResourceKvp("corrupt_frontars", tostring(i))
end
function CORRUPT.setFrontSMGSetting(i)
    SetResourceKvp("corrupt_frontsmgs", tostring(i))
end
function CORRUPT.setHitMarkerSetting(i)
    SetResourceKvp("corrupt_hitmarkersounds", tostring(i))
end
function CORRUPT.setCODHitMarkerSetting(i)
    SetResourceKvp("corrupt_codhitmarkersounds", tostring(i))
end
function CORRUPT.setKillListSetting(Q)
    SetResourceKvp("corrupt_killlistsetting", tostring(Q))
end
function CORRUPT.setOldKillfeed(Q)
    SetResourceKvp("corrupt_oldkillfeed", tostring(Q))
end
function CORRUPT.setDamageIndicator(Q)
    SetResourceKvp("corrupt_damageindicator", tostring(Q))
end
function CORRUPT.setDamageIndicatorColour(Q)
    SetResourceKvp("corrupt_damageindicatorcolour", tostring(Q))
end
function CORRUPT.setReducedChatOpacity(K)
    SetResourceKvp("corrupt_reducedchatopacity", tostring(K))
end
function CORRUPT.setLegacyInventory(K)
    SetResourceKvp("corrupt_legacyinventory", tostring(K))
end
function CORRUPT.setHideEventAnnouncementFlag(K)
    SetResourceKvp("corrupt_hideeventannouncement", tostring(K))
end
function CORRUPT.getHideEventAnnouncementFlag()
    return g
end
function CORRUPT.getLegacyInventory()
    return LegacyInventory
end
function CORRUPT.setShowHealthPercentageFlag(K)
    SetResourceKvp("corrupt_healthpercentage", tostring(K))
end
function CORRUPT.getShowHealthPercentageFlag()
    return h
end
function CORRUPT.setFlashlightNotAimingFlag(R)
    SetFlashLightKeepOnWhileMoving(R)
    i = R
    SetResourceKvp("corrupt_flashlightnotaiming", tostring(R))
end
function CORRUPT.setRadioAnim(R)
    x = R
    SetResourceKvp("corrupt_radio_anim", tostring(R))
end
function CORRUPT.getRadioAnim()
    return x
end
function CORRUPT.setLowProps(R)
    y = R
    SetResourceKvp("corrupt_low_props", tostring(R))
end
function CORRUPT.getGangPingSound()
    return m
end
function CORRUPT.getGangPingVolume()
    return o
end
function CORRUPT.getGangPingMarkerIndex()
    return q
end
function CORRUPT.getGangPingMarkerSize()
    return gangmarkersize
end
function CORRUPT.getDoorbellIndex()
    return w
end
local function a0(j)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("settingsmenu", "settings"), j)
end
local H = {
    {"50%", 0.5},
    {"60%", 0.6},
    {"70%", 0.7},
    {"80%", 0.8},
    {"90%", 0.9},
    {"100%", 1.0},
    {"150%", 1.5},
    {"200%", 2.0},
    {"1000%", 10.0}
}
local a1 = {"50%", "60%", "70%", "80%", "90%", "100%", "150%", "200%", "1000%"}
local I = 6
local J = {}
local compensation = {}
local K
local L
local M
local N
RegisterNetEvent(
    "CORRUPT:gotCustomWeaponsOwned",
    function(O)
        J = O
    end
)
RegisterNetEvent(
    "CORRUPT:generatedAccessCode",
    function(a2)
        M = a2
    end
)
RegisterNetEvent(
    "CORRUPT:getWhitelistedUsers",
    function(P)
        N = P
    end
)

RegisterNetEvent(
    "CORRUPT:gotCompensation",
    function(Q)
        compensation = Q
    end
)
local Q = {}
local function R(S, T)
    return Q[S.name .. T.name]
end
local function U(S)
    local V = false
    for W, T in pairs(S.presets) do
        if Q[S.name .. T.name] then
            V = true
            Q[S.name .. T.name] = nil
        end
    end
    if V then
        for X, Y in pairs(S.default) do
            SetVisualSettingFloat(X, Y)
        end
    end
end
local function Z(T)
    for X, Y in pairs(T.values) do
        SetVisualSettingFloat(X, Y)
    end
end
local function _(S, T, a3)
    U(S)
    if a3 then
        Q[S.name .. T.name] = true
        Z(T)
    end
    local a4 = json.encode(Q)
    SetResourceKvp("corrupt_graphic_presets", a4)
end
local a5 = {
    "0%",
    "5%",
    "10%",
    "15%",
    "20%",
    "25%",
    "30%",
    "35%",
    "40%",
    "45%",
    "50%",
    "55%",
    "60%",
    "65%",
    "70%",
    "75%",
    "80%",
    "85%",
    "90%",
    "95%",
    "100%"
}
local a6 = {
    0.0,
    0.05,
    0.1,
    0.15,
    0.2,
    0.25,
    0.3,
    0.35,
    0.4,
    0.45,
    0.5,
    0.55,
    0.6,
    0.65,
    0.7,
    0.75,
    0.8,
    0.85,
    0.9,
    0.95,
    1.0
}
local a7 = {
    "25%",
    "50%",
    "75%",
    "100%",
    "125%",
    "150%",
    "175%",
    "200%",
    "250%",
    "300%",
    "350%",
    "400%",
    "450%",
    "500%",
    "750%",
    "1000%"
}
local a8 = {0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0, 2.5, 3.0, 3.5, 4.0, 4.5, 5.0, 7.5, 10.0}
local a9 = {
    "0.1s",
    "0.2s",
    "0.3s",
    "0.4s",
    "0.5s",
    "0.6s",
    "0.7s",
    "0.8s",
    "0.9s",
    "1s",
    "1.25s",
    "1.5s",
    "1.75s",
    "2.0s"
}
local aa = {100, 200, 300, 400, 500, 600, 700, 800, 900, 1000, 1250, 1500, 1750, 2000}
local ab = {
    "Disabled",
    "Fireworks",
    "Celebration",
    "Firework Burst",
    "Water Explosion",
    "Ramp Explosion",
    "Gas Explosion",
    "Electrical Spark",
    "Electrical Explosion",
    "Concrete Impact",
    "EMP 1",
    "EMP 2",
    "EMP 3",
    "Spike Mine",
    "Kinetic Mine",
    "Tar Mine",
    "Short Burst",
    "Fog Sphere",
    "Glass Smash",
    "Glass Drop",
    "Falling Leaves",
    "Wood Smash",
    "Train Smoke",
    "Money",
    "Confetti",
    "Marbles",
    "Sparkles"
}
local ac = {
    {"DISABLED", "DISABLED", 1.0},
    {"scr_indep_fireworks", "scr_indep_firework_shotburst", 0.2},
    {"scr_xs_celebration", "scr_xs_confetti_burst", 1.2},
    {"scr_rcpaparazzo1", "scr_mich4_firework_burst_spawn", 1.0},
    {"particle cut_finale1", "cs_finale1_car_explosion_surge_spawn", 1.0},
    {"des_fib_floor", "ent_ray_fbi5a_ramp_explosion", 1.0},
    {"des_gas_station", "ent_ray_paleto_gas_explosion", 0.5},
    {"core", "ent_dst_electrical", 1.0},
    {"core", "ent_sht_electrical_box", 1.0},
    {"des_vaultdoor", "ent_ray_pro1_concrete_impacts", 1.0},
    {"scr_xs_dr", "scr_xs_dr_emp", 1.0},
    {"scr_xs_props", "scr_xs_exp_mine_sf", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_emp", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_spike", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_kinetic", 1.0},
    {"veh_xs_vehicle_mods", "exp_xs_mine_tar", 1.0},
    {"scr_stunts", "scr_stunts_shotburst", 1.0},
    {"scr_tplaces", "scr_tplaces_team_swap", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_window_break", 1.0},
    {"des_fib_glass", "ent_ray_fbi2_glass_drop", 2.5},
    {"des_stilthouse", "ent_ray_fam3_falling_leaves", 1.0},
    {"des_stilthouse", "ent_ray_fam3_wood_frags", 1.0},
    {"des_train_crash", "ent_ray_train_smoke", 1.0},
    {"core", "ent_brk_banknotes", 2.0},
    {"core", "ent_dst_inflate_ball_clr", 1.0},
    {"core", "ent_dst_gen_gobstop", 1.0},
    {"core", "ent_sht_telegraph_pole", 1.0}
}
local ad = {
    "Disabled",
    "BikerFilter",
    "CAMERA_BW",
    "drug_drive_blend01",
    "glasses_blue",
    "glasses_brown",
    "glasses_Darkblue",
    "glasses_green",
    "glasses_purple",
    "glasses_red",
    "helicamfirst",
    "hud_def_Trevor",
    "Kifflom",
    "LectroDark",
    "MP_corona_tournament_DOF",
    "MP_heli_cam",
    "mugShot",
    "NG_filmic02",
    "REDMIST_blend",
    "trevorspliff",
    "ufo",
    "underwater",
    "WATER_LAB",
    "WATER_militaryPOOP",
    "WATER_river",
    "WATER_salton"
}
local ae = {
    lightning = false,
    pedFlash = false,
    pedFlashRGB = {11, 11, 11},
    pedFlashIntensity = 4,
    pedFlashTime = 1,
    screenFlash = false,
    screenFlashRGB = {11, 11, 11},
    screenFlashIntensity = 4,
    screenFlashTime = 1,
    particle = 1,
    timecycle = 1,
    timecycleTime = 1
}
local af = 0
local function ag()
    local ah = json.encode(ae)
    SetResourceKvp("corrupt_kill_effects", ah)
end
local ai = {head = 1, body = 1, arms = 1, legs = 1}
local function aj()
    local ak = json.encode(ai)
    SetResourceKvp("corrupt_blood_effects", ak)
end
Citizen.CreateThread(
    function()
        Citizen.Wait(1000)
        local a4 = GetResourceKvpString("corrupt_graphic_presets")
        if a4 and a4 ~= "" then
            Q = json.decode(a4) or {}
        end
        for W, S in pairs(a.presets) do
            for W, T in pairs(S.presets) do
                if R(S, T) then
                    Z(T)
                end
            end
        end
        local ah = GetResourceKvpString("corrupt_kill_effects")
        if ah and ah ~= "" then
            local al = json.decode(ah)
            for am, a3 in pairs(al) do
                if ae[am] then
                    ae[am] = a3
                end
            end
        end
        local ak = GetResourceKvpString("corrupt_blood_effects")
        if ak and ak ~= "" then
            local al = json.decode(ak)
            for am, a3 in pairs(al) do
                if ai[am] then
                    ai[am] = a3
                end
            end
        end
    end
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("settingsmenu", "settings"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "settings"),
            true,
            false,
            true,
            function()
                if CORRUPT.isNewPlayer() then
                    drawNativeNotification(
                        "Press ~INPUT_REPLAY_START_STOP_RECORDING_SECONDARY~ to toggle the Options Menu."
                    )
                end
                RageUI.ButtonWithStyle(
                    "Weapon Whitelists",
                    "Sell your custom weapon whitelists here.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            M = nil
                            K = nil
                            L = nil
                            N = nil
                            TriggerServerEvent("CORRUPT:getCustomWeaponsOwned")
                        end
                    end,
                    RMenu:Get("settingsmenu", "weaponswhitelist")
                )
                RageUI.ButtonWithStyle(
                    "Weapon Options",
                    "Weapon related options.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("settingsmenu", "weaponsettings")
                )
                if CORRUPT.isInGang() then
                    RageUI.ButtonWithStyle(
                        "Gang Options",
                        "Gang related options.",
                        {RightLabel = "→→→"},
                        true,
                        function(an, ao, ap)
                        end,
                        RMenu:Get("settingsmenu", "gangsettings")
                    )
                end
                RageUI.ButtonWithStyle(
                    "Graphic Presets",
                    "View a list of preconfigured graphic settings.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("settingsmenu", "graphicpresets")
                )
                RageUI.ButtonWithStyle(
                    "Kill Effects",
                    "Toggle effects that occur on killing a player.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("settingsmenu", "killeffects")
                )
                RageUI.ButtonWithStyle(
                    "Blood Effects",
                    "Toggle effects that occur when damaging a player.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("settingsmenu", "bloodeffects")
                )
                RageUI.ButtonWithStyle(
                    "UI Visibility",
                    "UI related options.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("settingsmenu", "uisettings")
                )
                RageUI.ButtonWithStyle(
                    "Change Linked Discord",
                    "Begins the process of changing your linked Discord. Your linked discord is used to sync roles with the server.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("CORRUPT:changeLinkedDiscord")
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Compensation",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("CORRUPT:getCompensation")
                        end
                    end,
                    RMenu:Get("settingsmenu", "compsettings")
                )
                RageUI.ButtonWithStyle(
                    "Miscellaneous",
                    "Miscellaneous options.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("settingsmenu", "miscsettings")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "uisettings"),
            true,
            false,
            true,
            function()
                RageUI.Checkbox(
                    "Hide Event Announcements",
                    "Hides the big scaleform from displaying across your screen, will still announce in chat.",
                    g,
                    {},
                    function()
                    end,
                    function()
                        g = true
                        CORRUPT.setHideEventAnnouncementFlag(true)
                    end,
                    function()
                        g = false
                        CORRUPT.setHideEventAnnouncementFlag(false)
                    end
                )
                RageUI.Checkbox(
                    "Show Health Percentage",
                    "Displays the health and armour percentage on the bars.",
                    h,
                    {},
                    function()
                    end,
                    function()
                        h = true
                        CORRUPT.setShowHealthPercentageFlag(true)
                    end,
                    function()
                        h = false
                        CORRUPT.setShowHealthPercentageFlag(false)
                    end
                )
                RageUI.Checkbox(
                    "Streetnames",
                    "",
                    CORRUPT.isStreetnamesEnabled(),
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    function()
                        CORRUPT.setStreetnamesEnabled(true)
                    end,
                    function()
                        CORRUPT.setStreetnamesEnabled(false)
                    end
                )
                RageUI.Checkbox(
                    "Compass",
                    "",
                    CORRUPT.isCompassEnabled(),
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    function()
                        CORRUPT.setCompassEnabled(true)
                    end,
                    function()
                        CORRUPT.setCompassEnabled(false)
                    end
                )
                RageUI.Checkbox(
                    "Cinematic Black Bars",
                    "",
                    e,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                RageUI.Separator("~y~These changes are persistent across restarts.")
                local function ar()
                    CORRUPT.hideUI()
                    hideUI = true
                end
                local function as()
                    CORRUPT.showUI()
                    hideUI = false
                end
                RageUI.ButtonWithStyle(
                    "Crosshair",
                    "Create a custom built-in crosshair here.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("crosshair", "main")
                )
                RageUI.Checkbox(
                    "Disable Main UI",
                    "",
                    hideUI,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                local function ar()
                    CORRUPT.toggleBlackBars()
                    e = true
                end
                local function as()
                    CORRUPT.toggleBlackBars()
                    e = false
                end
                RageUI.Checkbox(
                    "Reduce Chat Opacity",
                    "",
                    f,
                    {},
                    function()
                    end,
                    function()
                        f = true
                        CORRUPT.setReducedChatOpacity(true)
                        TriggerEvent("CORRUPT:chatReduceOpacity", true)
                    end,
                    function()
                        f = false
                        CORRUPT.setReducedChatOpacity(false)
                        TriggerEvent("CORRUPT:chatReduceOpacity", false)
                    end
                )
                RageUI.Checkbox(
                    "Use Legacy Inventory",
                    "Changes the inventory (L) to use the legacy design.",
                    LegacyInventory,
                    {},
                    function()
                    end,
                    function()
                        LegacyInventory = true
                        CORRUPT.setLegacyInventory(true)
                    end,
                    function()
                        LegacyInventory = false
                        CORRUPT.setLegacyInventory(false)
                    end
                )
                RageUI.ButtonWithStyle(
                    "Scope Settings",
                    "Add a toggleable range finder when using sniper scopes.",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                    end,
                    RMenu:Get("scope", "main")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "weaponsettings"),
            true,
            false,
            true,
            function()
                local function ar()
                    TriggerEvent("CORRUPT:setDiagonalWeapons")
                    b = true
                    CORRUPT.setDiagonalWeaponSetting(b)
                end
                local function as()
                    TriggerEvent("CORRUPT:setVerticalWeapons")
                    b = false
                    CORRUPT.setDiagonalWeaponSetting(b)
                end
                RageUI.Checkbox(
                    "Enable Diagonal Weapons",
                    "~g~This changes the way weapons look on your back from vertical to diagonal.",
                    b,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
                RageUI.Checkbox(
                    "Enable Front Assault Rifles",
                    "~g~This changes the positioning of Assault Rifles from back to front.",
                    c,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        TriggerEvent("CORRUPT:setFrontAR")
                        c = true
                        CORRUPT.setFrontARSetting(c)
                    end,
                    function()
                        TriggerEvent("CORRUPT:setBackAR")
                        c = false
                        CORRUPT.setFrontARSetting(c)
                    end
                )
                RageUI.Checkbox(
                    "Enable Front SMGs",
                    "~g~This changes the positioning of SMGs from back to front.",
                    z,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        TriggerEvent("CORRUPT:setFrontSMG")
                        z = true
                        CORRUPT.setFrontSMGSetting(z)
                    end,
                    function()
                        TriggerEvent("CORRUPT:setBackSMG")
                        z = false
                        CORRUPT.setFrontSMGSetting(z)
                    end
                )
                local function ar()
                    TriggerEvent("CORRUPT:hsSoundsOn")
                    d = true
                    CORRUPT.setHitMarkerSetting(d)
                    tvRP.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
                end
                local function as()
                    TriggerEvent("CORRUPT:hsSoundsOff")
                    d = false
                    CORRUPT.setHitMarkerSetting(d)
                    tvRP.notify("~y~Experimental Headshot sounds now set to " .. tostring(d))
                end
                RageUI.Checkbox(
                    "Enable Experimental Hit Marker Sounds",
                    "~g~This adds 'hit marker' sounds when shooting another player, however it can be unreliable.",
                    d,
                    {Style = RageUI.CheckboxStyle.Car},
                    function(an, ap, ao, aq)
                    end,
                    ar,
                    as
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "gangsettings"),
            true,
            false,
            true,
            function()
                RageUI.List(
                    "Gang Ping Marker",
                    {"Only Text", "Marker", "Icon"},
                    q,
                    "Display of gang markers.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= q then
                            q = aw
                            SetResourceKvpInt("corrupt_gang_ping_marker", aw)
                        end
                    end
                )
                RageUI.List(
                    "Gang Name Distance",
                    l,
                    j,
                    "Max distance to display gang member names.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= j then
                            j = aw
                            SetResourceKvpInt("corrupt_gang_name_distance", aw)
                            TriggerEvent("CORRUPT:setGangNameDistance", k[aw])
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "miscsettings"),
            true,
            false,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Store Inventory",
                    "View your store inventory here.",
                    {RightLabel = "→→→"},
                    true,
                    function()
                    end,
                    RMenu:Get("store", "mainmenu")
                )
                RageUI.Checkbox(
                    "Keep Flashlight On Whilst Moving",
                    "Makes weapon flashlight beams stay visible while moving.",
                    i,
                    {},
                    function()
                    end,
                    function()
                        CORRUPT.setFlashlightNotAimingFlag(true)
                    end,
                    function()
                        CORRUPT.setFlashlightNotAimingFlag(false)
                    end
                )
                RageUI.Checkbox(
                    "Toggle Radio Animation",
                    "The player will play an animation when speaking over radio.",
                    x,
                    {},
                    function()
                    end,
                    function()
                        CORRUPT.setRadioAnim(true)
                    end,
                    function()
                        CORRUPT.setRadioAnim(false)
                    end
                )
                RageUI.List(
                    "Doorbell Status",
                    v,
                    w,
                    "Change the status of the doorbell.",
                    {},
                    true,
                    function(at, au, av, aw)
                        if aw ~= w then
                            w = aw
                            SetResourceKvpInt("corrupt_doorbell_index", aw)
                        end
                    end
                )
                RageUI.SliderProgress(
                    "Song Volume",
                    djmusic.volume,
                    100,
                    "Select or update the song volume",
                    {
                        ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255},
                        ProgressColor = {R = 0, G = 117, B = 194, A = 255}
                    },
                    true,
                    function(n, o, p, q)
                        if o then
                            if q ~= djmusic.volume then
                                djmusic.volume = q
                                if djmusic.volume % 10 == 0 or djmusic.volume == 1 then
                                    SendNUIMessage({type = "djVolume", djmusic.volume})
                                end
                                drawNativeText("DJ~w~: Volume Updated")
                            end
                        end
                        djmusic.volume = q
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "compsettings"),
            true,
            false,
            true,
            function()
                if next(compensation) ~= nil then
                    for ax, ay in pairs(compensation) do
                        RageUI.ButtonWithStyle(
                            "~g~"..ax,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(an, ao, ap)
                                if ap then
                                    TriggerServerEvent("CORRUPT:claimCompensation", ay)
                                    compensation[ax] = nil
                                end
                            end
                        )
                    end
                else
                    RageUI.Separator("~r~No compensation available.")
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "changediscord"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~A code has been messaged to the Discord account")
                RageUI.Separator("-----")
                RageUI.Separator("~y~If you have not received a message verify:")
                RageUI.Separator("~y~1. Your direct messages are open.")
                RageUI.Separator("~y~2. The account you provided was correct.")
                RageUI.Separator("-----")
                RageUI.ButtonWithStyle(
                    "Enter Code",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("CORRUPT:enterDiscordCode")
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "weaponswhitelist"),
            true,
            false,
            true,
            function()
                for ax, ay in pairs(J) do
                    RageUI.ButtonWithStyle(
                        ay,
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(an, ao, ap)
                            if ap then
                                K = ay
                                L = ax
                                N = nil
                            end
                        end,
                        RMenu:Get("settingsmenu", "generateaccesscode")
                    )
                end
                RageUI.Separator("~y~If you do not see your custom weapon here.")
                RageUI.Separator("~y~Please open a ticket on our support discord.")
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "generateaccesscode"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~Weapon Whitelist for " .. K)
                RageUI.Separator("How it works:")
                RageUI.Separator("You generate an access code for the player who wishes")
                RageUI.Separator("to purchase your custom weapon whitelist, which they ")
                RageUI.Separator("then enter on the store to receive their automated")
                RageUI.Separator("weapon whitelist.")
                RageUI.ButtonWithStyle(
                    "Create access code",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            local az = getGenericTextInput("User ID of player purchasing your weapon whitelist.")
                            if tonumber(az) then
                                az = tonumber(az)
                                if az > 0 then
                                    TriggerServerEvent("CORRUPT:generateWeaponAccessCode", L, az)
                                end
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "View whitelisted users",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(an, ao, ap)
                        if ap then
                            TriggerServerEvent("CORRUPT:requestWhitelistedUsers", L)
                        end
                    end,
                    RMenu:Get("settingsmenu", "viewwhitelisted")
                )
                if M then
                    RageUI.Separator("~g~Access code generated: " .. M)
                    RageUI.ButtonWithStyle(
                        "Copy Code to Clipboard",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(ae, af, ag)
                            if ag then
                                tvRP.copyToClipboard(M)
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "viewwhitelisted"),
            true,
            false,
            true,
            function()
                RageUI.Separator("~g~Whitelisted users for " .. K)
                if N == nil then
                    RageUI.Separator("~r~Requesting whitelisted users...")
                else
                    for aA, aB in pairs(N) do
                        RageUI.ButtonWithStyle(
                            "ID: " .. tostring(aA),
                            "",
                            {RightLabel = aB},
                            true,
                            function()
                            end
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "graphicpresets"),
            true,
            false,
            true,
            function()
                for W, S in pairs(a.presets) do
                    if S.enabled then
                        RageUI.Separator(S.name)
                        for W, T in pairs(S.presets) do
                            local aC = R(S, T)
                            RageUI.Checkbox(T.name,nil,aC,{},function(an, ap, ao, aq)
                                if aq ~= aC then
                                    _(S, T, aq)
                                end
                            end,function()end,function()end)
                        end
                    end
                end
                RageUI.Checkbox("Disable Low Priority Props","Removes small ambient world objects such as signs, bins, creates, rubbish, etc.",y,{},function()
                end,function()
                    CORRUPT.setLowProps(true)
                end,function()
                   CORRUPT.setLowProps(false)
                end)
                RageUI.List("Timecycle",a.timecycles.names,timecycleIndex,"Change current Timecycle.",{},true,function(ae, af, ag, ah)
                    if ah ~= timecycleIndex then
                        timecycleIndex = ah
                        SetResourceKvpInt("corrupt_timecycle_index", ah)
                        SetTimecycleModifier(a.timecycles.values[ah])
                    end
                end)
                RageUI.List("Sky",a.weathers.names,weatherIndex,"Change current Sky.",{},true,function(ae, af, ag, ah)
                    if ah ~= weatherIndex then
                        weatherIndex = ah
                        SetResourceKvpInt("corrupt_weather_index", ah)
                        ARMA.setWeather(a.weathers.values[ah])
                    end
                end)
                RageUI.List("Render Distance Modifier",a1,I,"~g~Lowering this will increase your FPS!",{},true,function(an, ao, ap, aD)
                    I = aD
                end,function()end,nil)
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "killeffects"),
            true,
            false,
            true,
            function()
                RageUI.Checkbox(
                    "Create Lightning",
                    "",
                    ae.lightning,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.lightning = aq
                            ag()
                        end
                    end
                )
                RageUI.Checkbox(
                    "Ped Flash",
                    "",
                    ae.pedFlash,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.pedFlash = aq
                            ag()
                        end
                    end
                )
                if ae.pedFlash then
                    RageUI.List(
                        "Ped Flash Red",
                        a5,
                        ae.pedFlashRGB[1],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[1] ~= aD then
                                ae.pedFlashRGB[1] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Green",
                        a5,
                        ae.pedFlashRGB[2],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[2] ~= aD then
                                ae.pedFlashRGB[2] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Blue",
                        a5,
                        ae.pedFlashRGB[3],
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashRGB[3] ~= aD then
                                ae.pedFlashRGB[3] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Intensity",
                        a7,
                        ae.pedFlashIntensity,
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashIntensity ~= aD then
                                ae.pedFlashIntensity = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Ped Flash Time",
                        a9,
                        ae.pedFlashTime,
                        "",
                        {},
                        ae.pedFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.pedFlashTime ~= aD then
                                ae.pedFlashTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.Checkbox(
                    "Screen Flash",
                    "",
                    ae.screenFlash,
                    {},
                    function(an, ap, ao, aq)
                        if ap then
                            ae.screenFlash = aq
                            ag()
                        end
                    end
                )
                if ae.screenFlash then
                    RageUI.List(
                        "Screen Flash Red",
                        a5,
                        ae.screenFlashRGB[1],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[1] ~= aD then
                                ae.screenFlashRGB[1] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Green",
                        a5,
                        ae.screenFlashRGB[2],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[2] ~= aD then
                                ae.screenFlashRGB[2] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Blue",
                        a5,
                        ae.screenFlashRGB[3],
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashRGB[3] ~= aD then
                                ae.screenFlashRGB[3] = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Intensity",
                        a7,
                        ae.screenFlashIntensity,
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashIntensity ~= aD then
                                ae.screenFlashIntensity = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                    RageUI.List(
                        "Screen Flash Time",
                        a9,
                        ae.screenFlashTime,
                        "",
                        {},
                        ae.screenFlash,
                        function(an, ao, ap, aD)
                            if ao and ae.screenFlashTime ~= aD then
                                ae.screenFlashTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.List(
                    "Timecycle Flash",
                    ad,
                    ae.timecycle,
                    "",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ao and ae.timecycle ~= aD then
                            ae.timecycle = aD
                            ag()
                        end
                    end,
                    function()
                    end
                )
                if ae.timecycle ~= 1 then
                    RageUI.List(
                        "Timecycle Flash Time",
                        a9,
                        ae.timecycleTime,
                        "",
                        {},
                        true,
                        function(an, ao, ap, aD)
                            if ao and ae.timecycleTime ~= aD then
                                ae.timecycleTime = aD
                                ag()
                            end
                        end,
                        function()
                        end
                    )
                end
                RageUI.List(
                    "~y~Particles~w~",
                    ab,
                    ae.particle,
                    "",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ao and ae.particle ~= aD then
                            if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                                notify("~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature.")
                                notify("~y~Available @ corrupt.tebex.io")
                            end
                            ae.particle = aD
                            ag()
                        end
                    end,
                    function()
                    end
                )
                local aE = 0
                if ae.lightning then
                    aE = math.max(aE, 1000)
                end
                if ae.pedFlash then
                    aE = math.max(aE, aa[ae.pedFlashTime])
                end
                if ae.screenFlash then
                    aE = math.max(aE, aa[ae.screenFlashTime])
                end
                if ae.timecycleTime ~= 1 then
                    aE = math.max(aE, a6[ae.timecycleTime])
                end
                if ae.particle ~= 1 then
                    aE = math.max(aE, 1000)
                end
                if GetGameTimer() - af > aE + 1000 then
                    CORRUPT.addKillEffect(PlayerPedId(), true)
                    af = GetGameTimer()
                end
                DrawAdvancedTextNoOutline(0.59, 0.9, 0.005, 0.0028, 1.5, "PREVIEW", 255, 0, 0, 255, 2, 0)
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("settingsmenu", "bloodeffects"),
            true,
            false,
            true,
            function()
                RageUI.List(
                    "~y~Head",
                    ab,
                    ai.head,
                    "Effect that displays when you hit the head.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.head ~= aD then
                            if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                                notify("~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature.")
                                notify("~y~Available @ corrupt.tebex.io")
                            end
                            ai.head = aD
                            aj()
                        end
                        if ap then
                            CORRUPT.addBloodEffect("head", 0x796E, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Body",
                    ab,
                    ai.body,
                    "Effect that displays when you hit the body.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.body ~= aD then
                            if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                                notify("~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature.")
                                notify("~y~Available @ corrupt.tebex.io")
                            end
                            ai.body = aD
                            aj()
                        end
                        if ap then
                            CORRUPT.addBloodEffect("body", 0x0, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Arms",
                    ab,
                    ai.arms,
                    "Effect that displays when you hit the arms.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.arms ~= aD then
                            if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                                notify("~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature.")
                                notify("~y~Available @ corrupt.tebex.io")
                            end
                            ai.arms = aD
                            aj()
                        end
                        if ap then
                            CORRUPT.addBloodEffect("arms", 0xBB0, PlayerPedId())
                            CORRUPT.addBloodEffect("arms", 0x58B7, PlayerPedId())
                        end
                    end
                )
                RageUI.List(
                    "~y~Legs",
                    ab,
                    ai.legs,
                    "Effect that displays when you hit the legs.",
                    {},
                    true,
                    function(an, ao, ap, aD)
                        if ai.legs ~= aD then
                            if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
                                notify("~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature.")
                                notify("~y~Available @ corrupt.tebex.io")
                            end
                            ai.legs = aD
                            aj()
                        end
                        if ap then
                            CORRUPT.addBloodEffect("legs", 0x3FCF, PlayerPedId())
                            CORRUPT.addBloodEffect("legs", 0xB3FE, PlayerPedId())
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
RegisterNetEvent("CORRUPT:Opensettingsmenu")
AddEventHandler(
    "CORRUPT:Opensettingsmenu",
    function(aF)
        if not aF then
            RageUI.Visible(RMenu:Get("settingsmenu", "settings"), true)
        end
    end
)
local function y(x)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("settingsmenu", "settings"), x)
end
local settingsmenu = false
RegisterCommand(
    "settings",
    function()
        if CORRUPT.getStaffLevel() > 0 then
            RageUI.Visible(RMenu:Get("corruptadminmenu", "mainmenu"),not RageUI.Visible(RMenu:Get("corruptadminmenu", "mainmenu")))
        else
            settingsmenu = not settingsmenu
            y(settingsmenu)
        end
    end,
    false
)
RegisterKeyMapping("settings", "Open Settings", "KEYBOARD", "F2")
Citizen.CreateThread(
    function()
        while true do
            OverrideLodscaleThisFrame(H[I][2])
            Wait(0)
        end
    end
)
AddEventHandler(
    "CORRUPT:enteredCity",
    function()
    end
)
AddEventHandler(
    "CORRUPT:leftCity",
    function()
    end
)
local function au(av)
    local aw = GetEntityCoords(av, true)
    local aG = GetGameTimer()
    local aH = math.floor(a6[ae.pedFlashRGB[1]] * 255)
    local aI = math.floor(a6[ae.pedFlashRGB[2]] * 255)
    local aJ = math.floor(a6[ae.pedFlashRGB[3]] * 255)
    local aK = a8[ae.pedFlashIntensity]
    local aL = aa[ae.pedFlashTime]
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        local aN = aK * 25.0 * aM
        DrawLightWithRange(aw.x, aw.y, aw.z + 1.0, aH, aI, aJ, 50.0, aN)
        Citizen.Wait(0)
    end
end
local function aO()
    local aG = GetGameTimer()
    local aH = math.floor(a6[ae.screenFlashRGB[1]] * 255)
    local aI = math.floor(a6[ae.screenFlashRGB[2]] * 255)
    local aJ = math.floor(a6[ae.screenFlashRGB[3]] * 255)
    local aK = a8[ae.screenFlashIntensity]
    local aL = aa[ae.screenFlashTime]
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        local aN = math.floor(25.5 * aK * aM)
        DrawRect(0.0, 0.0, 2.0, 2.0, aH, aI, aJ, aN)
        Citizen.Wait(0)
    end
end
local function aP(av)
    local aw = GetEntityCoords(av, true)
    local aQ = ac[ae.particle]
    CORRUPT.loadPtfx(aQ[1])
    UseParticleFxAsset(aQ[1])
    StartParticleFxNonLoopedAtCoord(aQ[2], aw.x, aw.y, aw.z, 0.0, 0.0, 0.0, aQ[3], false, false, false)
    RemoveNamedPtfxAsset(aQ[1])
end
local function aR()
    local aG = GetGameTimer()
    local aL = aa[ae.timecycleTime]
    SetTimecycleModifier(ad[ae.timecycle])
    while GetGameTimer() - aG < aL do
        local aM = (aL - (GetGameTimer() - aG)) / aL
        SetTimecycleModifierStrength(1.0 * aM)
        Citizen.Wait(0)
    end
    ClearTimecycleModifier()
end
function CORRUPT.addKillEffect(aS, aT)
    if ae.lightning then
        ForceLightningFlash()
    end
    if ae.pedFlash then
        Citizen.CreateThreadNow(
            function()
                au(aS)
            end
        )
    end
    if ae.screenFlash then
        Citizen.CreateThreadNow(
            function()
                aO()
            end
        )
    end
    if ae.particle ~= 1 and (tvRP.isPlatClub() or aT) then
        Citizen.CreateThreadNow(
            function()
                aP(aS)
            end
        )
    end
    if ae.timecycle ~= 1 then
        Citizen.CreateThreadNow(
            function()
                aR()
            end
        )
    end
end
function CORRUPT.addBloodEffect(aU, aV, av)
    local aW = ai[aU]
    if aW > 1 then
        local aQ = ac[aW]
        CORRUPT.loadPtfx(aQ[1])
        UseParticleFxAsset(aQ[1])
        StartParticleFxNonLoopedOnPedBone(aQ[2], av, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, aV, aQ[3], false, false, false)
        RemoveNamedPtfxAsset(aQ[1])
    end
end
AddEventHandler(
    "CORRUPT:onPlayerKilledPed",
    function(aX)
        CORRUPT.addKillEffect(aX, false)
    end
)
local aY = {
    [0x0] = "body",
    [0x2E28] = "body",
    [0xE39F] = "legs",
    [0xF9BB] = "legs",
    [0x3779] = "legs",
    [0x83C] = "legs",
    [0xCA72] = "legs",
    [0x9000] = "legs",
    [0xCC4D] = "legs",
    [0x512D] = "legs",
    [0xE0FD] = "body",
    [0x5C01] = "body",
    [0x60F0] = "body",
    [0x60F1] = "body",
    [0x60F2] = "body",
    [0xFCD9] = "body",
    [0xB1C5] = "arms",
    [0xEEEB] = "arms",
    [0x49D9] = "arms",
    [0x67F2] = "arms",
    [0xFF9] = "arms",
    [0xFFA] = "arms",
    [0x67F3] = "arms",
    [0x1049] = "arms",
    [0x104A] = "arms",
    [0x67F4] = "arms",
    [0x1059] = "arms",
    [0x105A] = "arms",
    [0x67F5] = "arms",
    [0x1029] = "arms",
    [0x102A] = "arms",
    [0x67F6] = "arms",
    [0x1039] = "arms",
    [0x103A] = "arms",
    [0x29D2] = "arms",
    [0x9D4D] = "arms",
    [0x6E5C] = "arms",
    [0xDEAD] = "arms",
    [0xE5F2] = "arms",
    [0xFA10] = "arms",
    [0xFA11] = "arms",
    [0xE5F3] = "arms",
    [0xFA60] = "arms",
    [0xFA61] = "arms",
    [0xE5F4] = "arms",
    [0xFA70] = "arms",
    [0xFA71] = "arms",
    [0xE5F5] = "arms",
    [0xFA40] = "arms",
    [0xFA41] = "arms",
    [0xE5F6] = "arms",
    [0xFA50] = "arms",
    [0xFA51] = "arms",
    [0x9995] = "head",
    [0x796E] = "head",
    [0x5FD4] = "head",
    [0xD003] = "body",
    [0x45FC] = "body",
    [0x1D6B] = "legs",
    [0xB23F] = "legs"
}
AddEventHandler(
    "CORRUPT:onPlayerDamagePed",
    function(aX)
        if not tvRP.isPlusClub() and not tvRP.isPlatClub() then
            return
        end
        local aZ, aV = GetPedLastDamageBone(aX, 0)
        if aZ then
            local a_ = GetPedBoneIndex(aX, aV)
            local b0 = GetWorldPositionOfEntityBone(aX, a_)
            local b1 = aY[aV]
            if not b1 then
                local b2 = GetWorldPositionOfEntityBone(aX, GetPedBoneIndex(aX, 0x9995))
                local b3 = GetWorldPositionOfEntityBone(aX, GetPedBoneIndex(aX, 0x2E28))
                if b0.z >= b2.z - 0.01 then
                    b1 = "head"
                elseif b0.z < b3.z then
                    b1 = "legs"
                else
                    local b4 = GetEntityCoords(aX, true)
                    local b5 = #(b4.xy - b0.xy)
                    if b5 > 0.075 then
                        b1 = "arms"
                    else
                        b1 = "body"
                    end
                end
            end
            CORRUPT.addBloodEffect(b1, aV, aX)
        end
    end
)
RegisterNetEvent("CORRUPT:gotDiscord")
AddEventHandler(
    "CORRUPT:gotDiscord",
    function()
        RageUI.Visible(RMenu:Get("settingsmenu", "changediscord"), true)
    end
)
objettable = {}
Citizen.CreateThread(
    function()
        while true do
            if y then
                while objettable == nil do
                    Citizen.Wait(0)
                end
                for c = 1, #objettable do
                    local d = GetGamePool("CObject")
                    local e = GetHashKey(objettable[c])
                    for f, g in pairs(d) do
                        if GetEntityModel(g) == e then
                            SetEntityAsMissionEntity(g, true, true)
                            DeleteObject(g)
                        end
                    end
                end
            end
            Citizen.Wait(1000)
        end
    end
)
RMenu.Add(
    "ProfileMenu",
    "main",
    RageUI.CreateMenu(
        "",
        "Profile Settings",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_settingsui",
        "corrupt_settingsui"
    )
)