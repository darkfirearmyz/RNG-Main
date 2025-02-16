local trainingWorlds = {}
local trainingWorldsCount = 0
RegisterCommand('trainingworlds', function(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.armoury') then
        TriggerClientEvent('CORRUPT:trainingWorldSendAll', source, trainingWorlds)
        TriggerClientEvent('CORRUPT:trainingWorldOpen', source, CORRUPT.hasPermission(user_id, 'police.announce'))
    end
end)

RegisterNetEvent("CORRUPT:trainingWorldCreate")
AddEventHandler("CORRUPT:trainingWorldCreate", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    trainingWorldsCount = trainingWorldsCount + 1
    CORRUPT.prompt(source,"World Name:","",function(player,worldname) 
        if string.gsub(worldname, "%s+", "") ~= '' then
            if next(trainingWorlds) then
                for k,v in pairs(trainingWorlds) do
                    if v.name == worldname then
                        CORRUPT.notify(source, {"This world name already exists."})
                        return
                    elseif v.ownerUserId == user_id then
                        CORRUPT.notify(source, {"You already have a world, please delete it first."})
                        return
                    end
                end
            end
            CORRUPT.prompt(source,"World Password:","",function(player,password) 
                trainingWorlds[trainingWorldsCount] = {name = worldname, ownerName = CORRUPT.getPlayerName(source), ownerUserId = user_id, bucket = trainingWorldsCount, members = {}, password = password}
                table.insert(trainingWorlds[trainingWorldsCount].members, user_id)
                CORRUPT.setBucket(source, trainingWorldsCount)
                TriggerClientEvent('CORRUPT:trainingWorldSend', -1, trainingWorldsCount, trainingWorlds[trainingWorldsCount])
                CORRUPT.notify(source, {'~g~Training World Created!'})
            end)
        else
            CORRUPT.notify(source, {"Invalid World Name."})
        end
    end)
end)

RegisterNetEvent("CORRUPT:trainingWorldRemove")
AddEventHandler("CORRUPT:trainingWorldRemove", function(world)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'police.announce') then
        if trainingWorlds[world] ~= nil then
            TriggerClientEvent('CORRUPT:trainingWorldRemove', -1, world)
            for k,v in pairs(trainingWorlds[world].members) do
                local memberSource = CORRUPT.getUserSource(v)
                if memberSource ~= nil then
                    CORRUPT.setBucket(memberSource, 0)
                    CORRUPT.notify(memberSource, {"~w~The training world you were in was deleted, you have been returned to the main dimension."})
                end
            end
            trainingWorlds[world] = nil
        end
    end
end)

RegisterNetEvent("CORRUPT:trainingWorldJoin")
AddEventHandler("CORRUPT:trainingWorldJoin", function(world)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.prompt(source,"Enter Password:","",function(player,password) 
        if password ~= trainingWorlds[world].password then
            CORRUPT.notify(source, {"Invalid Password."})
            return
        else
            CORRUPT.setBucket(source, world)
            table.insert(trainingWorlds[world].members, user_id)
            CORRUPT.notify(source, {"~w~You have joined training world "..trainingWorlds[world].name..' owned by '..trainingWorlds[world].ownerName..'.'})
        end
    end)
end)

RegisterNetEvent("CORRUPT:trainingWorldLeave")
AddEventHandler("CORRUPT:trainingWorldLeave", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    CORRUPT.setBucket(source, 0)
    CORRUPT.notify(source, {"~w~You have left the training world."})
end)

