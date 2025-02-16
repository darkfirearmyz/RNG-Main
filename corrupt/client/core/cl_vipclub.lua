RMenu.Add(
    "vipclubmenu",
    "mainmenu",
    RageUI.CreateMenu(
        "",
        "~w~Corrupt Club",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "managesubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~Corrupt Club",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageusersubscription",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~Corrupt Club Manage",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "manageperks",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "mainmenu"),
        "",
        "~w~Corrupt Club Perks",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "deathsounds",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Manage Death Sounds",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
RMenu.Add(
    "vipclubmenu",
    "vehicleextras",
    RageUI.CreateSubMenu(
        RMenu:Get("vipclubmenu", "manageperks"),
        "",
        "~w~Vehicle Extras",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "Corrupt_club",
        "Corrupt_club"
    )
)
local a = {hoursOfPlus = 0, hoursOfPlatinum = 0}
local b = {}
function tvRP.isPlusClub()
    if a.hoursOfPlus > 0 then
        return true
    else
        return false
    end
end
function tvRP.isPlatClub()
    if a.hoursOfPlatinum > 0 then
        return true
    else
        return false
    end
end
RegisterCommand(
    "Corruptclub",
    function()
        TriggerServerEvent("CORRUPT:getPlayerSubscription")
        RageUI.CloseAll()
        RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu"), not RageUI.Visible(RMenu:Get("vipclubmenu", "mainmenu")))
    end
)
local c = {
    ["Default"] = {checked = true, soundId = "playDead"},
    ["Fortnite"] = {checked = false, soundId = "fortnite_death"},
    ["Roblox"] = {checked = false, soundId = "roblox_death"},
    ["Minecraft"] = {checked = false, soundId = "minecraft_death"},
    ["Pac-Man"] = {checked = false, soundId = "pacman_death"},
    ["Mario"] = {checked = false, soundId = "mario_death"},
    ["CS:GO"] = {checked = false, soundId = "csgo_death"}
}
local d = false
local e = false
local f = false
local g = false
local h = {"Red", "Blue", "Green", "Pink", "Yellow", "Orange", "Purple"}
local i = tonumber(GetResourceKvpString("Corrupt_damageindicatorcolour")) or 1
Citizen.CreateThread(
    function()
        local j = GetResourceKvpString("Corrupt_codhitmarkersounds") or "false"
        if j == "false" then
            d = false
            TriggerEvent("CORRUPT:codHMSoundsOff")
        else
            d = true
            TriggerEvent("CORRUPT:codHMSoundsOn")
        end
        local k = GetResourceKvpString("Corrupt_killlistsetting") or "false"
        if k == "false" then
            e = false
        else
            e = true
        end
        local l = GetResourceKvpString("Corrupt_oldkillfeed") or "false"
        if l == "false" then
            f = false
        else
            f = true
        end
        local m = GetResourceKvpString("Corrupt_damageindicator") or "false"
        if m == "false" then
            g = false
        else
            g = true
        end
        Wait(5000)
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(f, g)
        if g then
            TriggerServerEvent("CORRUPT:getPlayerSubscription")
            Wait(5000)
            local n = CORRUPT.getDeathSound()
            local o = "playDead"
            for p, j in pairs(c) do
                if j.soundId == n then
                    o = p
                end
            end
            for p, k in pairs(c) do
                if o ~= p then
                    k.checked = false
                else
                    k.checked = true
                end
            end
        end
    end
)
function CORRUPT.setDeathSound(n)
    if tvRP.isPlusClub() or tvRP.isPlatClub() then
        SetResourceKvp("Corrupt_deathsound", n)
    else
        tvRP.notify("~r~Cannot change deathsound, not a valid Corrupt Plus or Platinum subscriber.")
    end
end
function CORRUPT.getDeathSound()
    if tvRP.isPlusClub() or tvRP.isPlatClub() then
        local p = GetResourceKvpString("Corrupt_deathsound")
        if type(p) == "string" and p ~= "" then
            return p
        else
            return "playDead"
        end
    else
        return "playDead"
    end
end
function CORRUPT.getDmgIndcator()
    return g, i
end
local function k(h)
    SendNUIMessage({transactionType = h})
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("vipclubmenu", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "mainmenu"),
            true,
            true,
            true,
            function()
                if tvRP.isPlusClub() or tvRP.isPlatClub() then
                    RageUI.ButtonWithStyle(
                        "Manage Subscription",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "managesubscription")
                    )
                    RageUI.ButtonWithStyle(
                        "Manage Perks",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "manageperks")
                    )
                else
                    RageUI.ButtonWithStyle(
                        "Purchase Subscription",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                            if r then
                                CORRUPT.OpenUrl("https://corrupt-public.tebex.io/category/subscriptions")
                            end
                        end
                    )
                end
                if CORRUPT.isDeveloper(CORRUPT.getUserId()) or CORRUPT.getStaffLevel() >= 10 then
                    RageUI.ButtonWithStyle(
                        "Manage User's Subscription",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(m, q, r)
                        end,
                        RMenu:Get("vipclubmenu", "manageusersubscription")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "managesubscription"),
            true,
            true,
            true,
            function()
                colourCode = getColourCode(a.hoursOfPlus)
                RageUI.Separator(
                    "Days remaining of Plus Subscription: " ..
                        colourCode .. math.floor(a.hoursOfPlus / 24 * 100) / 100 .. " days."
                )
                colourCode = getColourCode(a.hoursOfPlatinum)
                RageUI.Separator(
                    "Days remaining of Platinum Subscription: " ..
                        colourCode .. math.floor(a.hoursOfPlatinum / 24 * 100) / 100 .. " days."
                )
                RageUI.Separator()
                RageUI.ButtonWithStyle(
                    "Sell Plus Subscription days.",
                    "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                    {RightLabel = "→→→"},
                    true,
                    function(m, q, r)
                        if r then
                            if isInGreenzone then
                                TriggerServerEvent("CORRUPT:beginSellSubscriptionToPlayer", "Plus")
                            else
                                notify("~r~You must be in a greenzone to sell.")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Sell Platinum Subscription days.",
                    "~r~If you have already claimed your weekly kit, you may not sell days until the week is over.",
                    {RightLabel = "→→→"},
                    true,
                    function(m, q, r)
                        if r then
                            if isInGreenzone then
                                TriggerServerEvent("CORRUPT:beginSellSubscriptionToPlayer", "Platinum")
                            else
                                notify("~r~You must be in a greenzone to sell.")
                            end
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "manageusersubscription"),
            true,
            true,
            true,
            function()
                if CORRUPT.isDeveloper(CORRUPT.getUserId()) then
                    if next(b) then
                        RageUI.Separator("Perm ID: " .. b.userid)
                        colourCode = getColourCode(b.hoursOfPlus)
                        RageUI.Separator(
                            "Days of Plus Remaining: " .. colourCode .. math.floor(b.hoursOfPlus / 24 * 100) / 100
                        )
                        colourCode = getColourCode(b.hoursOfPlatinum)
                        RageUI.Separator(
                            "Days of Platinum Remaining: " ..
                                colourCode .. math.floor(b.hoursOfPlatinum / 24 * 100) / 100
                        )
                        RageUI.ButtonWithStyle(
                            "Set Plus Days",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                                if r then
                                    TriggerServerEvent("CORRUPT:setPlayerSubscription", b.userid, "Plus")
                                end
                            end
                        )
                        RageUI.ButtonWithStyle(
                            "Set Platinum Days",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(m, q, r)
                                if r then
                                    TriggerServerEvent("CORRUPT:setPlayerSubscription", b.userid, "Platinum")
                                end
                            end
                        )
                    else
                        RageUI.Separator("Please select a Perm ID")
                    end
                    RageUI.ButtonWithStyle(
                        "Select Perm ID",
                        nil,
                        {RightLabel = "→→→"},
                        true,
                        function(s, t, u)
                            if u then
                                permID = CORRUPT.KeyboardInput("Enter Perm ID", "", 10)
                                if permID == nil then
                                    tvRP.notify("Invalid Perm ID")
                                    return
                                end
                                TriggerServerEvent("CORRUPT:getPlayerSubscription", permID)
                            end
                        end,
                        RMenu:Get("vipclubmenu", "manageusersubscription")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "manageperks"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Custom Death Sounds",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(m, q, r)
                    end,
                    RMenu:Get("vipclubmenu", "deathsounds")
                )
                RageUI.ButtonWithStyle(
                    "Vehicle Extras",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(m, q, r)
                    end,
                    RMenu:Get("vipclubmenu", "vehicleextras")
                )
                RageUI.ButtonWithStyle(
                    "Claim Weekly Kit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(m, q, r)
                        if r then
                            if not globalInPrison and not tvRP.isHandcuffed() then
                                TriggerServerEvent("CORRUPT:claimWeeklyKit")
                            else
                                notify("~r~You can not redeem a kit whilst in custody.")
                            end
                        end
                    end
                )
                local function r()
                    TriggerEvent("CORRUPT:codHMSoundsOn")
                    d = true
                    CORRUPT.setCODHitMarkerSetting(d)
                    tvRP.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                end
                local function v()
                    TriggerEvent("CORRUPT:codHMSoundsOff")
                    d = false
                    CORRUPT.setCODHitMarkerSetting(d)
                    tvRP.notify("~y~COD Hitmarkers now set to " .. tostring(d))
                end
                RageUI.Checkbox(
                    "Enable COD Hitmarkers",
                    "~g~This adds 'hit marker' sound and image when shooting another player.",
                    d,
                    {RightBadge = RageUI.CheckboxStyle.Car},
                    function(l, q, m, w)
                    end,
                    r,
                    v
                )
                RageUI.Checkbox(
                    "Enable Kill List",
                    "~g~This adds a kill list below your crosshair when you kill a player.",
                    e,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        e = true
                        CORRUPT.setKillListSetting(e)
                        tvRP.notify("~y~Kill List now set to " .. tostring(e))
                    end,
                    function()
                        e = false
                        CORRUPT.setKillListSetting(e)
                        tvRP.notify("~y~Kill List now set to " .. tostring(e))
                    end
                )
                RageUI.Checkbox(
                    "Enable Old Kilfeed",
                    "~g~This toggles the old killfeed that notifies above minimap.",
                    f,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        f = true
                        CORRUPT.setOldKillfeed(f)
                        tvRP.notify("~y~Old killfeed now set to " .. tostring(f))
                    end,
                    function()
                        f = false
                        CORRUPT.setOldKillfeed(f)
                        tvRP.notify("~y~Old killfeed now set to " .. tostring(f))
                    end
                )
                RageUI.Checkbox(
                    "Enable Damage Indicator",
                    "~g~This toggles the display of damage indicator.",
                    g,
                    {Style = RageUI.CheckboxStyle.Car},
                    function()
                    end,
                    function()
                        g = true
                        CORRUPT.setDamageIndicator(g)
                        tvRP.notify("~y~Damage Indicator now set to " .. tostring(g))
                    end,
                    function()
                        g = false
                        CORRUPT.setDamageIndicator(g)
                        tvRP.notify("~y~Damage Indicator now set to " .. tostring(g))
                    end
                )
                if g then
                    RageUI.List(
                        "Damage Colour",
                        h,
                        i,
                        "~g~Change the displayed colour of damage",
                        {},
                        true,
                        function(x, y, z, A)
                            i = A
                            CORRUPT.setDamageIndicatorColour(i)
                        end,
                        function()
                        end,
                        nil
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "deathsounds"),
            true,
            true,
            true,
            function()
                for B, p in pairs(c) do
                    RageUI.Checkbox(
                        B,
                        "",
                        p.checked,
                        {},
                        function()
                        end,
                        function()
                            for n, j in pairs(c) do
                                j.checked = false
                            end
                            p.checked = true
                            k(p.soundId)
                            CORRUPT.setDeathSound(p.soundId)
                        end,
                        function()
                        end
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("vipclubmenu", "vehicleextras"),
            true,
            true,
            true,
            function()
                local C = CORRUPT.getPlayerVehicle()
                SetVehicleAutoRepairDisabled(C, true)
                for D = 1, 99, 1 do
                    if DoesExtraExist(C, D) then
                        RageUI.Checkbox(
                            "Extra " .. D,
                            "",
                            IsVehicleExtraTurnedOn(C, D),
                            {},
                            function()
                            end,
                            function()
                                SetVehicleExtra(C, D, 0)
                            end,
                            function()
                                SetVehicleExtra(C, D, 1)
                            end
                        )
                    end
                end
            end,
            function()
            end
        )
    end
)
RegisterNetEvent(
    "CORRUPT:setVIPClubData",
    function(E, b)
        a.hoursOfPlus = E
        a.hoursOfPlatinum = b
    end
)
RegisterNetEvent(
    "CORRUPT:getUsersSubscription",
    function(F, G, H)
        b.userid = F
        b.hoursOfPlus = G
        b.hoursOfPlatinum = H
        RMenu:Get("vipclubmenu", "manageusersubscription")
    end
)
RegisterNetEvent(
    "CORRUPT:userSubscriptionUpdated",
    function()
        TriggerServerEvent("CORRUPT:getPlayerSubscription", permID)
    end
)
Citizen.CreateThread(
    function()
        while true do
            if tvRP.isPlatClub() then
                if not HasPedGotWeapon(PlayerPedId(), "GADGET_PARACHUTE", false) then
                    CORRUPT.allowweapon("GADGET_PARACHUTE")
                    GiveWeaponToPed(PlayerPedId(), "GADGET_PARACHUTE")
                    SetPlayerHasReserveParachute(PlayerId())
                end
            end
            if tvRP.isPlusClub() or tvRP.isPlatClub() then
                SetVehicleDirtLevel(CORRUPT.getPlayerVehicle(), 0.0)
            end
            Wait(500)
        end
    end
)
function getColourCode(a)
    if a == nil then
        return "~r~" 
    end
    if a >= 10 then
        colourCode = "~g~"
    elseif a < 10 and a > 3 then
        colourCode = "~y~"
    else
        colourCode = "~r~"
    end
    return colourCode
end
local z = {}
local function A()
    for E, I in pairs(z) do
        DrawAdvancedTextNoOutline(
            0.6,
            0.5 + 0.025 * E,
            0.005,
            0.0028,
            0.45,
            "Killed " .. I.name,
            255,
            255,
            255,
            255,
            CORRUPT.getFontId("Akrobat-Regular"),
            1
        )
    end
end
CORRUPT.createThreadOnTick(A)
RegisterNetEvent(
    "CORRUPT:onPlayerKilledPed",
    function(J)
        if e and (tvRP.isPlatClub() or tvRP.isPlusClub()) and IsPedAPlayer(J) then
            local K = NetworkGetPlayerIndexFromPed(J)
            if K >= 0 then
                local L = GetPlayerServerId(K)
                if L >= 0 then
                    local M = CORRUPT.getPlayerName(K)
                    table.insert(z, {name = M, source = L})
                    SetTimeout(
                        2000,
                        function()
                            for E, I in pairs(z) do
                                if L == I.source then
                                    table.remove(z, E)
                                end
                            end
                        end
                    )
                end
            end
        end
    end
)
