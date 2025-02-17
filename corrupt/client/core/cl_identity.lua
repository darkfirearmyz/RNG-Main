local a = {vector3(-552.35083007813, -191.59149169922, 38.21964263916)}
local b = false
local c = ""
local d = "N/A"
local e = "N/A"
local f = 0
local g = false
RMenu.Add("identity", "main", RageUI.CreateMenu("", "City Hall", 0, 100, "corrupt_cityhallui", "corrupt_cityhallui"))
RMenu.Add("identity", "confirm", RageUI.CreateSubMenu(RMenu:Get("identity", "main"), "", "Confirm Identity"))
Citizen.CreateThread(
    function()
        if true then
            local h = function()
                drawNativeNotification("Press ~INPUT_PICKUP~ to access the City Hall.")
                PlaySound(-1, "SELECT", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            end
            local i = function()
                RageUI.CloseAll()
                RageUI.Visible(RMenu:Get("identity", "main"), false)
                RageUI.Visible(RMenu:Get("identity", "confirm"), false)
            end
            local f = function()
                if IsControlJustPressed(1, 51) then
                    TriggerServerEvent("CORRUPT:getIdentity")
                    RageUI.CloseAll()
                    RageUI.Visible(RMenu:Get("identity", "main"), not RageUI.Visible(RMenu:Get("identity", "main")))
                end
            end
            for d, e in pairs(a) do
                CORRUPT.createArea("identity_" .. d, e, 1.5, 6, h, i, f)
                tvRP.addMarker(e.x, e.y, e.z - 0.2, 0.5, 0.5, 0.5, 0, 50, 255, 170, 50, 20, false, false, true)
            end
        end
    end
)
RegisterNetEvent("CORRUPT:gotCurrentIdentity")
AddEventHandler(
    "CORRUPT:gotCurrentIdentity",
    function(j, k, l)
        d = j
        e = k
        f = l
    end
)
RegisterNetEvent("CORRUPT:gotNewIdentity")
AddEventHandler(
    "CORRUPT:gotNewIdentity",
    function(j, k, l)
        newfirstname = j
        newlastname = k
        newage = l
        RageUI.Visible(RMenu:Get("identity", "confirm"), true)
    end
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("identity", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("identity", "main"),
            true,
            false,
            true,
            function()
                if d ~= "N/A" then
                    RageUI.Separator("Your current identity")
                    RageUI.Separator("Firstname ~y~|~w~ " .. d .. "")
                    RageUI.Separator("Lastname ~y~|~w~ " .. e .. "")
                    RageUI.Separator("Age ~y~|~w~ " .. f .. "")
                    RageUI.ButtonWithStyle(
                        "Change your Identity",
                        "£5000",
                        {RightLabel = "→→→"},
                        true,
                        function(m, n, o)
                            if o then
                                RageUI.CloseAll()
                                TriggerServerEvent("CORRUPT:getNewIdentity")
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("identity", "confirm"),
            true,
            false,
            true,
            function()
                RageUI.Separator("Your new identity")
                RageUI.Separator("Firstname ~y~|~w~ " .. newfirstname .. "")
                RageUI.Separator("Lastname ~y~|~w~ " .. newlastname .. "")
                RageUI.Separator("Age ~y~|~w~ " .. newage .. "")
                RageUI.ButtonWithStyle(
                    "Yes",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(d, e, m)
                        if m then
                            TriggerServerEvent(
                                "CORRUPT:ChangeIdentity",
                                newfirstname,
                                newlastname,
                                tonumber(newage)
                            )
                            RageUI.CloseAll()
                        end
                    end,
                    RMenu:Get("identity", "confirm")
                )
                RageUI.ButtonWithStyle(
                    "No",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(d, e, m)
                    end,
                    RMenu:Get("identity", "main")
                )
            end,
            function()
            end
        )
    end
)
local p = false
local function q(r)
    local s = GetPlayerFromServerId(r)
    if s == -1 then
        return "CHAR_BLOCKED", nil
    end
    local t = GetPlayerPed(s)
    if t == 0 then
        return "CHAR_BLOCKED", nil
    end
    local u = RegisterPedheadshotTransparent(t)
    local v = GetGameTimer()
    while not IsPedheadshotReady(u) do
        if GetGameTimer() - v > 2500 or not IsPedheadshotValid(u) then
            UnregisterPedheadshot(u)
            return "CHAR_BLOCKED", nil
        end
        Citizen.Wait(0)
    end
    return GetPedheadshotTxdString(u), u
end
RegisterNetEvent(
    "CORRUPT:showIdentity",
    function(w, x, y, z, A, B, C, D, E)
        p = true
        RequestStreamedTextureDict("driving_licence")
        while not HasStreamedTextureDictLoaded("driving_licence") do
            Citizen.Wait(0)
        end
        local F, G = q(w)
        local H = x and "full" or "provisional"
        local I = CORRUPT.getFontId("Akrobat-ExtraLight")
        y = string.upper(y)
        z = string.upper(z)
        while p do
            DrawSprite("driving_licence", H, 0.15, 0.5, 0.3, 0.3, 0.0, 255, 255, 255, 255)
            DrawSprite(F, F, 0.05, 0.5, 0.07, 0.1, 0.0, 255, 255, 255, 255)
            DrawAdvancedTextNoOutline(0.2, 0.413, 0.005, 0.0028, 0.25, y, 70, 70, 71, 255, I, 1)
            DrawAdvancedTextNoOutline(0.2, 0.426, 0.005, 0.0028, 0.25, z, 70, 70, 71, 255, I, 1)
            DrawAdvancedTextNoOutline(
                0.2,
                0.456,
                0.005,
                0.0028,
                0.25,
                string.format("%s ENGLAND", A),
                70,
                70,
                71,
                255,
                I,
                1
            )
            DrawAdvancedTextNoOutline(0.2, 0.470, 0.005, 0.0028, 0.25, C, 70, 70, 71, 255, I, 1)
            DrawAdvancedTextNoOutline(0.2, 0.484, 0.005, 0.0028, 0.25, D, 70, 70, 71, 255, I, 1)
            DrawAdvancedTextNoOutline(0.2, 0.510, 0.005, 0.0028, 0.35, B, 70, 70, 71, 255, I, 1)
            for J, K in pairs(E) do
                DrawAdvancedTextNoOutline(0.2, 0.534 + J * 0.018, 0.005, 0.0028, 0.25, K, 70, 70, 71, 255, I, 1)
            end
            Citizen.Wait(0)
        end
        SetStreamedTextureDictAsNoLongerNeeded("driving_licence")
        if G then
            UnregisterPedheadshot(G)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:hideIdentity",
    function()
        p = false
    end
)
