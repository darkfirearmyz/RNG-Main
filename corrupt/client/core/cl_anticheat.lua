decor = nil
local function c(d, ...)
    for e, f in pairs(GetGamePool("CVehicle")) do
        d(f, ...)
        Wait(0)
    end
end
Citizen.CreateThread(
    function()
        while decor == nil do
            Wait(100)
        end
        DecorRegister(decor, 3)
        while true do
            Citizen.Wait(500)
            if not CORRUPT.inEvent() then
                c(
                    function(f)
                        if DecorGetInt(f, decor) ~= 945 then
                            if NetworkHasControlOfEntity(f) then
                                local g = GetEntityModel(f)
                                DeleteEntity(f)
                            end
                        end
                    end
                )
            end
        end
    end
)
local h = false
Citizen.CreateThread(
    function()
        Wait(15000)
        while true do
            local i = CORRUPT.getPlayerPed()
            local j = CORRUPT.getPlayerId()
            local k = CORRUPT.getPlayerVehicle()
            if k == 0 then
                SetWeaponDamageModifier("WEAPON_RUN_OVER_BY_CAR", 0.0)
                SetWeaponDamageModifier("WEAPON_RAMMED_BY_CAR", 0.0)
                SetWeaponDamageModifier("VEHICLE_WEAPON_ROTORS", 0.0)
                SetWeaponDamageModifier("WEAPON_UNARMED", 0.5)
                SetWeaponDamageModifier("WEAPON_SNOWBALL", 0.0)
                local l = GetSelectedPedWeapon(i)
                if l == "WEAPON_SNOWBALL" then
                    SetPlayerWeaponDamageModifier(j, 0.0)
                else
                    SetPlayerWeaponDamageModifier(j, 1.0)
                    SetWeaponDamageModifier(l, 1.0)
                end
                if
                    not h and GetUsingseethrough() and not CORRUPT.isPlayerInPoliceHeli() and not CORRUPT.isPlayerInDrone()
                 then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 13)
                    h = true
                end
            end
            SetPedInfiniteAmmoClip(i, false)
            for e, m in pairs(tvRP.getWeapons()) do
                SetPedInfiniteAmmo(i, false, m.hash)
            end
            SetEntityInvincible(k, false)
            ToggleUsePickupsForPlayer(j, "PICKUP_HEALTH_SNACK", false)
            ToggleUsePickupsForPlayer(j, "PICKUP_HEALTH_STANDARD", false)
            ToggleUsePickupsForPlayer(j, "PICKUP_WEAPON_PISTOL", false)
            ToggleUsePickupsForPlayer(j, "PICKUP_AMMO_BULLET_MP", false)
            Citizen.InvokeNative(0xdef665962974b74c, 2047, false)
            SetLocalPlayerCanCollectPortablePickups(false)
            SetPlayerHealthRechargeMultiplier(j, 0.0)
            Wait(500)
        end
    end
)
local n = false
local o = nil
RegisterNetEvent(
    "CORRUPT:setTeleportingState",
    function(p)
        n = p
    end
)
local t = false
local u = false
AddEventHandler(
    "esx:getSharedObject",
    function(v)
        if t == true then
            CancelEvent()
            v(nil)
            return
        end
        TriggerServerEvent("CORRUPT:AntiCheatBan", 4, "esx:getSharedObject")
        t = true
        v(nil)
    end
)
local w = {
    "ambulancier:selfRespawn",
    "bank:transfer",
    "esx_ambulancejob:revive",
    "esx-qalle-jail:openJailMenu",
    "esx_jailer:wysylandoo",
    "esx_society:openBossMenu",
    "esx:spawnVehicle",
    "esx_status:set",
    "HCheat:TempDisableDetection",
    "UnJP",
    "bank:transfer",
    "esx_skin:openSaveableMenu",
    "esx_society:openBossMenu",
    "esx_status:set",
    "esx_ambulancejob:revive",
    "ambulancier:selfRespawn",
    "esx-qalle-jail:openJailMenu",
    "UnJP",
    "esx_inventoryhud:openPlayerInventory",
    "HCheat:TempDisableDetection",
    "esx_policejob:handcuff",
    "esx:getSharedObject",
    "esx:teleport",
    "esx_spectate:spectate"
}
RegisterCommand("testscreenshot", function()
    TriggerServerEvent("CORRUPT:AntiCheatLog", 10, "esx:getSharedObject")
end)
for x, y in ipairs(w) do
    AddEventHandler(
        y,
        function()
            if u == true then
                CancelEvent()
                return
            end
            TriggerServerEvent("CORRUPT:AntiCheatBan", 4, y)
            u = true
        end
    )
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(5000)
            local j = PlayerId()
            local k = GetVehiclePedIsIn(j, false)
            local z = GetPlayerWeaponDamageModifier(j)
            local A = GetPlayerWeaponDefenseModifier(j)
            local B = GetPlayerWeaponDefenseModifier_2(j)
            local C = GetPlayerVehicleDamageModifier(j)
            local D = GetPlayerVehicleDefenseModifier(j)
            local E = GetPlayerMeleeWeaponDefenseModifier(j)
            if k ~= 0 then
                local F = GetVehicleTopSpeedModifier(k)
                if F > 1.0 then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "GetVehicleTopSpeedModifier", E)
                end
            end
            local G = GetWeaponDamageModifier(GetCurrentPedWeapon(j, 0, false))
            local H = GetPlayerMeleeWeaponDamageModifier(PlayerId())
            if z > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "PlayerWeaponDamageModifier", z)
            end
            if A > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "PlayerWeaponDefenseModifier", A)
            end
            if B > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "PlayerWeaponDefenseModifier_2", B)
            end
            if C > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "PlayerVehicleDamageModifier", C)
            end
            if D > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "PlayerVehicleDefenseModifier", D)
            end
            if G > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "GetWeaponDamageModifier", E)
            end
            if H > 1.0 then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "GetPlayerMeleeWeaponDamageModifier", E)
            end
            RemoveAllPickupsOfType("PICKUP_HEALTH_SNACK")
            RemoveAllPickupsOfType("PICKUP_HEALTH_STANDARD")
        end
    end
)

