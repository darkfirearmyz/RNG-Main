DecorRegister("corrupt_owner", 3)
DecorRegister("corrupt_uuid", 3)
DecorRegister("lootid", 3)
DecorRegister("lsAudioId", 3)
RequestScriptAudioBank("DLC_ALARM\\ALARMPACK_ONE", false)
local a = module("corrupt-assets", "cfg/cfg_garages")
local b = module("cfg/cfg_lscustoms")
globalVehicleOwnership = {}
globalOwnedPlayerVehicles = {}
globalLastSpawnedVehicleTime = 0
local vehicleWeightsTable = {}
local garage_type = ""
local lastSpawnedType = nil
local c = {}
local d = 0
local e = ""
local f = ""
local g = ""
local h = nil
local j = ""
local k = {}
local l = 0
local m = 0
local n = {}
local o = false
local p = {}
local q = {}
local r = {}
local s = {}
local t = false
local u = false
local v = {
    [0] = "",
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = "",
    [6] = "bnr34ffeng",
    [7] = "ta028viper",
    [8] = "rotary7",
    [9] = "lgcy12ferf40",
    [10] = "v6audiea839",
    [11] = "n55b30t0",
    [12] = "fordvoodoo",
    [13] = "ta103ninjah2r",
    [14] = "dchallengerhellcat"
}
local w = {}
local x = {}
local y = {}
local z = {}
RegisterNetEvent('CORRUPT:returnVehicleWeights')
AddEventHandler('CORRUPT:returnVehicleWeights', function(vehicleWeights)
    vehicleWeightsTable = vehicleWeights
end)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(A, B)
        if B then
            TriggerServerEvent("CORRUPT:refreshGaragePermissions")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:recieveRefreshedGaragePermissions",
    function(C)
        c = C
    end
)
RegisterNetEvent(
    "CORRUPT:initRentingVehicles",
    function(D)
        p = D
    end
)
RegisterNetEvent(
    "CORRUPT:initRentedVehicles",
    function(E)
        q = E
    end
)
RegisterNetEvent(
    "CORRUPT:insertRentedVehicles",
    function(F)
        table.insert(q, F)
    end
)
RegisterNetEvent(
    "CORRUPT:insertRentingVehicles",
    function(G)
        table.insert(p, G)
    end
)
RegisterNetEvent(
    "CORRUPT:setVehicleRarity",
    function(H, I)
        w[H] = I
    end
)
RegisterNetEvent(
    "CORRUPT:setVehicleMilage",
    function(J, K)
        x[J] = K
    end
)
RegisterNetEvent(
    "CORRUPT:decreaseHourRentedVehicles",
    function(H)
        for L, M in pairs(q) do
            if string.lower(M.vehicleId) == string.lower(H) then
                if q[L].hoursLeft > 1 then
                    q[L].hoursLeft = q[L].hoursLeft - 1
                else
                    q[L] = nil
                end
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:decreaseHourRentingVehicles",
    function(H)
        for L, M in pairs(p) do
            if string.lower(M.vehicleId) == string.lower(H) then
                if p[L].hoursLeft > 1 then
                    p[L].hoursLeft = p[L].hoursLeft - 1
                else
                    p[L] = nil
                end
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:endRentedVehicle",
    function(H)
        for L, M in pairs(q) do
            if string.lower(M.vehicleId) == string.lower(H) then
                q[L] = nil
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:endRentingVehicle",
    function(H)
        for L, M in pairs(p) do
            if string.lower(M.vehicleId) == string.lower(H) then
                p[L] = nil
            end
        end
    end
)
function CORRUPT.getVehicleInfoFromUUID(J)
    return z[J]
end
local function N(H)
    for J, O in pairs(z) do
        if string.lower(O.vehicleId) == string.lower(H) then
            return J
        end
    end
    return nil
end
RegisterNetEvent(
    "CORRUPT:updateOwnedVehicles",
    function(P)
        y = {}
        for J, O in pairs(P) do
            for Q, R in pairs(a.garages) do
                for H, S in pairs(R) do
                    if string.lower(H) == string.lower(O.vehicleId) then
                        local T = nil
                        for U, V in pairs(y) do
                            if V.type == Q then
                                T = V
                                break
                            end
                        end
                        if not T then
                            T = {type = Q, class = R["_config"].type, vehicles = {}}
                            table.insert(y, T)
                        end
                        local W = {uuid = J, vehicleId = O.vehicleId, name = S[1], fuel = O.fuel}
                        table.insert(T.vehicles, W)
                        z[J] = W
                        globalOwnedPlayerVehicles[O.vehicleId] = true
                        found = true
                        break
                    end
                end
            end
        end
        table.sort(
            y,
            function(X, Y)
                return X.type < Y.type
            end
        )
        for U, V in pairs(y) do
            table.sort(
                V.vehicles,
                function(X, Y)
                    return X.name < Y.name
                end
            )
        end
        local Z = CORRUPT.getCustomFolders()
        local _ = GetResourceKvpInt("corrupt_garagefolders_version")
        if table.count(Z) > 0 and _ == 0 then
            local a0 = table.copy(Z)
            for a1, a2 in pairs(a0) do
                local a3 = {}
                for H in pairs(a2) do
                    local J = N(H)
                    if J then
                        a3[J] = true
                    end
                end
                a0[a1] = a3
            end
            r = a0
            CORRUPT.saveCustomFolders()
            SetResourceKvpInt("corrupt_garagefolders_version", 1)
        else
            r = Z
        end
        s = CORRUPT.getGarageSettings()
        local a4 = {}
        for U, V in pairs(y) do
            local a5 = {}
            for U, O in pairs(V.vehicles) do
                table.insert(a5, {display = O.name, spawncode = O.uuid})
            end
            table.insert(a4, {display = V.type, vehicles = a5})
        end
        TriggerEvent("CORRUPT:setVehicleFolders", a4)
    end,
    false
)
local function a6(Q)
    if c[Q] then
        return true
    else
        return false
    end
end
local function a7(Q)
    RageUI.CloseAll()
    if a6(Q) then
        if CORRUPT.playerInWager() then
            tvRP.notify("~r~You cannot use this feature whilst in a wager.")
        else
            RageUI.Visible(RMenu:Get("garages", "mainmenu"), true)
        end
    end
end
local function a8(Q)
    RageUI.CloseAll()
    RageUI.Visible(RMenu:Get("garages", "mainmenu"), false)
end
CreateThread(
    function()
        local a9 = {}
        local aa = {}
        for Q, M in pairs(a.garages) do
            for ab, ac in pairs(M) do
                if ab == "_config" then
                    local ad, ae, af, ag, ah, type =
                        ac.blipid,
                        ac.blipcolor,
                        ac.markerid,
                        ac.markercolours,
                        ac.permissions,
                        ac.type
                    for ai, aj in pairs(a.garageInstances) do
                        local ak, al, am = table.unpack(aj)
                        if Q == ak then
                            if am then
                                table.insert(a9, {position = al, blipId = ad, blipColor = ae, name = ak})
                            end
                            table.insert(aa, {position = al, colour = ag, markerId = af})
                        end
                    end
                end
            end
        end
        local an = function(ao)
            PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
            j = a.garages[ao.garageType]["_config"].type
            a7(ao.garageType)
            garage_type = ao.garageType
            selectedGarageVector = ao.position
        end
        local ap = function(ao)
            PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
            a8(ao.garageType)
        end
        local aq = function(ao)
        end
        for ar, R in pairs(a.garageInstances) do
            CORRUPT.createArea(
                "garage_" .. ar,
                R[2],
                1.5,
                6,
                an,
                ap,
                aq,
                {garageType = R[1], garageId = ar, position = R[2]}
            )
        end
        for ad, as in pairs(a9) do
            tvRP.addBlip(as.position.x, as.position.y, as.position.z, as.blipId, as.blipColor, as.name, 0.7, false)
        end
        for af, at in pairs(aa) do
            tvRP.addMarker(
                at.position.x,
                at.position.y,
                at.position.z,
                0.7,
                0.7,
                0.5,
                at.colour[1],
                at.colour[2],
                at.colour[3],
                125,
                50,
                at.markerId,
                true
            )
        end
    end
)
local au = 0
local av = 0.0
local function aw(H)
    DeleteVehicle(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false))
    CreateThread(
        function()
            local ax = GetHashKey(H)
            RequestModel(ax)
            local ay = 0
            while not HasModelLoaded(ax) and ay < 200 do
                drawNativeText("~r~Downloading vehicle model")
                Wait(0)
                ay = ay + 1
            end
            if HasModelLoaded(ax) then
                local az =
                    CreateVehicle(
                    ax,
                    selectedGarageVector.x,
                    selectedGarageVector.y,
                    selectedGarageVector.z,
                    av,
                    false,
                    false
                )
                DecorSetInt(az, decor, 945)
                SetEntityAsMissionEntity(az, false, false)
                FreezeEntityPosition(az, true)
                SetEntityInvincible(az, true)
                SetVehicleDoorsLocked(az, 4)
                SetModelAsNoLongerNeeded(ax)
                if au ~= 0 then
                    DestroyCam(au, 0)
                    au = 0
                end
                SetEntityAlpha(CORRUPT.getPlayerPed(), 0, false)
                FreezeEntityPosition(CORRUPT.getPlayerPed(), true)
                SetEntityCollision(CORRUPT.getPlayerPed(), false, false)
                SetEntityCollision(az, false, false)
                local aA = GetEntityCoords(CORRUPT.getPlayerPed())
                local aB = GetEntityRotation(CORRUPT.getPlayerPed())
                local aC = CreateCam("DEFAULT_SCRIPTED_CAMERA", 1)
                local aD = vector3(aA.x, aA.y, aA.z + 2.0) - GetEntityForwardVector(CORRUPT.getPlayerPed()) * 4.0
                SetCamActive(aC, true)
                RenderScriptCams(true, true, 500, 1, 0)
                SetCamCoord(aC, aD.x, aD.y, aD.z)
                SetCamRot(aC, -20.0, aB.y, aB.z, 2)
                au = aC
                Citizen.CreateThread(
                    function()
                        while DoesEntityExist(az) do
                            Citizen.Wait(25)
                            av = (av + 1) % 360
                            SetEntityHeading(az, av)
                        end
                    end
                )
                t = false
                o = true
                l = az
            else
                tvRP.notify("~r~Failed to load vehicle.")
                return -1
            end
        end
    )
