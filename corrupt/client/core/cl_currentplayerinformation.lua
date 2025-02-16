local a = {}
RegisterNetEvent("CORRUPT:receiveCurrentPlayerInfo")
AddEventHandler(
    "CORRUPT:receiveCurrentPlayerInfo",
    function(b)
        a = b
    end
)
function CORRUPT.getCurrentPlayerInfo(c)
    for d, e in pairs(a) do
        if d == c then
            return e
        end
    end
end
