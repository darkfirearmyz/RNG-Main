ownedGaffs = {}
local cfg = module("cfg/homes")

--SQL
MySQL.createCommand("CORRUPT/get_address","SELECT home, number FROM corrupt_user_homes WHERE user_id = @user_id")
MySQL.createCommand("CORRUPT/get_home_owner","SELECT user_id FROM corrupt_user_homes WHERE home = @home AND number = @number")
MySQL.createCommand("CORRUPT/rm_address","DELETE FROM corrupt_user_homes WHERE user_id = @user_id AND home = @home")
MySQL.createCommand("CORRUPT/set_address","REPLACE INTO corrupt_user_homes(user_id,home,number) VALUES(@user_id,@home,@number)")
MySQL.createCommand("CORRUPT/fetch_rented_houses", "SELECT * FROM corrupt_user_homes WHERE rented = 1")
MySQL.createCommand("CORRUPT/rentedupdatehouse", "UPDATE corrupt_user_homes SET user_id = @id, rented = @rented, rentedid = @rentedid, rentedtime = @rentedunix WHERE user_id = @user_id AND home = @home")

Citizen.CreateThread(function()
    while true do
        Wait(300000)
        MySQL.query('CORRUPT/fetch_rented_houses', {}, function(rentedhouses)
            for i,v in pairs(rentedhouses) do 
               if os.time() > tonumber(v.rentedtime) then
                  MySQL.execute('CORRUPT/rentedupdatehouse', {id = v.rentedid, rented = 0, rentedid = "", rentedunix = "", user_id = v.user_id, home = v.home})
               end
            end
        end)
    end
end)

function getUserAddress(user_id, cbr)
    local task = Task(cbr)
  
    MySQL.query("CORRUPT/get_address", {user_id = user_id}, function(rows, affected)
        task({rows[1]})
    end)
end
  
function setUserAddress(user_id, home, number)
    MySQL.execute("CORRUPT/set_address", {user_id = user_id, home = home, number = number})
end
  
function removeUserAddress(user_id, home)
    MySQL.execute("CORRUPT/rm_address", {user_id = user_id, home = home})
end

function getUserByAddress(home, number, cbr)
    local task = Task(cbr)
  
    MySQL.query("CORRUPT/get_home_owner", {home = home, number = number}, function(rows, affected)
        if #rows > 0 then
            task({rows[1].user_id})
        else
            task()
        end
    end)
end
function SyncHousingonbuy()
    for k,v in pairs(CORRUPT.getUsers()) do
        CORRUPT.SyncHousing(v, k)
    end
end
function CORRUPT.SyncHousing(source, user_id)
    local owned = {}
    local ownedbyplayer = {}
    local notowned = {}

    local function processHome(k, owner)
        if owner == user_id then
            owned[k] = true
            TriggerClientEvent("CORRUPT:addHome", source, k)
        elseif owner == nil then
            notowned[k] = true
        else
            ownedbyplayer[k] = true
        end
    end

    for k, v in pairs(cfg.homes) do
        local x, y, z = table.unpack(v.entry_point)

        getUserByAddress(k, 1, function(owner)
            processHome(k, owner)
        end)
    end
    SetTimeout(500, function()
        TriggerClientEvent("CORRUPT:setupHomesForSale", source, notowned, owned, {})
    end)
end
function leaveHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = CORRUPT.getUserSource(user_id)
    CORRUPT.setBucket(player, 0)
    for k, v in pairs(cfg.homes) do
        if k == home then
            local x,y,z = table.unpack(v.entry_point)
            CORRUPTclient.teleport(player, {x,y,z})
            CORRUPTclient.setInHome(player, {false})
            task({true})
        end
    end
end

function accessHome(user_id, home, number, cbr)
    local task = Task(cbr)
    local player = CORRUPT.getUserSource(user_id)
    local count = 0
    for k, v in pairs(cfg.homes) do
        count = count+1
        if k == home then
            CORRUPT.setBucket(player, count)
            local x,y,z = table.unpack(v.leave_point)
            CORRUPTclient.teleport(player, {x,y,z})
            CORRUPTclient.setInHome(player, {true})
            task({true})
        end
    end
end

