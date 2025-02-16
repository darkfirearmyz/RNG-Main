----------- [[ UTILITIES ]] -----------

local function ensureSecurityHasBlip(ped)
    local pedBlip = GetBlipFromEntity(ped)
    if pedBlip == 0 then
        if GetRoomKeyFromEntity(PlayerPedId()) ~= 0 and not IsPedDeadOrDying(ped, true) then
            pedBlip = AddBlipForEntity(ped)
            SetBlipColour(pedBlip, 1)
            SetBlipScale(pedBlip, 0.5)
            SetBlipAsShortRange(pedBlip, true)
        end
    else
        if GetRoomKeyFromEntity(PlayerPedId()) == 0 or IsPedDeadOrDying(ped, true) then
           RemoveBlip(pedBlip)
        end
    end
end

local function onUpdateSecurityStand(ped)
    if NetworkHasControlOfEntity(ped) then
        if GetScriptTaskStatus(ped, 0xD88F2CDE) == 7 then
            local position = Entity(ped).state.position
            TaskStandGuard(ped, position.x, position.y, position.z, position.w, "WORLD_HUMAN_GUARD_STAND")
        end

        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, true)
    end

    ensureSecurityHasBlip(ped)
end

local function onUpdateSecurityAttack(ped)
    if NetworkHasControlOfEntity(ped) then
        if GetScriptTaskStatus(ped, 0x2E85A751) == 7 then
            if GetScriptTaskStatus(ped, 0xD88F2CDE) ~= 7 then
                ClearPedTasksImmediately(ped)
            end

            SetPedCombatMovement(ped, 2)
            SetRagdollBlockingFlags(ped, 1)
            SetPedDropsWeaponsWhenDead(ped, false)

            TaskCombatPed(ped, PlayerPedId(), 0, 16)
        end

        local _, weaponModel = GetCurrentPedWeapon(ped)
        if weaponModel ~= `WEAPON_PISTOL` then
            GiveWeaponToPed(ped, `WEAPON_PISTOL`, 1000, false, true)
        end

        if GetPedRelationshipGroupHash(ped) ~= `SECURITY_ATTACK` then
            SetPedRelationshipGroupHash(ped, `SECURITY_ATTACK`)
            SetPedRelationshipGroupDefaultHash(ped, `SECURITY_ATTACK`)
        end

        SetBlockingOfNonTemporaryEvents(ped, true)
        FreezeEntityPosition(ped, false)
    end


    ensureSecurityHasBlip(ped)
end

local function onUpdateWorkerSitting(ped)
    if NetworkHasControlOfEntity(ped) then
        if not IsPedUsingScenario(ped, "PROP_HUMAN_SEAT_BENCH") then
            TaskStartScenarioInPlace(ped, "PROP_HUMAN_SEAT_BENCH", -1, false)
            FreezeEntityPosition(ped, true)
        end

        local position = Entity(ped).state.position
        SetEntityCoordsNoOffset(ped, position.x, position.y, position.z, false, false, false)

        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end

