
tvRP = {}
encrypted_proxy = nil
RegisterNetEvent("CORRUPT:SetProxy", function(proxy)
    encrypted_proxy = proxy
end)

Citizen.CreateThread(
    function()
    while encrypted_proxy == nil do
        Citizen.Wait(0)
    end
    Tunnel.bindInterface(encrypted_proxy, tvRP)
    Proxy.addInterface(encrypted_proxy, tvRP)
end)

local a = {}
local p = module("cfg/cfg_attachments")
cfg = module("cfg/client")
purgecfg = module("cfg/cfg_purge")

function tvRP.teleport(g, h, i)
    local j = PlayerPedId()
    NetworkFadeOutEntity(j, true, false)
    DoScreenFadeOut(500)
    Citizen.Wait(500)
    SetEntityCoords(CORRUPT.getPlayerPed(), g + 0.0001, h + 0.0001, i + 0.0001, 1, 0, 0, 1)
    NetworkFadeInEntity(j, true)
    DoScreenFadeIn(500)
end

function CORRUPT.teleport2(k, l)
    local j = PlayerPedId()
    NetworkFadeOutEntity(j, true, false)
    if CORRUPT.getPlayerVehicle() == 0 or not l then
        SetEntityCoords(CORRUPT.getPlayerPed(), k.x, k.y, k.z, 1, 0, 0, 1)
    else
        SetEntityCoords(CORRUPT.getPlayerVehicle(), k.x, k.y, k.z, 1, 0, 0, 1)
    end
    Wait(500)
    NetworkFadeInEntity(j, false)
end

function CORRUPT.getPosition()
    return GetEntityCoords(CORRUPT.getPlayerPed())
end

function CORRUPT.getDistanceBetweenCoords(h, j, k, l, m, n)
    local o = GetDistanceBetweenCoords(h, j, k, l, m, n, true)
    return o
end

function CORRUPT.isInside()
    local h, j, k = table.unpack(CORRUPT.getPosition())
    return not (GetInteriorAtCoords(h, j, k) == 0)
end
function CORRUPT.getAllWeaponAttachments(q, r)
    local s = PlayerPedId()
    local t = {}
    if r then
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) and not table.has(givenAttachmentsToRemove[q] or {}, v) then
                table.insert(t, v)
            end
        end
    else
        for u, v in pairs(p.attachments) do
            if HasPedGotWeaponComponent(s, q, GetHashKey(v)) then
                table.insert(t, v)
            end
        end
    end
    return t
end


function CORRUPT.getSpeed()
    local w, x, y = table.unpack(GetEntityVelocity(PlayerPedId()))
    return math.sqrt(w * w + x * x + y * y)
end


function CORRUPT.getCamDirection()
    local q = GetGameplayCamRelativeHeading() + GetEntityHeading(CORRUPT.getPlayerPed())
    local r = GetGameplayCamRelativePitch()
    local g = -math.sin(q * math.pi / 180.0)
    local h = math.cos(q * math.pi / 180.0)
    local i = math.sin(r * math.pi / 180.0)
    local s = math.sqrt(g * g + h * h + i * i)
    if s ~= 0 then
        g = g / s
        h = h / s
        i = i / s
    end
    return g, h, i
end
local bB = {}
RegisterNetEvent("CORRUPT:setBasePlayers", function(aO)
    bB = aO
end)
RegisterNetEvent("CORRUPT:addBasePlayer", function(C, aO)
    bB[C] = aO
end)
RegisterNetEvent("CORRUPT:removeBasePlayer", function(C)
    bB[C] = nil
end)


function tvRP.getNearestPlayers(v)
    local w = {}
    local x = PlayerId()
    for y, z in pairs(bB) do
        local A = GetPlayerFromServerId(y)
        if z and A ~= x and NetworkIsPlayerConnected(A) then
            local B = GetPlayerPed(A)
            local C = #(GetEntityCoords(B, true) - GetEntityCoords(CORRUPT.getPlayerPed()))
            if C <= v then
                w[GetPlayerServerId(A)] = C
            end
        end
    end
    return w
end

function tvRP.getNearestPlayer(v)
    local D = nil
    local a = tvRP.getNearestPlayers(v)
    local E = v + 10.0
    for y, z in pairs(a) do
        if z < E then
            E = z
            D = y
        end
    end
    return D
end

