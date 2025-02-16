local a = 0
local b = 0
local c = 0
local d = 0
RMenu.Add(
    "lottery",
    "mainmenu",
    RageUI.CreateMenu(
        "",
        "Main Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_lotteryui",
        "corrupt_lotteryui"
    )
)
RageUI.CreateWhile(
    1.0,
    RMenu:Get("lottery", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("lottery", "mainmenu"),
            true,
            true,
            true,
            function()
                RageUI.Separator("------------------")
                RageUI.Separator("Pot £" .. getMoneyStringFormatted(b))
                if c > 0 then
                    RageUI.Separator(tostring(c) .. " Participant" .. (c > 1 and "s" or ""))
                else
                    RageUI.Separator("No Participants")
                end
                if d > 0 then
                    local e = math.floor(b / a)
                    local f = d > 1 and " tickets" or " ticket"
                    RageUI.Separator(
                        "You have purchased " .. tostring(d) .. f .. " (" .. tostring(math.floor(d / e * 100)) .. "%)"
                    )
                else
                    RageUI.Separator("You haven't purchased any tickets")
                end
                RageUI.Separator("------------------")
                RageUI.Separator("~y~Drawn at 8:00PM UK Time")
                RageUI.Separator("~y~Tickets can be purchased at a convenience store")
            end
        )
    end
)
RegisterNetEvent(
    "CORRUPT:setLotteryInfo",
    function(g, h, i)
        a = g
        b = h
        c = i
    end
)
RegisterNetEvent(
    "CORRUPT:setPersonalAmountBought",
    function(j)
        d = j
    end
)
RegisterCommand(
    "lottery",
    function()
        RageUI.Visible(RMenu:Get("lottery", "mainmenu"), true)
        TriggerServerEvent("CORRUPT:getLotteryInfo")
    end,
    false
)
function CORRUPT.getLotteryTicketPrice()
    return a
end
