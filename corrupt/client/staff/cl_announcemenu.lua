RMenu.Add(
    "corruptannouncements",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~Announcement Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_announceui",
        "corrupt_announceui"
    )
)
local a = {}
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corruptannouncements", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corruptannouncements", "main"),
            true,
            true,
            true,
            function()
                for b, c in pairs(a) do
                    RageUI.ButtonWithStyle(
                        c.name,
                        string.format("%s Price: £%s", c.desc, getMoneyStringFormatted(c.price)),
                        {RightLabel = "→→→"},
                        true,
                        function(d, e, f)
                            if f then
                                TriggerServerEvent("CORRUPT:serviceAnnounce", c.name)
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
RegisterNetEvent(
    "CORRUPT:serviceAnnounceCl",
    function(g, h)
        CORRUPT.announce(g, h)
    end
)
RegisterNetEvent(
    "CORRUPT:buildAnnounceMenu",
    function(i)
        a = i
        RageUI.Visible(
            RMenu:Get("corruptannouncements", "main"),
            not RageUI.Visible(RMenu:Get("corruptannouncements", "main"))
        )
    end
)
RegisterCommand(
    "announcemenu",
    function()
        TriggerServerEvent("CORRUPT:getAnnounceMenu")
    end
)
