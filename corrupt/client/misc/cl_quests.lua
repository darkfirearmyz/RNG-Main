local a = module("cfg/cfg_quests")
local b = {}
local c = nil
local function d()
    CORRUPT.loadAnimDict("anim@mp_player_intcelebrationfemale@air_guitar")
    TaskPlayAnim(
        PlayerPedId(),
        "anim@mp_player_intcelebrationfemale@air_guitar",
        "air_guitar",
        8.0,
        -8.0,
        -1,
        0,
        0.0,
        false,
        false,
        false
    )
end
local function e(f, g, h)
    local i = RequestScaleformMovie("mp_big_message_freemode")
    while not HasScaleformMovieLoaded(i) do
        Wait(0)
    end
    Citizen.CreateThread(
        function()
            local j = 0
            while j < h do
                Wait(0)
                BeginScaleformMovieMethod(i, "SHOW_SHARD_WASTED_MP_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString(f)
                ScaleformMovieMethodAddParamTextureNameString(g)
                ScaleformMovieMethodAddParamInt(5)
                EndScaleformMovieMethod()
                DrawScaleformMovieFullscreen(i, 255, 255, 255, 255, 0)
                j = j + 1
            end
            SetScaleformMovieAsNoLongerNeeded(i)
        end
    )
end
local function k(l, m, n, o)
    local p = l .. "_" .. tostring(m)
    local q = n.pos
    local r = function()
        if not b[p] then
            if not DoesEntityExist(b[p]) then
                CORRUPT.loadModel(n.model)
                local s = CreateObject(n.model, q.x, q.y, q.z, false, true, false)
                SetModelAsNoLongerNeeded(n.model)
                FreezeEntityPosition(s, true)
                SetEntityAlpha(s, 210, 0)
                SetEntityCollision(s, false, false)
                b[p] = s
            end
        end
    end
    local t = function()
        DeleteObject(b[p])
        b[p] = nil
    end
    local u = function()
        if o == "green" then
            DrawLightWithRangeAndShadow(q.x, q.y, q.z, 52, 235, 55, 30.0, 0.5, 1.0)
        elseif o == "orange" then
            DrawLightWithRangeAndShadow(q.x, q.y, q.z, 230, 115, 0, 30.0, 0.5, 1.0)
        elseif o == "red" then
            DrawLightWithRangeAndShadow(q.x, q.y, q.z, 230, 0, 0, 30.0, 0.5, 1.0)
        end
    end
    CORRUPT.createArea("quests_prop_" .. p, q, 100.0, 6, r, t, u)
    local v = function()
        CORRUPT.drawFloatingHelpText("Press [E] to collect.", vector3(q.x, q.y, q.z + 0.2))
        if IsControlJustPressed(0, 38) then
            if l == "CHRISTMAS" then
                SendNUIMessage({transactionType = "christmas_quest"})
            end
            DeleteEntity(b[p])
            TriggerServerEvent("CORRUPT:setQuestCompleted", l, m)
            d()
        end
    end
    CORRUPT.createArea(
        "quests_text_" .. p,
        q,
        2.0,
        6,
        function()
        end,
        function()
        end,
        v
    )
end
local function w(x)
    if x.startDate then
        local y, z = table.unpack(x.startDate)
        if c.month < z then
            return false
        elseif c.month == z and c.day < y then
            return false
        end
    end
    if x.endDate then
        local y, z = table.unpack(x.endDate)
        if c.month > z then
            return false
        elseif c.month == z and c.day >= y then
            return false
        end
    end
    return true
end
RegisterNetEvent(
    "CORRUPT:questSendCompletedPositions",
    function(A, B)
        c = B
        for l, x in pairs(a.quests) do
            if w(x) then
                for m, n in pairs(x.locations) do
                    if not A[l] or not table.has(A[l], m) then
                        k(l, m, n, x.lightColour)
                    end
                end
            end
        end
    end
)
local function C(l, m)
    local p = l .. "_" .. tostring(m)
    tvRP.removeArea("quests_prop_" .. p)
    tvRP.removeArea("quests_text_" .. p)
end
RegisterNetEvent(
    "CORRUPT:questCollected",
    function(D, l, m, E)
        C(l, m)
        if D then
            e("~g~+14 Days CORRUPT Club Platinum", "You collected them all!", 600)
            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
            AnimpostfxPlay("DMT_flight", 0, false)
            Wait(4000)
            DoScreenFadeOut(1000)
            Wait(1000)
            AnimpostfxStop("DMT_flight")
            StopGameplayCamShaking(true)
            DoScreenFadeIn(2000)
        else
            e(
                "Collected ~y~" .. tostring(E) .. "/" .. tostring(table.count(a.quests[l].locations)),
                "Collect them all to win a prize!",
                600
            )
            PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
            ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
            AnimpostfxPlay("SuccessMichael", 0, false)
            Wait(4000)
            DoScreenFadeOut(1000)
            Wait(1000)
            AnimpostfxStop("SuccessMichael")
            StopGameplayCamShaking(true)
            DoScreenFadeIn(2000)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:halloweenQuestCompleted",
    function(l, m)
        C(l, m)
        e("~g~All Sweets Collected", "You collected them all!", 600)
        PlaySoundFrontend(-1, "Hack_Success", "DLC_HEIST_BIOLAB_PREP_HACKING_SOUNDS", true)
        ShakeGameplayCam("FAMILY5_DRUG_TRIP_SHAKE", 1.0)
        AnimpostfxPlay("DMT_flight", 0, false)
        Wait(4000)
        DoScreenFadeOut(1000)
        Wait(1000)
        AnimpostfxStop("DMT_flight")
        StopGameplayCamShaking(true)
        DoScreenFadeIn(2000)
    end
)
Citizen.CreateThread(
    function()
        while true do
            for F, s in pairs(b) do
                if DoesEntityExist(s) then
                    SetEntityHeading(s, GetEntityHeading(s) + 1 % 360)
                end
            end
            Citizen.Wait(0)
        end
    end
)
AddEventHandler(
    "onResourceStop",
    function(G)
        if G == GetCurrentResourceName() then
            for F, H in pairs(b) do
                DeleteObject(H)
            end
        end
    end
)
