local function a(b)
    local c = GetActivePlayers()
    local d = -1
    local e = -1
    local f = PlayerPedId()
    local g = GetEntityCoords(f)
    for h, i in ipairs(c) do
        local j = GetPlayerPed(i)
        if j ~= f then
            local k = GetEntityCoords(j)
            local l = #(k - g)
            if d == -1 or d > l then
                e = i
                d = l
            end
        end
    end
    if d ~= -1 and d <= b then
        return e
    else
        return nil
    end
end
RegisterNetEvent("CORRUPT:useTheForceTarget")
AddEventHandler(
    "CORRUPT:useTheForceTarget",
    function()
        FreezeEntityPosition(PlayerPedId(), true)
        Wait(2500)
        CORRUPT.loadAnimDict("ragdoll@human")
        TaskPlayAnim(CORRUPT.getPlayerPed(), "ragdoll@human", "electrocute", 3.0, 1.0, -1, 01, 0, 0, 0, 0)
        Wait(5000)
        CORRUPT.setHealth(0)
        FreezeEntityPosition(PlayerPedId(), false)
    end
)
RegisterNetEvent("CORRUPT:useTheForceSync")
AddEventHandler(
    "CORRUPT:useTheForceSync",
    function(m, n, o)
        if #(m - GetEntityCoords(PlayerPedId())) < 25.0 then
            SendNUIMessage({transactionType = "unlimitedpower"})
            local o = {}
            local p = 0
            local q = n - m
            for r = 1, 10, 1 do
                table.insert(o, m + vector3(q.x / 10 * r, q.y / 10 * r, q.z / 10 * r))
            end
            local s = {}
            for t, u in pairs(o) do
                SetPtfxAssetNextCall("core")
                local v =
                    StartParticleFxLoopedAtCoord(
                    "ent_dst_elec_crackle",
                    u.x,
                    u.y,
                    u.z,
                    0.0,
                    0.0,
                    0.0,
                    1.2,
                    false,
                    false,
                    false
                )
                table.insert(s, v)
            end
            while p < 150 do
                p = p + 1
                for t, u in pairs(o) do
                    SetPtfxAssetNextCall("core")
                    local v =
                        StartParticleFxLoopedAtCoord(
                        "sp_foundry_sparks",
                        u.x,
                        u.y,
                        u.z,
                        90.0,
                        0.0,
                        0.0,
                        0.3,
                        false,
                        false,
                        false
                    )
                    SetPtfxAssetNextCall("core")
                    local w =
                        StartParticleFxLoopedAtCoord(
                        "ent_dst_elec_fire_sp",
                        u.x,
                        u.y,
                        u.z,
                        0.0,
                        0.0,
                        0.0,
                        1.0,
                        false,
                        false,
                        false
                    )
                    table.insert(s, v)
                    table.insert(s, w)
                end
                Wait(50)
                for t, u in pairs(s) do
                    RemoveParticleFx(u)
                end
            end
        end
    end
)
RegisterCommand(
    "theforce",
    function()
        if CORRUPT.isDeveloper() then
            local e = a(10)
            if e then
                local x = GetPlayerServerId(e)
                if x ~= -1 then
                    if not HasNamedPtfxAssetLoaded("core") then
                        RequestNamedPtfxAsset("core")
                        while not HasNamedPtfxAssetLoaded("core") do
                            Wait(0)
                        end
                    end
                    local p = 0
                    local m = GetEntityCoords(PlayerPedId())
                    local j = GetPlayerPed(e)
                    local n = GetEntityCoords(j)
                    local r = {}
                    local o = n - m
                    TriggerServerEvent("CORRUPT:theForceSync", x, m, n, o)
                    for s = 1, 10, 1 do
                        table.insert(r, m + vector3(o.x / 10 * s, o.y / 10 * s, o.z / 10 * s))
                    end
                    TriggerEvent("CORRUPT:PlaySound", "unlimitedpower")
                    FreezeEntityPosition(PlayerPedId(), true)
                    CORRUPT.loadAnimDict("anim@amb@clubhouse@bar@drink@idle_a")
                    TaskPlayAnim(
                        CORRUPT.getPlayerPed(),
                        "anim@amb@clubhouse@bar@drink@idle_a",
                        "idle_a_bartender",
                        3.0,
                        1.0,
                        -1,
                        01,
                        0,
                        0,
                        0,
                        0
                    )
                    RemoveAnimDict("anim@amb@clubhouse@bar@drink@idle_a")
                    local t = {}
                    for u, y in pairs(r) do
                        UseParticleFxAsset("core")
                        local v =
                            StartParticleFxLoopedAtCoord(
                            "ent_dst_elec_crackle",
                            y.x,
                            y.y,
                            y.z,
                            0.0,
                            0.0,
                            0.0,
                            1.2,
                            false,
                            false,
                            false
                        )
                        table.insert(t, v)
                    end
                    while p < 150 do
                        p = p + 1
                        for u, y in pairs(r) do
                            UseParticleFxAsset("core")
                            local v =
                                StartParticleFxLoopedAtCoord(
                                "sp_foundry_sparks",
                                y.x,
                                y.y,
                                y.z,
                                90.0,
                                0.0,
                                0.0,
                                0.3,
                                false,
                                false,
                                false
                            )
                            UseParticleFxAsset("core")
                            local w =
                                StartParticleFxLoopedAtCoord(
                                "ent_dst_elec_fire_sp",
                                y.x,
                                y.y,
                                y.z,
                                0.0,
                                0.0,
                                0.0,
                                1.0,
                                false,
                                false,
                                false
                            )
                            table.insert(t, v)
                            table.insert(t, w)
                        end
                        Wait(50)
                        for u, y in pairs(t) do
                            RemoveParticleFx(y)
                        end
                    end
                    RemoveNamedPtfxAsset("core")
                    FreezeEntityPosition(PlayerPedId(), false)
                    ClearPedTasks(PlayerPedId())
                else
                    drawNativeNotification("~r~No one nearby to use the force on!")
                end
            else
                drawNativeNotification("~r~No one nearby to use the force on!")
            end
        end
    end
)
RegisterCommand(
    "thor",
    function()
        if CORRUPT.getUserId() == 2 then
            tvRP.setCustomization({model = "Thor_IW"})
            if not HasNamedPtfxAssetLoaded("core") then
                RequestNamedPtfxAsset("core")
                while not HasNamedPtfxAssetLoaded("core") do
                    Wait(0)
                end
            end
            local p = 0
            while p < 1000 do
                p = p + 1
                local g = GetEntityCoords(CORRUPT.getPlayerPed())
                UseParticleFxAsset("core")
                local v =
                    StartParticleFxLoopedAtCoord(
                    "sp_foundry_sparks",
                    g.x,
                    g.y,
                    g.z,
                    0.0,
                    0.0,
                    0.0,
                    1.0,
                    false,
                    false,
                    false,
                    false
                )
                UseParticleFxAsset("core")
                local w =
                    StartParticleFxLoopedAtCoord(
                    "ent_dst_elec_crackle",
                    g.x,
                    g.y,
                    g.z - 1,
                    0.0,
                    0.0,
                    0.0,
                    5.0,
                    false,
                    false,
                    false,
                    false
                )
                UseParticleFxAsset("core")
                local z =
                    StartParticleFxLoopedAtCoord(
                    "exp_grd_plane_sp",
                    g.x,
                    g.y,
                    g.z - 1,
                    0.0,
                    0.0,
                    0.0,
                    1.0,
                    false,
                    false,
                    false,
                    false
                )
                Wait(100)
                RemoveParticleFx(v, false)
                RemoveParticleFx(w, false)
                RemoveParticleFx(z, false)
            end
            RemoveNamedPtfxAsset("core")
        end
    end,
    false
)
RegisterCommand(
    "yoda",
    function()
        if CORRUPT.getUserId() == 2 then
            tvRP.setCustomization({model = "yoda"})
        end
    end,
    false
)