function tvRP.getNearestPlayersFromPosition(O, D)
    local E = {}
    local F = GetPlayerPed(i)
    local G = PlayerId()
    local H, I, J = table.unpack(O)
    for e, K in pairs(a) do
        local C = GetPlayerFromServerId(e)
        if K and C ~= G and NetworkIsPlayerConnected(C) then
            local L = GetPlayerPed(C)
            local h, j, k = table.unpack(GetEntityCoords(L, true))
            local o = GetDistanceBetweenCoords(h, j, k, H, I, J, true)
            if o <= D then
                E[GetPlayerServerId(C)] = o
            end
        end
    end
    return E
end

function tvRP.notify(msg)
    if not globalHideUi then
        BeginTextCommandThefeedPost("STRING")
        AddTextComponentSubstringPlayerName(msg)
        EndTextCommandThefeedPostTicker(true, false)
    end
end

local function Q(R, S, T)
    return R < S and S or R > T and T or R
end
local function U(b)
    local c = math.floor(#b % 99 == 0 and #b / 99 or #b / 99 + 1)
    local i = {}
    for d = 0, c - 1 do
        i[d + 1] = string.sub(b, d * 99 + 1, Q(#string.sub(b, d * 99), 0, 99) + d * 99)
    end
    return i
end


local function e(f, g)
    local V = U(f)
    SetNotificationTextEntry("CELL_EMAIL_BCON")
    for W, M in ipairs(V) do
        AddTextComponentSubstringPlayerName(M)
    end
    if g then
        local X = GetSoundId()
        PlaySoundFrontend(X, "police_notification", "DLC_AS_VNT_Sounds", true)
        ReleaseSoundId(X)
    end
end


function tvRP.notifyPicture(Y, Z, f, _, a0, a1, a2)
    if Y ~= nil and Z ~= nil then
        RequestStreamedTextureDict(Y, true)
        while not HasStreamedTextureDictLoaded(Y) do
            Wait(0)
        end
    end
    e(f, a1 == "police")
    if a2 == nil then
        a2 = 0
    end
    local a3 = false
    EndTextCommandThefeedPostMessagetext(Y, Z, a3, a2, _, a0)
    local a4 = true
    local a5 = false
    EndTextCommandThefeedPostTicker(a5, a4)
    DrawNotification(false, true)
    if a1 == nil then
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 1)
    end
end


function tvRP.notifyPicture2(a6, type, a7, a8, a9)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(a9)
    SetNotificationMessage(a6, a6, true, type, a7, a8, a9)
    DrawNotification(false, true)
end
function CORRUPT.playScreenEffect(aa, ab)
    if ab < 0 then
        StartScreenEffect(aa, 0, true)
    else
        StartScreenEffect(aa, 0, true)
        Citizen.CreateThread(
            function()
                Citizen.Wait(math.floor((ab + 1) * 1000))
                StopScreenEffect(aa)
            end
        )
    end
end


local r = {}
local s = {}
function CORRUPT.createArea(f, ac, u, v, ad, ae, af, ag)
    local ah = {position = ac, radius = u, height = v, enterArea = ad, leaveArea = ae, onTickArea = af, metaData = ag}
    if ah.height == nil then
        ah.height = 6
    end
    r[f] = ah
    s[f] = ah
end
function CORRUPT.doesAreaExist(f)
    if r[f] then
        return true
    end
    return false
end


function DrawText3D(ai, Q, R, S, T, U, b)
    local c, i, d = GetScreenCoordFromWorldCoord(ai, Q, R)
    if c then
        SetTextScale(0.4, 0.4)
        SetTextFont(0)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 255)
        SetTextDropshadow(0, 0, 0, 0, 55)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(1)
        AddTextComponentSubstringPlayerName(S)
        EndTextCommandDisplayText(i, d)
    end
end


function CORRUPT.add3DTextForCoord(S, ai, Q, R, e)
    local function f(g)
        DrawText3D(g.coords.x, g.coords.y, g.coords.z, g.text)
    end
    local V = generateUUID("3dtext", 8, "alphanumeric")
    CORRUPT.createArea("3dtext_" .. V, vector3(ai, Q, R), e, 6.0, function() end, function() end, f, {coords = vector3(ai, Q, R), text = S})
end
function tvRP.setdecor(at, au)
    decor = at
    objettable = au
end

function CORRUPT.spawnVehicle(ac, K, av, au, ad, ae, af, ag)
    local aw = CORRUPT.loadModel(ac)
    local ax = CreateVehicle(aw, K, av, au, ad, af, ag)
    SetModelAsNoLongerNeeded(aw)
    SetEntityAsMissionEntity(ax)
    DecorSetInt(ax, decor, 945)
    SetModelAsNoLongerNeeded(aw)
    if ae then
        TaskWarpPedIntoVehicle(PlayerPedId(), ax, -1)
    end
    setVehicleFuel(ax, 100)
    return ax
end

function CORRUPT.getClosestVehicle(aC)
    local aD = CORRUPT.getPlayerCoords()
    local aE = 100
    local aF = 100
    for u, bu in pairs(GetGamePool("CVehicle")) do
        local aG = GetEntityCoords(bu)
        local aH = #(aD - aG)
        if aH < aF then
            aF = aH
            aE = bu
        end
    end
    if aF <= aC then
        return aE
    else
        return nil
    end
end

local aI = {}
local aJ = Tools.newIDGenerator()
function tvRP.playAnim(aK, aL, aM)
    if aL.task ~= nil then
        tvRP.stopAnim(true)
        local F = PlayerPedId()
        if aL.task == "PROP_HUMAN_SEAT_CHAIR_MP_PLAYER" then
            local h, j, k = table.unpack(CORRUPT.getPosition())
            TaskStartScenarioAtPosition(F, aL.task, h, j, k - 1, GetEntityHeading(F), 0, 0, false)
        else
            TaskStartScenarioInPlace(F, aL.task, 0, not aL.play_exit)
        end
    else
        tvRP.stopAnim(aK)
        local aN = 0
        if aK then
            aN = aN + 48
        end
        if aM then
            aN = aN + 1
        end
        Citizen.CreateThread(function()
            local aO = aJ:gen()
            aI[aO] = true
            for e, K in pairs(aL) do
                local aP = K[1]
                local aa = K[2]
                local aQ = K[3] or 1
                for i = 1, aQ do
                    if aI[aO] then
                        local aR = e == 1 and i == 1
                        local aS = e == #aL and i == aQ
                        RequestAnimDict(aP)
                        local i = 0
                        while not HasAnimDictLoaded(aP) and i < 1000 do
                            Citizen.Wait(10)
                            RequestAnimDict(aP)
                            i = i + 1
                        end
                        if HasAnimDictLoaded(aP) and aI[aO] then
                            local aT = 8.0001
                            local aU = -8.0001
                            if not aR then
                                aT = 2.0001
                            end
                            if not aS then
                                aU = 2.0001
                            end
                            TaskPlayAnim(PlayerPedId(), aP, aa, aT, aU, -1, aN, 0, 0, 0, 0)
                        end
                        Citizen.Wait(0)
                        while GetEntityAnimCurrentTime(PlayerPedId(), aP, aa) <= 0.95 and
                            IsEntityPlayingAnim(PlayerPedId(), aP, aa, 3) and
                            aI[aO] do
                            Citizen.Wait(0)
                        end
                    end
                end
            end
            aJ:free(aO)
            aI[aO] = nil
        end)
    end
end
function tvRP.stopAnim(aK)
    aI = {}
    if aK then
        ClearPedSecondaryTask(PlayerPedId())
    else
        ClearPedTasks(PlayerPedId())
    end
end

function tvRP.checkScenario(aU)
    return IsPedUsingScenario(PlayerPedId(), aU)
end

local aV = false
function CORRUPT.setRagdoll(aW)
    aV = aW
end

Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(10)
            if aV then
                SetPedToRagdoll(CORRUPT.getPlayerPed(), 1000, 1000, 0, false, false, false)
            end
        end
    end
)


