local cfg = module("cfg/cfg_guntrader")
local gunstores = module("cfg/gunstores")
local gunstoreTable = gunstores.GunStores
for k,v in pairs(gunstores.RebelWithAdvanced) do
    gunstoreTable["Rebel"][k] = v
end
local selectedGunstore = nil

RMenu.Add('GunTrader', 'main', RageUI.CreateMenu("", "",CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "banners", "gunstore"))
RMenu:Get("GunTrader", "main"):SetSubtitle("~b~CORRUPT Weapon Trader")
RMenu.Add("GunTrader", "guns",RageUI.CreateSubMenu(RMenu:Get("GunTrader", "main"),"","",CORRUPT.getRageUIMenuWidth(),CORRUPT.getRageUIMenuHeight()))


RageUI.CreateWhile(1.0,RMenu:Get("GunTrader", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("GunTrader", "main"),true,true,true,function()
        for k,v in pairs(gunstoreTable) do
            if cfg.sellableCategories[k] then
                for k2,v2 in pairs(v) do
                    if k2 == "_config" then
                        RageUI.ButtonWithStyle(v2[4], "Sell weapons bought from "..v2[4], {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                            if Selected then
                                selectedGunstore = k
                                RMenu:Get("GunTrader", "guns"):SetSubtitle("~b~"..v2[4].." Weapons")
                            end
                        end,RMenu:Get("GunTrader", "guns"))
                    end
                end
            end
        end
    end,function()end)
    RageUI.IsVisible(RMenu:Get("GunTrader", "guns"),true,true,true,function()
        for k,v in pairs(gunstoreTable) do
            if k == selectedGunstore then
                for k2,v2 in pairs(v) do
                    if k2 ~= "_config" then
                        local substrings = {"w_ex", "prop_", "p_", "w_me"}
                        local found = false
                        for _, s in ipairs(substrings) do
                            if string.find(v2[5], s) then
                                found = true
                                break
                            end
                        end
                        if not found then
                            local weaponPrice = v2[2]
                            if k == "LargeArmsDealer" then weaponPrice = v2[7] end
                            RageUI.ButtonWithStyle(v2[1], "Sell back for £"..getMoneyStringFormatted(weaponPrice*cfg.refundPercentage), {RightLabel = "→→→"}, true, function(Hovered, Active, Selected) 
                                if Selected then
                                    TriggerServerEvent("CORRUPT:gunTraderSell",k,k2)
                                end
                            end)
                        end
                    end
                end
            end
        end
    end,function()end)
end)

CreateThread(function()
    CORRUPT.createDynamicPed(cfg.pedModel,cfg.pedPosition,cfg.pedHeading,true,"mini@strip_club@idles@bouncer@base","base",75.0,nil,function(k)
        SetEntityCanBeDamaged(k, 0)
        SetPedAsEnemy(k, 0)
        SetBlockingOfNonTemporaryEvents(k, 1)
        SetPedResetFlag(k, 249, 1)
        SetPedConfigFlag(k, 185, true)
        SetPedConfigFlag(k, 108, true)
        SetPedCanEvasiveDive(k, 0)
        SetPedCanRagdollFromPlayerImpact(k, 0)
        SetPedConfigFlag(k, 208, true)
        SetEntityCollision(k, false)
        SetEntityCoordsNoOffset(k, cfg.pedPosition.x, cfg.pedPosition.y, cfg.pedPosition.z,cfg.pedHeading, 0, 0)
        SetEntityHeading(k, cfg.pedHeading)
        FreezeEntityPosition(k, true)
    end)
    local a9 = function(aa)
        RageUI.CloseAll()
        selectedGunstore = nil
        RageUI.Visible(RMenu:Get("GunTrader", "main"), true)
    end
    local ab = function(aa)
        RageUI.CloseAll()
        RageUI.Visible(RMenu:Get("GunTrader", "main"), false)
    end
    local ac = function(aa)
    end
    CORRUPT.createArea("weapontrader",cfg.location,1.5,6,a9,ab,ac,{})
    local af = cfg.location
    tvRP.addBlip(af.x, af.y, af.z, 160, 1, "Weapon Trader", 0.7, false)
    tvRP.addMarker(af.x,af.y,af.z,0.7,0.7,0.5,255,0,0,125,50,27,true)
    local blip = AddBlipForRadius(af.x, af.y, af.z, 35.0)
    SetBlipColour(blip, 44)
	SetBlipAlpha(blip, 180)
end)