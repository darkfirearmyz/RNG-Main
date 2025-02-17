local isInVehControl = false
local windowState1 = true
local windowState2 = true
local windowState3 = true
local windowState4 = true
local DisableSeatShuffle = true
local LeaveRunning = true


-- Vehicle Speed Limiter
local k = {
    vehicle = nil,
    adSpeed = 1,
    limiterSpeed = 1,
    limiter = false,
    predictedMax = nil,
    door = 1,
    limitingVehicle = nil,
    currentLimit = nil,
    adMode = 1
}
local l = false
local m = false
local n = false
local o = false
local p = false
local q = 0
local r = true
local s = false
local t = 1

Citizen.CreateThread(
    function()
        while true do
            if m and CORRUPT.getPlayerVehicle() ~= k.limitingVehicle then
                m = false
                SetVehicleMaxSpeed(CORRUPT.getPlayerVehicle(), k.predictedMax)
                predictedMax = nil
                tvRP.notify("~r~Vehicle Changed, stopping limiter")
            end
            Wait(500)
        end
    end
)
function convert(speed)
    return speed * 10 * 0.44704 - 0.5
end






function limiter(speedlimtmph)
    speedlimtmph = tonumber(speedlimtmph / 10)
    if speedlimtmph then
        k.limiterSpeed = speedlimtmph
        k.limiter = true
        tvRP.notify("~gSpeed Limiter: ~w~" .. speedlimtmph .. " MPH")
    else
        tvRP.notify("~r~ERROR~w~: Invalid Speed")
    end
    Citizen.CreateThread(
        function()
            while k.limiter do
                local z = CORRUPT.getPlayerVehicle()
                local speed = k.limiterSpeed
                if z ~= 0 then
                    k.limitingVehicle = z
                    m = true
                    k.predictedMax = GetVehicleEstimatedMaxSpeed(z)
                    if convert(speed) > k.predictedMax then
                        SetVehicleMaxSpeed(z, k.predictedMax)
                        k.currentLimit = k.predictedMax
                    else
                        SetVehicleMaxSpeed(z, convert(speed))
                        k.currentLimit = convert(speed)
                    end
                else
                    k.limiter = false
                end
                Wait(100)
            end
            SetVehicleMaxSpeed(k.limitingVehicle, k.predictedMax)
            p = false
            m = false
        end
    )
end

function GetVehicleSpeedLimt()
    AddTextEntry("FMMC_MPM_NA", "Enter Speed Limit | To Disable, Enter 0")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local L = GetOnscreenKeyboardResult()
        return L
    end
    return nil
end

RegisterCommand("vehcontrol", function(source, args, rawCommand)
	if IsPedInAnyVehicle(PlayerPedId(), false) and not IsPauseMenuActive() then
		openVehControl()
	end
end, false)

RegisterKeyMapping('vehcontrol', 'Open Vehicle Menu', 'keyboard', "M")

function openExternal()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		openVehControl()
	end
end

function openVehControl()
	isInVehControl = true
	SetNuiFocus(true, true)
	SendNUIMessage({
		type = "openGeneral"
	})
end

function closeVehControl()
	isInVehControl = false
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "closeAll"
	})
end

RegisterNUICallback('vehicle-NUIFocusOff', function()
	isInVehControl = false
	SetNuiFocus(false, false)
	SendNUIMessage({
		type = "closeAll"
	})
end)

RegisterNUICallback('vehicle-ignition', function()
    EngineControl()
end)
function convert(speed)
    return speed * 10 * 0.44704 - 0.5
end
RegisterNUICallback('vehicle-speedlimit', function()
    local speed = GetEntitySpeed(CORRUPT.getPlayerVehicle())
    if convert(speed) < 10.0 then
        isInVehControl = false
        SetNuiFocus(false, false)
        SendNUIMessage({
            type = "closeAll"
        })
        speedlimtmph = GetVehicleSpeedLimt()
        limiter(speedlimtmph)
    else
        tvRP.notify("~r~Alert~w~: Please slow down to enable the speed limiter.")
    end
end)


RegisterNUICallback('vehicle-interiorLight', function()
	InteriorLightControl()
end)

RegisterNUICallback('vehicle-doors', function(data, cb)
	DoorControl(data.door)
end)

RegisterNUICallback('vehicle-seatchange', function(data, cb)
	SeatControl(data.seat)
end)

RegisterNUICallback('vehicle-windows', function(data, cb)
	WindowControl(data.window, data.door)
end)
function EngineControl()
    local vehicle = GetVehiclePedIsIn(PlayerPedId(), false)
    if vehicle ~= nil and vehicle ~= 0 and GetPedInVehicleSeat(vehicle, 0) then
        SetVehicleEngineOn(vehicle, (not GetIsVehicleEngineRunning(vehicle)), false, true)
    end
end

function InteriorLightControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if IsVehicleInteriorLightOn(vehicle) then
			SetVehicleInteriorlight(vehicle, false)
		else
			SetVehicleInteriorlight(vehicle, true)
		end
	end
end

function DoorControl(door)
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if GetVehicleDoorAngleRatio(vehicle, door) > 0.0 then
			SetVehicleDoorShut(vehicle, door, false)
		else
			SetVehicleDoorOpen(vehicle, door, false)
		end
	end