function CORRUPT.isPlayerAboveGround()
    local J = CORRUPT.getPlayerCoords()
    local K, L = GetGroundZFor_3dCoord(J.x, J.y, J.z, 0.0, false)
    return K, L
end
local M = 0
local N = 0
local O = 0
local P = 0
local function Q(f)
    local R = GetVehicleNumberOfWheels(f)
    local S = 0.0
    for x = 0, R - 1 do
        local T = GetVehicleWheelSpeed(f, x)
        if T > S then
            S = T
        end
    end
    return S
end
local function U()
    local i = PlayerPedId()
    for e, V in pairs(GetGamePool("CObject")) do
        if GetEntityAttachedTo(V) == i then
            DeleteEntity(V)
        end
    end
end
Citizen.CreateThread(
    function()
        Wait(2000)
        local o = GetEntityCoords(PlayerPedId())
        while true do
            local i = PlayerPedId()
            local W = GetEntityCoords(i)
            local X = #(o - W)
            o = W
            if
                X > 0.4 and not IsPedFalling(i) and CORRUPT.getStaffLevel() < 2 and not IsPedInParachuteFreeFall(i) and
                    not carryingBackInProgress and
                    not piggyBackInProgress and
                    not CORRUPT.takeHostageInProgress() and
                    GetPedParachuteState(i) <= 0 and
                    not IsPedRagdoll(i) and
                    not IsPedRunning(i) and
                    not CORRUPT.isPlayerRappeling() and
                    not CORRUPT.isPlayerAboveGround() and
                    not CORRUPT.isPlayerHidingInBoot() and
                    not CORRUPT.isSpectatingEvent()
             then
                if not IsPedInAnyVehicle(i, 1) then
                    M = M + 1
                    if M > 100 then
                        TriggerServerEvent("CORRUPT:AntiCheatBan", 1)
                        M = 0
                    end
                end
            end
            local f, Y = CORRUPT.getPlayerVehicle()
            if DoesEntityExist(f) and Y and X > 0.2 and CORRUPT.getStaffLevel() < 2 then
                if O ~= f then
                    N = 0
                    O = f
                end
                local S = Q(f)
                local Z = GetEntitySpeed(f)
                if S < 5.0 and Z < 2.5 then
                    N = N + 1
                    U()
                    if N > 100 and GetGameTimer() - P > 4000 then
                        TriggerServerEvent("CORRUPT:AntiCheatBan", 1)
                        N = 0
                        P = GetGameTimer()
                    end
                end
            end
            Wait(0)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            M = 0
            Wait(60000)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if GetLabelText("notification_buffer") ~= "NULL" then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 7)
            end
            if GetLabelText("text_buffer") ~= "NULL" then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 7)
            end
            if GetLabelText("preview_text_buffer") ~= "NULL" then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 7)
            end
            Wait(20000)
        end
    end
)
Citizen.CreateThread(
    function()
        Wait(10000)
        local _ = 0
        while true do
            if _ >= 100 and not tvRP.isInComa() then
                TriggerServerEvent("CORRUPT:AntiCheatBan", 6)
                Citizen.Wait(5000)
            end
            if not tvRP.isStaffedOn()  then
                local j = PlayerId()
                local i = PlayerPedId()
                local a0 = GetEntityHealth(i)
                SetPlayerHealthRechargeMultiplier(j, 0.0)
                if i ~= 0 then
                    SetEntityHealth(i, a0 - 2)
                    Citizen.Wait(50)
                    if GetEntityHealth(i) > a0 - 2 then
                        _ = _ + 1
                    elseif _ > 0 then
                        _ = _ - 1
                    end
                    SetEntityHealth(i, GetEntityHealth(i) + 2)
                end
            else
                Citizen.Wait(2000)
            end
        end
    end
)
local a1 = {["WEAPON_UNARMED"] = true, ["WEAPON_PETROLCAN"] = true, ["WEAPON_SNOWBALL"] = true}
CreateThread(
    function()
        while true do
            local i = CORRUPT.getPlayerPed()
            local l = GetSelectedPedWeapon(i)
            if IsPedShooting(i) and not a1[l] then
                local a2, a3 = GetAmmoInClip(i, l)
                if a3 == GetMaxAmmoInClip(i, l, false) then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 8, "Infinite Ammo")
                    Wait(60000)
                end
            end
            Wait(500)
        end
    end
)
local a4 = vector3(0.0, 0.0, 0.0)
local a5 = 0
local a6 = nil
local a7 = 0
local a8 = 0
local a9 = vector3(0.0, 0.0, 0.0)
local aa = 0
local ab = 0
local function ac(ad, ae, af)
    if type(ad) == "vector3" then
        a9 = ad
    else
        a9 = vector3(ad, ae, af)
    end
    aa = GetGameTimer()