end
local function aE(aF)
    local aG = AddBlipForEntity(aF)
    SetBlipSprite(aG, 56)
    SetBlipDisplay(aG, 4)
    SetBlipScale(aG, 1.0)
    SetBlipColour(aG, 2)
    SetBlipAsShortRange(aG, true)
end
RegisterNetEvent("CORRUPT:spawnPersonalVehicle",function(J, aH, aI, aJ, aK)
        a8()
        if GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false) == d then
            DeleteEntity(d)
        end
        tvRP.notify("~g~Loading vehicle, please wait.")
        local O = z[J]
        local H = O.vehicleId
        local aL = globalVehicleOwnership[H]
        if aL == nil or not DoesEntityExist(aL[2]) then
            local ax = CORRUPT.loadModel(H)
            if ax == nil then
                tvRP.notify("~r~Vehicle does not exist, if you believe this is an error contact a Car Dev on discord.")
                return
            end
            globalLastSpawnedVehicleTime = GetGameTimer()
            local aF
            if aJ then
                local aA = CORRUPT.getPosition()
                local aM, U, aN = GetNthClosestVehicleNode(aA.x, aA.y, aA.z, nil, 8, 8, 8, 8)
                local U, aO, U = GetNthClosestVehicleNode(aA.x, aA.y, aA.z, 15)
                local aP, U, aQ = GetClosestVehicleNodeWithHeading(aA.x, aA.y, aA.z, nil, 8, 8, 8, 8)
                local U, aR, U = GetPointOnRoadSide(aA.x, aA.y, aA.z, 0.0)
                if tostring(aR) ~= "vector3(0, 0, 0)" and tostring(aO) ~= "vector3(0, 0, 0)" then
                    aF = CORRUPT.spawnVehicle(ax, aO.x, aO.y, aO.z + 0.5, aN or 0.0, false, true, true)
                    CORRUPT.loadModel("s_m_y_xmech_01")
                    SendNUIMessage({transactionType = "MPCT_AKAA_0" .. math.random(1, 5)})
                    local aS = CreatePedInsideVehicle(aF, "PED_TYPE_CIVMALE", "s_m_y_xmech_01", -1, false, false)
                    SetModelAsNoLongerNeeded("s_m_y_xmech_01")
                    TaskVehicleDriveToCoord(aS, aF, aR.x, aR.y, aR.z, 15.0, 1.0, ax, 786603, 5.0, 0.0)
                    aE(aF)
                    SetTimeout(
                        5000,
                        function()
                            while GetEntitySpeed(aF) > 5.0 do
                                Wait(500)
                            end
                            TaskLeaveVehicle(aS, aF, 64)
                            TaskWanderStandard(aS, 10.0, 10)
                            Wait(10000)
                            DeletePed(aS)
                        end
                    )
                    print("[Corrupt] Spawned vehicle with spawncode: " .. tostring(H))
                    DecorSetInt(aF, "corrupt_owner", CORRUPT.getUserId())
                    DecorSetInt(aF, "corrupt_uuid", J)
                    globalVehicleOwnership[H] = {H, aF}
                    setVehicleFuel(aF, O.fuel)
                    tvRP.applyModsOnVehicle(aH, H, aF)
                    TriggerServerEvent("CORRUPT:spawnVehicleCallback", aI, VehToNet(aF))
                    table.insert(nveh, aF)
                end
            else
                local aT = aK or CORRUPT.getPosition()
                aF = CORRUPT.spawnVehicle(ax, aT.x, aT.y, aT.z + 0.5, GetEntityHeading(PlayerPedId()), true, true, true)
                aE(aF)
                print("[Corrupt] Spawned vehicle with spawncode: " .. tostring(H))
                DecorSetInt(aF, "corrupt_owner", CORRUPT.getUserId())
                DecorSetInt(aF, "corrupt_uuid", J)
                globalVehicleOwnership[H] = {H, aF}
                setVehicleFuel(aF, O.fuel)
                tvRP.applyModsOnVehicle(aH, H, aF)
                TriggerServerEvent("CORRUPT:spawnVehicleCallback", aI, VehToNet(aF))
                table.insert(n, aF)
                CreateThread(
                    function()
                        local aU = true
                        SetTimeout(
                            5000,
                            function()
                                aU = false
                            end
                        )
                        while aU do
                            if DoesEntityExist(aF) then
                                SetLocalPlayerAsGhost(true)
                                SetNetworkVehicleAsGhost(aF, true)
                                SetEntityAlpha(aF, 220, false)
                            end
                            Wait(0)
                        end
                        SetLocalPlayerAsGhost(false)
                        SetNetworkVehicleAsGhost(aF, false)
                        SetEntityAlpha(aF, 255, false)
                        ResetEntityAlpha(aF)
                    end
                )
            end
            SetModelAsNoLongerNeeded(ax)
            while DoesEntityExist(aF) do
                local aV = CORRUPT.getVehicleFuel(aF)
                if O.fuel ~= aV then
                    TriggerServerEvent("CORRUPT:updateFuel", H, math.floor(aV * 1000) / 1000)
                    O.fuel = aV
                    SetEntityInvincible(aF, false)
                    SetEntityCanBeDamaged(aF, true)
                end
                Wait(60000)
            end
        else
            tvRP.notify("This vehicle is already out.")
        end
    end
)
function func_previewGarageVehicle()
    if o then
        if IsControlJustPressed(0, 177) then
            DeleteVehicle(l)
            l = 0
            m = 0
            o = false
            DestroyCam(au, 0)
            RenderScriptCams(0, 0, 1, 1, 1)
            au = 0
            SetFocusEntity(GetPlayerPed(PlayerId()))
            SetEntityAlpha(CORRUPT.getPlayerPed(), 255, false)
            FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
            SetEntityCollision(CORRUPT.getPlayerPed(), true, true)
        end
    end
end
CORRUPT.createThreadOnTick(func_previewGarageVehicle)
local function aW(H)
    return H == "surprise"
end
local function aX(H)
    for Q, aY in pairs(a.garages) do
        for aZ in pairs(aY) do
            if aZ ~= "_config" and aZ == H then
                return a6(Q) and j == aY["_config"].type
            end
        end
    end
    return true
end
local function a_()
    local b0 = {}
    for J, W in pairs(z) do
        table.insert(b0, {uuid = J, info = W})
    end
    table.sort(
        b0,
        function(X, Y)
            return X.info.name < Y.info.name
        end
    )
    return b0
