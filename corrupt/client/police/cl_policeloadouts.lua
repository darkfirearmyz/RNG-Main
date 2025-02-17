local a = {}
local b = nil
local c = module("corrupt-assets", "cfg/weapons")
local d = {
    vector3(457.0222, -983.0001, 30.68948),
    vector3(1844.323, 3692.164, 34.26707),
    vector3(-435.9965, 5989.574, 31.71618),
    vector3(-1106.505, -826.4623, 14.2828),
    vector3(-447.44174194336,6009.1782226562,31.706176757812)
}
RMenu.Add(
    "policeloadouts",
    "main",
    RageUI.CreateMenu(
        "",
        "Please Select Division",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_jobselectorui",
        "metpd"
    )
)
RMenu.Add(
    "policeloadouts",
    "confirm",
    RageUI.CreateSubMenu(
        RMenu:Get("policeloadouts", "main"),
        "",
        "Confirm Selection",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("policeloadouts", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("policeloadouts", "main"),
            true,
            true,
            true,
            function()
                for e, f in pairs(a) do
                    RageUI.ButtonWithStyle(
                        e,
                        nil,
                        f.hasPermission and {RightLabel = "→→→"} or {RightBadge = ""},
                        f.hasPermission,
                        function(g, h, i)
                            if i then
                                b = e
                            end
                        end,
                        RMenu:Get("policeloadouts", "confirm")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("policeloadouts", "confirm"),
            true,
            true,
            true,
            function()
                RageUI.Separator("~g~" .. b)
                for e, f in pairs(a[b].weapons) do
                    RageUI.Separator(c.weapons[f].name)
                end
                RageUI.ButtonWithStyle(
                    "Confirm",
                    nil,
                    {RightLabel = "→→→"},
                    true,
                    function(g, h, i)
                        if i then
                            TriggerServerEvent("CORRUPT:selectLoadout", b)
                            RageUI.Visible(RMenu:Get("policeloadouts", "confirm"), false)
                            RageUI.CloseAll()
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
RegisterNetEvent("CORRUPT:gotLoadouts")
AddEventHandler(
    "CORRUPT:gotLoadouts",
    function(j)
        a = j
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(k, l)
        if l then
            local m = function(n)
            end
            local o = function(n)
                b = nil
                RageUI.Visible(RMenu:Get("policeloadouts", "main"), false)
                RageUI.Visible(RMenu:Get("policeloadouts", "confirm"), false)
                RageUI.CloseAll()
            end
            local p = function(n)
                if IsControlJustPressed(1, 38) then
                    TriggerServerEvent("CORRUPT:getPoliceLoadouts")
                    RageUI.Visible(
                        RMenu:Get("policeloadouts", "main"),
                        not RageUI.Visible(RMenu:Get("policeloadouts", "main"))
                    )
                end
                local f, q, r = table.unpack(GetFinalRenderedCamCoord())
                DrawText3D(
                    d[n.locationId].x,
                    d[n.locationId].y,
                    d[n.locationId].z,
                    "Press [E] to open Police Loadouts",
                    f,
                    q,
                    r
                )
            end
            for e, f in pairs(d) do
                CORRUPT.createArea("police_loadouts_" .. e, f, 1.5, 6, m, o, p, {locationId = e})
            end
        end
    end
)
