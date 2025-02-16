local managePlayerUI = false
local MoneyStuff = {}
local o = 0
local InventoryStuff = {}
local p = 0
local q = 14
local permid = nil
RegisterNetEvent("CORRUPT:receivedUserInformation")
AddEventHandler("CORRUPT:receivedUserInformation", function(moneyStuff,inventoryStuff,id)
    permid = id
    MoneyStuff = moneyStuff
    InventoryStuff = inventoryStuff.data
    F = inventoryStuff.weight
    e = inventoryStuff.maxWeight
    managePlayerUI = true
    inGUICORRUPT = true
    setCursor(1)
end)

local function M(N, O)
    local P = sortAlphabetically(N)
    local Q = #P
    local R = O * q
    local S = {}
    for T = R + 1, math.min(R + q, Q) do
        table.insert(S, P[T])
    end
    return S
end
Citizen.CreateThread(function()
    while true do
        if managePlayerUI then
            DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150)
            DrawAdvancedText(0.593, 0.242, 0.005, 0.0028, 0.66, "Player Management", 255, 255, 255, 255, 7, 0)
            DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225)
            DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
            DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
            DrawAdvancedText(0.594, 0.454, 0.005, 0.0028, 0.4, "Give Item", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.575, 0.545, 0.005, 0.0028, 0.325, "Give Cash", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.615, 0.545, 0.005, 0.0028, 0.325, "Take Cash", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.575, 0.634, 0.005, 0.0028, 0.325, "Give Bank", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.615, 0.634, 0.005, 0.0028, 0.325, "Take Bank", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.575, 0.722, 0.005, 0.0028, 0.325, "Give Chips", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.615, 0.722, 0.005, 0.0028, 0.325, "Take Chips", 255, 255, 255, 255, 6, 0)
            DrawRect(0.5, 0.273, 0.572, 0.0069999999999999, 0, 50, 142, 150)
            DisableControlAction(0, 200, true)
            inGUICORRUPT = true
            DrawAdvancedText(0.798, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.714, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.831, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
            local C = 0.026
            local D = 0.026
            local E = 0
            local F = 0
            for H, I in pairs(sortAlphabetically(InventoryStuff)) do
                F = F + I["value"].amount * I["value"].Weight
            end
            local Z = M(InventoryStuff, p)
            if #Z == 0 then
                p = 0
            end
            for H, I in pairs(Z) do
                local v = I.title
                local w = I["value"]
                local J, K, m = w.ItemName, w.amount, w.Weight
                DrawAdvancedText(0.714, 0.360 + E * D, 0.005, 0.0028, 0.366, J, 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.831,0.360 + E * D,0.005,0.0028,0.366,tostring(m * K) .. "kg",255,255,255,255,4,0)
                DrawAdvancedText(0.798, 0.360 + E * D, 0.005, 0.0028, 0.366, getMoneyStringFormatted(K), 255, 255, 255, 255, 4, 0)
                E = E + 1
            end
            DrawAdvancedText(0.750,0.3,0.005,0.0028,0.5,"Player's Inventory",255,255,255,255,4,0)
            if table.count(InventoryStuff) > q then
                DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                if CursorInArea(0.735, 0.755, 0.72, 0.76) and (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then
                    local U = math.floor(table.count(InventoryStuff) / q)
                    p = math.min(p + 1, U)
                end
                DrawAdvancedText(0.661, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                if CursorInArea(0.55, 0.58, 0.72, 0.76) and (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329)) then
                    p = math.max(p - 1, 0)
                end
            end
            local C = 0.026
            local D = 0.026
            local E = 0
            local F = 0
            local G = sortAlphabetically(MoneyStuff)
            for H, I in pairs(G) do
                local v = I.title
                local w = I["value"]
                local J, K, m = w.ItemName, w.amount, w.Weight
                F = F + K * m
                DrawAdvancedText(0.404, 0.335 + E * D, 0.005, 0.0028, 0.366, J, 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.488, 0.335 + E * D, 0.005, 0.0028, 0.366, "£"..getMoneyStringFormatted(K), 255, 255, 255, 255, 4, 0)
                E = E + 1
            end
            DrawAdvancedText(0.440,0.3,0.005,0.0028,0.5,"Player's Assets",255,255,255,255,4,0)
            if CursorInArea(0.4598, 0.5333, 0.418, 0.4709) then
                DrawRect(0.5, 0.45, 0.075, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    TriggerServerEvent('CORRUPT:ManagePlayerItem',permid)
                end
            else
                DrawRect(0.5, 0.45, 0.075, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.4598, 0.498, 0.5042, 0.5666) then
                DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerCash',permid,l,"Increase")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.5004, 0.5333, 0.5042, 0.5666) then
                DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerCash',permid,l,"Decrease")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.4598, 0.498, 0.5931, 0.6477) then
                DrawRect(0.48, 0.629, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerBank',permid,l,"Increase")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.48, 0.629, 0.0375, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.5004, 0.5333, 0.5931, 0.6477) then
                DrawRect(0.52, 0.629, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerBank',permid,l,"Decrease")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.52, 0.629, 0.0375, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.4598, 0.498, 0.6831, 0.7377) then
                DrawRect(0.48, 0.718, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerChips',permid,l,"Increase")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.48, 0.718, 0.0375, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.5004, 0.5333, 0.6831, 0.7377) then
                DrawRect(0.52, 0.718, 0.0375, 0.056, 0, 50, 142, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    CORRUPT.clientPrompt("Amount:","",function(l)
                        if tonumber(l) then
                            TriggerServerEvent('CORRUPT:ManagePlayerChips',permid,l,"Decrease")
                        else
                            tvRP.notify("~r~Invalid Amount")
                        end
                    end)
                end
            else
                DrawRect(0.52, 0.718, 0.0375, 0.056, 0, 0, 0, 150)
            end
            DisableControlAction(0, 177, true)
            if IsDisabledControlPressed(0, 177) then
                managePlayerUI = false
                setCursor(0)
                inGUICORRUPT=false
            end
        end
        Wait(0)
    end
end)