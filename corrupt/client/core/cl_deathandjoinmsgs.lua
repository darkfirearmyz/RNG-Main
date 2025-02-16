local a = false
local b = true
RegisterCommand("togglekillfeed",function()
    if not a then
        b = not b
        if b then
            tvRP.notify("~g~Killfeed is now enabled")
            SendNUIMessage({type = "killFeedEnable"})
        else
            tvRP.notify("~r~Killfeed is now disabled")
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)
RegisterNetEvent("CORRUPT:showHUD",function(c)
    a = not c
    if b then
        if c then
            SendNUIMessage({type = "killFeedEnable"})
        else
            SendNUIMessage({type = "killFeedDisable"})
        end
    end
end)

RegisterNetEvent("CORRUPT:newKillFeed",function(d, e, f, g, h, i, j, headshotKill)
    if GetIsLoadingScreenActive() then
        return
    end
    local k = "other"
    local l = CORRUPT.getPlayerName(CORRUPT.getPlayerId())
    if e == l or d == l then
        k = "self"
    end
    local killFeedKvp = GetResourceKvpString("CORRUPT_oldkillfeed") or "false"
    if killFeedKvp == "false" then
        oldKillfeed = false
    else
        oldKillfeed = true
    end
    if f == "Unknown" then
        g = true
    end
    if oldKillfeed and (tvRP.isPlatClub() or tvRP.isPlusClub()) then
        if g then
            tvRP.notify('~o~'..e..' ~w~died.')
        elseif headshotKill then
            tvRP.notify('~o~'..d..' ~w~headshotted ~o~'..e..'~w~.')
        else
            tvRP.notify('~o~'..d..' ~w~killed ~o~'..e..'~w~.')
        end
    else
        SendNUIMessage({type = "addKill",victim = e,killer = d,weapon = f,suicide = g,victimGroup = i,killerGroup = j,range = h,uuid = generateUUID("kill", 10, "alphabet"),category = k,isHeadshot = headshotKill})
    end
end)