local function onUpdatePersonStanding(ped, panic)
    if NetworkHasControlOfEntity(ped) then
        if panic then
            if not IsEntityPlayingAnim(ped, "amb@code_human_cower@female@idle_a", "idle_c", 3) then
                RequestAnimDict("amb@code_human_cower@female@idle_a")
                if HasAnimDictLoaded("amb@code_human_cower@female@idle_a") then
                    TaskPlayAnim(ped, "amb@code_human_cower@female@idle_a", "idle_c", 8.0, 8.0, -1, 1, 1.0, false, false, false)
                end
                RemoveAnimDict("amb@code_human_cower@female@idle_a")
            end
        else
            if Entity(ped).state.usingPhone then
                if not IsPedUsingScenario(ped, "WORLD_HUMAN_STAND_MOBILE") then
                    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_STAND_MOBILE", -1, false)
                end
            end
        end

        FreezeEntityPosition(ped, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
    end
end

local function onUpdateWorldPeds(panic)
    for _, ped in ipairs(GetGamePool("CPed")) do
        if NetworkGetEntityIsNetworked(ped) then
            local type = Entity(ped).state.type

            if type == "SECURITY_STAND" then
                onUpdateSecurityStand(ped)
            elseif type == "SECURITY_ATTACK" then
                onUpdateSecurityAttack(ped)
            elseif type == "WORKER_SITTING" then
                onUpdateWorkerSitting(ped)
            elseif type == "PERSON_STANDING" then
                onUpdatePersonStanding(ped, panic)
            end
        end
    end
end

local function disableRunningAndSprintingInside()
    if GetRoomKeyFromEntity(PlayerPedId()) ~= 0 then
        DisableControlAction(0, 21, true) -- INPUT_SPRINT
        DisableControlAction(0, 22, true) -- INPUT_JUMP
    end
end

local function checkPlayerIsBeingSilent(info)
    local playerPos = GetEntityCoords(PlayerPedId(), true)
    if #(playerPos - info.bankPosition) < 100.0 then
        if GetRoomKeyFromEntity(PlayerPedId()) ~= 0 then
            if GetVehiclePedIsUsing(PlayerPedId()) ~= 0 and not info.sentAlert then -- Driving inside
                TriggerServerEvent("CORRUPT:bankHeistSecurityAlerted")
                info.sentAlert = true
            end

            local _, weaponModel = GetCurrentPedWeapon(PlayerPedId())
            if weaponModel ~= `WEAPON_UNARMED` and not info.sentAlert then -- Using weapons inside
                TriggerServerEvent("CORRUPT:bankHeistSecurityAlerted")
                info.sentAlert = true
            end
        end
    end
end

local function ensureSecureDoorsAreLocked()
    local frontMetalDoor = GetClosestObjectOfType(257.04, 220.35, 106.28, 5.0, 4072696575, false, false, false)
    FreezeEntityPosition(frontMetalDoor, true)

    local rearMetalDoor = GetClosestObjectOfType(261.84, 221.77, 106.28, 5.0, 746855201, false, false, false)
    FreezeEntityPosition(rearMetalDoor, true)

    local topWoodenDoor = GetClosestObjectOfType(265.68, 218.37, 110.28, 5.0, 1956494919, false, false, false)
    FreezeEntityPosition(topWoodenDoor, true)
end

local function drawPlayerCount(info)
    DrawGTATimerBar("~y~MEMBERS~w~", tostring(#info.players), 0)
end

local function exitHackingScaleform(info)
    if info.scaleform then
        SetScaleformMovieAsNoLongerNeeded(info.scaleform)
        SetScaleformMovieAsNoLongerNeeded(info.buttonScaleform)
        info.scaleform = nil
        info.buttonScaleform = nil
        info.numberLives = nil
        info.scaleformReturn = nil
        TriggerServerEvent("CORRUPT:bankHeistUsingComputer", false)
        CORRUPT.showUI()
    end
end

local function createHackingScaleform()
    CORRUPT.hideUI()

    local scaleform = RequestScaleformMovieInteractive("HACKING_PC")
    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "SET_LABELS")
    ScaleformMovieMethodAddParamTextureNameString("Local Disk (C:)")
    ScaleformMovieMethodAddParamTextureNameString("Network")
    ScaleformMovieMethodAddParamTextureNameString("External Device (F:)")
    ScaleformMovieMethodAddParamTextureNameString("adhesive.dll")
    ScaleformMovieMethodAddParamTextureNameString("eulen.exe")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND")
    ScaleformMovieMethodAddParamInt(0)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "ADD_PROGRAM")
    ScaleformMovieMethodAddParamFloat(1.0)
    ScaleformMovieMethodAddParamFloat(4.0)
    ScaleformMovieMethodAddParamTextureNameString("My Computer")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "ADD_PROGRAM")
    ScaleformMovieMethodAddParamFloat(6.0)
    ScaleformMovieMethodAddParamFloat(6.0)
    ScaleformMovieMethodAddParamTextureNameString("Power Off")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(1)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(2)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(3)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(4)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(5)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(6)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_COLUMN_SPEED")
    ScaleformMovieMethodAddParamInt(7)
    ScaleformMovieMethodAddParamInt(255)
    EndScaleformMovieMethod()

    return scaleform
