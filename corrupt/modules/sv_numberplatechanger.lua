local forbiddenNames = {
	"%^1",
	"%^2",
	"%^3",
	"%^4",
	"%^5",
	"%^6",
	"%^7",
	"%^8",
	"%^9",
	"%^%*",
	"%^_",
	"%^=",
	"%^%~",
	"admin",
	"nigger",
	"cunt",
	"faggot",
	"fuck",
	"fucker",
	"fucking",
	"anal",
	"stupid",
	"damn",
	"cock",
	"cum",
	"dick",
	"dipshit",
	"dildo",
	"douchbag",
	"douch",
	"kys",
	"jerk",
	"jerkoff",
	"gay",
	"homosexual",
	"lesbian",
	"suicide",
	"mothafucka",
	"negro",
	"pussy",
	"queef",
	"queer",
	"weeb",
	"retard",
	"masterbate",
	"suck",
	"tard",
	"allahu akbar",
	"terrorist",
	"twat",
	"vagina",
	"wank",
	"whore",
	"wanker",
	"n1gger",
	"f4ggot",
	"n0nce",
	"d1ck",
	"h0m0",
	"n1gg3r",
	"h0m0s3xual",
	"free up mandem",
	"nazi",
	"hitler",
	"cheater",
	"cheating",
}

MySQL.createCommand("CORRUPT/update_numplate","UPDATE corrupt_user_vehicles SET vehicle_plate = @registration WHERE user_id = @user_id AND vehicle = @vehicle")
MySQL.createCommand("CORRUPT/check_numplate","SELECT * FROM corrupt_user_vehicles WHERE vehicle_plate = @plate")

RegisterNetEvent('CORRUPT:getCars')
AddEventHandler('CORRUPT:getCars', function()
    local cars = {}
    local source = source
    local user_id = CORRUPT.getUserId(source)
    exports['corrupt']:execute("SELECT * FROM `corrupt_user_vehicles` WHERE user_id = @user_id", {user_id = user_id}, function(result)
        if result ~= nil then 
            for k,v in pairs(result) do
                if v.user_id == user_id then
                    cars[v.vehicle] = {v.vehicle, v.vehicle_plate}
                end
            end
            TriggerClientEvent('CORRUPT:carsTable', source, cars)
        end
    end)
end)

RegisterNetEvent("CORRUPT:ChangeNumberPlate")
AddEventHandler("CORRUPT:ChangeNumberPlate", function(vehicle)
	local source = source
    local user_id = CORRUPT.getUserId(source)
	CORRUPT.prompt(source,"Plate Name:","",function(source, plateName)
		if plateName == '' then return end
		exports['corrupt']:execute("SELECT * FROM `corrupt_user_vehicles` WHERE vehicle_plate = @plate", {plate = plateName}, function(result)
            if next(result) then 
                CORRUPT.notify(source,{"This plate is already taken."})
                return
			else
				for name in pairs(forbiddenNames) do
					if plateName == forbiddenNames[name] then
						CORRUPT.notify(source,{"You cannot have this plate."})
						return
					end
				end
				if CORRUPT.tryFullPayment(user_id,500000) then
					CORRUPT.notify(source,{"~g~Changed plate of "..vehicle.." to "..plateName})
					MySQL.execute("CORRUPT/update_numplate", {user_id = user_id, registration = plateName, vehicle = vehicle})
					TriggerClientEvent("CORRUPT:RecieveNumberPlate", source, plateName)
					TriggerClientEvent("CORRUPT:PlaySound", source, "apple")
					TriggerEvent('CORRUPT:getCars')
				else
					CORRUPT.notify(source,{"You don't have enough money!"})
				end
            end
        end)
	end)
end)

RegisterNetEvent("CORRUPT:checkPlateAvailability")
AddEventHandler("CORRUPT:checkPlateAvailability", function(plate)
	local source = source
    local user_id = CORRUPT.getUserId(source)
	MySQL.query("CORRUPT/check_numplate", {plate = plate}, function(result)
		if #result > 0 then 
			CORRUPT.notify(source, {"The plate "..plate.." is already taken."})
		else
			CORRUPT.notify(source, {"~g~The plate "..plate.." is available."})
		end
	end)
end)
