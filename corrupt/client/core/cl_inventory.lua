local WeaponCfg = module("corrupt-assets", "cfg/weapons")
local WeaponConfig = WeaponCfg.weapons
drawInventoryUI = false
drawNewInventoryUI = false
local a = false
local b = false
local c = false
local d = 0.00
local e = 0.00
local f = nil
local g = nil
local h = nil
local i = false
local j = nil
local k = 0
local l = 0
local m = false
local n = {
    ["9mm"] = true,
    ["12gauge"] = true,
    [".308"] = true,
    ["7.62"] = true,
    ["5.56"] = true,
    [".357"] = true,
    ["p5.56mm"] = true,
    ["p.308"] = true,
    ["p9mm"] = true,
    ["p12gauge"] = true
}
local p = nil
local q = nil
local r = nil
local s = false
inventoryType = nil
local t = false
local HoverTempID = nil
local function u()
    if IsUsingKeyboard(2) and not tvRP.isInComa() and not tvRP.isHandcuffed() then
        TriggerServerEvent("CORRUPT:FetchPersonalInventory")
        if not i then
            if CORRUPT.getLegacyInventory() then
                drawInventoryUI = not drawInventoryUI
                if drawInventoryUI then
                    setCursor(1)
                else
                    setCursor(0)
                    inGUICORRUPT = false
                    if p then
                        tvRP.vc_closeDoor(q, 5)
                        p = nil
                        q = nil
                        r = nil
                        TriggerEvent("CORRUPT:clCloseTrunk")
                    end
                    inventoryType = nil
                    CORRUPT.clearInventory(true)
                    CORRUPTSecondItemList = {}
                end
            else
                drawNewInventoryUI = not drawNewInventoryUI
                if drawNewInventoryUI then
                    inGUICORRUPT = true
                    exports["corruptui"]:sendMessage({
                        app = "inventory",
                        type = "APP_TOGGLE",
                    })
                    exports["corruptui"]:setFocus(true, true, true)
                else
                    HoverTempID = nil
                    inGUICORRUPT = false
                    exports["corruptui"]:sendMessage({
                        app = "",
                        type = "APP_TOGGLE",
                    })
                    exports["corruptui"]:setFocus(false, false, false)
                    if p then
                        tvRP.vc_closeDoor(q, 5)
                        p = nil
                        q = nil
                        r = nil
                        TriggerEvent("CORRUPT:clCloseTrunk")
                    end
                    inventoryType = nil
                    CORRUPT.clearInventory(true)
                    CORRUPTSecondItemList = {}
                end
            end
        else
            tvRP.notify("~r~Cannot open inventory right before a restart!")
        end
    end
end
function weaponclass(name)
    name = string.gsub(name, "wbody|", "")
    local weapon = WeaponConfig[name]
    if name == "WEAPON_MOSIN" then
        return "Heavy"
    end
    if weapon then
        return weapon.class
    else
        return "none"
    end
end
function weaponsubtype(name)
    name = string.gsub(name, "wbody|", "")
    local weapon = WeaponConfig[name]
    if weapon then
        return weapon.subType
    else
        return "none"
    end
end

local sortedWeapons = {}

function CORRUPT.SetUiCurrentWeapons(weapons)
    sortedWeapons = {}
    for k, v in pairs(weapons) do
        local count = #sortedWeapons + 1
        local weapon = WeaponConfig[k]
        if weapon then
            local class = weapon.class
            local ammo = weapon.ammo
            local subType = weapon.subType
            if k == "WEAPON_MOSIN" then
                class = "Heavy"
            end
            if weapon.name ~= "Parachute" then
                if not subType then
                    table.insert(sortedWeapons, {id = count, name = weapon.name, class = class, ammo = ammo, itemId = k})
                else
                    table.insert(sortedWeapons, {id = count, name = weapon.name, class = class, ammo = ammo, subType = subType, itemId = k})
                end
            end
        end
    end
    exports["corruptui"]:sendMessage({
        app = "inventory",
        type = "INVENTORY_SET_EQUIPPED_WEAPONS",
        info = sortedWeapons
    })
end

function CORRUPT.getWeaponFromId(id)
    return sortedWeapons[id]
end



RegisterCommand("inventory", u, false)
RegisterKeyMapping("inventory", "Open Inventory", "KEYBOARD", "L")
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI and IsDisabledControlJustReleased(0, 200) then
                u()
            end
            Wait(0)
        end
    end
)
local CORRUPTNuiItemList = {}
local CORRUPTNuiSecondItemList = {}
local CORRUPTItemList = {}
local w = 0
local CORRUPTSecondItemList = {}
local currentInventoryMaxWeight = 30
local x = 0
local y = 14
function CORRUPT.getSpaceInFirstChest()
    return currentInventoryMaxWeight - d
end
function CORRUPT.getSpaceInSecondChest()
    local z = 0
    if next(CORRUPTSecondItemList) == nil then
        return e
    else
        for u, w in pairs(CORRUPTSecondItemList) do
            z = z + w.amount * w.weight
        end
        return e - z
    end
end
-- NUI Inventory
exports["corruptui"]:registerCallback("inventoryInitialRequest", function(data, cb)
    exports["corruptui"]:sendMessage({
        app = "inventory",
        type = "INVENTORY_SET_HAS_DONE_INITIAL_REQUEST",
    })
end)

