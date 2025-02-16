function handleInitialState()
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetVoiceChannel(playerServerId)

	while MumbleGetVoiceChannelFromServerId(playerServerId) ~= playerServerId do
		Wait(250)
		MumbleSetVoiceChannel(playerServerId)
	end

	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)

	addNearbyPlayers()
end
AddEventHandler('mumbleConnected', function(address, isReconnecting)
	logger.info('Connected to mumble server with address of %s, is this a reconnect %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address, isReconnecting)
	-- don't try to set channel instantly, we're still getting data.
	local voiceModeData = Cfg.voiceModes[mode]
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, true)

	handleInitialState()

	logger.log('Finished connection logic')
end)

AddEventHandler('mumbleDisconnected', function(address)
	logger.info('Disconnected from mumble server with address of %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address)
end)

-- TODO: Convert the last Cfg to a Convar, while still keeping it simple.
AddEventHandler('pma-voice:settingsCallback', function(cb)
	cb(Cfg)
end)

function handleInitialState()
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(voiceModeData[1] + 0.0)
	MumbleClearVoiceTarget(voiceTarget)
	MumbleSetVoiceTarget(voiceTarget)
	MumbleSetVoiceChannel(playerServerId)

	while MumbleGetVoiceChannelFromServerId(playerServerId) ~= playerServerId do
		Wait(250)
		MumbleSetVoiceChannel(playerServerId)
	end

	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)

	addNearbyPlayers()
end
AddEventHandler('mumbleConnected', function(address, isReconnecting)
	logger.info('Connected to mumble server with address of %s, is this a reconnect %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address, isReconnecting)
	-- don't try to set channel instantly, we're still getting data.
	local voiceModeData = Cfg.voiceModes[mode]
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance =  voiceModeData[1],
		mode = voiceModeData[2],
	}, true)

	handleInitialState()

	logger.log('Finished connection logic')
end)

AddEventHandler('mumbleDisconnected', function(address)
	logger.info('Disconnected from mumble server with address of %s', GetConvarInt('voice_hideEndpoints', 1) == 1 and 'HIDDEN' or address)
end)

-- TODO: Convert the last Cfg to a Convar, while still keeping it simple.
AddEventHandler('pma-voice:settingsCallback', function(cb)
	cb(Cfg)
end)



local wasProximityDisabledFromOverride = false
disableProximityCycle = false
local maxProximityMode = 1000
RegisterCommand('setvoiceintent', function(source, args)
	if GetConvarInt('voice_allowSetIntent', 1) == 1 then
		local intent = args[1]
		if intent == 'speech' then
			MumbleSetAudioInputIntent(`speech`)
		elseif intent == 'music' then
			MumbleSetAudioInputIntent(`music`)
		end
		LocalPlayer.state:set('voiceIntent', intent, true)
	end
end)

-- TODO: Better implementation of this?
RegisterCommand('vol', function(_, args)
	if not args[1] then return end
	setVolume(tonumber(args[1]))
end)

exports('setAllowProximityCycleState', function(state)
	type_check({state, "boolean"})
	disableProximityCycle = state
end)

function setProximityState(proximityRange, isCustom)
	local voiceModeData = Cfg.voiceModes[mode]
	MumbleSetTalkerProximity(proximityRange + 0.0)
	LocalPlayer.state:set('proximity', {
		index = mode,
		distance = proximityRange,
		mode = isCustom and "Custom" or voiceModeData[2],
	}, true)
	sendUIMessage({
		-- JS expects this value to be - 1, "custom" voice is on the last index
		voiceMode = isCustom and #Cfg.voiceModes or mode - 1
	})
end

exports("overrideProximityRange", function(range, disableCycle)
	type_check({range, "number"})
	setProximityState(range, true)
	if disableCycle then
		disableProximityCycle = true
		wasProximityDisabledFromOverride = true
	end
end)

exports("clearProximityOverride", function()
	local voiceModeData = Cfg.voiceModes[mode]
	setProximityState(voiceModeData[1], false)
	if wasProximityDisabledFromOverride then
		disableProximityCycle = false
	end
end)

RegisterCommand('cycleproximity', function()
	-- Proximity is either disabled, or manually overwritten.
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode + 1

	-- If we're within the range of our voice modes, allow the increase, otherwise reset to the first state
	if newMode <= #Cfg.voiceModes and newMode <= maxProximityMode then
		mode = newMode
	else
		mode = 1
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)

