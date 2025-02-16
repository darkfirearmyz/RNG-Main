RMenu.Add(
    "pedsmenu",
    "main",
    RageUI.CreateMenu("CORRUPT Peds", "CORRUPT Peds Menu", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight())
)
local a = module("cfg/cfg_peds")
local b = a.pedMenus
local c = {}
local d = nil
local e = nil
local f = true
local g
local h = false
local j = {}
local k = {}
local l = 0
RageUI.CreateWhile(
    1.0,
    RMenu:Get("pedsmenu", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("pedsmenu", "main"),
            true,
            true,
            true,
            function()
                if d ~= nil or e ~= nil and tvRP.getCustomization() ~= d then
                    RageUI.ButtonWithStyle(
                        "Reset",
                        nil,
                        {},
                        true,
                        function(m, n, o)
                            if o then
                                revertPedChange()
                            end
                        end
                    )
                end
                for i = 1, #c, 1 do
                    RageUI.ButtonWithStyle(
                        c[i][2],
                        nil,
                        {},
                        true,
                        function(m, n, o)
                            if o then
                                if GetEntityHealth(CORRUPT.getPlayerPed()) > 102 then
                                    spawnPed(c[i][1])
                                else
                                    tvRP.notify("You try to change ped, but then remember you are dead.")
                                end
                            end
                        end
                    )
                end
            end,
            function()
            end
        )
    end
)
function showPedsMenu(p)
    RageUI.Visible(RMenu:Get("pedsmenu", "main"), p)
end
function spawnPed(q)
    local r = CORRUPT.getPlayerPed()
    local s = GetEntityHeading(r)
    tvRP.setCustomization({model = q})
    SetEntityHeading(CORRUPT.getPlayerPed(), s)
    Wait(100)
    SetEntityMaxHealth(CORRUPT.getPlayerPed(), 200)
    CORRUPT.setHealth(200)
end
function revertPedChange()
    tvRP.setCustomization(d)
end
RegisterNetEvent(
    "CORRUPT:buildPedMenus",
    function(t)
        for i = 1, #j do
            tvRP.removeArea(j[i])
            j[i] = nil
        end
        for i = 1, #k do
            tvRP.removeMarker(k[i])
        end
        local u = function(v)
        end
        local w = function(x)
            c = a.peds[x.menu_id]
            g = i
            if f then
                d = tvRP.getCustomization()
                l = GetEntityHealth(CORRUPT.getPlayerPed())
            end
            h = true
            showPedsMenu(true)
            f = false
        end
        local y = function(v)
            showPedsMenu(false)
            f = true
            h = false
            CORRUPT.setHealth(l) 
        end
        for i = 1, #t do
            local z = t[i]
            local A = z[1]
            local B = string.format("pedmenu_%s_%s", A, i)
            CORRUPT.createArea(B, z[2], 1.25, 6, w, y, u, {menu_id = A})
            local C =
                tvRP.addMarker(z[2].x, z[2].y, z[2].z - 1, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 27, false, false)
            j[#j + 1] = B
            k[#k + 1] = C
        end
    end
)
function getPedMenuId(string)
    return stringsplit(string, "_")[2]
end
