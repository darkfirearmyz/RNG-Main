local a = module("cfg/cfg_attachments")
local function b(c, d, e)
    return c < d and d or c > e and e or c
end
local function f(g)
    local h = math.floor(#g % 99 == 0 and #g / 99 or #g / 99 + 1)
    local i = {}
    for j = 0, h - 1 do
        i[j + 1] = string.sub(g, j * 99 + 1, b(#string.sub(g, j * 99), 0, 99) + j * 99)
    end
    return i
end
local function k(l, m)
    local n = f(l)
    BeginTextCommandThefeedPost("CELL_EMAIL_BCON")
    for o, p in ipairs(n) do
        AddTextComponentSubstringPlayerName(p)
    end
    if m then
        local q = GetSoundId()
        PlaySoundFrontend(q, "police_notification", "DLC_AS_VNT_Sounds", true)
        ReleaseSoundId(q)
    end
end
function CORRUPT.loadModel(r)
    local s
    if type(r) ~= "string" then
        s = r
    else
        s = GetHashKey(r)
    end
    if IsModelInCdimage(s) then
        if not HasModelLoaded(s) then
            RequestModel(s)
            while not HasModelLoaded(s) do
                Wait(0)
            end
        end
        return s
    else
        return nil
    end
end
function CORRUPT.loadAnimDict(t)
    if not HasAnimDictLoaded(t) then
        RequestAnimDict(t)
        while not HasAnimDictLoaded(t) do
            Wait(0)
        end
    end
    return t
end
function CORRUPT.loadClipSet(u)
    if not HasClipSetLoaded(u) then
        RequestClipSet(u)
        while not HasClipSetLoaded(u) do
            Wait(0)
        end
    end
end
function CORRUPT.loadPtfx(v)
    if not HasNamedPtfxAssetLoaded(v) then
        RequestNamedPtfxAsset(v)
        while not HasNamedPtfxAssetLoaded(v) do
            Wait(0)
        end
    end
    UseParticleFxAsset(v)
end
function getMoneyStringFormatted(w)
    local j, x, y, z, A = tostring(w):find("([-]?)(%d+)([.]?%d*)")
    z = z:reverse():gsub("(%d%d%d)", "%1,")
    return y .. z:reverse():gsub("^,", "") .. A
end
function tvRP.getStreetNameAtCoord(B, C, D)
    return GetStreetNameFromHashKey(GetStreetNameAtCoord(B, C, D))
end
RegisterNetEvent("CORRUPT:notifyMessage",function(l)
    tvRP.notify(l)
end)
function CallScaleformMethod(method, ...)
	local t
	local args = { ... }
	BeginScaleformMovieMethod(Scaleform, method)
	for _, v in ipairs(args) do
		t = type(v)
		if t == "string" then
			PushScaleformMovieMethodParameterString(v)
		elseif t == "number" then
			if string.match(tostring(v), "%.") then
				PushScaleformMovieFunctionParameterFloat(v)
			else
				PushScaleformMovieFunctionParameterInt(v)
			end
		elseif t == "boolean" then
			PushScaleformMovieMethodParameterBool(v)
		end
	end
	EndScaleformMovieMethod()
end
function getAllWeaponAttachments(E, F)
    local G = PlayerPedId()
    local H = {}
    if F then
        for I, J in pairs(a.attachments) do
            if HasPedGotWeaponComponent(G, E, GetHashKey(J)) and not table.has(givenAttachmentsToRemove[E] or {}, J) then
                table.insert(H, J)
            end
        end
    else
        for I, J in pairs(a.attachments) do
            if HasPedGotWeaponComponent(G, E, GetHashKey(J)) then
                table.insert(H, J)
            end
        end
    end
    return H
end
function drawNativeNotification(K, L)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(K)
    if L then
        EndTextCommandDisplayHelp(0, false, false, -1)
    else
        EndTextCommandDisplayHelp(0, 0, 1, -1)
    end
end
function drawNativeText(M)
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName(M)
    EndTextCommandPrint(1000, 1)
end
function clearNativeText()
    BeginTextCommandPrint("STRING")
    AddTextComponentSubstringPlayerName("")
    EndTextCommandPrint(1, true)
end
function CORRUPT.spawnVehicle(N, B, C, D, O, P, Q, R)
    local S = CORRUPT.loadModel(N)
    local T = CreateVehicle(S, B, C, D, O, Q, R)
    SetModelAsNoLongerNeeded(S)
    SetEntityAsMissionEntity(T, false, false)
    DecorSetInt(T, decor, 945)
    SetModelAsNoLongerNeeded(S)
    if P then
        TaskWarpPedIntoVehicle(PlayerPedId(), T, -1)
    end
    setVehicleFuel(T, 100)
    return T
end
function CORRUPT.loadWeaponAsset(U)
    local U = GetHashKey(U)
    RequestWeaponAsset(U, 31, 0)
    while not HasWeaponAssetLoaded(U) do
        Wait(0)
    end
    return U
end
function CORRUPT.spawnWeaponObject(E, B, C, D)
    local V = CORRUPT.loadWeaponAsset(E)
    local W = CreateWeaponObject(V, 0, B, C, D, true, 0, 0)
    return W
end
function CORRUPT.getPedServerId(X)
    local Y = GetActivePlayers()
    for I, J in pairs(Y) do
        if X == GetPlayerPed(J) then
            local Z = GetPlayerServerId(J)
            return Z
        end
    end
    return nil
end
function CORRUPT.syncNetworkId(_)
    SetNetworkIdExistsOnAllMachines(_, true)
    SetNetworkIdCanMigrate(_, false)
    NetworkUseHighPrecisionBlending(_, true)
end
Citizen.CreateThread(
    function()
        if not HasStreamedTextureDictLoaded("timerbars") then
            RequestStreamedTextureDict("timerbars", false)
            while not HasStreamedTextureDictLoaded("timerbars") do
                Wait(0)
            end
        end
    end
)
function DrawGTATimerBar(a0, K, a1, a2, a3, a4)
    local a5 = 0.17
    local a6 = -0.01
    local a7 = 0.038
    local a8 = 0.008
    local a9 = 0.005
    local a4 = a4 or 0.32
    local a2 = a2 or 0.5
    local aa = -0.04
    local ab = 0.014
    local ac = GetSafeZoneSize()
    local ad = ab + ac - a5 + a5 / 2
    local ae = aa + ac - a7 + a7 / 2 - (a1 - 1) * (a7 + a9)
    DrawSprite("timerbars", "all_black_bg", ad, ae, a5, 0.038, 0, 0, 0, 0, 128)
    DrawGTAText(a0, ac - a5 + 0.06, ae - a8, a4)
    DrawGTAText(string.upper(K), ac - a6 + (a3 or 0), ae - 0.0175, a2, true, a5 / 2)
end
function GetPlayers()
    local Y = {}
    for o, j in ipairs(GetActivePlayers()) do
        table.insert(Y, j)
    end
    return Y
end
function GetClosestPlayer(af)
    local Y = GetPlayers()
    local ag = -1
    local ah = -1
    local ai = PlayerPedId()
    local aj = GetEntityCoords(ai, 0)
    for o, c in ipairs(Y) do
        local ak = GetPlayerPed(c)
        if ak ~= ai then
            local al = GetEntityCoords(GetPlayerPed(c), 0)
            local am = #(al - aj)
            if ag == -1 or ag > am then
                ah = c
                ag = am
            end
        end
    end
    if ag <= af then
        return ah
    else
        return nil
    end
end
function CORRUPT.randomNum(d, e)
    math.randomseed(GetGameTimer() * math.random() * 2)
    return math.random(d, e)
end
function CORRUPT.notifyPicture(an, ao, l, a0, ap, aq, ar)
    if an ~= nil and ao ~= nil then
        RequestStreamedTextureDict(an, true)
        while not HasStreamedTextureDictLoaded(an) do
            print("stuck loading", an)
            Wait(0)
        end
    end
    k(l, aq == "police")
    if ar == nil then
        ar = 0
    end
    local as = false
    EndTextCommandThefeedPostMessagetext(an, ao, as, ar, a0, ap)
    local at = true
    local au = false
    EndTextCommandThefeedPostTicker(au, at)
    EndTextCommandThefeedPostTicker(false, true)
    if aq == nil then
        PlaySoundFrontend(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 1)
    end
end
RegisterNetEvent("CORRUPT:notifyPicture", CORRUPT.notifyPicture)
soundEventCode = 0
TriggerServerEvent("CORRUPT:soundCodeServer")
RegisterNetEvent("CORRUPT:soundCode",function(av)
    soundEventCode = av
end)
RegisterNetEvent("CORRUPT:playClientNuiSound",function(aw, ax, af)
    local ay = CORRUPT.getPlayerCoords()
    if #(ay - aw) <= af then
        SendNUIMessage({transactionType = ax})
    end
end)
RegisterNetEvent(
    "__CORRUPT_callback:client",
    function(az, ...)
        local aA = promise.new()
        TriggerEvent(
            string.format("c__CORRUPT_callback:%s", az),
            function(...)
                aA:resolve({...})
            end,
            ...
        )
        local aB = Citizen.Await(aA)
        TriggerServerEvent(string.format("__CORRUPT_callback:server:%s", az), table.unpack(aB))
    end
)
CORRUPT.TriggerServerCallback = function(az, ...)
    assert(type(az) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(az))
    local aA = promise.new()
    local aC = GetGameTimer()
    RegisterNetEvent(string.format("__CORRUPT_callback:client:%s:%s", az, aC))
    local aD =
        AddEventHandler(
        string.format("__CORRUPT_callback:client:%s:%s", az, aC),
        function(...)
            aA:resolve({...})
        end
    )
    TriggerServerEvent("__CORRUPT_callback:server", az, aC, ...)
    local aB = Citizen.Await(aA)
    RemoveEventHandler(aD)
    return table.unpack(aB)
end
CORRUPT.RegisterClientCallback = function(az, aE)
    assert(type(az) == "string", "Invalid Lua type at argument #1, expected string, got " .. type(az))
    assert(type(aE) == "function", "Invalid Lua type at argument #2, expected function, got " .. type(aE))
    AddEventHandler(
        string.format("c__CORRUPT_callback:%s", az),
        function(aF, ...)
            aF(aE(...))
        end
    )
end
function pairsByKeys(aG, aH)
    local aI = {}
    for aJ in pairs(aG) do
        table.insert(aI, aJ)
    end
    table.sort(aI, aH)
    local j = 0
    local aK = function()
        j = j + 1
        if aI[j] == nil then
            return nil
        else
            return aI[j], aG[aI[j]]
        end
    end
    return aK
end
function sortAlphabetically(aL)
    local aG = {}
    for a0, c in pairsByKeys(aL) do
        table.insert(aG, {title = a0, value = c})
    end
    aL = aG
    return aL
end
function CORRUPT.getNetId(aM, aN)
    if aN == nil then
        aN = ""
    end
    local aO = 0
    local aP = DoesEntityExist(aM)
    if not aP then
    else
        aO = NetworkGetNetworkIdFromEntity(aM)
        if aO == aM then
        end
    end
    return aO
end
function CORRUPT.getObjectId(aQ, aN)
    if aN == nil then
        aN = ""
    end
    local aA = 0
    local aR = NetworkDoesNetworkIdExist(aQ)
    if not aR then
    else
        local aS = NetworkGetEntityFromNetworkId(aQ)
        aA = aS
    end
    return aA
end
local aT = {}
local aU = {}
Citizen.CreateThread(
    function()
        local a = module("corrupt-assets", "cfg/cfg_garages")
        for aV, J in pairs(a.garages) do
            for aW, aX in pairs(J) do
                if aV ~= "_config" then
                    local aY = aX[1]
                    local aZ = string.lower(aW)
                    if not aT[aZ] then
                        aT[aZ] = {name = aY, garageType = aV}
                        aU[GetHashKey(aZ)] = aZ
                    end
                end
            end
        end
    end
)
function CORRUPT.getVehicleNameFromId(aZ)
    if aT[string.lower(aZ)] then
        return aT[string.lower(aZ)].name
    end
    return ""
end
function CORRUPT.getGarageNameFromId(aZ)
    return aT[string.lower(aZ)].garageType
end
function CORRUPT.getVehicleIdFromModel(s)
    return aU[s]
end
local a_ = math.rad
local b0 = math.cos
local b1 = math.sin
local b2 = math.abs
function CORRUPT.rotationToDirection(b3)
    local B = a_(b3.x)
    local D = a_(b3.z)
    return vector3(-b1(D) * b2(b0(B)), b0(D) * b2(b0(B)), b1(B))
end