RegisterCommand('cycleproximitybackwards', function()
	-- Proximity is either disabled, or manually overwritten.
	if GetConvarInt('voice_enableProximityCycle', 1) ~= 1 or disableProximityCycle then return end
	local newMode = mode - 1

	-- If we're within the range of our voice modes, allow the increase, otherwise reset to the first state
	if newMode > 0 then
		mode = newMode
	else
		mode = #Cfg.voiceModes
		if mode > maxProximityMode then
			mode = maxProximityMode
		end
	end

	setProximityState(Cfg.voiceModes[mode][1], false)
	TriggerEvent('pma-voice:setTalkingMode', mode)
end, false)

if gameVersion == 'fivem' then
	RegisterKeyMapping('cycleproximity', 'Cycle Proximity', 'keyboard', 'PAGEUP')
	RegisterKeyMapping('cycleproximitybackwards', 'Cycle Proximity Backwards', 'keyboard', 'PAGEDOWN')
end

exports("setMaxProximityMode", function(maxMode)
	if maxMode > 0 then
		if mode > maxMode then
			mode = maxMode
			setProximityState(Cfg.voiceModes[mode][1], false)
			TriggerEvent('pma-voice:setTalkingMode', mode)
		end
		maxProximityMode = maxMode
	end
end)

exports("clearMaxProximityMode", function()
	maxProximityMode = 1000
end)

local uiReady = promise.new()
function sendUIMessage(message)
	Citizen.Await(uiReady)
	SendNUIMessage(message)
end

RegisterNUICallback("uiReady", function(data, cb)
	uiReady:resolve(true)

	cb('ok')
end)


local callChannel = 0

---function createCallThread
---creates a call thread to listen for key presses
local function createCallThread()
	CreateThread(function()
		local changed = false
		while callChannel ~= 0 do
			-- check if they're pressing voice keybinds
			if MumbleIsPlayerTalking(PlayerId()) and not changed then
				changed = true
				playerTargets(radioPressed and radioData or {}, callData)
				TriggerServerEvent('pma-voice:setTalkingOnCall', true)
			elseif changed and MumbleIsPlayerTalking(PlayerId()) ~= 1 then
				changed = false
				MumbleClearVoiceTargetPlayers(voiceTarget)
				TriggerServerEvent('pma-voice:setTalkingOnCall', false)
			end
			Wait(0)
		end
	end)
end

RegisterNetEvent('pma-voice:syncCallData', function(callTable, channel)
	callData = callTable
	for tgt, enabled in pairs(callTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'call')
		end
	end
end)

RegisterNetEvent('pma-voice:setTalkingOnCall', function(tgt, enabled)
	if tgt ~= playerServerId then
		callData[tgt] = enabled
		toggleVoice(tgt, enabled, 'call')
	end
end)

RegisterNetEvent('pma-voice:addPlayerToCall', function(plySource)
	callData[plySource] = false
end)

RegisterNetEvent('pma-voice:removePlayerFromCall', function(plySource)
	if plySource == playerServerId then
		for tgt, _ in pairs(callData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'call')
			end
		end
		callData = {}
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(radioPressed and radioData or {}, callData)
	else
		callData[plySource] = nil
		toggleVoice(plySource, false, 'call')
		if MumbleIsPlayerTalking(PlayerId()) then
			MumbleClearVoiceTargetPlayers(voiceTarget)
			playerTargets(radioPressed and radioData or {}, callData)
		end
	end
end)

function setCallChannel(channel)
	if GetConvarInt('voice_enableCalls', 1) ~= 1 then return end
	TriggerServerEvent('pma-voice:setPlayerCall', channel)
	callChannel = channel
	sendUIMessage({
		callInfo = channel
	})
	createCallThread()
end

exports('setCallChannel', setCallChannel)
exports('SetCallChannel', setCallChannel)

exports('addPlayerToCall', function(_call)
	local call = tonumber(_call)
	if call then
		setCallChannel(call)
	end
end)
exports('removePlayerFromCall', function()
	setCallChannel(0)
end)

RegisterNetEvent('pma-voice:clSetPlayerCall', function(_callChannel)
	if GetConvarInt('voice_enableCalls', 1) ~= 1 then return end
	callChannel = _callChannel
	createCallThread()
end)


local radioChannel = 0
local radioNames = {}
local disableRadioAnim = false

