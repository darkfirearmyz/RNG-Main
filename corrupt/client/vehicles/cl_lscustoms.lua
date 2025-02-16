local a = module("cfg/cfg_lscustoms")
RMenu.Add(
    "lscustoms",
    "repair",
    RageUI.CreateMenu(
        "",
        "Repair Vehicle",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_lscustomsui",
        "corrupt_lscustomsui"
    )
)
RMenu.Add(
    "lscustoms",
    "mainmenu",
    RageUI.CreateMenu(
        "",
        "Los Santos Customs",
        CORRUPT.getRageUIMenuWidth(),
        CORRUPT.getRageUIMenuHeight(),
        "corrupt_lscustomsui",
        "corrupt_lscustomsui"
    )
)
local b = {}
local function c(d)
    local e = table.concat(b, "_")
    table.insert(b, string.lower(string.gsub(d.name, "%s+", "")))
    d.menu = table.concat(b, "_")
    if d.name ~= "Main Menu" then
        RMenu.Add(
            "lscustoms",
            d.menu,
            RageUI.CreateSubMenu(
                RMenu:Get("lscustoms", e),
                "",
                d.name,
                CORRUPT.getRageUIMenuWidth(),
                CORRUPT.getRageUIMenuHeight()
            )
        )
    end
    if d.type == "categoryList" then
        for f, g in pairs(d.categories) do
            c(g)
        end
    else
        RMenu:Get("lscustoms", d.menu):AddInstructionButton({"~INPUT_NEXT_CAMERA~", "Change Camera"})
    end
    table.remove(b)
end
c(a.category)
local h = nil
local i = nil
local j = 0
local k = nil
local l = 0
local m = 0
local n = 0
local o = -1
local p = false
local q = {["livery"] = function()
        local r = {}
        for s = 1, GetVehicleLiveryCount(j) do
            table.insert(r, s)
        end
        return r
    end}
local function t(u, v)
    SetCamActive(m, true)
    local w = GetModelDimensions(GetEntityModel(j))
    local x = w.y * -2.0
    local y = w.x * -2.0
    local z = w.z * -2.0
    local A
    if u == "front" then
        A = GetOffsetFromEntityInWorldCoords(j, v.x, x / 2.0 + v.y, v.z)
    elseif u == "front-top" then
        A = GetOffsetFromEntityInWorldCoords(j, v.x, x / 2.0 + v.y, z + v.z)
    elseif u == "back" then
        A = GetOffsetFromEntityInWorldCoords(j, v.x, -(x / 2.0) + v.y, v.z)
    elseif u == "back-top" then
        A = GetOffsetFromEntityInWorldCoords(j, v.x, -(x / 2.0) + v.y, z / 2.0 + v.z)
    elseif u == "left" then
        A = GetOffsetFromEntityInWorldCoords(j, -(y / 2.0) + v.x, v.y, v.z)
    elseif u == "right" then
        A = GetOffsetFromEntityInWorldCoords(j, y / 2.0 + v.x, v.y, v.z)
    elseif u == "middle" then
        A = GetOffsetFromEntityInWorldCoords(j, v.x, v.y, z / 2.0 + v.z)
    end
    SetCamCoord(m, A.x, A.y, A.z)
    local B = GetOffsetFromEntityInWorldCoords(j, 0.0, 0.0, 0.0)
    PointCamAtCoord(m, B.x, B.y, B.z)
    RenderScriptCams(true, true, 1000, false, false)
end
local function C(D, E)
    local F = GetEntityBoneIndexByName(j, D)
    if F == -1 then
        return
    end
    local G = GetWorldPositionOfEntityBone(j, F)
    local v = GetOffsetFromEntityGivenWorldCoords(j, G.x, G.y, G.z)
    local u = GetOffsetFromEntityInWorldCoords(j, v.x + E.x, v.y + E.y, v.z + E.z)
    SetCamActive(m, true)
    SetCamCoord(m, u.x, u.y, u.z)
    local H = GetOffsetFromEntityInWorldCoords(j, 0.0, v.y, v.z)
    PointCamAtCoord(m, H.x, H.y, H.z)
    RenderScriptCams(true, true, 1000, false, false)
end
local function I(d)
    if m == 0 then
        return
    end
    local J = d.cameraPreset
    if not J then
        return
    end
    local K = a.cameraPresets[J]
    assert(K, string.format("Camera preset %s does not exist", J))
    if K.type == "moveVeh" then
        t(K.position, K.offset)
    elseif K.type == "pointBone" then
        C(K.bone, K.offset)
    elseif K.type == "doors" then
        for f, L in pairs(K.doors) do
            SetVehicleDoorOpen(j, L, false, false)
        end
    elseif K.type == "viewMode" then
        SetFollowVehicleCamViewMode(K.mode)
    end