end
local ag = SetEntityCoords
SetEntityCoords = function(ah, ai, aj, ak, al, am, an, ao)
    if ah == a5 or ah == a7 then
        ac(ai, aj, ak)
    end
    ag(ah, ai, aj, ak, al, am, an, ao)
end
local ap = SetEntityCoordsNoOffset
SetEntityCoordsNoOffset = function(ah, ai, aj, ak, al, am, an)
    if ah == a5 or ah == a7 then
        ac(ai, aj, ak)
    end
    ap(ah, ai, aj, ak, al, am, an)
end
local aq = NetworkResurrectLocalPlayer
NetworkResurrectLocalPlayer = function(ad, ae, af, ar, as, at)
    ac(ad, ae, af)
    aq(ad, ae, af, ar, as, at)
end
local au = StartPlayerTeleport
StartPlayerTeleport = function(av, ad, ae, af, ar, aw, ax, ay)
    ac(ad, ae, af)
    au(av, ad, ae, af, ar, aw, ax, ay)
end
local function az(aA, aB)
    if math.abs(aA.x) > aB or math.abs(aA.y) > aB or math.abs(aA.z) > aB then
        return true
    else
        return false
    end
end
local function aC()
    local i = PlayerPedId()
    if i == nil or i == 0 then
        return
    end
    a5 = i
    local aD = GetGameTimer()
    local k = GetVehiclePedIsUsing(i)
    if a7 ~= k then
        a8 = aD
    end
    a7 = k
    local aE = false
    if k ~= 0 then
        aE = GetPedInVehicleSeat(k, -1) ~= i
    end
    local aF = a6
    a6 = GetEntityCoords(i, true)
    if not aF then
        return
    end
    local aG = #(aF - a6)
    if
        aG < 50.0 or aE or carryingBackInProgress or piggyBackInProgress or CORRUPT.isPlayerHidingInBoot() or
            GetEntityAttachedTo(i) ~= 0
     then
        return
    end
    if aD - a8 < 2000 or aD - aa < 5000 then
        return
    end
    if #(a6 - a9) < 15.0 or #(a6 - a4) < 50.0 or #(aF - a4) < 50.0 then
        return
    end
    local aH = #(aF.xy - a6.xy)
    if aF.z < -180.0 and aH < 2500.0 then
        return
    end
    if a6.z >= -52.0 and a6.z <= -48.0 and aH < 10.0 then
        return
    end
    local aI = GetEntityVelocity(i)
    local aJ = (a6 - aF) / GetFrameTime()
    local aK = aI - aJ
    if az(aK, 100.0) then
        if aD - ab > 5000 then
            TriggerServerEvent("CORRUPT:sendVelocityLimit", aF, a6)
            ab = aD
        end
    end
