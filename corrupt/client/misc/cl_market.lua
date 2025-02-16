RMenu.Add(
    "corruptmarket",
    "main",
    RageUI.CreateMenu("", "Items", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_marketui", "corrupt_marketui")
)
RMenu.Add(
    "corruptmarket",
    "amount",
    RageUI.CreateSubMenu(RMenu:Get("corruptmarket", "main"), "", " ", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight())
)
local a = {
    menuOpen = false,
    currentMenu = 0,
    markets = {},
    marketsTypes = {},
    distanceToMarket = 0,
    currentMarket = {},
    amountIndex = 1,
    selectedItem = {},
    itemNames = {},
    currentMarketId = ""
}
local b = {}
local c = {}
local d = {}
local e
local f = {}
for g = 1, 100 do
    table.insert(f, tostring(g))
end
local function h(i)
    local j = {}
    for k, l in pairs(i) do
        if k ~= "_config" then
            table.insert(j, {itemId = k, price = l})
        end
    end
    table.sort(
        j,
        function(m, n)
            return m.price < n.price
        end
    )
    local g = 0
    return function()
        g = g + 1
        if j[g] then
            return j[g].itemId, j[g].price
        else
            return nil, nil
        end
    end
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corruptmarket", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corruptmarket", "main"),
            true,
            false,
            true,
            function()
                local o = false
                for p, l in h(a.currentMarket) do
                    if a.currentMarket["_config"].lottery and not o and l > CORRUPT.getLotteryTicketPrice() then
                        RageUI.ButtonWithStyle(
                            "Lottery Ticket",
                            "",
                            {RightLabel = "£" .. getMoneyStringFormatted(CORRUPT.getLotteryTicketPrice())},
                            true,
                            function(q, r, s)
                                if s then
                                    RMenu:Get("corruptmarket", "amount").MetaData = {
                                        item_id = "lottery",
                                        price = CORRUPT.getLotteryTicketPrice()
                                    }
                                end
                            end,
                            RMenu:Get("corruptmarket", "amount")
                        )
                        o = true
                    end
                    RageUI.ButtonWithStyle(
                        a.itemNames[a.currentMarketId][p][1],
                        a.itemNames[a.currentMarketId][p][3],
                        {RightLabel = "£" .. getMoneyStringFormatted(l)},
                        true,
                        function(q, r, s)
                            if s then
                                RMenu:Get("corruptmarket", "amount").MetaData = {item_id = p, price = l}
                            end
                        end,
                        RMenu:Get("corruptmarket", "amount")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corruptmarket", "amount"),
            true,
            false,
            true,
            function(t)
                RageUI.List(
                    "Amount",
                    f,
                    a.amountIndex,
                    "Current Price: £" .. getMoneyStringFormatted(t.price * a.amountIndex),
                    {},
                    true,
                    function(q, r, s, u)
                        if r then
                            a.amountIndex = u
                        end
                    end,
                    function()
                    end,
                    nil
                )
                RageUI.Button(
                    "Buy",
                    "Current Price: £" .. getMoneyStringFormatted(t.price * a.amountIndex),
                    {},
                    function(q, r, s)
                        if s then
                            if t.item_id == "lottery" then
                                TriggerServerEvent("CORRUPT:buyLotteryTicket", a.amountIndex)
                            else
                                TriggerServerEvent("CORRUPT:requestToBuyItem", t.item_id, a.amountIndex)
                            end
                        end
                    end
                )
            end,
            function()
            end
        )
    end
)
RegisterNetEvent(
    "CORRUPT:buildMarketMenus",
    function(v)
        for g = 1, #d do
            tvRP.removeArea(d[g])
            d[g] = nil
        end
        for g = 1, #c do
            tvRP.removeMarker(c[g])
        end
        local w = function(t)
            a.currentMarket = b[t.market_id]
            a.currentMarketId = t.market_id
            a.menuOpen = true
            RageUI.CloseAll()
            RageUI.Visible(RMenu:Get("corruptmarket", "main"), true)
        end
        local x = function()
            a.menuOpen = false
            RageUI.CloseAll()
            RageUI.Visible(RMenu:Get("corruptmarket", "main"), false)
        end
        local y = function()
        end
        for g = 1, #v do
            local z = v[g]
            local A = "market" .. v[g][1] .. g
            CORRUPT.createArea(A, z[2], 1.25, 6, w, x, y, {market_id = v[g][1]})
            local B = tvRP.addMarker(z[2].x, z[2].y, z[2].z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 29, true, true)
            d[#d + 1] = A
            c[#c + 1] = B
        end
    end
)
RegisterNetEvent(
    "CORRUPT:buildMarkets",
    function(C, D)
        b = C
        a.itemNames = D
    end
)
RegisterNetEvent(
    "CORRUPT:playItemBoughtSound",
    function()
        SendNUIMessage({transactionType = "playMoney"})
    end
)
function GetMarketRefund(E)
    TriggerServerEvent("CORRUPT:getRefundFromMarket", E)
end