end
local function M()
    if m == 0 then
        return
    end
    local N = GetFinalRenderedCamCoord()
    SetCamCoord(m, N.x, N.y, N.z)
    local O = GetGameplayCamRot(2)
    SetCamRot(m, O.x, O.y, O.z, 2)
    RenderScriptCams(true, true, 0, false, false)
    RenderScriptCams(false, true, 1000, false, false)
    SetCamActive(n, true)
    TogglePausedRenderphases(true)
    SetCamActive(m, false)
end
local function P(d)
    local J = d.cameraPreset
    if not J then
        return
    end
    local K = a.cameraPresets[J]
    assert(K, string.format("Camera preset %s does not exist", J))
    if K.type == "moveVeh" then
        M()
    elseif K.type == "pointBone" then
        M()
    elseif K.type == "doors" then
        for L = 0, GetNumberOfVehicleDoors(j) do
            SetVehicleDoorOpen(j, L, false, false)
        end
    elseif K.type == "viewMode" then
        SetFollowVehicleCamViewMode(1)
    end
end
local function Q(R, S)
    for T, U in pairs(R) do
        if U == true then
            S(T)
            return
        end
    end
    S(nil)
end
local function V(W, X, Y)
    if W then
        return {RightBadge = RageUI.BadgeStyle.CarWhite}
    elseif X then
        return {RightBadge = RageUI.BadgeStyle.CarBlack}
    else
        return {RightLabel = "£" .. getMoneyStringFormatted(Y)}
    end
end
local function Z()
    if o ~= -1 then
        return
    end
    o = GetSoundId()
    PlaySoundFromEntity(o, "Drill", PlayerPedId(), "DLC_HEIST_FLEECA_SOUNDSET", true, 0)
    Citizen.CreateThread(
        function()
            local _ = GetGameTimer()
            while GetGameTimer() - _ < 2000 do
                local a0 = (GetGameTimer() - _) / 2000
                SetVariableOnSound(o, "DrillState", a0)
                Citizen.Wait(0)
            end
            StopSound(o)
            Citizen.Wait(1000)
            ReleaseSoundId(o)
            o = -1
        end
    )
end
local function a1(d, a2)
    if d.modType == 18 or d.modType == 22 then
        ToggleVehicleMod(j, d.modType, true)
    else
        SetVehicleMod(j, d.modType, a2, true)
    end
end
local function a3(d)
    Q(
        h[d.saveKey],
        function(T)
            if T then
                if d.modType == 18 or d.modType == 2 then
                    ToggleVehicleMod(j, d.modType, true)
                else
                    SetVehicleMod(j, d.modType, tonumber(T), false)
                end
            else
                if d.modType == 18 or d.modType == 2 then
                    ToggleVehicleMod(j, d.modType, false)
                else
                    SetVehicleMod(j, d.modType, -1, false)
                end
            end
        end
    )
end
local function a4(d)
    for a5 = -1, GetNumVehicleMods(j, d.modType) - 1 do
        local a6 = "Stock"
        if a5 >= 0 then
            local a7 = GetModTextLabel(j, d.modType, a5)
            local a8 = GetLabelText(a7)
            a6 = a8 ~= "NULL" and a8 or "N/A"
        end
        local a9 = h[d.saveKey][tostring(a5)]
        local Y = a5 >= 0 and d.price or 0
        local aa = V(a9 == true, a9 ~= nil, Y)
        RageUI.ButtonWithStyle(
            a6,
            nil,
            aa,
            true,
            function(ab, ac, ad)
                if ac then
                    a1(d, a5)
                end
                if ad then
                    if a9 == true then
                        notify("~r~You have already applied this mod")
                    elseif a9 == false then
                        TriggerServerEvent("CORRUPT:setActiveModList", l, a.categoryToIndentifier[d], a5)
                        Z()
                    else
                        TriggerServerEvent("CORRUPT:purchaseModList", l, a.categoryToIndentifier[d], a5)
                        Z()
                    end
                end
            end
        )
    end
end
local function ae(d)
    local r = q[d.generatorName]()
    for f, a2 in pairs(r) do
        local a9 = h[d.saveKey][tostring(a2)]
        local aa = V(a9 == true, a9 ~= nil, d.price)
        RageUI.ButtonWithStyle(
            string.format("%s %d", d.prefix, a2),
            nil,
            aa,
            true,
            function(ab, ac, ad)
                if ad then
                    if a9 == true then
                        notify("~r~You have already applied this mod")
                    elseif a9 == false then
                        TriggerServerEvent("CORRUPT:setActiveModList", l, a.categoryToIndentifier[d], a2)
                        Z()
                    else
                        TriggerServerEvent("CORRUPT:purchaseModList", l, a.categoryToIndentifier[d], a2)
                        Z()
                    end
                end
            end
        )
    end
end
local function af(ag, ah)
    for ai = 0, GetNumModColors(ag, false) - 1 do
        SetVehicleModColor_1(j, ag, ai, 0)
        if GetVehicleColours(j) == ah then
            return
        end
    end
    local f, aj = GetVehicleColours(j)
    SetVehicleColours(j, ah, aj)
