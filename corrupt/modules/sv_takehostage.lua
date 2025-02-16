local takingHostage = {}
--takingHostage[source] = targetSource, source is takingHostage targetSource
local takenHostage = {}
--takenHostage[targetSource] = source, targetSource is being takenHostage by source

RegisterServerEvent("CORRUPT:takeHostageSync")
AddEventHandler("CORRUPT:takeHostageSync", function(targetSrc)
	local source = source
	TriggerClientEvent("CORRUPT:takeHostageSyncTarget", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterServerEvent("CORRUPT:takeHostageReleaseHostage")
AddEventHandler("CORRUPT:takeHostageReleaseHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("CORRUPT:takeHostageReleaseHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("CORRUPT:takeHostageKillHostage")
AddEventHandler("CORRUPT:takeHostageKillHostage", function(targetSrc)
	local source = source
	if takenHostage[targetSrc] then 
		TriggerClientEvent("CORRUPT:takeHostageKillHostage", targetSrc, source)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	end
end)

RegisterServerEvent("CORRUPT:takeHostageStop")
AddEventHandler("CORRUPT:takeHostageStop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("CORRUPT:takeHostageCl_stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("CORRUPT:takeHostageCl_stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

AddEventHandler('playerDropped', function(reason)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("CORRUPT:takeHostageCl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil
		takingHostage[source] = nil
	end
	if takenHostage[source] then
		TriggerClientEvent("CORRUPT:takeHostageCl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil
		takenHostage[source] = nil
	end
end)