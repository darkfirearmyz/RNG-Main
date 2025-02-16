local lang = CORRUPT.lang
local cfg = module("corrupt-assets", "cfg/cfg_inventory")

-- this module define the player inventory (lost after respawn, as wallet)

CORRUPT.items = {}

function CORRUPT.defInventoryItem(idname,name,description,choices,weight)
  if weight == nil then
    weight = 0
  end
  local item = {name=name,description=description,choices=choices,weight=weight}
  CORRUPT.items[idname] = item
  item.ch_give = function(player)
  end
  item.ch_giveall = function(player)
  end
  item.ch_trash = function(idname,player)
  end
end


function ch_give(idname, player)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    CORRUPTclient.getNearestPlayers(player, {10}, function(nplayers) 
      local numPlayers = 0
      local nplayerId = nil
      for k, v in pairs(nplayers) do
        numPlayers = numPlayers + 1
        nplayerId = k
      end

      if numPlayers == 1 then
        CORRUPT.prompt(player, lang.inventory.give.prompt({CORRUPT.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
          local amount = parseInt(amount)
          local nplayer = nplayerId
          local nuser_id = CORRUPT.getUserId(nplayer)

          if nuser_id ~= nil then
            local itemAmount = CORRUPT.getInventoryItemAmount(user_id, idname)
            local inventoryWeight = CORRUPT.getInventoryWeight(nuser_id)
            local itemWeight = CORRUPT.getItemWeight(idname)
            local newWeight = inventoryWeight + itemWeight * amount
            if newWeight <= CORRUPT.getInventoryMaxWeight(nuser_id) then
              if CORRUPT.tryGetInventoryItem(user_id, idname, amount, true) then
                CORRUPT.giveInventoryItem(nuser_id, idname, amount, true)
                TriggerEvent('CORRUPT:RefreshInventory', player)
                TriggerEvent('CORRUPT:RefreshInventory', nplayer)
                CORRUPTclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
                CORRUPTclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
              else
                CORRUPT.notify(player, { lang.common.invalid_value() })
              end
            else
              CORRUPT.notify(player, { lang.inventory.full() })
            end
          else
            CORRUPT.notify(player, { 'Invalid Temp ID.' })
          end
        end)
      elseif numPlayers > 1 then
        usrList = ""
        for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. CORRUPT.getPlayerName(k) .. " | "
        end

        CORRUPT.prompt(player, "Players Nearby: " .. usrList, "", function(player, nplayer)
          nplayer = nplayer
          if nplayer ~= nil and nplayer ~= "" then
            local selectedPlayerId = tonumber(nplayer)
            if nplayers[selectedPlayerId] then
                CORRUPT.prompt(player, lang.inventory.give.prompt({CORRUPT.getInventoryItemAmount(user_id, idname)}), "", function(player, amount)
                local amount = parseInt(amount)
                local nplayer = selectedPlayerId
                local nuser_id = CORRUPT.getUserId(nplayer)
                if nuser_id ~= nil then
                  local itemAmount = CORRUPT.getInventoryItemAmount(user_id, idname)
                  local inventoryWeight = CORRUPT.getInventoryWeight(nuser_id)
                  local itemWeight = CORRUPT.getItemWeight(idname)
                  local newWeight = inventoryWeight + itemWeight * amount
                  if newWeight <= CORRUPT.getInventoryMaxWeight(nuser_id) then
                    if CORRUPT.tryGetInventoryItem(user_id, idname, amount, true) then
                      CORRUPT.giveInventoryItem(nuser_id, idname, amount, true)
                      TriggerEvent('CORRUPT:RefreshInventory', player)
                      TriggerEvent('CORRUPT:RefreshInventory', nplayer)
                      CORRUPTclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
                      CORRUPTclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
                    else
                      CORRUPT.notify(player, { lang.common.invalid_value() })
                    end
                  else
                    CORRUPT.notify(player, { lang.inventory.full() })
                  end
                else
                  CORRUPT.notify(player, { 'Invalid Temp ID.' })
                end
              end)
            else
              CORRUPT.notify(player, { 'Invalid Temp ID.' })
            end
          else
            CORRUPT.notify(player, { lang.common.no_player_near() })
          end
        end)
      else
        CORRUPT.notify(player, { "~r~No players nearby!" })
      end
    end)
  end
end
function ch_giveall(idname, player)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    CORRUPTclient.getNearestPlayers(player, {10}, function(nplayers)
      local numPlayers = 0
      local nplayerId = nil
      for k, v in pairs(nplayers) do
        numPlayers = numPlayers + 1
        nplayerId = k
      end

      if numPlayers == 1 then
        local amount = parseInt(CORRUPT.getInventoryItemAmount(user_id, idname))
        local nplayer = nplayerId
        local nuser_id = CORRUPT.getUserId(nplayer)

        if nuser_id ~= nil then
          local itemAmount = CORRUPT.getInventoryItemAmount(user_id, idname)
          local inventoryWeight = CORRUPT.getInventoryWeight(nuser_id)
          local itemWeight = CORRUPT.getItemWeight(idname)
          local newWeight = inventoryWeight + itemWeight * amount

          if newWeight <= CORRUPT.getInventoryMaxWeight(nuser_id) then
            if CORRUPT.tryGetInventoryItem(user_id, idname, amount, true) then
              CORRUPT.giveInventoryItem(nuser_id, idname, amount, true)
              TriggerEvent('CORRUPT:RefreshInventory', player)
              TriggerEvent('CORRUPT:RefreshInventory', nplayer)
              CORRUPTclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
              CORRUPTclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
            else
              CORRUPT.notify(player, { lang.common.invalid_value() })
            end
          else
            CORRUPT.notify(player, { lang.inventory.full() })
          end
        else
          CORRUPT.notify(player, { 'Invalid Temp ID.' })
        end
      elseif numPlayers > 1 then
        -- If there are multiple players nearby, show the player list
        usrList = ""
        for k, v in pairs(nplayers) do
          usrList = usrList .. "[" .. k .. "]" .. CORRUPT.getPlayerName(k) .. " | "
        end

        CORRUPT.prompt(player, "Players Nearby: " .. usrList, "", function(player, nplayer)
          nplayer = nplayer
          if nplayer ~= nil and nplayer ~= "" then
            local selectedPlayerId = tonumber(nplayer)
            if nplayers[selectedPlayerId] then
                local amount = parseInt(CORRUPT.getInventoryItemAmount(user_id, idname))
                local nplayer = selectedPlayerId
                local nuser_id = CORRUPT.getUserId(nplayer)

                if nuser_id ~= nil then
                  local itemAmount = CORRUPT.getInventoryItemAmount(user_id, idname)
                  local inventoryWeight = CORRUPT.getInventoryWeight(nuser_id)
                  local itemWeight = CORRUPT.getItemWeight(idname)
                  local newWeight = inventoryWeight + itemWeight * amount
                  if newWeight <= CORRUPT.getInventoryMaxWeight(nuser_id) then
                    if CORRUPT.tryGetInventoryItem(user_id, idname, amount, true) then
                      CORRUPT.giveInventoryItem(nuser_id, idname, amount, true)
                      TriggerEvent('CORRUPT:RefreshInventory', player)
                      TriggerEvent('CORRUPT:RefreshInventory', nplayer)
                      CORRUPTclient.playAnim(player, { true, { { "mp_common", "givetake1_a", 1 } }, false })
                      CORRUPTclient.playAnim(nplayer, { true, { { "mp_common", "givetake2_a", 1 } }, false })
                    else
                      CORRUPT.notify(player, { lang.common.invalid_value() })
                    end
                  else
                    CORRUPT.notify(player, { lang.inventory.full() })
                  end
                else
                  CORRUPT.notify(player, { 'Invalid Temp ID.' })
                end
            else
              CORRUPT.notify(player, { 'Invalid Temp ID.' })
            end
          else
            CORRUPT.notify(player, { lang.common.no_player_near() })
          end
        end)
      else
        CORRUPT.notify(player, { "~r~No players nearby!" }) --no players nearby
      end
    end)
  end
end

-- trash action
function ch_trash(idname, player)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    if CORRUPT.getInventoryItemAmount(user_id,idname) > 1 then 
      CORRUPT.prompt(player,lang.inventory.trash.prompt({CORRUPT.getInventoryItemAmount(user_id,idname)}),"",function(player,amount)
        local amount = parseInt(amount)
        if CORRUPT.tryGetInventoryItem(user_id,idname,amount,false) then
          TriggerEvent('CORRUPT:RefreshInventory', player)
          CORRUPT.TrashLootBag(idname, amount, player)
          CORRUPT.notify(player,{lang.inventory.trash.done({CORRUPT.getItemName(idname),amount})})
          CORRUPTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
        else
          CORRUPT.notify(player,{lang.common.invalid_value()})
        end
      end)
    else
      if CORRUPT.tryGetInventoryItem(user_id,idname,1,false) then
        TriggerEvent('CORRUPT:RefreshInventory', player)
        CORRUPT.TrashLootBag(idname, 1, player)
        CORRUPT.notify(player,{lang.inventory.trash.done({CORRUPT.getItemName(idname),1})})
        CORRUPTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
      else
        CORRUPT.notify(player,{lang.common.invalid_value()})
      end
    end
  end
end
function ch_trashall(idname, player)
  local user_id = CORRUPT.getUserId(player)
  if user_id ~= nil then
    -- prompt number
    local amount = CORRUPT.getInventoryItemAmount(user_id, idname)
    if CORRUPT.tryGetInventoryItem(user_id,idname,amount,false) then
      TriggerEvent('CORRUPT:RefreshInventory', player)
      CORRUPT.TrashLootBag(idname, amount, player)
      CORRUPT.notify(player,{lang.inventory.trash.done({CORRUPT.getItemName(idname),amount})})
      CORRUPTclient.playAnim(player,{true,{{"pickup_object","pickup_low",1}},false})
    else
      CORRUPT.notify(player,{lang.common.invalid_value()})
    end
  end
end

function CORRUPT.computeItemName(item,args)
  if type(item.name) == "string" then return item.name
  else return item.name(args) end
end

function CORRUPT.computeItemDescription(item,args)
  if type(item.description) == "string" then return item.description
  else return item.description(args) end
end

function CORRUPT.computeItemChoices(item,args)
  if item.choices ~= nil then
    return item.choices(args)
  else
    return {}
  end
end

function CORRUPT.computeItemWeight(item,args)
  if type(item.weight) == "number" then return item.weight
  else return item.weight(args) end
end


function CORRUPT.parseItem(idname)
  return splitString(idname,"|")
end

-- return name, description, weight
function CORRUPT.getItemDefinition(idname)
  local args = CORRUPT.parseItem(idname)
  local item = CORRUPT.items[args[1]]
  if item ~= nil then
    return CORRUPT.computeItemName(item,args), CORRUPT.computeItemDescription(item,args), CORRUPT.computeItemWeight(item,args)
  end

  return nil,nil,nil
end

function CORRUPT.getItemName(idname)
  local args = CORRUPT.parseItem(idname)
  local item = CORRUPT.items[args[1]]
  if item ~= nil then return CORRUPT.computeItemName(item,args) end
  return args[1]
end

function CORRUPT.getItemDescription(idname)
  local args = CORRUPT.parseItem(idname)
  local item = CORRUPT.items[args[1]]
  if item ~= nil then return CORRUPT.computeItemDescription(item,args) end
  return ""
end

function CORRUPT.getItemChoices(idname, player)
  local args = CORRUPT.parseItem(idname)
  local item = CORRUPT.items[args[1]]
  local choices = {}
  if item ~= nil then
    -- compute choices
    local cchoices = CORRUPT.computeItemChoices(item,args)
    if cchoices then
      for k,v in pairs(cchoices) do
        choices[k] = v
      end
    end
    choices["TrashAll"] = {function(player) ch_trashall(idname, player) end, "Drops All item."}
    choices["GiveAll"] = {function(player) ch_giveall(idname, player) end, "Gives All items to the nearest player."}
    choices[lang.inventory.give.title()] = {function(player) ch_give(idname, player) end, lang.inventory.give.description()}
    choices["Trash"] = {function(player) ch_trash(idname, player) end, "Drops item."}
  end

  return choices
end
function CORRUPT.getItemWeight(idname)
  local args = CORRUPT.parseItem(idname)
  local item = CORRUPT.items[args[1]]
  if item ~= nil then return CORRUPT.computeItemWeight(item,args) end
  return 1
end
function CORRUPT.computeItemsWeight(items)
  local weight = 0

  for k,v in pairs(items) do
    local iweight = CORRUPT.getItemWeight(k)
    if iweight ~= nil then
      weight = weight+iweight*v.amount
    end
  end

  return weight
end
function CORRUPT.giveInventoryItem(user_id,idname,amount,notify)
  local player = CORRUPT.getUserSource(user_id)
  if notify == nil then notify = true end

  local data = CORRUPT.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry then -- add to entry
      entry.amount = entry.amount+amount
    else -- new entry
      data.inventory[idname] = {amount=amount}
    end

    -- notify
    if notify then
      local player = CORRUPT.getUserSource(user_id)
      if player ~= nil then
        CORRUPT.notify(player,{lang.inventory.give.received({CORRUPT.getItemName(idname),amount})})
      end
    end
  end
  TriggerEvent('CORRUPT:RefreshInventory', player)
end

function CORRUPT.RunTrashTask(source, itemName)
    local choices = CORRUPT.getItemChoices(itemName, source)
    if choices['Trash'] then
        choices['Trash'][1](source)
    else 
        local user_id = CORRUPT.getUserId(source)
        local data = CORRUPT.getUserDataTable(user_id)
        data.inventory[itemName] = nil;
    end
    TriggerEvent('CORRUPT:RefreshInventory', source)
end
function CORRUPT.RunTrashAllTask(source, itemName)
  local choices = CORRUPT.getItemChoices(itemName, source)
  if choices['TrashAll'] then
      choices['TrashAll'][1](source)
  else 
      local user_id = CORRUPT.getUserId(source)
      local data = CORRUPT.getUserDataTable(user_id)
      data.inventory[itemName] = nil;
  end
  TriggerEvent('CORRUPT:RefreshInventory', source)
end


function CORRUPT.RunGiveTask(source, itemName)
    local choices = CORRUPT.getItemChoices(itemName, source)
    if choices['Give'] then
        choices['Give'][1](source)
    end
    TriggerEvent('CORRUPT:RefreshInventory', source)
end
function CORRUPT.RunGiveAllTask(source, itemName)
  local choices = CORRUPT.getItemChoices(itemName, source)
  if choices['GiveAll'] then
      choices['GiveAll'][1](source)
  end
  TriggerEvent('CORRUPT:RefreshInventory', source)
end

function CORRUPT.RunInventoryTask(source, itemName, amount)
    local choices = CORRUPT.getItemChoices(itemName, source, amount)
    if choices['Use'] then 
        choices['Use'][1](source, amount)
    elseif choices['Drink'] then
        choices['Drink'][1](source)
    elseif choices['Load'] then
        choices['Load'][1](source, amount)
    elseif choices['Eat'] then
        choices['Eat'][1](source)
    elseif choices['Equip'] then 
        choices['Equip'][1](source, amount)
    elseif choices['Take'] then 
        choices['Take'][1](source)
    end
    TriggerEvent('CORRUPT:RefreshInventory', source)
end

function CORRUPT.LoadAllTask(source, itemName)
  local choices = CORRUPT.getItemChoices(itemName, source)
  choices['LoadAll'][1](source)
  TriggerEvent('CORRUPT:RefreshInventory', source)
end

function CORRUPT.EquipTask(source, itemName)
  local choices = CORRUPT.getItemChoices(itemName, source)
  choices['Equip'][1](source)
  TriggerEvent('CORRUPT:RefreshInventory', source)
end

-- try to get item from a connected user inventory
function CORRUPT.tryGetInventoryItem(user_id,idname,amount,notify)
  if notify == nil then notify = true end -- notify by default
  local player = CORRUPT.getUserSource(user_id)

  local data = CORRUPT.getUserDataTable(user_id)
  if data and amount > 0 then
    local entry = data.inventory[idname]
    if entry and entry.amount >= amount then -- add to entry
      entry.amount = entry.amount-amount

      -- remove entry if <= 0
      if entry.amount <= 0 then
        data.inventory[idname] = nil 
      end

      -- notify
      if notify then
        local player = CORRUPT.getUserSource(user_id)
        if player ~= nil then
          CORRUPT.notify(player,{lang.inventory.give.given({CORRUPT.getItemName(idname),amount})})
      
        end
      end
      TriggerEvent('CORRUPT:RefreshInventory', player)
      return true
    else
      -- notify
      if notify then
        local player = CORRUPT.getUserSource(user_id)
        if player ~= nil then
          local entry_corruptunt = 0
          if entry then entry_corruptunt = entry.amount end
          CORRUPT.notify(player,{lang.inventory.missing({CORRUPT.getItemName(idname),amount-entry_corruptunt})})
        end
      end
    end
  end

  return false
end

-- get user inventory amount of item
function CORRUPT.getInventoryItemAmount(user_id,idname)
  local data = CORRUPT.getUserDataTable(user_id)
  if data and data.inventory then
    local entry = data.inventory[idname]
    if entry then
      return entry.amount
    end
  end

  return 0
end

-- return user inventory total weight
function CORRUPT.getInventoryWeight(user_id)
  local data = CORRUPT.getUserDataTable(user_id)
  if data and data.inventory then
    return CORRUPT.computeItemsWeight(data.inventory)
  end
  return 0
end

function CORRUPT.getInventoryMaxWeight(user_id)
  local data = CORRUPT.getUserDataTable(user_id)
  if data.invcap ~= nil then
    return data.invcap
  end
  return 30
end


-- clear connected user inventory
function CORRUPT.clearInventory(user_id)
  local data = CORRUPT.getUserDataTable(user_id)
  if data then
    data.inventory = {}
  end
end


AddEventHandler("CORRUPT:playerJoin", function(user_id,source,name,last_login)
  local data = CORRUPT.getUserDataTable(user_id)
  if data.inventory == nil then
    data.inventory = {}
  end
end)


RegisterCommand("storebackpack", function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  local data = CORRUPT.getUserDataTable(user_id)

  CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
      if cb then
          local invcap = 30
          if CORRUPT.isDeveloper(user_id) then
              invcap = 1000
          end
      elseif plathours > 0 then
          invcap = invcap + 20
      elseif plushours > 0 then
          invcap = invcap + 10
      end

      if invcap == 30 then
          CORRUPT.notify(source, {"You do not have a backpack equipped."})
          return
      end

      if data.invcap - 15 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Off White Bag (+15kg)", 1, false)
      elseif data.invcap - 20 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Gucci Bag (+20kg)", 1, false)
      elseif data.invcap - 30 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Nike Bag (+30kg)", 1, false)
      elseif data.invcap - 35 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Hunting Backpack (+35kg)", 1, false)
      elseif data.invcap - 40 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Green Hiking Backpack (+40kg)", 1, false)
      elseif data.invcap - 70 == invcap then
          CORRUPT.giveInventoryItem(user_id, "Rebel Backpack (+70kg)", 1, false)
      end

      CORRUPT.updateInvCap(user_id, invcap)
      CORRUPT.notify(source, {"~g~Backpack Stored"})
      TriggerClientEvent('CORRUPT:removeBackpack', source)
  end)

  if not cb and CORRUPT.getInventoryWeight(user_id) + 5 > CORRUPT.getInventoryMaxWeight(user_id) then
      CORRUPT.notify(source, {"You do not have enough room to store your backpack"})
  end
end)