end
local function ak(ag, ah)
    for ai = 0, GetNumModColors(ag, false) - 1 do
        SetVehicleModColor_2(j, ag, ai)
        local f, aj = GetVehicleColours(j)
        if aj == ah then
            return
        end
    end
    SetVehicleColours(j, GetVehicleColours(j), ah)
end
local function al(d, am)
    local an = d.saveKey
    if an == "windowtint" then
        SetVehicleWindowTint(j, am.tint)
    elseif an == "frontwheel" then
        SetVehicleWheelType(j, 0)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "backwheel" then
        SetVehicleWheelType(j, 0)
        SetVehicleMod(j, 24, am.index, false)
    elseif an == "sportwheels" then
        SetVehicleWheelType(j, 0)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "musclewheels" then
        SetVehicleWheelType(j, 1)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "lowriderwheels" then
        SetVehicleWheelType(j, 2)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "highendwheels" then
        SetVehicleWheelType(j, 7)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "suvwheels" then
        SetVehicleWheelType(j, 3)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "offroadwheels" then
        SetVehicleWheelType(j, 4)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "tunerwheels" then
        SetVehicleWheelType(j, 6)
        SetVehicleMod(j, 23, am.index, false)
    elseif an == "wheelaccessories" then
        SetVehicleModKit(j, 0)
        ToggleVehicleMod(j, 20, true)
        SetVehicleTyreSmokeColor(j, am.colour[1], am.colour[2], am.colour[3])
    elseif an == "chrome" then
        af(5, am.index)
    elseif an == "classic" then
        af(0, am.index)
    elseif an == "matte" then
        af(3, am.index)
    elseif an == "metals" then
        af(4, am.index)
    elseif an == "metallic" then
        af(1, am.index)
    elseif an == "util" then
        local f, aj = GetVehicleColours(j)
        SetVehicleColours(j, am.index, aj)
    elseif an == "chameleon" then
        local f, aj = GetVehicleColours(j)
        SetVehicleColours(j, am.index, aj)
    elseif an == "chrome2" then
        ak(5, am.index)
    elseif an == "classic2" then
        ak(0, am.index)
    elseif an == "matte2" then
        ak(3, am.index)
    elseif an == "metal2" then
        ak(4, am.index)
    elseif an == "metallic2" then
        ak(1, am.index)
    elseif an == "pearlescent" then
        local f, ao = GetVehicleColours(j)
        SetVehicleExtraColours(j, am.index, ao)
    elseif an == "wheelcolor" then
        SetVehicleExtraColours(j, GetVehicleColours(j), am.index)
    elseif an == "interiorcolour" then
        SetVehicleInteriorColor(j, am.index)
    elseif an == "dashboardcolour" then
        SetVehicleDashboardColor(j, am.index)
    elseif an == "mod_14" then
        SetVehicleMod(j, 14, am.index, false)
    elseif an == "mod_15" then
        SetVehicleMod(j, 15, am.index, false)
    elseif an == "mod_22" then
        ToggleVehicleMod(j, 22, am.index > 0)
    elseif an == "xenonlights" then
        ToggleVehicleMod(j, 22, true)
        SetVehicleXenonLightsColor(j, am.index)
    elseif an == "neonlayout" then
        SetVehicleNeonLightEnabled(j, 0, false)
        SetVehicleNeonLightEnabled(j, 1, false)
        SetVehicleNeonLightEnabled(j, 2, false)
        SetVehicleNeonLightEnabled(j, 3, false)
        if am.mod == 1 then
            SetVehicleNeonLightEnabled(j, 0, true)
            SetVehicleNeonLightEnabled(j, 1, true)
            SetVehicleNeonLightEnabled(j, 2, true)
            SetVehicleNeonLightEnabled(j, 3, true)
        elseif am.mod == 2 then
            SetVehicleNeonLightEnabled(j, 2, true)
            SetVehicleNeonLightEnabled(j, 3, true)
        elseif am.mod == 3 then
            SetVehicleNeonLightEnabled(j, 0, true)
            SetVehicleNeonLightEnabled(j, 1, true)
            SetVehicleNeonLightEnabled(j, 2, true)
        elseif am.mod == 4 then
            SetVehicleNeonLightEnabled(j, 0, true)
            SetVehicleNeonLightEnabled(j, 1, true)
            SetVehicleNeonLightEnabled(j, 3, true)
        end
        SetVehicleNeonLightsColour(j, 222, 222, 255)
    elseif an == "neoncolour" then
        SetVehicleNeonLightEnabled(j, 0, true)
        SetVehicleNeonLightEnabled(j, 1, true)
        SetVehicleNeonLightEnabled(j, 2, true)
        SetVehicleNeonLightEnabled(j, 3, true)
        local ap = a.neonColours[am.name]
        SetVehicleNeonLightsColour(j, ap[1], ap[2], ap[3])
    elseif an == "sounds" then
        EnableControlAction(0, 71, true)
        if Entity(j).state.previewSoundId ~= am.soundId then
            ForceVehicleEngineAudio(j, am.soundId)
            SetTimeout(
                500,
                function()
                    SetVehicleRadioEnabled(j, false)
                    SetVehRadioStation(j, "OFF")
                end
            )
            Entity(j).state.previewSoundId = am.soundId
        end
    end