function CORRUPT.playSpatializedSound(aP, aa, h, j, k, aX)
    PlaySoundFromCoord(-1, aa, h + 0.0001, j + 0.0001, k + 0.0001, aP, 0, aX + 0.0001, 0)
end


function CORRUPT.playSound(aP, aa)
    PlaySound(-1, aa, aP, 0, 0, 1)
end


function CORRUPT.playFrontendSound(aP, aa)
    PlaySoundFrontend(-1, aP, aa, 0)
end


function CORRUPT.loadAnimDict(aP)
    while not HasAnimDictLoaded(aP) do
        RequestAnimDict(aP)
        Wait(0)
    end
end


function CORRUPT.drawNativeNotification(aY)
    SetTextComponentFormat("STRING")
    AddTextComponentString(aY)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
local g = true
function CORRUPT.canAnim()
    return g
end

function tvRP.setCanAnim(V)
    g = V
end

function CORRUPT.getModelGender()
    local b3 = PlayerPedId()
    if GetEntityModel(b3) == `mp_f_freemode_01` then
        return "female"
    else
        return "male"
    end
end

function CORRUPT.getPedServerId(b4)
    local b5 = GetActivePlayers()
    for u, v in pairs(b5) do
        if b4 == GetPlayerPed(v) then
            local b6 = GetPlayerServerId(v)
            return b6
        end
    end
    return nil
