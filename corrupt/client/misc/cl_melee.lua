globalInBoxingZone = false
local a = {
    {pos = vector3(-50.477890014648, -1282.771484375, 29.429399490356), radius = 2},
    {pos = vector3(-575.4462890625, 286.91946411133, 94.939964294434), radius = 2},
    {pos = vector3(-294.72583007812, -1992.2838134766, 30.966064453125), radius = 4},
    {pos = vector3(-301.53894042969, 6267.5932617188, 24.484985351562), radius = 2},
    {pos = vector3(1642.041015625, 2526.7734375, 45.56485748291), radius = 8.0}
}
local b = true
local c = false
RegisterCommand(
    "cancelmelee",
    function()
        if CORRUPT.getUserId() == 1 or CORRUPT.getUserId() == 2 then
            c = true
        end
    end,
    false
)
function CORRUPT.enablePunching(d)
    c = d
end
Citizen.CreateThread(
    function()
        CORRUPT.enablePunching(false)
        while true do
            local e = PlayerPedId()
            local f = CORRUPT.getPlayerVehicle()
            local g = PlayerId()
            if not globalInBoxingZone and not c then
                if GetSelectedPedWeapon(e) == `WEAPON_UNARMED` then
                    DisableControlAction(0, 263, true)
                    DisableControlAction(0, 264, true)
                    DisableControlAction(0, 257, true)
                    DisableControlAction(0, 140, true)
                    DisableControlAction(0, 141, true)
                    DisableControlAction(0, 142, true)
                    DisableControlAction(0, 143, true)
                    DisableControlAction(0, 24, true)
                    DisableControlAction(0, 25, true)
                end
            end
            SetPedCanBeDraggedOut(e, false)
            SetPedConfigFlag(e, 149, true)
            SetPedConfigFlag(e, 438, true)
            SetPedConfigFlag(e, 250, false)
            SetPlayerTargetingMode(3)
            local h = GetSelectedPedWeapon(PlayerPedId())
            if h == `WEAPON_UNARMED` or GetWeapontypeGroup(h) == `GROUP_MELEE` then
                SetPlayerLockonRangeOverride(g, 50.0)
            else
                SetPlayerLockonRangeOverride(g, 0.0)
            end
            RestorePlayerStamina(g, 1.0)
            if f ~= 0 and b then
                if GetPedInVehicleSeat(f, 0) == e then
                    if GetIsTaskActive(e, 165) then
                        SetPedIntoVehicle(e, f, 0)
                    end
                end
            end
            Wait(0)
        end
    end
)
function disableSeatShuffle(d)
    b = d
end
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(i, j)
        if j then
            local k = function(l)
                globalInBoxingZone = true
            end
            local m = function(l)
                globalInBoxingZone = false
            end
            local n = function(l)
            end
            for o, p in pairs(a) do
                CORRUPT.createArea("boxing_" .. o, p.pos, p.radius, 6, k, m, n, {})
            end
        end
    end
)
RegisterCommand(
    "shuff",
    function(q, r, s)
        if IsPedInAnyVehicle(CORRUPT.getPlayerPed(), false) then
            disableSeatShuffle(false)
            Citizen.Wait(5000)
            disableSeatShuffle(true)
        else
            CancelEvent()
        end
    end,
    false
)
local t = false
local u = {
    vector3(-60.958786010742, -1291.7238769531, 29.905078887939),
    vector3(1645.5516357422, 2536.77734375, 44.564895629883)
}
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(i, j)
        if j then
            local k = function(l)
                if not t then
                    drawNativeNotification("Press ~INPUT_PICKUP~ to  pick up 🥊")
                else
                    drawNativeNotification("Press ~INPUT_PICKUP~ to take off up 🥊")
                end
            end
            local m = function(l)
            end
            local n = function(l)
                if IsControlJustPressed(1, 51) then
                    if not t then
                        putGloves()
                        t = true
                    else
                        removeGloves()
                        t = false
                    end
                end
            end
            for o, v in pairs(u) do
                tvRP.addMarker(v.x, v.y, v.z, 1.0, 1.0, 1.0, 0, 0, 255, 100, 50, 27, false, false, true)
                CORRUPT.createArea(o .. "_boxingGloves", v, 1.5, 6, k, m, n, {})
            end
        end
    end
)
local w = {}
function putGloves()
    local x = CORRUPT.getPlayerPed()
    local y = CORRUPT.loadModel("prop_boxing_glove_01")
    local z = GetEntityCoords(x)
    local A = CreateObject(y, z.x, z.y, z.z + 0.50, true, false, false)
    local B = CreateObject(y, z.x, z.y, z.z + 0.50, true, false, false)
    table.insert(w, A)
    table.insert(w, B)
    SetModelAsNoLongerNeeded(y)
    FreezeEntityPosition(A, false)
    SetEntityCollision(A, false, true)
    ActivatePhysics(A)
    FreezeEntityPosition(B, false)
    SetEntityCollision(B, false, true)
    ActivatePhysics(B)
    if not x then
        x = CORRUPT.getPlayerPed()
    end
    AttachEntityToEntity(
        A,
        x,
        GetPedBoneIndex(x, 0xEE4F),
        0.05,
        0.00,
        0.04,
        00.0,
        90.0,
        -90.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
    AttachEntityToEntity(
        B,
        x,
        GetPedBoneIndex(x, 0xAB22),
        0.05,
        0.00,
        -0.04,
        00.0,
        90.0,
        90.0,
        true,
        true,
        false,
        true,
        1,
        true
    )
end
function removeGloves()
    for C, D in pairs(w) do
        DeleteObject(D)
    end
    w = {}
end