end
local function aq(d)
    local an = d.saveKey
    if
        an == "chrome" or an == "classic" or an == "matte" or an == "metallic" or an == "metals" or an == "util" or
            an == "chameleon"
     then
        applyPrimaryColours(h, j)
    elseif an == "chrome2" or an == "classic2" or an == "matte2" or an == "metallic2" or an == "metal2" then
        applySecondaryColours(h, j)
    elseif an == "windowtint" then
        Q(
            h["windowtint"],
            function(T)
                if T then
                    SetVehicleWindowTint(j, tonumber(T))
                else
                    SetVehicleWindowTint(j, 0)
                end
            end
        )
    elseif an == "frontwheel" then
        Q(
            h["frontwheel"],
            function(T)
                SetVehicleWheelType(j, 0)
                if T then
                    SetVehicleMod(j, 23, tonumber(T), false)
                else
                    SetVehicleMod(j, 23, 0, false)
                end
            end
        )
    elseif an == "backwheel" then
        Q(
            h["backwheel"],
            function(T)
                SetVehicleWheelType(j, 0)
                if T then
                    SetVehicleMod(j, 24, tonumber(T), false)
                else
                    SetVehicleMod(j, 24, 0, false)
                end
            end
        )
    elseif an == "pearlescent" then
        Q(
            h["pearlescent"],
            function(T)
                local f, ao = GetVehicleColours(j)
                if T then
                    SetVehicleExtraColours(j, tonumber(T), ao)
                else
                    SetVehicleExtraColours(j, 0, ao)
                end
            end
        )
    elseif an == "wheelcolor" then
        Q(
            h["wheelcolor"],
            function(T)
                if T then
                    SetVehicleExtraColours(j, GetVehicleColours(j), tonumber(T))
                else
                    SetVehicleExtraColours(j, GetVehicleColours(j), 0)
                end
            end
        )
    elseif an == "interiorcolour" then
        Q(
            h["interiorcolour"],
            function(T)
                if T then
                    SetVehicleInteriorColor(j, tonumber(T))
                else
                    SetVehicleInteriorColor(j, 0)
                end
            end
        )
    elseif an == "dashboardcolour" then
        Q(
            h["dashboardcolour"],
            function(T)
                if T then
                    SetVehicleDashboardColor(j, tonumber(T))
                else
                    SetVehicleDashboardColor(j, 0)
                end
            end
        )
    elseif an == "mod_14" then
        Q(
            h["mod_14"],
            function(T)
                if T then
                    SetVehicleMod(j, 14, tonumber(T), false)
                else
                    SetVehicleMod(j, 14, -1, false)
                end
            end
        )
    elseif an == "mod_15" then
        Q(
            h["mod_15"],
            function(T)
                if T then
                    SetVehicleMod(j, 15, tonumber(T), false)
                else
                    SetVehicleMod(j, 15, -1, false)
                end
            end
        )
    elseif an == "mod_22" or an == "xenonlights" then
        Q(
            h["mod_22"],
            function(ar)
                Q(
                    h["xenonlights"],
                    function(as)
                        if ar and tonumber(ar) > 0 then
                            ToggleVehicleMod(j, 22, true)
                            if as then
                                SetVehicleXenonLightsColor(j, tonumber(as))
                            end
                        else
                            ToggleVehicleMod(j, 22, false)
                        end
                    end
                )
            end
        )
    elseif an == "neonlayout" or an == "neoncolour" then
        Q(
            h["neonlayout"],
            function(at)
                Q(
                    h["neoncolour"],
                    function(au)
                        if at and tonumber(at) > 0 then
                            local av = tonumber(at)
                            if av == 1 then
                                SetVehicleNeonLightEnabled(j, 0, true)
                                SetVehicleNeonLightEnabled(j, 1, true)
                                SetVehicleNeonLightEnabled(j, 2, true)
                                SetVehicleNeonLightEnabled(j, 3, true)
                            elseif av == 2 then
                                SetVehicleNeonLightEnabled(j, 2, true)
                                SetVehicleNeonLightEnabled(j, 3, true)
                            elseif av == 3 then
                                SetVehicleNeonLightEnabled(j, 0, true)
                                SetVehicleNeonLightEnabled(j, 1, true)
                                SetVehicleNeonLightEnabled(j, 2, true)
                            elseif av == 4 then
                                SetVehicleNeonLightEnabled(j, 0, true)
                                SetVehicleNeonLightEnabled(j, 1, true)
                                SetVehicleNeonLightEnabled(j, 3, true)
                            end
                            if au then
                                local ap = a.neonColours[au]
                                SetVehicleNeonLightsColour(j, ap[1], ap[2], ap[3])
                            else
                                SetVehicleNeonLightsColour(j, 222, 222, 255)
                            end
                        else
                            SetVehicleNeonLightEnabled(j, 0, false)
                            SetVehicleNeonLightEnabled(j, 1, false)
                            SetVehicleNeonLightEnabled(j, 2, false)
                            SetVehicleNeonLightEnabled(j, 3, false)
                        end
                    end
                )
            end
        )
    elseif an == "sounds" then
        Q(
            h["sounds"],
            function(T)
                if T then
                    ForceVehicleEngineAudio(j, getVehicleSoundNameFromId(tonumber(T)))
                else
                    ForceVehicleEngineAudio(j, "")
                end
                SetTimeout(
                    500,
                    function()
                        SetVehicleRadioEnabled(j, false)
                        SetVehRadioStation(j, "OFF")
                    end
                )
            end
        )
    end
