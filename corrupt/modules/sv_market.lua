local shopLocation = {
    {"1", vector3(128.1410369873, -1286.1120605469, 29.281036376953)},
    {"2", vector3(-47.522762298584,-1756.85717773438,29.4210109710693)},
    {"3", vector3(25.7454013824463,-1345.26232910156,29.4970207214355)}, 
    {"4", vector3(1135.57678222656,-981.78125,46.4157981872559)}, 
    {"5", vector3(1163.53820800781,-323.541320800781,69.2050552368164)}, 
    {"6", vector3(374.190032958984,327.506713867188,103.566368103027)}, 
    {"7", vector3(2555.35766601563,382.16845703125,108.622947692871)}, 
    {"8", vector3(2676.76733398438,3281.57788085938,55.2411231994629)}, 
    {"9", vector3(1960.50793457031,3741.84008789063,32.3437385559082)},
    {"10", vector3(1393.23828125,3605.171875,34.9809303283691)}, 
    {"11", vector3(1166.18151855469,2709.35327148438,38.15771484375)}, 
    {"12", vector3(547.987609863281,2669.7568359375,42.1565132141113)}, 
    {"13", vector3(1698.30737304688,4924.37939453125,42.0636749267578)}, 
    {"14", vector3(1729.54443359375,6415.76513671875,35.0372200012207)}, 
    {"15", vector3(-3243.9013671875,1001.40405273438,12.8307056427002)}, 
    {"16", vector3(-2967.8818359375,390.78662109375,15.0433149337769)}, 
    {"17", vector3(-3041.17456054688,585.166198730469,7.90893363952637)},
    {"18", vector3(-1820.55725097656,792.770568847656,138.113250732422)}, 
    {"19", vector3(-1486.76574707031,-379.553985595703,40.163387298584)}, 
    {"20", vector3(-1223.18127441406,-907.385681152344,12.3263463973999)}, 
    {"21", vector3(-707.408996582031,-913.681701660156,19.2155857086182)},
}
local shopItems = {}

for i = 1, 21 do
    shopItems[tostring(i)] = {
        _config = {
            lottery = CORRUPT.IsLotteryActive()
        },
        morphine = 50000,
        lockpick = 25000,
        electric_shaver = 250000,
        headbag = 10000,
        keys = 10000,
        cuffs = 150000,
        boltcutters = 400000,
        burner_phone = 500000
    }
end

local itemNames = {}
for i = 1, 21 do
    itemNames[tostring(i)] = {
        morphine = {"Morphine", "A powerful painkiller.", ""},
        lockpick = {"Lockpick", "A tool used to pick locks.", ""},
        electric_shaver = {"Shaver", "A tool used to shave.", ""},
        headbag = {"Head Bag", "A bag used to cover the head.", ""},
        keys = {"Handcuff Keys", "A tool used to unlock handcuffs.", ""},
        cuffs = {"Handcuffs", "A tool used to handcuff.", ""},
        boltcutters = {"Bolt Cutters", "A tool used to cut bolts.", ""},
        burner_phone = {"Burner Phone", "Phone to clean dirty cash.", ""},
    }
end

local serveritemstable = {
    morphine = 50000,
    lockpick = 25000,
    electric_shaver = 250000,
    headbag = 10000,
    keys = 10000,
    cuffs = 150000,
    boltcutters = 400000,
    burner_phone = 500000
}

AddEventHandler("CORRUPTcli:playerSpawned", function()
    local source = source
    TriggerClientEvent("CORRUPT:buildMarkets", source, shopItems, itemNames)
    TriggerClientEvent("CORRUPT:buildMarketMenus", source, shopLocation)
end)

RegisterNetEvent("CORRUPT:requestToBuyItem")
AddEventHandler("CORRUPT:requestToBuyItem", function(item, amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if serveritemstable[item] then
        local totalPrice = serveritemstable[item] * amount
        if CORRUPT.getInventoryWeight(user_id) <= 25 then
            if CORRUPT.tryPayment(user_id, totalPrice) then
                CORRUPT.giveInventoryItem(user_id, item, amount, false)
                CORRUPT.notify(source, {"~g~Paid ".. '£' ..getMoneyStringFormatted(totalPrice)..'.'})
                TriggerClientEvent("CORRUPT:playItemBoughtSound", source)
            else
                CORRUPT.notify(source, {"Not enough money."})
            end
        else
            CORRUPT.notify(source,{'Not enough inventory space.'})
        end
    end
end)


function CORRUPT.UpdateAllMarkets()
    TriggerClientEvent("CORRUPT:buildMarkets", -1, shopItems, itemNames)
end
