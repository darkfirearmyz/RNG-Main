local a = module("corrupt-assets", "cfg/cfg_vehiclemaxspeeds")
local b = false
local c = false
local d = false
local e = false
local f = 0
local g = false
local h = false
local i = false
local j = vector3(0.0, 0.0, 0.0)
local k = 0.0
local l = {
    { -- St Thomas
        colour = 2,
        id = 1,
        pos = vector3(333.91488647461, -597.16156005859, 29.292747497559),
        dist = 40,
        nonRP = false,
        setBit = false,
        maxHeight = 105.0
    },
    { -- Legion JD
        colour = 2,
        id = 1,
        pos = vector3(148.066, -1050.763, 29.34099),
        dist = 40,
        nonRP = false,
        setBit = false,
        maxHeight = 87.0
    },
    { -- Paleto Bank
        colour = 2,
        id = 1,
        pos = vector3(-110.09871673584, 6464.6030273438, 31.62672996521),
        dist = 20,
        nonRP = false,
        setBit = false,
        maxHeight = 50.0
    },
    { -- Vespucci PD
        colour = 2,
        id = 1,
        pos = vector3(-1079.5734863281, -843.14739990234, 4.8841333389282),
        dist = 45,
        nonRP = false,
        setBit = false,
        maxHeight = 59.0
    },
    { -- VIP Island
        colour = 2,
        id = 1,
        pos = vector3(-2181.7966308594, 5189.8286132813, 17.64377784729),
        dist = 150,
        nonRP = true,
        setBit = false,
        maxHeight = 77.0
    },
    { -- City Hall
        colour = 2,
        id = 1,
        pos = vector3(-540.54748535156, -216.42681884766, 37.64966583252),
        dist = 50,
        nonRP = false,
        setBit = false,
        maxHeight = 102.0
    },
    { -- Legion Garage
        colour = 2,
        id = 1,
        pos = vector3(246.30143737793, -782.50170898438, 30.573167800903),
        dist = 40,
        nonRP = false,
        setBit = false,
        maxHeight = 100.0
    },
    { -- Admin Island
        colour = 2,
        id = 1,
        pos = vector3(3061.135, -4719.28, 15.26162),
        dist = 40,
        nonRP = true,
        setBit = false,
        maxHeight = 150.0
    },
    { -- Diamond Casino
        colour = 2,
        id = 1,
        pos = vector3(1133.0970458984, 250.78565979004, -51.035778045654),
        dist = 100,
        nonRP = false,
        setBit = false,
        interior = true,
        maxHeight = 0.0
    },
    { -- Beach Cinema
        colour = 2,
        id = 1,
        pos = vector3(-1671.5692138672, -912.63940429688, 8.2297477722168),
        dist = 50,
        nonRP = false,
        setBit = false,
        maxHeight = 60.0
    },
    { -- Paleto Casino
        colour = 2,
        id = 1,
        pos = vector3(13.929432868958, 6711.216796875, -105.85443878174),
        dist = 100,
        nonRP = false,
        setBit = false,
        interior = true,
        maxHeight = 0.0
    },
    { -- Royal London
        colour = 2,
        id = 1,
        pos = vector3(337.64172363281, -1393.6368408203, 32.509204864502),
        dist = 50,
        nonRP = false,
        setBit = false,
        maxHeight = 100.0
    },
    { -- VIP City
        colour = 2,
        id = 1,
        pos = vector3(-335.19680786133, -699.10406494141, 33.036075592041),
        dist = 30,
        nonRP = false,
        setBit = false,
        maxHeight = 86.0
    },
    { -- Airport during Purge
        colour = 2,
        id = 1,
        pos = vector3(-1437.4920654297, -2961.6879882812, 14.313854217529),
        dist = 700,
        nonRP = true,
        setBit = false,
        maxHeight = 210.0,
        isPurge = true
    },
    { -- Kortz Center
        colour = 2,
        id = 1,
        pos = vector3(-2335.1215820313, 266.88153076172, 169.60194396973),
        dist = 50,
        nonRP = false,
        setBit = false,
        maxHeight = 210.0
    },
    { -- Paleto Lodges
        colour = 2,
        id = 1,
        pos = vector3(-732.95123291016, 5812.35546875, 17.42693901062),
        dist = 35,
        nonRP = false,
        setBit = false,
        maxHeight = 210.0
    },
    { -- Paleto Hospital
        colour = 2,
        id = 1,
        pos = vector3(-258.038544, 6325.708008, 32.427223),
        dist = 30,
        nonRP = false,
        setBit = false,
        maxHeight = 210.0
    },
    { -- Sandy Hospital
        colour = 2,
        id = 1,
        pos = vector3(1828.143555, 3676.382324, 34.270058),
        dist = 25,
        nonRP = false,
        setBit = false,
        maxHeight = 210.0
    }
}
local m = {
    {vector3(333.91488647461, -597.16156005859, 29.292747497559), 40.0, 2, 180}, -- St Thomas
    {vector3(148.066, -1050.763, 29.34099), 40.0, 2, 180}, -- Legion JD
    {vector3(-110.09871673584, 6464.6030273438, 31.62672996521), 20.0, 2, 180}, -- Paleto Bank
    {vector3(-1079.5734863281, -843.14739990234, 4.8841333389282), 45.0, 2, 180}, -- Vespucci PD
    {vector3(-2181.7966308594, 5189.8286132813, 17.64377784729), 150.0, 2, 180}, -- VIP Island
    {vector3(-540.54748535156, -216.42681884766, 37.64966583252), 50.0, 2, 180}, -- City Hall
    {vector3(246.30143737793, -782.50170898438, 30.573167800903), 40.0, 2, 180}, -- Legion Garage
    {vector3(-335.19680786133, -699.10406494141, 33.036075592041), 30.0, 2, 180}, -- Admin Island
    {vector3(-1671.5692138672, -912.63940429688, 8.2297477722168), 50.0, 2, 180}, -- Beach Cinema
    {vector3(1468.5318603516, 6328.529296875, 18.894895553589), 100.0, 1, 180}, -- Paleto Casino
    {vector3(337.64172363281, -1393.6368408203, 32.509204864502), 50.0, 2, 180}, -- Royal London
    {vector3(4982.5634765625, -5175.1079101562, 2.4887988567352), 120.0, 1, 180}, -- Cayo Rebel
    {vector3(5115.7465820312, -4623.2915039062, 2.642692565918), 85.0, 1, 180}, -- Cayo Large Arms
    {vector3(-1437.4920654297, -2961.6879882812, 14.31385421759), 700.0, 2, 255, true}, -- Airport During Purge
    {vector3(-2335.1215820313, 266.88153076172, 169.60194396973), 50.0, 2, 180}, -- Kortz Center
    {vector3(-732.95123291016, 5812.35546875, 17.42693901062), 35.0, 2, 180}, -- Paleto Lodges
    {vector3(-1716.5004882812,8886.94921875,28.144144058228), 200.0, 1, 180}, -- Oil Rig
    {vector3(-258.038544, 6325.708008, 32.427223), 30.0, 2, 180}, -- Paleto Hospital
    {vector3(1828.143555, 3676.382324, 34.270058), 25.0, 2, 180}, -- Sandy Hospital
}
local n = Citizen.CreateThread
local o = Citizen.Wait
local SetEntityInvincible = SetEntityInvincible
local SetPlayerInvincible = SetPlayerInvincible
local ClearPedBloodDamage = ClearPedBloodDamage
local ResetPedVisibleDamage = ResetPedVisibleDamage
local ClearPedLastWeaponDamage = ClearPedLastWeaponDamage
local SetEntityProofs = SetEntityProofs
local SetEntityCanBeDamaged = SetEntityCanBeDamaged
local NetworkSetFriendlyFireOption = NetworkSetFriendlyFireOption
local GetEntityCoords = GetEntityCoords
local SetEntityNoCollisionEntity = SetEntityNoCollisionEntity
local SetPedCanRagdoll = SetPedCanRagdoll
local SetPedCanRagdollFromPlayerImpact = SetPedCanRagdollFromPlayerImpact
local SetEntityMaxSpeed = SetEntityMaxSpeed
local GetEntityModel = GetEntityModel
local SetEntityCollision = SetEntityCollision
local DisableControlAction = DisableControlAction
local GetVehiclePedIsIn = GetVehiclePedIsIn
function CORRUPT.areGreenzonesDisabled()
    return i
