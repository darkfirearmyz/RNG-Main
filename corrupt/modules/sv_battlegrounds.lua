 local battleroyale = module("cfg/events/cfg_battleroyale")
 local weapons = battleroyale.lootTable
 local data = {
     players = {},
     isActive = false,
     data = {},
     eventId = 0,
     eventName = "",
     drawPlayersTimeBar = true,
     musicString = "",
     playMusic = false
 }
 local LootBoxData = {}
 local ArmourPlateData = {}
 local plateId = 1
 local boxId = 1
 local coordstoplateid = {}
 local coordstoboxid = {}
 local function BattlegWeapons(crateID)
     local numWeapons = math.random(1, 2)
     LootBoxData[crateID].weapon = {}
     for i = 1, numWeapons do
         local weapon = weapons[math.random(1, #weapons)]
         if weapon[2] then
             LootBoxData[crateID].weapon[weapon[2]] = {amount = 250}
         end
         if weapon[1] then
             LootBoxData[crateID].weapon[weapon[1]] = { amount = 1 }
         end
     end
 end


 RegisterServerEvent("CORRUPT:startBattleGrounds", function(eventData)
     data = eventData
     local location = battleroyale.locations[data.data.info.locationIndex]

     plateId, boxId = 0, 0
     ArmourPlateData, LootBoxData = {}, {}

     for i, location in pairs(location.armourLocations) do
         plateId = plateId + 1
         ArmourPlateData[plateId] = {coords = location, plateId = plateId}
     end

     for i, location in pairs(location.lootLocations) do
         boxId = boxId + 1
         LootBoxData[boxId] = {coords = location, box = boxId}
         BattlegWeapons(boxId)
     end
     battleroyale.lootBoxes, battleroyale.armourPlates = LootBoxData, ArmourPlateData

     local lootboxid = {}
     for k, v in pairs(LootBoxData) do
         table.insert(lootboxid, v.box)
     end

     local indexname = battleroyale.locations[data.data.info.locationIndex].name
     for k, v in pairs(data.players) do
         TriggerClientEvent("CORRUPT:syncLootboxesTable", k, lootboxid, indexname)
     end
 end)

 RegisterServerEvent("CORRUPT:removeArmourPlate", function(platid)
     local source = source
     local user_id = CORRUPT.getUserId(source)
     if platid and data.players[source] then
         CORRUPT.setArmour(source, 100, true)
         for k, v in pairs(data.players) do
             TriggerClientEvent("CORRUPT:removeArmourPlateCl", k, platid)
         end
     end
 end)

 RegisterServerEvent("CORRUPT:openCrateBattle", function(source, crateID)
     if source and crateID and data.players[source] and LootBoxData[crateID] then
         local weapon = LootBoxData[crateID].weapon
         for i , v in pairs(weapon) do
             CORRUPT.notify(source, {"~g~You have received a " ..CORRUPT.getItemName(i)})
             CORRUPTclient.GiveWeaponsToPlayer(source, {{[i] = {ammo = 250}}, false})
             LootBoxData[crateID].weapon[i] = nil
         end
         for i,v in pairs(data.players) do
             TriggerClientEvent("CORRUPT:removeLootBox", i, crateID)
         end
     end
 end)
