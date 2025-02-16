local a = false
local b = false
RegisterNetEvent(
    "CORRUPT:applyMorphine",
    function()
        if not a then
            a = true
            local c = "mp_suicide"
            local d = "pill"
            CORRUPT.loadAnimDict(c)
            TaskPlayAnim(CORRUPT.getPlayerPed(), c, d, 2.0, 2.0, 2500, 48, 1, 9, false, false)
            RemoveAnimDict(c)
            Wait(2500)
            local e = 0
            while e <= 100 do
                if GetEntityHealth(PlayerPedId()) <= 200 and GetEntityHealth(PlayerPedId()) > 102 then
                    tvRP.varyHealth(1)
                end
                e = e + 1
                Wait(250)
            end
            a = false
        else
            tvRP.notify("~r~fuck, I don't feel too good...")
            local c = "mp_suicide"
            local d = "pill"
            CORRUPT.loadAnimDict(c)
            TaskPlayAnim(CORRUPT.getPlayerPed(), c, d, 2.0, 2.0, 2500, 48, 1, 9, false, false)
            RemoveAnimDict(c)
            Wait(2500)
            tvRP.playScreenEffect("DrugsMichaelAliensFight", 30)
            local e = 0
            while e <= 100 do
                if GetEntityHealth(PlayerPedId()) > 102 then
                    tvRP.varyHealth(-2)
                end
                e = e + 1
                Wait(250)
            end
        end
    end
)
RegisterNetEvent(
    "CORRUPT:eatTaco",
    function()
        if not b then
            b = true
            local f = {
                {"mp_player_inteat@burger", "mp_player_int_eat_burger_enter", 1},
                {"mp_player_inteat@burger", "mp_player_int_eat_burger", 1},
                {"mp_player_inteat@burger", "mp_player_int_eat_burger_fp", 1},
                {"mp_player_inteat@burger", "mp_player_int_eat_exit_burger", 1}
            }
            tvRP.playAnim(true, f, false)
            Wait(2500)
            local e = 0
            while e <= 25 do
                if GetEntityHealth(PlayerPedId()) <= 200 and GetEntityHealth(PlayerPedId()) > 102 then
                    tvRP.varyHealth(1)
                end
                e = e + 1
                Wait(125)
            end
            b = false
        else
            tvRP.notify("~r~You dropped the taco on the floor trying to stuff it in your mouth!")
        end
    end
)
local function g(h)
    local i = PlayerPedId()
    tvRP.setCanAnim(false)
    SetTimecycleModifier("spectator5")
    SetPedMotionBlur(i, true)
    CORRUPT.loadClipSet("move_m@drunk@verydrunk")
    SetPedMovementClipset(i, "move_m@drunk@verydrunk", true)
    RemoveClipSet("move_m@drunk@verydrunk")
    Citizen.Wait(8000)
    DoScreenFadeOut(3500)
    local j = GetGameTimer()
    while GetGameTimer() - j < 12000 do
        SetPedToRagdoll(i, 5000, 5000, 0, false, false, false)
        Citizen.Wait(0)
    end
    if h then
        DoScreenFadeIn(2000)
        Citizen.Wait(2000)
        tvRP.setCanAnim(true)
    end
    ClearTimecycleModifier()
    SetPedMotionBlur(i, false)
    ResetPedMovementClipset(i, 0.0)