end
local function aw(d)
    if d.saveKey == "mod_14" then
        Citizen.CreateThread(
            function()
                local _ = GetGameTimer()
                while GetGameTimer() - _ < 2500 do
                    SetControlNormal(0, 86, 1.0)
                    Citizen.Wait(0)
                end
            end
        )
    else
        Z()
    end
    if
        d.name ~= "Chrome" and d.name ~= "Classic" and d.name ~= "Matte" and d.name ~= "Metallic" and d.name ~= "Metals" and
            d.name ~= "Pearlescent" and
            d.name ~= "Util" and
            d.name ~= "Chameleon"
     then
        return
    end
    Citizen.CreateThread(
        function()
            CORRUPT.loadPtfx("scr_as_trans")
            UseParticleFxAsset("scr_as_trans")
            local ax =
                StartParticleFxLoopedOnEntity(
                "scr_as_trans_smoke",
                j,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                0.0,
                2.0,
                false,
                false,
                false
            )
            local ay, az, aA = GetVehicleColor(j)
            SetParticleFxLoopedColour(ax, ay / 255, az / 255, aA / 255, false)
            Citizen.Wait(1000)
            StopParticleFxLooped(ax, false)
            RemoveNamedPtfxAsset("scr_as_trans")
        end
    )
end
local function aB(d)
    if d.helpText then
        drawNativeNotification(d.helpText, true)
    end
    for a2, am in pairs(d.items) do
        local aC = am[d.saveValue]
        local aD = type(aC) == "table" and json.encode(aC) or tostring(aC)
        local a9 = h[d.saveKey][aD]
        local aa = V(a9 == true, a9 ~= nil, am.price or d.price)
        RageUI.ButtonWithStyle(
            am.name,
            nil,
            aa,
            true,
            function(ab, ac, ad)
                if ac then
                    al(d, am)
                end
                if ad then
                    if a9 == true then
                        notify("~r~You have already applied this mod")
                    elseif a9 == false then
                        TriggerServerEvent("CORRUPT:setActiveStaticList", l, a.categoryToIndentifier[d], a2)
                        aw(d)
                    else
                        TriggerServerEvent("CORRUPT:purchaseStaticList", l, a.categoryToIndentifier[d], a2)
                        aw(d)
                    end
                end
            end
        )
    end
end
local function aE(d)
    for a2, am in pairs(d.items) do
        local aF = h[d.saveKey] or 0
        if type(aF) ~= "number" then
            aF = tonumber(aF)
        end
        local aa = V(aF == d.ownedValue, false, am.price or d.price)
        RageUI.ButtonWithStyle(
            am.name,
            nil,
            aa,
            true,
            function(ab, ac, ad)
                if ad then
                    if aF == d.ownedValue then
                        notify("~r~You have already applied this mod")
                    else
                        TriggerServerEvent("CORRUPT:purchaseStaticValueList", l, a.categoryToIndentifier[d], a2)
                        Z()
                    end
                end
            end
        )
    end
end
local function aG(d)
    local aH = h[d.saveKey] or {}
    if #aH > 0 then
        drawNativeNotification(string.format("Press ~INPUT_FRONTEND_ACCEPT~ to change %s", d.helpSuffix))
    end
    for a2, aI in pairs(aH) do
        RageUI.ButtonWithStyle(
            string.format("%s%d", d.indexPrefix, a2),
            "",
            {RightLabel = tostring(aI)},
            true,
            function(ab, ac, ad)
                if ad then
                    CORRUPT.clientPrompt(
                        d.inputTitle,
                        "",
                        function(aJ)
                            local aK = aH[a2]
                            local aL = nil
                            if d.valueType == "number" then
                                local aM = tonumber(aJ)
                                if aM then
                                    aL = aM
                                else
                                    notify("~r~Could not parse number.")
                                end
                            else
                                aL = aJ
                            end
                            if aL and aL ~= aK then
                                TriggerServerEvent("CORRUPT:setValueInputList", l, a.categoryToIndentifier[d], a2, aL)
                            end
                        end
                    )
                end
            end
        )
    end
    RageUI.ButtonWithStyle(
        d.buyTitle,
        "",
        {RightLabel = "£" .. getMoneyStringFormatted(d.price)},
        true,
        function(ab, ac, ad)
            if ad then
                TriggerServerEvent("CORRUPT:purchaseValueInputList", l, a.categoryToIndentifier[d])
            end
        end
    )
