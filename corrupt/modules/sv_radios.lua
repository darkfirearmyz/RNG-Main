local cfg = module("cfg/cfg_radios")

local function getRadioType(user_id)
    if CORRUPT.hasPermission(user_id, "police.armoury") then
        return "Police"
    elseif CORRUPT.hasPermission(user_id, "nhs.menu") then
        return "NHS"
    elseif CORRUPT.hasPermission(user_id, "hmp.menu") then
        return "HMP"
    end
    return false
end

local radioChannels = {
    ['Police'] = {
        name = 'Police',
        players = {},
        channel = 1,
        callsign = true,
    },
    ['NHS'] = {
        name = 'NHS',
        players = {},
        channel = 2,
    },
    ['HMP'] = {
        name = 'HMP',
        players = {},
        channel = 3,
    }
}

function createRadio(source)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        Wait(1000)
        for k,v in pairs(cfg.sortOrder[radioType]) do
            if CORRUPT.hasPermission(user_id, v) then
                local sortOrder = k
                local name = CORRUPT.getPlayerName(source)
                local callsign = getCallsign(radioType, source, user_id, radioType)
                if radioChannels[radioType].callsign then
                    if callsign then
                        name = name.." ["..callsign.."]"
                    end
                end
                radioChannels[radioType]['players'][source] = {name = name, sortOrder = sortOrder}
                TriggerClientEvent('CORRUPT:radiosCreateChannel', source, radioChannels[radioType].channel, radioChannels[radioType].name, radioChannels[radioType].players, true)
                TriggerClientEvent('CORRUPT:radiosAddPlayer', -1, radioChannels[radioType].channel, source, {name = name, sortOrder = sortOrder})
                TriggerEvent("CORRUPT:ChatClockOn", source, radioType, true)
            end
        end
    else
        local gangname = CORRUPT.getGangName(user_id)

        if gangname and gangname ~= "" then
            if not radioChannels[gangname] then
                radioChannels[gangname] = {name = gangname, players = {}, channel = math.random(10, 1000)}
            end
            
            local name = CORRUPT.getPlayerName(source)
            radioChannels[gangname]['players'][source] = {name = name, sortOrder = 1}
            TriggerClientEvent('CORRUPT:radiosCreateChannel', source, radioChannels[gangname].channel, radioChannels[gangname].name, radioChannels[gangname].players, true)
            TriggerClientEvent('CORRUPT:radiosAddPlayer', -1, radioChannels[gangname].channel, source, {name = name, sortOrder = 1})
        end
    end
end




function removeRadio(source)
    for a,b in pairs(radioChannels) do
        if next(radioChannels[a]['players']) then
            for k,v in pairs(radioChannels[a]['players']) do
                if k == source then
                    if a then
                        TriggerEvent("CORRUPT:ChatClockOn", source, a, false)
                    end
                    TriggerClientEvent('CORRUPT:radiosRemovePlayer', -1, radioChannels[a].channel, k)
                    radioChannels[a]['players'][source] = nil
                end
            end
        end
    end
end

RegisterServerEvent("CORRUPT:clockedOnCreateRadio")
AddEventHandler("CORRUPT:clockedOnCreateRadio", function(source)
    local source = source
    syncRadio(source)
end)

RegisterServerEvent("CORRUPT:clockedOffRemoveRadio")
AddEventHandler("CORRUPT:clockedOffRemoveRadio", function(source)
    local source = source
    syncRadio(source)
end)

AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    local source = source
    syncRadio(source)
end)

AddEventHandler('playerDropped', function(reason)
    local source = source
    removeRadio(source)
end)

RegisterCommand("reconnectradio", function(source, args, rawCommand)
    local source = source
    syncRadio(source)
end)


function syncRadio(source)
    removeRadio(source)
    TriggerClientEvent('CORRUPT:radiosClearAll', source)
    Wait(500)
    createRadio(source)
end





RegisterServerEvent("CORRUPT:radiosSetIsMuted")
AddEventHandler("CORRUPT:radiosSetIsMuted", function(mutedState)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local radioType = getRadioType(user_id)
    if radioType then
        for k,v in pairs(radioChannels[radioType]['players']) do
            if k == source then
                TriggerClientEvent('CORRUPT:radiosSetPlayerIsMuted', -1, radioChannels[radioType].channel, k, mutedState)
            end
        end
    else
        local gang = CORRUPT.getGangName(user_id)
        if gang then
            for k,v in pairs(radioChannels[gang]['players']) do
                if k == source then
                    TriggerClientEvent('CORRUPT:radiosSetPlayerIsMuted', -1, radioChannels[gang].channel, k, mutedState)
                end
            end
        end
    end
end)


AddEventHandler("CORRUPT:ChatClockOn", function(source, mode, state)
    local policechat = {
        name = "Police",
        displayName = "Police",
        isChannel = "Police",
        color = "#0000ff",
        isGlobal = false,
    }
    local nhschat = {
        name = "NHS",
        displayName = "NHS",
        isChannel = "NHS",
        color = "#00ff00",
        isGlobal = false,
    }
    local hmpchat = {
        name = "HMP",
        displayName = "HMP",
        isChannel = "HMP",
        color = "#0000ff",
        isGlobal = false,
    }
    if state then
        if mode == "Police" then
            TriggerClientEvent('chat:addMode', source, policechat)
        elseif mode == "NHS" then
            TriggerClientEvent('chat:addMode', source, nhschat)
        elseif mode == "HMP" then
            TriggerClientEvent('chat:addMode', source, hmpchat)
        end
    else
        TriggerClientEvent('chat:removeMode', source, mode)
    end
end)
        