end
function CORRUPT.setGreenzonesDisabled(p)
    i = p
end
n(
    function()
        for q, r in pairs(m) do
            if not r[5] and not CORRUPT.isPurge() or r[5] and CORRUPT.isPurge() then
                local s = AddBlipForRadius(r[1].x, r[1].y, r[1].z, r[2])
                SetBlipColour(s, r[3])
                SetBlipAlpha(s, r[4])
            end
        end
    end
)
n(
    function()
        local t = CORRUPT.isPurge()
        while true do
            local u = CORRUPT.getPlayerPed()
            local v = CORRUPT.getPlayerCoords()
            for w, x in pairs(l) do
                if not x.isPurge and not t or x.isPurge and t then
                    local y = #(v.xy - x.pos.xy)
                    while y < x.dist and v.z < x.maxHeight and not x.destroy do
                        v = CORRUPT.getPlayerCoords()
                        y = #(v.xy - x.pos.xy)
                        if x.nonRP then
                            c = true
                        else
                            if not x.setBit then
                                b = true
                                d = true
                                e = false
                                f = 5
                                j = x.pos
                                k = x.dist
                                x.setBit = true
                            end
                            if x.interior then
                                setDrawGreenInterior = true
                            end
                        end
                        o(100)
                    end
                    if x.setBit then
                        d = false
                        e = true
                        f = 5
                        j = vector3(0.0, 0.0, 0.0)
                        k = 0.0
                        x.setBit = false
                    end
                    c = false
                    b = false
                    d = false
                    setDrawGreenInterior = false
                    SetEntityInvincible(u, false)
                    SetPlayerInvincible(CORRUPT.getPlayerId(), false)
                    ClearPedBloodDamage(u)
                    ResetPedVisibleDamage(u)
                    ClearPedLastWeaponDamage(u)
                    SetEntityProofs(u, false, false, false, false, false, false, false, false)
                    SetEntityCanBeDamaged(u, true)
                    SetLocalPlayerAsGhost(false)
                    SetNetworkVehicleAsGhost(CORRUPT.getPlayerVehicle(), false)
                end
            end
            o(250)
        end
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(z, A)
        if A then
            local B = function(C)
                inCityZone = true
            end
            local D = function(C)
                inCityZone = false
            end
            local E = function(C)
            end
            CORRUPT.createArea(
                "cityzone",
                vector3(-225.30703735352, -916.74755859375, 31.216938018799),
                750.0,
                100,
                B,
                D,
                E,
                {}
            )
        end
    end
)
local function F()
    local G = CORRUPT.getPlayerCoords()
    local H = nil
    for I = 1, 25 do
        local J, K = GetNthClosestVehicleNode(G.x, G.y, G.z, I)
        if J and #(j - K) > k then
            H = K
            break
        end
    end
    if H then
        local L, M = CORRUPT.getPlayerVehicle()
        if L ~= 0 then
            if M and GetScriptTaskStatus(PlayerPedId(), "SCRIPT_TASK_VEHICLE_DRIVE_TO_COORD") == 7 then
                TaskVehicleDriveToCoord(PlayerPedId(), L, H.x, H.y, H.z, 30.0, 1.0, GetEntityModel(L), 16777216, 1.0, 1)
            end
        else
            if GetScriptTaskStatus(PlayerPedId(), "SCRIPT_TASK_FOLLOW_NAVMESH_TO_COORD_ADVANCED") == 7 then
                TaskFollowNavMeshToCoordAdvanced(PlayerPedId(), H.x, H.y, H.z, 8.0, -1, 2.5, 0, 0, 0.0, 100.0, 4000.0)
            end
        end
    end
