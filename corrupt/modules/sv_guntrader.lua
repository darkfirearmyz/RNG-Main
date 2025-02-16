local guntraderEnabled = false
local day = tonumber(os.date("%d"))
local gunstores = module("cfg/gunstores")
local cfg = module("cfg/cfg_guntrader")
local weapons = module("corrupt-assets", "cfg/weapons")

for k,v in pairs(gunstores.RebelWithAdvanced) do
    gunstores.GunStores["Rebel"][k] = v
end

local function getWeaponRefundPrice(gunstore, weapon)
    for k,v in pairs(gunstores.GunStores) do
        if cfg.sellableCategories[k] and k == gunstore then
            if v[weapon] and weapon ~= "GADGET_PARACHUTE" then
                return v[weapon][2]*cfg.refundPercentage*grindBoost
            else
                return false
            end
        end
    end
end

local sellingGuns = {}
RegisterServerEvent("CORRUPT:gunTraderSell")
AddEventHandler("CORRUPT:gunTraderSell", function(gunstore, weapon)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local refundAmount = getWeaponRefundPrice(gunstore, weapon)
    if not guntraderEnabled then return CORRUPT.notify(source, {"~r~Sorry, I am not currently purchasing weapons."}) end
    if purgeActive then return CORRUPT.notify(source, {"~r~You cannot use this feature during a purge."}) end
    if not sellingGuns[source] then
        sellingGuns[source] = true
        if refundAmount then 
            vRPclient.getWeapons(source,{},function(weapons)
                if weapons[weapon] then
                    RemoveWeaponFromPed(GetPlayerPed(source), weapon)
                    CORRUPTclient.removeWeapon(source,{weapon})
                    CORRUPT.giveDirtyMoney(user_id, refundAmount)
                    CORRUPT.notify(source, {"~g~You sold your "..weapons.weapons[weapon].name.." for £"..getMoneyStringFormatted(refundAmount)})
                    TriggerClientEvent("CORRUPT:playItemBoughtSound", source)
                else
                    CORRUPT.notify(source, {"~r~Please equip the weapon you want to sell first."})
                end
            end)
        end
        sellingGuns[source] = nil
    end
end)