RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

-- this is a built-in event, but somehow needs to be registered
RegisterNetEvent('playerJoining')


local blockedWords = {
    "nigger",
    "nigga",
    "wog",
    "coon",
    "paki",
    "faggot",
    "anal",
    "kys",
    "homosexual",
    "lesbian",
    "suicide",
    "negro",
    "queef",
    "queer",
    "allahu akbar",
    "terrorist",
    "wanker",
    "n1gger",
    "f4ggot",
    "n0nce",
    "d1ck",
    "h0m0",
    "n1gg3r",
    "h0m0s3xual",
    "nazi",
    "hitler",
    "fag",
    "fa5",
}


exports('addMessage', function(target, message)
    if not message then
        message = target
        target = -1
    end

    if not target or not message then return end

    TriggerClientEvent('chat:addMessage', target, message)
end)

local hooks = {}
local hookIdx = 1

exports('registerMessageHook', function(hook)
    local resource = GetInvokingResource()
    hooks[hookIdx + 1] = {
        fn = hook,
        resource = resource
    }

    hookIdx = hookIdx + 1
end)

local modes = {}

local function getMatchingPlayers(seObject)
    local players = GetPlayers()
    local retval = {}

    for _, v in ipairs(players) do
        if IsPlayerAceAllowed(v, seObject) then
            retval[#retval + 1] = v
        end
    end

    return retval
end
exports('registerMode', function(modeData)
    if not modeData.name or not modeData.displayName or not modeData.cb then
        return false
    end

    local resource = GetInvokingResource()

    modes[modeData.name] = modeData
    modes[modeData.name].resource = resource

    local clObj = {
        name = modeData.name,
        displayName = modeData.displayName,
        color = modeData.color or '#fff',
        isChannel = modeData.isChannel,
        isGlobal = modeData.isGlobal,
    }

    if not modeData.seObject then
        TriggerClientEvent('chat:addMode', -1, clObj)
    else
        for _, v in ipairs(getMatchingPlayers(modeData.seObject)) do
            TriggerClientEvent('chat:addMode', v, clObj)
        end
    end

    return true
end)

local function unregisterHooks(resource)
    local toRemove = {}

    for k, v in pairs(hooks) do
        if v.resource == resource then
            table.insert(toRemove, k)
        end
    end

    for _, v in ipairs(toRemove) do
        hooks[v] = nil
    end

    toRemove = {}

    for k, v in pairs(modes) do
        if v.resource == resource then
            table.insert(toRemove, k)
        end
    end

    for _, v in ipairs(toRemove) do
        TriggerClientEvent('chat:removeMode', -1, {
            name = v
        })

        modes[v] = nil
    end
end
local CharSetLookup = {}
local over = true
local theString = ""
local theReward = 0

local function generateRandomLetters()
    local chars = {}
    for loop = 1, 5 do
        local randomChar = string.char(math.random(65, 90)) -- ASCII values for A to Z
        chars[loop] = randomChar
    end
    return table.concat(chars)
end

theString = {}
Citizen.CreateThread(function()
    while true do
        Citizen.Wait(900000)
        over = false
        theString = generateRandomLetters()
        theString = string.upper(theString)
        theReward = math.random(10000, 50000) * 2
        TriggerEvent("CORRUPT:ChatReward:Check", theString, theReward)
        TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] Who writes the word: ^1" .. theString .. "^2 first gets ^1£" .. theReward)
        SetTimeout(10000, function()
            if not over then
                TriggerClientEvent('chatMessage', -1, "^2[Mini-Event] ^1Time is over, no one wrote the word!")
                over = true
                theReward = 0
                theString = ""
            end
        end)
    end
end)


