RegisterNetEvent('CORRUPT:purchaseHighRollersMembership')
AddEventHandler('CORRUPT:purchaseHighRollersMembership', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if not CORRUPT.hasGroup(user_id, 'Highroller') then
        if CORRUPT.tryFullPayment(user_id,10000000) then
            CORRUPT.addUserGroup(user_id, 'Highroller')
            CORRUPT.notify(source, {'~g~You have purchased the ~b~High Rollers ~g~membership.'})
            CORRUPT.sendWebhook('purchase-highrollers',"Corrupt Purchased Highrollers Logs", "> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player TempID: **"..source.."**\n> Player PermID: **"..user_id.."**")
        else
            CORRUPT.notify(source, {'You do not have enough money to purchase this membership.'})
        end
    else
        CORRUPT.notify(source, {"You already have High Roller's License."})
    end
end)

RegisterNetEvent('CORRUPT:removeHighRollersMembership')
AddEventHandler('CORRUPT:removeHighRollersMembership', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, 'Highroller') then
        CORRUPT.removeUserGroup(user_id, 'Highroller')
    else
        CORRUPT.notify(source, {"You do not have High Roller's License."})
    end
end)