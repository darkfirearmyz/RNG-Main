local Participant = {}
local Pot = 0
local TicketPrice = 20000
local LotteryActive = false

function CORRUPT.IsLotteryActive()
    return LotteryActive
end
function gettotalparticipants()
    local total = 0
    if Participant then
        for k, v in pairs(Participant) do
            total = total + 1
        end
    end
    return total
end


function setRandomAmountForLottery()
    Pot = math.floor(math.random(500000, 1000000) / 100) * 100
    TicketPrice = math.floor(math.random(10000, 50000) / 100) * 100
    LotteryActive = true
end

setRandomAmountForLottery()

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    local participant = #Participant or 0
    TriggerClientEvent("CORRUPT:setLotteryInfo", source, TicketPrice, Pot, gettotalparticipants())
end)

RegisterNetEvent("CORRUPT:getLotteryInfo")
AddEventHandler("CORRUPT:getLotteryInfo", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if Participant[user_id] then
        TriggerClientEvent("CORRUPT:setPersonalAmountBought", source, tonumber(Participant[user_id]))
    end
    TriggerClientEvent("CORRUPT:setLotteryInfo",source, TicketPrice, Pot, gettotalparticipants())
end)

RegisterNetEvent("CORRUPT:buyLotteryTicket")
AddEventHandler("CORRUPT:buyLotteryTicket", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local price = TicketPrice * amount
    if CORRUPT.tryPayment(user_id, price) then
        Participant[user_id] = amount
        Pot = Pot + price
        TriggerClientEvent("CORRUPT:playItemBoughtSound", source)
    end
end)

Citizen.CreateThread(
    function()
        while true do 
            Citizen.Wait(1000)
            local time = os.date("*t")
            if time.hour == 20 and time.min == 0 and time.sec == 0 then
                LotteryActive = false
                if next(Participant) ~= nil then 
                    local winnerIndex = math.random(1, gettotalparticipants())
                    local user_id = next(Participant, winnerIndex - 1)
                    local winnerAmount = Participant[user_id]
                    CORRUPT.notify(CORRUPT.getUserSource(user_id), {"~g~The lottery has been drawn. You were the winner for £"..getMoneyStringFormatted(Pot)..'.'})
                    CORRUPT.giveBankMoney(user_id, Pot)
                end
                Pot = 0
                Participant = {}
                CORRUPT.UpdateAllMarkets()
            end
        end
    end
)