end

local function onUpdateHackingScaleform(info)
    DrawScaleformMovieFullscreen(info.scaleform, 255, 255, 255, 255, 0)
    DrawScaleformMovieFullscreen(info.buttonScaleform, 255, 255, 255, 255, 0)

    BeginScaleformMovieMethod(info.scaleform, "SET_CURSOR")
    ScaleformMovieMethodAddParamFloat(GetControlNormal(0, 239))
    ScaleformMovieMethodAddParamFloat(GetControlNormal(0, 240))
    EndScaleformMovieMethod()

    DisableControlAction(0, 24, true)
    if IsDisabledControlJustPressed(0, 24) then
        BeginScaleformMovieMethod(info.scaleform, "SET_INPUT_EVENT_SELECT")
        info.scaleformReturn = EndScaleformMovieMethodReturnValue()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    end

    DisableControlAction(0, 25, true)
    if IsDisabledControlJustPressed(0, 25) then
        BeginScaleformMovieMethod(info.scaleform, "SET_INPUT_EVENT_BACK")
        EndScaleformMovieMethod()
        PlaySoundFrontend(-1, "HACKING_CLICK", "", true)
    end

    if info.numberLives <= 0 then
        exitHackingScaleform(info)
        TriggerServerEvent("CORRUPT:bankHeistSecurityAlerted")
        info.sentAlert = true
        return
    end

    if IsScaleformMovieMethodReturnValueReady(info.scaleformReturn) then
        local program = GetScaleformMovieMethodReturnValueInt(info.scaleformReturn)

        if program == 82 then
            PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
        elseif program == 83 then
            BeginScaleformMovieMethod(info.scaleform, "RUN_PROGRAM")
            ScaleformMovieMethodAddParamFloat(83.0)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(info.scaleform, "SET_ROULETTE_WORD")
            ScaleformMovieMethodAddParamTextureNameString(info.hackingText)
            EndScaleformMovieMethod()
        elseif program == 87 then
            info.numberLives = info.numberLives - 1

            BeginScaleformMovieMethod(info.scaleform, "SET_ROULETTE_WORD")
            ScaleformMovieMethodAddParamTextureNameString(info.hackingText)
            EndScaleformMovieMethod()

            BeginScaleformMovieMethod(info.scaleform, "SET_LIVES")
            ScaleformMovieMethodAddParamInt(info.numberLives)
            ScaleformMovieMethodAddParamInt(5)
            EndScaleformMovieMethod()

            PlaySoundFrontend(-1, "HACKING_CLICK_BAD", "", false)
        elseif program == 86 then
            PlaySoundFrontend(-1, "HACKING_SUCCESS", "", true)

            Citizen.CreateThread(function()
                BeginScaleformMovieMethod(info.scaleform, "SET_ROULETTE_OUTCOME")
                ScaleformMovieMethodAddParamBool(true)
                ScaleformMovieMethodAddParamTextureNameString("BRUTEFORCE SUCCESSFUL!")
                EndScaleformMovieMethod()

                Citizen.Wait(2500)

                BeginScaleformMovieMethod(info.scaleform, "CLOSE_APP")
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "OPEN_LOADING_PROGRESS")
                ScaleformMovieMethodAddParamBool(true)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_PROGRESS")
                ScaleformMovieMethodAddParamInt(35)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_TIME")
                ScaleformMovieMethodAddParamInt(35)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString("Writing data to buffer..")
                ScaleformMovieMethodAddParamFloat(2.0)
                EndScaleformMovieMethod()

                Citizen.Wait(2500)

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_MESSAGE")
                ScaleformMovieMethodAddParamTextureNameString("Executing malicious code..")
                ScaleformMovieMethodAddParamFloat(2.0)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_TIME")
                ScaleformMovieMethodAddParamInt(15)
                EndScaleformMovieMethod()

                BeginScaleformMovieMethod(info.scaleform, "SET_LOADING_PROGRESS")
                ScaleformMovieMethodAddParamInt(75)
                EndScaleformMovieMethod()

                Citizen.Wait(1500)
                exitHackingScaleform(info)
                TriggerServerEvent("CORRUPT:bankHeistHackSuccess")
            end)
        elseif program == 6 then
            Citizen.Wait(500)
            exitHackingScaleform(info)
        end
    end
