local a = module("cfg/cfg_impound")
local b = {owner_id = 0, owner_name = "", vehicle = "", vehicle_name = ""}
local c = {}
Citizen.CreateThread(
    function()
        for d, e in pairs(a.peds) do
            CORRUPT.createDynamicPed(e.modelHash, e.position, e.heading, true, e.animDict, e.animName, 30, false, false)
            tvRP.addBlip(e.position.x, e.position.y, e.position.z, 357, 81, "Vehicle Impound", 0.8, false)
        end
        Wait(2000)
        local f = function()
            TriggerServerEvent("CORRUPT:getImpoundedVehicles")
            RageUI.Visible(RMenu:Get("CORRUPTImpound", "main"), true)
        end
        local g = function()
            RageUI.CloseAll()
        end
        local h = function()
        end
        for d, e in pairs(a.peds) do
            CORRUPT.createArea("vehicle_impound_" .. d, e.position, 3.0, 6, f, g, h, {})
        end
    end
)
RMenu.Add(
    "CORRUPTImpound",
    "reasons",
    RageUI.CreateMenu(
        "",
        "~b~Impounding Vehicle...",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_jobselectorui",
        "metpd"
    )
)
RMenu.Add(
    "CORRUPTImpound",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~Your Impounded Vehicles",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_jobselectorui",
        "metpd"
    )
)
RMenu.Add("CORRUPTImpound", "vehicle_information", RageUI.CreateSubMenu(RMenu:Get("CORRUPTImpound", "main")))
RMenu.Add("CORRUPTImpound", "pay_fine_confirmation", RageUI.CreateSubMenu(RMenu:Get("CORRUPTImpound", "vehicle_information")))
local i = 0
RageUI.CreateWhile(
    1.0,
    RMenu:Get("CORRUPTImpound", "main"),
    nil,
    function()
        RageUI.BackspaceMenuCallback(
            function()
                resetChecked()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTImpound", "reasons"),
            true,
            true,
            true,
            function()
                RageUI.Separator("Vehicle: ~b~" .. b.vehicle_name .. "~s~ | Owner: ~b~" .. b.owner_name)
                for j = 1, #a.reasonsForImpound do
                    RageUI.Checkbox(
                        a.reasonsForImpound[j].option,
                        "",
                        a.reasonsForImpound[j].checked,
                        {Style = 1},
                        function(k, l, d, m)
                            if l then
                                a.reasonsForImpound[j].checked = m
                            end
                        end
                    )
                end
                RageUI.ButtonWithStyle(
                    "~g~Confirm Selection",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, d, l)
                        if l then
                            local n = {}
                            for j, o in ipairs(a.reasonsForImpound) do
                                if o.checked then
                                    table.insert(n, j)
                                    o.checked = false
                                end
                            end
                            TriggerServerEvent(
                                "CORRUPT:impoundVehicle",
                                b.owner_id,
                                b.owner_name,
                                b.vehicle,
                                b.vehicle_name,
                                n,
                                b.vehicle_net_id
                            )
                            RageUI.CloseAll()
                        end
                    end,
                    function()
                    end
                )
                RageUI.ButtonWithStyle(
                    "~r~Cancel",
                    "",
                    {RightLabel = "→→→"},
                    true,
                    function(k, d, l)
                        if l then
                            RageUI.CloseAll()
                        end
                    end,
                    function()
                    end
                )
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTImpound", "main"),
            true,
            true,
            true,
            function()
                RageUI.Separator("View your impounded vehicles here.")
                RageUI.Separator(
                    "You can pay the ~g~£" ..
                        getMoneyStringFormatted(a.impoundPrice) .. "~s~ fine to release your vehicle."
                )
                RageUI.Separator("---")
                if c ~= nil and c ~= {} then
                    for p, q in pairs(c) do
                        RageUI.ButtonWithStyle(
                            q.vehicle_name,
                            "",
                            {RightLabel = "→→→"},
                            true,
                            function(k, d, l)
                                if l then
                                    i = q
                                end
                            end,
                            RMenu:Get("CORRUPTImpound", "vehicle_information")
                        )
                    end
                else
                    RageUI.Separator("~r~None of your vehicles are currently impounded.")
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTImpound", "vehicle_information"),
            true,
            true,
            true,
            function()
                if i ~= 0 then
                    RageUI.Separator(i.vehicle_name)
                    RageUI.Separator(
                        "This vehicle was impounded by ~b~" ..
                            i.impounded_by_name .. " (ID: " .. i.impounder .. ") ~s~for:"
                    )
                    local r = i.reasons
                    for j, o in ipairs(r) do
                        RageUI.Separator("» " .. r[j])
                    end
                    RageUI.ButtonWithStyle(
                        "~g~Pay Fine",
                        "Paying the fine will release your vehicle.",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                        end,
                        RMenu:Get("CORRUPTImpound", "pay_fine_confirmation")
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("CORRUPTImpound", "pay_fine_confirmation"),
            true,
            true,
            true,
            function()
                if i ~= 0 then
                    RageUI.Separator("Would you like to release your vehicle?")
                    RageUI.Separator(
                        "This action will cost you ~g~£" .. getMoneyStringFormatted(a.impoundPrice) .. "~s~."
                    )
                    RageUI.Separator("---")
                    RageUI.ButtonWithStyle(
                        "~g~Pay",
                        "Pay the fine",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                            if l then
                                TriggerServerEvent("CORRUPT:releaseImpoundedVehicle", i.vehicle)
                            end
                        end,
                        RMenu:Get("CORRUPTImpound", "main")
                    )
                    RageUI.ButtonWithStyle(
                        "~r~Cancel",
                        "Go back",
                        {RightLabel = "→→→"},
                        true,
                        function(k, d, l)
                        end,
                        RMenu:Get("CORRUPTImpound", "main")
                    )
                end
            end,
            function()
            end
        )
    end
)
RegisterNetEvent(
    "CORRUPT:receiveInfoForVehicleToImpound",
    function(s, t, u, v, e)
        b = {owner_id = tonumber(s), owner_name = t, vehicle = u, vehicle_name = v, vehicle_net_id = e}
    end
)
RegisterNetEvent(
    "CORRUPT:receiveImpoundedVehicles",
    function(w)
        c = w
    end
)

