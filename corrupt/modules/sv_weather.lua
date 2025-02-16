voteCooldown = 1800
currentWeather = "EXTRASUNNY"

weatherVoterCooldown = voteCooldown

RegisterServerEvent("CORRUPT:vote") 
AddEventHandler("CORRUPT:vote", function(weatherType)
    TriggerClientEvent("CORRUPT:SyncVoteWeather", -1, weatherType)
end)

RegisterServerEvent("CORRUPT:requestTimeWeatherSync") 
AddEventHandler("CORRUPT:requestTimeWeatherSync", function()
    local source = source
    TriggerClientEvent("CORRUPT:setWeather", source, currentWeather)
end)

RegisterServerEvent("CORRUPT:setCurrentWeather")
AddEventHandler("CORRUPT:setCurrentWeather", function(newWeather)
	currentWeather = newWeather
end)

Citizen.CreateThread(function()
	while true do
		weatherVoterCooldown = weatherVoterCooldown + 1
		Citizen.Wait(1000)
	end
end)

RegisterCommand("voteweather", function(source, args, rawCommand)
    local source = source
    if weatherVoterCooldown >= voteCooldown then
        TriggerClientEvent("CORRUPT:startWeatherVote", -1)
        weatherVoterCooldown = 0
    else
        CORRUPT.notify(source, {"~r~You must wait "..(voteCooldown - weatherVoterCooldown).." seconds before starting another vote."})
    end
end)