end
local function k()
    local l = {
        vector4(-803.1484375, 168.69989013672, 76.740577697754, 117.35),
        vector4(1971.0661621094, 3819.2163085938, 33.428691864014, 301.21),
        vector4(951.93359375, 459.44088745117, 126.2303237915, 161.45),
        vector4(973.404296875, -208.77210998535, 76.168434143066, 63.13),
        vector4(1350.5997314453, -535.03851318359, 74.035507202148, 253.63),
        vector4(-17.932209014893, -1436.7879638672, 31.101530075073, 174.58)
    }
    local i = PlayerPedId()
    local m = l[math.random(1, #l)]
    FreezeEntityPosition(i, true)
    SetEntityCoordsNoOffset(i, m.x, m.y, m.z, true, false, false)
    SetEntityHeading(i, m.w)
    CORRUPT.loadAnimDict("anim@amb@nightclub@lazlow@lo_toilet@")
    TaskPlayAnim(
        i,
        "anim@amb@nightclub@lazlow@lo_toilet@",
        "lowtoilet_base_laz",
        800.0,
        8.0,
        -1,
        49,
        0,
        false,
        false,
        false
    )
    RemoveAnimDict("anim@amb@nightclub@lazlow@lo_toilet@")
    while not HasAnimSetLoaded("move_ped_crouched") do
        RequestAnimSet("move_ped_crouched")
        Citizen.Wait(0)
    end
    SetPedMovementClipset(i, "move_ped_crouched", 0.35)
    RemoveAnimSet("move_ped_crouched")
    Citizen.Wait(2000)
    DoScreenFadeIn(1000)
    Citizen.Wait(5000)
    tvRP.setCanAnim(true)
    StopAnimTask(i, "anim@amb@nightclub@lazlow@lo_toilet@", "lowtoilet_base_laz", 1.0)
    ResetPedMovementClipset(i, 0.55)
    FreezeEntityPosition(i, false)
end
local function n()
    local j = GetGameTimer()
    while true do
        local o = GetGameTimer() - j
        if o > 1000 then
            break
        end
        local p = (1000 - o) / 1000
        SetTimecycleModifierStrength(p)
        Citizen.Wait(0)
    end
    ClearTimecycleModifier()
end
local function q(r, s)
    CORRUPT.loadModel(r)
    CORRUPT.loadModel(s)
    local t = CORRUPT.getPlayerCoords()
    local u, v = GetNthClosestVehicleNode(t.x, t.y, t.z, 6)
    if u then
        local w = CreatePed(0, r, v.x, v.y, v.z, 0.0, true, true)
        local x = CreateObject(s, t.x, t.y, t.z, true, true, false)
        AttachEntityToEntity(
            x,
            w,
            GetPedBoneIndex(w, 17188),
            0.120,
            0.010,
            0.010,
            5.0,
            150.0,
            0.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        TaskGoToCoordAnyMeans(w, t.x, t.y, t.z, 5.0, 0.0, false, 786603, 0xbf800000)
        local y = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        local z = GetGameplayCamCoord()
        SetCamCoord(y, z.x, z.y, z.z)
        local A = GetGameplayCamRot(2)
        SetCamRot(y, A.x, A.y, A.z, 2)
        SetCamActive(y, true)
        RenderScriptCams(true, true, 0, true, true)
        PointCamAtEntity(y, w, 0.0, 0.0, 0.0, true)
        SetCamFov(y, 30.0)
        local B = AddBlipForEntity(w)
        SetBlipSprite(B, 141)
        SetBlipColour(B, 2)
        local j = GetGameTimer()
        while #(GetEntityCoords(w, true) - t) > 2.0 and GetGameTimer() - j < 10000 do
            Citizen.Wait(0)
        end
        SetCamActive(y, false)
        RenderScriptCams(false, false, 0, false, false)
        DestroyCam(y, false)
        DetachEntity(x, false, false)
        Citizen.Wait(30000)
        DeleteEntity(w)
        DeleteEntity(x)
    end
    SetModelAsNoLongerNeeded(r)
    SetModelAsNoLongerNeeded(s)
end
local function C()
    local t = CORRUPT.getPlayerCoords()
    local u, v = GetNthClosestVehicleNode(t.x, t.y, t.z, 6)
    if not u then
        return
    end
    CORRUPT.loadModel("u_m_m_jesus_01")
    local D = CreatePed(0, "u_m_m_jesus_01", v.x, v.y, v.z, 0.0, false, false)
    TaskTurnPedToFaceEntity(D, PlayerPedId(), -1)
    SetModelAsNoLongerNeeded("u_m_m_jesus_01")
    SetTimecycleModifier("Kifflom")
    local y = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    local z = GetGameplayCamCoord()
    SetCamCoord(y, z.x, z.y, z.z)
    local A = GetGameplayCamRot(2)
    SetCamRot(y, A.x, A.y, A.z, 2)
    SetCamActive(y, true)
    RenderScriptCams(true, true, 0, true, true)
    PointCamAtEntity(y, D, 0.0, 0.0, 0.0, true)
    notify("~y~Is that... jesus?")
    local E = 30.0 - GetCamFov(y)
    local j = GetGameTimer()
    while true do
        local o = GetGameTimer() - j
        if o > 10000 then
            break
        end
        local p = o / 15000
        local F = E * p
        SetCamFov(y, 30.0 + F)
        Citizen.Wait(0)
    end
    SetCamActive(y, false)
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(y, false)
    DeleteEntity(D)
    n()
end
local function G()
    CORRUPT.loadModel("prop_anim_cash_note_b")
    local H = CORRUPT.getPlayerCoords()
    local x = CreateObject("prop_anim_cash_note_b", H.x, H.y, H.z, false, false, false)
    PlaceObjectOnGroundProperly(x)
    SetModelAsNoLongerNeeded("prop_anim_cash_note_b")
end
local function I()
    CORRUPT.loadModel("a320")
    CORRUPT.loadModel("s_m_m_pilot_01")
    CORRUPT.overrideTime(0, 0, 0)
    CORRUPT.setWeather("THUNDER")
    local J = CreateVehicle("a320", 1578.0584716797, 4051.5563964844, 1084.2967529297, 78.90, false, false)
    DecorSetInt(J, decor, 945)
    local K = CreatePedInsideVehicle(J, 0, "s_m_m_pilot_01", -1, false, false)
    DecorSetInt(K, decor, 945)
    SetModelAsNoLongerNeeded("a320")
    SetModelAsNoLongerNeeded("s_m_m_pilot_01")
    local y = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    AttachCamToPedBone(y, K, GetPedBoneIndex(K, 12844), 0.0, 0.0, 0.7, true)
    SetCamActive(y, true)
    RenderScriptCams(true, true, 0, true, true)
    SetFocusEntity(J)
    local function L()
        return math.random(-2, 2) + 0.0
    end
    DoScreenFadeIn(1000)
    local M = 0
    while not IsEntityDead(J) do
        if GetGameTimer() - M > 200 then
            ApplyForceToEntity(J, 1, L(), L(), L(), 0.0, 0.0, 0.0, -1, true, false, true, false, false)
            M = GetGameTimer()
        end
        local N = GetEntityRotation(J, 2)
        SetCamRot(y, N.x, N.y, N.z, 2)
        SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, false, false, false)
        Citizen.Wait(0)
    end
    ClearFocus()
    SetCamActive(y, false)
    RenderScriptCams(false, false, 0, false, false)
    DestroyCam(y, false)
    DeleteEntity(K)
    DeleteEntity(J)
    tvRP.setCanAnim(true)
    CORRUPT.cancelOverrideTimeWeather()
end
RegisterNetEvent(
    "CORRUPT:halloweenUnknownCandy",
    function()
        CORRUPT.loadAnimDict("mp_safehousebeer@")
        CORRUPT.loadModel("tr_prop_tr_plate_sweets_01a")
        local i = PlayerPedId()
        local O = CreateObject("tr_prop_tr_plate_sweets_01a", 0.0, 0.0, 0.0, false, false, false)
        AttachEntityToEntity(
            O,
            i,
            GetPedBoneIndex(i, 28422),
            0.0,
            0.0,
            0.0,
            0.0,
            0.0,
            180.0,
            true,
            true,
            false,
            true,
            1,
            true
        )
        TaskPlayAnim(i, "mp_safehousebeer@", "drink_2", 800.0, 8.0, -1, 49, 0, false, false, false)
        Citizen.Wait(5000)
        DeleteEntity(O)
        TaskPlayAnim(i, "mp_safehousebeer@", "exit", 8.0, 1.0, -1, 49, 0, false, false, false)
        Citizen.Wait(500)
        local P = math.random(1, 20)
        if P == 1 then
            DoScreenFadeOut(1000)
            SetEntityHealth(i, 200)
            Citizen.Wait(2000)
            DoScreenFadeIn(1000)
            Citizen.Wait(1000)
            notify("~g~You suddenly feel a lot better.")
        elseif P == 2 then
            TriggerEvent("CORRUPT:cocaineEffect")
            notify("~r~That wasn't sugar...")
        elseif P == 3 then
            TriggerEvent("CORRUPT:heroinEffect")
            notify("~r~What liquid was that?")
        elseif P == 4 then
            TriggerEvent("CORRUPT:doAcid")
            notify("~r~...")
        elseif P == 5 then
            g(true)
        elseif P == 6 then
            notify("~y~You witness a flash of light.")
            ForceLightningFlash()
            SetTimecycleModifier("glasses_purple")
            Citizen.Wait(1000)
            n()
        elseif P == 7 then
            CORRUPT.hideUI()
            g(false)
            k()
            CORRUPT.showUI()
        elseif P == 8 then
            g(false)
            I()
            notify("~r~Okay...")
        elseif P == 9 then
            notify("~g~Tastes sweet.")
        elseif P == 10 then
            notify("~g~Tastes like dark chocolate.")
        elseif P == 11 then
            notify("~y~You notice rocks on the ground whilst eating.")
        elseif P == 12 then
            g(true)
            notify("~r~You start coughing up blood...")
            while not IsEntityDead(i) and GetEntityHealth(i) > 102 do
                SetEntityHealth(i, GetEntityHealth(i) - 1)
                Citizen.Wait(200)
            end
        elseif P == 13 then
            CORRUPT.hideUI()
            C()
            CORRUPT.showUI()
        elseif P == 14 then
            tvRP.setCanAnim(false)
            CORRUPT.loadAnimDict("misscarsteal2peeing")
            TaskPlayAnim(i, "misscarsteal2peeing", "peeing_loop", 8.0, 1.0, -1, 49, 0, false, false, false)
            RemoveAnimDict("misscarsteal2peeing")
            CORRUPT.loadPtfx("scr_amb_chop")
            UseParticleFxAsset("scr_amb_chop")
            local Q =
                StartNetworkedParticleFxLoopedOnEntityBone(
                "ent_anim_dog_peeing",
                i,
                -0.05,
                0.3,
                0.0,
                0.0,
                90.0,
                90.0,
                GetEntityBoneIndexByName("ent_anim_dog_peeing", "VFX"),
                1065353216,
                0,
                0,
                0
            )
            Citizen.Wait(10000)
            StopParticleFxLooped(Q, false)
            tvRP.setCanAnim(true)
        elseif P == 15 then
            notify("~g~You notice you're standing on a £5 note.")
            G()
        elseif P == 16 then
            SetTimecycleModifier("hud_def_Trevor")
            notify("~g~You feel a sudden burst of energy.")
            local j = GetGameTimer()
            while GetGameTimer() - j < 20000 do
                SetRunSprintMultiplierForPlayer(PlayerId(), 1.40)
                Citizen.Wait(0)
            end
            SetRunSprintMultiplierForPlayer(PlayerId(), 1.0)
            n()
        elseif P == 17 then
            notify("~y~That didn't taste of anything.")
        elseif P == 18 then
            notify("~r~**chokes**")
            SetPedToRagdoll(i, 1000, 1000, 0, false, false, false)
        elseif P == 19 then
            CORRUPT.hideUI()
            notify("~g~A stray cat brings you a thrown away burger.")
            q("a_c_cat_01", "prop_food_cb_burg02")
            CORRUPT.showUI()
        elseif P == 20 then
            CORRUPT.hideUI()
            notify("~g~A stray dog brings you a ball.")
            q("a_c_retriever", "prop_tennis_ball")
            CORRUPT.showUI()
        end
    end
)
