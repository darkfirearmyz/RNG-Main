local cfg = module("cfg/cfg_kits")
local currentCooldown = 0
local selectedCategory = nil
local selectedWeapon = nil

RMenu.Add('kitsmenu', 'main', RageUI.CreateMenu("", "Kits", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight()))
RMenu.Add("kitsmenu", "weapons", RageUI.CreateSubMenu(RMenu:Get("kitsmenu", "main"), "", "Kits",CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight()))
RMenu.Add("kitsmenu", "confirm", RageUI.CreateSubMenu(RMenu:Get("kitsmenu", "main"), "", "Kits",CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight()))

RageUI.CreateWhile(1.0,RMenu:Get("kitsmenu", "main"),nil,function()
    RageUI.IsVisible(RMenu:Get("kitsmenu", "main"),true,true,true,function()
        if currentCooldown > 0 then
            RageUI.Separator("~r~Please wait " .. formatTimeString(formatTime(currentCooldown)) .. " before redeeming another kit.")
        else
            for _,v in pairs(cfg.kits) do
                RageUI.ButtonWithStyle(v.name,v.includes,{RightLabel=""},true,function(j,k,l)
                    if l then
                        selectedCategory = _
                    end
                end,RMenu:Get("kitsmenu","weapons"))
            end
        end
    end,function()end)
    RageUI.IsVisible(RMenu:Get("kitsmenu", "weapons"),true,true,true,function()
        RageUI.Separator("~g~"..cfg.kits[selectedCategory].name)
        RageUI.Separator("~g~Armour: "..cfg.kits[selectedCategory].armour.."%")
        for _,v in pairs(cfg.kits[selectedCategory].weapons) do
            RageUI.ButtonWithStyle(v.name,string.format("This weapon comes with %s ammo.", cfg.kits[selectedCategory].categoryAmmo),{},true,function(j,k,l)
                if l then
                    selectedWeapon = _
                end
            end,RMenu:Get("kitsmenu","confirm"))
        end
    end,function()end)
    RageUI.IsVisible(RMenu:Get("kitsmenu", "confirm"),true,true,true,function()
        RageUI.Separator("~r~Are you sure you want to redeem this kit?")
        RageUI.Separator("~r~Cooldown: "..formatTimeString(formatTime(cfg.kits[selectedCategory].cooldown*60)))
        RageUI.ButtonWithStyle("Yes","You will receive a cooldown for "..formatTimeString(formatTime(cfg.kits[selectedCategory].cooldown*60)).." after claiming this kit.",{},true,function(j,k,l)
            if l then
                TriggerServerEvent("cnr_kits:redeemKit",selectedCategory,selectedWeapon)
            end
        end, RMenu:Get("kitsmenu","main"))
        RageUI.ButtonWithStyle("No","",{},true,function(j,k,l)
            if l then
                selectedCategory = nil
            end
        end, RMenu:Get("kitsmenu","main"))
    end,function()end)
end)

RegisterNetEvent("cnr_kits:sendKitCooldowns", function(cooldown)
    currentCooldown = cooldown
end)

RegisterCommand("kit", function()
    TriggerServerEvent("cnr_kits:getKitCooldown")
    RageUI.Visible(RMenu:Get("kitsmenu", "main"), not RageUI.Visible(RMenu:Get("kitsmenu", "main")))
end)