end
n(
    function()
        while true do
            local u = PlayerPedId()
            local N = GetVehiclePedIsIn(u, false)
            -- SetVehicleAutoRepairDisabled(N, true)
            if not CORRUPT.areGreenzonesDisabled() then
                isInGreenzone = b or c
                local O = GetActivePlayers()
                local P = CORRUPT.getPlayerId()
                if b or c then
                    SetEntityMaxSpeed(N, a.maxSpeeds["50"])
                    SetLocalPlayerAsGhost(true)
                    SetNetworkVehicleAsGhost(N, true)
                    SetEntityAlpha(CORRUPT.getPlayerVehicle(), 255, false)
                    SetEntityAlpha(u, 255, false)
                    for Q, R in pairs(O) do
                        local S = GetPlayerPed(R)
                        local T = GetVehiclePedIsIn(S, true)
                        SetEntityAlpha(S, 255, false)
                        SetEntityAlpha(T, 255, false)
                    end
                    SetEntityInvincible(u, true)
                    SetPlayerInvincible(P, true)
                    ClearPedBloodDamage(u)
                    if usingDelgun then
                        CORRUPT.setWeapon(u, "WEAPON_STAFFGUN", true)
                    else
                        CORRUPT.setWeapon(u, "WEAPON_UNARMED", true)
                    end
                    ResetPedVisibleDamage(u)
                    ClearPedLastWeaponDamage(u)
                    SetEntityProofs(u, true, true, true, true, true, true, true, true)
                    SetEntityCanBeDamaged(u, false)
                    SetPedCanRagdoll(u, false)
                    SetPedCanRagdollFromPlayerImpact(u, false)
                else
                    SetPedCanRagdoll(u, true)
                    SetPedCanRagdollFromPlayerImpact(u, true)
                    if N ~= 0 then
                        SetEntityCollision(N, true, true)
                        local U = GetEntityModel(N)
                        if not inCityZone then
                            if a.vehicleMaxSpeeds[U] ~= nil then
                                SetEntityMaxSpeed(N, a.maxSpeeds[a.vehicleMaxSpeeds[U]])
                            else
                                SetEntityMaxSpeed(N, a.maxSpeeds["250"])
                            end
                        else
                            SetEntityMaxSpeed(N, a.maxSpeeds["100"])
                        end
                    end
                end
                if d and g == false then
                    TriggerEvent(
                        "CORRUPT:showNotification",
                        {
                            text = "You have entered the greenzone",
                            height = "200px",
                            width = "auto",
                            colour = "#FFF",
                            background = "#32CD32",
                            pos = "bottom-right",
                            icon = "success"
                        },
                        5000
                    )
                    g = true
                    h = false
                end
                if e and h == false then
                    TriggerEvent(
                        "CORRUPT:showNotification",
                        {
                            text = "You have left the greenzone",
                            height = "60px",
                            width = "auto",
                            colour = "#FFF",
                            background = "#ff0000",
                            pos = "bottom-right",
                            icon = "bad"
                        },
                        5000
                    )
                    h = true
                    g = false
                end
                if b then
                    DisableControlAction(2, 37, true)
                    DisablePlayerFiring(P, true)
                    DisableControlAction(0, 106, true)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 140, true)
                    local V, W = tvRP.getPlayerCombatTimer()
                    if V > 0 and W then
                        F()
                    end
                end
                if c then
                    drawNativeText("You have entered a non-RP greenzone, you may talk out of character here")
                    DisableControlAction(2, 37, true)
                    DisablePlayerFiring(P, true)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 140, true)
                end
                if setDrawGreenInterior then
                    DisableControlAction(0, 106, true)
                    DisableControlAction(0, 45, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 22, true)
                end
            end
            o(0)
        end
    end
)
function CORRUPT.createGreenzone(X, Y, Z)
    local _ = AddBlipForRadius(Y.x, Y.y, Y.z, Z)
    SetBlipColour(_, 2)
    SetBlipAlpha(_, 180)
    table.insert(l, {name = X, blip = _, pos = Y, dist = Z, maxHeight = Y.z + Z, nonRP = false, setBit = false})
end
function CORRUPT.deleteGreenzone(X)
    for w, a0 in pairs(l) do
        if a0.name == X then
            a0.destroy = true
            RemoveBlip(a0.blip)
            table.remove(l, w)
            break
        end
    end
end