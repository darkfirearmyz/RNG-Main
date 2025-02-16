local chatCooldown = {}
local lastmsg = nil
blockedWords = {
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

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(3000)
		for k,v in pairs(chatCooldown) do
			chatCooldown[k] = nil
		end
	end
end)

RegisterCommand("anon", function(source, args)
	local message = table.concat(args, " ")
	TriggerEvent("CORRUPT:Anon", source, message)
end)

RegisterServerEvent("CORRUPT:Anon", function(source, args)
    if #args <= 0 then 
		return 
	end
	local source = source
	local name = CORRUPT.getPlayerName(source)
    local message = args
	local user_id = CORRUPT.getUserId(source)
	if not chatCooldown[source] then
		if name then 
			for word in pairs(blockedWords) do
				if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(message:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
					TriggerClientEvent('CORRUPT:chatFilterScaleform', source, 10, 'That word is not allowed.')
					CancelEvent()
					return
				end
			end
			CORRUPT.sendWebhook('anon', "Corrupt Chat Logs", "```"..message.."```".."\n> Player Name: **"..CORRUPT.getPlayerName(source).."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
			TriggerClientEvent('chatMessage', -1, "^4Global @^1Anonymous: ", { 128, 128, 128 }, message, "ooc", "Anonymous")
			chatCooldown[source] = true
		end
	else
		TriggerClientEvent('chatMessage', source, "^1[CORRUPT]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert", "OOC")
		chatCooldown[source] = true
	end
end)

function CORRUPT.ooc(source, args, raw)
	if #args <= 0 then 
		return 
	end
	local source = source
	local name = CORRUPT.getPlayerName(source)
	local message = args
	local user_id = CORRUPT.getUserId(source)
	local gangtag = CORRUPT.getGangTag(user_id)
	if not chatCooldown[source] then 
		for word in pairs(blockedWords) do
			if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(args:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
				TriggerClientEvent('CORRUPT:chatFilterScaleform', source, 10, 'That word is not allowed.')
				CancelEvent()
				return
			end
		end
		if gangtag and gangtag ~= "" then
			name = "["..gangtag.."] "..name
		end
		if CORRUPT.hasGroup(user_id, "Founder") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Founder ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif CORRUPT.hasGroup(user_id, "Lead Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^8 Lead Developer ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif CORRUPT.hasGroup(user_id, "Developer") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Developer ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
		elseif CORRUPT.hasGroup(user_id, "Operations Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Operations Manager ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
		elseif CORRUPT.hasGroup(user_id, "Community Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^1 Community Manager ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Staff Manager") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^6 Staff Manager ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Head Administrator") and user_id ~= 61 then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Head Administrator ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")	
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Senior Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^3 Senior Administrator ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "OOC")	
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Administrator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^4 Administrator ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")			
			chatCooldown[source] = true			
		elseif CORRUPT.hasGroup(user_id, "Senior Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Senior Moderator ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Moderator") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Moderator ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")				
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Support Team") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^2 Support Team ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Trial Staff") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7^r |^5 Trial Staff ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Baller") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^3" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Rainmaker") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^4" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Kingpin") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^1" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Supreme") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^5" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Premium") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^6" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		elseif CORRUPT.hasGroup(user_id, "Supporter") then
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^2" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		else
			TriggerClientEvent('chatMessage', -1, "^7OOC ^7 | ^7" .. name .."^7 : " , { 128, 128, 128 }, message, "ooc", "OOC")
			chatCooldown[source] = true
		end
		CORRUPT.sendWebhook('ooc', "Corrupt Chat Logs", "```"..message.."```".."\n> Player Name: **"..name.."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
	else
		TriggerClientEvent('chatMessage', source, "^1[CORRUPT]", { 128, 128, 128 }, " Chat Spam | Retry in 3 Seconds", "alert", "OOC")
		chatCooldown[source] = true
	end
end
RegisterServerEvent("CORRUPT:ooc", function(source, args)
	CORRUPT.ooc(source, args)
end)

RegisterCommand("ooc", function(source, args, raw)
    local message = table.concat(args, " ")
    CORRUPT.ooc(source, message)
end)

RegisterCommand("/", function(source, args, raw)
	local message = table.concat(args, " ")
	message = message:sub(1)
    CORRUPT.ooc(source, message)
end)





RegisterCommand('cc', function(source, args, rawCommand)
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasPermission(user_id, 'admin.ban') then
        TriggerClientEvent('chat:clear',-1)             
    end
end, false)


RegisterServerEvent("CORRUPT:Twitter")
AddEventHandler("CORRUPT:Twitter", function(source,message)
	local name = CORRUPT.getPlayerName(source)
	local user_id = CORRUPT.getUserId(source)
	TriggerClientEvent('chatMessage', -1, "Global @"..name..":",  { 255, 255, 255 }, message, "twt", "Global")
	CORRUPT.sendWebhook("twitter", "Corrupt Chat Logs", "```"..message.."```".."\n> Player Name: **"..name.."**\n> Player PermID: **"..user_id.."**\n> Player TempID: **"..source.."**")
end)
--Function
function stringsplit(inputstr, sep)
	if sep == nil then
		sep = "%s"
	end
	local t={} ; i=1
	for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
		t[i] = str
		i = i + 1
	end
	return t
end

function cleanMessage(message)
	local replacements = {
	  [" "] = "",
	  ["-"] = "",
	  ["."] = "",
	  ["$"] = "s",
	  ["€"] = "e",
	  [","] = "",
	  [";"] = "",
	  [":"] = "",
	  ["*"] = "",
	  ["_"] = "",
	  ["|"] = "",
	  ["/"] = "",
	  ["<"] = "",
	  [">"] = "",
	  ["ß"] = "ss",
	  ["&"] = "",
	  ["+"] = "",
	  ["¦"] = "",
	  ["§"] = "s",
	  ["°"] = "",
	  ["#"] = "",
	  ["@"] = "a",
	  ["\""] = "",
	  ["("] = "",
	  [")"] = "",
	  ["="] = "",
	  ["?"] = "",
	  ["!"] = "",
	  ["´"] = "",
	  ["`"] = "",
	  ["'"] = "",
	  ["^"] = "",
	  ["~"] = "",
	  ["["] = "",
	  ["]"] = "",
	  ["{"] = "",
	  ["}"] = "",
	  ["£"] = "e",
	  ["¨"] = "",
	  ["ç"] = "c",
	  ["¬"] = "",
	  ["\\"] = "",
	  ["1"] = "i",
	  ["3"] = "e",
	  ["4"] = "a",
	  ["5"] = "s",
	  ["0"] = "o"
	}
  
	local finalmessage = message:lower()
	finalmessage = finalmessage:gsub(".", function(c)
	  return replacements[c] or c
	end)
  
	return finalmessage
  end