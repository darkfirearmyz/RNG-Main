local a = nil
local b = {}
local c = ""
local function d()
    if next(b) then
        return true
    end
    return false
end
RMenu.Add(
    "frwardrobe",
    "mainmenu",
    RageUI.CreateMenu(
        "",
        "",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_wardrobeui",
        "corrupt_wardrobeui"
    )
)
RMenu:Get("frwardrobe", "mainmenu"):SetSubtitle("HOME")
RMenu.Add(
    "frwardrobe",
    "listoutfits",
    RageUI.CreateSubMenu(
        RMenu:Get("frwardrobe", "mainmenu"),
        "",
        "Wardrobe",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "frwardrobe",
    "equip",
    RageUI.CreateSubMenu(
        RMenu:Get("frwardrobe", "listoutfits"),
        "",
        "Wardrobe",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("frwardrobe", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("frwardrobe", "mainmenu"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "List Outfits",
                    "",
                    {RightLabel = "→→→"},
                    d(),
                    function(e, f, g)
                    end,
                    RMenu:Get("frwardrobe", "listoutfits")
                )
                RageUI.ButtonWithStyle(
                    "Save Outfit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            c = getGenericTextInput("outfit name:")
                            if c then
                                if not CORRUPT.isPlayerInAnimalForm() then
                                    TriggerServerEvent("CORRUPT:saveWardrobeOutfit", c)
                                else
                                    tvRP.notify("Cannot save animal in wardrobe.")
                                end
                            else
                                tvRP.notify("~r~Invalid outfit name")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Get Outfit Code",
                    "Gets a code for your current outfit which can be shared with other players.",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            if tvRP.isPlusClub() or tvRP.isPlatClub() then
                                TriggerServerEvent("CORRUPT:getCurrentOutfitCode")
                            else
                                tvRP.notify(
                                    "~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature."
                                )
                                tvRP.notify("~y~Available @ corrupt.tebex.io")
                            end
                        end
                    end,
                    nil
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frwardrobe", "listoutfits"),
            true,
            true,
            true,
            function()
                if b ~= {} then
                    for h, i in pairs(b) do
                        RageUI.ButtonWithStyle(
                            h,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(e, f, g)
                                if g then
                                    c = h
                                end
                            end,
                            RMenu:Get("frwardrobe", "equip")
                        )
                    end
                else
                    RageUI.ButtonWithStyle(
                        "No outfits saved",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(e, f, g)
                        end,
                        RMenu:Get("frwardrobe", "mainmenu")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("frwardrobe", "equip"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Equip Outfit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            TriggerServerEvent("CORRUPT:equipWardrobeOutfit", c)
                        end
                    end,
                    RMenu:Get("frwardrobe", "listoutfits")
                )
                RageUI.ButtonWithStyle(
                    "Delete Outfit",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(e, f, g)
                        if g then
                            TriggerServerEvent("CORRUPT:deleteWardrobeOutfit", c)
                        end
                    end,
                    RMenu:Get("frwardrobe", "listoutfits")
                )
            end,
            function()
            end
        )
    end
)
local function j()
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("frwardrobe", "mainmenu"), true)
end
local function k()
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("frwardrobe", "mainmenu"), false)
end
RegisterNetEvent(
    "CORRUPT:openOutfitMenu",
    function(l)
        if l then
            b = l
        else
            TriggerServerEvent("CORRUPT:initWardrobe")
        end
        j()
    end
)
RegisterNetEvent(
    "CORRUPT:refreshOutfitMenu",
    function(l)
        b = l
    end
)
RegisterNetEvent(
    "CORRUPT:closeOutfitMenu",
    function()
        k()
    end
)