end

local function createHackingInstructionalButtons()
    local scaleform = RequestScaleformMovie("instructional_buttons")

    while not HasScaleformMovieLoaded(scaleform) do
        Citizen.Wait(0)
    end

    BeginScaleformMovieMethod(scaleform, "CLEAR_ALL")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_DATA_SLOT")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamPlayerNameString("~INPUT_ATTACK~")
    BeginTextCommandScaleformString("STRING")
    AddTextComponentSubstringKeyboardDisplay("Click / Select")
    EndTextCommandScaleformString()
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "DRAW_INSTRUCTIONAL_BUTTONS")
    EndScaleformMovieMethod()

    BeginScaleformMovieMethod(scaleform, "SET_BACKGROUND_COLOUR")
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(0)
    ScaleformMovieMethodAddParamInt(80)
    EndScaleformMovieMethod()

    return scaleform
end

----------- [[ STAGE: DRIVE_TO_BANK ]] -----------

local function initDriveToBank(info)
    info.bankBlip = AddBlipForCoord(info.bankPosition.x, info.bankPosition.y, info.bankPosition.z)
    SetBlipRoute(info.bankBlip, true)
    info.audioPlayed = false
    TriggerMusicEvent("AH3B_EVADE_COPS_RT")
end

local function runDriveToBank(info)
    drawPlayerCount(info)

    if GetGameTimer() - info.lastInit > 10000 then
        if not info.audioPlayed then
            PlaySoundFrontend(-1, "wondering_what_doing", "dlc_bankheist_setupone_soundset", false)
            info.audioPlayed = true
        end
    end

    drawNativeText("Drive to the ~y~Bank Of England~w~")
end

local function cleanDriveToBank(info)
    RemoveBlip(info.bankBlip)
    info.bankBlip = nil
    info.audioPlayed = nil
end

----------- [[ STAGE: GO_TO_ENTRANCE ]] -----------

