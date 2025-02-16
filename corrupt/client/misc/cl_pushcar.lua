PushCarConfig = {}
PushCarConfig.DamageNeeded = 200.0
PushCarConfig.MaxWidth = 5.0
PushCarConfig.MaxHeight = 5.0
PushCarConfig.MaxLength = 5.0
local a = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
local b = nil
local function c(d)
    local e = -GetEntityForwardVector(d)
    local f = {"wheel_lr", "wheel_rr"}
    for g, h in ipairs(f) do
        local i = GetEntityBoneIndexByName(d, h)
        local j = GetWorldPositionOfEntityBone(d, i)
        local k = j + e * 2.0
        local l = StartExpensiveSynchronousShapeTestLosProbe(j.x, j.y, j.z, k.x, k.y, k.z, -1, d, 1)
        local m, n = GetShapeTestResult(l)
        if n == 1 then
            return true
        end
    end
    return false
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5)
            local o = CORRUPT.getPlayerPed()
            Vehicle = {Coords = nil, Vehicle = nil, Dimensions = nil, IsInFront = false, Distance = nil}
            b = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), true)
            if b == nil then
                b = GetVehiclePedIsTryingToEnter(CORRUPT.getPlayerPed())
            end
            if b then
                local p = GetEntityCoords(b)
                local q = GetEntityCoords(b)
                local r = GetEntityCoords(CORRUPT.getPlayerPed())
                local s = #(q - r)
                if
                    IsVehicleSeatFree(b, -1) and GetVehicleEngineHealth(b) <= PushCarConfig.DamageNeeded and
                        not IsEntityInWater(b)
                 then
                    if s < 10 then
                        CORRUPT.DrawText3D(p, "Press [~g~SHIFT~w~] and [~g~E~w~] to push the vehicle", 0.2)
                    end
                else
                    b = GetVehiclePedIsTryingToEnter(CORRUPT.getPlayerPed())
                end
                if
                    IsControlPressed(0, a["LEFTSHIFT"]) and GetEntityHealth(CORRUPT.getPlayerPed()) > 102 and
                        IsVehicleSeatFree(b, -1) and
                        not IsEntityAttachedToEntity(o, b) and
                        IsControlJustPressed(0, a["E"]) and
                        GetVehicleEngineHealth(b) <= PushCarConfig.DamageNeeded
                 then
                    local q = GetEntityCoords(b)
                    local r = GetEntityCoords(CORRUPT.getPlayerPed())
                    local s = #(q - r)
                    if s < 10 and not c(b) then
                        local p = GetEntityCoords(o)
                        if
                            #(GetEntityCoords(b) + GetEntityForwardVector(b) - GetEntityCoords(o)) >
                                #(GetEntityCoords(b) + GetEntityForwardVector(b) * -1 - GetEntityCoords(o))
                         then
                            Vehicle.IsInFront = false
                        else
                            Vehicle.IsInFront = true
                        end
                        local t = vector3(0.0, 0.0, 0.0)
                        local u = vector3(5.0, 5.0, 5.0)
                        Vehicle.Dimensions = GetModelDimensions(GetEntityModel(b), t, u)
                        if Vehicle.IsInFront then
                            AttachEntityToEntity(
                                CORRUPT.getPlayerPed(),
                                b,
                                GetPedBoneIndex(PlayerPedId(), 6286),
                                0.0,
                                Vehicle.Dimensions.y * -1 + 0.1,
                                Vehicle.Dimensions.z + 1.0,
                                0.0,
                                0.0,
                                180.0,
                                0.0,
                                false,
                                false,
                                true,
                                false,
                                true
                            )
                        else
                            AttachEntityToEntity(
                                CORRUPT.getPlayerPed(),
                                b,
                                GetPedBoneIndex(PlayerPedId(), 6286),
                                0.0,
                                Vehicle.Dimensions.y - 0.3,
                                Vehicle.Dimensions.z + 1.0,
                                0.0,
                                0.0,
                                0.0,
                                0.0,
                                false,
                                false,
                                true,
                                false,
                                true
                            )
                        end
                        dict = "missfinale_c2ig_11"
                        RequestAnimDict(dict)
                        while not HasAnimDictLoaded(dict) do
                            Citizen.Wait(100)
                        end
                        TaskPlayAnim(o, "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0, -8.0, -1, 35, 0, 0, 0, 0)
                        RemoveAnimDict(dict)
                        Citizen.Wait(200)
                        local v = b
                        while true do
                            Citizen.Wait(5)
                            if IsDisabledControlPressed(0, a["A"]) then
                                TaskVehicleTempAction(CORRUPT.getPlayerPed(), v, 11, 1000)
                            end
                            if IsDisabledControlPressed(0, a["D"]) then
                                TaskVehicleTempAction(CORRUPT.getPlayerPed(), v, 10, 1000)
                            end
                            if Vehicle.IsInFront then
                                SetVehicleForwardSpeed(v, -1.0)
                            else
                                SetVehicleForwardSpeed(v, 1.0)
                            end
                            if HasEntityCollidedWithAnything(v) then
                                SetVehicleOnGroundProperly(v)
                            end
                            if not IsDisabledControlPressed(0, a["E"]) or IsEntityInWater(v) then
                                DetachEntity(o, false, false)
                                StopAnimTask(o, "missfinale_c2ig_11", "pushcar_offcliff_m", 2.0)
                                FreezeEntityPosition(o, false)
                                break
                            end
                        end
                    end
                end
            end
        end
    end
)
