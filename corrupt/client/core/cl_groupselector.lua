local a = module("cfg/cfg_groupselector")
local b = a.selectors
local c = {}
local d = false
local e = ""
RMenu.Add(
    "main",
    "groupselector",
    RageUI.CreateMenu(
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_licenseui",
        "corrupt_licenseui"
    )
)
RMenu:Get("main", "groupselector"):SetSubtitle("Select a job.")
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(f, g)
        if g and not CORRUPT.isPurge() then
            TriggerServerEvent("CORRUPT:getJobSelectors")
            TriggerServerEvent("CORRUPT:getFactionWhitelistedGroups")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:gotJobSelectors",
    function(h)
        c = h
        local i = function(j)
            e = j.selectorId
        end
        local k = function(j)
            RageUI.CloseAll()
            RageUI.Visible(RMenu:Get("main", "groupselector"), false)
        end
        local l = function(j)
            if IsControlJustPressed(1, 38) then
                local m = b[j.selectorId].type
                RageUI.CloseAll()
                RMenu:Get("main", "groupselector"):SetSpriteBanner(
                    a.selectorTypes[m]._config.TextureDictionary,
                    a.selectorTypes[m]._config.texture
                )
                RageUI.Visible(RMenu:Get("main", "groupselector"), true)
            end
            local n, o, p = table.unpack(GetFinalRenderedCamCoord())
            DrawText3D(
                b[j.selectorId].position.x,
                b[j.selectorId].position.y,
                b[j.selectorId].position.z,
                "Press [E] to open Job Selector.",
                n,
                o,
                p
            )
        end
        for q, r in pairs(c) do
            CORRUPT.createArea("selector_" .. q, r.position, 1.5, 6, i, k, l, {selectorId = q})
            tvRP.addMarker(r.position.x, r.position.y, r.position.z - 1, 1.0, 1.0, 1.0, 255, 0, 0, 170, 50, 27)
            tvRP.addBlip(
                r.position.x,
                r.position.y,
                r.position.z,
                r._config.blipid,
                r._config.blipcolor,
                r._config.name
            )
        end
    end
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("main", "groupselector"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("main", "groupselector"),
            true,
            true,
            true,
            function()
                for q, r in pairs(c) do
                    if q == e then
                        for s, t in pairs(r.jobs) do
                            RageUI.ButtonWithStyle(
                                t[1],
                                r._config.name,
                                {RightLabel = "→→→"},
                                true,
                                function(u, v, w)
                                    if w then
                                        TriggerServerEvent("CORRUPT:jobSelector", q, t[1])
                                        SetTimeout(
                                            1000,
                                            function()
                                                TriggerServerEvent("CORRUPT:refreshGaragePermissions")
                                                ExecuteCommand("blipson")
                                            end
                                        )
                                    end
                                end
                            )
                        end
                        RageUI.ButtonWithStyle(
                            "Unemployed",
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(u, v, w)
                                if w then
                                    TriggerServerEvent("CORRUPT:jobSelector", q, "Unemployed")
                                    SetTimeout(
                                        1000,
                                        function()
                                            TriggerServerEvent("CORRUPT:refreshGaragePermissions")
                                        end
                                    )
                                end
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