RegisterNetEvent(
    "CORRUPT:impoundSuccess",
    function(x, u, y, z, A, B, C, D)
        local v = NetworkGetEntityFromNetworkId(x)
        local E = GetEntityCoords(v, false)
        local F = CreateObject("prop_cs_protest_sign_03", E.x, E.y, E.z, true, true, true)
        CORRUPT.loadModel("prop_clamp")
        FreezeEntityPosition(v, true)
        local G = CreateObject("prop_clamp", E.x, E.y, E.z, true, true, true)
        SetModelAsNoLongerNeeded("prop_clamp")
        local H = GetEntityBoneIndexByName(v, "wheel_lf")
        SetEntityHeading(G, 0.0)
        AttachEntityToEntity(G, v, H, -0.1, 0.15, -0.3, 180.0, 200.0, 90.0, true, true, false, false, 2, true)
        FreezeEntityPosition(G, true)
        if IsVehicleWindowIntact(v, 0) then
            local I = GetEntityBoneIndexByName(v, "windscreen")
            FreezeEntityPosition(F, true)
            AttachEntityToEntity(F, v, I, 0.1, -2.7, -1.65, -32.0, 5.0, 180.0, true, true, false, true, 0, true)
        end
        tvRP.notifyPicture(
            "polnotification",
            "notification",
            "You have siezed a ~b~" ..
                u ..
                    "~s~ owned by ~b~" ..
                        y .. "~s~. \n \nA tow truck will pick up the vehicle shortly and take it to the impound.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
        local J = PlayerPedId()
        local K = GetEntityCoords(J)
        local L, L, M = GetClosestVehicleNodeWithHeading(K.x, K.y, K.z, nil, 8, 8, 8, 8)
        local L, N, L = GetPointOnRoadSide(K.x, K.y, K.z, 0.0)
        local L, O = GetNthClosestVehicleNode(K.x, K.y, K.z, 15)
        local P
        local Q
        if O ~= vector3(0, 0, 0) and N ~= vector3(0, 0, 0) then
            CORRUPT.loadModel("flatbed")
            CORRUPT.loadModel("a_m_m_prolhost_01")
            P = CORRUPT.spawnVehicle("flatbed", O.x, O.y, O.z, M, false, true, true)
            local R = NetworkGetNetworkIdFromEntity(P)
            SetVehicleDoorsLocked(P, 2)
            SetNetworkIdCanMigrate(R, false)
            SetModelAsNoLongerNeeded("flatbed")
            local S = AddBlipForEntity(P)
            SetBlipSprite(S, 68)
            SetBlipDisplay(S, 4)
            SetBlipScale(S, 1.0)
            SetBlipColour(S, 5)
            SetBlipAsShortRange(S, true)
            Q = CreatePedInsideVehicle(P, 1, "a_m_m_prolhost_01", -1, true)
            local T = NetworkGetNetworkIdFromEntity(Q)
            TaskVehicleDriveToCoord(Q, P, N.x, N.y, N.z, 15.0, 1.0, "flatbed", 262144, 5.0)
            SetModelAsNoLongerNeeded("a_m_m_prolhost_01")
            local U = GetGameTimer()
            local V = #(GetEntityCoords(v) - GetEntityCoords(P))
            while V > 15.0 and GetGameTimer() - U < 20000 do
                Wait(1000)
                V = #(GetEntityCoords(v) - GetEntityCoords(P))
            end
            TriggerServerEvent(
                "CORRUPT:deleteImpoundEntities",
                x,
                NetworkGetNetworkIdFromEntity(G),
                NetworkGetNetworkIdFromEntity(F)
            )
            v = CORRUPT.spawnVehicle(z, C.x, C.y, C.z, D, false, true, false)
            x = NetworkGetEntityFromNetworkId(v)
            SetVehicleDoorsLocked(v, 2)
            SetNetworkIdCanMigrate(x, false)
            SetVehicleColours(v, A, B)
            AttachEntityToEntity(v, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
            TriggerServerEvent("CORRUPT:awaitTowTruckArrival", x, R, T)
            TaskVehicleDriveToCoord(
                Q,
                P,
                a.driveToPosition.x,
                a.driveToPosition.y,
                a.driveToPosition.z,
                15.0,
                1.0,
                "flatbed",
                262144,
                5.0
            )
            SetEntityInvincible(v, true)
            SetEntityInvincible(P, true)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:attachVehToTowCl",
    function(x, W)
        local v = NetworkGetEntityFromNetworkId(x)
        local P = NetworkGetEntityFromNetworkId(W)
        AttachEntityToEntity(v, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
    end
)
local function X(v)
    for Y = -1, GetVehicleMaxNumberOfPassengers(v) - 1 do
        if not IsVehicleSeatFree(v, Y) then
            return true
        end
    end
    return false
end
function CORRUPT.impoundVehicleOptions(Z, _, x, a0)
    local a1 = g_vehicleHashToVehicleName[_]
    if X(a0) then
        tvRP.notifyPicture(
            "polnotification",
            "notification",
            "The vehicle cannot be impounded with a person inside.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
        return
    end
    local a2 = GetVehicleClass(a0)
    if a2 == 18 then
        tvRP.notifyPicture(
            "polnotification",
            "notification",
            "Emergency vehicles cannot be impounded.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
    elseif a.disallowedVehicleClasses[a2] then
        tvRP.notifyPicture(
            "polnotification",
            "notification",
            "That vehicle is too large to be impounded.",
            "Metropolitan Police",
            "Impound",
            nil,
            nil
        )
    else
        TriggerServerEvent("CORRUPT:fetchInfoForVehicleToImpound", Z, a1, x)
        RageUI.Visible(RMenu:Get("CORRUPTImpound", "reasons"), true)
    end
end
function CORRUPT.isVehicleImpounded(v)
    return c[v] ~= nil
end
function resetChecked()
    for L, o in ipairs(a.reasonsForImpound) do
        o.checked = false
    end
end
exports("impound", CORRUPT.impoundVehicleOptions)
exports("isImpounded", CORRUPT.isVehicleImpounded)

RegisterNetEvent("CORRUPT:impoundRequested",function(E, ax)
    local ak = CORRUPT.loadModel(E)
    if ak == nil then
        tvRP.notify("~r~Vehicle model not found. Please request a new impound vehicle.")
        return
    end
    local as
    local an = CORRUPT.getPosition()
    local az, T, aA = GetNthClosestVehicleNode(an.x, an.y, an.z, nil, 8, 8, 8, 8)
    local T, aB, T = GetNthClosestVehicleNode(an.x, an.y, an.z, 15)
    local aC, T, aD = GetClosestVehicleNodeWithHeading(an.x, an.y, an.z, nil, 8, 8, 8, 8)
    local T, aE, T = GetPointOnRoadSide(an.x, an.y, an.z, 0.0)
    local P
    local x
    if tostring(aE) ~= "vector3(0, 0, 0)" and tostring(aB) ~= "vector3(0, 0, 0)" then
        CORRUPT.loadModel("flatbed")
        CORRUPT.loadModel("a_m_m_prolhost_01")
        P = CORRUPT.spawnVehicle("flatbed", aB.x+5, aB.y, aB.z, M, false, true, true)
        local R = NetworkGetNetworkIdFromEntity(P)
        as = CORRUPT.spawnVehicle(ak, aB.x, aB.y, aB.z + 0.5, aA or 0.0, false, true, true)
        SetVehicleDoorsLocked(P, 2)
        SetNetworkIdCanMigrate(R, false)
        SetModelAsNoLongerNeeded("flatbed")
        x = NetworkGetEntityFromNetworkId(as)
        SetVehicleDoorsLocked(as, 2)
        SetNetworkIdCanMigrate(x, false)
        AttachEntityToEntity(as, P, 20, -0.5, -5.0, 1.0, 0.0, 0.0, 0.0, false, false, false, false, 20, true)
        SetEntityInvincible(as, true)
        SetEntityInvincible(P, true)
        local S = AddBlipForEntity(P)
        SetBlipSprite(S, 68)
        SetBlipDisplay(S, 4)
        SetBlipScale(S, 1.0)
        SetBlipColour(S, 5)
        SetBlipAsShortRange(S, true)
        Q = CreatePedInsideVehicle(P, 1, "a_m_m_prolhost_01", -1, true)
        TaskVehicleDriveToCoord(Q, P, aE.x, aE.y, aE.z, 15.0, 1.0, "flatbed", 262144, 5.0)
        SetModelAsNoLongerNeeded("a_m_m_prolhost_01")
        local U = GetGameTimer()
        local V = #(GetEntityCoords(an) - GetEntityCoords(P))
        while V > 15.0 and GetGameTimer() - U < 20000 do
            Wait(1000)
            V = #(GetEntityCoords(an) - GetEntityCoords(P))
        end
        DetachEntity(as, true, true)
        DeleteEntity(P)
        DeleteEntity(Q)
        SetVehicleDoorsLocked(as, 0)
        SetEntityInvincible(as, false)
        SetEntityInvincible(P, false)
        SetNetworkIdCanMigrate(x, true)
    end
end)