--- event syncRadioData
--- syncs the current players on the radio to the client
---@param radioTable table the table of the current players on the radio
---@param localPlyRadioName string the local players name
function syncRadioData(radioTable, localPlyRadioName)
	radioData = radioTable
	logger.info('[radio] Syncing radio table.')
	if GetConvarInt('voice_debugMode', 0) >= 4 then
		print('-------- RADIO TABLE --------')
		tPrint(radioData)
		print('-----------------------------')
	end
	for tgt, enabled in pairs(radioTable) do
		if tgt ~= playerServerId then
			toggleVoice(tgt, enabled, 'radio')
		end
	end
	sendUIMessage({
		radioChannel = radioChannel,
		radioEnabled = radioEnabled
	})
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[playerServerId] = localPlyRadioName
	end
end
RegisterNetEvent('pma-voice:syncRadioData', syncRadioData)

--- event setTalkingOnRadio
--- sets the players talking status, triggered when a player starts/stops talking.
---@param plySource number the players server id.
---@param enabled boolean whether the player is talking or not.
function setTalkingOnRadio(plySource, enabled)
	toggleVoice(plySource, enabled, 'radio')
	radioData[plySource] = enabled
	playMicClicks(enabled)
end
RegisterNetEvent('pma-voice:setTalkingOnRadio', setTalkingOnRadio)

--- event addPlayerToRadio
--- adds a player onto the radio.
---@param plySource number the players server id to add to the radio.
function addPlayerToRadio(plySource, plyRadioName)
	radioData[plySource] = false
	if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
		radioNames[plySource] = plyRadioName
	end
	if radioPressed then
		logger.info('[radio] %s joined radio %s while we were talking, adding them to targets', plySource, radioChannel)
		playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		logger.info('[radio] %s joined radio %s', plySource, radioChannel)
	end
end
RegisterNetEvent('pma-voice:addPlayerToRadio', addPlayerToRadio)

--- event removePlayerFromRadio
--- removes the player (or self) from the radio
---@param plySource number the players server id to remove from the radio.
function removePlayerFromRadio(plySource)
	if plySource == playerServerId then
		logger.info('[radio] Left radio %s, cleaning up.', radioChannel)
		for tgt, _ in pairs(radioData) do
			if tgt ~= playerServerId then
				toggleVoice(tgt, false, 'radio')
			end
		end
		sendUIMessage({
			radioChannel = 0,
			radioEnabled = radioEnabled
		})
		radioNames = {}
		radioData = {}
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
	else
		toggleVoice(plySource, false)
		if radioPressed then
			logger.info('[radio] %s left radio %s while we were talking, updating targets.', plySource, radioChannel)
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
		else
			logger.info('[radio] %s has left radio %s', plySource, radioChannel)
		end
		radioData[plySource] = nil
		if GetConvarInt("voice_syncPlayerNames", 0) == 1 then
			radioNames[plySource] = nil
		end
	end
end
RegisterNetEvent('pma-voice:removePlayerFromRadio', removePlayerFromRadio)

