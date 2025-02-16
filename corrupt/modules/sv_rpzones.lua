local rpZones = {}
local numRP = 0

RegisterServerEvent("CORRUPT:createRPZone")
AddEventHandler("CORRUPT:createRPZone", function(zoneData)
	local source = source
	local user_id = CORRUPT.getUserId(source)
	if CORRUPT.hasPermission(user_id, 'group.remove') then
		numRP = numRP + 1
		zoneData['uuid'] = numRP
		rpZones[numRP] = zoneData
		TriggerClientEvent('CORRUPT:createRPZone', -1, zoneData)
	end
end)

RegisterServerEvent("CORRUPT:removeRPZone")
AddEventHandler("CORRUPT:removeRPZone", function(uuid)
	local source = source
	local user_id = CORRUPT.getUserId(source)
	if CORRUPT.hasPermission(user_id, 'group.remove') then
		if next(rpZones) then
			for k,v in pairs(rpZones) do
				if v.uuid == uuid then
					rpZones[k] = nil
					TriggerClientEvent('CORRUPT:removeRPZone', -1, uuid)
					break
				end
			end
		end
	end
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
	if first_spawn and next(rpZones) then
		for _, zoneData in pairs(rpZones) do
			TriggerClientEvent('CORRUPT:createRPZone', source, zoneData)
		end
	end
end)