end
local function aN(d)
    RageUI.ButtonWithStyle(
        d.name,
        d.description,
        {RightLabel = "→→→"},
        true,
        function(ab, ac, ad)
            if ad then
                TriggerEvent("CORRUPT:lsCustomsOpenExternalMenu", d.menuType, j, l, h)
            end
        end,
        RMenu:Get(d.menuType, d.menuName)
    )
end
local function aO(d)
    if IsControlJustPressed(0, 0) then
        if m == 0 then
            I(d)
        else
            M()
        end
    end
end
local function aP(d)
    RageUI.IsVisible(
        RMenu:Get("lscustoms", d.menu),
        true,
        true,
        true,
        function()
            RageUI.BackspaceMenuCallback(
                function()
                    P(d)
                    if d.type == "modList" then
                        a3(d)
                    elseif d.type == "staticList" then
                        aq(d)
                    end
                end
            )
            if d.type == "modList" then
                a4(d)
                aO(d)
            elseif d.type == "indexModList" then
                ae(d)
                aO(d)
            elseif d.type == "staticList" then
                aB(d)
                aO(d)
            elseif d.type == "staticValueList" then
                aE(d)
                aO(d)
            elseif d.type == "valueInputList" then
                aG(d)
                aO(d)
            elseif d.type == "categoryList" then
                for f, g in pairs(d.categories) do
                    if g.visible then
                        if g.type == "externalMenu" then
                            aN(g)
                        else
                            RageUI.ButtonWithStyle(
                                g.name,
                                g.description,
                                {RightLabel = "→→→"},
                                true,
                                function(ab, ac, ad)
                                    if ad then
                                        I(g)
                                    end
                                end,
                                RMenu:Get("lscustoms", g.menu)
                            )
                        end
                    end
                end
            end
        end
    )
    if d.type == "categoryList" then
        for f, g in pairs(d.categories) do
            aP(g)
        end
    end
end
RageUI.CreateWhile(
    1.0,
    RMenu:Get("lscustoms", "mainmenu"),
    nil,
    function()
        RageUI.IsVisible(
            RMenu:Get("lscustoms", "repair"),
            true,
            true,
            true,
            function()
                RageUI.ButtonWithStyle(
                    "Repair Vehicle",
                    nil,
                    {RightLabel = "£1,000"},
                    true,
                    function(ab, ac, ad)
                        if ad then
                            TriggerServerEvent("CORRUPT:lscustomsRepairVehicle")
                        end
                    end
                )
            end
        )
        aP(a.category)
    end
)
local aQ = {["default"] = function()
        return true
    end, ["isCar"] = function()
        return IsThisModelACar(GetEntityModel(j))
    end, ["isBike"] = function()
        return IsThisModelABike(GetEntityModel(j))
    end, ["isPlane"] = function()
        return IsThisModelAPlane(GetEntityModel(j))
    end, ["hasFrontBumper"] = function()
        return GetNumVehicleMods(j, 1) > 0
    end, ["hasRearBumper"] = function()
        return GetNumVehicleMods(j, 2) > 0
    end, ["hasAnyBumper"] = function()
        return GetNumVehicleMods(j, 1) > 0 or GetNumVehicleMods(j, 2) > 0
    end, ["hasChassis"] = function()
        for ai = 42, 46 do
            if GetNumVehicleMods(j, ai) > 0 then
                return true
            end
        end
        return GetNumVehicleMods(j, 5) > 0
    end, ["hasInterior"] = function()
        for ai = 27, 37 do
            if GetNumVehicleMods(j, ai) > 0 then
                return true
            end
        end
        return false
    end, ["hasPlates"] = function()
        return GetNumVehicleMods(j, 25) > 0 or GetNumVehicleMods(j, 26) > 0
    end, ["isCarOrBike"] = function()
        return IsThisModelACar(GetEntityModel(j)) or IsThisModelABike(GetEntityModel(j))
    end, ["hasBiometricLock"] = function()
        return h and h["security"] and h["security"]["21"] ~= nil
    end}
local aR = {[18] = true}
local function aS(d)
    d.visible = true
    if d.type == "modList" then
        d.visible = GetNumVehicleMods(j, d.modType) > 0
    elseif d.type == "indexModList" then
        d.visible = table.count(q[d.generatorName]()) > 0
    else
        if d.type == "staticList" and string.match(d.saveKey, "mod_") then
            local aT = tonumber(string.sub(d.saveKey, 5))
            if aT and not aR[aT] and GetNumVehicleMods(j, aT) == 0 then
                d.visible = false
            end
        end
        if d.requirements then
            local aU = stringsplit(d.requirements, ",")
            for f, aV in pairs(aU) do
                aV = string.gsub(aV, "%s+", "")
                local aW = aQ[aV]
                if not aW() then
                    d.visible = false
                    break
                end
            end
        elseif d.visible then
            d.visible = aQ["default"]()
        end
    end
    if d.type == "categoryList" then
        local aX = false
        for f, g in pairs(d.categories) do
            aS(g)
            if g.visible then
                aX = true
            end
        end
        if not aX then
            d.visible = false
        end
    end