end

RegisterNetEvent(
    "CORRUPT:settingPlayerIntoVehicle",
    function()
        aa = GetGameTimer()
    end
)
local aL = 0
local aM = 0
local aN = 0
local aO = 0
local aP = 0
local aQ = 0
local aR = 0
local aS = SetVehicleFixed
SetVehicleFixed = function(f)
    if f == aQ then
        aP = GetGameTimer()
    end
    aS(f)
end
local aT = SetVehicleBodyHealth
SetVehicleBodyHealth = function(f, p)
    if f == aQ then
        aL = math.floor(p)
    end
    aT(f, p)
end
local aU = SetVehicleEngineHealth
SetVehicleEngineHealth = function(f, a0)
    if f == aQ then
        aM = math.floor(a0)
    end
    aU(f, a0)
end
local aV = SetVehiclePetrolTankHealth
SetVehiclePetrolTankHealth = function(f, a0)
    if f == aQ then
        aN = math.floor(a0)
    end
    aV(f, a0)
end
local aW = SetEntityHealth
SetEntityHealth = function(ah, a0)
    if ah == aQ then
        aM = math.floor(a0)
    end
    aW(ah, a0)
end
local function aX(f)
    local aY = {}
    local g = GetEntityModel(f)
    local aZ = GetVehicleModelNumberOfSeats(g) - 1
    for a_ = 0, aZ do
        local b0 = GetPedInVehicleSeat(f, a_)
        if b0 ~= 0 and IsPedAPlayer(b0) then
            local b1 = NetworkGetPlayerIndexFromPed(b0)
            if b1 ~= -1 then
                local b2 = GetPlayerServerId(b1)
                table.insert(aY, {a_, b2})
            end
        end
    end
    return aY
end
local function b3(b4, b5)
    if b4 == 0 or b4 < 0 and b5 < 0 then
        return false
    end
    local b6 = math.abs(b5 - b4)
    if b6 <= 4 then
        return false
    end
    if b6 <= 50 and b4 ~= 1000 then
        return false
    end
    return b4 > b5
end
local function b7()
    local f, Y = CORRUPT.getPlayerVehicle()
    if
        f == 0 or not DoesEntityExist(f) or not Y or not NetworkGetEntityIsNetworked(f) or
            GetIsTaskActive(PlayerPedId(), 165) or
            GetEntityType(GetEntityAttachedTo(f)) == 2 or
            CORRUPT.inEvent()
     then
        aQ = 0
        aL = 1000
        aM = 1000
        aN = 1000
        aO = 1000
        return
    end
    local b8 = math.floor(GetVehicleBodyHealth(f))
    local b9 = math.floor(GetVehicleEngineHealth(f))
    local ba = math.floor(GetVehiclePetrolTankHealth(f))
    local bb = math.floor(GetEntityHealth(f))
    if b3(b8, aL) or b3(b9, aM) or b3(ba, aN) or b3(bb, aO) then
        local aD = GetGameTimer()
        if GetGameTimer() - aP > 1000 and f == aQ and aD - aR > 5000 and GetEntityHealth(PlayerPedId()) > 102 and
                aD - globalLastSpawnedVehicleTime > 5000
         then
            local aY = aX(f)
            local bc = CORRUPT.getVehicleIdFromModel(GetEntityModel(f)) or "N/A"
            TriggerServerEvent("CORRUPT:sendVehicleStats", b8, aL, b9, aM, ba, aN, bb, aO, aY, bc)
            aR = aD
        end
    end
    aL = b8
    aM = b9
    aN = ba
    aO = bb
    aQ = f
end
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(bd, be)
        if be then
            Citizen.Wait(15000)
            while true do
                aC()
                b7()
                Citizen.Wait(0)
            end
        end
    end
)


