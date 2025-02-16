
-- this module define some police tools and functions
local lang = CORRUPT.lang
local a = module("corrupt-assets", "cfg/weapons")
function CORRUPT.notify(source, message)
  if type(message) == "table" then
    message = table.unpack(message)
  end
  TriggerClientEvent("CORRUPT:Notify", source, message)
end
local isStoring = {}

local choice_store_weapons = function(source)
    if CORRUPT.inWager(source) then return end
    local user_id = CORRUPT.getUserId(source)
    local data = CORRUPT.getUserDataTable(user_id)
    CORRUPTclient.getWeapons(source, {}, function(weapons)
        if not isStoring[source] then
            CORRUPT.getSubscriptions(user_id, function(cb, plushours, plathours)
                if cb then
                    local maxWeight = 30
                    if CORRUPT.isDeveloper(user_id) then
                        maxWeight = 1000
                    elseif plathours > 0 then
                        maxWeight = 50
                    elseif plushours > 0 then
                        maxWeight = 40
                    end
                    if CORRUPT.getInventoryWeight(user_id) <= maxWeight then
                        isStoring[source] = true
                        CORRUPTclient.GiveWeaponsToPlayer(source, {{}, true}, function(removedwep)
                            for k, v in pairs(weapons) do
                                if k ~= 'GADGET_PARACHUTE' and k ~= 'WEAPON_STAFFGUN' and k ~= 'WEAPON_SMOKEGRENADE' and k ~= 'WEAPON_FLASHBANG' then
                                    CORRUPT.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                                    if v.ammo > 0 and k ~= 'WEAPON_STUNGUN' then
                                        for i, c in pairs(a.weapons) do
                                            if i == k and c.class ~= 'Melee' then
                                                if v.ammo > 250 then
                                                    v.ammo = 250
                                                end
                                                CORRUPT.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                                            end
                                        end
                                    end
                                end
                            end
                            TriggerEvent('CORRUPT:RefreshInventory', source)
                            data.weapons = {}
                            SetTimeout(3000, function()
                                isStoring[source] = nil
                            end)
                        end)
                    else
                      CORRUPT.notify(source, {'~r~You do not have enough Weight to store Weapons.'})
                    end
                end
            end)
        end
    end)
end

local cooldowns = {}

RegisterServerEvent("CORRUPT:forceStoreSingleWeapon")
AddEventHandler("CORRUPT:forceStoreSingleWeapon", function(model)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local currentTime = os.time()
    if CORRUPT.inWager(source) then return end
    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        CORRUPT.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        cooldowns[source] = currentTime

        if model ~= nil then
            CORRUPTclient.getWeapons(source, {}, function(weapons)
                for k, v in pairs(weapons) do
                    if k == model then
                        local new_weight = CORRUPT.getInventoryWeight(user_id) + CORRUPT.getItemWeight(model)
                        if new_weight <= CORRUPT.getInventoryMaxWeight(user_id) then
                            RemoveWeaponFromPed(GetPlayerPed(source), k)
                            CORRUPTclient.removeWeapon(source, {k})
                            CORRUPT.giveInventoryItem(user_id, "wbody|"..k, 1, true)
                            if v.ammo > 0 then
                                for i, c in pairs(a.weapons) do
                                    if i == model and c.class ~= 'Melee' then
                                        CORRUPT.giveInventoryItem(user_id, c.ammo, v.ammo, true)
                                        CORRUPT.notify(source,{'~g~Weapons Stored', '~b~'..CORRUPT.getItemName("wbody|"..k)..'~w~ x1\n~b~'..CORRUPT.getItemName(c.ammo)..'~w~ x'..v.ammo})
                                    end
                                end
                            else
                              CORRUPT.notify(player,{'~g~Weapons Stored', '~b~'..CORRUPT.getItemName("wbody|"..k)..'~w~ x1'})
                            end
                        end
                    end
                end
            end)
        end
    end
end)

RegisterCommand('storeallweapons', function(source)
    local source = source
    local currentTime = os.time()

    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        CORRUPT.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        choice_store_weapons(source, false)
        cooldowns[source] = currentTime
    end
end)
RegisterServerEvent("CORRUPT:StoreAllWeapons", function()
    local source = source
    local currentTime = os.time()

    if cooldowns[source] and currentTime - cooldowns[source] < 3 then
        CORRUPT.notify(source, {"~r~Store weapon cooldown. Please wait"})
    else
        choice_store_weapons(source, true)
        cooldowns[source] = currentTime
    end
end)