end
local function aY()
    k = CORRUPT.getVehicleIdFromModel(GetEntityModel(j))
    if DecorExistOn(j, "corrupt_uuid") then
        l = DecorGetInt(j, "corrupt_uuid")
    else
        l = 0
    end
    if k == nil or l == 0 then
        notify("~r~Could not identify the vehicle you are in.")
        i = nil
        j = 0
        return
    end
    TriggerServerEvent("CORRUPT:getBoughtUpgrades", l)
    while not h do
        Citizen.Wait(0)
    end
    DisplayRadar(false)
    SetPlayerControl(PlayerId(), false, 0)
    TriggerServerEvent("CORRUPT:setCustomsGarageStatus", i.index, true)
    DoScreenFadeOut(500)
    while IsScreenFadingOut() do
        Citizen.Wait(0)
    end
    local aZ = i.driveIn
    SetEntityCoordsNoOffset(j, aZ.position.x, aZ.position.y, aZ.position.z, false, false, false)
    SetEntityHeading(j, aZ.heading)
    FadeOutLocalPlayer(true)
    SetVehicleOnGroundProperly(j)
    SetVehicleLights(j, 2)
    SetVehicleInteriorlight(j, true)
    SetVehicleDoorsLocked(j, 4)
    SetPlayerInvincible(PlayerId(), true)
    SetEntityInvincible(j, true)
    SetEntityCanBeDamaged(j, false)
    SetVehRadioStation(j, "OFF")
    local a_ = i.interior
    if a_ then
        ForceRoomForEntity(PlayerPedId(), a_.key, a_.room)
        ForceRoomForEntity(j, a_.key, a_.room)
        ForceRoomForGameViewport(a_.key, a_.room)
    end
    if i.type == "automobile" then
        local b0 = i.camera
        n = GetRenderingCam()
        m = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(m, b0.position.x, b0.position.y, b0.position.z + 1.0)
        PointCamAtEntity(m, j, 1, 1, 1, true)
        SetCamActive(m, true)
        RenderScriptCams(true, false, 0, false, false)
        local b1 = i.inside
        TaskVehicleDriveToCoord(
            PlayerPedId(),
            j,
            b1.position.x,
            b1.position.y,
            b1.position.z,
            3.0,
            1.0,
            GetEntityModel(j),
            16777216,
            0.1,
            1
        )
    end
    if a_ then
        ForceRoomForEntity(PlayerPedId(), a_.key, a_.room)
        ForceRoomForEntity(j, a_.key, a_.room)
        ForceRoomForGameViewport(a_.key, a_.room)
    end
    DoScreenFadeIn(3000)
    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end
    local _ = GetGameTimer()
    while not IsVehicleStopped(j) do
        if GetGameTimer() - _ < 15000 then
            break
        end
        Citizen.Wait(0)
    end
    ClearPedTasks(PlayerPedId())
    if i.type == "automobile" then
        local b2 = GetFinalRenderedCamCoord()
        SetCamCoord(m, b2.x, b2.y, b2.z)
        local b3 = GetGameplayCamRot(2)
        SetCamRot(m, b3.x, b3.y, b3.z, 2)
        RenderScriptCams(true, true, 0, false, false)
        RenderScriptCams(false, true, 1000, false, false)
        SetCamActive(m, true)
        TogglePausedRenderphases(true)
        SetCamActive(m, false)
    end
    FreezeEntityPosition(j, true)
    SetEntityCollision(j, false, false)
    SetPlayerControl(PlayerId(), true, 0)
    RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL", false)
    RequestScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2", false)
    currentCategory = a
    RMenu:Get("lscustoms", "mainmenu"):SetSubtitle(i.name)
    aS(a.category)
    if IsVehicleDamaged(j) then
        RageUI.Visible(RMenu:Get("lscustoms", "repair"), true)
    else
        RageUI.Visible(RMenu:Get("lscustoms", "mainmenu"), true)
    end
    p = true