function CORRUPT.RemakeTableForNUIInventory(tabletype, second)
    CORRUPTNuiItemList = {}
    CORRUPTNuiSecondItemList = {}
    for k,v in pairs(tabletype) do
        if v.amount > 0 then
            local class = weaponclass(k)
            local item = {
                name = v.name,
                amount = v.amount,
                weight = v.weight,
                combinedMass = v.amount * v.weight,
                itemId = k
            }
            if class and class ~= "none" then
                item.weapon = {
                    class = class
                }
            end
            local subtype = weaponsubtype(k)
            if subtype and subtype ~= "none" then
                item.weapon.subType = subtype
            end
            if second then
                table.insert(CORRUPTNuiSecondItemList, item)
            else
                table.insert(CORRUPTNuiItemList, item)
            end
        end
    end
end
function CORRUPT.clearInventory(invtype)
    if not invtype then
        CORRUPTNuiItemList = {}
    else
        CORRUPTNuiSecondItemList = {}
    end
    exports["corruptui"]:sendMessage({
        app = "inventory",
        type = "INVENTORY_SET_PRIMARY",
        info = {
            currentMass = d,
            maximumMass = currentInventoryMaxWeight,
            items = CORRUPTNuiItemList
        }
    })
    exports["corruptui"]:sendMessage({
        app = "inventory",
        type = "INVENTORY_SET_SECONDARY",
    })
    exports["corruptui"]:sendMessage({
        app = "inventory",
        type = "INVENTORY_SET_GIVE_REQUEST",
        info = {
            players = nil,
            request = nil
        }
    })
    HoverTempID = nil
    userlist = {}
end
local Item_To_Give = nil
local Item_To_Give_Amount = nil
exports["corruptui"]:registerCallback("inventoryCommand", function(data)
    local event = data.command
    local item = data.selectedItemId
    local amount = data.moveAmount
    local selectedInventoryName = data.selectedInventoryName
    if lockInventorySoUserNoSpam then
        return
    end
    lockInventorySoUserNoSpam = true
    if selectedInventoryName == "Player" and event ~= "move" and event ~= "move_all" and event ~= "equip_all" and event ~= "loot_all" and event ~= "transfer_all" and event ~= "store_all" and event ~= "store" then
        if event == "use" then
            if item then
                TriggerServerEvent("CORRUPT:UseItem", item, "Plr", amount)
            else
                tvRP.notify("~r~No item selected!")
            end
        elseif event == "use_all" then
            if item then
                TriggerServerEvent("CORRUPT:UseAllItem", item, "Plr")
            else
                tvRP.notify("~r~No item selected!")
            end
        elseif event == "drop" or event == "drop_all" then
            if item then
                if selectedInventoryName ~= "Player" then
                    tvRP.notify("~r~You must have the item on your person to drop it!")
                else
                    TriggerServerEvent("CORRUPT:TrashItem" .. (event == "drop_all" and "AllNui" or "Nui"), item, "Plr", amount)
                end
            else
                tvRP.notify("~r~No item selected!")
            end
        elseif event == "give" or event == "give_all" then
            if item then
                if selectedInventoryName ~= "Player" then
                    tvRP.notify("~r~You must have the item on your person to give it!")
                else
                    if event == "give" then
                        Item_To_Give = item
                        Item_To_Give_Amount = amount
                        TriggerServerEvent("CORRUPT:RequestGive", item, amount)
                    elseif event == "give_all" then
                        TriggerServerEvent("CORRUPT:RequestGive", item, nil)
                    end
                end
            else
                tvRP.notify("~r~No item selected!")
            end
        end
    elseif event == "move" or event == "use" then
        if item then
            if g ~= nil and c and selectedInventoryName ~= "Boot" then
                if CORRUPT.isPurge() then
                    notify("~r~No items will be saved during a purge.")
                elseif tvRP.getPlayerCombatTimer() > 0 then
                    notify("~r~You can not store items whilst in combat.")
                else
                    if inventoryType == "CarBoot" then
                        TriggerServerEvent("CORRUPT:MoveItem", "Plr", item, r, false)
                    elseif inventoryType == "Housing" then
                        TriggerServerEvent("CORRUPT:MoveItem", "Plr", item, "home", false)
                    elseif inventoryType == "Crate" then
                        TriggerServerEvent("CORRUPT:MoveItem", "Plr", item, "crate", false)
                    elseif s then
                        TriggerServerEvent("CORRUPT:MoveItem", "Plr", item, "LootBag", true)
                    end
                end
            elseif g ~= nil and c and selectedInventoryName == "Boot" then
                if inventoryType == "CarBoot" then
                    TriggerServerEvent("CORRUPT:MoveItem", inventoryType, item, r, false)
                elseif inventoryType == "Housing" then
                    TriggerServerEvent("CORRUPT:MoveItem", inventoryType, item, "home", false)
                elseif inventoryType == "Crate" then
                    TriggerServerEvent("CORRUPT:MoveItem", inventoryType, item, "crate", false)
                else
                    TriggerServerEvent("CORRUPT:MoveItem", "LootBag", item, LootBagIDNew, true)
                end
            else
                tvRP.notify("~r~No item selected!")
            end
        else
            tvRP.notify("~r~No second inventory available!")
        end
    elseif event == "move_all" then
        if item then
            if selectedInventoryName ~= "Boot" then
                if CORRUPT.isPurge() then
                    notify("~r~You can not store items during a purge.")
                elseif tvRP.getPlayerCombatTimer() > 0 then
                    notify("~r~You can not store items whilst in combat.")
                else
                    if inventoryType == "CarBoot" then
                        TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", item, r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
                    elseif inventoryType == "Housing" then
                        TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", item, "home")
                    elseif inventoryType == "Crate" then
                        TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", item, "crate")
                    elseif s then
                        TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", item, "LootBag")
                    end
                end
            elseif selectedInventoryName == "Boot" then
                if inventoryType == "CarBoot" then
                    TriggerServerEvent("CORRUPT:MoveItemAll", inventoryType, item, r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
                elseif inventoryType == "Housing" then
                    TriggerServerEvent("CORRUPT:MoveItemAll", inventoryType, item, "home")
                elseif inventoryType == "Crate" then
                    TriggerServerEvent("CORRUPT:MoveItemAll", inventoryType, item, "crate")
                else
                    TriggerServerEvent("CORRUPT:MoveItemAll", "LootBag", item, LootBagIDNew)
                end
            else
                tvRP.notify("~r~No item selected!")
            end
        else
            tvRP.notify("~r~No second inventory available!")
        end
    elseif event == "equip_all" then
        TriggerServerEvent("CORRUPT:EquipAll")
    elseif event == "loot_all" then
        if inventoryType == "CarBoot" then
            TriggerServerEvent("CORRUPT:LootAll", inventoryType, r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
        elseif inventoryType == "Housing" then
            TriggerServerEvent("CORRUPT:LootAll", inventoryType, "home")
        elseif inventoryType == "Crate" then
            tvRP.notify("~r~You can not loot all from a crate.")
        else
            TriggerServerEvent("CORRUPT:LootAll", "LootBag", LootBagIDNew)
        end
    elseif event == "transfer_all" then
        if inventoryType == "CarBoot" then
            TriggerServerEvent("CORRUPT:TransferAll",r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
        elseif inventoryType == "Housing" then
            TriggerServerEvent("CORRUPT:TransferAll", "home")
        elseif inventoryType == "Crate" then
            TriggerServerEvent("CORRUPT:TransferAll", "crate")
        end
    elseif event == "give_result" then
        TriggerServerEvent("CORRUPT:GiveItemNui", data.selectedPermId, data.item, data.amount)
        exports["corruptui"]:sendMessage({
            app = "inventory",
            type = "INVENTORY_SET_GIVE_REQUEST",
            info = {
                players = nil,
                request = nil
            }
        })
        HoverTempID = nil
        userlist = {}
    elseif event == "store_all" then
        TriggerServerEvent("CORRUPT:StoreAllWeapons")
    elseif event == "store" then
        TriggerServerEvent("CORRUPT:forceStoreSingleWeapon", CORRUPT.getWeaponFromId(data.id).itemId)
    end

    Citizen.CreateThread(
        function()
            Wait(250)
            lockInventorySoUserNoSpam = false
        end
    )
end)

local userlist = {}
RegisterNetEvent("CORRUPT:OpenGiveNui", function(item, amount, user_list)
    if item and amount and user_list then
        userlist = user_list
        exports["corruptui"]:sendMessage({
            app = "inventory",
            type = "INVENTORY_SET_GIVE_REQUEST",
            info = {
                players = user_list,
                request = {
                    item = item,
                    amount = amount
                }
            }
        })
    end
end)

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if HoverTempID ~= nil then
                local H = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(HoverTempID)))
                DrawMarker(
                    2,
                    H.x,
                    H.y,
                    H.z + 1.1,
                    0.0,
                    0.0,
                    0.0,
                    0.0,
                    -180.0,
                    0.0,
                    0.4,
                    0.4,
                    0.4,
                    0,
                    120,
                    255,
                    200,
                    false,
                    true,
                    2,
                    false
                )
            end
        end
    end
)