local cfg = module("corrupt-assets", "cfg/cfg_anticheat")
Citizen.CreateThread(
    function()
        while true do
            local f = CORRUPT.getPlayerVehicle()
            if GetVehicleHasParachute(f) or GetCanVehicleJump(f) or GetHasRocketBoost(f) then
                local bf = GetEntityModel(f)
                if not table.has(cfg.anticheat, bf) then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 12, globalVehicleModelHashMapping[bf])
                end
            end
            Wait(5000)
        end
    end
)


CreateThread(function()
    local coords2beforeX, coords2beforeY = 0, 0
    local coordsBeforeX, coordsBeforeY = 0, 0
    while (true) do
        if IsControlJustPressed(0, 24) and IsPedStill(PlayerPedId()) then
            local x, y = GetNuiCursorPosition()
            if (coordsBeforeX < 1166 and coordsBeforeX > 1033 and coordsBeforeY < 515 and coordsBeforeY > 371) then
                if (x < 1390 and x > 969 and y < 767 and y > 734) then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 30, "Injection")
                end
            end
            if (coords2beforeX < 1166 and coords2beforeX > 1033 and coords2beforeY < 515 and coords2beforeY > 371) then
                if (x < 1390 and x > 969 and y < 767 and y > 734) then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 30, "Injection")
                end
            end
            coordsBeforeX, coordsBeforeY = GetNuiCursorPosition()
            coords2beforeX, coords2beforeY = coordsBeforeX, coordsBeforeY
        end
        Wait(0)
    end
end)


Citizen.CreateThread(function()
    while true do
        Wait(500)
        for j, v in ipairs(GetGamePool("CVehicle")) do
            local height = GetEntityHeightAboveGround(v)
            local driver = GetPedInVehicleSeat(v, -1)
            local speed = GetEntitySpeed(v)
            if not IsEntityInWater(v) and not DoesEntityExist(driver) then
                if (height > 4.0) then
                    DeleteEntity(v)
                end
                if (height > 2.0) and (speed > 40) then
                    DeleteEntity(v)
                end
            end
        end
    end
end)


CreateThread(function()
    while true do
        Wait(400)
        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            local isVehicleOnGround = IsVehicleOnAllWheels(vehicle)
            if isVehicleOnGround then
                local maxSpeed = GetVehicleEstimatedMaxSpeed(vehicle)
                local currentSpeed = GetEntitySpeed(vehicle)
                local totalSpeed = maxSpeed + 40
                if currentSpeed > totalSpeed then
                    TriggerServerEvent("CORRUPT:AntiCheatLog", 31)
                end
            end
        end
    end
end)