local function routeMessage(source, author, message, mode, fromConsole)
    if source >= 1 then
        author = exports["corrupt"]:GetDiscordName(source)
    end

    local outMessage = {
        color = { 255, 255, 255 },
        multiline = true,
        args = { message },
        mode = mode
    }

    if author ~= "" then
        outMessage.args = { author, message }
    end

    if mode and modes[mode] then
        local modeData = modes[mode]

        if modeData.seObject and not IsPlayerAceAllowed(source, modeData.seObject) then
            return
        end
    end

    local messageCanceled = false
    local routingTarget = -1

    local hookRef = {
        updateMessage = function(t)
            -- shallow merge
            for k, v in pairs(t) do
                if k == 'template' then
                    outMessage['template'] = v:gsub('%{%}', outMessage['template'] or '@default')
                elseif k == 'params' then
                    if not outMessage.params then
                        outMessage.params = {}
                    end

                    for pk, pv in pairs(v) do
                        outMessage.params[pk] = pv
                    end
                else
                    outMessage[k] = v
                end
            end
        end,

        cancel = function()
            messageCanceled = true
        end,

        setSeObject = function(object)
            routingTarget = getMatchingPlayers(object)
        end,

        setRouting = function(target)
            routingTarget = target
        end
    }

    for _, hook in pairs(hooks) do
        if hook.fn then
            hook.fn(source, outMessage, hookRef)
        end
    end

    if modes[mode] then
        local m = modes[mode]

        m.cb(source, outMessage, hookRef)
    end

    if messageCanceled then
        return
    end
    if string.sub(message, 1, 1) == "/" then
        CancelEvent()
        return
    end
    if mode == "OOC" then
        TriggerEvent("CORRUPT:ooc", source, message)
        return
    end
    if mode == "Gang" then
        TriggerEvent("CORRUPT:GangChat", source, message)
        return
    end
    if mode == "Anonymous" then
        TriggerEvent("CORRUPT:Anon", source, message)
        return
    end
    if mode == "Police" then
        TriggerEvent("CORRUPT:PoliceChat", source, message)
        return
    end
    if mode == "NHS" then
        TriggerEvent("CORRUPT:Nchat", source, message)
        return
    end
    if mode == "Admin" then
        TriggerEvent("CORRUPT:AdminChat", source, message)
        return
    end
    TriggerEvent("CORRUPT:Twitter", source, message)
    if not over then
        local upperMessage = string.upper(message)
        if upperMessage == theString then
            TriggerEvent("CORRUPT:ChatReward:Pay",source, theString, theReward)
            over = true 
        end
    end
end
local cooldown = {}
AddEventHandler('_chat:messageEntered', function(author, color, message, mode)
    author = exports["corrupt"]:GetDiscordName(source)
    if not message or not author then
        return
    end
    if not WasEventCanceled() then
        if cooldown[source] and not (os.time() > cooldown[source]) then
            TriggerClientEvent('chatMessage', source, "CORRUPT",  { 255, 255, 255 }, "You are being rate limited.", "alert", mode)
            return
        else
            cooldown[source] = nil
        end

		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('CORRUPT:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
        cooldown[source] = os.time() + 1
        routeMessage(source, author, message, mode)
    end
end)


AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = exports["corrupt"]:GetDiscordName(source)
    routeMessage(source, name, '/' .. command, nil, true)
    if not WasEventCanceled() then
        routeMessage(source, name, '/' .. command, nil, true)
    end
    CancelEvent()
end)

-- command suggestions for clients
local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end
AddEventHandler('chatMessage', function(Source, Name, Msg, mode)
    args = stringsplit(Msg, " ")
    CancelEvent()
    if string.find(args[1], "/") then
        local cmd = args[1]
        table.remove(args, 1)
	else
		TriggerClientEvent('chatMessage', -1, Name, { 255, 255, 255 }, Msg, mode)
	end
end)


AddEventHandler('chat:init', function()
    local source = source
    refreshCommands(source)

    for _, modeData in pairs(modes) do
        local clObj = {
            name = modeData.name,
            displayName = modeData.displayName,
            color = modeData.color or '#fff',
            isChannel = modeData.isChannel,
            isGlobal = modeData.isGlobal,
        }

        if not modeData.seObject or IsPlayerAceAllowed(source, modeData.seObject) then
            TriggerClientEvent('chat:addMode', source, clObj)
        end
    end
end)

AddEventHandler('onServerResourceStart', function(resName)
    Wait(500)

    for _, player in ipairs(GetPlayers()) do
        refreshCommands(player)
    end
end)

AddEventHandler('onResourceStop', function(resName)
    unregisterHooks(resName)
end)