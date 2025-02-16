local coinflipTables = {
    [1] = false,
    [2] = false,
    [5] = false,
    [6] = false,
}

local linkedTables = {
    [1] = 2,
    [2] = 1,
    [5] = 6,
    [6] = 5,
}

local coinflipGameInProgress = {}
local coinflipGameData = {}

local betId = 0

function giveChips(source,amount)
    local user_id = CORRUPT.getUserId(source)
    MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = amount})
    TriggerClientEvent('CORRUPT:chipsUpdated', source)
end

AddEventHandler('playerDropped', function (reason)
    local source = source
    for k,v in pairs(coinflipTables) do
        if v == source then
            coinflipTables[k] = false
            coinflipGameData[k] = nil
        end
    end
end)

RegisterNetEvent("CORRUPT:requestCoinflipTableData")
AddEventHandler("CORRUPT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("CORRUPT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("CORRUPT:requestSitAtCoinflipTable")
AddEventHandler("CORRUPT:requestSitAtCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then
        for k,v in pairs(coinflipTables) do
            if v == source then
                coinflipTables[k] = false
                return
            end
        end
        coinflipTables[chairId] = source
        local currentBetForThatTable = coinflipGameData[chairId]
        TriggerClientEvent("CORRUPT:sendCoinflipTableData",-1,coinflipTables)
        TriggerClientEvent("CORRUPT:sitAtCoinflipTable",source,chairId,currentBetForThatTable)
    end
end)

RegisterNetEvent("CORRUPT:leaveCoinflipTable")
AddEventHandler("CORRUPT:leaveCoinflipTable", function(chairId)
    local source = source
    if source ~= nil then 
        for k,v in pairs(coinflipTables) do 
            if v == source then 
                coinflipTables[k] = false
                coinflipGameData[k] = nil
            end
        end
        TriggerClientEvent("CORRUPT:sendCoinflipTableData",-1,coinflipTables)
    end
end)

RegisterNetEvent("CORRUPT:proposeCoinflip")
AddEventHandler("CORRUPT:proposeCoinflip",function(betAmount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    betId = betId+1
    if betAmount ~= nil then 
        if coinflipGameData[betId] == nil then
            coinflipGameData[betId] = {}
        end
        if not coinflipGameInProgress[betId] then
            if tonumber(betAmount) then
                betAmount = tonumber(betAmount)
                if betAmount >= 100000 then
                    MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                        chips = rows[1].chips
                        if chips >= betAmount then
                            TriggerClientEvent('CORRUPT:chipsUpdated', source)
                            if coinflipGameData[betId][source] == nil then
                                coinflipGameData[betId][source] = {}
                            end
                            coinflipGameData[betId] = {betId = betId, betAmount = betAmount, user_id = user_id}
                            for k,v in pairs(coinflipTables) do
                                if v == source then
                                    TriggerClientEvent('CORRUPT:addCoinflipProposal', source, betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    if coinflipTables[linkedTables[k]] then
                                        TriggerClientEvent('CORRUPT:addCoinflipProposal', coinflipTables[linkedTables[k]], betId, {betId = betId, betAmount = betAmount, user_id = user_id})
                                    end
                                end
                            end
                            CORRUPT.notify(source,{"~g~Bet placed: " .. getMoneyStringFormatted(betAmount) .. " chips."})
                        else 
                            CORRUPT.notify(source,{"Not enough chips!"})
                        end
                    end)
                else
                    CORRUPT.notify(source,{'Minimum bet at this table is £100,000.'})
                    return
                end
            end
        end
    else
       CORRUPT.notify(source,{"Error betting!"})
    end
end)

RegisterNetEvent("CORRUPT:requestCoinflipTableData")
AddEventHandler("CORRUPT:requestCoinflipTableData", function()   
    local source = source
    TriggerClientEvent("CORRUPT:sendCoinflipTableData",source,coinflipTables)
end)

RegisterNetEvent("CORRUPT:cancelCoinflip")
AddEventHandler("CORRUPT:cancelCoinflip", function()   
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.user_id == user_id then
            coinflipGameData[k] = nil
            TriggerClientEvent("CORRUPT:cancelCoinflipBet",-1,k)
        end
    end
end)

RegisterNetEvent("CORRUPT:acceptCoinflip")
AddEventHandler("CORRUPT:acceptCoinflip", function(gameid)   
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(coinflipGameData) do
        if v.betId == gameid then
            MySQL.query("casinochips/get_chips", {user_id = user_id}, function(rows, affected)
                chips = rows[1].chips
                if chips >= v.betAmount then
                    MySQL.execute("casinochips/remove_chips", {user_id = user_id, amount = v.betAmount})
                    TriggerClientEvent('CORRUPT:chipsUpdated', source)
                    MySQL.execute("casinochips/remove_chips", {user_id = v.user_id, amount = v.betAmount})
                    TriggerClientEvent('CORRUPT:chipsUpdated', CORRUPT.getUserSource(v.user_id))
                    local coinFlipOutcome = math.random(0,1)
                    if coinFlipOutcome == 0 then
                        local game = {amount = v.betAmount, winner = CORRUPT.getPlayerName(source), loser = CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id))}
                        TriggerClientEvent('CORRUPT:coinflipOutcome', source, true, game)
                        TriggerClientEvent('CORRUPT:coinflipOutcome', CORRUPT.getUserSource(v.user_id), false, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = user_id, amount = v.betAmount*2})
                        TriggerClientEvent('CORRUPT:chipsUpdated', source)
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..CORRUPT.getPlayerName(source).." has WON a coin flip against "..CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!", "alert")
                        end
                        CORRUPT.sendWebhook('coinflip-bet',"Corrupt Coinflip Logs", "> Winner Name: **"..CORRUPT.getPlayerName(source).."**\n> Winner TempID: **"..source.."**\n> Winner PermID: **"..user_id.."**\n> Loser Name: **"..CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id)).."**\n> Loser TempID: **"..CORRUPT.getUserSource(v.user_id).."**\n> Loser PermID: **"..v.user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    else
                        local game = {amount = v.betAmount, winner = CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id)), loser = CORRUPT.getPlayerName(source)}
                        TriggerClientEvent('CORRUPT:coinflipOutcome', source, false, game)
                        TriggerClientEvent('CORRUPT:coinflipOutcome', CORRUPT.getUserSource(v.user_id), true, game)
                        Wait(10000)
                        MySQL.execute("casinochips/add_chips", {user_id = v.user_id, amount = v.betAmount*2})
                        TriggerClientEvent('CORRUPT:chipsUpdated', CORRUPT.getUserSource(v.user_id))
                        if v.betAmount > 10000000 then
                            TriggerClientEvent('chatMessage', -1, "^7Coin Flip |", { 124, 252, 0 }, ""..CORRUPT.getPlayerName(source).." has WON a coin flip against "..CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id)).." for "..getMoneyStringFormatted(v.betAmount).." chips!", "alert")
                        end
                        CORRUPT.sendWebhook('coinflip-bet',"Corrupt Coinflip Logs", "> Winner Name: **"..CORRUPT.getPlayerName(CORRUPT.getUserSource(v.user_id)).."**\n> Winner TempID: **"..CORRUPT.getUserSource(v.user_id).."**\n> Winner PermID: **"..v.user_id.."**\n> Loser Name: **"..CORRUPT.getPlayerName(source).."**\n> Loser TempID: **"..source.."**\n> Loser PermID: **"..user_id.."**\n> Amount: **"..getMoneyStringFormatted(v.betAmount).."**")
                    end
                else 
                    CORRUPT.notify(source,{"Not enough chips!"})
                end
            end)
        end
    end
end)

RegisterCommand('tables', function(source)
    print(json.encode(coinflipTables))
end)