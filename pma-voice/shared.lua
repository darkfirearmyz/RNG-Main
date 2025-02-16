Cfg = {}

voiceTarget = 1

gameVersion = GetGameName()

-- these are just here to satisfy linting
if not IsDuplicityVersion() then
	LocalPlayer = LocalPlayer
	playerServerId = GetPlayerServerId(PlayerId())
end
Player = Player
Entity = Entity

if GetConvar('voice_useNativeAudio', 'false') == 'true' then
	-- native audio distance seems to be larger then regular gta units
	Cfg.voiceModes = {
		{2.0, "Whisper"}, -- Whisper speech distance in gta distance units
		{6.0, "Normal"}, -- Normal speech distance in gta distance units
		{15.0, "Shouting"} -- Shout speech distance in gta distance units
	}
else
	Cfg.voiceModes = {
		{5.0, "Whisper"}, -- Whisper speech distance in gta distance units
		{10.0, "Normal"}, -- Normal speech distance in gta distance units
		{20.0, "Shouting"} -- Shout speech distance in gta distance units
	}
end

logger = {
	log = function(message, ...)
	end,
	info = function(message, ...)
		if GetConvarInt('voice_debugMode', 0) >= 1 then
		end
	end,
	warn = function(message, ...)
	end,
	error = function(message, ...)
		error((message):format(...))
	end,
	verbose = function(message, ...)
		if GetConvarInt('voice_debugMode', 0) >= 4 then
		end
	end,
}


function tPrint(tbl, indent)
end

local function types(args)
    local argType = type(args[1])
    for i = 2, #args do
        local arg = args[i]
        if argType == arg then
            return true, argType
        end
    end
    return false, argType
end

--- does a type check and errors if an invalid type is sent
---@param ... table a table with the variable being the first argument and the expected type being the second
function type_check(...)
    local vars = {...}
    for i = 1, #vars do
        local var = vars[i]
        local matchesType, varType = types(var)
        if not matchesType then
            table.remove(var, 1)
            error(("Invalid type sent to argument #%s, expected %s, got %s"):format(i, table.concat(var, "|"), varType))
        end
    end
end
