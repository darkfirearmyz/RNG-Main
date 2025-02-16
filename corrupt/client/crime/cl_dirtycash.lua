local a = "IDLE"
local b = false
local function c(d)
    CORRUPT.loadModel(d.model)
    d.ped = CreatePed(0, d.model, d.position.x, d.position.y, d.position.z - 1.0, d.position.w, false, false)
    SetModelAsNoLongerNeeded(d.model)
    FreezeEntityPosition(d.ped, true)
    SetEntityInvincible(d.ped, true)
    SetEntityCanBeDamaged(d.ped, false)
    SetPedAlertness(d.ped, 0)
    SetBlockingOfNonTemporaryEvents(d.ped, true)
    SetEntityCollision(d.ped, false, false)
    GiveWeaponToPed(d.ped, 0x01B79F17, 1, false, true)
    SetCurrentPedWeapon(d.ped, 0x01B79F17, true)
    CORRUPT.loadAnimDict("anim@heists@heist_corona@team_idles@female_a")
    TaskPlayAnim(d.ped, "anim@heists@heist_corona@team_idles@female_a", "idle", 8.0, 8.0, -1, 1, 0, false, false, false)
    RemoveAnimDict("anim@heists@heist_corona@team_idles@female_a")
    if GetPlayerServerId(PlayerId()) == d.playerSrc then
        d.blip = AddBlipForRadius(d.position.x, d.position.y, d.position.z, 10.0)
        SetBlipColour(d.blip, 5)
        SetBlipAlpha(d.blip, 150)
        SetWaypointOff()
    end
end
local function e(d)
    if d.blip then
        RemoveBlip(d.blip)
    end
    DeleteEntity(d.ped)
end
local function f()
    if a == "IDLE" then
        drawNativeNotification("Press ~INPUT_CONTEXT~ to hand over the dirty cash.")
        if IsControlJustPressed(0, 51) then
            TriggerServerEvent("CORRUPT:startHandingDirtyCash")
        end
    elseif a == "HANDING_OVER" then
        subtitleText("~b~Handing over cash...")
    end
end
local function g()
    if a == "HANDING_OVER" then
        TriggerServerEvent("CORRUPT:stopHandingDirtyCash")
    end
end
RegisterNetEvent(
    "CORRUPT:addDirtyCashDealer",
    function(h, i, j)
        local d = {playerSrc = h, position = i, model = j}
        CORRUPT.createArea(
            "dirtycash_" .. tostring(h),
            i.xyz,
            50.0,
            6.0,
            c,
            e,
            function()
            end,
            d
        )
        if GetPlayerServerId(PlayerId()) == h then
            CORRUPT.createArea(
                "dirtycash_local",
                i.xyz,
                1.5,
                6.0,
                function()
                end,
                g,
                f,
                nil
            )
        end
    end
)
RegisterNetEvent(
    "CORRUPT:removeDirtyCashDealer",
    function(h)
        if GetPlayerServerId(PlayerId()) == h then
            tvRP.removeArea("dirtycash_local")
        end
        local d = CORRUPT.getAreaMetaData("dirtycash_" .. tostring(h))
        if d.ped then
            ClearPedTasksImmediately(d.ped)
            SetEntityAsNoLongerNeeded(d.ped)
        end
        if d.blip then
            RemoveBlip(d.blip)
        end
        tvRP.removeArea("dirtycash_" .. tostring(h))
    end
)
RegisterNetEvent(
    "CORRUPT:routeDirtyCashDealer",
    function(i)
        if b then
            return
        end
        b = true
        local k = PlayerPedId()
        SendNUIMessage({transactionType = "ring"})
        CORRUPT.loadAnimDict("cellphone@")
        TaskPlayAnim(k, "cellphone@", "cellphone_text_in", 3.0, -1, -1, 50, 0, false, false, false)
        RemoveAnimDict("cellphone@")
        CORRUPT.loadModel("prop_amb_phone")
        local l = CreateObject("prop_amb_phone", i.x, i.y, i.z, true, true, false)
        AttachEntityToEntity(
            l,
            k,
            GetPedBoneIndex(k, 28422),
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            true,
            true,
            false,
            false,
            0,
            true
        )
        SetModelAsNoLongerNeeded("prop_amb_phone")
        Citizen.Wait(9000)
        StopAnimTask(k, "cellphone@", "cellphone_text_in", 1.0)
        DeleteEntity(l)
        SetNewWaypoint(i.x, i.y)
        drawNativeNotification("A marker has been set to the cleaners location.")
        b = false
    end
)
local function m(i)
    local n = 5.0
    local o = 0
    for p, q in pairs(GetGamePool("CPed")) do
        if not IsPedAPlayer(q) and NetworkGetEntityIsLocal(q) then
            local r = #(GetEntityCoords(q, true) - i.xyz)
            if r < n then
                n = r
                o = q
            end
        end
    end
    return o
end
RegisterNetEvent(
    "CORRUPT:startHandingDirtyCash",
    function(s)
        a = "HANDING_OVER"
        Citizen.CreateThread(
            function()
                tvRP.startCircularProgressBar(
                    "",
                    s,
                    nil,
                    function()
                    end
                )
            end
        )
        local k = PlayerPedId()
        local t = m(CORRUPT.getPlayerCoords())
        TaskTurnPedToFaceEntity(k, t, 1000)
        Citizen.Wait(1000)
        CORRUPT.loadAnimDict("mp_common")
        TaskPlayAnim(k, "mp_common", "givetake1_a", 8.0, 8.0, -1, 1, 0, false, false, false)
        RemoveAnimDict("mp_common")
        Citizen.Wait(2000)
        while a == "HANDING_OVER" do
            if not IsEntityPlayingAnim(k, "mp_common", "givetake1_a", 3) then
                TriggerServerEvent("CORRUPT:stopHandingDirtyCash")
                break
            end
            Citizen.Wait(0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:stopHandingDirtyCash",
    function()
        a = "IDLE"
        StopAnimTask(PlayerPedId(), "mp_common", "givetake1_a", 1.0)
        CORRUPT.stopCircularProgressBar()
    end
)
RegisterNetEvent(
    "CORRUPT:startHandingDirtyCashAnim",
    function(i)
        local q = m(i)
        if q ~= 0 then
            CORRUPT.loadAnimDict("mp_common")
            TaskPlayAnim(q, "mp_common", "givetake2_a", 8.0, 8.0, -1, 1, 0, false, false, false)
            RemoveAnimDict("mp_common")
        end
    end
)
RegisterNetEvent(
    "CORRUPT:stopHandingDirtyCashAnim",
    function(i)
        local q = m(i)
        if q ~= 0 then
            CORRUPT.loadAnimDict("anim@heists@heist_corona@team_idles@female_a")
            TaskPlayAnim(
                q,
                "anim@heists@heist_corona@team_idles@female_a",
                "idle",
                8.0,
                8.0,
                -1,
                1,
                0,
                false,
                false,
                false
            )
            RemoveAnimDict("anim@heists@heist_corona@team_idles@female_a")
        end
    end
)