end
local cooldown = false
function SeatControl(seat)
    if cooldown == false then
        cooldown = true
        local playerPed = GetPlayerPed(-1)
        if (IsPedSittingInAnyVehicle(playerPed)) then
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if IsVehicleSeatFree(vehicle, seat) then
                SetPedIntoVehicle(GetPlayerPed(-1), vehicle, seat)
            end
        end
        Citizen.Wait(1000)
        cooldown = false
    else
        tvRP.notify("~r~Alert~w~: Please wait before changing seats again.")
    end
end

function WindowControl(window, door)
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if window == 0 then
			if windowState1 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState1 = false
			else
				RollUpWindow(vehicle, window)
				windowState1 = true
			end
		elseif window == 1 then
			if windowState2 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState2 = false
			else
				RollUpWindow(vehicle, window)
				windowState2 = true
			end
		elseif window == 2 then
			if windowState3 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState3 = false
			else
				RollUpWindow(vehicle, window)
				windowState3 = true
			end
		elseif window == 3 then
			if windowState4 == true and DoesVehicleHaveDoor(vehicle, door) then
				RollDownWindow(vehicle, window)
				windowState4 = false
			else
				RollUpWindow(vehicle, window)
				windowState4 = true
			end
		end
	end
end

function FrontWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState1 == true or windowState2 == true then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			windowState1 = false
			windowState2 = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			windowState1 = true
			windowState2 = true
		end
	end
end

function BackWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState3 == true or windowState4 == true then
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState3 = false
			windowState4 = false
		else
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState3 = true
			windowState4 = true
		end
	end
end

function AllWindowControl()
	local playerPed = GetPlayerPed(-1)
	if (IsPedSittingInAnyVehicle(playerPed)) then
		local vehicle = GetVehiclePedIsIn(playerPed, false)
		if windowState1 == true or windowState2 == true or windowState3 == true or windowState4 == true then
			RollDownWindow(vehicle, 0)
			RollDownWindow(vehicle, 1)
			RollDownWindow(vehicle, 2)
			RollDownWindow(vehicle, 3)
			windowState1 = false
			windowState2 = false
			windowState3 = false
			windowState4 = false
		else
			RollUpWindow(vehicle, 0)
			RollUpWindow(vehicle, 1)
			RollUpWindow(vehicle, 2)
			RollUpWindow(vehicle, 3)
			windowState1 = true
			windowState2 = true
			windowState3 = true
			windowState4 = true
		end
	end
end

TriggerEvent('chat:addSuggestion', '/engine', 'Start/Stop Engine')
RegisterCommand("engine", function(source, args, rawCommand)
	EngineControl()
end, false)

TriggerEvent('chat:addSuggestion', '/door', 'Open/Close Vehicle Door', {
	{ name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})
RegisterCommand("door", function(source, args, rawCommand)
	local doorID = tonumber(args[1])
	if doorID ~= nil then
		if doorID == 1 then
			DoorControl(0)
		elseif doorID == 2 then
			DoorControl(1)
		elseif doorID == 3 then
			DoorControl(2)
		elseif doorID == 4 then
			DoorControl(3)
		end
	else
		TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/door [door id]")
	end
end, false)
TriggerEvent('chat:addSuggestion', '/seat', 'Move to a seat', {
	{ name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})
RegisterCommand("seat", function(source, args, rawCommand)
	local seatID = tonumber(args[1])
	if seatID ~= nil then
		if seatID == 1 then
			SeatControl(-1)
		elseif seatID == 2 then
			SeatControl(0)
		elseif seatID == 3 then
			SeatControl(1)
		elseif seatID == 4 then
			SeatControl(2)
		end
	else
		TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/seat [seat id]")
	end
end, false)

TriggerEvent('chat:addSuggestion', '/window', 'Roll Up/Down Window', {
	{ name="ID", help="1) Driver, 2) Passenger, 3) Driver Side Rear, 4) Passenger Side Rear" }
})
RegisterCommand("window", function(source, args, rawCommand)
	local windowID = tonumber(args[1])
	if windowID ~= nil then
		if windowID == 1 then
			WindowControl(0, 0)
		elseif windowID == 2 then
			WindowControl(1, 1)
		elseif windowID == 3 then
			WindowControl(2, 2)
		elseif windowID == 4 then
			WindowControl(3, 3)
		end
	else
		TriggerEvent("chatMessage", "Usage: ", {255, 0, 0}, "/window [door id]")
	end
end, false)
TriggerEvent('chat:addSuggestion', '/hood', 'Open/Close Hood')
RegisterCommand("hood", function(source, args, rawCommand)
	DoorControl(4)
end, false)
TriggerEvent('chat:addSuggestion', '/trunk', 'Open/Close Trunk')

RegisterCommand("trunk", function(source, args, rawCommand)
	DoorControl(5)
end, false)

TriggerEvent('chat:addSuggestion', '/windowfront', 'Roll Up/Down Front Windows')

RegisterCommand("windowfront", function(source, args, rawCommand)
	FrontWindowControl()
end, false)
TriggerEvent('chat:addSuggestion', '/windowback', 'Roll Up/Down Back Windows')

RegisterCommand("windowback", function(source, args, rawCommand)
	BackWindowControl()
end, false)

TriggerEvent('chat:addSuggestion', '/windowall', 'Roll Up/Down All Windows')

RegisterCommand("windowall", function(source, args, rawCommand)
	AllWindowControl()
end, false)

RegisterCommand("vehcontrolclose", function(source, args, rawCommand)
	closeVehControl()
end, false)

function DisplayHelpText(str)
	SetTextComponentFormat("STRING")
	AddTextComponentString(str)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