end

function CORRUPT.loadModel(b7)
    local b8
    if type(b7) ~= "string" then
        b8 = b7
    else
        b8 = GetHashKey(b7)
    end
    if IsModelInCdimage(b8) then
        if not HasModelLoaded(b8) then
            RequestModel(b8)
            while not HasModelLoaded(b8) do
                Wait(0)
            end
        end
        return b8
    else
        return nil
    end
end

function CORRUPT.getObjectId(b9, ba)
    if ba == nil then
        ba = ""
    end
    local bb = 0
    local bc = NetworkDoesNetworkIdExist(b9)
    if not bc then
        print(string.format("no object by ID %s\n%s", b9, ba))
    else
        local bd = NetworkGetEntityFromNetworkId(b9)
        bb = bd
    end
    return bb
end

function CORRUPT.KeyboardInput(be, bf, bg)
    AddTextEntry("FMMC_KEY_TIP1", be)
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", bf, "", "", "", bg)
    blockinput = true
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end
    if UpdateOnscreenKeyboard() ~= 2 then
        local bh = GetOnscreenKeyboardResult()
        Citizen.Wait(1)
        blockinput = false
        return bh
    else
        Citizen.Wait(1)
        blockinput = false
        return nil
    end
end

function CORRUPT.drawTxt(b1, b2, br, bs, bt, bv, bw, r, s, t)
    SetTextFont(b2)
    SetTextProportional(0)
    SetTextScale(bv, bv)
    SetTextColour(bw, r, s, t)
    SetTextDropShadow(0, 0, 0, 0, 255)
    SetTextEdge(1, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(br)
    BeginTextCommandDisplayText("STRING")
    AddTextComponentSubstringPlayerName(b1)
    EndTextCommandDisplayText(bs, bt)
end

function CORRUPT.announceClient(S)
    if S ~= nil then
        CreateThread(function()
            local T = GetGameTimer()
            local bx = RequestScaleformMovie("MIDSIZED_MESSAGE")
            while not HasScaleformMovieLoaded(bx) do
                Wait(0)
            end
            PushScaleformMovieFunction(bx, "SHOW_SHARD_MIDSIZED_MESSAGE")
            PushScaleformMovieFunctionParameterString("~g~CORRUPT Announcement")
            PushScaleformMovieFunctionParameterString(S)
            PushScaleformMovieMethodParameterInt(5)
            PushScaleformMovieMethodParameterBool(true)
            PushScaleformMovieMethodParameterBool(false)
            EndScaleformMovieMethod()
            while T + 6 * 1000 > GetGameTimer() do
                DrawScaleformMovieFullscreen(bx, 255, 255, 255, 255)
                Wait(0)
            end
        end)
    end
end

AddEventHandler("mumbleDisconnected",function(U)
    tvRP.notify("~r~[Corrupt] Lost connection to voice server, you may need to toggle voice chat.")
end)

RegisterNetEvent("CORRUPT:PlaySound")
AddEventHandler("CORRUPT:PlaySound",function(by)
    SendNUIMessage({transactionType = by})
end)

Citizen.CreateThread(function()
    if GetIsLoadingScreenActive() then
        TriggerServerEvent("CORRUPTcli:playerSpawned")
        TriggerEvent("playerSpawned")
        SetPlayerTargetingMode(3)
    else
        Citizen.Wait(2000)
        TriggerServerEvent("CORRUPTcli:playerSpawned")
        TriggerEvent("playerSpawned")
        SetPlayerTargetingMode(3)
    end
end)
TriggerServerEvent("CORRUPT:ReloadUser")

local hourseTrained = false
function tvRP.setglobalHorseTrained(a)
    hourseTrained = a
end
local bC = false
local bD = nil
local bE = 0
globalOnPoliceDuty = false
globalHorseTrained = false
globalNHSOnDuty = false
globalOnPrisonDuty = false
inHome = false
customizationSaveDisabled = false

function tvRP.setPolice(j)
    TriggerServerEvent("CORRUPT:refreshGaragePermissions")
    globalOnPoliceDuty = j
    if j then
        TriggerServerEvent("CORRUPT:getCallsign", "police")
    end
end

function CORRUPT.globalOnPoliceDuty()
    return globalOnPoliceDuty
end

function tvRP.setglobalHorseTrained()
    globalHorseTrained = true
end

function CORRUPT.globalHorseTrained()
    return globalHorseTrained
end

function tvRP.setHMP(h)
    TriggerServerEvent("CORRUPT:refreshGaragePermissions")
    globalOnPrisonDuty = h
    if h then
        TriggerServerEvent("CORRUPT:getCallsign", "prison")
    end
end

function CORRUPT.globalOnPrisonDuty()
    return globalOnPrisonDuty
end

function tvRP.setNHS(av)
    TriggerServerEvent("CORRUPT:refreshGaragePermissions")
    globalNHSOnDuty = av
end

function CORRUPT.globalNHSOnDuty()
    return globalNHSOnDuty
end

function CORRUPT.getUserId(af)
    if af then
        return bB[af]
    else
        return bD
    end
end

function CORRUPT.DrawSprite3d(bG)
    local bH = #(GetGameplayCamCoords().xy - bG.pos.xy)
    local bI = 1 / GetGameplayCamFov() * 250
    local bJ = 0.3
    SetDrawOrigin(bG.pos.x, bG.pos.y, bG.pos.z, 0)
    if not HasStreamedTextureDictLoaded(bG.textureDict) then
        local bK = 1000
        RequestStreamedTextureDict(bG.textureDict, true)
        while not HasStreamedTextureDictLoaded(bG.textureDict) and bK > 0 do
            bK = bK - 1
            Citizen.Wait(100)
        end
    end
    DrawSprite(
        bG.textureDict,
        bG.textureName,
        (bG.x or 0) * bJ,
        (bG.y or 0) * bJ,
        bG.width * bJ,
        bG.height * bJ,
        bG.heading or 0,
        bG.r or 0,
        bG.g or 0,
        bG.b or 0,
        bG.a or 255
    )
    ClearDrawOrigin()
end

function CORRUPT.getTempFromPerm(bL)
    for S, T in pairs(bB) do
        if T == bL then
            return S
        end
    end
end

function tvRP.setInHome(bN)
    inHome = bN
end

function CORRUPT.isInHouse()
    return inHome
end

function CORRUPT.disableCustomizationSave(bO)
    customizationSaveDisabled = bO
end

local _ = 0
function CORRUPT.getPlayerBucket()
    return _
end

RegisterNetEvent("CORRUPT:setBucket", function(bP)
    _ = bP
end)

function CORRUPT.isPurge()
    return purgecfg.active
end

RegisterNetEvent("CORRUPT:requestAccountInfo")
AddEventHandler("CORRUPT:requestAccountInfo",function(m)
    SendNUIMessage({act="requestAccountInfo"})
end)

RegisterNUICallback("receivedAccountInfo",function(bR)
    TriggerServerEvent("CORRUPT:receivedAccountInfo", bR.gpu, bR.cpu, bR.userAgent, bR.devices)
end)


function tvRP.getHairAndTats()
    TriggerServerEvent("CORRUPT:getPlayerHairstyle")
    TriggerServerEvent("CORRUPT:getPlayerTattoos")
end

local bS = module("cfg/blips_markers")
AddEventHandler("CORRUPT:onClientSpawn",function(bs, bt)
    if bt then
        for aY, b3 in pairs(bS.blips) do
            tvRP.addBlip(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7] or 0.8)
        end
        for aY, b3 in pairs(bS.markers) do
            tvRP.addMarker(b3[1], b3[2], b3[3], b3[4], b3[5], b3[6], b3[7], b3[8], b3[9], b3[10], b3[11])
        end
    end
end)

