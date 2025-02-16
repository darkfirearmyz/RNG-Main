local a = 0
local b = 0
local c = 0
local d = 2
proximityIdToString = {[1] = "Whisper", [2] = "Talking", [3] = "Shouting"}
local e, f = GetActiveScreenResolution()
RegisterNetEvent("CORRUPT:showHUD")
AddEventHandler(
    "CORRUPT:showHUD",
    function(g)
        showhudUI(g)
    end
)
AddEventHandler(
    "pma-voice:setTalkingMode",
    function(h)
        d = h
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, i.rightX * i.resX)
    end
)
function updateMoneyUI(j, k, l, m, i, n)
    SendNUIMessage(
        {
            updateMoney = true,
            cash = j,
            bank = k,
            redmoney = l,
            userId = CORRUPT.getUserId(),
            proximity = proximityIdToString[m],
            topLeftAnchor = i,
            yAnchor = n
        }
    )
end
function showhudUI(g)
    SendNUIMessage({showMoney = g})
end
RegisterNetEvent("CORRUPT:setDisplayMoney")
RegisterNetEvent(
    "CORRUPT:setDisplayMoney",
    function(o)
        local p = tostring(math.floor(o))
        a = getMoneyStringFormatted(p)
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, i.rightX * i.resX)
    end
)
RegisterNetEvent("CORRUPT:setDisplayBankMoney")
AddEventHandler(
    "CORRUPT:setDisplayBankMoney",
    function(o)
        local p = tostring(math.floor(o))
        b = getMoneyStringFormatted(p)
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, i.rightX * i.resX)
    end
)
RegisterNetEvent("CORRUPT:setDisplayRedMoney")
AddEventHandler(
    "CORRUPT:setDisplayRedMoney",
    function(o)
        local p = tostring(math.floor(o))
        c = getMoneyStringFormatted(p)
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, i.rightX * i.resX)
    end
)
RegisterNetEvent("CORRUPT:initMoney")
AddEventHandler(
    "CORRUPT:initMoney",
    function(j, k)
        local q = tostring(math.floor(j))
        a = getMoneyStringFormatted(q)
        local p = tostring(math.floor(k))
        b = getMoneyStringFormatted(p)
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, i.rightX * i.resX)
    end
)
Citizen.CreateThread(
    function()
        Wait(5000)
        TriggerServerEvent("CORRUPT:requestPlayerBankBalance")
        local r = false
        while true do
            local s, t = GetActiveScreenResolution()
            if s ~= e or t ~= f then
                e, f = GetActiveScreenResolution()
                cachedMinimapAnchor = GetMinimapAnchor()
                updateMoneyUI("£" .. a, "£" .. b, "£" .. c, d, cachedMinimapAnchor.rightX * cachedMinimapAnchor.resX)
            end
            if NetworkIsPlayerTalking(PlayerId()) then
                if not r then
                    r = true
                    SendNUIMessage({moneyTalking = true})
                end
            else
                if r then
                    r = false
                    SendNUIMessage({moneyTalking = false})
                end
            end
            Wait(0)
        end
    end
)
RegisterNUICallback(
    "moneyUILoaded",
    function(u, v)
        local i = CORRUPT.getCachedMinimapAnchor()
        updateMoneyUI("£" .. tostring(a), "£" .. tostring(b), "£" .. tostring(c), d, i.rightX * i.resX)
    end
)