exports["corruptui"]:registerCallback("onNearbyHover", function(data, cb)
    local permid = data.permId
    local enabled = data.enabled
    local tempid
    for k, v in pairs(userlist) do
        if v.permId == permid then
            tempid = v.source
            break
        end
    end
    if enabled then
        HoverTempID = tempid
    else
        HoverTempID = nil
    end
end)


RegisterNetEvent(
    "CORRUPT:FetchPersonalInventory",
    function(A, B, C)
        CORRUPT.RemakeTableForNUIInventory(A)
        CORRUPTItemList = A
        d = B
        currentInventoryMaxWeight = C
        exports["corruptui"]:sendMessage({
            app = "inventory",
            type = "INVENTORY_SET_PRIMARY",
            info = {
                currentMass = d,
                maximumMass = C,
                items = CORRUPTNuiItemList
            }
        })
        CORRUPT.SetUiCurrentWeapons(tvRP.getWeapons())
        if CORRUPTItemList["dirtycash"] then
            TriggerEvent("CORRUPT:setDisplayRedMoney", CORRUPTItemList["dirtycash"].amount)
        else
            TriggerEvent("CORRUPT:setDisplayRedMoney", 0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:SendSecondaryInventoryData",
    function(x, y, D, E)
        if E ~= nil then
            r = E
            inventoryType = "CarBoot"
        end
        CORRUPTSecondItemList = x
        e = D
        c = true
        CORRUPT.RemakeTableForNUIInventory(x, true)
        exports["corruptui"]:sendMessage({
            app = "inventory",
            type = "INVENTORY_SET_SECONDARY",
            info = {
                currentMass = y,
                maximumMass = D,
                items = CORRUPTNuiSecondItemList
            }
        })
        if CORRUPT.getLegacyInventory() then
            drawInventoryUI = true
            setCursor(1)
        else
            drawNewInventoryUI = true
            inGUICORRUPT = true
            exports["corruptui"]:sendMessage({
                app = "inventory",
                type = "APP_TOGGLE",
            })
            exports["corruptui"]:setFocus(true, true, true)
        end
        if D then
            g = D
            h = GetEntityCoords(CORRUPT.getPlayerPed())
            if D == "notmytrunk" then
                j = GetEntityCoords(CORRUPT.getPlayerPed())
            end
            if string.match(D, "player_") then
                l = string.gsub(D, "player_", "")
            else
                l = 0
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:closeToRestart",
    function(x)
        i = true
        Citizen.CreateThread(
            function()
                while true do
                    CORRUPT.clearInventory(true)
                    if drawNewInventoryUI then
                        drawNewInventoryUI = false
                        exports["corruptui"]:sendMessage({
                            app = "",
                            type = "APP_TOGGLE",
                        })
                        exports["corruptui"]:setFocus(false, false, false)
                    end
                    CORRUPTSecondItemList = {}
                    c = false
                    drawInventoryUI = false
                    setCursor(0)
                    Wait(50)
                end
            end
        )
    end
)
RegisterNetEvent(
    "CORRUPT:closeSecondaryInventory",
    function()
        CORRUPT.clearInventory(true)
        if drawNewInventoryUI then
            drawNewInventoryUI = false
            inGUICORRUPT = false
            exports["corruptui"]:sendMessage({
                app = "",
                type = "APP_TOGGLE",
            })
            exports["corruptui"]:setFocus(false, false, false)
        end
        CORRUPTSecondItemList = {}
        c = false
        s = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
    end
)
AddEventHandler(
    "CORRUPT:clCloseTrunk",
    function()
        c = false
        drawInventoryUI = false
        g = nil
        setCursor(0)
        f = nil
        inGUICORRUPT = false
        CORRUPTSecondItemList = {}
        CORRUPT.clearInventory(true)
        if drawNewInventoryUI then
            drawNewInventoryUI = false
            exports["corruptui"]:sendMessage({
                app = "",
                type = "APP_TOGGLE",
            })
            exports["corruptui"]:setFocus(false, false, false)
        end
    end
)
AddEventHandler(
    "CORRUPT:clOpenTrunk",
    function()  
        local F, G, H = tvRP.getNearestOwnedVehicle(3.5)
        r = G
        q = H
        if F and IsPedInAnyVehicle(GetPlayerPed(-1), false) == false then
            p = GetEntityCoords(PlayerPedId())
            tvRP.vc_openDoor(G, 5)
            inventoryType = "CarBoot"
            TriggerServerEvent("CORRUPT:FetchTrunkInventory", G)
        else
            tvRP.notify("~r~You don't have the keys to this vehicle!")
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if f ~= nil and c then
                local I = GetEntityCoords(CORRUPT.getPlayerPed())
                local J = GetEntityCoords(f)
                local K = #(I - J)
                if K > 10.0 then
                    TriggerEvent("CORRUPT:clCloseTrunk")
                    TriggerServerEvent("CORRUPT:closeChest")
                end
            end
            if g == "house" and c then
                local I = GetEntityCoords(CORRUPT.getPlayerPed())
                local J = h
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("CORRUPT:clCloseTrunk")
                    TriggerServerEvent("CORRUPT:closeChest")
                end
            end
            if g == "notmytrunk" and c then
                local I = GetEntityCoords(CORRUPT.getPlayerPed())
                local J = j
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("CORRUPT:clCloseTrunk")
                    TriggerServerEvent("CORRUPT:closeChest")
                end
            end
            if l ~= 0 and c then
                local I = GetEntityCoords(CORRUPT.getPlayerPed())
                local J = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(tonumber(l))))
                local K = #(I - J)
                if K > 5.0 then
                    TriggerEvent("CORRUPT:clCloseTrunk")
                    TriggerServerEvent("CORRUPT:closeChest")
                end
            end
            if f == nil and g == "trunk" then
                c = false
                if drawNewInventoryUI then
                    drawNewInventoryUI = false
                    exports["corruptui"]:sendMessage({
                        app = "",
                        type = "APP_TOGGLE",
                    })
                    exports["corruptui"]:setFocus(false, false, false)
                    isGUICORRUPT = false
                end
                drawInventoryUI = false
            end
            Wait(500)
        end
    end
)
local function L(M, N)
    local O = sortAlphabetically(M)
    local P = #O
    local Q = N * y
    local R = {}
    for S = Q + 1, math.min(Q + y, P) do
        table.insert(R, O[S])
    end
    return R
