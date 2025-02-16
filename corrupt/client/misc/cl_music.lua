local a = {
    active = false,
    spawnedDecks = false,
    coords = vector3(0, 0, 0),
    handles = {},
    dui = nil,
    isStatic = false,
    isVehicle = false,
    vehicleNetId = -1,
    currentStaticId = nil
}
local b = {volume = 1, volumeWhole = 10}
local c = {}
local d = {}
local e = nil
local f = nil
local g = 0
local h = nil
local i = {}
local j = {
    {coords = vector3(1551.7019042969, 249.96797180176, -48.203105926514), heading = 256.84},
    {coords = vector3(375.33557128906, 275.97552490234, 92.399833679199), heading = 256.84},
    {coords = vector3(4893.5034179688, -4905.390625, 3.4866433143616), heading = 178.2}
}
RMenu.Add(
    "corruptmusic",
    "main",
    RageUI.CreateMenu(
        "",
        "~b~DJ Mixer",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_musicui",
        "corrupt_musicui"
    )
)
RMenu.Add(
    "corruptmusic",
    "admin",
    RageUI.CreateSubMenu(
        RMenu:Get("corruptmusic", "main"),
        "DJ Admin",
        "~b~DJ Admin Menu",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight()
    )
)
TriggerEvent("chat:addSuggestion", "/play", "Play a song on the DJ Mixer", {{name = "URL", help = "Video ID"}})
TriggerEvent("chat:addSuggestion", "/djmenu", "Toggle the DJ Mixer")
TriggerEvent("chat:addSuggestion", "/djadmin", "Administrate the use of the DJ Mixer")
local function k(l, m)
    local n = {type = l, payload = m}
    if a.duiObj then
        SendDuiMessage(a.duiObj, json.encode(n))
    end
end
local function o(p, q, r, s, t)
    CORRUPT.loadModel(s)
    local u = GetOffsetFromEntityInWorldCoords(CORRUPT.getPlayerPed(), p, q, r)
    local v = CreateObject(s, u.x, u.y, u.z, true, true, true)
    SetModelAsNoLongerNeeded(s)
    table.insert(a.handles, v)
    PlaceObjectOnGroundProperly(v)
    FreezeEntityPosition(v, true)
    local w = GetEntityHeading(CORRUPT.getPlayerPed())
    SetEntityHeading(v, w + t)
end
local function x(y, z)
    a.active = true
    a.coords = CORRUPT.getPlayerCoords()
    a.spawnedDecks = true
    a.isVehicle = z
    if z then
        a.vehicleNetId = NetworkGetNetworkIdFromEntity(CORRUPT.getPlayerVehicle())
    end
    if not y and not z then
        o(0.0, 1.5, 0.0, "ba_prop_battle_dj_stand", 0.0)
        o(-1.5, 1.5, 0.0, "ba_prop_battle_club_speaker_large", 180.0)
        o(1.5, 1.5, 0.0, "ba_prop_battle_club_speaker_large", 180.0)
        o(0.0, -1.2, 0.0, "prop_studio_light_01", 180.0)
    end
end
local function A(B)
    local C, D = CORRUPT.getPlayerVehicle()
    return C ~= 0 and D and DecorGetBool(C, "subwoofer") and
        (not B or NetworkGetNetworkIdFromEntity(C) == a.vehicleNetId)
end
local function E()
    local F = false
    for G, H in pairs(c) do
        if H.coords == a.coords then
            F = true
        end
    end
    if A(true) then
        return true
    end
    return F
