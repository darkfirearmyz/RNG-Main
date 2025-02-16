local cfg = module("cfg/cfg_purge")
local a = cfg.coords[cfg.location]
local function b()
    math.random()
    math.random()
    math.random()
    return a[math.random(1, #a)]
end
local c = false
function CORRUPT.hasSpawnProtection()
    return c
end
local function d()
    c = true
    SetTimeout(10000,function()
        c = false
    end)
    Citizen.CreateThread(function()
        SetLocalPlayerAsGhost(true)
        while c do
            SetEntityProofs(CORRUPT.getPlayerPed(), true, true, true, true, true, true, true, true)
            SetEntityAlpha(CORRUPT.getPlayerPed(), 100, false)
            Wait(0)
        end
        SetEntityAlpha(CORRUPT.getPlayerPed(), 255, false)
        SetLocalPlayerAsGhost(false)
        ResetGhostedEntityAlpha()
        CORRUPT.notify("~g~Spawn protection ended!")
        SetEntityProofs(CORRUPT.getPlayerPed(), false, false, false, false, false, false, false, false)
    end)
end
local e
RegisterNetEvent("CORRUPT:purgeSpawnClient")
AddEventHandler("CORRUPT:purgeSpawnClient",function(j)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    d()
    DoScreenFadeOut(250)
    CORRUPT.hideUI()
    Wait(500)
    TriggerScreenblurFadeIn(100.0)
    e = b()
    RequestCollisionAtCoord(e.x, e.y, e.z)
    local k = GetGameTimer()
    while HaveAllStreamingRequestsCompleted(CORRUPT.getPlayerPed()) ~= 1 and GetGameTimer() - k < 5000 do
        Wait(0)
        print("[CORRUPT] Waiting for streaming requests to complete!")
    end
    CORRUPT.checkCustomization()
    TriggerServerEvent('CORRUPT:getPlayerHairstyle')
    TriggerServerEvent('CORRUPT:getPlayerTattoos')
    DoScreenFadeIn(1000)
    CORRUPT.showUI()
    local l = CORRUPT.getPlayerCoords()
    SetEntityCoordsNoOffset(CORRUPT.getPlayerPed(), l.x, l.y, 1200.0, false, false, false)
    SetEntityVisible(CORRUPT.getPlayerPed(), false, false)
    FreezeEntityPosition(CORRUPT.getPlayerPed(), true)
    SetEntityVisible(CORRUPT.getPlayerPed(), true, true)
    SetFocusPosAndVel(e.x, e.y, e.z + 1000, 0.0, 0.0, 0.0)
    spawnCam = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", e.x, e.y, e.z + 1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActive(spawnCam, true)
    RenderScriptCams(true, true, 0, true, false)
    spawnCam2 = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", e.x, e.y, e.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
    SetCamActiveWithInterp(spawnCam2, spawnCam, 5000, 0, 0)
    Wait(2500)
    ClearFocus()
    if not j then
        SetEntityCoords(CORRUPT.getPlayerPed(), e.x, e.y, e.z)
    end
    FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
    TriggerScreenblurFadeOut(2000.0)
    Wait(2000)
    DestroyCam(spawnCam, false)
    DestroyCam(spawnCam2, false)
    RenderScriptCams(false, true, 2000, 0, 0)
    CORRUPT.setHealth(200)
    TriggerServerEvent("CORRUPT:purgeClientHasSpawned")
end)
RegisterNetEvent("CORRUPT:purgeGetWeapon")
AddEventHandler("CORRUPT:purgeGetWeapon",function()
    tvRP.notify("~o~Random weapon received!")
    PlaySoundFrontend(-1, "Weapon_Upgrade", "DLC_GR_Weapon_Upgrade_Soundset", true)
end)
Citizen.CreateThread(function()
    if CORRUPT.isPurge() then
        local m = AddBlipForRadius(0.0, 0.0, 0.0, 50000.0)
        SetBlipColour(m, 1)
        SetBlipAlpha(m, 180)
    end
end)
RegisterCommand("airport", function()
    if CORRUPT.isPurge() then
        local checkCoords = CORRUPT.getPlayerCoords()
        tvRP.notify("~g~Teleporting to airport... please wait.")
        Wait(5000)
        if checkCoords == CORRUPT.getPlayerCoords() then
            tvRP.teleport(-1113.495, -2917.377, 13.94363)
            tvRP.notify("~g~Teleported to airport, use /suicide to return to the purge.")
        else
            tvRP.notify("~r~Teleportation failed, please remain still when teleporting.")
        end
    end
end)