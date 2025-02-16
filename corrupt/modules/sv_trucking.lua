local cfg = module("cfg/cfg_trucking")
local ownedtrucks = {}
local rentedtrucks = {}
local onTruckJob = {}

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    TriggerEvent("CORRUPT:updateOwnedTruckssv", user_id, ownedtrucks[user_id] or {}, rentedtrucks[user_id] or {})
end)

local d = {
    owned = {},
    rented = {}
}

RegisterNetEvent("CORRUPT:updateOwnedTruckssv")
AddEventHandler("CORRUPT:updateOwnedTruckssv", function(user_id, ownedTrucks, rentedTrucks)
    local source = source
    d["owned"][user_id] = ownedTrucks
    d["rented"][user_id] = rentedTrucks
    TriggerClientEvent("CORRUPT:updateOwnedTrucks", source, d["owned"][user_id], d["rented"][user_id])
end)

RegisterServerEvent("CORRUPT:rentTruck")
AddEventHandler("CORRUPT:rentTruck", function(vehicleName, price)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    rentedtrucks[user_id] = rentedtrucks[user_id] or {}
    table.insert(rentedtrucks[user_id], vehicleName)
    TriggerClientEvent("CORRUPT:updateOwnedTrucks", source, ownedtrucks[user_id], rentedtrucks[user_id])
end)

RegisterServerEvent("CORRUPT:spawnTruck")
AddEventHandler("CORRUPT:spawnTruck", function(vehicleName)
    local source = source
    TriggerClientEvent("CORRUPT:spawnTruckCl", source, vehicleName)
end)

RegisterServerEvent("CORRUPT:truckJobBuyAllTrucks")
AddEventHandler("CORRUPT:truckJobBuyAllTrucks", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local price = 5000

    if CORRUPT.tryFullPayment(user_id, price) then
        ownedtrucks[user_id] = ownedtrucks[user_id] or {}
        table.insert(ownedtrucks[user_id], "truck_model_name") -- replace with actual truck model
        TriggerClientEvent("CORRUPT:updateOwnedTrucks", source, ownedtrucks[user_id], rentedtrucks[user_id])
    else
        TriggerClientEvent("CORRUPT:notify", source, "Insufficient funds to buy all trucks.")
    end
end)

RegisterServerEvent("CORRUPT:toggleTruckJob")
AddEventHandler("CORRUPT:toggleTruckJob", function(onDuty)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    onTruckJob[user_id] = onDuty
    TriggerClientEvent("CORRUPT:setTruckerOnDuty", source, onDuty)
end)
