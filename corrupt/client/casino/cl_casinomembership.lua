RMenu.Add(
    "corrupthighrollers",
    "casino",
    RageUI.CreateMenu(
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "shopui_title_casino",
        "shopui_title_casino"
    )
)
RMenu:Get("corrupthighrollers", "casino"):SetSubtitle("~b~MEMBERSHIP")
RMenu.Add(
    "corrupthighrollers",
    "confirmadd",
    RageUI.CreateSubMenu(
        RMenu:Get("corrupthighrollers", "casino"),
        "",
        "~b~Are you sure?",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "corrupthighrollers",
    "confirmremove",
    RageUI.CreateSubMenu(
        RMenu:Get("corrupthighrollers", "casino"),
        "",
        "~b~Are you sure?",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "corrupthighrollers",
    "casinoban",
    RageUI.CreateSubMenu(
        RMenu:Get("corrupthighrollers", "casino"),
        "",
        "~b~Manage Casino Ban",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "corrupthighrollers",
    "casinostats",
    RageUI.CreateSubMenu(
        RMenu:Get("corrupthighrollers", "casino"),
        "",
        "~b~Casino Stats",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
local a = {
    {
        pedPosition = vector3(1088.0207519531, 221.13066101074, -49.200397491455),
        pedHeading = 175.0,
        entryPosition = vector3(1088.3181152344, 218.88592529297, -50.200374603271)
    }
}
local b = {}
local c = 0
local d = 0
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corrupthighrollers", "casino"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corrupthighrollers", "casino"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Purchase High Rollers Membership (£10,000,000)",
                    "~g~Allows you to sit at High-Rollers only seats.",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                    end,
                    RMenu:Get("corrupthighrollers", "confirmadd")
                )
                RageUI.ButtonWithStyle(
                    "Remove High Rollers Membership (£0)",
                    "~r~This is an irrevocable action, you will not receive any money in return.",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                    end,
                    RMenu:Get("corrupthighrollers", "confirmremove")
                )
                RageUI.ButtonWithStyle(
                    "Casino Ban",
                    "~b~Allows you to ban yourself from the casino for a set period of time. Whilst banned you cannot access this menu.",
                    CORRUPT.casinoBanned() and {RightLabel = "~w~Time Left " .. CORRUPT.getTimeLeft(d)} or
                        {RightLabel = "→→→"},
                    not CORRUPT.casinoBanned(),
                    function(e, f, g)
                    end,
                    RMenu:Get("corrupthighrollers", "casinoban")
                )
                RageUI.ButtonWithStyle(
                    "View Casino Stats",
                    "~b~Your bet history throughout Corrupt.",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                    end,
                    RMenu:Get("corrupthighrollers", "casinostats")
                )
                RageUI.ButtonWithStyle(
                    "Claim Rakeback",
                    "~b~Claim a % of lost bets back.",
                    {RightLabel = "£" .. getMoneyStringFormatted(c)},
                    c > 0,
                    function(e, f, g)
                        if g then
                            c = 0
                            TriggerServerEvent("CORRUPT:claimRakeback")
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corrupthighrollers", "confirmadd"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "No",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            tvRP.notify("~y~Cancelled!")
                        end
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
                RageUI.ButtonWithStyle(
                    "Yes",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            TriggerServerEvent("CORRUPT:purchaseHighRollersMembership")
                        end
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corrupthighrollers", "confirmremove"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "No",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            tvRP.notify("~y~Cancelled!")
                        end
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
                RageUI.ButtonWithStyle(
                    "Yes",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            TriggerServerEvent("CORRUPT:removeHighRollersMembership")
                        end
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corrupthighrollers", "casinoban"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Ban Duration",
                    "",
                    d > 0 and {RightLabel = d .. " hours"} or {RightLabel = "Set Duration"},
                    true,
                    function(e, f, g)
                        if g then
                            CORRUPT.clientPrompt(
                                "Ban Duration: ",
                                "",
                                function(h)
                                    if tonumber(h) then
                                        if tonumber(h) > 0 then
                                            d = tonumber(h)
                                        else
                                            tvRP.notify("~r~Invalid duration.")
                                        end
                                    else
                                        tvRP.notify("~r~Invalid duration.")
                                    end
                                end
                            )
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Confirm Ban",
                    "~r~This is an irrevocable action.",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            TriggerServerEvent("CORRUPT:casinoBan", d)
                        end
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corrupthighrollers", "casinostats"),
            true,
            true,
            true,
            function()
                if next(b) then
                    for i, j in pairs(b) do
                        RageUI.Separator(j)
                    end
                else
                    RageUI.Separator("~r~You have no casino stats to display.")
                end
                RageUI.ButtonWithStyle(
                    "Back",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                    end,
                    RMenu:Get("corrupthighrollers", "casino")
                )
            end,
            function()
            end
        )
    end
)
RegisterNetEvent("CORRUPT:setCasinoStats")
AddEventHandler(
    "CORRUPT:setCasinoStats",
    function(k, l, m)
        b = k
        c = l
        d = m
    end
)
function showCasinoMembership(n)
    RageUI.Visible(RMenu:Get("corrupthighrollers", "casino"), n)
end
Citizen.CreateThread(
    function()
        local o = "mini@strip_club@idles@bouncer@base"
        RequestAnimDict(o)
        while not HasAnimDictLoaded(o) do
            RequestAnimDict(o)
            Wait(0)
        end
        for p, q in pairs(a) do
            local r = CORRUPT.loadModel("u_f_m_casinocash_01")
            local s = CreatePed(26, r, q.pedPosition.x, q.pedPosition.y, q.pedPosition.z, 175.0, false, true)
            SetModelAsNoLongerNeeded(r)
            SetEntityCanBeDamaged(s, 0)
            SetPedAsEnemy(s, 0)
            SetBlockingOfNonTemporaryEvents(s, 1)
            SetPedResetFlag(s, 249, 1)
            SetPedConfigFlag(s, 185, true)
            SetPedConfigFlag(s, 108, true)
            SetPedCanEvasiveDive(s, 0)
            SetPedCanRagdollFromPlayerImpact(s, 0)
            SetPedConfigFlag(s, 208, true)
            SetEntityCoordsNoOffset(s, q.pedPosition.x, q.pedPosition.y, q.pedPosition.z, 175.0, 0, 0, 1)
            SetEntityHeading(s, q.pedHeading)
            FreezeEntityPosition(s, true)
            TaskPlayAnim(s, o, "base", 8.0, 0.0, -1, 1, 0, 0, 0, 0)
            RemoveAnimDict(o)
        end
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(t, u)
        if u then
            TriggerServerEvent("CORRUPT:getCasinoStats")
            local v = function(w)
                TriggerServerEvent("CORRUPT:getCasinoStats")
                showCasinoMembership(true)
            end
            local x = function(w)
                RageUI.CloseAll()
                showCasinoMembership(false)
            end
            local y = function(w)
            end
            for z, q in pairs(a) do
                tvRP.addBlip(
                    q.entryPosition.x,
                    q.entryPosition.y,
                    q.entryPosition.z,
                    682,
                    0,
                    "Casino Memberships",
                    0.7,
                    true
                )
                tvRP.addMarker(
                    q.entryPosition.x,
                    q.entryPosition.y,
                    q.entryPosition.z,
                    1.0,
                    1.0,
                    1.0,
                    138,
                    43,
                    226,
                    70,
                    50,
                    27
                )
                CORRUPT.createArea("casinomembership_" .. z, q.entryPosition, 1.5, 6, v, x, y, {})
            end
        end
    end
)
function CORRUPT.casinoBanned()
    return d > 0
end