CreateThread(function()
    while true do
        Wait(2000)
        local DetectableTextures = {{txd="HydroMenu",txt="HydroMenuHeader",name="HydroMenu"},{txd="John",txt="John2",name="SugarMenu"},{txd="darkside",txt="logo",name="Darkside"},{txd="ISMMENU",txt="ISMMENUHeader",name="ISMMENU"},{txd="dopatest",txt="duiTex",name="Copypaste Menu"},{txd="fm",txt="menu_bg",name="Fallout Menu"},{txd="wave",txt="logo",name="Wave"},{txd="wave1",txt="logo1",name="Wave (alt.)"},{txd="meow2",txt="woof2",name="Alokas66",x=1000,y=1000},{txd="adb831a7fdd83d_Guest_d1e2a309ce7591dff86",txt="adb831a7fdd83d_Guest_d1e2a309ce7591dff8Header6",name="Guest Menu"},{txd="hugev_gif_DSGUHSDGISDG",txt="duiTex_DSIOGJSDG",name="HugeV Menu"},{txd="MM",txt="menu_bg",name="Metrix Mehtods"},{txd="wm",txt="wm2",name="WM Menu"},{txd="NeekerMan",txt="NeekerMan1",name="Lumia Menu"},{txd="Blood-X",txt="Blood-X",name="Blood-X Menu"},{txd="Dopamine",txt="Dopameme",name="Dopamine Menu"},{txd="Fallout",txt="FalloutMenu",name="Fallout Menu"},{txd="Luxmenu",txt="Lux meme",name="LuxMenu"},{txd="Reaper",txt="reaper",name="Reaper Menu"},{txd="absoluteeulen",txt="Absolut",name="Absolut Menu"},{txd="KekHack",txt="kekhack",name="KekHack Menu"},{txd="Maestro",txt="maestro",name="Maestro Menu"},{txd="KekHack",txt="kekhack",name="KekHack Menu"},{txd="SkidMenu",txt="skidmenu",name="Skid Menu"},{txd="Brutan",txt="brutan",name="Brutan Menu"},{txd="FiveSense",txt="fivesense",name="Fivesense Menu"},{txd="NeekerMan",txt="NeekerMan1",name="Lumia Menu"},{txd="Auttaja",txt="auttaja",name="Auttaja Menu"},{txd="BartowMenu",txt="bartowmenu",name="Bartow Menu"},{txd="Hoax",txt="hoaxmenu",name="Hoax Menu"},{txd="FendinX",txt="fendin",name="Fendinx Menu"},{txd="Hammenu",txt="Ham",name="Ham Menu"},{txd="Lynxmenu",txt="Lynx",name="Lynx Menu"},{txd="Oblivious",txt="oblivious",name="Oblivious Menu"},{txd="malossimenuv",txt="malossimenu",name="Malossi Menu"},{txd="memeeee",txt="Memeeee",name="Memeeee Menu"},{txd="tiago",txt="Tiago",name="Tiago Menu"},{txd="Hydramenu",txt="hydramenu",name="Hydra Menu"},{txd="_UI",txt="_UI",name="_UI"},{txd="Hydramenu",txt="hydramenu",name="Hydra Menu"},{txd="Hydramenu",txt="hydramenu",name="Hydra Menu"},{txd="Hydramenu",txt="hydramenu",name="Hydra Menu"},{txd="AREF",txt="AREF",name="Fallout Menu"},{txd="LumiaF",txt="LumiaN",name="Lumia"},{txd="LumiaN",txt="LumiaN",name="Lumia"},{txd="LumiaF",txt="LumiaF",name="Lumia"},{txd="LumiaN",txt="LumiaF",name="Lumia"},{txd="LLumia1.rE",txt="Lumia1.rE",name="Lumia"},{txd="Lumia1",txt="Lumia1",name="Lumia"},{txd="NeekerMan1",txt="NeekerMan1",name="Lumia"},{txd="NeekerMan1",txt="NeekerMan",name="Lumia"},{txd="MaestroMenu",txt="MaestroMenu",name="MaestroMenu"},{txd="Genesis",txt="Genesis",name="Genesis Menu"},{txd="Sugä",txt="Sugo",name="Sugar Menu"},{txd="Watermalone",txt="watermalone",name="Watermalone Menu"}}
        for i, data in pairs(DetectableTextures) do
            if data.x and data.y and not adbypass then
                if GetTextureResolution(data.txd, data.txt).x == data.x and
                    GetTextureResolution(data.txd, data.txt).y == data.y then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 33)
                end
            else
                if GetTextureResolution(data.txd, data.txt).x ~= 4.0 then
                    TriggerServerEvent("CORRUPT:AntiCheatBan", 33)
                end
            end
        end
    end
end)

CreateThread(function()
    local isAiming = false
    local targetPlayer = nil
    local aimStartTime = 0
    local aimDurationThreshold = 2
    local aimbotcanhave = 0
    while true do
        Wait(0)
        if IsAimCamActive() then
            local result, entity = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if result == 1 and DoesEntityExist(entity) and IsEntityAPed(entity) and IsPedAPlayer(entity) and not IsPedStill(entity) and not IsPedStill(PlayerPedId()) then
                local targetPed = GetPedIndexFromEntityIndex(entity)
                if not isAiming or targetPed ~= targetPlayer then
                    isAiming = true
                    targetPlayer = targetPed
                    aimStartTime = GetGameTimer()
                else
                    local currentTime = GetGameTimer()
                    local aimDuration = (currentTime - aimStartTime) / 1000
                    if aimDuration >= aimDurationThreshold then
                        TriggerServerEvent("CORRUPT:AntiCheatLog", 34, "Player can have Aimbot")
                        isAiming = false
                        targetPlayer = nil
                        aimStartTime = 0
                        aimbotcanhave = aimbotcanhave + 1
                    end
                end
            else
                isAiming = false
                targetPlayer = nil
                aimStartTime = 0
            end
        else
            isAiming = false
            targetPlayer = nil
            aimStartTime = 0
        end
        if aimbotcanhave >= 3 then
            TriggerServerEvent("CORRUPT:AntiCheatLog", 34, "Player can have Aimbot")
            aimbotcanhave = 0
        end
    end
end)


AddStateBagChangeHandler(nil, nil, function(bagName, key, value)
    if #key > 131072 then
        TriggerServerEvent("CORRUPT:AntiCheatBan", 34)
    end
end)