function loadAnimDict(a)
    while not HasAnimDictLoaded(a) do
        RequestAnimDict(a)
        Citizen.Wait(5)
    end
end
Citizen.CreateThread(
    function()
        while true do
            Citizen.Wait(0)
            if CORRUPT.isDeveloper() then
                SetPedInfiniteAmmo(PlayerPedId(), true, GetHashKey(GetSelectedPedWeapon(PlayerPedId())))
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 90) then
                local b = GetClosestPlayer(3)
                if b then
                    targetSrc = GetPlayerServerId(b)
                    if targetSrc > 0 then
                        TriggerServerEvent("CORRUPT:dragPlayer", targetSrc)
                    end
                end
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsDisabledControlJustPressed(1, 185) then
                TriggerServerEvent("CORRUPT:ejectFromVehicle")
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 74) and CORRUPT.isDeveloper() then
                Wait(1000)
                local e = "melee@unarmed@streamed_variations"
                local f = "plyr_takedown_front_headbutt"
                local g = CORRUPT.getPlayerPed()
                if DoesEntityExist(g) and not IsEntityDead(g) then
                    loadAnimDict(e)
                    if IsEntityPlayingAnim(g, e, f, 3) then
                        TaskPlayAnim(g, e, "exit", 3.0, 1.0, -1, 0, 0, 0, 0, 0)
                        ClearPedSecondaryTask(g)
                    else
                        TaskPlayAnim(g, e, f, 3.0, 1.0, -1, 0, 0, 0, 0, 0)
                    end
                    RemoveAnimDict(e)
                end
                TriggerServerEvent("CORRUPT:KnockoutNoAnim")
                Wait(1000)
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 32) then
                if
                    not IsPauseMenuActive() and not IsPedInAnyVehicle(CORRUPT.getPlayerPed(), true) and
                        not IsPedSwimming(CORRUPT.getPlayerPed()) and
                        not IsPedSwimmingUnderWater(CORRUPT.getPlayerPed()) and
                        not IsPedShooting(CORRUPT.getPlayerPed()) and
                        not IsPedDiving(CORRUPT.getPlayerPed()) and
                        not IsPedFalling(CORRUPT.getPlayerPed()) and
                        GetEntityHealth(CORRUPT.getPlayerPed()) > 105 and
                        not tvRP.isHandcuffed() and
                        not CORRUPT.isInRadioChannel()
                 then
                    tvRP.playAnim(true, {{"rcmnigel1c", "hailing_whistle_waive_a"}}, false)
                end
            end
            if IsControlPressed(1, 19) and IsControlJustPressed(1, 29) then
                if not IsPedInAnyVehicle(CORRUPT.getPlayerPed(), false) then
                    local h = GetClosestPlayer(4)
                    local i = IsEntityPlayingAnim(GetPlayerPed(h), "missminuteman_1ig_2", "handsup_enter", 3)
                    if i then
                        TriggerServerEvent("CORRUPT:requestPlaceBagOnHead")
                    else
                        drawNativeNotification("Player must have his hands up!")
                    end
                end
            end
        end
    end
)