end
local function I()
    if E() then
        TriggerServerEvent("CORRUPT:stopSongServer", a.coords, a.isVehicle, a.vehicleNetId)
    end
    a.active = false
    a.spawnedDecks = false
    for G, J in pairs(a.handles) do
        if NetworkGetEntityIsNetworked(J) then
            local K = NetworkGetNetworkIdFromEntity(J)
            if K > 0 then
                TriggerServerEvent("CORRUPT:djDeleteObject", J)
            end
        else
            DeleteObject(J)
        end
    end
    if a.isStatic then
        a.isStatic = false
        TriggerServerEvent("CORRUPT:setStaticDjMenuNotInUse", a.currentStaticId)
        FreezeEntityPosition(CORRUPT.getPlayerPed(), false)
        CORRUPT.cancelEmote(true)
        tvRP.setCanAnim(true)
        TriggerEvent("CORRUPT:toggleDjMenu", false)
    end
    a.isVehicle = false
    a.vehicleNetId = -1
    a.handles = {}
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("corruptmusic", "main"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("corruptmusic", "main"),
            true,
            false,
            true,
            function()
                if inOrganHeist then
                    return
                elseif not a.active then
                    RageUI.Button(
                        "Start Session",
                        "Start a new DJ Session",
                        {},
                        function(L, M, N)
                            if N then
                                if tvRP.getPlayerCombatTimer() == 0 and not CORRUPT.isPlayerInRedZone() then
                                    if CORRUPT.getPlayerVehicle() ~= 0 then
                                        if A(false) then
                                            x(false, true)
                                        else
                                            notify("~r~This vehicle does not have a subwoofer.")
                                        end
                                    else
                                        x(false, false)
                                    end
                                else
                                    notify("~r~You can not set up a DJ deck right now.")
                                end
                            end
                        end,
                        nil
                    )
                else
                    if not a.isVehicle or A(true) then
                        RageUI.Button(
                            "Play Song",
                            "Youtube Video ID",
                            true,
                            function(L, M, N)
                                if N then
                                    TriggerServerEvent("CORRUPT:promptPlaySong")
                                end
                            end
                        )
                        RageUI.SliderProgress(
                            "Song Volume",
                            b.volumeWhole,
                            10,
                            "Select or update the song volume",
                            {
                                ProgressBackgroundColor = {R = 0, G = 0, B = 0, A = 255},
                                ProgressColor = {R = 0, G = 117, B = 194, A = 255}
                            },
                            true,
                            function(L, N, M, O)
                                if N then
                                    if O ~= b.volumeWhole then
                                        b.volumeWhole = O
                                        b.volume = O / 10
                                        if E() then
                                            TriggerServerEvent(
                                                "CORRUPT:updateVolumeServer",
                                                a.coords,
                                                b.volume,
                                                a.isVehicle,
                                                a.vehicleNetId
                                            )
                                        end
                                        drawNativeText("~b~DJ~w~: Volume Updated")
                                    end
                                end
                            end
                        )
                        RageUI.Button(
                            "Stop Song",
                            "Stop the current song",
                            {},
                            function(L, M, N)
                                if N then
                                    if E() then
                                        TriggerServerEvent("CORRUPT:stopSongServer", a.coords, a.isVehicle)
                                    end
                                    drawNativeText("~b~DJ~w~: Song Stopped")
                                end
                            end,
                            nil
                        )
                        RageUI.Button(
                            "End Session",
                            "Stop the current DJ Session",
                            {},
                            function(L, M, N)
                                if N then
                                    I()
                                    drawNativeText("~b~DJ~w~: Session Ended")
                                end
                            end,
                            nil
                        )
                    else
                        RageUI.Separator("~r~No connection to vehicle subwoofer")
                        if a.vehicleNetId > 0 and not NetworkDoesNetworkIdExist(a.vehicleNetId) then
                            TriggerServerEvent("CORRUPT:adminStopVehicleSong", a.vehicleNetId)
                            a.vehicleNetId = -1
                            I()
                        end
                    end
                    RageUI.Button(
                        "Help",
                        "Assistance message",
                        {},
                        function(L, M, N)
                            if N then
                                TriggerEvent(
                                    "CORRUPT:showNotification",
                                    {
                                        text = "The Video ID is the ID at the end of the YouTube URL after =",
                                        height = "200px",
                                        width = "auto",
                                        colour = "#FFF",
                                        background = "#32CD32",
                                        pos = "bottom-right",
                                        icon = "success"
                                    },
                                    5000
                                )
                            end
                        end,
                        nil
                    )
                end
            end,
            function()
            end
        )
        RageUI.IsVisible(
            RMenu:Get("corruptmusic", "admin"),
            true,
            false,
            true,
            function()
                if table.count(i) > 0 then
                    for P, Q in pairs(i) do
                        if i[P] ~= nil then
                            RageUI.Button(
                                "ID: " .. Q[3] .. " - Started: " .. Q[5],
                                "Name: " ..
                                    Q[4] .. " Distance Away: " .. round(#(CORRUPT.getPlayerCoords() - Q[2]), 2) .. " metres",
                                {},
                                function(L, M, N)
                                    if N then
                                        TriggerServerEvent("CORRUPT:adminStopSong", Q[1])
                                        i[P] = nil
                                    end
                                end,
                                nil
                            )
                        end
                    end
                end
                for C, H in pairs(d) do
                    RageUI.Button(
                        "Vehicle Subwoofer",
                        "Name: " ..
                            H.djName ..
                                " Distance Away: " ..
                                    round(#(CORRUPT.getPlayerCoords() - GetEntityCoords(C, true)), 2) .. " metres",
                        {},
                        function(L, M, N)
                            if N then
                                local R = NetworkGetNetworkIdFromEntity(C)
                                if R > 0 then
                                    TriggerServerEvent("CORRUPT:adminStopVehicleSong", R)
                                end
                            end
                        end,
                        nil
                    )
                end
            end,
            function()
            end
        )
    end
)
RegisterNetEvent("CORRUPT:playDjSong",function(S, T, U, V)
    for W, H in pairs(c) do
        if H.coords == T then
            c[W] = nil
        end
    end
    c[U] = {coords = T, id = S, isPlaying = true, djName = V, startTime = GetGameTimer(), volume = 1.0}
end)

RegisterNetEvent("CORRUPT:toggleDjMenu",function()
    RageUI.Visible(RMenu:Get("corruptmusic", "main"), not RageUI.Visible(RMenu:Get("corruptmusic", "main")))
end)

RegisterNetEvent("CORRUPT:toggleDjAdminMenu",function(X)
    RageUI.Visible(RMenu:Get("corruptmusic", "admin"), true)
    i = X
end)

RegisterNetEvent("CORRUPT:finaliseSong",function(Y)
    if a.active then
        TriggerServerEvent("CORRUPT:playDjSongServer", Y, a.coords, a.isVehicle, a.vehicleNetId)
    end
end)

RegisterNetEvent("CORRUPT:updateDjVolume",function(T, Z)
    for G, H in pairs(c) do
        if H.coords == T then
            H.volume = Z
        end
    end
end)

RegisterNetEvent("CORRUPT:stopSong",function(T)
    for U, H in pairs(c) do
        if H.coords == T then
            c[U] = nil
        end
    end
end)

Citizen.CreateThread(
    function()
        a.duiObj = CreateDui("https://arthur-fivem-hypnonema.pages.dev/", 1280, 720)
        a.dui = GetDuiHandle(a.duiObj)
        k(
            "init",
            {
                payload = {
                    resourceName = GetCurrentResourceName(),
                    posterUrl = "https://cdn.discordapp.com/attachments/856971689891856394/1002189147160727632/unknown.png"
                }
            }
        )
        local _ = {
            "se_h4_dlc_int_02_h4_lobby",
            "se_h4_dlc_int_02_h4_main_bar",
            "se_h4_dlc_int_02_h4_main_front_02",
            "se_h4_dlc_int_02_h4_main_front_01",
            "se_h4_dlc_int_02_h4_bogs",
            "se_h4_dlc_int_02_h4_entrance_doorway",
            "se_h4_dlc_int_02_h4_main_room_cutscenes"
        }
        for G, a0 in pairs(_) do
            SetStaticEmitterEnabled(a0, false)
        end
        DecorRegister("subwoofer", 2)
    end
)
local function a1(a2)
    local a3 = nil
    local a4 = nil
    local a5 = 35.0
    for U, H in pairs(c) do
        local a6 = #(H.coords - a2.playerCoords)
        if a6 < a5 then
            a3 = U
            a4 = H.coords
            a5 = a6
        end
    end
    for C in pairs(d) do
        if DoesEntityExist(C) then
            local a7 = GetEntityCoords(C, true)
            local a6 = #(a7 - a2.playerCoords)
            if a6 < a5 then
                a3 = C
                a4 = a7
                a5 = a6
            end
        else
            d[C] = nil
        end
    end
    if a3 then
        local H = c[a3] or d[a3]
        if a3 ~= e or H.id ~= f then
            local a8 = c[e]
            if a8 then
                a8.isPlaying = false
            end
            if c[a3] then
                k(
                    "synchronizeState",
                    {
                        payload = {
                            url = "https://youtube.com/watch?v=" .. H.id,
                            paused = false,
                            currentTime = (GetGameTimer() - H.startTime) / 1000,
                            ["repeat"] = false
                        }
                    }
                )
            elseif d[a3] then
                local R = NetworkGetNetworkIdFromEntity(a3)
                if R ~= 0 then
                    TriggerServerEvent("CORRUPT:requestVehicleStartTime", R)
                end
            end
            drawNativeText("~b~DJ " .. H.djName .. "~w~: New Song playing")
            e = a3
            f = H.id
            H.isPlaying = true
        end
        local Z = (35.0 - #(a2.playerCoords - a4)) / 35.0
        if Z < 0.0 then
            Z = 0.0
        elseif H.volume <= 1.0 then
            Z = Z * H.volume
        end
        k("volume", {payload = Z})
    elseif e then
        local a8 = c[e]
        if a8 then
            a8.isPlaying = false
        end
        k("stop", {})
        e = nil
        f = nil
    end
end
CORRUPT.createThreadOnTick(a1)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(a9, aa)
        if aa then
            for ab, ac in pairs(j) do
                local function ad()
                    if not GlobalState["djmenuinuse_" .. ab] then
                        drawNativeNotification("Press ~INPUT_CONTEXT~ to open the DJ Menu!")
                    else
                        drawNativeNotification("This DJ Station is in use.")
                    end
                end
                local function ae()
                end
                local function af()
                    if not GlobalState["djmenuinuse_" .. ab] then
                        drawNativeNotification("Press ~INPUT_CONTEXT~ to open the DJ Menu!")
                    elseif not a.isStatic then
                        drawNativeNotification("This DJ Station is in use.")
                    end
                    if IsControlJustPressed(1, 51) and not GlobalState["djmenuinuse_" .. ab] then
                        x(true, false)
                        local ag = CORRUPT.getPlayerPed()
                        TriggerEvent("CORRUPT:toggleDjMenu")
                        TriggerServerEvent("CORRUPT:setStaticDjMenuInUse", ab)
                        SetEntityCoords(ag, ac.coords)
                        SetEntityHeading(ag, ac.heading)
                        Wait(500)
                        FreezeEntityPosition(ag, true)
                        CORRUPT.playEmote("dj")
                        tvRP.setCanAnim(false)
                        a.isStatic = true
                        a.currentStaticId = ab
                    end
                end
                CORRUPT.createArea("dj" .. ab, ac.coords, 2.5, 6.0, ad, ae, af)
            end
        end
    end
)
function setVehicleIdSubwoofer(C, ah)
    if ah["1"] == true then
        DecorSetBool(C, "subwoofer", true)
    end
end
AddStateBagChangeHandler(
    "subwoofer",
    nil,
    function(ai, G, aj)
        local R = tonumber(stringsplit(ai, ":")[2])
        local ak = 0
        while true do
            if ak > 25 then
                return
            elseif NetworkDoesEntityExistWithNetworkId(R) then
                local C = NetworkGetEntityFromNetworkId(R)
                if C ~= 0 then
                    if aj then
                        d[C] = {id = aj.id, djName = aj.name, startTime = GetGameTimer(), volume = aj.volume}
                    else
                        d[C] = nil
                    end
                    break
                end
            end
            ak = ak + 1
            Citizen.Wait(200)
        end
    end
)

RegisterNetEvent(
    "CORRUPT:setVehicleStartTime",
    function(al, R, song)
        if NetworkDoesEntityExistWithNetworkId(R) then
            local C = NetworkGetEntityFromNetworkId(R)
            if C ~= 0 and e == C then
                k(
                    "synchronizeState",
                    {
                        payload = {
                            url = "https://youtube.com/watch?v=" .. song,
                            paused = false,
                            currentTime = (GetNetworkTimeAccurate() - al) / 1000,
                            ["repeat"] = false
                        }
                    }
                )
            end
        end
    end
)
AddEventHandler(
    "hypnonema:updateStateDuration",
    function(ah)
        if GetGameTimer() - g < 5000 and a.active and h then
            TriggerServerEvent("CORRUPT:setMusicDuration", h, math.floor(ah.duration))
            h = nil
        end
    end
)
RegisterNetEvent(
    "CORRUPT:requestMusicDuration",
    function(U)
        g = GetGameTimer()
        h = U
    end
)


RegisterNetEvent("CORRUPT:djDeleteObject", function(entity)
    DeleteEntity(entity)
end)