end
local function b4()
    SetPlayerControl(PlayerId(), false, 0)
    DoScreenFadeOut(500)
    while IsScreenFadingOut() do
        Citizen.Wait(0)
    end
    tvRP.applyModsOnVehicle(h, k, j)
    local b5 = i.driveOut
    SetEntityCoords(j, b5.position.x, b5.position.y, b5.position.z, false, false, false, false)
    SetEntityHeading(j, b5.heading)
    SetEntityCollision(j, true, true)
    FreezeEntityPosition(j, false)
    SetVehicleOnGroundProperly(j)
    SetVehicleDoorsLocked(j, 0)
    SetPlayerInvincible(PlayerId(), false)
    SetVehicleLights(j, 0)
    NetworkLeaveTransition()
    if i.type == "automobile" then
        SetCamActive(m, false)
        RenderScriptCams(false, false, 0, false, false)
        DestroyCam(m, false)
        m = 0
        local b6 = i.outside
        TaskVehicleDriveToCoord(
            PlayerPedId(),
            j,
            b6.position.x,
            b6.position.y,
            b6.position.z,
            3.0,
            0.1,
            GetEntityModel(j),
            16777216,
            0.1,
            1
        )
    end
    local a_ = i.interior
    if a_ then
        ForceRoomForEntity(PlayerPedId(), a_.key, a_.room)
        ForceRoomForEntity(j, a_.key, a_.room)
        ForceRoomForGameViewport(a_.key, a_.room)
    end
    DoScreenFadeIn(3000)
    while IsScreenFadingIn() do
        Citizen.Wait(0)
    end
    local _ = GetGameTimer()
    while not IsVehicleStopped(j) do
        if GetGameTimer() - _ < 15000 then
            break
        end
        Citizen.Wait(0)
    end
    ClearPedTasks(PlayerPedId())
    SetEntityInvincible(j, false)
    SetEntityCanBeDamaged(j, true)
    SetVehicleFixed(j)
    ReleaseNamedScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL")
    ReleaseNamedScriptAudioBank("DLC_MPHEIST\\HEIST_FLEECA_DRILL_2")
    TriggerServerEvent("CORRUPT:setCustomsGarageStatus", i.index, false)
    i = nil
    previousCategory = nil
    currentCategory = nil
    j = 0
    SetPlayerControl(PlayerId(), true, 0)
    DisplayRadar(true)
end
local function b7(b8)
    local b9, ba = CORRUPT.getPlayerVehicle()
    if b9 == 0 or not ba or i then
        return
    end
    local bb = GetEntityModel(b9)
    local userid, spawncode = tvRP.getVehicleInfos(b9)
    if userid ~= CORRUPT.getUserId() then
        CORRUPT.DrawText(0.5, 0.8, "~r~You cannot upgrade this vehicle~w~", 1.0, 4, 0)
    elseif b8.isLocked then
        CORRUPT.DrawText(0.5, 0.8, "~r~Locked, please wait~w~", 1.0, 4, 0)
    elseif b8.type == "plane" and not IsThisModelAPlane(bb) then
        CORRUPT.DrawText(0.5, 0.8, "~r~You must be a in a plane to use this~w~", 1.0, 4, 0)
    elseif b8.type == "boat" and not IsThisModelABoat(bb) then
        CORRUPT.DrawText(0.5, 0.8, "~r~You must be a in a boat to use this~w~", 1.0, 4, 0)
    else
        CORRUPT.DrawText(0.5, 0.8, "Press ~b~ENTER~w~ to enter ~b~" .. b8.name .. "~w~", 1.0, 4, 0)
        if IsControlJustPressed(0, 201) then
            i = b8
            j = b9
            Citizen.CreateThread(aY)
        end
    end
end
local function bc(d)
    if RageUI.Visible(RMenu:Get("lscustoms", d.menu)) then
        return true
    end
    if d.type == "externalMenu" then
        return RageUI.Visible(RMenu:Get(d.menuType, d.menuName))
    elseif d.type == "categoryList" then
        for f, g in pairs(d.categories) do
            if bc(g) then
                return true
            end
        end
    end
    return false
end
local function bd()
    if i then
        SetLocalPlayerVisibleLocally(true)
        if p and not bc(a.category) and not RageUI.Visible(RMenu:Get("lscustoms", "repair")) then
            Citizen.CreateThread(b4)
            p = false
        end
    end
end
Citizen.CreateThread(
    function()
        for a2, b8 in pairs(a.garages) do
            b8.index = a2
            CORRUPT.createArea(
                "lscustoms_" .. tostring(a2),
                b8.driveIn.position,
                5.0,
                6.0,
                function()
                end,
                function()
                end,
                b7,
                b8
            )
            tvRP.addBlip(b8.inside.position.x, b8.inside.position.y, b8.inside.position.z, 72, nil, "LS Customs")
        end
        CORRUPT.createThreadOnTick(bd)
    end
)
RegisterNetEvent(
    "CORRUPT:setCustomsGarageStatus",
    function(be, bf)
        a.garages[be].isLocked = bf
    end
)
RegisterNetEvent(
    "CORRUPT:syncCustomsGarageStatus",
    function(bg)
        for f, a2 in pairs(bg) do
            a.garages[a2].isLocked = true
        end
    end
)
RegisterNetEvent("CORRUPT:gotBoughtUpgrades", function(bh)
    h = bh
end)

RegisterNetEvent("CORRUPT:setSpecificOwnedUpgrade", function(T, U)
    h[T] = U
end)

RegisterNetEvent("CORRUPT:lscustomsRepairVehicle", function()
    SetVehicleFixed(j)
    RageUI.Visible(RMenu:Get("lscustoms", "mainmenu"), true)
end)

function CORRUPT.isInsideLsCustoms()
    return i ~= nil
end