RegisterNetEvent("CORRUPT:buyHome")
AddEventHandler("CORRUPT:buyHome", function(house)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local player = CORRUPT.getUserSource(user_id)

    for k, v in pairs(cfg.homes) do
        if house == k then
            getUserByAddress(house,1,function(noowner) --check if house already has a owner
                if noowner == nil then
                    getUserAddress(user_id, function(address) -- check if user already has a home
                        if CORRUPT.tryFullPayment(user_id,v.buy_price) then --try payment
                            local price = v.buy_price
                            setUserAddress(user_id,house,1) --set address
                            CORRUPT.SyncHousing(source, user_id)
                            CORRUPT.notify(player,{"~g~You bought "..k.."!"}) --notify
                            SyncHousingonbuy()
                            for a,b in pairs(CORRUPT.getUsers({})) do
                                local x,y,z = table.unpack(v.entry_point)
                                CORRUPTclient.removeBlipAtCoords(b,{x,y,z})
                                if user_id == a then
                                    CORRUPTclient.addBlip(b,{x,y,z,374,1,house})
                                end
                            end
                        else
                            CORRUPT.notify(player,{"~r~You do not have enough money to buy "..k}) --not enough money
                        end
                    end)
                else
                    CORRUPT.notify(player,{"~r~Someone already owns "..k})
                end
                if noowner ~= nil then
                    TriggerClientEvent('HouseOwned', player)
                end
            end)
        end
    end
end)

RegisterNetEvent("CORRUPT:enterHome")
AddEventHandler("CORRUPT:enterHome", function(house)
    local user_id = CORRUPT.getUserId(source)
    local player = CORRUPT.getUserSource(user_id)
    local name = CORRUPT.getPlayerName(source)

    getUserByAddress(house, 1, function(huser_id) --check if player owns home
        local hplayer = CORRUPT.getUserSource(huser_id) --temp id of home owner

        if huser_id ~= nil then
            if huser_id == user_id then
                accessHome(user_id, house, 1, function(ok) --enter home
                    if not ok then
                        CORRUPT.notify(player,{"Unable to enter home"}) --notify unable to enter home for whatever reason
                    end
                end)
            else
                if hplayer ~= nil then --check if home owner is online
                    CORRUPT.notify(player,{"~r~You do not own this home, Knocked on door!"})
                    TriggerClientEvent("CORRUPT:someoneAtTheDoor", hplayer) --knock on door
                    CORRUPT.request(hplayer,name.." knocked on your door!", 30, function(v,ok) --knock on door
                        if ok then
                            CORRUPT.notify(player,{"~g~Doorbell Accepted"}) --doorbell accepted
                            accessHome(user_id, house, 1, function(ok) --enter home
                                if not ok then
                                    CORRUPT.notify(player,{"~r~Unable to enter home!"}) --notify unable to enter home for whatever reason
                                end
                            end)
                        end
                        if not ok then
                            CORRUPT.notify(player,{"~r~Doorbell Refused "}) -- doorbell refused
                        end
                    end)
                else
                    CORRUPT.notify(player,{"~r~Home owner not online!"}) -- home owner not online
                end
            end
        else
            CORRUPT.notify(player,{"~r~Nobody owns "..house..""}) --no home owner & user_id already doesn't have a house
        end
    end)
end)

RegisterNetEvent("CORRUPT:exitHome")
AddEventHandler("CORRUPT:exitHome", function(house)
    local user_id = CORRUPT.getUserId(source)
    local player = CORRUPT.getUserSource(user_id)
    leaveHome(user_id, house, 1, function(ok)
        if not ok then
            CORRUPT.notify(player,{"~r~Unable to leave home!"})
        end
    end)
end)

