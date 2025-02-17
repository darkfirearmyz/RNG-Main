local a = module("cfg/cfg_jewelleryheist")
RMenu.Add(
    "frSellJewelry",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~Sell Jewelry",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "shopui_title_arenawar",
        "shopui_title_arenawar"
    )
)
local b
RageUI.CreateWhile(
    1.0,
    RMenu:Get("frSellJewelry", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("frSellJewelry", "main"),
            true,
            false,
            true,
            function()
                for c = 1, #a.jewelryItems, 1 do
                    RageUI.ButtonWithStyle(
                        a.jewelryItems[c].name,
                        "",
                        {RightLabel = "£" .. getMoneyStringFormatted(a.jewelryItems[c].sellPrice)},
                        true,
                        function(d, e, f)
                            if e then
                                b = c
                            end
                            if f then
                                TriggerServerEvent(
                                    "CORRUPT:sellJewelry",
                                    a.jewelryItems[b].spawnName,
                                    a.jewelryItems[b].sellPrice,
                                    a.jewelryItems[b].name
                                )
                            end
                        end,
                        nil
                    )
                end
            end,
            function()
            end
        )
    end
)
Citizen.CreateThread(
    function()
        enter_sellJewelry = function()
            RageUI.Visible(RMenu:Get("frSellJewelry", "main"), true)
        end
        exit_sellJewelry = function()
            RageUI.Visible(RMenu:Get("frSellJewelry", "main"), false)
        end
        ontick_sellJewelry = function()
        end
        for c = 1, #a.jewelrySellLocs, 1 do
            tvRP.addMarker(
                a.jewelrySellLocs[c].coords.x,
                a.jewelrySellLocs[c].coords.y,
                a.jewelrySellLocs[c].coords.z - 0.9,
                0.8,
                0.8,
                0.8,
                200,
                0,
                0,
                255,
                30,
                27,
                false,
                false,
                false
            )
            tvRP.addBlip(
                a.jewelrySellLocs[c].coords.x,
                a.jewelrySellLocs[c].coords.y,
                a.jewelrySellLocs[c].coords.z,
                618,
                46,
                "Sell Jewelry"
            )
            CORRUPT.createArea(
                "sellJewelry_" .. c,
                a.jewelrySellLocs[c].coords,
                2.0,
                5.0,
                enter_sellJewelry,
                exit_sellJewelry,
                ontick_sellJewelry,
                {}
            )
        end
    end
)
