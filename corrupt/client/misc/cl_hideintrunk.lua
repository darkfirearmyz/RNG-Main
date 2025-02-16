local a = {
    [0] = true,
    [1] = true,
    [2] = true,
    [3] = true,
    [4] = true,
    [5] = true,
    [6] = true,
    [9] = true,
    [11] = true,
    [12] = true,
    [17] = true,
    [18] = true
}
local function b(vehicle)
    local c = GetActivePlayers()
    local d = CORRUPT.getPlayerCoords()
    for e, f in pairs(c) do
        local g = GetPlayerPed(f)
        local h = GetEntityCoords(g)
        local i = #(d - h)
        if i < 5 and IsEntityPlayingAnim(g, "timetable@floyd@cryingonbed@base", "base", 3) then
            return true
        end
    end
    return false
end
local j = false
local k = false
function CORRUPT.isPlayerHidingInBoot()
    return j
end
local function l(vehicle, m)
    if tvRP.isHandcuffed() or tvRP.isTazed() then
        return false
    end
    local n = GetEntitySpeed(PlayerPedId())
    local o = GetEntitySpeed(vehicle)
    if n > 1.0 or o > 2.5 then
        return false
    end
    if m and #(CORRUPT.getPlayerCoords() - m) > 1.0 then
        return false
    end
    return true
end
Citizen.CreateThread(
    function()
        local p = 250
        while true do
            Citizen.Wait(p)
            local q = CORRUPT.getPlayerPed()
            local r = CORRUPT.getPlayerVehicle()
            local s = CORRUPT.getClosestVehicle(7.0)
            local t = GetVehicleClass(s)
            local u = GetVehicleDoorLockStatus(s)
            if r == 0 and a[t] and GetEntityHealth(CORRUPT.getPlayerPed()) > 102 and not noclipActive then
                if s and s ~= 0 then
                    p = 0
                    local v = GetEntityBoneIndexByName(s, "boot")
                    local w = GetWorldPositionOfEntityBone(s, v)
                    local x = #(w - CORRUPT.getPlayerCoords())
                    if x < 2 and NetworkGetEntityIsNetworked(s) and not CORRUPT.isInTutorial() then
                        DrawMarker(
                            0,
                            w.x,
                            w.y,
                            w.z,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.3,
                            0.3,
                            0.3,
                            0,
                            255,
                            150,
                            255,
                            true,
                            false,
                            2,
                            false,
                            nil,
                            nil,
                            false
                        )
                        k = true
                        drawNativeNotification("~s~~INPUT_VEH_PUSHBIKE_SPRINT~ to get inside the boot.")
                        if IsDisabledControlJustReleased(1, 137) and l(vehicle) then
                            if not b(vehicle) then
                                local m = CORRUPT.getPlayerCoords()
                                tvRP.startCircularProgressBar(
                                    "",
                                    2000,
                                    nil,
                                    function()
                                    end
                                )
                                if l(vehicle, m) then
                                    if u <= 1 then
                                        tvRP.setCanAnim(false)
                                        CORRUPT.setWeapon(q, "WEAPON_UNARMED", true)
                                        j = true
                                        local y = GetEntityCoords(PlayerPedId())
                                        local z = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
                                        SetCamCoord(z, y.x, y.x, y.z)
                                        PointCamAtEntity(z, s, 0.0, 0.0, 0.0, false)
                                        SetCamActive(z, true)
                                        RenderScriptCams(true, false, 0, true, true)
                                        SetVehicleDoorOpen(s, 5, false, false)
                                        RaiseConvertibleRoof(s, false)
                                        AttachEntityToEntity(
                                            q,
                                            s,
                                            -1,
                                            0.0,
                                            -2.2,
                                            0.5,
                                            0.0,
                                            0.0,
                                            0.0,
                                            false,
                                            false,
                                            false,
                                            false,
                                            20,
                                            true
                                        )
                                        ClearPedTasksImmediately(q)
                                        Wait(100)
                                        CORRUPT.loadAnimDict("timetable@floyd@cryingonbed@base")
                                        TaskPlayAnim(
                                            q,
                                            "timetable@floyd@cryingonbed@base",
                                            "base",
                                            1.0,
                                            -1,
                                            -1,
                                            1,
                                            0,
                                            0,
                                            0,
                                            0
                                        )
                                        RemoveAnimDict("timetable@floyd@cryingonbed@base")
                                        Wait(1000)
                                        SetVehicleDoorShut(s, 5, false)
                                        DestroyCam(z, 0)
                                        RenderScriptCams(0, 0, 1, 1, 1)
                                        AttachEntityToEntity(
                                            q,
                                            s,
                                            v,
                                            0.0,
                                            0.0,
                                            -0.5,
                                            0.0,
                                            0.0,
                                            0.0,
                                            false,
                                            false,
                                            false,
                                            false,
                                            20,
                                            true
                                        )
                                        k = true
                                        drawNativeNotification("~s~~INPUT_FRONTEND_RRIGHT~ To exit the boot.")
                                        local A = true
                                        local B = false
                                        while A and j do
                                            DisableAllControlActions(0)
                                            DisableAllControlActions(1)
                                            DisableAllControlActions(2)
                                            EnableControlAction(0, 0, true)
                                            EnableControlAction(0, 249, true)
                                            EnableControlAction(2, 1, true)
                                            EnableControlAction(2, 2, true)
                                            EnableControlAction(0, 177, true)
                                            EnableControlAction(0, 200, true)
                                            if IsDisabledControlPressed(0, 177) then
                                                if GetVehicleDoorLockStatus(s) <= 1 then
                                                    A = false
                                                else
                                                    tvRP.notify("~r~Vehicle is locked, cannot get in boot.")
                                                end
                                            end
                                            if not DoesEntityExist(s) then
                                                A = false
                                            end
                                            if GetEntityHealth(q) <= 102 then
                                                A = false
                                            end
                                            if not IsEntityPlayingAnim(q, "timetable@floyd@cryingonbed@base", "base", 3) then
                                                TaskPlayAnim(
                                                    q,
                                                    "timetable@floyd@cryingonbed@base",
                                                    "base",
                                                    1.0,
                                                    -1,
                                                    -1,
                                                    1,
                                                    0,
                                                    0,
                                                    0,
                                                    0
                                                )
                                            end
                                            Wait(0)
                                        end
                                        j = false
                                        DetachEntity(q, true, true)
                                        SetEntityVisible(q, true, true)
                                        ClearAllHelpMessages()
                                        ClearPedTasks(PlayerPedId())
                                        SetVehicleDoorOpen(s, 5, false, false)
                                        tvRP.setCanAnim(true)
                                        Wait(1000)
                                        SetVehicleDoorShut(s, 5, false)
                                    else
                                        tvRP.notify("~r~Vehicle is locked, cannot get out of boot.")
                                    end
                                else
                                    tvRP.notify("~r~You and the vehicle must remain stationary to get in.")
                                end
                            else
                                tvRP.notify("~r~Someone is already in this boot.")
                            end
                        end
                    else
                        if k then
                            ClearHelp(true)
                            k = false
                        end
                    end
                else
                    p = 250
                end
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:removeHiddenInBoot",
    function()
        j = false
    end
)
