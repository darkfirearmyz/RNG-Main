
local items = {}
local a = module("corrupt-assets", "cfg/weapons")
CORRUPTAmmoTypes = {
  [".357"] = {name = ".357 Bullets"},
  ["12gauge"] = {name = "12 Gauge Pellets"},
  ["5.56"] = {name = "5.56mm NATO"},
  ["7.62"] = {name = "7.62mm Bullets"},
  ["9mm"] = {name = "9mm Bullets"},
  [".308"] = {name = ".308 Sniper Rounds"},
  ["p5.56"] = {name = "Police Issued 5.56mm"},
  ["p9mm"] = {name = "Police Issued 9mm"},
  ["p.308"] = {name = "Police Issued .308 Sniper Rounds"},
  ["p12gauge"] = {name = "Police Issued 12 Gauge Pellets"}
}



items["truckingrepairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["transportrepairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["diyrepairkit"] = {"Repair Kit","Used to repair vehicles.",nil,0.5}
items["boltcutters"] = {"Bolt Cutters","Used break into houses.",nil,2.5}
items["headbag"] = {"Head Bag","Used to cover someone's head.",nil,0.5}
items["electric_shaver"] = {"Shaver","Used to shave someone's head.",nil,0.5}
items["keys"] = {"Handcuff Keys","Used to uncuff someone.",nil,0.5}
items["cuffs"] = {"Handcuff","Used to cuff someone.",nil,0.5}
items["lockpick"] = {"Lockpick","Used to lockpick vehicles.",nil,0.5}
items["rock"] = {"Rock","This Is Useless.",nil,0.5}
items["dirtycash"] = {"Dirty Cash", "",nil,0.0}
items["burner_phone"] = {"Burner Phone", "",nil,0.5}
items["hacking_device"] = {"Hacking Device", "This Is For Jewelry Hiest",nil,2.5}
items["sapphire"] = {"Sapphire", "",nil,0.5}
items["jewelry_necklace"] = {"Necklace", "",nil,0.5}
items["jewelry_watch"] = {"Watch", "",nil,0.5}
items["jewelry_ring"] = {"Ring", "",nil,0.5}
items["armourplate"] = {"Armour Plate","",nil,5}
items["pd_armourplate"] = {"Police Armour Plate","",nil,5}
items["civilian_radio"] = {"Civilian Radio", "Used for gang related purposes",nil,0.5}

local get_wname = function(weapon_id)
  for k,v in pairs(a.weapons) do
    if k == weapon_id then
      return v.name
    end
  end
end

--- weapon body
local wbody_name = function(args)
  return get_wname(args[2])
end

local wbody_desc = function(args)
  return ""
end

local wbody_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  choices["Equip"] = {function(player,choice)
    local user_id = CORRUPT.getUserId(player)
    if user_id ~= nil then
      if CORRUPT.tryGetInventoryItem(user_id, fullidname, 1, true) then
        local weapons = {}
        weapons[args[2]] = {ammo = 0}
        for k,v in pairs(a.weapons) do
          if k == args[2] then
            if v.policeWeapon then
              if CORRUPT.hasPermission(user_id, 'police.armoury') then
                CORRUPTclient.GiveWeaponsToPlayer(player, {weapons, false})
              else
                CORRUPTclient.notify(player, {'~r~You do not have permission to equip this weapon.'})
              end
            else
              CORRUPTclient.GiveWeaponsToPlayer(player, {weapons, false})
            end
          end
        end
      end
    end
  end}

  return choices
end

local wbody_weight = function(args)
  for k,v in pairs(a.weapons) do
    for c,d in pairs(args) do
      if k == d then
        if v.class == "Melee" then
          return 1.00
        elseif v.class == "Pistol" then
          return 5.00
        elseif v.class == "SMG" or v.class == "Shotgun" then
          return 7.50
        elseif v.class == "AR" then
          return 10.00
        elseif v.class == "Heavy" or v.class == "LMG" then
          return 15.00
        else
          return 1.00
        end
      end
    end
  end
end

items["wbody"] = {wbody_name,wbody_desc,wbody_choices,wbody_weight}

--- weapon ammo
local get_wammo_wname = function(ammo)
  for k,v in pairs(CORRUPTAmmoTypes) do
    if k == ammo then
      return v.name
    end
  end
end

local wammo_name = function(args)
  return get_wammo_wname(args[1])
end

local wammo_desc = function(args)
  return ""
end

local wammo_choices = function(args)
  local choices = {}
  local fullidname = joinStrings(args,"|")
  local ammotype = nil;
  ammotype = args[1]
  choices["Load"] = {
    function(player,amount)
      local user_id = CORRUPT.getUserId(player)
      if user_id ~= nil then
        local totalamount = CORRUPT.getInventoryItemAmount(user_id, fullidname)
        if string.find(fullidname, "Police") and not CORRUPT.hasPermission(user_id, 'police.armoury') then
          CORRUPTclient.notify(player, {'~r~You do not have permission to load this ammo.'})
          local bulletAmount = CORRUPT.getInventoryItemAmount(user_id, fullidname)
          CORRUPT.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
          return
        end
        if amount == nil then 
          CORRUPT.prompt(player, "Amount to load ? (max "..totalamount..")", "", function(player,rcorruptunt)
            rcorruptunt = parseInt(rcorruptunt)
            CORRUPTclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
              for k,v in pairs(a.weapons) do -- goes through new weapons cfg
                for c,d in pairs(uweapons) do -- goes through current weapons
                  if k == c then  -- if weapon in new cfg is the same as in current weapons
                    if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                      if CORRUPT.tryGetInventoryItem(user_id, fullidname, rcorruptunt, true) then -- take ammo from inv
                        local weapons = {}
                        weapons[k] = {ammo = rcorruptunt}
                        CORRUPTclient.GiveWeaponsToPlayer(player, {weapons,false})
                        TriggerEvent('CORRUPT:RefreshInventory', player)
                        return
                      end
                    end
                  end
                end
              end
            end)
          end)
        else
          amount = parseInt(amount)
          CORRUPTclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
            for k,v in pairs(a.weapons) do -- goes through new weapons cfg
              for c,d in pairs(uweapons) do -- goes through current weapons
                if k == c then  -- if weapon in new cfg is the same as in current weapons
                  if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                    if CORRUPT.tryGetInventoryItem(user_id, fullidname, amount, true) then -- take ammo from inv
                      local weapons = {}
                      weapons[k] = {ammo = amount}
                      CORRUPTclient.GiveWeaponsToPlayer(player, {weapons,false})
                      TriggerEvent('CORRUPT:RefreshInventory', player)
                      return
                    end
                  end
                end
              end
            end
          end)
        end
      end
    end
  }

  choices["LoadAll"] = {
    function(player,choice)
      local user_id = CORRUPT.getUserId(player)
      if user_id ~= nil then
        rcorruptunt = parseInt(CORRUPT.getInventoryItemAmount(user_id, fullidname))
        if rcorruptunt > 250 then rcorruptunt = 250 end
        if string.find(fullidname, "Police") and not CORRUPT.hasPermission(user_id, 'police.armoury') then
          CORRUPTclient.notify(player, {'~r~You do not have permission to load this ammo.'})
          local bulletAmount = CORRUPT.getInventoryItemAmount(user_id, fullidname)
          CORRUPT.tryGetInventoryItem(user_id, fullidname, bulletAmount, false)
          return
        end
        CORRUPTclient.getWeapons(player, {}, function(uweapons) -- gets current weapons
          for k,v in pairs(a.weapons) do -- goes through new weapons cfg
            for c,d in pairs(uweapons) do -- goes through current weapons
              if k == c then  -- if weapon in new cfg is the same as in current weapons
                if fullidname == v.ammo then -- check if ammo being loaded is the same as the ammo for that gun
                  if CORRUPT.tryGetInventoryItem(user_id, fullidname, rcorruptunt, true) then -- take ammo from inv
                    local weapons = {}
                    weapons[k] = {ammo = rcorruptunt}
                    CORRUPTclient.GiveWeaponsToPlayer(player, {weapons,false})
                    TriggerEvent('CORRUPT:RefreshInventory', player)
                    return
                  end
                end
              end
            end
          end
        end)
      end
    end
  }
  return choices
end

local wammo_weight = function(args)
  return 0.01
end

for i,v in pairs(CORRUPTAmmoTypes) do
  items[i] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}
end

items["wammo"] = {wammo_name,wammo_desc,wammo_choices,wammo_weight}

return items