local function initGoToEntrance(info)
    info.bankEnterBlips = {}
    for _, position in ipairs(info.bankEnterPositions) do
        local blip = AddBlipForCoord(position.x, position.y, position.z)
        SetBlipScale(blip, 0.5)
        info.bankEnterBlips[#info.bankEnterBlips + 1] = blip
    end

    PlaySoundFrontend(-1, "one_of_two_doors", "dlc_bankheist_setupone_soundset", false)
end

local function runGoToEntrance(info)
    drawPlayerCount(info)
    onUpdateWorldPeds(false)

    drawNativeText("Enter the bank through an ~y~entrance~w~")
end

local function cleanGotoEntrance(info)
    for _, blip in ipairs(info.bankEnterBlips) do
        RemoveBlip(blip)
    end
end

----------- [[ STAGE: FIND_COMPUTER ]] -----------

local function initFindComputer()
    PlaySoundFrontend(-1, "laptop_upstairs_offices", "dlc_bankheist_setupone_soundset", false)
end

local function runFindComputer(info)
    onUpdateWorldPeds(false)
    disableRunningAndSprintingInside()
    checkPlayerIsBeingSilent(info)
    drawPlayerCount(info)
    ensureSecureDoorsAreLocked()

    if GetRoomKeyFromEntity(PlayerPedId()) == 0 then
        drawNativeText("Head ~y~inside~w~ to locate the bank manager's ~b~computer~w~")
    else
        drawNativeText("Locate the bank manager's ~b~computer~w~")
    end
end

----------- [[ STAGE: HACK_COMPUTER ]] -----------

local function initHackComputer(info)
    info.computerBlip = AddBlipForCoord(info.computerPosition.x, info.computerPosition.y, info.computerPosition.z)
    SetBlipSprite(info.computerBlip, 606)
    SetBlipColour(info.computerBlip, 18)
    SetBlipScale(info.computerBlip, 0.75)

    info.eventUsingComputer = RegisterHeistEvent("CORRUPT:bankHeistUsingComputer", function(player)
        print(string.format("Received set hacking player (server: %d)", player or 0))
        info.hackingPlayer = player
    end)

    PlaySoundFrontend(-1, "load_the_hack", "dlc_bankheist_setupone_soundset", false)
end

local function runHackComputer(info)
    onUpdateWorldPeds(false)
    disableRunningAndSprintingInside()
    checkPlayerIsBeingSilent(info)
    ensureSecureDoorsAreLocked()

    drawNativeText("Hack the ~b~computer~w to gain access to the cameras")

    if not info.hackingPlayer then
        local playerPos = GetEntityCoords(PlayerPedId(), true)
        if #(info.computerPosition - playerPos) < 1.0 then
            drawNativeNotification("Press ~INPUT_PICKUP~ to hack the computer")
            DisableControlAction(0, 38, true)
            if IsDisabledControlPressed(0, 38) then
                TriggerServerEvent("CORRUPT:bankHeistUsingComputer", true)
                info.scaleform = createHackingScaleform()
                info.buttonScaleform = createHackingInstructionalButtons()
                info.numberLives = 5
                local texts = { "BATHBOMB", "ADHESIVE", "ROLEPLAY", "BANKPASS", "BUYMERCH", "SAVEFISH", "REDLIGHT", "LIVEONcE" }
                info.hackingText = texts[math.random(1, #texts)]
            end
        end
    end

    if info.scaleform then
        onUpdateHackingScaleform(info)
    else
        drawPlayerCount(info)
    end

    if info.hackingPlayer then
        local player = GetPlayerFromServerId(info.hackingPlayer)
        if player ~= -1 then
            DrawGTATimerBar("~b~HACKING~w~", CORRUPT.getPlayerName(player), 1)
        end
    end
end

local function cleanHackComputer(info)
    RemoveEventHandler(info.eventUsingComputer)
    info.eventUsingComputer = nil

    RemoveBlip(info.computerBlip)
    info.computerBlip = nil

    info.hackingPlayer = nil
    exitHackingScaleform(info)
end

----------- [[ STAGE: VIEW_HACKED_CAMERAS ]] -----------

local function initViewHackedCameras(info)
    info.cameraHandle = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
    SetCamActive(info.cameraHandle, true)
    RenderScriptCams(info.cameraHandle, false, 0, false, false)

    info.lastCameraStage = 0
    info.lastCameraTransition = 0

    SetTimecycleModifier("scanline_cam_cheap")
    SetTimecycleModifierStrength(2.0)

    CORRUPT.hideUI()
    SetPlayerControl(PlayerId(), false, 0)

    PlaySoundFrontend(-1, "hack_like_that_still", "dlc_bankheist_setupone_soundset", false)
    info.audioPlayed = false
end

local function runViewHackedCameras(info)
    onUpdateWorldPeds(false)
    disableRunningAndSprintingInside()
    checkPlayerIsBeingSilent(info)
    drawPlayerCount(info)
    ensureSecureDoorsAreLocked()

    local currentTime = GetGameTimer()
    if currentTime - info.lastCameraTransition > 3500 and info.lastCameraStage < #info.camerasInformation then
        info.lastCameraStage = info.lastCameraStage + 1
        local camInfo = info.camerasInformation[info.lastCameraStage]
        local pos = camInfo.position

        local rotOne = camInfo.rotations[1]
        SetCamParams(info.cameraHandle, pos.x, pos.y, pos.z, rotOne.x, rotOne.y, rotOne.z, 70.0, 0, 1, 1, 2)

        local rotTwo = camInfo.rotations[2]
        if rotTwo then
            SetCamParams(info.cameraHandle, pos.x, pos.y, pos.z, rotTwo.x, rotTwo.y, rotTwo.z, 70.0, 3000, 1, 1, 2)
        end

        info.lastCameraTransition = currentTime
    end

    if not info.goldTrollieHandles then
        RequestModel(`hei_prop_hei_cash_trolly_01`)
        if HasModelLoaded(`hei_prop_hei_cash_trolly_01`) then
            info.goldTrollieHandles = {}
            for _, position in ipairs(info.goldTrolliePositions) do
                local handle = CreateObject(`hei_prop_hei_cash_trolly_01`, position.x, position.y, position.z, false, false, false)
                SetEntityHeading(handle, position.w)
                FreezeEntityPosition(handle, true)
                table.insert(info.goldTrollieHandles, handle)
            end
            SetModelAsNoLongerNeeded(`hei_prop_hei_cash_trolly_01`)
        end
    end

    if currentTime - info.lastInit > 11000 then
        if not info.audioPlayed then
            PlaySoundFrontend(-1, "lets_go_boys", "dlc_bankheist_setupone_soundset", false)
            info.audioPlayed = true
        end
    end

    HideHUDThisFrame()
end

local function cleanViewHackedCameras(info)
    RenderScriptCams(false, false, 0, false, false)
    SetCamActive(info.cameraHandle)
    DestroyCam(info.cameraHandle)
    info.cameraHandle = nil
    info.lastCameraStage = nil
    info.lastCameraTransition = nil

    ClearTimecycleModifier()

    for _, handle in ipairs(info.goldTrollieHandles) do
        DeleteEntity(handle)
    end
    info.goldTrollieHandles = nil
    SetModelAsNoLongerNeeded(`hei_prop_hei_cash_trolly_01`)

    CORRUPT.showUI()
    SetPlayerControl(PlayerId(), true, 0)
    info.audioPlayed = nil
end

----------- [[ STAGE: EXIT_BANK ]] -----------

local function initExitBank(info)
    info.exitBlip = AddBlipForCoord(info.lestersFactoryPosition.x, info.lestersFactoryPosition.y, info.lestersFactoryPosition.z)
    SetBlipRoute(info.exitBlip, true)

    info.audioPlayed = false
end

local function runExitBank(info)
    onUpdateWorldPeds(false)
    disableRunningAndSprintingInside()
    checkPlayerIsBeingSilent(info)
    drawPlayerCount(info)
    ensureSecureDoorsAreLocked()

    if GetGameTimer() - info.lastInit > 20000 then
        if not info.audioPlayed then
            PlaySoundFrontend(-1, "make_phone_calls", "dlc_bankheist_setupone_soundset", false)
            info.audioPlayed = true
        end
    end

    drawNativeText("Return to the ~y~factory~w~")
end

local function cleanExitBank(info)
    RemoveBlip(info.exitBlip)
    info.exitBlip = nil
    info.audioPlayed = nil
end

----------- [[ STAGE: EXIT_BANK_ALERTED ]] -----------

local function initExitBankAlerted(info)
    local startedLoading = GetGameTimer()
    while not RequestScriptAudioBank("ALARM_BELL_02") do
        if GetGameTimer() - startedLoading > 2000 then
            print("Failed to load bell audio bank")
            ReleaseNamedScriptAudioBank("ALARM_BELL_02")
            break
        end
        Citizen.Wait(0)
    end

    info.alarmSounds = {}
    for _, positon in ipairs(info.alarmPositions) do
        local sound = GetSoundId()
        PlaySoundFromCoord(info.alarmSound, "Bell_02", positon.x, positon.y, positon.z, "ALARMS_SOUNDSET", false, 0, false)
        info.alarmSounds[#info.alarmSounds + 1] = sound
    end

    local pos = info.alarmTurnOnCamera.position
    local rot = info.alarmTurnOnCamera.rotation
    info.alarmCamera = CreateCamWithParams("DEFAULT_SCRIPTED_CAMERA", pos.x, pos.y, pos.z, rot.x, rot.y, rot.z, 60.0, false, 2)
    SetCamActive(info.alarmCamera, true)
    RenderScriptCams(true, false, 0, false, false)

    info.alarmTurnOnTime = GetGameTimer()
    info.alarmLastFlashed = GetGameTimer()

    AddRelationshipGroup("SECURITY_ATTACK")
    SetRelationshipBetweenGroups(0, `SECURITY_ATTACK`, `SECURITY_ATTACK`)

    local myGroup = GetPedRelationshipGroupHash(PlayerPedId())
    SetRelationshipBetweenGroups(5, `SECURITY_ATTACK`, myGroup)
    SetRelationshipBetweenGroups(5, myGroup, `SECURITY_ATTACK`)

    info.exitBlip = AddBlipForCoord(info.lestersFactoryPosition.x, info.lestersFactoryPosition.y, info.lestersFactoryPosition.z)
    SetBlipRoute(info.exitBlip, true)

    SetFakeWantedLevel(3)
    info.sentAlert = nil

    PlaySoundFrontend(-1, "you_fucking_stupid", "dlc_bankheist_setupone_soundset", false)
    info.hurryUpStage = 1
end

local function runExitBankAlerted(info)
    onUpdateWorldPeds(true)
    drawPlayerCount(info)
    ensureSecureDoorsAreLocked()

    local currentTime = GetGameTimer()

    if info.alarmCamera and currentTime - info.alarmTurnOnTime > 2000 then
        RenderScriptCams(false, false, 0, false, false)
        SetCamActive(info.alarmCamera, false)
        DestroyCam(info.alarmCamera)
        info.alarmCamera = nil
        info.alarmTurnOnTime = nil
    end

    if currentTime - info.alarmLastFlashed > 500 then
        for _, position in ipairs(info.alarmPositions) do
            local intensity = (info.alarmCamera and 10.0 or 2.5)
            DrawLightWithRange(position.x - 0.5, position.y - 0.5, position.z, 255, 0, 0, 5.0, intensity)
            DrawLightWithRange(position.x + 0.5, position.y + 0.5, position.z, 255, 0, 0, 5.0, intensity)
            DrawLightWithRange(position.x, position.y, position.z, 255, 0, 0, 5.0, intensity)
        end

        if currentTime - info.alarmLastFlashed > 500 then
            info.alarmLastFlashed = currentTime
        end
    end

    if info.hurryUpStage < 3 then
        if currentTime - info.lastInit > (120000 * info.hurryUpStage) then
            if info.hurryUpStage == 1 then
                PlaySoundFrontend(-1, "where_you_at", "dlc_bankheist_setupone_soundset", false)
            elseif info.hurryUpStage == 2 then
                PlaySoundFrontend(-1, "hurry_up_get_here", "dlc_bankheist_setupone_soundset", false)
            end
            info.hurryUpStage = info.hurryUpStage + 1
        end
    end

    drawNativeText("Return to the ~y~factory~w~")
end

local function cleanExitBankAlerted(info)
    RemoveBlip(info.exitBlip)
    info.exitBlip = nil

    if info.alarmSounds then
        for _, sound in ipairs(info.alarmSounds) do
            StopSound(sound)
            ReleaseSoundId(sound)
        end
    end
    info.alarmSounds = nil

    info.alarmLastFlashed = nil
    info.hurryUpStage = nil

    RemoveRelationshipGroup(`SECURITY_ATTACK`)
    SetFakeWantedLevel(0)
end

----------- [[ CONFIGURATION ]] -----------

local heist = {}

heist.stages = {
    {
        name = "DRIVE_TO_BANK",
        init = initDriveToBank,
        run = runDriveToBank,
        clean = cleanDriveToBank
    },
    {
        name = "GO_TO_ENTRANCE",
        init = initGoToEntrance,
        run = runGoToEntrance,
        clean = cleanGotoEntrance
    },
    {
        name = "FIND_COMPUTER",
        init = initFindComputer,
        run = runFindComputer
    },
    {
        name = "HACK_COMPUTER",
        init = initHackComputer,
        run = runHackComputer,
        clean = cleanHackComputer
    },
    {
        name = "VIEW_HACKED_CAMERAS",
        init = initViewHackedCameras,
        run = runViewHackedCameras,
        clean = cleanViewHackedCameras
    },
    {
        name = "EXIT_BANK",
        init = initExitBank,
        run = runExitBank,
        clean = cleanExitBank,
        isFinishStage = true
    },
    {
        name = "EXIT_BANK_ALERTED",
        init = initExitBankAlerted,
        run = runExitBankAlerted,
        clean = cleanExitBankAlerted,
        isFinishStage = true
    }
}

heist.finish = function()
    TriggerMusicEvent("BST_STOP")
    ReleaseNamedScriptAudioBank("ALARM_BELL_02")
end

return heist