end
RMenu.Add(
    "garages",
    "mainmenu",
    RageUI.CreateMenu("", "", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_garageui", "corrupt_garageui")
)
RMenu:Get("garages", "mainmenu"):SetSubtitle("~b~Garages")
RMenu.Add(
    "garages",
    "rentmanager",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "mainmenu"),
        "",
        "~b~Rent Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "rentedout",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "rentmanager"),
        "",
        "~b~Vehicles Rented Out",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "rentedin",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "rentmanager"),
        "",
        "~b~Vehicles Renting",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "rentedinfo",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "rentedin"),
        "",
        "~b~Vehicles Rent Info",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "listgarages",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "mainmenu"),
        "",
        "~b~Garage Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "vehiclemenu",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "listgarages"),
        "",
        "~b~Vehicle Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "spawnmenu",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "vehiclemenu"),
        "",
        "~b~Spawn Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "customfolders",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "listgarages"),
        "",
        "~b~Custom Folders Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "settings",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "mainmenu"),
        "",
        "~b~Settings",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "viewall",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "settings"),
        "",
        "~b~All Vehicles",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "rentonlymenu",
    RageUI.CreateSubMenu(
        RMenu:Get("garages", "viewall"),
        "",
        "~b~Vehicle Management Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
RMenu.Add(
    "garages",
    "confirm",
    RageUI.CreateMenu("", "", CORRUPT.getRageUIMenuWidth(), CORRUPT.getRageUIMenuHeight(), "corrupt_garageui", "corrupt_garageui")
)
RMenu:Get("garages", "confirm"):SetSubtitle("~b~Are you sure you want to DELETE this vehicle?")
local function b1()
    RageUI.ButtonWithStyle(
        "[Create Custom Folder]",
        "",
        {RightLabel = "→→→"},
        true,
        function(b2, b3, b4)
            if b2 then
            end
            if b3 then
            end
            if b4 then
                local a1 = getCustomFolderNameInput()
                if a1 ~= "" then
                    if r[a1] == nil then
                        CORRUPT.createCustomFolder(a1)
                    else
                        tvRP.notify("~r~Folder already exists.")
                    end
                else
                    tvRP.notify("~r~Invalid folder name.")
                end
            end
        end,
        RMenu:Get("garages", "customfolders")
    )
    RageUI.ButtonWithStyle(
        "[Delete Custom Folder]",
        "",
        {RightLabel = "→→→"},
        true,
        function(b2, b3, b4)
            if b2 then
            end
            if b3 then
            end
            if b4 then
                local a1 = getCustomFolderNameInput()
                if a1 ~= "" then
                    if r[a1] then
                        CORRUPT.deleteCustomFolder(a1)
                    else
                        tvRP.notify("~r~Folder already exists.")
                    end
                else
                    tvRP.notify("~r~Invalid folder name.")
                end
            end
        end,
        RMenu:Get("garages", "customfolders")
    )
    for a1, a2 in pairs(r) do
        RageUI.ButtonWithStyle(
            a1,
            "",
            {RightLabel = "→→→"},
            true,
            function(b2, b3, b4)
                if b2 then
                end
                if b3 then
                end
                if b4 then
                    h = nil
                    selectedCustomFolder = a1
                end
            end,
            RMenu:Get("garages", "vehiclemenu")
        )
    end
end
local function b5(O, b6)
    if not b6 and s.hideCustomFolderVehiclesFromOriginalGarages and CORRUPT.isVehicleInAnyCustomFolder(O.uuid) then
        return
    end
    if aW(O.vehicleId) and CORRUPT.getStaffLevel() == 0 then
        return
    end
    local b7 = ""
    if O.fuel <= 20 then
        b7 = "~r~"
    elseif O.fuel <= 50 then
        b7 = "~y~"
    elseif O.fuel <= 100 then
        b7 = "~g~"
    end
    RageUI.ButtonWithStyle(O.name,b7 .. "Fuel " .. tostring(math.floor(O.fuel)) .. "% ~v~| "..vehicleWeightsTable[O.vehicleId],{RightLabel = "→→→"},true,
        function(b2, b3, b4)
            if b3 then
                if (l == 0 or m ~= O.vehicleId) and not t then
                    DeleteVehicle(l)
                    t = true
                    aw(O.vehicleId)
                    m = O.vehicleId
                end
            end
            if b4 then
                e = O.vehicleId
                g = O.uuid
                TriggerServerEvent("CORRUPT:getVehicleRarity", O.vehicleId)
                TriggerServerEvent("CORRUPT:getVehicleMilage", O.uuid)
                f = O.name
                selectedCustomFolder = nil
            end
        end,
        RMenu:Get("garages", "spawnmenu")
    )
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("garages", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("garages", "mainmenu"),
            true,
            true,
            true,
            function()
                local previousMatches = a.garages[garage_type]["_config"].type == lastSpawnedType
                RageUI.ButtonWithStyle(
                    "Garages",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            TriggerServerEvent("CORRUPT:refreshGaragePermissions")
                        end
                    end,
                    RMenu:Get("garages", "listgarages")
                )
                RageUI.ButtonWithStyle(
                    "Store Vehicle",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            local b8 = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
                            if DoesEntityExist(b8) then
                                DeleteEntity(b8)
                            end
                        end
                    end,
                    RMenu:Get("garages", "mainmenu")
                )
                RageUI.ButtonWithStyle(
                    "Spawn Last Vehicle",
                    f, previousMatches and 
                    {RightLabel = "→→→"} or {},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            if tvRP.getPlayerCombatTimer() == 0 then
                                local aL = globalVehicleOwnership[g]
                                if aL == nil or not DoesEntityExist(aL[2]) then
                                    TriggerServerEvent("CORRUPT:spawnPersonalVehicle", g)
                                else
                                    tvRP.notify("Vehicle is already out!")
                                end
                            else
                                tvRP.notify("~r~You cannot spawn a vehicle with a combat timer.")
                            end
                        end
                    end,
                    RMenu:Get("garages", "mainmenu")
                )
                RageUI.ButtonWithStyle(
                    "Rent Manager",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                        end
                    end,
                    RMenu:Get("garages", "rentmanager")
                )
                RageUI.ButtonWithStyle(
                    "Settings",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                        end
                    end,
                    RMenu:Get("garages", "settings")
                )
                RageUI.ButtonWithStyle(
                    "~y~Fuel all vehicles. (£25,000)",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            if tvRP.isPlusClub() or tvRP.isPlatClub() then
                                if not u then
                                    TriggerServerEvent("CORRUPT:fuelAllVehicles")
                                    u = true
                                    SendNUIMessage({transactionType = "playMoney"})
                                    SetTimeout(
                                        60000,
                                        function()
                                            u = false
                                        end
                                    )
                                else
                                    tvRP.notify("~r~You've done this too recently, try again later.")
                                end
                            else
                                tvRP.notify(
                                    "~y~You need to be a subscriber of CORRUPT Plus or CORRUPT Platinum to use this feature."
                                )
                                tvRP.notify("~y~Available @ store.corruptstudios.net")
                            end
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "rentmanager"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Vehicles Rented Out",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                        end
                    end,
                    RMenu:Get("garages", "rentedout")
                )
                RageUI.ButtonWithStyle(
                    "Vehicles Rented In",
                    f,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                        end
                    end,
                    RMenu:Get("garages", "rentedin")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "rentedout"),
            true,
            true,
            true,
            function()
                for U, b9 in pairs(q) do
                    local ba, bb, bc = b9.vehicleName, b9.rentedBy, b9.hoursLeft
                    RageUI.ButtonWithStyle(
                        ba,
                        "Rented to " .. bb .. " - " .. bc .. " hours left!",
                        {RightLabel = "→→→"},
                        true,
                        function(b2, b3, b4)
                            if b2 then
                            end
                            if b3 then
                            end
                            if b4 then
                                k = b9
                                k.type = "rentingout"
                            end
                        end,
                        RMenu:Get("garages", "rentedinfo")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "rentedin"),
            true,
            true,
            true,
            function()
                for U, b9 in pairs(p) do
                    local ba, bb, bc = b9.vehicleName, b9.rentedBy, b9.hoursLeft
                    RageUI.ButtonWithStyle(
                        ba,
                        "Rented from " .. bb .. " - " .. bc .. " hours left!",
                        {RightLabel = "→→→"},
                        true,
                        function(b2, b3, b4)
                            if b2 then
                            end
                            if b3 then
                            end
                            if b4 then
                                k = b9
                                k.type = "rentingin"
                            end
                        end,
                        RMenu:Get("garages", "rentedinfo")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(RMenu:Get("garages", "rentedinfo"),true,true,true,function()
            local H, ba, bb, bc = k.vehicleId, k.vehicleName, k.rentedBy, k.hoursLeft
            RageUI.Separator("~y~Rent Info")
            RageUI.Separator("---------")
            RageUI.Separator("Vehicle: " .. ba)
            RageUI.Separator("Rented from: " .. bb)
            RageUI.Separator("Hours Left: " .. bc)
            RageUI.ButtonWithStyle("Request Rent Cancellation","",{RightLabel = "→→→"},true,function(b2, b3, b4)
                if b4 then
                    TriggerServerEvent("CORRUPT:requestRentCancellation", ba, H, k.type)
                end
            end)
            if k.type == "rentingout" then
                RageUI.ButtonWithStyle('Extend rent time', "~y~This will extend the rent of " ..ba, {}, true, function(Hovered, Active, Selected)
                    if Selected then 
                        TriggerServerEvent("CORRUPT:ExtendRent", H, ba)
                    end
                end)
            end
        end,function()end)
        RageUI.IsVisible(
            RMenu:Get("garages", "listgarages"),
            true,
            true,
            true,
            function()
                if not s.showCustomFoldersInGarageMenu then
                    RageUI.ButtonWithStyle(
                        "[Custom Folders]",
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(b2, b3, b4)
                            if b2 then
                            end
                            if b3 then
                            end
                            if b4 then
                            end
                        end,
                        RMenu:Get("garages", "customfolders")
                    )
                else
                    b1()
                end
                for U, V in pairs(y) do
                    if a6(V.type) and j == V.class then
                        RageUI.ButtonWithStyle(
                            V.type,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(b2, b3, b4)
                                if b4 then
                                    h = V
                                    selectedCustomFolder = nil
                                end
                            end,
                            RMenu:Get("garages", "vehiclemenu")
                        )
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "customfolders"),
            true,
            true,
            true,
            function()
                b1()
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "spawnmenu"),
            true,
            true,
            true,
            function()
                local bd = f
                if w[e] then
                    bd = bd .. " | " .. "Rarity (1:" .. tostring(w[e]) .. ")"
                    if x[g] then
                        bd = bd .. " | Milage (" .. tostring(x[g]) .. " miles)"
                    end
                end
                RageUI.ButtonWithStyle("Spawn Vehicle",bd,{RightLabel = "→→→"},true,function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            for L, M in pairs(n) do
                                if not DoesEntityExist(M) then
                                    table.remove(n, L)
                                end
                            end
                            if #n <= 5 then
                                DeleteVehicle(l)
                                l = 0
                                m = 0
                                o = false
                                DestroyCam(au, 0)
                                RenderScriptCams(0, 0, 1, 1, 1)
                                au = 0
                                SetFocusEntity(GetPlayerPed(PlayerId()))
                                SetEntityAlpha(CORRUPT.getPlayerPed(), 255, false)
                                FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
                                SetEntityCollision(CORRUPT.getPlayerPed(), true, true)
                                local aL = globalVehicleOwnership[g]
                                if aL == nil or not DoesEntityExist(aL[2]) then
                                    lastSpawnedType = a.garages[garage_type]["_config"].type
                                    TriggerServerEvent("CORRUPT:spawnPersonalVehicle", g)
                                else
                                    tvRP.notify("Vehicle is already out!")
                                end
                            else
                                tvRP.notify("~r~You may only take out a maximum of 5 vehicles at a time.")
                            end
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Sell Vehicle to Player",
                    bd,
                    CORRUPT.canVehicleBeSold(e) and {RightLabel = "→→→"} or {RightBadge = ""},
                    CORRUPT.canVehicleBeSold(e),
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 and CORRUPT.canVehicleBeSold(e) then
                            TriggerServerEvent("CORRUPT:beginSellVehicleToPlayer", e)
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
                RageUI.ButtonWithStyle(
                    "Rent Vehicle to Player",
                    bd,
                    CORRUPT.canVehicleBeRented(e) and {RightLabel = "→→→"} or {RightBadge = ""},
                    CORRUPT.canVehicleBeRented(e),
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 and CORRUPT.canVehicleBeRented(e) then
                            TriggerServerEvent("CORRUPT:beginRentVehicleToPlayer", e)
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
                RageUI.ButtonWithStyle(
                    "Crush Vehicle",
                    "This will ~r~DELETE ~w~this vehicle from your garage!",
                    CORRUPT.canVehicleBeSold(e) and {RightLabel = "→→→"} or {RightBadge = ""},
                    CORRUPT.canVehicleBeSold(e),
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                        end
                    end,
                    RMenu:Get("garages", "confirm")
                )
                RageUI.ButtonWithStyle(
                    "Add to custom folder",
                    bd,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            local a1 = getCustomFolderNameInput()
                            CORRUPT.addCarToCustomFolder(g, f, a1)
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
                RageUI.ButtonWithStyle(
                    "Remove from custom folder",
                    bd,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            local a1 = getCustomFolderNameInput()
                            CORRUPT.removeCarFromCustomFolder(g, a1)
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
                RageUI.ButtonWithStyle(
                    "View Remote Dashcam",
                    bd,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b4 then
                            TriggerServerEvent("CORRUPT:viewRemoteDashcam", g)
                        end
                    end
                )
                RageUI.ButtonWithStyle(
                    "Display Vehicle Blip",
                    bd,
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b4 then
                            TriggerServerEvent("CORRUPT:displayVehicleBlip", g)
                        end
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "vehiclemenu"),
            true,
            true,
            true,
            function()
                if h then
                    for U, O in pairs(h.vehicles) do
                        b5(O, false)
                    end
                end
                local be = r[selectedCustomFolder]
                if be then
                    local bf = {}
                    for J in pairs(be) do
                        local O = z[tonumber(J)]
                        if O and aX(O.vehicleId) then
                            table.insert(bf, O)
                        end
                    end
                    table.sort(
                        bf,
                        function(bg, bh)
                            return bg.name < bh.name
                        end
                    )
                    for U, O in pairs(bf) do
                        b5(O, true)
                    end
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "confirm"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "No",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            tvRP.notify("~y~Cancelled!")
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
                RageUI.ButtonWithStyle(
                    "Yes",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 then
                            local b8 = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
                            if DoesEntityExist(b8) then
                                DeleteEntity(b8)
                            end
                            if verifyCrushVehicle() == "CONFIRM" then
                                TriggerServerEvent("CORRUPT:crushVehicle", g)
                            else
                                tvRP.notify("~r~Cancelled vehicle crush!")
                            end
                        end
                    end,
                    RMenu:Get("garages", "spawnmenu")
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "settings"),
            true,
            true,
            true,
            function()
                RageUI.Checkbox(
                    "Hide custom folder vehicles",
                    "This hides these vehicles from their original garage.",
                    s.hideCustomFolderVehiclesFromOriginalGarages,
                    {},
                    function(b2, b4, b3, bi)
                    end,
                    function()
                        s.hideCustomFolderVehiclesFromOriginalGarages = true
                        CORRUPT.saveGarageSettings()
                    end,
                    function()
                        s.hideCustomFolderVehiclesFromOriginalGarages = false
                        CORRUPT.saveGarageSettings()
                    end
                )
                RageUI.Checkbox(
                    "Show Custom Folders In Garage Menu",
                    "~y~This removes the [Custom Folders] menu item, and puts custom folders in the root garages menu.",
                    s.showCustomFoldersInGarageMenu,
                    {},
                    function(b2, b4, b3, bi)
                    end,
                    function()
                        s.showCustomFoldersInGarageMenu = true
                        CORRUPT.saveGarageSettings()
                    end,
                    function()
                        s.showCustomFoldersInGarageMenu = false
                        CORRUPT.saveGarageSettings()
                    end
                )
                RageUI.ButtonWithStyle("View All Vehicles","View vehicles for the purpose of selling and renting.",{RightLabel = "→→→"},true,function(Hovered, Active, Selected)
                    if Selected then lastSpawnedType = nil end
                end,RMenu:Get("garages", "viewall"))
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "viewall"),
            true,
            true,
            true,
            function()
                for U, bj in pairs(a_()) do
                    RageUI.ButtonWithStyle(
                        bj.info.name,
                        "",
                        {RightLabel = "→→→"},
                        true,
                        function(b2, b3, b4)
                            if b4 then
                                g = bj.uuid
                                e = bj.info.vehicleId
                            end
                        end,
                        RMenu:Get("garages", "rentonlymenu")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("garages", "rentonlymenu"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Sell Vehicle to Player",
                    "",
                    {RightLabel = "→→→"},
                    CORRUPT.canVehicleBeSold(e),
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 and CORRUPT.canVehicleBeSold(e) then
                            TriggerServerEvent("CORRUPT:beginSellVehicleToPlayer", e)
                        end
                    end,
                    RMenu:Get("garages", "viewall")
                )
                RageUI.ButtonWithStyle(
                    "Rent Vehicle to Player",
                    "",
                    {RightLabel = "→→→"},
                    CORRUPT.canVehicleBeRented(e),
                    function(b2, b3, b4)
                        if b2 then
                        end
                        if b3 then
                        end
                        if b4 and CORRUPT.canVehicleBeRented(e) then
                            TriggerServerEvent("CORRUPT:beginRentVehicleToPlayer", e)
                        end
                    end,
                    RMenu:Get("garages", "viewall")
                )
            end,
            function()
            end
        )
    end
)
function verifyCrushVehicle()
    AddTextEntry("FMMC_MPM_NA", "Please type CONFIRM in all caps to confirm the crushing of this vehicle?")
    DisplayOnscreenKeyboard(
        1,
        "FMMC_MPM_NA",
        "Please type CONFIRM in all caps to confirm the crushing of this vehicle",
        "",
        "",
        "",
        "",
        30
    )
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local bk = GetOnscreenKeyboardResult()
        if bk then
            return bk
        else
            return ""
        end
    end
    return ""
end
function getCustomFolderNameInput()
    AddTextEntry("FMMC_MPM_NA", "Enter folder name:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter folder name:", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local bk = GetOnscreenKeyboardResult()
        if bk then
            return bk
        else
            return ""
        end
    end
    return ""
end
function tvRP.getVehicleInfos(az)
    if az and DecorExistOn(az, "corrupt_owner") then
        local A = DecorGetInt(az, "corrupt_owner")
        local bl = CORRUPT.getVehicleIdFromModel(GetEntityModel(az))
        if bl then
            return A, bl
        end
    end
end
function tvRP.getNetworkedVehicleInfos(bm)
    local az = CORRUPT.getObjectId(bm, "tvRP.getNetworkedVehicleInfos")
    if az and DecorExistOn(az, "corrupt_owner") then
        local A = DecorGetInt(az, "corrupt_owner")
        local bl = CORRUPT.getVehicleIdFromModel(GetEntityModel(az))
        if bl then
            return A, bl
        end
    end
end
function stringsplit(bn, bo)
    if bo == nil then
        bo = "%s"
    end
    local bp = {}
    i = 1
    for bq in string.gmatch(bn, "([^" .. bo .. "]+)") do
        bp[i] = bq
        i = i + 1
    end
    return bp
end
local function br(bs, bt, bu)
    for i = 0, GetNumModColors(bs, false) - 1 do
        SetVehicleModColor_1(bu, bs, i, 0)
        if GetVehicleColours(bu) == bt then
            return
        end
    end
    local U, bv = GetVehicleColours(bu)
    SetVehicleColours(bu, bt, bv)
end
local function bw(bs, bt, bu)
    for i = 0, GetNumModColors(bs, false) - 1 do
        SetVehicleModColor_2(bu, bs, i)
        local U, bv = GetVehicleColours(bu)
        if bv == bt then
            return
        end
    end
    SetVehicleColours(bu, GetVehicleColours(bu), bt)
end
function applyPrimaryColours(aH, bx)
    local by = 0
    for L, M in pairs(aH["chrome"]) do
        if M == true then
            br(5, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["classic"]) do
        if M == true then
            br(0, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["matte"]) do
        if M == true then
            br(3, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["metals"]) do
        if M == true then
            br(4, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["metallic"]) do
        if M == true then
            br(1, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["util"]) do
        if M == true then
            by = tonumber(L)
        end
    end
    for L, M in pairs(aH["chameleon"]) do
        if M == true then
            by = tonumber(L)
        end
    end
    if by ~= 0 then
        local U, bz = GetVehicleColours(bx)
        SetVehicleColours(bx, by, bz)
    end
end
function applySecondaryColours(aH, bx)
    local bA = 0
    for L, M in pairs(aH["chrome2"]) do
        if M == true then
            bw(5, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["classic2"]) do
        if M == true then
            bw(0, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["matte2"]) do
        if M == true then
            bw(3, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["metal2"]) do
        if M == true then
            bw(4, tonumber(L), bx)
        end
    end
    for L, M in pairs(aH["metallic2"]) do
        if M == true then
            bw(1, tonumber(L), bx)
        end
    end
    if bA ~= 0 then
        local bB = GetVehicleColours(bx)
        SetVehicleColours(bx, bB, bA)
    end
end
function tvRP.applyModsOnVehicle(aH, H, bx)
    for L, M in pairs(aH["windowtint"]) do
        if M == true then
            SetVehicleWindowTint(bx, tonumber(L))
        end
    end
    Wait(0)
    SetVehicleModKit(bx, 0)
    for L, M in pairs(aH.sportwheels) do
        if M == true then
            SetVehicleWheelType(bx, 0)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH.musclewheels) do
        if M == true then
            SetVehicleWheelType(bx, 1)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["lowriderwheels"]) do
        if M == true then
            SetVehicleWheelType(bx, 2)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["highendwheels"]) do
        if M == true then
            SetVehicleWheelType(bx, 7)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["suvwheels"]) do
        if M == true then
            SetVehicleWheelType(bx, 3)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["offroadwheels"]) do
        if M == true then
            SetVehicleWheelType(bx, 4)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["tunerwheels"]) do
        if M == true then
            SetVehicleWheelType(bx, 6)
            SetVehicleMod(bx, 23, tonumber(L), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["wheelaccessories"]) do
        if M == true then
            SetVehicleModKit(bx, 0)
            ToggleVehicleMod(bx, 20, true)
            L = L:gsub("%[", "")
            L = L:gsub("]", "")
            smokecolor = stringsplit(L, ",")
            SetVehicleTyreSmokeColor(bx, tonumber(smokecolor[1]), tonumber(smokecolor[2]), tonumber(smokecolor[3]))
        end
    end
    Wait(0)
    applyPrimaryColours(aH, bx)
    Wait(0)
    applySecondaryColours(aH, bx)
    for L, M in pairs(aH["pearlescent"]) do
        if M == true then
            local U, bC = GetVehicleExtraColours(bx)
            SetVehicleExtraColours(bx, tonumber(L), bC)
        end
    end
    for L, M in pairs(aH["wheelcolor"]) do
        if M == true then
            SetVehicleExtraColours(bx, GetVehicleExtraColours(bx), tonumber(L))
        end
    end
    local bD = 0
    for L, M in pairs(aH["interiorcolour"]) do
        if M == true then
            bD = tonumber(L)
        end
    end
    SetVehicleInteriorColor(bx, bD)
    local bE = 0
    for L, M in pairs(aH["dashboardcolour"]) do
        if M == true then
            bE = tonumber(L)
        end
    end
    SetVehicleDashboardColor(bx, bE)
    local bx = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
    SetVehicleModKit(bx, 0)
    for i = 0, 48, 1 do
        if aH[tostring("mod_" .. i)] ~= nil then
            for L, M in pairs(aH[tostring("mod_" .. i)]) do
                if M == true then
                    Wait(0)
                    local bF = tonumber(L)
                    if i == 18 then
                        ToggleVehicleMod(bx, 18, true)
                    elseif i == 22 then
                        ToggleVehicleMod(bx, 22, bF > 0)
                    else
                        SetVehicleMod(bx, i, bF, false)
                    end
                end
            end
        end
    end
    Wait(0)
    if tonumber(aH["nitro"]) and tonumber(aH["nitro"]) > 0 then
        setVehicleIdNitro(bx, aH["nitro"])
    end
    for L, M in pairs(aH["antilag"]) do
        if M == true then
            setVehicleAntiLag(H, tonumber(L))
        end
    end
    setVehicleIdDriftSuspension(H, aH["driftsuspension"])
    for L, M in pairs(aH["driftsmoke"]) do
        if M == true then
            setVehicleIdDriftSmoke(H, tonumber(L))
        end
    end
    setVehicleIdPlaneSmoke(bx, H, aH["planesmokes"])
    setVehicleIdBiometricLock(bx, aH["security"], aH["biometric_users"])
    setVehicleIdStancer(bx, aH["stancer"])
    setVehicleIdSubwoofer(bx, aH["misc"])
    Wait(0)
    local bG =
        pcall(
        function()
            SetVehicleNumberPlateText(CORRUPT.getPlayerVehicle(), aH["vehicle_plate"])
        end
    )
    if not bG then
        print(
            "Failed to set the licence plate of your vehicle, please report to a developer. Plate:",
            aH["vehicle_plate"]
        )
    end
    Wait(0)
    for L, M in pairs(aH["sounds"]) do
        if M == true then
            local bH = getVehicleSoundNameFromId(tonumber(L))
            local aL = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
            ForceVehicleEngineAudio(aL, bH)
            SetTimeout(
                500,
                function()
                    SetVehicleRadioEnabled(aL, false)
                    SetVehRadioStation(aL, "OFF")
                end
            )
            DecorSetInt(aL, "lsAudioId", tonumber(L))
        end
    end
    Wait(0)
    for L, M in pairs(aH["bulletproof_tires"]) do
        if M == true then
            SetVehicleTyresCanBurst(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), false)
        end
    end
    Wait(0)
    for L, M in pairs(aH["plate_colour"]) do
        if M == true then
            SetVehicleNumberPlateTextIndex(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), tonumber(L))
        end
    end
    Wait(0)
    for L, M in pairs(aH["neonlayout"]) do
        local bF = tonumber(L)
        if M == true and bF and bF > 0 then
            if bF == 1 then
                SetVehicleNeonLightEnabled(bx, 0, true)
                SetVehicleNeonLightEnabled(bx, 1, true)
                SetVehicleNeonLightEnabled(bx, 2, true)
                SetVehicleNeonLightEnabled(bx, 3, true)
            elseif bF == 2 then
                SetVehicleNeonLightEnabled(bx, 2, true)
                SetVehicleNeonLightEnabled(bx, 3, true)
            elseif bF == 3 then
                SetVehicleNeonLightEnabled(bx, 0, true)
                SetVehicleNeonLightEnabled(bx, 1, true)
                SetVehicleNeonLightEnabled(bx, 2, true)
            elseif bF == 4 then
                SetVehicleNeonLightEnabled(bx, 0, true)
                SetVehicleNeonLightEnabled(bx, 1, true)
                SetVehicleNeonLightEnabled(bx, 3, true)
            end
            if aH["neoncolour"] then
                for L, M in pairs(aH["neoncolour"]) do
                    if M == true then
                        local bI, bJ, bh = table.unpack(b.neonColours[L])
                        SetVehicleNeonLightsColour(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), bI, bJ, bh)
                    end
                end
            end
        end
    end
    Wait(0)
    for L, M in pairs(aH["xenonlights"]) do
        if M == true then
            SetVehicleXenonLightsColor(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), tonumber(L))
        end
    end
    Wait(0)
    for L, M in pairs(aH["liveries"]) do
        if M == true then
            SetVehicleLivery(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), tonumber(L))
        end
    end
    Wait(0)
    for U, O in pairs(z) do
        if O.vehicleId == H then
            O.fuel = aH["fuel"]
        end
    end
