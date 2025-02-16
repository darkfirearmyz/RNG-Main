local a = false
RegisterCommand(
    "flipcar",
    function()
        local b, c = CORRUPT.getPlayerVehicle()
        if b == 0 then
            tvRP.notify("You are not in a vehicle")
            return
        end
        if not c then
            tvRP.notify("You are not the driver of this vehicle")
            return
        end
        if GetIsVehicleEngineRunning(b) then
            tvRP.notify("You must have the engine off to flip the vehicle")
            return
        end
        if IsVehicleOnAllWheels(b) then
            tvRP.notify("Your vehicle does not require flipping")
            return
        end
        if a then
            tvRP.notify("Your vehicle is already waiting to be flipped")
            return
        end
        a = true
        tvRP.notify("Flipping your vehicle in 30 seconds. Please remain stationary")
        local d = CORRUPT.getPlayerPed()
        local e = GetEntityHealth(d)
        local f = GetGameTimer()
        while GetGameTimer() - f < 30000 do
            if CORRUPT.getPlayerVehicle() ~= b then
                tvRP.notify("Cancelling flip as you left the vehicle")
                a = false
                return
            end
            if GetEntityHealth(d) ~= e then
                tvRP.notify("Cancelling flip as you recieved damage")
                a = false
                return
            end
            if GetEntitySpeed(b) >= 4.4704 then
                tvRP.notify("Cancelling flip as you are not stationary")
                a = false
                return
            end
            if GetIsVehicleEngineRunning(b) then
                tvRP.notify("Cancelling flip as you turned the engine on")
                a = false
                return
            end
            Citizen.Wait(0)
        end
        SetVehicleOnGroundProperly(b)
        tvRP.notify("Your vehicle has been flipped")
        a = false
    end
)
