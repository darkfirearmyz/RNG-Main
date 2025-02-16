local a = module("corrupt-assets", "cfg/weapons")
local b = false
local c
local d
local e = {name = "", price = "", model = "", priceString = "", ammoPrice = "", weaponShop = ""}
local f
local g
local h = ""
local i = false
local j = {
    ["Legion"] = {
        _config = {
            {
                vector3(-3171.5241699219, 1087.5402832031, 19.838747024536),
                vector3(-330.56484985352, 6083.6059570312, 30.454759597778)
            },
            154,
            1,
            "B&Q Tool Shop",
            {""},
            true
        }
    },
    ["SmallArmsDealer"] = {
        _config = {
            {
                vector3(2437.5708007813, 4966.5610351563, 41.34761428833),
                vector3(-1500.4978027344, -216.72758483887, 46.889373779297),
                vector3(1243.0490722656, -427.33932495117, 67.918403625488),
                vector3(21.739552, -1107.360962, 29.797031)
            },
            110,
            1,
            "Small Arms Dealer",
            {""},
            true
        }
    },
    ["CorruptDealer"] = {
        _config = {
            {
                vector3(-254.10989379883,6322.03515625,39.659301757812),
                vector3(-379.95166015625,6087.6396484375,39.608764648438)
            },
            110,
            1,
            "Corrupt Dealer",
            {""},
            true
        }
    },
    ["LargeArmsDealer"] = {
        _config = {
            {
                vector3(-1108.3199462891, 4934.7392578125, 217.35540771484),
                vector3(5065.6201171875, -4591.3857421875, 1.8652405738831)
            },
            110,
            1,
            "Large Arms Dealer",
            {"gang.whitelisted"},
            false
        }
    },
    ["VIP"] = {
        _config = {
            {vector3(-2151.6000976562,5192.17578125,15.715698242188)},
            110,
            5,
            "VIP Gun Store",
            {"vip.gunstore"},
            true
        }
    },
    ["Rebel"] = {
        _config = {
            {
                vector3(1545.2554931641,6331.5532226562,23.078569412231),
                vector3(4925.6259765625, -5243.0908203125, 1.524599313736)
            },
            110,
            5,
            "Rebel Gun Store",
            {"rebellicense.whitelisted"},
            true
        }
    },
    ["policeSmallArms"] = {
        _config = {
            {
                vector3(461.53082275391, -979.35876464844, 29.689668655396),
                vector3(1842.9096679688, 3690.7692871094, 33.267082214355),
                vector3(-443.00482177734, 5987.939453125, 31.716201782227),
                vector3(638.55255126953, 2.7499871253967, 43.423725128174),
                vector3(-1104.5264892578, -821.70153808594, 13.282785415649)
            },
            110,
            5,
            "MET Police Small Arms",
            {"police.armoury"},
            false,
            true
        }
    },
    ["policeLargeArms"] = {
        _config = {
            {
                vector3(1840.6104736328, 3691.4741210938, 33.350730895996),
                vector3(461.43179321289, -982.66412353516, 29.689668655396),
                vector3(-441.43609619141, 5986.4052734375, 31.716201782227),
                vector3(640.8759765625, -0.63530212640762, 43.423385620117),
                vector3(-1102.5059814453, -820.62091064453, 13.282785415649)
            },
            110,
            5,
            "MET Police Large Arms",
            {"police.loadshop2", "police.armoury"},
            false,
            true
        }
    },
    ["prisonArmoury"] = {
        _config = {
            {vector3(1779.3741455078, 2542.5639648438, 45.797782897949)},
            110,
            5,
            "Prison Armoury",
            {"hmp.menu"},
            false,
            true
        }
    }
}
RMenu.Add(
    "CORRUPTGunstore",
    "mainmenu",
    RageUI.CreateMenu("", "", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_gunstoreui", "corrupt_gunstoreui")
)
RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSubtitle("GUNSTORE")
RMenu.Add(
    "CORRUPTGunstore",
    "type",
    RageUI.CreateSubMenu(
        RMenu:Get("CORRUPTGunstore", "mainmenu"),
        "",
        "Purchase Weapon or Ammo",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_gunstoreui",
        "corrupt_gunstoreui"
    )
)
RMenu.Add(
    "CORRUPTGunstore",
    "confirm",
    RageUI.CreateSubMenu(
        RMenu:Get("CORRUPTGunstore", "type"),
        "",
        "Purchase confirm your purchase",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_gunstoreui",
        "corrupt_gunstoreui"
    )
)
RMenu.Add(
    "CORRUPTGunstore",
    "vip",
    RageUI.CreateSubMenu(
        RMenu:Get("CORRUPTGunstore", "mainmenu"),
        "",
        "Purchase Weapon or Ammo",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_gunstoreui",
        "corrupt_gunstoreui"
    )
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("CORRUPTGunstore", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("CORRUPTGunstore", "mainmenu"),
            true,
            true,
            true,
            function()
                i = false
                if c ~= nil and j ~= nil then
                    if tvRP.isPlatClub() then
                        if c == "VIP" then
                            RageUI.ButtonWithStyle(
                                "~y~[Platinum Large Arms]",
                                "",
                                {RightLabel = "→→→"},
                                true,
                                function(k, l, m)
                                end,
                                RMenu:Get("CORRUPTGunstore", "vip")
                            )
                        end
                    end
                    for n, o in pairs(j) do
                        if c == n then
                            for p, q in pairs(sortedKeys(o)) do
                                local r = o[q]
                                if q ~= "_config" then
                                    local s, t, u = table.unpack(r)
                                    local v = false
                                    local w
                                    if q == "item|fillUpArmour" then
                                        local x = GetPedArmour(CORRUPT.getPlayerPed())
                                        local y = 100 - x
                                        w = y * 1000
                                        v = true
                                    end
                                    local z = ""
                                    if v then
                                        z = tostring(getMoneyStringFormatted(w))
                                    else
                                        z = tostring(getMoneyStringFormatted(t))
                                    end
                                    RageUI.ButtonWithStyle(
                                        s,
                                        "£" .. z,
                                        {RightLabel = "→→→"},
                                        true,
                                        function(k, l, m)
                                            if k then
                                            end
                                            if l then
                                                f = q
                                            end
                                            if m then
                                                e.name = s
                                                e.priceString = z
                                                e.model = q
                                                e.price = t
                                                e.ammoPrice = u
                                                e.weaponShop = n
                                            end
                                        end,
                                        RMenu:Get("CORRUPTGunstore", "type")
                                    )
                                end
                            end
                        end
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTGunstore", "type"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Purchase Weapon Body",
                    "£" .. getMoneyStringFormatted(e.price),
                    {RightLabel = "→→→"},
                    true,
                    function(k, l, m)
                        if m then
                            h = "body"
                        end
                    end,
                    RMenu:Get("CORRUPTGunstore", "confirm")
                )
                if
                    not a.weapons[e.model] or
                        a.weapons[e.model].ammo ~= "modelammo" and a.weapons[e.model].ammo ~= ""
                    then
                    RageUI.ButtonWithStyle(
                        "Purchase Weapon Ammo (Max)",
                        "£" .. getMoneyStringFormatted(math.floor(e.price / 2)),
                        {RightLabel = "→→→"},
                        true,
                        function(k, l, m)
                            if m then
                                h = "ammo"
                            end
                        end,
                        RMenu:Get("CORRUPTGunstore", "confirm")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTGunstore", "confirm"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Yes",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, l, m)
                        if m then
                            if string.sub(e.model, 1, 4) == "item" then
                                TriggerServerEvent("CORRUPT:buyWeapon", e.model, e.price, e.name, e.weaponShop, "armour")
                            else
                                if h == "ammo" then
                                    if HasPedGotWeapon(CORRUPT.getPlayerPed(), GetHashKey(e.model), false) then
                                        TriggerServerEvent(
                                            "CORRUPT:buyWeapon",
                                            e.model,
                                            e.price,
                                            e.name,
                                            e.weaponShop,
                                            "ammo"
                                        )
                                    else
                                        tvRP.notify("You do not have the body of this weapon to purchase ammo.")
                                    end
                                else
                                    TriggerServerEvent(
                                        "CORRUPT:buyWeapon",
                                        e.model,
                                        e.price,
                                        e.name,
                                        e.weaponShop,
                                        "weapon",
                                        i
                                    )
                                end
                            end
                        end
                    end,
                    RMenu:Get("CORRUPTGunstore", "confirm")
                )
                RageUI.ButtonWithStyle(
                    "No",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, l, m)
                    end,
                    RMenu:Get("CORRUPTGunstore", "mainmenu")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTGunstore", "vip"),
            true,
            true,
            true,
            function()
                local A = j["LargeArmsDealer"]
                for p, q in pairs(sortedKeys(A)) do
                    i = true
                    local r = A[q]
                    if q ~= "_config" then
                        local s, t, u = table.unpack(r)
                        local v = false
                        local w
                        if q == "item|fillUpArmour" then
                            local x = GetPedArmour(CORRUPT.getPlayerPed())
                            local y = 100 - x
                            w = y * 1000
                            v = true
                        end
                        local z = ""
                        if v then
                            z = tostring(getMoneyStringFormatted(w))
                        else
                            z = tostring(getMoneyStringFormatted(t))
                        end
                        RageUI.ButtonWithStyle(
                            s,
                            "£" .. z,
                            {RightLabel = "→→→"},
                            true,
                            function(k, l, m)
                                if k then
                                end
                                if l then
                                    f = q
                                end
                                if m then
                                    e.name = s
                                    e.priceString = z
                                    e.model = q
                                    e.price = t
                                    e.ammoPrice = u
                                    e.weaponShop = "VIP"
                                end
                            end,
                            RMenu:Get("CORRUPTGunstore", "type")
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
    "CORRUPT:refreshGunStorePermissions",
    function()
        TriggerServerEvent("CORRUPT:requestNewGunshopData")
    end
)
local B = false
RegisterNetEvent("CORRUPT:recieveFilteredGunStoreData")
AddEventHandler(
    "CORRUPT:recieveFilteredGunStoreData",
    function(C)
        j = C
        for l, D in pairs(C) do
            if D["WEAPON_MP5TAZER"] then
                B = true
            end
        end
    end
)
RegisterNetEvent("CORRUPT:recalculateLargeArms")
AddEventHandler(
    "CORRUPT:recalculateLargeArms",
    function(B)
        for n, o in pairs(j) do
            if n == "LargeArmsDealer" then
                for s, E in pairs(o) do
                    if s ~= "_config" then
                        local F = j[n][s][7]
                        j[n][s][2] = F * (1 + B / 100)
                    end
                end
            end
        end
    end
)
local function G(n, H)
    c = n
    d = H
    if n == "Rebel" then
        RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSpriteBanner("corrupt_rebel", "corrupt_rebel")
    elseif n == "policeSmallArms" then
        RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "confirm"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "type"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
    elseif n == "policeLargeArms" then
        RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "confirm"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "type"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
    elseif n == "prisonArmoury" then
        RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "confirm"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
        RMenu:Get("CORRUPTGunstore", "type"):SetSpriteBanner("corrupt_jobselectorui", "metpd")
    else
        RMenu:Get("CORRUPTGunstore", "mainmenu"):SetSpriteBanner("corrupt_gunstoreui", "corrupt_gunstoreui")
    end
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("CORRUPTGunstore", "mainmenu"), true)
end
local function I(n)
    c = nil
    d = nil
    f = nil
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("CORRUPTGunstore", "mainmenu"), false)
end
Citizen.CreateThread(
    function()
        while true do
            if f and g ~= f then
                g = f
                for n, o in pairs(j) do
                    local E = o[g]
                    if E then
                        local D = E[5]
                        if D and d then
                            local J = o._config[1][d]
                            if i then
                                J = vector3(-2151.5739746094, 5191.2548828125, 14.718822479248)
                            end
                            local K = CORRUPT.loadModel(D)
                            if K and J then
                                local L = CreateObject(K, J.x, J.y, J.z + 1, false, false, false)
                                while g == f and DoesEntityExist(L) do
                                    SetEntityHeading(L, GetEntityHeading(L) + 1 % 360)
                                    Wait(0)
                                end
                                DeleteEntity(L)
                            end
                            SetModelAsNoLongerNeeded(K)
                        end
                    end
                end
            end
            local M = PlayerPedId()
            if not B and GetSelectedPedWeapon(M) == `WEAPON_MP5TAZER` then
                CORRUPT.setWeapon(M, "WEAPON_UNARMED", true)
            end
            Wait(0)
        end
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(N, O)
        if O then
            TriggerServerEvent("CORRUPT:requestNewGunshopData")
            for n, o in pairs(j) do
                local P, Q, M, R, S, T = table.unpack(o["_config"])
                for H, U in pairs(P) do
                    if T then
                        tvRP.addBlip(U.x, U.y, U.z, Q, M, R)
                    end
                    tvRP.addMarker(U.x, U.y, U.z, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
                    local V = function()
                        if GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false) == 0 then
                            G(n, H)
                        else
                            tvRP.notify("Exit your vehicle to access the gun store.")
                        end
                    end
                    local W = function()
                        I(n)
                    end
                    local X = function()
                    end
                    CORRUPT.createArea("gunstore_" .. n .. "_" .. H, U, 1.5, 6, V, W, X, {})
                end
            end
        end
    end
)
local Y = {}
function CORRUPT.createGunStore(Z, _, a0)
    local V = function()
        if GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false) == 0 then
            G(_)
        else
            tvRP.notify("Exit your vehicle to access the gun store.")
        end
    end
    local W = function()
        I(_)
    end
    local a1 = string.format("gunstore_%s_%s", _, Z)
    CORRUPT.createArea(
        a1,
        a0,
        1.5,
        6,
        V,
        W,
        function()
        end
    )
    local a2 = tvRP.addMarker(a0.x, a0.y, a0.z, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
    Y[Z] = {area = a1, marker = a2}
end
function CORRUPT.deleteGunStore(Z)
    local a3 = Y[Z]
    if a3 then
        CORRUPT.removeMarker(a3.marker)
        tvRP.removeArea(a3.area)
        Y[Z] = nil
    end
end
