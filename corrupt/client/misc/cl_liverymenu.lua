RMenu.Add("corruptliverymenu", "main", RageUI.CreateMenu("Corrupt Livery Menu", "~b~Corrupt Livery Menu"))
local a
RMenu:Get("corruptliverymenu", "main"):SetStyleSize(90)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corruptliverymenu", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corruptliverymenu", "main"),
            true,
            false,
            true,
            function()
                if a ~= nil then
                    for b = 1, GetVehicleLiveryCount(a) do
                        RageUI.Button(
                            "Livery #" .. b,
                            nil,
                            {},
                            function(c, d, e)
                                if e then
                                    SetVehicleLivery(a, b)
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
RegisterKeyMapping("livery", "Livery Menu", "keyboard", "INSERT")
TriggerEvent("chat:addSuggestion", "/livery", "Open the livery menu")
local f = 0
RegisterCommand(
    "livery",
    function(g, h)
        local i = CORRUPT.getPlayerPed()
        local j = CORRUPT.getPlayerVehicle()
        if IsPedInAnyVehicle(i, false) and GetPedInVehicleSeat(j, -1) == i then
            if GetVehicleLiveryCount(j) > 0 then
                a = j
                RageUI.Visible(
                    RMenu:Get("corruptliverymenu", "main"),
                    not RageUI.Visible(RMenu:Get("corruptliverymenu", "main"))
                )
            else
                tvRP.notify("~r~This vehicle has no liveries!")
            end
        end
    end,
    false
)