RegisterCommand('shield', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') then
    TriggerClientEvent('CORRUPT:toggleShieldMenu', source)
  end
end)

RegisterCommand('cuff', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  CORRUPTclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      CORRUPTclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and CORRUPT.hasPermission(user_id, 'admin.tickets')) or CORRUPT.hasPermission(user_id, 'police.armoury') then
          CORRUPTclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = CORRUPT.getUserId(nplayer)
              if (not CORRUPT.hasPermission(nplayer_id, 'police.armoury') or CORRUPT.hasPermission(nplayer_id, 'police.undercover')) then
                CORRUPTclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('CORRUPT:uncuffAnim', source, nplayer, false)
                    TriggerClientEvent('CORRUPT:unHandcuff', source, false)
                  else
                    TriggerClientEvent('CORRUPT:arrestCriminal', nplayer, source)
                    TriggerClientEvent('CORRUPT:arrestFromPolice', source)
                  end
                  TriggerClientEvent('CORRUPT:toggleHandcuffs', nplayer, false)
                  TriggerClientEvent('CORRUPT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              CORRUPT.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

RegisterCommand('frontcuff', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  CORRUPTclient.isHandcuffed(source,{},function(handcuffed)
    if handcuffed then
      return
    else
      CORRUPTclient.isStaffedOn(source, {}, function(staffedOn) 
        if (staffedOn and CORRUPT.hasPermission(user_id, 'admin.tickets')) or CORRUPT.hasPermission(user_id, 'police.armoury') then
          CORRUPTclient.getNearestPlayer(source,{5},function(nplayer)
            if nplayer ~= nil then
              local nplayer_id = CORRUPT.getUserId(nplayer)
              if (not CORRUPT.hasPermission(nplayer_id, 'police.armoury') or CORRUPT.hasPermission(nplayer_id, 'police.undercover')) then
                CORRUPTclient.isHandcuffed(nplayer,{},function(handcuffed)
                  if handcuffed then
                    TriggerClientEvent('CORRUPT:uncuffAnim', source, nplayer, true)
                    TriggerClientEvent('CORRUPT:unHandcuff', source, true)
                  else
                    TriggerClientEvent('CORRUPT:arrestCriminal', nplayer, source)
                    TriggerClientEvent('CORRUPT:arrestFromPolice', source)
                  end
                  TriggerClientEvent('CORRUPT:toggleHandcuffs', nplayer, true)
                  TriggerClientEvent('CORRUPT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
                end)
              end
            else
              CORRUPT.notify(source,{lang.common.no_player_near()})
            end
          end)
        end
      end)
    end
  end)
end)

function CORRUPT.handcuffKeys(source)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.getInventoryItemAmount(user_id, 'keys') >= 1 then
    CORRUPTclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = CORRUPT.getUserId(nplayer)
        CORRUPTclient.isHandcuffed(nplayer,{},function(handcuffed)
          if handcuffed then
            CORRUPT.tryGetInventoryItem(user_id, 'keys', 1)
            TriggerClientEvent('CORRUPT:uncuffAnim', source, nplayer, false)
            TriggerClientEvent('CORRUPT:unHandcuff', source, false)
            TriggerClientEvent('CORRUPT:toggleHandcuffs', nplayer, false)
            TriggerClientEvent('CORRUPT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        CORRUPT.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

function CORRUPT.handcuff(source)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.getInventoryItemAmount(user_id, 'cuffs') >= 1 then
    CORRUPTclient.getNearestPlayer(source,{5},function(nplayer)
      if nplayer ~= nil then
        local nplayer_id = CORRUPT.getUserId(nplayer)
        CORRUPTclient.isHandcuffed(nplayer,{},function(handcuffed)
          if not handcuffed then
            CORRUPT.tryGetInventoryItem(user_id, 'cuffs', 1)
            TriggerClientEvent('CORRUPT:toggleHandcuffs', nplayer, true)
            TriggerClientEvent('CORRUPT:playHandcuffSound', -1, GetEntityCoords(GetPlayerPed(source)))
          end
        end)
      else
        CORRUPT.notify(source,{lang.common.no_player_near()})
      end
    end)
  end
end

local section60s = {}
RegisterCommand('s60', function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.announce') then
        if args[1] ~= nil and args[2] ~= nil then
            local radius = tonumber(args[1])
            local duration = tonumber(args[2])*60
            local section60UUID = #section60s+1
            section60s[section60UUID] = {radius = radius, duration = duration, uuid = section60UUID}
            TriggerClientEvent("CORRUPT:addS60", -1, GetEntityCoords(GetPlayerPed(source)), radius, section60UUID)
        else
            CORRUPT.notify(source,{'~r~Invalid Arguments.'})
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        for k,v in pairs(section60s) do
            if section60s[k].duration > 0 then
                section60s[k].duration = section60s[k].duration-1 
            else
                TriggerClientEvent('CORRUPT:removeS60', -1, section60s[k].uuid)
            end
        end
        Citizen.Wait(1000)
    end
end)

RegisterCommand('handbook', function(source, args)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('CORRUPT:toggleHandbook', source)
    end
end)

local draggingPlayers = {}

RegisterServerEvent('CORRUPT:dragPlayer')
AddEventHandler('CORRUPT:dragPlayer', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and (CORRUPT.hasPermission(user_id, "police.armoury") or CORRUPT.hasPermission(user_id, "hmp.menu")) then
      if playersrc ~= nil then
        local nuser_id = CORRUPT.getUserId(playersrc)
          if nuser_id ~= nil then
            CORRUPTclient.isHandcuffed(playersrc,{},function(handcuffed)
                if handcuffed then
                    if draggingPlayers[user_id] then
                      TriggerClientEvent("CORRUPT:undrag", playersrc, source)
                      draggingPlayers[user_id] = nil
                    else
                      TriggerClientEvent("CORRUPT:drag", playersrc, source)
                      draggingPlayers[user_id] = playersrc
                    end
                else
                    CORRUPT.notify(source,{"~r~Player is not handcuffed."})
                end
            end)
          else
              CORRUPT.notify(source,{"~r~There is no player nearby"})
          end
      else
          CORRUPT.notify(source,{"~r~There is no player nearby"})
      end
    end
end)

RegisterServerEvent('CORRUPT:putInVehicle')
AddEventHandler('CORRUPT:putInVehicle', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and CORRUPT.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        CORRUPTclient.isHandcuffed(playersrc,{}, function(handcuffed)  -- check handcuffed
          if handcuffed then
            CORRUPTclient.putInNearestVehicleAsPassenger(playersrc, {10})
          else
            CORRUPT.notify(source,{lang.police.not_handcuffed()})
          end
        end)
      end
    end
end)

RegisterServerEvent('CORRUPT:ejectFromVehicle')
AddEventHandler('CORRUPT:ejectFromVehicle', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and CORRUPT.hasPermission(user_id, "police.armoury") then
      CORRUPTclient.getNearestPlayer(source,{10},function(nplayer)
        local nuser_id = CORRUPT.getUserId(nplayer)
        if nuser_id ~= nil then
          CORRUPTclient.isHandcuffed(nplayer,{}, function(handcuffed)  -- check handcuffed
            if handcuffed then
              CORRUPTclient.ejectVehicle(nplayer, {})
            else
              CORRUPT.notify(source,{lang.police.not_handcuffed()})
            end
          end)
        else
          CORRUPT.notify(source,{lang.common.no_player_near()})
        end
      end)
    end
end)


RegisterServerEvent("CORRUPT:Knockout")
AddEventHandler('CORRUPT:Knockout', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPTclient.getNearestPlayer(source, {2}, function(nplayer)
        local nuser_id = CORRUPT.getUserId(nplayer)
        if nuser_id ~= nil then
            TriggerClientEvent('CORRUPT:knockOut', nplayer)
            SetTimeout(30000, function()
                TriggerClientEvent('CORRUPT:knockOutDisable', nplayer)
            end)
        end
    end)
end)

RegisterServerEvent("CORRUPT:KnockoutNoAnim")
AddEventHandler('CORRUPT:KnockoutNoAnim', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
      CORRUPTclient.getNearestPlayer(source, {2}, function(nplayer)
          local nuser_id = CORRUPT.getUserId(nplayer)
          if nuser_id ~= nil then
              TriggerClientEvent('CORRUPT:knockOut', nplayer)
              SetTimeout(30000, function()
                  TriggerClientEvent('CORRUPT:knockOutDisable', nplayer)
              end)
          end
      end)
    end
end)

RegisterServerEvent("CORRUPT:requestPlaceBagOnHead")
AddEventHandler('CORRUPT:requestPlaceBagOnHead', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.getInventoryItemAmount(user_id, 'headbag') >= 1 then
      CORRUPTclient.getNearestPlayer(source, {10}, function(nplayer)
          local nuser_id = CORRUPT.getUserId(nplayer)
          if nuser_id ~= nil then
              CORRUPT.tryGetInventoryItem(user_id, 'headbag', 1, true)
              TriggerClientEvent('CORRUPT:placeHeadBag', nplayer)
          end
      end)
    end
end)

RegisterServerEvent('CORRUPT:gunshotTest')
AddEventHandler('CORRUPT:gunshotTest', function(playersrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and CORRUPT.hasPermission(user_id, "police.armoury") then
      if playersrc ~= nil then
        CORRUPTclient.hasRecentlyShotGun(playersrc,{}, function(shotagun)
          if shotagun then
            CORRUPT.notify(source, {"~r~Player has recently shot a gun."})
          else
            CORRUPT.notify(source, {"~r~Player has no gunshot residue on fingers."})
          end
        end)
      end
    end
end)

RegisterServerEvent('CORRUPT:tryTackle')
AddEventHandler('CORRUPT:tryTackle', function(id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') or CORRUPT.hasPermission(user_id, 'admin.tickets') then
        TriggerClientEvent('CORRUPT:playTackle', source)
        TriggerClientEvent('CORRUPT:getTackled', id, source)
    end
end)

RegisterCommand('drone', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasGroup(user_id, 'Drone Trained') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
      TriggerClientEvent('toggleDrone', source)
  end
end)

RegisterCommand('trafficmenu', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') then
      TriggerClientEvent('CORRUPT:toggleTrafficMenu', source)
  end
end)

RegisterServerEvent('CORRUPT:startThrowSmokeGrenade')
AddEventHandler('CORRUPT:startThrowSmokeGrenade', function(name)
    local source = source
    TriggerClientEvent('CORRUPT:displaySmokeGrenade', -1, name, GetEntityCoords(GetPlayerPed(source)))
end)

RegisterCommand('breathalyse', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('CORRUPT:breathalyserCommand', source)
  end
end)

RegisterServerEvent('CORRUPT:breathalyserRequest')
AddEventHandler('CORRUPT:breathalyserRequest', function(temp)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
      TriggerClientEvent('CORRUPT:beingBreathalysed', temp)
      TriggerClientEvent('CORRUPT:breathTestResult', source, math.random(0, 100), CORRUPT.getPlayerName(temp))
    end
end)

seizeBullets = {
  ['p9mm'] = true,
  ['p7.62'] = true,
  ['p.357'] = true,
  ['p12gauge'] = true,
  ['p.308'] = true,
  ['p5.56'] = true,
}

RegisterServerEvent('CORRUPT:seizeWeapons')
AddEventHandler('CORRUPT:seizeWeapons', function(playerSrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
      CORRUPTclient.isHandcuffed(playerSrc,{},function(handcuffed)
        if handcuffed then
          RemoveAllPedWeapons(GetPlayerPed(playerSrc), true)
          local player_id = CORRUPT.getUserId(playerSrc)
          local cdata = CORRUPT.getUserDataTable(player_id)
          for a,b in pairs(cdata.inventory) do
              if string.find(a, 'wbody|') then
                  c = a:gsub('wbody|', '')
                  cdata.inventory[c] = b
                  cdata.inventory[a] = nil
              end
          end
          for k,v in pairs(a.weapons) do
              if cdata.inventory[k] ~= nil then
                  if not v.policeWeapon then
                    cdata.inventory[k] = nil
                  end
              end
          end
          for c,d in pairs(cdata.inventory) do
              if seizeBullets[c] then
                cdata.inventory[c] = nil
              end
          end
          TriggerEvent('CORRUPT:RefreshInventory', playerSrc)
          CORRUPT.notify(source, {'Seized weapons.'})
          CORRUPT.notify(playerSrc, {'Your weapons have been seized.'})
        end
      end)
    end
end)

seizeDrugs = {
  ['Weed leaf'] = true,
  ['Weed'] = true,
  ['Coca leaf'] = true,
  ['Cocaine'] = true,
  ['Opium Poppy'] = true,
  ['Heroin'] = true,
  ['Ephedra'] = true,
  ['Meth'] = true,
  ['Frogs legs'] = true,
  ['Lysergic Acid Amide'] = true,
  ['LSD'] = true,
}
RegisterServerEvent('CORRUPT:seizeIllegals')
AddEventHandler('CORRUPT:seizeIllegals', function(playerSrc)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
      local player_id = CORRUPT.getUserId(playerSrc)
      local cdata = CORRUPT.getUserDataTable(player_id)
      for a,b in pairs(cdata.inventory) do
          for c,d in pairs(seizeDrugs) do
              if a == c then
                cdata.inventory[a] = nil
              end
          end
      end
      TriggerEvent('CORRUPT:RefreshInventory', playerSrc)
      CORRUPT.notify(source, {'~r~Seized illegals.'})
      CORRUPT.notify(playerSrc, {'~r~Your illegals have been seized.'})
    end
end)

RegisterServerEvent("CORRUPT:newPanic")
AddEventHandler("CORRUPT:newPanic", function(a,b)
	local source = source
	local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') or CORRUPT.hasPermission(user_id, 'hmp.menu') or CORRUPT.hasPermission(user_id, 'nhs.menu') or CORRUPT.hasPermission(user_id, 'lfb.onduty.permission') then
        TriggerClientEvent("CORRUPT:returnPanic", -1, nil, a, b)
        CORRUPT.sendWebhook(getPlayerFaction(user_id)..'-panic', 'Corrupt Panic Logs', "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**\n> Location: **"..a.Location.."**")
    end
end)

RegisterNetEvent("CORRUPT:flashbangThrown")
AddEventHandler("CORRUPT:flashbangThrown", function(coords)   
    TriggerClientEvent("CORRUPT:flashbangExplode", -1, coords)
end)

RegisterNetEvent("CORRUPT:updateSpotlight")
AddEventHandler("CORRUPT:updateSpotlight", function(a)  
  local source = source 
  TriggerClientEvent("CORRUPT:updateSpotlight", -1, source, a)
end)

RegisterCommand('wc', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') then
    CORRUPTclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        CORRUPTclient.getPoliceCallsign(source, {}, function(callsign)
          CORRUPTclient.getPoliceRank(source, {}, function(rank)
            CORRUPTclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            CORRUPT.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank.."\n~b~Name: ~w~"..CORRUPT.getPlayerName(source),"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('CORRUPT:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand('wca', function(source, args)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') then
    CORRUPTclient.getNearestPlayer(source, {2}, function(nplayer)
      if nplayer ~= nil then
        CORRUPTclient.getPoliceCallsign(source, {}, function(callsign)
          CORRUPTclient.getPoliceRank(source, {}, function(rank)
            CORRUPTclient.playAnim(source,{true,{{'paper_1_rcm_alt1-9', 'player_one_dual-9', 1}},false})
            CORRUPT.notifyPicture(nplayer, {"polnotification","notification","~b~Callsign: ~w~"..callsign.."\n~b~Rank: ~w~"..rank,"Metropolitan Police","Warrant Card",false,nil})
            TriggerClientEvent('CORRUPT:flashWarrantCard', source)
          end)
        end)
      end
    end)
  end
end)

RegisterCommand("impoundvehicle", function(source)
  local source = source
  local user_id = CORRUPT.getUserId(source)
  if CORRUPT.hasPermission(user_id, 'police.armoury') then
    local impoundedVehicles = exports["corrupt"]:executeSync("SELECT * FROM corrupt_user_vehicles WHERE impounded = 1 and locked = 0")
    if #impoundedVehicles > 0 then
      local randomVehicle = impoundedVehicles[math.random(1, #impoundedVehicles)]
      local v = randomVehicle
      CORRUPT.notify(source, {"~g~Impounded vehicle has been sent to your MDT."})
      TriggerClientEvent("CORRUPT:impoundRequested", source, v.vehicle, GetEntityCoords(GetPlayerPed(source)))
    else
      CORRUPT.notify(source, {"~r~No vehicles were found in the impound."})
    end
  end
end)