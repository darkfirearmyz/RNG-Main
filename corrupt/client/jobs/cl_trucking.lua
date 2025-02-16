-- Create the main RageUI menu for corrupt trucking
RMenu.Add("corrupttruckmenu", "job", RageUI.CreateMenu("", "~b~Corrupt Trucking"))

local a = module("cfg/cfg_trucking")  -- Config module
local b = ""  -- Job ID or name placeholder
local c = false  -- Menu open state
local d = {vehicle = nil, trailer = nil, checkpoint = nil}  -- Job elements
local e, i, j = 1, false, false  -- Indices and toggle states
local f, g, h = {}, {}, {}  -- Blips, checkpoints, tracking tables
globalIsDoingTruckRoute, globalCurrentJob, globalJobOnPause = false, {}, false  -- Global job states

-- Initialize truck job markers on map
for k, l in pairs(a.jobs) do
    if l.config then
        local pos, blipLabel = l.config[1], l.config[2]
        tvRP.addBlip(pos.x, pos.y, pos.z, 67, 5, blipLabel)
        tvRP.addMarker(pos.x, pos.y, pos.z, 0.7, 0.7, 0.5, 0, 255, 125, 125, 50, 39, true, true)
    end
end

-- Main menu logic for RageUI
RageUI.CreateWhile(1.0, RMenu:Get("corrupttruckmenu", "job"), nil, function()
    RageUI.IsVisible(RMenu:Get("corrupttruckmenu", "job"), true, false, true, function()
        if b ~= "" then
            if not globalIsDoingTruckRoute then
                RageUI.Button("Start Job", nil, {RightLabel = "→→→"}, true, function(p, q, r)
                    if r then
                        if GetResourceKvpInt("corrupt") == 1 then
                            TriggerServerEvent("corrupt:startTruckerJob", b, false)
                        else
                            sequence()  -- Begin job start sequence if cutscene not done
                            TriggerServerEvent("corrupt:startTruckerJob", b, false)
                            SetResourceKvpInt("corrupt_trucking_done_cutscene", 1)
                        end
                    end
                end)
            else
                -- Display active job state with End Job button
                RageUI.Separator("~r~You are currently on a job.")
                RageUI.Button("End Job", nil, {RightLabel = "→→→"}, true, function(p, q, r)
                    if r then TriggerServerEvent("corrupt:endTruckerJob", "~r~You ended the job") end
                end)
            end
        end
    end)
end)

-- Event to handle player spawn
AddEventHandler("corrupt:onClientSpawn", function(spawned, _)
    if spawned then
        for k, l in pairs(a.jobs) do
            local pos, jobName = l.config[1], l.config[2]
            CORRUPT.createArea("trucking_" .. k, pos, 1.15, 6, function() drawNativeNotification("Press ~INPUT_PICKUP~ to open the Trucking menu.") end, closeTruckerMenu, function()
                if globalOnTruckJob then openTruckerMenu(k) else tvRP.notify("~r~You aren't clocked in as a Trucker. Head to city hall to sign up.") end
            end, {job = k})
        end
    end
end)

-- Open and close menu functions
function openTruckerMenu(jobID)
    b, c = jobID, true
    RMenu:Get("corrupttruckmenu", "job"):SetSubtitle(a.jobs[jobID]["config"][2])
    RageUI.Visible(RMenu:Get("corrupttruckmenu", "job"), true)
end

function closeTruckerMenu()
    c = false
    RageUI.Visible(RMenu:Get("corrupttruckmenu", "job"), false)
end

-- Helper function to safely retrieve a random table key
function getRandomTableKey(tbl)
    math.randomseed(GetGameTimer())
    return math.random(1, #tbl)
end

-- Main job start event handler
RegisterNetEvent("corrupt:startTruckerJobCl")
AddEventHandler("corrupt:startTruckerJobCl", function(jobData, isNextJob)
    globalCurrentJob = jobData
    local job = jobData[1]
    local trailerType = getRandomTableKey(job.trailers)
    -- Trailer spawn setup based on whether it's the first job or a continuation
    local spawnKey = isNextJob and "pickup" or "docks"
    local spawnCoords = job.trailerSpawns[spawnKey][e][2]
    d.trailer = spawnTrailer(job.trailers[trailerType][1], spawnCoords, job.trailerSpawns[spawnKey][e][1], job.trailers[trailerType][2])
    createDistanceCheckForSpawn(spawnCoords, job.trailers[trailerType][1], job.trailerSpawns[spawnKey][e][1])
end)

-- Function to attach trailer when near
Citizen.CreateThread(function()
    while true do
        local playerPed = PlayerPedId()
        if IsPedInAnyVehicle(playerPed, false) then
            local trailerPos = GetEntityCoords(d.trailer)
            local vehicle = GetVehiclePedIsIn(playerPed, false)
            if #(trailerPos - GetEntityCoords(vehicle)) <= 9.75 and not IsControlPressed(0, 74) and not IsVehicleAttachedToTrailer(vehicle) and not i then
                AttachVehicleToTrailer(vehicle, d.trailer, 1.0)
            end
        end
        Wait(1000)
    end
end)

-- Register and handle other events as needed (e.g., job end, payouts)

-- End of script adjustments
