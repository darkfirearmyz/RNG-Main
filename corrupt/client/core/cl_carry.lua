carryingBackInProgress = false
local a = ""
local b = ""
local c = 0
local d = vector3(1117.671, 218.7382, -49.4)
local e = false
distanceToCasino = 1000
TriggerEvent("chat:addSuggestion", "/carry", "Carry the nearest player")
RegisterCommand(
    "carry",
    function(f, g)
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            drawNativeNotification("You cannot carry someone whilst you are in a vehicle!")
        else
            if
                not globalPlayerInPrisonZone and not inOrganHeist or tvRP.isStaffedOn() or
                    CORRUPT.isDeveloper()
             then
                if GetEntityHealth(CORRUPT.getPlayerPed()) > 102 then
                    local h = GetEntityCoords(CORRUPT.getPlayerPed())
                    distanceToCasino = #(h - d)
                    if
                        not carryingBackInProgress and
                            (distanceToCasino > 200 or tvRP.isStaffedOn() or
                                CORRUPT.isDeveloper())
                     then
                        local i = CORRUPT.getPlayerPed()
                        local j = GetClosestPlayer(3)
                        if j ~= -1 then
                            target = GetPlayerServerId(j)
                            if GetEntityHealth(GetPlayerPed(j)) ~= 0 then
                                if
                                    not tvRP.isStaffedOn() and not globalLFBOnDuty and
                                        not CORRUPT.isDeveloper()
                                 then
                                    TriggerServerEvent("CarryPeople:requestCarry", target)
                                else
                                    TriggerServerEvent(
                                        "CarryPeople:sync",
                                        GetPlayerServerId(CORRUPT.getPlayerId()),
                                        target
                                    )
                                end
                            else
                                drawNativeNotification("Cannot carry dead people!")
                            end
                        else
                            drawNativeNotification("No one nearby to carry!")
                        end
                    else
                        local k = CORRUPT.getPlayerPed()
                        carryingBackInProgress = false
                        ClearPedSecondaryTask(k)
                        DetachEntity(k, true, false)
                        local j = GetClosestPlayer(3)
                        target = GetPlayerServerId(j)
                        if target ~= 0 then
                            TriggerServerEvent("CarryPeople:stop", target)
                        end
                    end
                end
            else
                tvRP.notify("~r~You cannot carry in the prison or the organ heist.")
            end
        end
    end,
    false
)
RegisterNetEvent(
    "CarryPeople:carryRequest",
    function()
        tvRP.notify("Someone is trying to carry you, press (~y~Y~w~) to accept (~r~L~w~) to refuse")
        e = true
        Citizen.CreateThread(
            function()
                while e do
                    if IsControlJustPressed(0, 246) then
                        tvRP.notify("~g~Request Accepted")
                        ExecuteCommand("carryaccept")
                        e = false
                    elseif IsControlJustPressed(0, 182) then
                        tvRP.notify("~r~Request Refused")
                        ExecuteCommand("carryrefuse")
                        e = false
                    end
                    Wait(0)
                end
            end
        )
        Citizen.Wait(15000)
        e = false
    end
)
Citizen.CreateThread(
    function()
        while true do
            Wait(5)
            if carryingBackInProgress then
                local l = CORRUPT.getPlayerPed()
                local m, n = CORRUPT.getPlayerVehicle()
                if m ~= 0 and n then
                    TriggerServerEvent("CarryPeople:stop", target)
                    carryingBackInProgress = false
                    ClearPedTasks(l)
                    StopAnimTask(l, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 0)
                    drawNativeNotification("You cannot carry someone whilst you are in a vehicle!")
                end
                if not tvRP.isStaffedOn() and IsPedFalling(l) and CORRUPT.isDeveloper() then
                    TriggerServerEvent("CarryPeople:stop", target)
                    carryingBackInProgress = false
                    ClearPedTasks(l)
                    StopAnimTask(l, "missfinale_c2mcs_1", "fin_c2_mcs_1_camman", 0)
                    drawNativeNotification("You cannot carry someone whilst you are falling")
                end
            end
        end
    end
)
RegisterNetEvent(
    "CarryPeople:syncTarget",
    function(target, o, p, q, r, s, t, u, v)
        local l = CORRUPT.getPlayerPed()
        local w = GetPlayerPed(GetPlayerFromServerId(target))
        carryingBackInProgress = true
        RequestAnimDict(o)
        while not HasAnimDictLoaded(o) do
            Citizen.Wait(10)
        end
        if u == nil then
            u = 180.0
        end
        AttachEntityToEntity(CORRUPT.getPlayerPed(), w, 0, r, q, s, 0.5, 0.5, u, false, false, false, false, 2, false)
        if v == nil then
            v = 0
        end
        TaskPlayAnim(l, o, p, 8.0, -8.0, t, v, 0, false, false, false)
        RemoveAnimDict(o)
        a = p
        b = o
        c = v
    end
)
RegisterNetEvent(
    "CarryPeople:syncMe",
    function(o, x, t, v)
        local l = CORRUPT.getPlayerPed()
        carryingBackInProgress = true
        RequestAnimDict(o)
        while not HasAnimDictLoaded(o) do
            Citizen.Wait(10)
        end
        Wait(500)
        if v == nil then
            v = 0
        end
        TaskPlayAnim(l, o, x, 8.0, -8.0, t, v, 0, false, false, false)
        RemoveAnimDict(o)
        a = x
        b = o
        c = v
    end
)
RegisterNetEvent(
    "CarryPeople:cl_stop",
    function()
        carryingBackInProgress = false
        ClearPedSecondaryTask(CORRUPT.getPlayerPed())
        DetachEntity(CORRUPT.getPlayerPed(), true, false)
    end
)
function func_carryAnimation()
    if carryingBackInProgress then
        DisablePlayerFiring(CORRUPT.getPlayerId(), true)
        if not IsEntityPlayingAnim(CORRUPT.getPlayerPed(), b, a, 3) then
            TaskPlayAnim(CORRUPT.getPlayerPed(), b, a, 8.0, -8.0, 100000, c, 0, false, false, false)
        end
    end
end
CORRUPT.createThreadOnTick(func_carryAnimation)