--- function setRadioChannel
--- sets the local players current radio channel and updates the server
---@param channel number the channel to set the player to, or 0 to remove them.
function setRadioChannel(channel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	type_check({channel, "number"})
	TriggerServerEvent('pma-voice:setPlayerRadio', channel)
	radioChannel = channel
end

--- exports setRadioChannel
--- sets the local players current radio channel and updates the server
exports('setRadioChannel', setRadioChannel)
-- mumble-voip compatability
exports('SetRadioChannel', setRadioChannel)

--- exports removePlayerFromRadio
--- sets the local players current radio channel and updates the server
exports('removePlayerFromRadio', function()
	setRadioChannel(0)
end)

--- exports addPlayerToRadio
--- sets the local players current radio channel and updates the server
---@param _radio number the channel to set the player to, or 0 to remove them.
exports('addPlayerToRadio', function(_radio)
	local radio = tonumber(_radio)
	if radio then
		setRadioChannel(radio)
	end
end)

--- exports toggleRadioAnim
--- toggles whether the client should play radio anim or not, if the animation should be played or notvaliddance
exports('toggleRadioAnim', function()
	disableRadioAnim = not disableRadioAnim
	TriggerEvent('pma-voice:toggleRadioAnim', disableRadioAnim)
end)

-- exports disableRadioAnim
--- returns whether the client is undercover or not
exports('getRadioAnimState', function()
	return disableRadioAnim
end)

--- check if the player is dead
--- seperating this so if people use different methods they can customize
--- it to their need as this will likely never be changed
--- but you can integrate the below state bag to your death resources.
--- LocalPlayer.state:set('isDead', true or false, false)
function isDead()
	if LocalPlayer.state.isDead then
		return true
	elseif IsPlayerDead(PlayerId()) then
		return true
	end
end

RegisterCommand('+radiotalk', function()
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	if isDead() or LocalPlayer.state.disableRadio then return end
	if getVolumes()["radio"] <= 0 then return end

	if not radioPressed and radioEnabled then
		if radioChannel > 0 then
			logger.info('[radio] Start broadcasting, update targets and notify server.')
			playerTargets(radioData, MumbleIsPlayerTalking(PlayerId()) and callData or {})
			TriggerServerEvent('pma-voice:setTalkingOnRadio', true)
			radioPressed = true
			playMicClicks(true)
			if GetConvarInt('voice_enableRadioAnim', 0) == 1 and not (GetConvarInt('voice_disableVehicleRadioAnim', 0) == 1 and IsPedInAnyVehicle(PlayerPedId(), false)) and not disableRadioAnim then
				RequestAnimDict('random@arrests')
				while not HasAnimDictLoaded('random@arrests') do
					Wait(10)
				end
				TaskPlayAnim(PlayerPedId(), "random@arrests", "generic_radio_enter", 8.0, 2.0, -1, 50, 2.0, 0, 0, 0)
				RemoveAnimDict("random@arrests")
			end
			CreateThread(function()
				TriggerEvent("pma-voice:radioActive", true)
				while radioPressed and not LocalPlayer.state.disableRadio do
					Wait(0)
					SetControlNormal(0, 249, 1.0)
					SetControlNormal(1, 249, 1.0)
					SetControlNormal(2, 249, 1.0)
				end
			end)
		end
	end
end, false)

RegisterCommand('-radiotalk', function()
	if (radioChannel > 0 or radioEnabled) and radioPressed then
		radioPressed = false
		MumbleClearVoiceTargetPlayers(voiceTarget)
		playerTargets(MumbleIsPlayerTalking(PlayerId()) and callData or {})
		TriggerEvent("pma-voice:radioActive", false)
		playMicClicks(false)
		if GetConvarInt('voice_enableRadioAnim', 0) == 1 then
			StopAnimTask(PlayerPedId(), "random@arrests", "generic_radio_enter", -4.0)
		end
		TriggerServerEvent('pma-voice:setTalkingOnRadio', false)
	end
end, false)
if gameVersion == 'fivem' then
	RegisterKeyMapping('+radiotalk', 'Talk over Radio', 'keyboard', GetConvar('voice_defaultRadio', 'LMENU'))
end

--- event syncRadio
--- syncs the players radio, only happens if the radio was set server side.
---@param _radioChannel number the radio channel to set the player to.
function syncRadio(_radioChannel)
	if GetConvarInt('voice_enableRadios', 1) ~= 1 then return end
	logger.info('[radio] radio set serverside update to radio %s', radioChannel)
	radioChannel = _radioChannel
end
RegisterNetEvent('pma-voice:clSetPlayerRadio', syncRadio)



AddEventHandler('onClientResourceStart', function(resource)
	if resource ~= GetCurrentResourceName() then
		return
	end

	-- Some people modify pma-voice and mess up the resource Kvp, which means that if someone
	-- joins another server that has pma-voice, it will error out, this will catch and fix the kvp.
	local success = pcall(function()
		local micClicksKvp = GetResourceKvpString('pma-voice_enableMicClicks')
		if not micClicksKvp then
			SetResourceKvp('pma-voice_enableMicClicks', "true")
		else
			if micClicksKvp ~= 'true' and micClicksKvp ~= 'false' then
				error('Invalid Kvp, throwing error for automatic fix')
			end
			micClicks = micClicksKvp
		end
	end)

	if not success then
		logger.warn('Failed to load resource Kvp, likely was inappropriately modified by another server, resetting the Kvp.')
		SetResourceKvp('pma-voice_enableMicClicks', "true")
		micClicks = 'true'
	end
	sendUIMessage({
		uiEnabled = GetConvarInt("voice_enableUi", 1) == 1,
		voiceModes = json.encode(Cfg.voiceModes),
		voiceMode = mode - 1
	})

	local radioChannel = LocalPlayer.state.radioChannel or 0
	local callChannel = LocalPlayer.state.callChannel or 0

	-- Reinitialize channels if they're set.
	if radioChannel ~= 0 then
		setRadioChannel(radioChannel)
	end

	if callChannel ~= 0 then
		setCallChannel(callChannel)
	end
end)


local mutedPlayers = {}

-- we can't use GetConvarInt because its not a integer, and theres no way to get a float... so use a hacky way it is!
local volumes = {
	-- people are setting this to 1 instead of 1.0 and expecting it to work.
	['radio'] = GetConvarInt('voice_defaultRadioVolume', 60) / 100,
	['call'] = GetConvarInt('voice_defaultCallVolume', 60) / 100,
}

radioEnabled, radioPressed, mode = true, false, GetConvarInt('voice_defaultVoiceMode', 2)
radioData = {}
callData = {}
submixIndicies = {}
--- function setVolume
--- Toggles the players volume
---@param volume number between 0 and 100
---@param volumeType string the volume type (currently radio & call) to set the volume of (opt)
function setVolume(volume, volumeType)
	type_check({volume, "number"})
	local volume = volume / 100

	if volumeType then
		local volumeTbl = volumes[volumeType]
		if volumeTbl then
			LocalPlayer.state:set(volumeType, volume, true)
			volumes[volumeType] = volume
			resyncVolume(volumeType, volume)
		else
			error(('setVolume got a invalid volume type %s'):format(volumeType))
		end
	else
		for volumeType, _ in pairs(volumes) do
			volumes[volumeType] = volume
			LocalPlayer.state:set(volumeType, volume, true)
		end
		resyncVolume("all", volume)
	end
end

function getVolumes()
	return volumes
end

exports('setRadioVolume', function(vol)
	setVolume(vol, 'radio')
end)
exports('getRadioVolume', function()
	return volumes['radio']
end)
exports("setCallVolume", function(vol)
	setVolume(vol, 'call')
end)
exports('getCallVolume', function()
	return volumes['call']
end)


-- default submix incase people want to fiddle with it.
-- freq_low = 389.0
-- freq_hi = 3248.0
-- fudge = 0.0
-- rm_mod_freq = 0.0
-- rm_mix = 0.16
-- o_freq_lo = 348.0
-- 0_freq_hi = 4900.0

if gameVersion == 'fivem' then
	local radioEffectId = CreateAudioSubmix('Radio')
	SetAudioSubmixEffectRadioFx(radioEffectId, 0)
	-- This is a GetHashKey on purpose, backticks break treesitter in nvim :|
	SetAudioSubmixEffectParamInt(radioEffectId, 0, GetHashKey('default'), 1)
	SetAudioSubmixOutputVolumes(
		radioEffectId,
		0,
		1.0 --[[ frontLeftVolume ]],
		0.25 --[[ frontRightVolume ]],
		0.0 --[[ rearLeftVolume ]],
		0.0 --[[ rearRightVolume ]],
		1.0 --[[ channel5Volume ]],
		1.0 --[[ channel6Volume ]]
	)
	AddAudioSubmixOutput(radioEffectId, 0)
	submixIndicies['radio'] = radioEffectId

	local callEffectId = CreateAudioSubmix('Call')
	SetAudioSubmixOutputVolumes(
		callEffectId,
		1,
		0.10 --[[ frontLeftVolume ]],
		0.50 --[[ frontRightVolume ]],
		0.0 --[[ rearLeftVolume ]],
		0.0 --[[ rearRightVolume ]],
		1.0 --[[ channel5Volume ]],
		1.0 --[[ channel6Volume ]]
	)
	AddAudioSubmixOutput(callEffectId, 1)
	submixIndicies['call'] = callEffectId

	-- Callback is expected to return data in an array, this is for compatibility sake with js, index 0 should be the name and index 1 should be the submixId
	exports("registerCustomSubmix", function(callback)
		local submixTable = callback()
		type_check({submixTable, "table"})
		local submixName, submixId = submixTable[1], submixTable[2]
		type_check({submixName, "string"}, {submixId, "number"})
		logger.info("Creating submix %s with submixId %s", submixName, submixId)
		submixIndicies[submixName] = submixId
	end)

	-- Trigger an event so resources can know when to register their submix
	-- Implementers will still have to do custom logic if their script has to restart during runtime
	TriggerEvent("pma-voice:registerCustomSubmixes")
end

--- export setEffectSubmix
--- Sets a user defined audio submix for radio and phonecall effects
---@param type string either "call" or "radio"
---@param effectId number submix id returned from CREATE_AUDIO_SUBMIX
exports("setEffectSubmix", function(type, effectId)
	type_check({type, "string"}, {effectId, "number"})
	if submixIndicies[type] then
		submixIndicies[type] = effectId
	end
end)

function restoreDefaultSubmix(plyServerId)
	local submix = Player(plyServerId).state.submix
	local submixEffect = submixIndicies[submix]
	if not submix or not submixEffect then
		MumbleSetSubmixForServerId(plyServerId, -1)
		return
	end
	MumbleSetSubmixForServerId(plyServerId, submixEffect)
end

-- used to prevent a race condition if they talk again afterwards, which would lead to their voice going to default.
local disableSubmixReset = {}
--- function toggleVoice
--- Toggles the players voice
---@param plySource number the players server id to override the volume for
---@param enabled boolean if the players voice is getting activated or deactivated
---@param moduleType string the volume & submix to use for the voice.
function toggleVoice(plySource, enabled, moduleType)
	if mutedPlayers[plySource] then return end
	logger.verbose('[main] Updating %s to talking: %s with submix %s', plySource, enabled, moduleType)
	local distance = currentTargets[plySource]
	if enabled and (not distance or distance > 4.0) then
		MumbleSetVolumeOverrideByServerId(plySource, enabled and volumes[moduleType])
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			if moduleType then
				disableSubmixReset[plySource] = true
				if submixIndicies[moduleType] then
					MumbleSetSubmixForServerId(plySource, submixIndicies[moduleType])
				end
			else
				restoreDefaultSubmix(plySource)
			end
		end
	elseif not enabled then
		if GetConvarInt('voice_enableSubmix', 1) == 1 and gameVersion == 'fivem' then
			-- garbage collect it
			disableSubmixReset[plySource] = nil
			SetTimeout(250, function()
				if not disableSubmixReset[plySource] then
					restoreDefaultSubmix(plySource)
				end
			end)
		end
		MumbleSetVolumeOverrideByServerId(plySource, -1.0)
	end
end

local function updateVolumes(voiceTable, override)
	for serverId, talking in pairs(voiceTable) do
		if not talking or serverId == playerServerId then goto skip_iter end
		MumbleSetVolumeOverrideByServerId(serverId, override)
		::skip_iter::
	end
end

--- resyncs the call/radio/etc volume to the new volume
---@param volumeType any
function resyncVolume(volumeType, newVolume)
	if volumeType == "all" then
		resyncVolume("radio", newVolume)
		resyncVolume("call", newVolume)
	elseif volumeType == "radio" then
		updateVolumes(radioData, newVolume)
	elseif volumeType == "call" then
		updateVolumes(callData, newVolume)
	end
end

--- function playerTargets
---Adds players voices to the local players listen channels allowing
---Them to communicate at long range, ignoring proximity range.
---@diagnostic disable-next-line: undefined-doc-param
---@param targets table expects multiple tables to be sent over
function playerTargets(...)
	local targets = {...}
	local addedPlayers = {
		[playerServerId] = true
	}

	for i = 1, #targets do
		for id, _ in pairs(targets[i]) do
			-- we don't want to log ourself, or listen to ourself
			if addedPlayers[id] and id ~= playerServerId then
				logger.verbose('[main] %s is already target don\'t re-add', id)
				goto skip_loop
			end
			if not addedPlayers[id] then
				logger.verbose('[main] Adding %s as a voice target', id)
				addedPlayers[id] = true
				MumbleAddVoiceTargetPlayerByServerId(voiceTarget, id)
			end
			::skip_loop::
		end
	end
end

--- function playMicClicks
---plays the mic click if the player has them enabled.
---@param clickType boolean whether to play the 'on' or 'off' click.
function playMicClicks(clickType)
	if micClicks ~= 'true' then return logger.verbose("Not playing mic clicks because client has them disabled") end
	-- TODO: Add customizable radio click volumes
	sendUIMessage({
		sound = (clickType and "audio_on" or "audio_off"),
		volume = (clickType and 0.1 or 0.03)
	})
end

--- getter for mutedPlayers
exports('getMutedPlayers', function()
	return mutedPlayers
end)

--- toggles the targeted player muted
---@param source number the player to mute
function toggleMutePlayer(source)
	if mutedPlayers[source] then
		mutedPlayers[source] = nil
		MumbleSetVolumeOverrideByServerId(source, -1.0)
	else
		mutedPlayers[source] = true
		MumbleSetVolumeOverrideByServerId(source, 0.0)
	end
end
exports('toggleMutePlayer', toggleMutePlayer)

function mutePlayer(source, flag)
	if flag then
		if not mutedPlayers[source] then
			mutedPlayers[source] = true
			MumbleSetVolumeOverrideByServerId(source, 0.0)
		end
	else
		if mutedPlayers[source] then
			mutedPlayers[source] = nil
			MumbleSetVolumeOverrideByServerId(source, -1.0)
		end
	end
end
exports("mutePlayer", mutePlayer)

--- function setVoiceProperty
--- sets the specified voice property
---@param type string what voice property you want to change (only takes 'radioEnabled' and 'micClicks')
---@param value any the value to set the type to.
function setVoiceProperty(type, value)
	if type == "radioEnabled" then
		radioEnabled = value
		sendUIMessage({
			radioEnabled = value
		})
	elseif type == "micClicks" then
		local val = tostring(value)
		micClicks = val
		SetResourceKvp('pma-voice_enableMicClicks', val)
	end
end
exports('setVoiceProperty', setVoiceProperty)
-- compatibility
exports('SetMumbleProperty', setVoiceProperty)
exports('SetTokoProperty', setVoiceProperty)


-- cache their external servers so if it changes in runtime we can reconnect the client.
local externalAddress = ''
local externalPort = 0
CreateThread(function()
	while true do
		Wait(500)
		-- only change if what we have doesn't match the cache
		if GetConvar('voice_externalAddress', '') ~= externalAddress or GetConvarInt('voice_externalPort', 0) ~= externalPort then
			externalAddress = GetConvar('voice_externalAddress', '')
			externalPort = GetConvarInt('voice_externalPort', 0)
			MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		end
	end
end)


if gameVersion == 'redm' then
	CreateThread(function()
		while true do
			if IsControlJustPressed(0, 0xA5BDCD3C --[[ Right Bracket ]]) then
				ExecuteCommand('cycleproximity')
			end
			if IsControlJustPressed(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('+radiotalk')
			elseif IsControlJustReleased(0, 0x430593AA --[[ Left Bracket ]]) then
				ExecuteCommand('-radiotalk')
			end

			Wait(0)
		end
	end)
end

RegisterCommand('vsync', function()
	if GetEntityHealth(PlayerPedId()) <= 102 then
		return
	end
	print('[vsync] disconnecting from voice server')
	MumbleSetActive(false)
	Wait(2000)
	MumbleSetActive(true)
	if GetConvar('voice_externalAddress', '') ~= '' and GetConvarInt('voice_externalPort', 0) ~= 0 then
		MumbleSetServerAddress(GetConvar('voice_externalAddress', ''), GetConvarInt('voice_externalPort', 0))
		while not MumbleIsConnected() do
			Wait(250)
		end
	end
	print('[vsync] connected to voice server')
end, false)

-- used when muted
local disableUpdates = false
local isListenerEnabled = false
local plyCoords = GetEntityCoords(PlayerPedId())
proximity = MumbleGetTalkerProximity()
currentTargets = {}

function orig_addProximityCheck(ply)
	local tgtPed = GetPlayerPed(ply)
	local voiceRange = GetConvar('voice_useNativeAudio', 'false') == 'true' and proximity * 3 or proximity
	local distance = #(plyCoords - GetEntityCoords(tgtPed))
	return distance < voiceRange, distance 
end
local addProximityCheck = orig_addProximityCheck

exports("overrideProximityCheck", function(fn)
	addProximityCheck = fn
end)

exports("resetProximityCheck", function()
	addProximityCheck = orig_addProximityCheck
end)

function addNearbyPlayers()
	if disableUpdates then return end
	-- update here so we don't have to update every call of addProximityCheck
	plyCoords = GetEntityCoords(PlayerPedId())
	proximity = MumbleGetTalkerProximity()
	currentTargets = {}
	MumbleClearVoiceTargetChannels(voiceTarget)
	if LocalPlayer.state.disableProximity then return end
	MumbleAddVoiceChannelListen(playerServerId)
	MumbleAddVoiceTargetChannel(voiceTarget, playerServerId)
	local players = GetActivePlayers()
	for i = 1, #players do
		local ply = players[i]
		local serverId = GetPlayerServerId(ply)
		local shouldAdd, distance = addProximityCheck(ply)
		if shouldAdd then
			-- if distance then
			-- 	currentTargets[serverId] = distance
			-- else
			-- 	-- backwards compat, maybe remove in v7 
			-- 	currentTargets[serverId] = 15.0
			-- end
			-- logger.verbose('Added %s as a voice target', serverId)
			MumbleAddVoiceTargetChannel(voiceTarget, serverId)
		end
	end
end

function setSpectatorMode(enabled)
	logger.info('Setting spectate mode to %s', enabled)
	isListenerEnabled = enabled
	local players = GetActivePlayers()
	if isListenerEnabled then
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			logger.verbose("Adding %s to listen table", serverId)
			MumbleAddVoiceChannelListen(serverId)
			::skip_loop::
		end
	else
		for i = 1, #players do
			local ply = players[i]
			local serverId = GetPlayerServerId(ply)
			if serverId == playerServerId then goto skip_loop end
			logger.verbose("Removing %s from listen table", serverId)
			MumbleRemoveVoiceChannelListen(serverId)
			::skip_loop::
		end
	end
end

RegisterNetEvent('onPlayerJoining', function(serverId)
	if isListenerEnabled then
		MumbleAddVoiceChannelListen(serverId)
		logger.verbose("Adding %s to listen table", serverId)
	end
end)

RegisterNetEvent('onPlayerDropped', function(serverId)
	if isListenerEnabled then
		MumbleRemoveVoiceChannelListen(serverId)
		logger.verbose("Removing %s from listen table", serverId)
	end
end)

local listenerOverride = false
exports("setListenerOverride", function(enabled)
	type_check({enabled, "boolean"})
	listenerOverride = enabled
end)

-- cache talking status so we only send a nui message when its not the same as what it was before
local lastTalkingStatus = false
local lastRadioStatus = false
local voiceState = "proximity"
CreateThread(function()
	TriggerEvent('chat:addSuggestion', '/muteply', 'Mutes the player with the specified id', {
		{ name = "player id", help = "the player to toggle mute" },
		{ name = "duration", help = "(opt) the duration the mute in seconds (default: 900)" }
	})
	while true do
		-- wait for mumble to reconnect
		while not MumbleIsConnected() do
			Wait(100)
		end
		-- Leave the check here as we don't want to do any of this logic 
		if GetConvarInt('voice_enableUi', 1) == 1 then
			local curTalkingStatus = MumbleIsPlayerTalking(PlayerId()) == 1
			if lastRadioStatus ~= radioPressed or lastTalkingStatus ~= curTalkingStatus then
				lastRadioStatus = radioPressed
				lastTalkingStatus = curTalkingStatus
				sendUIMessage({
					usingRadio = lastRadioStatus,
					talking = lastTalkingStatus
				})
			end
		end

		if voiceState == "proximity" then
			addNearbyPlayers()
			-- What a name, wowza
			local cam = GetConvarInt("voice_disableAutomaticListenerOnCamera", 0) ~= 1 and GetRenderingCam() or -1
			local isSpectating = NetworkIsInSpectatorMode() or cam ~= -1
			if not isListenerEnabled and (isSpectating or listenerOverride) then
				setSpectatorMode(true)
			elseif isListenerEnabled and not isSpectating and not listenerOverride then
				setSpectatorMode(false)
			end
		end

		Wait(GetConvarInt('voice_refreshRate', 200))
	end
end)

exports("setVoiceState", function(_voiceState, channel)
	if _voiceState ~= "proximity" and _voiceState ~= "channel" then
		logger.error("Didn't get a proper voice state, expected proximity or channel, got %s", _voiceState)
	end
	voiceState = _voiceState
	if voiceState == "channel" then
		type_check({channel, "number"})
		-- 65535 is the highest a client id can go, so we add that to the base channel so we don't manage to get onto a players channel
		channel = channel + 65535
		MumbleSetVoiceChannel(channel)
		while MumbleGetVoiceChannelFromServerId(playerServerId) ~= channel do
			Wait(250)
		end
		MumbleAddVoiceTargetChannel(voiceTarget, channel)
	elseif voiceState == "proximity" then
		handleInitialState()
	end
end)


AddEventHandler("onClientResourceStop", function(resource)
	if type(addProximityCheck) == "table" then
		local proximityCheckRef = addProximityCheck.__cfx_functionReference
		if proximityCheckRef then
			local isResource = string.match(proximityCheckRef, resource)
			if isResource then
				addProximityCheck = orig_addProximityCheck
				logger.warn('Reset proximity check to default, the original resource [%s] which provided the function restarted', resource)
			end
		end
	end
end)


AddStateBagChangeHandler("submix", "", function(bagName, _, value)
    local tgtId = tonumber(bagName:gsub('player:', ''), 10)
    if not tgtId then return end
    logger.info("%s had their submix set to %s", tgtId, value)
    -- We got an invalid submix, discard we don't care about it
    if value and not submixIndicies[value] then return logger.warn("Player %s applied submix %s but it isn't valid", tgtId, value) end
    -- we don't want to reset submix if the player is talking on the radio
    if not value and not radioData[tgtId] and not callData[tgtId] then
      logger.info("Resetting submix for player %s", tgtId)
      MumbleSetSubmixForServerId(tgtId, -1)
      return
    end
    MumbleSetSubmixForServerId(tgtId, submixIndicies[value])
  end)
  