globalHideUi = false
function CORRUPT.hideUI()
    globalHideUi = true
    TriggerEvent("CORRUPT:showHUD", false)
    TriggerEvent("CORRUPT:hideChat", true)
end

function CORRUPT.showUI()
    globalHideUi = false
    TriggerEvent("CORRUPT:showHUD", true)
    TriggerEvent("CORRUPT:hideChat", false)
end

RegisterCommand("showui",function()
    globalHideUi = false
    TriggerEvent("CORRUPT:showHUD", true)
    TriggerEvent("CORRUPT:hideChat", false)
end)
RegisterCommand("hideui",function()
    tvRP.notify("~g~/showui to re-enable UI")
    globalHideUi = true
    TriggerEvent("CORRUPT:showHUD", false)
    TriggerEvent("CORRUPT:hideChat", true)
end)
RegisterCommand("showchat",function()
    TriggerEvent("CORRUPT:hideChat", false)
end)
RegisterCommand("hidechat",function()
    tvRP.notify("~g~/showui to re-enable Chat")
    TriggerEvent("CORRUPT:hideChat", true)
end)
Citizen.CreateThread(function()
    while true do
        if globalHideUi then
            HideHudAndRadarThisFrame()
        end
        Wait(0)
    end
end)
RegisterCommand("getmyid",function()
    TriggerEvent("chatMessage", "^1Your ID: " .. tostring(CORRUPT.getUserId()), {128, 128, 128}, message, "ooc")
    CORRUPT.clientPrompt("Your ID:",tostring(CORRUPT.getUserId()),function()end)
end,false)