end
local itemlist = {["Dirty Cash"] = true}
local function G(a2, a3)
    if itemlist[a2] then
        return "£" .. getMoneyStringFormatted(a3)
    else
        return a3
    end
end
Citizen.CreateThread(
    function()
        while true do
            if drawInventoryUI then
                DrawRect(0.5, 0.53, 0.572, 0.508, 0, 0, 0, 150)
                DrawAdvancedText(
                    0.593,
                    0.235,
                    0.005,
                    0.0028,
                    0.66,
                    "CORRUPT INVENTORY",
                    255,
                    255,
                    255,
                    255,
                    CORRUPT.getFontId("Akrobat-ExtraBold"),
                    0
                )
                DrawRect(0.5, 0.24, 0.572, 0.058, 0, 0, 0, 225)
                DrawRect(0.342, 0.536, 0.215, 0.436, 0, 0, 0, 150)
                DrawRect(0.652, 0.537, 0.215, 0.436, 0, 0, 0, 150)
                if next(CORRUPTSecondItemList) then
                    DrawAdvancedText(0.664, 0.305, 0.005, 0.0028, 0.325, "Loot All", 255, 255, 255, 255, 6, 0)
                end
                if next(CORRUPTItemList) then
                    DrawAdvancedText(0.355, 0.305, 0.005, 0.0028, 0.325, "Equip All", 255, 255, 255, 255, 6, 0)
                end
                if next(CORRUPTItemList) and c then
                    if not s then
                        DrawAdvancedText(0.440, 0.305, 0.005, 0.0028, 0.325, "Transfer All", 255, 255, 255, 255, 6, 0)
                    end
                end
                if m then
                    DrawAdvancedText(0.575, 0.364, 0.005, 0.0028, 0.325, "Use", 255, 255, 255, 255, 6, 0)
                    DrawAdvancedText(0.615, 0.364, 0.005, 0.0028, 0.325, "Use All", 255, 255, 255, 255, 6, 0)
                else
                    DrawAdvancedText(0.594, 0.364, 0.005, 0.0028, 0.4, "Use", 255, 255, 255, 255, 6, 0)
                end
                DrawAdvancedText(0.575, 0.634, 0.005, 0.0028, 0.35, "Give X", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.615, 0.634, 0.005, 0.0028, 0.35, "Give All", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.594, 0.454, 0.005, 0.0028, 0.4, "Move", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.575, 0.545, 0.005, 0.0028, 0.325, "Move X", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.615, 0.545, 0.005, 0.0028, 0.325, "Move All", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.594, 0.722, 0.005, 0.0028, 0.4, "Trash", 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.488, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.404, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.521, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                DrawAdvancedText(0.833, 0.776, 0.005, 0.0028, 0.288, "[Press L to close]", 255, 255, 255, 255, 4, 0)
                DrawRect(0.5, 0.273, 0.572, 0.0069999999999999, 0, 120, 255, 150)
                DisableControlAction(0, 200, true)
                if table.count(CORRUPTItemList) > y then
                    DrawAdvancedText(0.528, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.412, 0.432, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        local T = math.floor(table.count(CORRUPTItemList) / y)
                        w = math.min(w + 1, T)
                    end
                    DrawAdvancedText(0.349, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                    if
                        CursorInArea(0.239, 0.269, 0.72, 0.76) and
                            (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                     then
                        w = math.max(w - 1, 0)
                    end
                end
                inGUICORRUPT = true
                if not c then
                    DrawAdvancedText(
                        0.751,
                        0.525,
                        0.005,
                        0.0028,
                        0.49,
                        "2nd Inventory not available",
                        255,
                        255,
                        255,
                        118,
                        6,
                        0
                    )
                elseif g ~= nil then
                    DrawAdvancedText(0.798, 0.335, 0.005, 0.0028, 0.366, "Amount", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.714, 0.335, 0.005, 0.0028, 0.366, "Item Name", 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(0.831, 0.335, 0.005, 0.0028, 0.366, "Weight", 255, 255, 255, 255, 4, 0)
                    local U = 0.026
                    local V = 0.026
                    local W = 0
                    local X = 0
                    for Y, Z in pairs(sortAlphabetically(CORRUPTSecondItemList)) do
                        X = X + Z["value"].amount * Z["value"].weight
                    end
                    local _ = L(CORRUPTSecondItemList, x)
                    if #_ == 0 then
                        x = 0
                    end
                    for Y, Z in pairs(_) do
                        local a0 = Z.title
                        local a1 = Z["value"]
                        local a2, a3, z = a1.name, a1.amount, a1.weight
                        DrawAdvancedText(0.714, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                        DrawAdvancedText(
                            0.831,
                            0.360 + W * V,
                            0.005,
                            0.0028,
                            0.366,
                            tostring(z * a3) .. "kg",
                            255,
                            255,
                            255,
                            255,
                            4,
                            0
                        )
                        DrawAdvancedText(0.798, 0.360 + W * V, 0.005, 0.0028, 0.366, G(a2, a3), 255, 255, 255, 255, 4, 0)
                        if CursorInArea(0.5443, 0.7584, 0.3435 + W * V, 0.3690 + W * V) then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, 0, 120, 255, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if not lockInventorySoUserNoSpam then
                                    b = a0
                                    a = false
                                    k = a3
                                    selectedItemWeight = z
                                    lockInventorySoUserNoSpam = true
                                    Citizen.CreateThread(
                                        function()
                                            Wait(250)
                                            lockInventorySoUserNoSpam = false
                                        end
                                    )
                                end
                            end
                        elseif a0 == b then
                            DrawRect(0.652, 0.331 + U * (W + 1), 0.215, 0.026, 0, 120, 255, 150)
                        end
                        W = W + 1
                    end
                    if X / e > 0.5 then
                        if X / e > 0.9 then
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                50,
                                0,
                                255,
                                4,
                                0
                            )
                        else
                            DrawAdvancedText(
                                0.826,
                                0.307,
                                0.005,
                                0.0028,
                                0.366,
                                "Weight: " .. X .. "/" .. e .. "kg",
                                255,
                                165,
                                0,
                                255,
                                4,
                                0
                            )
                        end
                    else
                        DrawAdvancedText(
                            0.826,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. e .. "kg",
                            255,
                            255,
                            153,
                            255,
                            4,
                            0
                        )
                    end
                    if table.count(CORRUPTSecondItemList) > y then
                        DrawAdvancedText(0.84, 0.742, 0.005, 0.0008, 0.4, "Next", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.735, 0.755, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            local T = math.floor(table.count(CORRUPTSecondItemList) / y)
                            x = math.min(x + 1, T)
                        end
                        DrawAdvancedText(0.661, 0.742, 0.005, 0.0008, 0.4, "Previous", 255, 255, 255, 255, 6, 0)
                        if
                            CursorInArea(0.55, 0.58, 0.72, 0.76) and
                                (IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329))
                         then
                            x = math.max(x - 1, 0)
                        end
                    end
                end
                if m then
                    if CursorInArea(0.46, 0.496, 0.33, 0.383) then
                        DrawRect(0.48, 0.359, 0.0375, 0.056, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("CORRUPT:UseItem", a, "Plr")
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.48, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                    if CursorInArea(0.501, 0.536, 0.329, 0.381) then
                        DrawRect(0.52, 0.359, 0.0375, 0.056, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("CORRUPT:UseAllItem", a, "Plr")
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.52, 0.359, 0.0375, 0.056, 0, 0, 0, 150)
                    end
                else
                    if CursorInArea(0.4598, 0.5333, 0.3283, 0.3848) then
                        DrawRect(0.5, 0.36, 0.075, 0.056, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if a then
                                    TriggerServerEvent("CORRUPT:UseItem", a, "Plr")
                                elseif b and g ~= nil and c then
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5, 0.36, 0.075, 0.056, 0, 0, 0, 150)
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.418, 0.4709) then
                    DrawRect(0.5, 0.45, 0.075, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if CORRUPT.isPurge() then
                                        notify("~r~No items will be saved during a purge.")
                                    end
                                    if tvRP.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("CORRUPT:MoveItem", "Plr", a, r, false)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("CORRUPT:MoveItem", "Plr", a, "home", false)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("CORRUPT:MoveItem", "Plr", a, "crate", false)
                                        elseif s then
                                            TriggerServerEvent("CORRUPT:MoveItem", "Plr", a, "LootBag", true)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("CORRUPT:MoveItem", inventoryType, b, r, false)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("CORRUPT:MoveItem", inventoryType, b, "home", false)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("CORRUPT:MoveItem", inventoryType, b, "crate", false)
                                    else
                                        TriggerServerEvent("CORRUPT:MoveItem", "LootBag", b, LootBagIDNew, true)
                                    end
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            else
                                tvRP.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.45, 0.075, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.4598, 0.498, 0.5042, 0.5666) then
                    DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        local a4 = tonumber(GetInvAmountText()) or 1
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    if CORRUPT.isPurge() then
                                        notify("~r~You can not store items during a purge.")
                                        return
                                    end
                                    if tvRP.getPlayerCombatTimer() > 0 then
                                        notify("~r~You can not store items whilst in combat.")
                                    else
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent("CORRUPT:MoveItemX", "Plr", a, r, false, a4)
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("CORRUPT:MoveItemX", "Plr", a, "home", false, a4)
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("CORRUPT:MoveItemX", "Plr", a, "crate", false, a4)
                                        elseif s then
                                            TriggerServerEvent("CORRUPT:MoveItemX", "Plr", a, "LootBag", true, a4)
                                        end
                                    end
                                elseif b and g ~= nil and c then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("CORRUPT:MoveItemX", inventoryType, b, r, false, a4)
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("CORRUPT:MoveItemX", inventoryType, b, "home", false, a4)
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("CORRUPT:MoveItemX", inventoryType, b, "crate", false, a4)
                                    else
                                        TriggerServerEvent("CORRUPT:MoveItemX", "LootBag", b, LootBagIDNew, true, a4)
                                    end
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            else
                                tvRP.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.48, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.5004, 0.5333, 0.5042, 0.5666) then
                    DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if c then
                                if a and g ~= nil and c then
                                    local L = CORRUPT.getSpaceInSecondChest()
                                    local a4 = k
                                    if k * selectedItemWeight > L then
                                        a4 = math.floor(L / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if CORRUPT.isPurge() then
                                            notify("~r~You can not store items during a purge.")
                                            return
                                        end
                                        if tvRP.getPlayerCombatTimer() > 0 then
                                            notify("~r~You can not store items whilst in combat.")
                                        else
                                            if inventoryType == "CarBoot" then
                                                TriggerServerEvent(
                                                    "CORRUPT:MoveItemAll",
                                                    "Plr",
                                                    a,
                                                    r,
                                                    NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3))
                                                )
                                            elseif inventoryType == "Housing" then
                                                TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", a, "home")
                                            elseif inventoryType == "Crate" then
                                                TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", a, "crate")
                                            elseif s then
                                                TriggerServerEvent("CORRUPT:MoveItemAll", "Plr", a, "LootBag")
                                            end
                                        end
                                    else
                                        tvRP.notify("~r~Not enough space in secondary chest!")
                                    end
                                elseif b and g ~= nil and c then
                                    local M = CORRUPT.getSpaceInFirstChest()
                                    local a4 = k
                                    if k * selectedItemWeight > M then
                                        a4 = math.floor(M / selectedItemWeight)
                                    end
                                    if a4 > 0 then
                                        if inventoryType == "CarBoot" then
                                            TriggerServerEvent(
                                                "CORRUPT:MoveItemAll",
                                                inventoryType,
                                                b,
                                                r,
                                                NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3))
                                            )
                                        elseif inventoryType == "Housing" then
                                            TriggerServerEvent("CORRUPT:MoveItemAll", inventoryType, b, "home")
                                        elseif inventoryType == "Crate" then
                                            TriggerServerEvent("CORRUPT:MoveItemAll", inventoryType, b, "crate")
                                        else
                                            TriggerServerEvent("CORRUPT:MoveItemAll", "LootBag", b, LootBagIDNew)
                                        end
                                    else
                                        tvRP.notify("~r~Not enough space in secondary chest!")
                                    end
                                else
                                    tvRP.notify("~r~No item selected!")
                                end
                            else
                                tvRP.notify("~r~No second inventory available!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.52, 0.54, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.4598, 0.498, 0.5931, 0.6477) then
                    DrawRect(0.48, 0.63, 0.0375, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("CORRUPT:GiveItem", a, "Plr")
                            else
                                tvRP.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.48, 0.63, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if CursorInArea(0.5004, 0.5333, 0.5931, 0.6477) then
                    DrawRect(0.52, 0.63, 0.0375, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("CORRUPT:GiveItemAll", a, "Plr")
                            else
                                tvRP.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.52, 0.63, 0.0375, 0.056, 0, 0, 0, 150)
                end
                if next(CORRUPTSecondItemList) then
                    if CursorInArea(0.5428, 0.5952, 0.2879, 0.3111) then
                        DrawRect(0.5695, 0.3, 0.05, 0.025, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                if inventoryType == "CarBoot" then
                                    TriggerServerEvent("CORRUPT:LootAll", inventoryType, r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
                                elseif inventoryType == "Housing" then
                                    TriggerServerEvent("CORRUPT:LootAll", inventoryType, "home")
                                elseif inventoryType == "Crate" then
                                    tvRP.notify("~r~You can not loot all from a crate.")
                                else
                                    TriggerServerEvent("CORRUPT:LootAll", "LootBag", LootBagIDNew)
                                end
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.5695, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if next(CORRUPTItemList) then
                    if CursorInArea(0.233854, 0.282813, 0.287037, 0.308333) then
                        DrawRect(0.2600, 0.3, 0.05, 0.025, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            if not lockInventorySoUserNoSpam then
                                TriggerServerEvent("CORRUPT:EquipAll")
                            end
                            lockInventorySoUserNoSpam = true
                            Citizen.CreateThread(
                                function()
                                    Wait(250)
                                    lockInventorySoUserNoSpam = false
                                end
                            )
                        end
                    else
                        DrawRect(0.2600, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                    end
                end
                if next(CORRUPTItemList) and c then
                    if not s then
                        if CursorInArea(0.322854, 0.371813, 0.287037, 0.308333) then
                            DrawRect(0.3460, 0.3, 0.05, 0.025, 0, 120, 255, 150)
                            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                                if not lockInventorySoUserNoSpam then
                                    if inventoryType == "CarBoot" then
                                        TriggerServerEvent("CORRUPT:TransferAll",r, NetworkGetNetworkIdFromEntity(tvRP.getNearestVehicle(3)))
                                    elseif inventoryType == "Housing" then
                                        TriggerServerEvent("CORRUPT:TransferAll", "home")
                                    elseif inventoryType == "Crate" then
                                        TriggerServerEvent("CORRUPT:TransferAll", "crate")
                                    end
                                end
                                lockInventorySoUserNoSpam = true
                                Citizen.CreateThread(
                                    function()
                                        Wait(250)
                                        lockInventorySoUserNoSpam = false
                                    end
                                )
                            end
                        else
                            DrawRect(0.3460, 0.3, 0.05, 0.025, 0, 0, 0, 150)
                        end
                    end
                end
                if CursorInArea(0.4598, 0.5333, 0.6831, 0.7377) then
                    DrawRect(0.5, 0.72, 0.075, 0.056, 0, 120, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if not lockInventorySoUserNoSpam then
                            if a then
                                TriggerServerEvent("CORRUPT:TrashItem", a, "Plr")
                            elseif b then
                                tvRP.notify("~r~Please move the item to your inventory to trash")
                            else
                                tvRP.notify("~r~No item selected!")
                            end
                        end
                        lockInventorySoUserNoSpam = true
                        Citizen.CreateThread(
                            function()
                                Wait(250)
                                lockInventorySoUserNoSpam = false
                            end
                        )
                    end
                else
                    DrawRect(0.5, 0.72, 0.075, 0.056, 0, 0, 0, 150)
                end
                local U = 0.026
                local V = 0.026
                local W = 0
                local X = 0
                local a5 = sortAlphabetically(CORRUPTItemList)
                for Y, Z in pairs(a5) do
                    local a0 = Z.title
                    local a1 = Z["value"]
                    local a2, a3, z = a1.name, a1.amount, a1.weight
                    X = X + a3 * z
                    DrawAdvancedText(0.404, 0.360 + W * V, 0.005, 0.0028, 0.366, a2, 255, 255, 255, 255, 4, 0)
                    DrawAdvancedText(
                        0.521,
                        0.360 + W * V,
                        0.005,
                        0.0028,
                        0.366,
                        tostring(z * a3) .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                    DrawAdvancedText(0.488, 0.360 + W * V, 0.005, 0.0028, 0.366, G(a2, a3), 255, 255, 255, 255, 4, 0)
                    if CursorInArea(0.2343, 0.4484, 0.3435 + W * V, 0.3690 + W * V) then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, 0, 120, 255, 150)
                        if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                            PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                            a = a0
                            if n[a] then
                                m = true
                            else
                                m = false
                            end
                            k = a3
                            selectedItemWeight = z
                            b = false
                        end
                    elseif a0 == a then
                        DrawRect(0.342, 0.331 + U * (W + 1), 0.215, 0.026, 0, 120, 255, 150)
                    end
                    W = W + 1
                end
                if X / currentInventoryMaxWeight > 0.5 then
                    if X / currentInventoryMaxWeight > 0.9 then
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            50,
                            0,
                            255,
                            4,
                            0
                        )
                    else
                        DrawAdvancedText(
                            0.516,
                            0.307,
                            0.005,
                            0.0028,
                            0.366,
                            "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                            255,
                            165,
                            0,
                            255,
                            4,
                            0
                        )
                    end
                else
                    DrawAdvancedText(
                        0.516,
                        0.307,
                        0.005,
                        0.0028,
                        0.366,
                        "Weight: " .. X .. "/" .. currentInventoryMaxWeight .. "kg",
                        255,
                        255,
                        255,
                        255,
                        4,
                        0
                    )
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if GetEntityHealth(CORRUPT.getPlayerPed()) <= 102 then
                CORRUPT.clearInventory(true)
                if drawNewInventoryUI then
                    drawNewInventoryUI = false
                    exports["corruptui"]:sendMessage({
                        app = "",
                        type = "APP_TOGGLE",
                    })
                    exports["corruptui"]:setFocus(false, false, false)
                end
                CORRUPTSecondItemList = {}
                c = false
                drawInventoryUI = false
                inGUICORRUPT = false
                setCursor(0)
            end
            Wait(50)
        end
    end
)
function GetInvAmountText()
    AddTextEntry("FMMC_MPM_NA", "Enter amount: (Blank to cancel)")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount: (Blank to cancel)", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local N = GetOnscreenKeyboardResult()
        return N
    end
    return nil
end
Citizen.CreateThread(function()
    while true do
        Wait(200)
        
        if p then
            if #(p - GetEntityCoords(PlayerPedId())) > 8.0 then
                drawInventoryUI = false
                tvRP.vc_closeDoor(q, 5)
                p = nil
                q = nil
                r = nil
                inventoryType = nil
            end
        end

        if drawInventoryUI then
            if tvRP.isInComa() or (inventoryType == "Crate" and GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `xs_prop_arena_crate_01a`, false, false, false) == 0) then
                TriggerEvent("CORRUPT:InventoryOpen", false)
                if p then
                    tvRP.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                end
            elseif s and (IsControlPressed(0, 323) or not IsEntityPlayingAnim(PlayerPedId(), "amb@medic@standing@tendtodead@base", "base", 3) or IsControlPressed(0, 137) or (lootbagtype == "bag" and GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `xs_prop_arena_bag_01`, false, false, false) == 0) or (lootbagtype == "trashbag" and GetClosestObjectOfType(GetEntityCoords(PlayerPedId()), 5.0, `ch_prop_ch_bag_01a`, false, false, false) == 0)) then
                TriggerEvent("CORRUPT:InventoryOpen", false)
                if p then
                    tvRP.vc_closeDoor(q, 5)
                    p = nil
                    q = nil
                    r = nil
                end
            end            
        end
    end
end)




function LoadAnimDict(a6)
    while not HasAnimDictLoaded(a6) do
        RequestAnimDict(a6)
        Citizen.Wait(5)
    end
end
RegisterNetEvent("CORRUPT:InventoryOpen")
AddEventHandler(
    "CORRUPT:InventoryOpen",
    function(a7, a8, a9, crate)
        if not crate then
            s = a8
            LootBagIDNew = a9
        end
        if a7 and not i then
            if CORRUPT.getLegacyInventory() then
                drawInventoryUI = true
                setCursor(1)
            else
                drawNewInventoryUI = true
                exports["corruptui"]:sendMessage({
                    app = "inventory",
                    type = "APP_TOGGLE",
                })
                exports["corruptui"]:setFocus(true, true, true)
            end
            inGUICORRUPT = true
        else
            lootbagtype = nil
            if drawNewInventoryUI then
                drawNewInventoryUI = false
                exports["corruptui"]:sendMessage({
                    app = "",
                    type = "APP_TOGGLE",
                })
                exports["corruptui"]:setFocus(false, false, false)
            end
            drawInventoryUI = false
            setCursor(0)
            CORRUPT.clearInventory(true)
            CORRUPTSecondItemList = {}
            inGUICORRUPT = false
            local aa = PlayerPedId()
            local X = GetEntityCoords(aa)
            ClearPedTasks(aa)
            ForcePedAiAndAnimationUpdate(aa, false, false)
            if CORRUPT.getPlayerVehicle() == 0 then
                SetEntityCoordsNoOffset(aa, X.x, X.y, X.z + 0.1, true, false, false)
            end
        end
    end
)



local lootbags = {}

RegisterNetEvent(
    "CORRUPT:createCashBag",
    function(b, c)
        local d = CORRUPT.loadModel("prop_poly_bag_money")
        local e = CreateObject(d, c.x, c.y, c.z, false, true, true)
        DecorSetInt(e, "lootid", b)
        PlaceObjectOnGroundProperly(e)
        SetModelAsNoLongerNeeded(d)
        lootbags[b] = e
        SetTimeout(
            600000,
            function()
                TriggerEvent("CORRUPT:removeLootbag", b)
            end
        )
    end
)

RegisterNetEvent('CORRUPT:floatInvBag', function(lootbagid)
    Wait(1000)
    local nettoobj = NetToObj(lootbagid) 
    SetObjectPhysicsParams(nettoobj, 10, 0, 0, 0, 0, 9.5, 0, 0, 0, 0, 75.0)
end)

RegisterNetEvent('CORRUPT:floatTrashBag', function(lootbagid)
    Wait(100)
    local nettoobj = NetToObj(lootbagid) 
    SetObjectPhysicsParams(nettoobj, 10, 0, 0, 0, 0, 9.5, 0, 0, 0, 0, 75.0)
    PlaceObjectOnGroundProperly(nettoobj)
end)

RegisterNetEvent(
    "CORRUPT:removeLootbag",
    function(b)
        local f = lootbags[b]
        if DoesEntityExist(f) then
            DeleteEntity(f)
            lootbags[b] = nil
        end
    end
)


AddEventHandler(
    "onResourceStop",
    function(g)
        if g == GetCurrentResourceName() then
            for h, i in pairs(lootbags) do
                DeleteObject(i)
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:playZipperSound",
    function(j)
        local k = GetEntityCoords(GetPlayerPed(-1))
        local l = #(k - j)
        if l <= 15 then
            local m = GetSoundId()
            PlaySoundFrontend(m, "Object_Collect_Player", "GTAO_FM_Events_Soundset", true)
            ReleaseSoundId(m)
        end
    end
)
