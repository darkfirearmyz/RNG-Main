local a = {
    ["ESC"] = 322,
    ["F1"] = 288,
    ["F2"] = 289,
    ["F3"] = 170,
    ["F5"] = 166,
    ["F6"] = 167,
    ["F7"] = 168,
    ["F8"] = 169,
    ["F9"] = 56,
    ["F10"] = 57,
    ["~"] = 243,
    ["1"] = 157,
    ["2"] = 158,
    ["3"] = 160,
    ["4"] = 164,
    ["5"] = 165,
    ["6"] = 159,
    ["7"] = 161,
    ["8"] = 162,
    ["9"] = 163,
    ["-"] = 84,
    ["="] = 83,
    ["BACKSPACE"] = 177,
    ["TAB"] = 37,
    ["Q"] = 44,
    ["W"] = 32,
    ["E"] = 38,
    ["R"] = 45,
    ["T"] = 245,
    ["Y"] = 246,
    ["U"] = 303,
    ["P"] = 199,
    ["["] = 39,
    ["]"] = 40,
    ["ENTER"] = 18,
    ["CAPS"] = 137,
    ["A"] = 34,
    ["S"] = 8,
    ["D"] = 9,
    ["F"] = 23,
    ["G"] = 47,
    ["H"] = 74,
    ["K"] = 311,
    ["L"] = 182,
    ["LEFTSHIFT"] = 21,
    ["Z"] = 20,
    ["X"] = 73,
    ["C"] = 26,
    ["V"] = 0,
    ["B"] = 29,
    ["N"] = 249,
    ["M"] = 244,
    [","] = 82,
    ["."] = 81,
    ["LEFTCTRL"] = 36,
    ["LEFTALT"] = 19,
    ["SPACE"] = 22,
    ["RIGHTCTRL"] = 70,
    ["HOME"] = 213,
    ["PAGEUP"] = 10,
    ["PAGEDOWN"] = 11,
    ["DELETE"] = 178,
    ["LEFT"] = 174,
    ["RIGHT"] = 175,
    ["TOP"] = 27,
    ["DOWN"] = 173,
    ["NENTER"] = 201,
    ["N4"] = 108,
    ["N5"] = 60,
    ["N6"] = 107,
    ["N+"] = 96,
    ["N-"] = 97,
    ["N7"] = 117,
    ["N8"] = 61,
    ["N9"] = 118
}
local b = false
local c = false
local d = "missmic2ig_11"
local e = "mic_2_ig_11_intro_goon"
local f = "mic_2_ig_11_intro_p_one"
local g = 0
local h = false
RegisterNetEvent(
    "CORRUPT:setPoliceOnDuty",
    function(i)
        globalOnPoliceDuty = i
    end
)
RegisterNetEvent(
    "CORRUPT:getTackled",
    function(j)
        if tvRP.isStaffedOn() then
            return
        end
        c = true
        TriggerEvent("CORRUPT:startCombatTimer", false)
        local k = CORRUPT.getPlayerPed()
        local l = GetPlayerPed(GetPlayerFromServerId(j))
        RequestAnimDict(d)
        while not HasAnimDictLoaded(d) do
            Citizen.Wait(10)
        end
        AttachEntityToEntity(
            CORRUPT.getPlayerPed(),
            l,
            11816,
            0.25,
            0.5,
            0.0,
            0.5,
            0.5,
            180.0,
            false,
            false,
            false,
            false,
            2,
            false
        )
        TaskPlayAnim(k, d, f, 8.0, -8.0, 3000, 0, 0, false, false, false)
        RemoveAnimDict(d)
        Citizen.Wait(3000)
        DetachEntity(CORRUPT.getPlayerPed(), true, false)
        h = true
        Citizen.Wait(3000)
        h = false
        c = false
    end
)
function CORRUPT.isPedBeingTackled()
    return h
end
RegisterNetEvent(
    "CORRUPT:playTackle",
    function()
        local k = CORRUPT.getPlayerPed()
        RequestAnimDict(d)
        while not HasAnimDictLoaded(d) do
            Citizen.Wait(10)
        end
        TaskPlayAnim(k, d, e, 8.0, -8.0, 3000, 0, 0, false, false, false)
        RemoveAnimDict(d)
        Citizen.Wait(3000)
        b = false
    end
)
local function m()
    local n = 3.0
    local o = nil
    for p, q in ipairs(GetActivePlayers()) do
        if q ~= PlayerId() then
            local r = GetPlayerServerId(q)
            local s = CORRUPT.clientGetUserIdFromSource(r)
            local t = CORRUPT.getJobType(s)
            if t ~= "metpd" and t ~= "hmp" and t ~= "npas" then
                local u = GetEntityCoords(GetPlayerPed(q), true)
                local v = #(u - CORRUPT.getPlayerCoords())
                if v < n then
                    n = v
                    o = r
                end
            end
        end
    end
    return o
end
local function w()
    if globalOnCasinoDuty then
        return IsEntityInArea(
            PlayerPedId(),
            820.3699,
            -95.55496,
            69.97881,
            1009.161,
            88.39021,
            125.1955,
            false,
            false,
            0
        ) or CORRUPT.getPlayerBucket() == 777
    else
        return false
    end
end
function func_tackleManagement()
    if h then
        SetPedToRagdoll(CORRUPT.getPlayerPed(), 1000, 1000, 0, 0, 0, 0)
    end
    if globalOnPoliceDuty or w() or tvRP.isStaffedOn() or globalOnPrisonDuty and globalPlayerInPrisonZone then
        if IsControlPressed(0, a["LEFTSHIFT"]) and IsControlPressed(0, a["G"]) then
            if
                not b and GetGameTimer() - g > 10 * 1000 and GetEntityHealth(PlayerPedId()) > 102 and
                    not CORRUPT.isKnockedOut()
             then
                local x = m()
                if x then
                    if
                        not b and not c and not IsPedInAnyVehicle(CORRUPT.getPlayerPed()) and
                            not IsPedInAnyVehicle(GetPlayerPed(x))
                     then
                        b = true
                        g = GetGameTimer()
                        TriggerServerEvent("CORRUPT:tryTackle", x)
                    end
                end
            end
        end
    end
end
CORRUPT.createThreadOnTick(func_tackleManagement)
