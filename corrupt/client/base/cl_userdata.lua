local a = false
AddEventHandler(
    "playerSpawned",
    function()
        a = false
        Citizen.CreateThread(
            function()
                Citizen.Wait(2000)
                a = true
            end
        )
    end
)

local b = {}
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(3000)
            if IsPlayerPlaying(PlayerId()) and a then
                if json.encode(b) ~= json.encode(tvRP.getWeapons()) then
                    b = tvRP.getWeapons()
                    CORRUPT.SetUiCurrentWeapons(b)
                    TriggerServerEvent("CORRUPT:updateWeapons", b)
                end
            end
        end
    end
)
local c = {}
Citizen.CreateThread(
    function()
        print("[Corrupt] Loading cached user data.")
        c = json.decode(GetResourceKvpString("corrupt_userdata") or "{}")
        if type(c) ~= "table" then
            c = {}
            print("[Corrupt] Failed to load cached user data setting to default.")
        else
            print("[Corrupt] Loaded cached user data.")
        end
    end
)
function CORRUPT.updateCustomization(d)
    local e = tvRP.getCustomization()
    if e.modelhash ~= 0 and IsModelValid(e.modelhash) then
        c.customisation = e
        if d then
            SetResourceKvp("corrupt_userdata", json.encode(c))
        end
    end
end
function CORRUPT.updateHealth(d)
    c.health = GetEntityHealth(PlayerPedId())
    if d then
        SetResourceKvp("corrupt_userdata", json.encode(c))
    end
end
function CORRUPT.updateArmour(d)
    c.armour = GetPedArmour(PlayerPedId())
    if d then
        SetResourceKvp("corrupt_userdata", json.encode(c))
    end
end
local f = vector3(0.0, 0.0, 0.0)
function CORRUPT.updatePos(d)
    local g = GetEntityCoords(PlayerPedId())
    if g.z > -150.0 and #(g - f) > 15.0 then
        c.position = g
        if d then
            SetResourceKvp("corrupt_userdata", json.encode(c))
        end
    end
end
Citizen.CreateThread(
    function()
        Wait(30000)
        while true do
            Wait(5000)
            if not CORRUPT.isInHouse() and not inOrganHeist and not CORRUPT.isPlayerInRedZone() and not CORRUPT.isInSpectate() and not CORRUPT.playerInWager()then
                CORRUPT.updatePos()
            end
            if not tvRP.isStaffedOn() and not CORRUPT.isPlayerInAnimalForm() then
                CORRUPT.updateCustomization()
            end
            CORRUPT.updateHealth()
            CORRUPT.updateArmour()
            SetResourceKvp("corrupt_userdata", json.encode(c))
        end
    end
)
function CORRUPT.checkCustomization()
    local e = c.customisation
    if e == nil or e.modelhash == 0 or not IsModelValid(e.modelhash) then
        tvRP.setCustomization(getDefaultCustomization(), true, true)
    else
        tvRP.setCustomization(e, true, true)
    end
end
function getDefaultCustomization(h)
    local i = {}
    i = {}
    i.model = h and "mp_f_freemode_01" or "mp_m_freemode_01"
    for j = 0, 19 do
        i[j] = {0, 0}
    end
    if h then
        i[0] = {33, 0}
        i[3] = {2, 0}
        i[11] = {2, 0}
    else
        i[0] = {0, 0}
        i[3] = {5, 0}
        i[11] = {5, 0}
    end
    i[1] = {0, 0}
    i[2] = {47, 0}
    i[4] = {4, 0}
    i[5] = {0, 0}
    i[6] = {7, 0}
    i[7] = {51, 0}
    i[8] = {0, 240}
    i[9] = {0, 1}
    i[10] = {0, 0}
    i[12] = {4, 0}
    i[15] = {0, 2}
    return i
