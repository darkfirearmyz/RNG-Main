local a = 1800
local b = true
local c = false
local d = 1800
local e = false
local f = false
Citizen.CreateThread(
    function()
        while true do
            local g = CORRUPT.getPlayerPed()
            if g then
                local h = GetEntityCoords(g)
                local i = GetEntityHeading(g)
                local j = GetGameplayCamRot(2)
                local k = globalOnPoliceDuty or globalNHSOnDuty or globalOnPrisonDuty or globalLFBOnDuty
                if not CORRUPT.isDeveloper() then
                    if h == prevPos and i == previousHeading and j == prevCameraHeading then
                        if d > 0 then
                            if k and d < 1500 and not e then
                                e = true
                                TriggerServerEvent("CORRUPT:factionAfkAlert", "5 minutes")
                            end
                            if d == 1202 then
                                e = false
                            end
                            if d == 1201 and not e and k then
                                TriggerServerEvent("CORRUPT:factionAfkAlert", "10 minutes")
                                e = true
                            end
                            if b and d == math.ceil(a / 4) then
                                afkScaleForm()
                            end
                            if b and d == math.ceil(a / 2) then
                                tvRP.notify(string.format("~r~You will be set to AFK in: %s seconds", d))
                            end
                            d = d - 1
                            c = true
                        else
                            if not f then
                                if k then
                                    TriggerServerEvent("CORRUPT:factionAfkAlert", "30 minutes - Player set to AFK")
                                end
                                TriggerServerEvent("kick:AFK")
                                f = true
                            end
                        end
                    else
                        if e and k then
                            TriggerServerEvent("CORRUPT:factionAfkAlert", "No longer AFK - player moved again")
                            e = false
                        end
                        if f then
                            TriggerServerEvent("CORRUPT:setNoLongerAFK")
                        end
                        c = false
                        d = a
                        f = false
                    end
                    prevPos = h
                    previousHeading = i
                    prevCameraHeading = j
                end
            end
            Wait(1000)
        end
    end
)
function afkScaleForm()
    Citizen.CreateThread(
        function()
            local l = RequestScaleformMovie("mp_big_message_freemode")
            while not HasScaleformMovieLoaded(l) do
                Citizen.Wait(0)
                while c do
                    Citizen.Wait(0)
                    BeginScaleformMovieMethod(l, "SHOW_SHARD_WASTED_MP_MESSAGE")
                    ScaleformMovieMethodAddParamTextureNameString("~r~WARNING")
                    ScaleformMovieMethodAddParamTextureNameString(
                        string.format("You will be set to AFK in %s seconds", d)
                    )
                    ScaleformMovieMethodAddParamInt(5)
                    EndScaleformMovieMethod()
                    DrawScaleformMovieFullscreen(l, 255, 255, 255, 255, 0)
                end
            end
        end
    )
end