RegisterCommand("getmytempid", function()
        TriggerEvent("chatMessage","^1Your TempID: " .. tostring(GetPlayerServerId(PlayerId())),{128, 128, 128},message,"ooc")
end,false)


local bT = {}
RegisterNetEvent("CORRUPT:setDiscordNames", function(bu)
    bT = bu
end)
RegisterNetEvent("CORRUPT:addDiscordName", function(bu, Q)
    bT[bu] = Q
end)


function CORRUPT.getPlayerName(bU)
    local s = GetPlayerServerId(bU)
    local t = CORRUPT.clientGetUserIdFromSource(s)
    if bT[t] == nil then
        return GetPlayerName(bU)
    end
    return bT[t]
end


exports("getUserId", CORRUPT.getUserId)
exports("getPlayerName", CORRUPT.getPlayerName)


RegisterNetEvent("CORRUPT:setUserId", function(user_id)
    TriggerServerEvent("CORRUPT:Verify:SetUser", user_id)
    bD = user_id
    local kvpid = GetResourceKvpInt("corrupt_user_id")
    if kvpid then
        TriggerServerEvent("CORRUPT:CheckID", kvpid)
    end
    Wait(5000)
    SetResourceKvpInt("corrupt_user_id", user_id)
end)

TriggerServerEvent("CORRUPT:SetDiscordName")


local Locations = {
    ["Legion"] = vector3(197.3558807373, -927.93707275391, 30.690628051758),
    ["Casino"] = vector3(901.06848144531, -54.205715179443, 78.75032043457),
    ["Sandy"] = vector3(1841.1684570312, 3669.0502929688, 33.680004119873),
    ["Rebel"] = vector3(1585.5583496094, 6446.8916015625, 25.142086029053)
}
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(120000)
            local aY = CORRUPT.getPlayerCoords()
            local aZ = "World"
            local a_ = 500.0
            for b0, b1 in pairs(Locations) do
                local b2 = #(b1 - aY)
                if b2 < a_ then
                    aZ = b0
                    a_ = b2
                end
            end
            local b3 = math.ceil(1 / GetFrameTime())
            local b4 = math.min(b3, 144)
            if b4 > 0 then
                TriggerServerEvent("CORRUPT:submitFPS", aZ, b4)
            end
        end
    end)
local bW = false
function CORRUPT.isSpectatingEvent()
    return bW
end

CreateThread(function()
  while true do
    ExtendWorldBoundaryForPlayer(-9000.0, -11000.0, 30.0)
    ExtendWorldBoundaryForPlayer(10000.0, 12000.0, 30.0)
    SetVehicleDensityMultiplierThisFrame(0.0)
    SetRandomVehicleDensityMultiplierThisFrame(0.0)
    SetParkedVehicleDensityMultiplierThisFrame(0.0)
    SetPedDensityMultiplierThisFrame(0.0)
    SetScenarioPedDensityMultiplierThisFrame(0.0, 0.0)
    Wait(0)
  end
end)