end
function getVehicleSoundNameFromId(bK)
    return v[bK]
end
function tvRP.despawnGarageVehicle(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        SetVehicleHasBeenOwnedByPlayer(aL[2], false)
        DeleteEntity(aL[2])
        globalVehicleOwnership[bL] = nil
        tvRP.notify("Vehicle stored.")
    end
end
function tvRP.getNearestVehicle(bM)
    local aT = CORRUPT.getPosition()
    local bN, bO, bP = aT.x, aT.y, aT.z
    local bQ = CORRUPT.getPlayerPed()
    if IsPedSittingInAnyVehicle(bQ) then
        return GetVehiclePedIsIn(bQ, true)
    else
        local az = GetClosestVehicle(bN + 0.0001, bO + 0.0001, bP + 0.0001, bM + 0.0001, 0, 8192 + 4096 + 4 + 2 + 1)
        if not IsEntityAVehicle(az) then
            az = GetClosestVehicle(bN + 0.0001, bO + 0.0001, bP + 0.0001, bM + 0.0001, 0, 4 + 2 + 1)
        end
        if not IsEntityAVehicle(az) then
            az = GetClosestVehicle(bN + 0.0001, bO + 0.0001, bP + 0.0001, bM + 0.0001, 0, 16384)
        end
        if az == 0 then
            return GetVehiclePedIsIn(bQ, true)
        else
            return az, nil
        end
    end
end
function CORRUPT.getClosestVehicle(bM)
    local bR = CORRUPT.getPlayerCoords()
    local bS = 100
    local bT = 100
    for U, bU in pairs(GetGamePool("CVehicle")) do
        local bV = GetEntityCoords(bU)
        local bW = #(bR - bV)
        if bW < bT then
            bT = bW
            bS = bU
        end
    end
    if bT <= bM then
        return bS
    else
        return nil
    end
end
function tryFindModelFromEntity(aL)
    local ax = GetEntityModel(aL)
    for bX, R in pairs(a.garages) do
        for L, M in pairs(R) do
            if M ~= "_config" then
                local bY = GetHashKey(M)
                if ax == bY then
                    return M
                end
            end
        end
    end
    return nil
end
function tvRP.tryOwnNearestVehicle(bM)
    local az = tvRP.getNearestVehicle(bM)
    if az then
        local A, bl = tvRP.getVehicleInfos(az)
        if A and A == CORRUPT.getUserId() then
            if globalVehicleOwnership[bl] ~= az then
                globalVehicleOwnership[bl] = {bl, az}
            end
        end
    end
end
function tvRP.fixeNearestVehicle(bM)
    local az = tvRP.getNearestVehicle(bM)
    if IsEntityAVehicle(az) then
        SetVehicleFixed(az)
    end
end
function tvRP.replaceNearestVehicle(bM)
    local az = tvRP.getNearestVehicle(bM)
    if IsEntityAVehicle(az) then
        SetVehicleOnGroundProperly(az)
    end
end
function tvRP.getVehicleAtPosition(bN, bO, bP)
    bN = bN + 0.0001
    bO = bO + 0.0001
    bP = bP + 0.0001
    local bZ = StartExpensiveSynchronousShapeTestLosProbe(bN, bO, bP, bN, bO, bP + 4, 10, CORRUPT.getPlayerPed(), 0)
    local bg, bh, b_, c0, c1 = GetShapeTestResult(bZ)
    return c1
end
function tvRP.getNearestOwnedVehicle(bM)
    tvRP.tryOwnNearestVehicle(bM)
    local c2
    local c3
    local bS
    local aA = GetEntityCoords(CORRUPT.getPlayerPed())
    for L, M in pairs(globalVehicleOwnership) do
        local c4 = #(GetEntityCoords(M[2], true) - aA)
        if c4 <= bM + 0.0001 then
            if not c2 or c4 < c2 then
                c2 = c4
                c3 = L
                bS = M[2]
            end
        end
    end
    if c3 then
        local A = DecorGetInt(bS, "corrupt_owner")
        return true, c3, A
    end
    return false, ""
end
function tvRP.getCurrentOwnedVehicle(bM)
    tvRP.tryOwnNearestVehicle(bM)
    local c2
    local c3
    for L, M in pairs(globalVehicleOwnership) do
        local c4 = #(GetEntityCoords(M[2], true) - GetEntityCoords(CORRUPT.getPlayerPed()))
        if c4 <= bM + 0.0001 then
            if not c2 or c4 < c2 then
                c2 = c4
                c3 = L
            end
        end
    end
    if c3 then
        return true, c3
    end
    return false, ""
end
function tvRP.getAnyOwnedVehiclePosition()
    for L, M in pairs(globalVehicleOwnership) do
        if IsEntityAVehicle(M[2]) then
            local bN, bO, bP = table.unpack(GetEntityCoords(M[2], true))
            return true, bN, bO, bP
        end
    end
    return false, 0, 0, 0
end
function tvRP.getOwnedVehiclePosition(bL)
    local aL = globalVehicleOwnership[bL]
    local bN, bO, bP = 0, 0, 0
    if aL then
        bN, bO, bP = table.unpack(GetEntityCoords(aL[2], true))
    end
    return bN, bO, bP
end
function tvRP.getOwnedVehicleHandle(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        return aL[2]
    end
end
function tvRP.ejectVehicle()
    local bQ = CORRUPT.getPlayerPed()
    if IsPedSittingInAnyVehicle(bQ) then
        local az = GetVehiclePedIsIn(bQ, false)
        if not CORRUPT.inEvent() then
            TaskLeaveVehicle(bQ, az, 4160)
        end
    end
end
function tvRP.isInVehicle()
    local bQ = CORRUPT.getPlayerPed()
    return IsPedSittingInAnyVehicle(bQ)
end
function tvRP.vc_openDoor(bL, c5)
    local aL = globalVehicleOwnership[bL]
    if aL then
        SetVehicleDoorOpen(aL[2], c5, 0, false)
    end
end
function tvRP.vc_closeDoor(bL, c5)
    local aL = globalVehicleOwnership[bL]
    if aL then
        SetVehicleDoorShut(aL[2], c5, false)
    end
end
function tvRP.vc_detachTrailer(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        DetachVehicleFromTrailer(aL[2])
    end
end
function tvRP.vc_detachTowTruck(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        local c1 = GetEntityAttachedToTowTruck(aL[2])
        if IsEntityAVehicle(c1) then
            DetachVehicleFromTowTruck(aL[2], c1)
        end
    end
end
function tvRP.vc_detachCargobob(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        local c1 = GetVehicleAttachedToCargobob(aL[2])
        if IsEntityAVehicle(c1) then
            DetachVehicleFromCargobob(aL[2], c1)
        end
    end
end
function tvRP.vc_toggleEngine(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        local c6 = GetIsVehicleEngineRunning(aL[2])
        SetVehicleEngineOn(aL[2], not c6, true, true)
        if c6 then
            SetVehicleUndriveable(aL[2], true)
        else
            SetVehicleUndriveable(aL[2], false)
        end
    end
end
function tvRP.vc_toggleLock(bL)
    local aL = globalVehicleOwnership[bL]
    if aL then
        local az = aL[2]
        local c7 = GetVehicleDoorLockStatus(az) >= 2
        local c8 = NetworkGetNetworkIdFromEntity(az)
        if c8 == 0 then
            tvRP.notify("~r~Failed to get ownership of vehicle to lock/unlock.")
        else
            tvRP.notify("Vehicle " .. (c7 and "unlocked" or "locked") .. ".")
            TriggerServerEvent("CORRUPT:setVehicleLock", c8, not c7)
        end
    end
end
RegisterNetEvent(
    "CORRUPT:setVehicleLock",
    function(c8, c9)
        if not NetworkDoesNetworkIdExist(c8) then
            return
        end
        local aL = NetworkGetEntityFromNetworkId(c8)
        if aL == 0 then
            return
        end
        if not NetworkHasControlOfEntity(aL) then
            return
        end
        if c9 then
            SetVehicleDoorsLocked(aL, 2)
            SetVehicleDoorsLockedForAllPlayers(aL, true)
        else
            SetVehicleDoorsLockedForAllPlayers(aL, false)
            SetVehicleDoorsLocked(aL, 1)
            SetVehicleDoorsLockedForPlayer(aL, PlayerId(), false)
        end
    end
)
RegisterNetEvent("CORRUPT:fixVehicle",function()
        local ca = CORRUPT.getPlayerPed()
        if IsPedInAnyVehicle(ca) then
            local aL = GetVehiclePedIsIn(ca, false)
            SetVehicleEngineHealth(aL, 9999)
            SetVehiclePetrolTankHealth(aL, 9999)
            SetVehicleFixed(aL)
        end
    end
)
RegisterNetEvent("CORRUPT:staffFixVehicle",function()
        local ca = CORRUPT.getPlayerPed()
        if IsPedInAnyVehicle(ca) then
            local aL = GetVehiclePedIsIn(ca, false)
            SetVehicleEngineHealth(aL, 9999)
            SetVehiclePetrolTankHealth(aL, 9999)
            SetVehicleFixed(aL)
        end
    end)
RegisterCommand(
    "callanambulance",
    function()
        tvRP.notify("~y~CALL AN AMBULANCE")
        tvRP.notify("~y~CALL AN AMBULANCE!")
        tvRP.notify("~r~BUT NOT FOR ME.")
        SendNUIMessage({transactionType = "callanambulance"})
    end,
    false
)
RegisterCommand(
    "car",
    function(cb, cc, cd)
        if CORRUPT.getStaffLevel() >= 6 and not CORRUPT.isPurge() or CORRUPT.getUserId() == 1 or CORRUPT.getUserId() == 2 then
            local aA = GetEntityCoords(CORRUPT.getPlayerPed())
            local ce = vector3(-1341.9575195313, -3032.8686523438, 13.944421768188)
            local bN, bO, bP = table.unpack(GetOffsetFromEntityInWorldCoords(CORRUPT.getPlayerPed(), 0.0, 3.0, 0.5))
            local az = cc[1]
            if az == nil then
                tvRP.notify("~r~No vehicle spawncode specified.")
                return
            end
            if az == "demonhawkk" and CORRUPT.getUserId() ~= 2 then
                tvRP.teleport(-807.62481689453, 172.82191467285, 76.740547180176)
                jimmy()
            elseif (string.lower(az) == "lloydzlego" or string.lower(az) == "lloydzlego2")  then
                tvRP.notify("~y~Oak's words echoed... There's a time and place for everything, but not now.")
            elseif az == "redarrow2" then
                tvRP.notify("~y~CALL AN AMBULANCE")
                tvRP.notify("~y~CALL AN AMBULANCE")
                tvRP.notify("~r~BUT NOT FOR ME.")
                SendNUIMessage({transactionType = "callanambulance"})
            else
                if #(aA - ce) < 600.0 or (CORRUPT.getUserId() == 1 or CORRUPT.getUserId() == 2) then
                    TriggerServerEvent("CORRUPT:logVehicleSpawn", az, "/car")
                    local cf = CORRUPT.spawnVehicle(az, aA.x, aA.y, aA.z, GetEntityHeading(CORRUPT.getPlayerPed()), true, true, true)
                    DecorSetInt(cf, decor, 945)
                    SetVehicleOnGroundProperly(cf)
                    SetEntityInvincible(cf, false)
                    SetVehicleModKit(cf, 0)
                    SetVehicleMod(cf, 11, 2, false)
                    SetVehicleMod(cf, 13, 2, false)
                    SetVehicleMod(cf, 12, 2, false)
                    SetVehicleMod(cf, 15, 3, false)
                    ToggleVehicleMod(cf, 18, true)
                    SetPedIntoVehicle(CORRUPT.getPlayerPed(), cf, -1)
                    SetModelAsNoLongerNeeded(GetHashKey(az))
                    SetVehRadioStation(cf, "OFF")
                    Wait(500)
                    SetVehRadioStation(cf, "OFF")
                else
                    tvRP.notify("~r~Vehicles may only be spawned at the airport for testing")
                end
            end
        end
    end,
    false
)
RegisterCommand(
    "dv",
    function()
        if
            globalOnPoliceDuty or globalNHSOnDuty or globalLFBOnDuty or CORRUPT.getStaffLevel() > 0 or CORRUPT.getUserId() == 5 or
                CORRUPT.getUserId() == 913 or
                globalOnPrisonDuty and isPlayerNearPrison()
         then
            local b8 = GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false)
            if NetworkHasControlOfEntity(b8) and (CORRUPT.getStaffLevel() > 0 or GetEntitySpeed(b8) < 1.0) then
                DeleteEntity(b8)
            end
        end
    end,
    false
)
AddEventHandler(
    "CORRUPT:searchClient",
    function(cg)
        local A = tonumber(DecorGetInt(cg, "corrupt_owner"))
        print("searching user_id", A, type(A))
        if A > 0 then
            CORRUPT.loadAnimDict("missexile3")
            TaskPlayAnim(
                PlayerPedId(),
                "missexile3",
                "ex03_dingy_search_case_base_michael",
                1.0,
                8.0,
                12000,
                1,
                1.0,
                false,
                false,
                false
            )
            RemoveAnimDict("missexile3")
            TriggerServerEvent("CORRUPT:searchVehicle", VehToNet(cg), A)
        else
            tvRP.notify("~r~Vehicle is not owned by anyone")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:openAllDoors",
    function(ch, ci)
        local aL = CORRUPT.getObjectId(ch, "CORRUPT:openAllDoors")
        local cj = GetNumberOfVehicleDoors(aL)
        for ck = 0, cj do
            if ci then
                SetVehicleDoorOpen(aL, ck, false, false)
            else
                SetVehicleDoorShut(aL, ck, false)
            end
        end
    end
)
local cl = {}
RegisterNetEvent(
    "CORRUPT:lockpickClient",
    function(cg, cm)
        FreezeEntityPosition(CORRUPT.getPlayerPed(), true)
        RequestAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
        while not HasAnimDictLoaded("anim@amb@clubhouse@tutorial@bkr_tut_ig3@") do
            Citizen.Wait(0)
        end
        local cn = true
        local co = false
        local cp = GetGameTimer()
        tvRP.notify("~g~Lock Picking in progress, you can cancel by pressing [E].")
        Citizen.CreateThread(
            function()
                while cn do
                    if
                        not IsEntityPlayingAnim(
                            CORRUPT.getPlayerPed(),
                            "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                            "machinic_loop_mechandplayer",
                            3
                        )
                     then
                        TaskPlayAnim(
                            CORRUPT.getPlayerPed(),
                            "anim@amb@clubhouse@tutorial@bkr_tut_ig3@",
                            "machinic_loop_mechandplayer",
                            8.0,
                            -8.0,
                            -1,
                            1,
                            0,
                            false,
                            false,
                            false
                        )
                    end
                    local cq = math.floor((GetGameTimer() - cp) / 60000 * 100)
                    drawNativeText("~b~Lock Picking - " .. cq .. "%")
                    if IsControlJustPressed(0, 38) then
                        tvRP.notify("~b~Lock Picking cancelled.")
                        cn = false
                        co = true
                        ClearPedTasks(CORRUPT.getPlayerPed())
                        FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
                    end
                    Wait(0)
                end
                RemoveAnimDict("anim@amb@clubhouse@tutorial@bkr_tut_ig3@")
            end
        )
        Wait(60000)
        FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
        ClearPedTasks(CORRUPT.getPlayerPed())
        cn = false
        if cm and not co then
            cl[cg] = true
            local A = tonumber(DecorGetInt(cg, "corrupt_owner"))
            if A > 0 then
                TriggerServerEvent("CORRUPT:lockpickVehicle", GetEntityModel(cg), A)
            else
                tvRP.notify("~r~Vehicle is not owned by anyone")
            end
            local cr = NetworkGetNetworkIdFromEntity(cg)
            if cr ~= 0 then
                TriggerServerEvent("CORRUPT:setVehicleLock", cr, false)
                tvRP.notify("Vehicle unlocked.")
            end
        else
            tvRP.notify("~r~Failed to lockpick vehicle.")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:playLockpickAlarm",
    function(cs)
        local ab = CORRUPT.getObjectId(cs, "CORRUPT:playLockpickAlarm")
        if ab then
            local bH = GetSoundId()
            PlaySoundFromEntity(bH, "ALARM_ONE", ab, "DLC_ALARM_SOUNDSET", 0, 0)
            SetTimeout(
                60000,
                function()
                    StopSound(bH)
                    ReleaseSoundId(bH)
                end
            )
        end
    end
)
AddEventHandler(
    "CORRUPT:verifyLockpick",
    function(cg)
        local A = tonumber(DecorGetInt(cg, "corrupt_owner"))
        if A > 0 then
            if cl[cg] then
                TriggerServerEvent("CORRUPT:lockpickVehicle", GetEntityModel(cg), A)
            else
                TriggerServerEvent("CORRUPT:attemptLockpick", cg, VehToNet(cg))
            end
        else
            tvRP.notify("~r~Vehicle owner is not online.")
        end
    end
)
function CORRUPT.getCustomFolders()
    local r = GetResourceKvpString("corrupt_garagefolders")
    if r == nil or r == "null" then
        r = "{}"
    end
    r = json.decode(r)
    return r
end
function CORRUPT.isVehicleInAnyCustomFolder(J)
    for a1, a2 in pairs(r) do
        if a2[J] or a2[tostring(J)] then
            return true
        end
    end
    return false
end
function CORRUPT.saveCustomFolders()
    SetResourceKvp("corrupt_garagefolders", json.encode(r))
end
function CORRUPT.addCarToCustomFolder(J, ba, a1)
    if r[a1] then
        r[a1][J] = true
        CORRUPT.saveCustomFolders()
        tvRP.notify("~g~Added vehicle to custom folder.")
    else
        tvRP.notify("~r~Failed to add vehicle to folder, folder does not exist?")
    end
end
function CORRUPT.removeCarFromCustomFolder(J, a1)
    if r[a1] then
        if r[a1][J] or r[a1][tostring(J)] then
            r[a1][J] = nil
            r[a1][tostring(J)] = nil
            CORRUPT.saveCustomFolders()
            tvRP.notify("~g~Removed vehicle from custom folder.")
        else
            tvRP.notify("~r~Failed to remove vehicle from folder, vehicle not in folder.")
        end
    else
        tvRP.notify("~r~Failed to remove vehicle from folder, folder does not exist?")
    end
end
function CORRUPT.createCustomFolder(ct)
    r[ct] = {}
    CORRUPT.saveCustomFolders()
    tvRP.notify("~g~Created " .. ct)
end
function CORRUPT.deleteCustomFolder(a1)
    r[a1] = nil
    CORRUPT.saveCustomFolders()
    tvRP.notify("~g~Deleted " .. a1)
end
function CORRUPT.getGarageSettings()
    local cu = GetResourceKvpString("corrupt_garagesettings")
    if cu == nil or cu == "null" then
        cu = "{}"
    end
    cu = json.decode(cu)
    return cu
end
function CORRUPT.saveGarageSettings()
    SetResourceKvp("corrupt_garagesettings", json.encode(s))
end
AddEventHandler(
    "CORRUPT:johnnyCantMakeIt",
    function()
        SendNUIMessage({transactionType = "MPCT_ALAA_0" .. math.random(1, 5)})
    end
)
local cz = 0
local function cA()
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(cz, false)
    cz = 0
    DoScreenFadeIn(0)
    ClearFocus()
end
RegisterNetEvent(
    "CORRUPT:viewRemoteDashcam",
    function(al, c8)
        if cz ~= 0 then
            DestroyCam(cz, false)
            return
        end
        DoScreenFadeOut(0)
        cz = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamActive(cz, true)
        SetCamCoord(cz, al.x, al.y, al.z)
        RenderScriptCams(true, false, 0, true, true)
        SetFocusPosAndVel(al.x, al.y, al.z, 0.0, 0.0, 0.0)
        RageUI.CloseAll()
        local cB = GetGameTimer()
        while not NetworkDoesEntityExistWithNetworkId(c8) do
            if GetGameTimer() - cB > 5000 then
                cA()
                notify("~r~Can not view dashcam of vehicle.")
                return
            end
            Citizen.Wait(0)
        end
        local aL = NetworkGetEntityFromNetworkId(c8)
        if aL == 0 then
            cA()
            notify("~r~Can not view dashcam of vehicle.")
            return
        end
        DoScreenFadeIn(0)
        notify("~g~Viewing your vehicle dashcam.")
        while DoesEntityExist(aL) and IsCamActive(cz) and not IsControlJustPressed(0, 177) do
            local cC = GetWorldPositionOfEntityBone(aL, GetEntityBoneIndexByName(aL, "windscreen"))
            local cD = GetEntityRotation(aL, 2)
            SetCamCoord(cz, cC.x, cC.y, cC.z)
            SetFocusPosAndVel(cC.x, cC.y, cC.z, 0.0, 0.0, 0.0)
            SetCamRot(cz, cD.x, cD.y, cD.z, 2)
            Citizen.Wait(0)
        end
        notify("~r~Stopped viewing your vehicle dashcam.")
        RenderScriptCams(false, false, 0, false, false)
        DestroyCam(cz, false)
        cz = 0
    end
)
local cE = 0
RegisterNetEvent("CORRUPT:displayVehicleBlip",function(al)
    if cE ~= 0 then
        RemoveBlip(cE)
    end
    if al then
        cE = AddBlipForCoord(al.x, al.y, al.z)
        SetBlipSprite(cE, 56)
        SetBlipScale(cE, 1.0)
        SetBlipColour(cE, 2)
    end
end)
local cF = 0
Citizen.CreateThread(
    function()
        DecorRegister("biometricLock", 2)
        while true do
            local aL, cG = CORRUPT.getPlayerVehicle()
            if aL ~= 0 and cG then
                local cH = DecorGetBool(aL, "biometricLock")
                if cH then
                    local A = CORRUPT.getUserId()
                    local cI = Entity(aL).state.biometricUsers
                    local cJ = DecorGetInt(aL, "corrupt_owner")
                    if A ~= cJ and not CORRUPT.isDeveloper() and (not cI or not table.has(cI, A)) then
                        DisableControlAction(0, 32, true)
                        DisableControlAction(0, 33, true)
                        DisableControlAction(0, 34, true)
                        DisableControlAction(0, 35, true)
                        DisableControlAction(0, 71, true)
                        DisableControlAction(0, 72, true)
                        DisableControlAction(0, 87, true)
                        DisableControlAction(0, 88, true)
                        DisableControlAction(0, 129, true)
                        DisableControlAction(0, 130, true)
                        DisableControlAction(0, 107, true)
                        DisableControlAction(0, 108, true)
                        DisableControlAction(0, 109, true)
                        DisableControlAction(0, 110, true)
                        DisableControlAction(0, 111, true)
                        DisableControlAction(0, 112, true)
                        DisableControlAction(0, 350, true)
                        DisableControlAction(0, 351, true)
                        SetVehicleRocketBoostPercentage(aL, 0.0)
                        drawNativeText("This vehicle is locked biometrically to the owner.")
                    end
                end
            end
            local ca = PlayerPedId()
            if GetIsTaskActive(ca, 160) then
                local cK = GetVehiclePedIsEntering(ca)
                if cK ~= 0 then
                    local cL = GetVehicleDoorLockStatus(cK)
                    if cL == 2 then
                        cF = cK
                    elseif cL == 1 and cK == cF then
                        ClearPedTasks(ca)
                        cF = 0
                    end
                end
            else
                cF = 0
            end
            Citizen.Wait(0)
        end
    end
)
function setVehicleIdBiometricLock(bx, cM, cN)
    if cM["21"] then
        DecorSetBool(bx, "biometricLock", true)
    end
    if cN then
        local cO = false
        if not NetworkGetEntityIsNetworked(bx) or NetworkGetNetworkIdFromEntity(bx) == 0 then
            cO = true
        end
        Citizen.CreateThread(
            function()
                Citizen.Wait(cO and 2500 or 0)
                local c8 = NetworkGetNetworkIdFromEntity(bx)
                TriggerServerEvent("CORRUPT:setBiometricUsersState", c8, cN)
            end
        )
    end
end
function tvRP.getModelFromNetId(c8)
    local aL = NetworkGetEntityFromNetworkId(c8)
    if aL ~= 0 then
        return aL
    end
    return 0
end

local cP = {}
Citizen.CreateThread(
    function()
        while true do
            for U, aL in pairs(GetGamePool("CVehicle")) do
                if not cP[aL] and DecorExistOn(aL, "lsAudioId") then
                    local bK = DecorGetInt(aL, "lsAudioId")
                    local cQ = getVehicleSoundNameFromId(bK)
                    ForceVehicleEngineAudio(aL, cQ)
                    cP[aL] = GetGameTimer()
                end
            end
            Citizen.Wait(2000)
        end
    end
)
exports(
    "hasAppliedEngineAudio",
    function(aL)
        local cR = cP[aL]
        return cR and GetGameTimer() - cR > 5000
    end
)
Citizen.CreateThread(
    function()
        while true do
            local aL, cG = CORRUPT.getPlayerVehicle()
            if
                aL ~= 0 and not globalHideUi and GetVehicleClass(aL) ~= 14 and
                    (cG or GetPedInVehicleSeat(aL, 0) == PlayerPedId())
             then
                SendNUIMessage({showSpeed = true, speed = math.ceil(GetEntitySpeed(aL) * 2.2369)})
            else
                SendNUIMessage({showSpeed = false, speed = 0})
            end
            Citizen.Wait(50)
        end
    end
)
local cS = vector3(0.0, 0.0, 0.0)
local cT = {}
Citizen.CreateThread(
    function()
        while true do
            local aL, cG = CORRUPT.getPlayerVehicle()
            local aK = CORRUPT.getPlayerCoords()
            if aL ~= 0 and cG and DecorGetInt(aL, "corrupt_owner") == CORRUPT.getUserId() then
                local ax = GetEntityModel(aL)
                local bW = #(cS - aK)
                if bW < 120.0 and GetEntitySpeed(aL) > 5.0 then
                    local cU = cT[ax]
                    if not cU then
                        cU = {meters = 0.0, secondsInVehicle = 0}
                        cT[ax] = cU
                    end
                    cU.meters = cU.meters + bW
                    cU.secondsInVehicle = cU.secondsInVehicle + 1
                    if cU.secondsInVehicle >= 30 then
                        if cU.meters > 50.0 then
                            TriggerServerEvent("CORRUPT:updateVehicleMilage", cU.meters)
                        end
                        cU.meters = 0.0
                        cU.secondsInVehicle = 0
                    end
                end
                cS = aK
            end
            Citizen.Wait(1000)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:playRepairAnimAA",
    function(aL)
        local ca = PlayerPedId()
        TaskLookAtEntity(ca, aL, -1, 2048, 3)
        Citizen.Wait(3000)
        TaskStartScenarioInPlace(ca, "WORLD_HUMAN_HAMMERING", 0, true)
        Citizen.Wait(3000)
        TaskStartScenarioInPlace(ca, "WORLD_HUMAN_WELDING", 0, true)
        Citizen.Wait(3000)
        TaskStartScenarioInPlace(ca, "CODE_HUMAN_MEDIC_TIME_OF_DEATH", 0, true)
        Citizen.Wait(6000)
        ClearPedTasksImmediately(ca)
    end
)
local c8 = ObjToNet(GetVehiclePedIsIn(PlayerPedId(), false))
RegisterNetEvent("CORRUPT:repairVehicleAA",function(c8)
    if NetworkDoesNetworkIdExist(c8) and NetworkDoesEntityExistWithNetworkId(c8) then
        local aL = NetworkGetEntityFromNetworkId(c8)
        if aL ~= 0 then
            if NetworkHasControlOfEntity(aL) then
                FreezeEntityPosition(aL, true)
            end
            Citizen.Wait(10000)
            if NetworkHasControlOfEntity(aL) then
                FreezeEntityPosition(aL, false)
                SetVehicleEngineHealth(aL, 9999)
                SetVehiclePetrolTankHealth(aL, 9999)
                SetVehicleFixed(aL)
            end
        end
    end
end)