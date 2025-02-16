local announceTables = {
    {permission = 'group.add.commanager', info = {name = "Server Announcement", desc = "Announce something to the server", price = 0}, image = 'https://cdn.discordapp.com/attachments/1200853764018544700/1211371456445947954/FZMys0F.png?ex=65edf495&is=65db7f95&hm=81bc49c9b6b105b7be25fbc1c21b66d02e728dc334682068a85ccc642e867ecc&'},
    {permission = 'police.announce', info = {name = "PD Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://cdn.discordapp.com/attachments/1200853764018544700/1211371456672571532/I7c5LsN.png?ex=65edf495&is=65db7f95&hm=e0f6a735b39ca5198238701ae475de4cd67f3cc55eb2b124ae6918d3ef205277&'},
    {permission = 'nhs.announce', info = {name = "NHS Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://cdn.discordapp.com/attachments/1200853764018544700/1211371457364361280/SypLbMo.png?ex=65edf495&is=65db7f95&hm=028ec357103b4a770eba3940b9cc167272f279d2aa77c99f7d830cde47947012&'},
    {permission = 'lfb.announce', info = {name = "LFB Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://cdn.discordapp.com/attachments/1200853764018544700/1211371456156532887/AFqPgYk.png?ex=65edf495&is=65db7f95&hm=5c1a928e17ef27701598dcd16ab50fa1419a7f878fb31b920281b0d35a77dde0&'},
    {permission = 'hmp.announce', info = {name = "HMP Announcement", desc = "Announce something to the server", price = 10000}, image = 'https://cdn.discordapp.com/attachments/1200853764018544700/1211371457033146490/rPF5FgQ.png?ex=65edf495&is=65db7f95&hm=a76fb58c1f57f754c6516cfe6b0eb3d611815b7f8181cfcec1691e92182900e9&'},
}

RegisterServerEvent("CORRUPT:getAnnounceMenu")
AddEventHandler("CORRUPT:getAnnounceMenu", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local hasPermsFor = {}
    for k,v in pairs(announceTables) do
        if CORRUPT.hasPermission(user_id, v.permission) or CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
            table.insert(hasPermsFor, v.info)
        end
    end
    if #hasPermsFor > 0 then
        TriggerClientEvent("CORRUPT:buildAnnounceMenu", source, hasPermsFor)
    end
end)

RegisterServerEvent("CORRUPT:serviceAnnounce")
AddEventHandler("CORRUPT:serviceAnnounce", function(announceType)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(announceTables) do
        if v.info.name == announceType then
            if CORRUPT.hasPermission(user_id, v.permission) or CORRUPT.hasGroup(user_id, 'Founder') or CORRUPT.hasGroup(user_id, 'Developer') or CORRUPT.hasGroup(user_id, 'Lead Developer') then
                if CORRUPT.tryFullPayment(user_id, v.info.price) then
                    CORRUPT.prompt(source,"Input text to announce","",function(source,data) 
                        TriggerClientEvent('CORRUPT:serviceAnnounceCl', -1, v.image, data)
                        if v.info.price > 0 then
                            CORRUPT.notify(source, {"~g~Purchased a "..v.info.name.." for £"..getMoneyStringFormatted(v.info.price).." with content ~b~"..data})
                            CORRUPT.sendWebhook('announce', "Corrupt Announcement Logs", "```"..data.."```".."\n> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        else
                            CORRUPT.notify(source, {"~g~Sending a "..v.info.name.." with content ~b~"..data})
                            CORRUPT.sendWebhook('announce', "Corrupt Announcement Logs", "```"..data.."```".."\n> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
                        end
                    end)
                else
                    CORRUPT.notify(source, {"~r~You do not have enough money to do this."})
                end
            else
                TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to Trigger an announcement')
            end
        end
    end
end)



RegisterCommand("consoleannounce", function(source, args)
    local source = source
    if source == 0 then
        local data = table.concat(args, " ")
        print("[Corrupt Announcement] "..data)
        TriggerClientEvent('CORRUPT:serviceAnnounceCl', -1, 'https://i.imgur.com/FZMys0F.png', data)
        CORRUPT.sendWebhook('announce', "Corrupt Announcement Logs", "```"..data.."```")
    else
        CORRUPT.notify(source, {"~r~You do not have permission to do this."})
    end
end)