RegisterNetEvent("CORRUPT:Sell")
AddEventHandler("CORRUPT:Sell", function(house)
    local user_id = CORRUPT.getUserId(source)
    local player = CORRUPT.getUserSource(user_id)
    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            CORRUPTclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. CORRUPT.getUserId(k) .. "]" .. CORRUPT.getPlayerName(k) .. " | " --add ids to usrList
                end
                if usrList ~= "" then
                    CORRUPT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then --validation
                            local target = CORRUPT.getUserSource(tonumber(target_id)) --get source of the new owner id
                            if target ~= nil then
                                CORRUPT.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        CORRUPT.request(target,CORRUPT.getPlayerName(player).." wants to sell: " ..house.. " Price: £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                            if ok then --bought
                                                local buyer_id = CORRUPT.getUserId(target) --get perm id of new owner
                                                amount = tonumber(amount) --convert amount str to int
                                                if CORRUPT.tryFullPayment(buyer_id,amount) then
                                                    setUserAddress(buyer_id, house, 1) --give house
                                                    removeUserAddress(user_id, house) -- remove house
                                                    CORRUPT.SyncHousing(source, user_id)
                                                    CORRUPT.giveBankMoney(user_id, amount) --give money to original owner
                                                    CORRUPT.notify(player,{"~g~You have successfully sold "..house.." to ".. CORRUPT.getPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                    CORRUPT.notify(target,{"~g~"..CORRUPT.getPlayerName(player).." has successfully sold you "..house.." for £"..amount.."!"}) --notify new owner
                                                else
                                                    CORRUPT.notify(player,{"".. CORRUPT.getPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                    CORRUPT.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                end
                                            else
                                                CORRUPT.notify(player,{""..CORRUPT.getPlayerName(target).." has refused to buy "..house.."!"}) --notify owner that refused
                                                CORRUPT.notify(target,{"~r~You have refused to buy "..house.."!"}) --notify new owner that refused
                                            end
                                        end)
                                    else
                                        CORRUPT.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                CORRUPT.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                            end
                        else
                            CORRUPT.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                        end
                    end)
                else
                    CORRUPT.notify(player,{"~r~No players nearby!"}) --no players nearby
                end
            end)
        else
            CORRUPT.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

RegisterNetEvent('CORRUPT:Rent')
AddEventHandler('CORRUPT:Rent', function(house)
    local user_id = CORRUPT.getUserId(source)
    local player = CORRUPT.getUserSource(user_id)
    getUserByAddress(house, 1, function(huser_id)
        if huser_id == user_id then
            CORRUPTclient.getNearestPlayers(player,{15},function(nplayers) --get nearest players
                usrList = ""
                for k, v in pairs(nplayers) do
                    usrList = usrList .. "[" .. CORRUPT.getUserId(k) .. "]" .. CORRUPT.getPlayerName(k) .. " | " --add ids to usrList
                end
                if usrList ~= "" then
                    CORRUPT.prompt(player,"Players Nearby: " .. usrList .. "","",function(player, target_id) --ask for id
                        target_id = target_id
                        if target_id ~= nil and target_id ~= "" then --validation
                            local target = CORRUPT.getUserSource(tonumber(target_id)) --get source of the new owner id
                            if target ~= nil then
                                CORRUPT.prompt(player,"Price £: ","",function(player, amount) --ask for price
                                    if tonumber(amount) and tonumber(amount) > 0 then
                                        CORRUPT.prompt(player,"Duration: ","",function(player, duration) --ask for price
                                            if tonumber(duration) and tonumber(duration) > 0 then
                                                CORRUPT.prompt(player, "Please replace text with YES or NO to confirm", "Rent Details:\nHouse: "..house.."\nRent Cost: "..amount.."\nDuration: "..duration.." hours\nRenting to player: "..CORRUPT.getPlayerName(target).."("..target_id..")",function(player,details)
                                                    if string.upper(details) == 'YES' then
                                                        CORRUPT.notify(player, {'~g~Rent offer sent!'})
                                                        CORRUPT.request(target,CORRUPT.getPlayerName(player).." wants to rent: " ..house.. " for "..duration.." hours, for £"..amount, 30, function(target,ok) --request new owner if they want to buy
                                                            if ok then 
                                                                local buyer_id = CORRUPT.getUserId(target) --get perm id of new owner
                                                                amount = tonumber(amount) --convert amount str to int
                                                                if CORRUPT.tryFullPayment(buyer_id,amount) then
                                                                    local rentedTime = os.time()
                                                                    rentedTime = rentedTime  + (60 * 60 * tonumber(duration)) 
                                                                    MySQL.execute("CORRUPT/rentedupdatehouse", {user_id = user_id, home = house, id = target_id, rented = 1, rentedid = user_id, rentedunix =  rentedTime }) 
                                                                    CORRUPT.giveBankMoney(user_id, amount)
                                                                    CORRUPT.notify(player,{"~g~You have successfully rented "..house.." to ".. CORRUPT.getPlayerName(target).." for £"..amount.."!"}) --notify original owner
                                                                    CORRUPT.notify(target,{"~g~"..CORRUPT.getPlayerName(player).." has successfully rented you "..house.." for £"..amount.."!"}) --notify new owner
                                                                    CORRUPT.SyncHousing(source, user_id)
                                                                    CORRUPT.SyncHousing(target, buyer_id)
                                                                else
                                                                    CORRUPT.notify(player,{"".. CORRUPT.getPlayerName(target).." doesn't have enough money!"}) --notify original owner
                                                                    CORRUPT.notify(target,{"~r~You don't have enough money!"}) --notify new owner
                                                                end
                                                            else
                                                                CORRUPT.notify(player,{""..CORRUPT.getPlayerName(target).." has refused to rent "..house.."!"}) --notify owner that refused
                                                                CORRUPT.notify(target,{"~r~You have refused to rent "..house.."!"}) --notify new owner that refused
                                                            end
                                                        end)
                                                    end
                                                end)
                                            end
                                        end)
                                    else
                                        CORRUPT.notify(player,{"~r~Price of home needs to be a number!"}) -- if price of home is a string not a int
                                    end
                                end)
                            else
                                CORRUPT.notify(player,{"~r~That Perm ID seems to be invalid!"}) --couldnt find perm id
                            end
                        else
                            CORRUPT.notify(player,{"~r~No Perm ID selected!"}) --no perm id selected
                        end
                    end)
                else
                    CORRUPT.notify(player,{"~r~No players nearby!"}) --no players nearby
                end
            end)
        else
            CORRUPT.notify(player,{"~r~You do not own "..house.."!"})
        end
    end)
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    CORRUPT.SyncHousing(source, user_id)
end)

local houseRobberies = {}
local usersBoltcutting = {}
RegisterNetEvent("CORRUPT:houseRobbery")
AddEventHandler("CORRUPT:houseRobbery", function(nameHouse)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not houseRobberies[nameHouse] then
        getUserByAddress(nameHouse, 1, function(huser_id)
            if CORRUPT.getUserSource(huser_id) ~= nil then
                if GetPlayerRoutingBucket(source) ~= 0 then
                    return CORRUPT.notify(source,{"~r~You cannot rob a house whilst not in bucket 0!"})
                end
                if CORRUPT.tryGetInventoryItem(user_id, 'boltcutters', 1, false) then
                    if huser_id ~= user_id then
                        usersBoltcutting[user_id] = os.time()
                        TriggerClientEvent("CORRUPT:forceBoltCutting", source)
                        TriggerClientEvent("CORRUPT:houseGettingRobbed", CORRUPT.getUserSource(huser_id), nameHouse, false)
                        Wait(300000)

                        if CORRUPT.getUserSource(huser_id) ~= nil then
                            CORRUPTclient.checkScenario(source, {"WORLD_HUMAN_WELDING"}, function(playingBoltcutting)
                                if playingBoltcutting and usersBoltcutting[user_id] == os.time() + 300000 then
                                    accessHome(user_id, nameHouse, 1, function(ok)
                                        if ok then
                                            houseRobberies[nameHouse] = {last_robbed = os.time()}
                                            CORRUPT.notify(source,{"~g~You have successfully broken into the house!"})
                                        end
                                    end)
                                end
                            end)
                        end
                    else
                        CORRUPT.notify(source,{"~r~You cannot rob your own house!"})
                    end
                else
                    CORRUPT.notify(source,{"~r~You need boltcutters to rob a house!"})
                end
            else
                CORRUPT.notify(source,{"~r~This house is not owned!"})
            end
        end)
    else
        CORRUPT.notify(source,{"~r~This house has already been robbed!"})
    end
end)


local houseRaid = {}
RegisterNetEvent("CORRUPT:raidHome")
AddEventHandler("CORRUPT:raidHome", function(nameHouse)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.hasPermission(user_id, "police.armoury") then
        return CORRUPT.notify(source,{"~r~You need to be a police officer to raid a house!"})
    end
    if not houseRaid[nameHouse] then
        getUserByAddress(nameHouse, 1, function(huser_id)
            if CORRUPT.getUserSource(huser_id) ~= nil then
                if GetPlayerRoutingBucket(source) ~= 0 then
                    return CORRUPT.notify(source,{"~r~You cannot raid a house whilst not in bucket 0!"})
                end
                if CORRUPT.hasPermission(user_id, "police.raid") then
                    if huser_id ~= user_id then
                        TriggerClientEvent("CORRUPT:houseGettingRobbed", CORRUPT.getUserSource(huser_id), nameHouse, true)
                        if CORRUPT.getUserSource(huser_id) ~= nil then
                            accessHome(user_id, nameHouse, 1, function(ok)
                                if ok then
                                    houseRaid[nameHouse] = {last_raided = os.time()}
                                    CORRUPT.notify(source,{"~g~You have successfully raided the house!"})
                                end
                            end)
                        end
                    else
                        CORRUPT.notify(source,{"~r~You cannot raid your own house!"})
                    end
                else
                    CORRUPT.notify(source,{"~r~You don't have permission to raid a house!"})
                end
            else
                CORRUPT.notify(source,{"~r~This home owner is not online!"})
            end
        end)
    else
        accessHome(user_id, nameHouse, 1, function(ok)
            if ok then
                CORRUPT.notify(source,{"~g~You have entered the raided house!"})
            end
        end)
    end
end)