end
RegisterNetEvent("CORRUPT:spawnAnim", function()
    DoScreenFadeOut(250)
    CORRUPT.hideUI()
    local k = c.position or vector3(178.5132598877, -1007.5575561523, 29.329647064209)
    Wait(500)
    TriggerScreenblurFadeIn(100.0)
    RequestCollisionAtCoord(k.x, k.y, k.z)
    NewLoadSceneStartSphere(k.x, k.y, k.z, 100.0, 2)
    SetEntityCoordsNoOffset(PlayerPedId(), k.x, k.y, k.z, true, false, false)
    SetEntityVisible(PlayerPedId(), false, false)
    FreezeEntityPosition(PlayerPedId(), true)
    local l = GetGameTimer()
    while (not HaveAllStreamingRequestsCompleted(PlayerPedId()) or GetNumberOfStreamingRequests() > 0) and
        GetGameTimer() - l < 10000 do
        Wait(0)
    end
    NewLoadSceneStop()
    CORRUPT.checkCustomization()
    TriggerServerEvent("CORRUPT:getPlayerHairstyle")
    TriggerServerEvent("CORRUPT:getPlayerTattoos")
    TriggerEvent("CORRUPT:playGTAIntro")
    TriggerEvent("CORRUPT:ForceRefreshData")
    TriggerServerEvent("CORRUPT:AntiCheat:Eulen:Check")
    DoScreenFadeIn(1000)
    ShutdownLoadingScreen()
    ShutdownLoadingScreenNui()
    if not CORRUPT.isDeveloper() then
        SetFocusPosAndVel(k.x, k.y, k.z + 1000)
        local m = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", k.x, k.y, k.z + 1000, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActive(m, true)
        RenderScriptCams(true, true, 0, 1, 0)
        local n = CreateCameraWithParams("DEFAULT_SCRIPTED_CAMERA", k.x, k.y, k.z, 0.0, 0.0, 0.0, 65.0, 0, 2)
        SetCamActiveWithInterp(n, m, 5000, 0, 0)
        Wait(2500)
        ClearFocus()
        TriggerScreenblurFadeOut(2000.0)
        Wait(2000)
        DestroyCam(m)
        DestroyCam(n)
        RenderScriptCams(false, true, 2000, 0, 0)
    else
        TriggerScreenblurFadeOut(500.0)
    end
    CORRUPT.setHealth(c.health or 200)
    CORRUPT.setArmour(c.armour)
    SetEntityVisible(PlayerPedId(), true, false)
    FreezeEntityPosition(PlayerPedId(), false)
    if not CORRUPT.isDeveloper() then
        Citizen.Wait(2000)
    end
    CORRUPT.showUI()
end)
spawning = false
AddEventHandler(
    "CORRUPT:playGTAIntro",
    function()
        if not CORRUPT.isDeveloper() then
            SendNUIMessage({transactionType = "gtaloadin"})
        end
    end
)
RegisterNetEvent("CORRUPT:setHairstyle")
AddEventHandler(
    "CORRUPT:setHairstyle",
    function(o)
        if o then
            dad = o["dad"] or 0
            mum = o["mum"] or 0
            skin = o["skin"] or 0
            dadmumpercent = o["dadmumpercent"] or 0
            eyecolor = o["eyecolor"] or 0
            acne = o["acne"] or 0
            skinproblem = o["skinproblem"] or 0
            freckle = o["freckle"] or 0
            wrinkle = o["wrinkle"] or 0
            wrinkleopacity = o["wrinkleopacity"] or 0
            hair = o["hair"] or 0
            haircolor = o["haircolor"] or 0
            eyebrow = o["eyebrow"] or 0
            eyebrowopacity = o["eyebrowopacity"] or 0
            beard = o["beard"] or 0
            beardopacity = o["beardopacity"] or 0
            beardcolor = o["beardcolor"] or 0
            eyeshadow = o["eyeshadow"] or 0
            lipstick = o["lipstick"] or 0
            eyeshadowcolour = o["eyeshadowcolour"] or 0
            lipstickcolour = o["lipstickcolour"] or 0
            facepaints = o["facepaints"] or 0
            facepaintscolour = o["facepaintscolour"] or 0
            SetPedHeadBlendData(
                GetPlayerPed(-1),
                dad,
                mum,
                0,
                skin,
                skin,
                skin,
                dadmumpercent,
                dadmumpercent,
                0.0,
                false
            )
            SetPedEyeColor(GetPlayerPed(-1), eyecolor)
            if acne == 0 then
                SetPedHeadOverlay(GetPlayerPed(-1), 0, acne, 0.0)
            else
                SetPedHeadOverlay(GetPlayerPed(-1), 0, acne, 1.0)
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 6, skinproblem, 1.0)
            if freckle == 0 then
                SetPedHeadOverlay(GetPlayerPed(-1), 9, freckle, 0.0)
            else
                SetPedHeadOverlay(GetPlayerPed(-1), 9, freckle, 1.0)
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 3, wrinkle, wrinkleopacity * 0.1)
            SetPedComponentVariation(GetPlayerPed(-1), 2, hair, 0, 2)
            SetPedHairColor(GetPlayerPed(-1), haircolor, haircolor)
            SetPedHeadOverlay(GetPlayerPed(-1), 2, eyebrow, eyebrowopacity * 0.1)
            SetPedHeadOverlay(GetPlayerPed(-1), 1, beard, beardopacity * 0.1)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 1, 1, beardcolor, beardcolor)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 2, 1, beardcolor, beardcolor)
            eyeShadowOpacity = 1.0
            if eyeshadow == 0 then
                eyeShadowOpacity = 0.0
            end
            lipstickOpacity = 1.0
            if lipstick == 0 then
                lipstickOpacity = 0.0
            end
            SetPedHeadOverlay(GetPlayerPed(-1), 4, eyeshadow, eyeShadowOpacity)
            SetPedHeadOverlay(GetPlayerPed(-1), 8, lipstick, lipstickOpacity)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 4, 1, eyeshadowcolour, eyeshadowcolour)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 8, 1, lipstickcolour, lipstickcolour)
            SetPedHeadOverlay(GetPlayerPed(-1), 4, facepaints, 1.0)
            SetPedHeadOverlayColor(GetPlayerPed(-1), 4, 1, facepaintscolour, 0)
        end
    end
)
