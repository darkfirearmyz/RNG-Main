local a = `WEAPON_STAFFGUN`
local b = false
local c = false
local d = 101
local e
local f = "N/A"
local g = "N/A"
local h = 0.0
local i = ""
local j = {}
local k = {}
TriggerEvent(
    "chat:addSuggestion",
    "/setspeed",
    "Sets speed gun capture speed",
    {{name = "Speed", help = "minimum 101"}}
)
RegisterCommand(
    "setspeed",
    function(l, m)
        if CORRUPT.globalOnPoliceDuty() then
            if m[1] ~= nil then
                if tonumber(m[1]) > 100 then
                    d = tonumber(m[1])
                    tvRP.notify(string.format("~g~Maximum speed set to %smph", tonumber(m[1])))
                else
                    d = 101
                    tvRP.notify("Minimum speed you can set is 101mph!")
                end
            end
        else
            tvRP.notify("Speed gun is not enabled!")
        end
    end
)
function func_drawRadar()
    if b and not usingDelgun then
        DisableControlAction(1, 18, true)
        DisablePlayerFiring(PlayerId(), true)
        DrawRect(0.5, 0.91, 0.13, 0.125, 0, 0, 0, 128)
        DrawAdvancedText(0.5, 0.68, 0.1, 0.2, 0.4, i .. "PLATE:  " .. f, 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.5, 0.715, 0.1, 0.2, 0.4, i .. "SPEED:  " .. parseInt(h) .. " MPH", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.5, 0.75, 0.1, 0.2, 0.4, i .. "MODEL:  " .. g, 255, 255, 255, 255, 4, 0)
    end
end
CORRUPT.createThreadOnTick(func_drawRadar)
Citizen.CreateThread(
    function()
        while true do
            if CORRUPT.globalOnPoliceDuty() and not usingDelgun then
                if GetSelectedPedWeapon(CORRUPT.getPlayerPed()) == a then
                    b = true
                else
                    b = false
                end
                if b and CORRUPT.getPlayerVehicle() == 0 then
                    local n = CORRUPT.getPlayerId()
                    if IsPlayerFreeAiming(n) then
                        local o, e = GetEntityPlayerIsFreeAimingAt(n)
                        local p = GetVehiclePedIsIn(e, false)
                        if
                            p ~= 0 and GetPedInVehicleSeat(p, -1) == e and not IsPedInAnyPlane(e) and
                                not IsPedInAnyHeli(e)
                         then
                            local q = p
                            f = GetVehicleNumberPlateText(q) or "N/A"
                            g = GetLabelText(GetDisplayNameFromVehicleModel(GetEntityModel(q))) or "N/A"
                            h = round(GetEntitySpeed(p) * 2.236936, 1) - 5
                            if k[f] ~= nil then
                                local r = k[f]
                                if not soundPlayed then
                                    PlaySoundFrontend(-1, "BEEP_GREEN", "DLC_HEIST_HACKING_SNAKE_SOUNDS", 1)
                                end
                                tvRP.notify(
                                    string.format("~h~Vehicle Flagged:~s~~n~Plate %s is flagged for:~n~%s", f, r)
                                )
                                soundPlayed = true
                                SetTimeout(
                                    10000,
                                    function()
                                        soundPlayed = false
                                    end
                                )
                            end
                            if h > d and h > 101 then
                                i = ""
                                if not j[q] then
                                    j[q] = true
                                    SetTimeout(
                                        30000,
                                        function()
                                            local q = q
                                            j[q] = nil
                                        end
                                    )
                                    TriggerServerEvent(
                                        "CORRUPT:speedGunFinePlayer",
                                        GetPlayerServerId(NetworkGetPlayerIndexFromPed(e)),
                                        h - d
                                    )
                                    Citizen.Wait(3000)
                                else
                                    tvRP.notify("This vehicle has been fined recently!")
                                end
                            else
                                i = "~w~"
                            end
                        end
                    end
                end
            end
            Wait(50)
        end
    end
)
RegisterNetEvent("CORRUPT:speedGunPlayerFined")
AddEventHandler(
    "CORRUPT:speedGunPlayerFined",
    function()
        PlaySoundFrontend(-1, "ScreenFlash", "MissionFailedSounds", 1)
        StartScreenEffect("FocusOut", 0, false)
        Wait(2000)
        StopScreenEffect("FocusOut")
    end
)
AddEventHandler(
    "CORRUPT:setFlagVehicles",
    function(s)
        k = s
    end
)
