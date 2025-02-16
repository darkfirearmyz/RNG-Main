
local items = {}

local cocaine_sniff = {}
cocaine_sniff["Take"] = {function(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    if CORRUPT.tryGetInventoryItem(user_id,"Cocaine",1) then
      CORRUPTclient.notify(player,{"~g~Taking Cocaine."})
      TriggerEvent('CORRUPT:RefreshInventory', player)
      TriggerClientEvent('CORRUPT:cocaineEffect', player)
    end
  end
end}

local heroin_take = {}
heroin_take["Take"] = {function(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    if CORRUPT.tryGetInventoryItem(user_id,"Heroin",1) then
      CORRUPTclient.notify(player,{"~g~Taking Heroin."})
      TriggerEvent('CORRUPT:RefreshInventory', player)
      TriggerClientEvent('CORRUPT:heroinEffect', player)
    end
  end
end}


local lsd_take = {}
lsd_take["Take"] = {function(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    if CORRUPT.tryGetInventoryItem(user_id,"LSD",1) then
      CORRUPTclient.notify(player,{"~g~Taking LSD."})
      TriggerEvent('CORRUPT:RefreshInventory', player)
      TriggerClientEvent('CORRUPT:doAcid', player)
    end
  end
end}

local morphine_choices = {}
morphine_choices["Take"] = {function(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    if CORRUPT.tryGetInventoryItem(user_id,"morphine",1) then
      TriggerEvent('CORRUPT:RefreshInventory', player)
      TriggerClientEvent('CORRUPT:applyMorphine', player)
    end
  end
end}

local taco_choices = {}
taco_choices["Take"] = {function(player,choice)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    if CORRUPT.tryGetInventoryItem(user_id,"taco",1) then
      TriggerEvent('CORRUPT:RefreshInventory', player)
      TriggerClientEvent('CORRUPT:eatTaco', player)
    end
  end
end}

-- Drugs
items["Cocaine"] = {"Cocaine","Some Cocaine.",function(args) return cocaine_sniff end,4}
items["Heroin"] = {"Heroin","Some Heroin.",function(args) return heroin_take end,4}
items["LSD"] = {"LSD","Some LSD.",function(args) return lsd_take end,4}

-- Edibles
items["morphine"] = {"Morphine","Some Morphine.",function(args) return morphine_choices end,1}
items["taco"] = {"Taco","A Taco.",function(args) return taco_choices end,1}

return items
