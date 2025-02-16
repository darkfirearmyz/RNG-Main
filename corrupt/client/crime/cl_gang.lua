local a = nil
local b = {}
local c = nil
local d = nil
local e = 18
local f = 82
local g = 228
local h = nil
local i = 1
local j = 1
local k = nil
local l = {}
local m = nil
local n = false
local o = nil
local p = {}
local q = nil
local r = 1
local s = false
local t = 0
local u = {
    ["White"] = {hud = 0, blip = 0},
    ["Red"] = {hud = 6, blip = 1},
    ["Green"] = {hud = 18, blip = 2},
    ["Blue"] = {hud = 9, blip = 3},
    ["Yellow"] = {hud = 12, blip = 5},
    ["Violet"] = {hud = 21, blip = 7},
    ["Pink"] = {hud = 24, blip = 8},
    ["Orange"] = {hud = 15, blip = 17}
}
local v = u["Red"]
local w = GetResourceKvpString("corrupt_gang_blip_colour") or "Red"
local function x()
    if CORRUPT.isGuestGangSelected() and o then
        return o
    else
        return h or o
    end
end
local function y(z)
    local A = {}
    for B, C in pairs(z.members) do
        A[B] = C
    end
    for D, E in pairs(z.guests) do
        A[D] = E
    end
    return A
end
RegisterNetEvent(
    "CORRUPT:inviteRecieved",
    function(F)
        b[table.count(b)] = F
        tvRP.notify("~g~Gang invite recieved from " .. F)
    end
)
RegisterNetEvent(
    "CORRUPT:guestInviteRecieved",
    function(F)
        p[table.count(p)] = F
        tvRP.notify("~g~Guest invite recieved from " .. F)
    end
)
local function G()
    AddTextEntry("FMMC_MPM_NA", "Enter amount:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Enter amount:", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local H = GetOnscreenKeyboardResult()
        return H
    end
    return nil
end
local function I()
    AddTextEntry("FMMC_MPM_NA", "Enter Gang Name:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local H = GetOnscreenKeyboardResult()
        return H
    end
    return nil
end
local function J()
    AddTextEntry("FMMC_MPM_NA", "Enter Perm ID to invite:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local H = GetOnscreenKeyboardResult()
        return H
    end
    return nil
end
local function tag()
    AddTextEntry("FMMC_MPM_NA", "Enter Chat Tag max 4 characters:")
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "", "", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local H = GetOnscreenKeyboardResult()
        if H ~= nil and H ~= "" and string.len(H) <= 4 then
            return H
        end
    end
    return nil
end
local function K(L)
    AddTextEntry("FMMC_MPM_NA", L)
    DisplayOnscreenKeyboard(1, "FMMC_MPM_NA", "Are you sure?", "Yes | No", "", "", "", 30)
    while UpdateOnscreenKeyboard() == 0 do
        DisableAllControlActions(0)
        Wait(0)
    end
    if GetOnscreenKeyboardResult() then
        local H = GetOnscreenKeyboardResult()
        if H == "yes" or H == "Yes" then
            return true
        else
            return false
        end
    end
    return false
end
local function M(z)
    local N = {}
    for O, C in pairs(z.members) do
        local P = table.copy(C)
        P.user_id = O
        table.insert(N, P)
    end
    for O, E in pairs(z.guests) do
        local Q = table.copy(E)
        Q.rank = 0
        Q.lastLogin = "Offline"
        Q.user_id = O
        table.insert(N, Q)
    end
    local R = {}
    local S = z == h and i or r
    local T = (S - 1) * 10 + 1
    local U = table.count(z.members) + table.count(z.guests)
    for V = T, math.min(T + 10, U + 1) - 1 do
        table.insert(R, N[V])
    end
    if #R == 0 then
        if z == h then
            i = math.max(i - 1, 1)
        else
            r = math.max(r - 1, 1)
        end
    end
    return R
end
local function W()
    local X = h.logs
    if n and h.logs then
        X = {}
        for Y, Z in pairs(h.logs) do
            if Z.user_id > 0 then
                table.insert(X, Z)
            end
        end
    end
    return X
end
local function _(X)
    local a0 = {}
    if X then
        local a1 = (j - 1) * 10 + 1
        for V = a1, math.min(a1 + 10, #X + 1) - 1 do
            table.insert(a0, X[V])
        end
        if #a0 == 0 then
            j = math.max(j - 1, 1)
        end
    end
    return a0
end
local function a2()
    if h then
        local a3 = h.members[CORRUPT.getUserId()]
        if a3 then
            return a3.rank
        end
    end
    return 0
end
local function a4()
    if a == "noGang" then
        DisableControlAction(0, 200, true)
        if CORRUPT.isNewPlayer() then
            drawNativeNotification("Press ~INPUT_SELECT_CHARACTER_MICHAEL~ to toggle the Gang Menu.")
        end
        DrawRect(0.471, 0.329, 0.285, -0.005, 0, 168, 255, 204)
        DrawRect(0.471, 0.304, 0.285, 0.046, 0, 0, 0, 150)
        DrawRect(0.471, 0.428, 0.285, 0.194, 0, 0, 0, 150)
        DrawRect(
            0.383,
            0.442,
            0.066,
            0.046,
            CreateGangSelectionRed,
            CreateGangSelectionGreen,
            CreateGangSelectionBlue,
            150
        )
        DrawRect(0.469, 0.442, 0.066, 0.046, JoinGangSelectionRed, JoinGangSelectionGreen, JoinGangSelectionBlue, 150)
        DrawAdvancedText(0.558, 0.303, 0.005, 0.0028, 0.539, "CORRUPT Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.478, 0.442, 0.005, 0.0028, 0.473, "Create Gang", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.564, 0.443, 0.005, 0.0028, 0.473, "Join Gang", 255, 255, 255, 255, 4, 0)
        DrawRect(0.561, 0.377, 0.065, -0.003, 0, 168, 255, 204)
        DrawAdvancedText(0.654, 0.37, 0.005, 0.0028, 0.364, "Invite list", 255, 255, 255, 255, 4, 0)
        for a5, a6 in pairs(b) do
            DrawAdvancedText(0.656, 0.398 + 0.020 * a5, 0.005, 0.0028, 0.234, a6, 255, 255, 255, 255, 0, 0)
            if CursorInArea(0.525, 0.59, 0.38 + 0.02 * a5, 0.396 + 0.02 * a5) and a5 ~= c then
                DrawRect(0.56, 0.39 + 0.02 * a5, 0.062, 0.019, 0, 168, 255, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    c = a5
                end
            elseif a5 == c then
                DrawRect(0.56, 0.39 + 0.02 * a5, 0.062, 0.019, 0, 168, 255, 150)
            end
        end
        if CursorInArea(0.35, 0.415, 0.415, 0.46) then
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 168
            CreateGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                createGangName = I()
                if createGangName ~= nil and createGangName ~= "null" and createGangName ~= "" then
                    TriggerServerEvent("CORRUPT:createGang", createGangName)
                else
                    tvRP.notify("~r~No gang name entered!")
                end
            end
        else
            CreateGangSelectionRed = 0
            CreateGangSelectionGreen = 0
            CreateGangSelectionBlue = 0
        end
        if CursorInArea(0.435, 0.51, 0.415, 0.46) then
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 168
            JoinGangSelectionBlue = 255
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if c ~= nil then
                    c = b[c]
                    TriggerServerEvent("CORRUPT:addUserToGang", c)
                    b = {}
                    a = "gang"
                else
                    tvRP.notify("~r~No gang invite selected")
                end
            end
        else
            JoinGangSelectionRed = 0
            JoinGangSelectionGreen = 0
            JoinGangSelectionBlue = 0
        end
        DrawAdvancedText(0.478, 0.372, 0.005, 0.0028, 0.473, "Guests", 255, 255, 255, 255, 4, 0)
        if CursorInAreaRect(0.383, 0.372, 0.066, 0.046) then
            DrawRect(0.383, 0.372, 0.066, 0.046, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "guest"
            end
        else
            DrawRect(0.383, 0.372, 0.066, 0.046, 0, 0, 0, 150)
        end
        if o then
            DrawAdvancedText(0.564, 0.372, 0.005, 0.0028, 0.473, "Settings", 255, 255, 255, 255, 4, 0)
            if CursorInAreaRect(0.469, 0.372, 0.066, 0.046) then
                DrawRect(0.469, 0.372, 0.066, 0.046, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    a = "settings"
                end
            else
                DrawRect(0.469, 0.372, 0.066, 0.046, 0, 0, 0, 150)
            end
        end
    end
    if a == "funds" then
        DrawRect(0.501, 0.558, 0.421, 0.326, 0, 0, 0, 150)
        DrawRect(0.501, 0.374, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.378, 0.005, 0.0028, 0.48, "corrupt gang - funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.581, 0.464, 0.005, 0.0028, 0.5, "Gang Funds", 255, 255, 255, 255, 0, 0)
        DrawAdvancedText(
            0.581,
            0.502,
            0.005,
            0.0028,
            0.4,
            "£" .. getMoneyStringFormatted(h.displayMoney),
            25,
            199,
            65,
            255,
            0,
            0
        )
        DrawAdvancedText(0.436, 0.578, 0.005, 0.0028, 0.4, "Deposit (2% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.536, 0.578, 0.005, 0.0028, 0.4, "Deposit All (2% Fee)", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.637, 0.578, 0.005, 0.0028, 0.4, "Withdraw", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.737, 0.578, 0.005, 0.0028, 0.4, "Withdraw All", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.3083, 0.3718, 0.5490, 0.5999) then
            DrawRect(0.341, 0.576, 0.075, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = G()
                if amount ~= nil then
                    TriggerServerEvent("CORRUPT:depositGangBalance", amount)
                else
                    tvRP.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.341, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4083, 0.4718, 0.5490, 0.5999) then
            DrawRect(0.441, 0.576, 0.075, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                TriggerServerEvent("CORRUPT:depositAllGangBalance")
            end
        else
            DrawRect(0.441, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5088, 0.5739, 0.5481, 0.6018) then
            DrawRect(0.542, 0.576, 0.075, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                amount = G()
                if amount ~= nil then
                    if a2() >= 3 then
                        TriggerServerEvent("CORRUPT:withdrawGangBalance", amount)
                    else
                        tvRP.notify("~r~You don't have a high enough rank to withdraw")
                    end
                else
                    tvRP.notify("~r~No amount entered!")
                end
            end
        else
            DrawRect(0.542, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6088, 0.6739, 0.5481, 0.6018) then
            DrawRect(0.642, 0.576, 0.075, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if a2() >= 3 then
                    TriggerServerEvent("CORRUPT:withdrawAllGangBalance")
                else
                    tvRP.notify("~r~You don't have a high enough rank to withdraw")
                end
            end
        else
            DrawRect(0.642, 0.576, 0.075, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "gang"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "members" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CORRUPT gang - members", 255, 255, 255, 255, 7, 0)
        DrawRect(0.448, 0.52, 0.295, 0.291, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.359, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.506, 0.359, 0.005, 0.0028, 0.4, "ID", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.555, 0.359, 0.005, 0.0028, 0.4, "Rank", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.625, 0.359, 0.005, 0.0028, 0.4, "Last Seen", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.675, 0.359, 0.005, 0.0028, 0.4, "Pin", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(0.746, 0.39, 0.005, 0.0028, 0.4, "Promote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.465, 0.005, 0.0028, 0.4, "Demote", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.54, 0.005, 0.0028, 0.4, "Kick", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.746, 0.615, 0.005, 0.0028, 0.4, "Invite", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.491, 0.695, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.581, 0.695, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        local U = table.count(h.members) + table.count(h.guests)
        DrawAdvancedText(
            0.536,
            0.695,
            0.005,
            0.0028,
            0.4,
            tostring(i) .. "/" .. tostring(math.ceil(U / 10.0)),
            255,
            255,
            255,
            255,
            4,
            0
        )
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        for a5, C in pairs(M(h)) do
            local a7 = "Unknown"
            if C.rank == 0 then
                a7 = "Guest"
            elseif C.rank == 1 then
                a7 = "Recruit"
            elseif C.rank == 2 then
                a7 = "Member"
            elseif C.rank == 3 then
                a7 = "Senior"
            elseif C.rank >= 4 then
                a7 = "Leader"
            end
            DrawAdvancedText(0.449, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, C.name, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.506, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, C.user_id, 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.555, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, a7, 255, 255, 255, 255, 6, 0)
            local a8 = C.lastLogin
            if fullPlayerListData[C.user_id] then
                a8 = "~g~Online"
            end
            DrawAdvancedText(0.625, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, a8, 255, 255, 255, 255, 6, 0)
            local a9 = k.pinnedPlayers[C.user_id] and h.isAdvanced and "📌" or "⭕"
            DrawAdvancedText(0.675, 0.3665 + 0.0287 * a5, 0.005, 0.0028, 0.2, a9, 255, 255, 255, 255, 6, 0)
            if CursorInArea(0.3005, 0.5955, 0.3731 + 0.0287 * (a5 - 1), 0.4018 + 0.0287 * (a5 - 1)) and d ~= C.user_id then
                DrawRect(0.448, 0.388 + 0.0287 * (a5 - 1), 0.295, 0.027, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    d = C.user_id
                end
            elseif d == C.user_id then
                DrawRect(0.448, 0.388 + 0.0287 * (a5 - 1), 0.295, 0.027, e, f, g, 150)
            end
            if CursorInArea(0.5755, 0.5955, 0.3731 + 0.0287 * (a5 - 1), 0.4018 + 0.0287 * (a5 - 1)) then
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    if h.isAdvanced then
                        if k.pinnedPlayers[C.user_id] then
                            k.pinnedPlayers[C.user_id] = nil
                        else
                            k.pinnedPlayers[C.user_id] = true
                        end
                        SetResourceKvp("corrupt_gang_pinned", json.encode(k.pinnedPlayers))
                    else
                        notify("~r~You must have the advanced gang license to pin a player.")
                    end
                end
            end
        end
        if CursorInArea(0.6182, 0.6822, 0.360, 0.416) then
            DrawRect(0.651, 0.388, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if d ~= nil and h then
                    if a2() >= 4 then
                        if h.members[d] then
                            TriggerServerEvent("CORRUPT:promoteUser", tonumber(d))
                        else
                            notify("~r~You can not promote a guest.")
                        end
                    else
                        tvRP.notify("~r~You don't have permission to promote!")
                    end
                else
                    tvRP.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.388, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.435, 0.491) then
            DrawRect(0.651, 0.463, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if d ~= nil and h then
                    if a2() >= 4 then
                        if h.members[d] then
                            TriggerServerEvent("CORRUPT:demoteUser", d)
                        else
                            notify("~r~You can not demote a guest.")
                        end
                    else
                        tvRP.notify("~r~You don't have permission to demote!")
                    end
                else
                    tvRP.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.463, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.510, 0.566) then
            DrawRect(0.651, 0.538, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if d ~= nil then
                    if a2() >= 3 then
                        if K("Are you sure?") then
                            if h.members[d] then
                                TriggerServerEvent("CORRUPT:kickMemberFromGang", d)
                            else
                                TriggerServerEvent("CORRUPT:kickGuestFromGang", d)
                            end
                        end
                    else
                        tvRP.notify("~r~You don't have permission to kick!")
                    end
                else
                    tvRP.notify("~r~No gang member selected")
                end
            end
        else
            DrawRect(0.651, 0.538, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6182, 0.6822, 0.585, 0.641) then
            DrawRect(0.651, 0.613, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                local aa = J()
                if aa ~= nil and tonumber(aa) then
                    if a2() >= 2 then
                        TriggerServerEvent("CORRUPT:inviteUserToGang", tonumber(aa))
                    else
                        tvRP.notify("~r~You don't have permission to invite players")
                    end
                else
                    tvRP.notify("Invalid Perm ID entered")
                end
            end
        else
            DrawRect(0.651, 0.613, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3735, 0.4185, 0.6768, 0.7074) then
            DrawRect(0.396, 0.693, 0.045, 0.033, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if i <= 1 then
                    tvRP.notify("~r~Lowest page reached")
                else
                    i = i - 1
                end
            end
        else
            DrawRect(0.396, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.4635, 0.5085, 0.6712, 0.7064) then
            DrawRect(0.486, 0.693, 0.045, 0.033, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if i >= math.ceil(U / 10.0) then
                    tvRP.notify("~r~Max page reached")
                else
                    i = i + 1
                end
            end
        else
            DrawRect(0.486, 0.693, 0.045, 0.033, 0, 0, 0, 150)
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "gang"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "logs" then
        local X = W()
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CORRUPT gang - logs", 255, 255, 255, 255, 7, 0)
        DrawRect(0.502, 0.52, 0.387, 0.286, 0, 0, 0, 150)
        DrawAdvancedText(0.449, 0.365, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.51, 0.365, 0.005, 0.0028, 0.4, "UserID", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.583, 0.365, 0.005, 0.0028, 0.4, "Date", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.757, 0.365, 0.005, 0.0028, 0.4, "Amount", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(0.673, 0.365, 0.005, 0.0028, 0.4, "New Balance", 255, 255, 255, 255, 4, 0)
        DrawAdvancedText(
            0.592,
            0.6925,
            0.005,
            0.0028,
            0.4,
            tostring(j) .. "/" .. tostring(math.ceil(table.count(X or {}) / 10.0)),
            255,
            255,
            255,
            255,
            4,
            0
        )
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "gang"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        for a5, Z in pairs(_(X)) do
            local ab = Z.amount >= 0 and 50 or 255
            local ac = Z.amount >= 0 and 255 or 50
            local ad = 50
            local ae = Z.user_id == -1 and "N/A" or tostring(Z.user_id)
            DrawAdvancedText(0.449, 0.365 + 0.0287 * a5, 0.005, 0.0028, 0.4, Z.name, ab, ac, ad, 255, 6, 0)
            DrawAdvancedText(0.51, 0.365 + 0.0287 * a5, 0.005, 0.0028, 0.4, ae, ab, ac, ad, 255, 6, 0)
            DrawAdvancedText(0.583, 0.365 + 0.0287 * a5, 0.005, 0.0028, 0.4, Z.date, ab, ac, ad, 255, 6, 0)
            DrawAdvancedText(
                0.673,
                0.365 + 0.0287 * a5,
                0.005,
                0.0028,
                0.4,
                "£" .. getMoneyStringFormatted(Z.newBalance),
                ab,
                ac,
                ad,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.757,
                0.365 + 0.0287 * a5,
                0.005,
                0.0028,
                0.4,
                "£" .. getMoneyStringFormatted(math.abs(Z.amount)),
                ab,
                ac, 
                ad,
                255,
                6,
                0
            )
        end
        DrawAdvancedText(0.547, 0.692, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.4195, 0.4845, 0.6768, 0.7074) then
            DrawRect(0.452, 0.69, 0.065, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if j <= 1 then
                    tvRP.notify("~r~Lowest page reached")
                else
                    j = j - 1
                end
            end
        else
            DrawRect(0.452, 0.69, 0.065, 0.036, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.639, 0.692, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.5125, 0.5775, 0.6712, 0.7064) then
            DrawRect(0.545, 0.69, 0.065, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if j >= math.ceil(table.count(h.logs) / 10.0) then
                    tvRP.notify("~r~Max page reached")
                else
                    j = j + 1
                end
            end
        else
            DrawRect(0.545, 0.69, 0.065, 0.036, 0, 0, 0, 150)
        end
        DrawAdvancedText(0.415, 0.693, 0.005, 0.0028, 0.4, n and "Show Turf" or "Hide Turf", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.2985, 0.3435, 0.6712, 0.7064) then
            DrawRect(0.321, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                n = not n
            end
        else
            DrawRect(0.321, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "settings" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CORRUPT gang - settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.7, 0.398, 0.005, 0.0028, 0.46, "Permissions Guide", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.436,
            0.005,
            0.0028,
            0.46,
            "A recruit can deposit to the gang funds only.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.472, 0.005, 0.0028, 0.46, "A member can invite users", 255, 255, 255, 255, 6, 0)
        DrawAdvancedText(
            0.7,
            0.51,
            0.005,
            0.0028,
            0.46,
            "A Senior can invite and kick members",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(
            0.7,
            0.572,
            0.005,
            0.0028,
            0.46,
            "A Leader can promote and demote members.",
            255,
            255,
            255,
            255,
            6,
            0
        )
        DrawAdvancedText(0.7, 0.532, 0.005, 0.0028, 0.46, "and withdraw from the gang funds.", 255, 255, 255, 255, 6, 0)
        if h then
            DrawAdvancedText(0.451, 0.616, 0.005, 0.0028, 0.4, "Leave Gang", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.554, 0.615, 0.005, 0.0028, 0.4, "Disband Gang", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.451, 0.693, 0.005, 0.0028, 0.4, "Set Chat Tag", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.551, 0.693, 0.005, 0.0028, 0.4, "Set Gang Fit", 255, 255, 255, 255, 4, 0)
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        local af = x()
        if h then
            if CursorInArea(0.3187, 0.3937, 0.5712, 0.6462) then
                DrawRect(0.357, 0.61, 0.075, 0.076, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if af == h then
                        if K("Are you sure?") then
                            TriggerServerEvent("CORRUPT:leaveGang")
                            a = "noGang"
                            setCursor(0)
                            SetPlayerControl(PlayerId(), 1, 0)
                        end
                    else
                        notify("~r~You must have your main gang selected to use this.")
                    end
                end
            else
                DrawRect(0.357, 0.61, 0.075, 0.076, 0, 0, 0, 150)
            end
            if CursorInArea(0.4197, 0.4932, 0.5712, 0.6462) then
                DrawRect(0.457, 0.61, 0.075, 0.076, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if af == h then
                        if a2() >= 4 then
                            if K("Are you sure?") == true then
                                TriggerServerEvent("CORRUPT:deleteGang")
                            end
                        else
                            tvRP.notify("~r~You don't have permission to disband!")
                        end
                    else
                        notify("~r~You must have your main gang selected to use this.")
                    end
                end
            else
                DrawRect(0.457, 0.61, 0.075, 0.076, 0, 0, 0, 150)
            end
            if CursorInArea(0.41, 0.49, 0.6712, 0.7064) then
                DrawRect(0.457, 0.689, 0.075, 0.036, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if a2() == 4 then
                        TriggerServerEvent("CORRUPT:setGangFit")
                    else
                        tvRP.notify("~r~You don't have permission to set the chat tag!")
                    end
                end
            else
                DrawRect(0.457, 0.689, 0.075, 0.036, 0, 0, 0, 150)
            end
            if CursorInArea(0.31, 0.39, 0.6712, 0.7064) then
                DrawRect(0.357, 0.689, 0.075, 0.036, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if a2() == 4 then
                        local tag = tag()
                        if tag ~= nil and tostring(tag) then
                            TriggerServerEvent("CORRUPT:setGangChatTag", tag)
                        end
                    else
                        tvRP.notify("~r~You don't have permission to set the chat tag!")
                    end
                end
            else
                DrawRect(0.357, 0.689, 0.075, 0.036, 0, 0, 0, 150)
            end
        end
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if h then
                    a = "gang"
                else
                    a = "noGang"
                end
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
        if af.isAdvanced then
            local ag = k.blips and "Disable" or "Enable"
            DrawAdvancedText(0.451, 0.416, 0.005, 0.0028, 0.4, ag .. " Blips", 255, 255, 255, 255, 6, 0)
            if CursorInArea(0.3187, 0.3937, 0.3712, 0.4462) then
                DrawRect(0.357, 0.41, 0.075, 0.076, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    k.blips = not k.blips
                    TriggerEvent("CORRUPT:deleteGangBlips")
                    if not k.blips then
                        TriggerEvent("CORRUPT:deleteGangBlips")
                        TriggerServerEvent("CORRUPT:setGangBlipsEnabled", nil)
                    else
                        local ah = x() == h and "own" or "guest"
                        TriggerServerEvent("CORRUPT:setGangBlipsEnabled", ah, true)
                    end
                    SetResourceKvp("corrupt_gang_blips", tostring(k.blips))
                end
            else
                DrawRect(0.357, 0.41, 0.075, 0.076, 0, 0, 0, 150)
            end
            local ai = k.pings and "Disable" or "Enable"
            DrawAdvancedText(0.554, 0.415, 0.005, 0.0028, 0.4, ai .. " Pings", 255, 255, 255, 255, 4, 0)
            if CursorInArea(0.4197, 0.4932, 0.3712, 0.4462) then
                DrawRect(0.457, 0.41, 0.075, 0.076, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    k.pings = not k.pings
                    SetResourceKvp("corrupt_gang_pings", tostring(k.pings))
                end
            else
                DrawRect(0.457, 0.41, 0.075, 0.076, 0, 0, 0, 150)
            end
            local aj = k.names and "Disable" or "Enable"
            DrawAdvancedText(0.451, 0.516, 0.005, 0.0028, 0.4, aj .. " Names", 255, 255, 255, 255, 6, 0)
            if CursorInArea(0.3187, 0.3937, 0.4712, 0.5462) then
                DrawRect(0.357, 0.51, 0.075, 0.076, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    k.names = not k.names
                    SetResourceKvp("corrupt_gang_names", tostring(k.names))
                end
            else
                DrawRect(0.357, 0.51, 0.075, 0.076, 0, 0, 0, 150)
            end
            if h then
                DrawAdvancedText(0.554, 0.515, 0.005, 0.0028, 0.4, "Rename Gang", 255, 255, 255, 255, 4, 0)
                if CursorInArea(0.4197, 0.4932, 0.4712, 0.5462) then
                    DrawRect(0.457, 0.51, 0.075, 0.076, e, f, g, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if h.isAdvanced then
                            local ak = I()
                            if ak ~= nil and ak ~= "null" and ak ~= "" then
                                TriggerServerEvent("CORRUPT:renameGang", ak)
                            else
                                tvRP.notify("~r~No gang name entered!")
                            end
                        else
                            notify("~r~Your main gang does not have the advanced license.")
                        end
                    end
                else
                    DrawRect(0.457, 0.51, 0.075, 0.076, 0, 0, 0, 150)
                end
            end
            local al, am, an = GetHudColour(u[w].hud)
            DrawAdvancedText(0.645, 0.63, 0.005, 0.0028, 0.46, "Your Blip Colour: ", 255, 255, 255, 255, 6, 0)
            DrawRect(0.62, 0.628, 0.05, 0.025, al, am, an, 255)
            if CursorInArea(0.595, 0.645, 0.6155, 0.6405) then
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    local ao = false
                    local ap = false
                    for aq in pairs(u) do
                        if aq == w then
                            ao = true
                        elseif ao then
                            w = aq
                            ap = true
                            break
                        end
                    end
                    if not ap then
                        for aq in pairs(u) do
                            w = aq
                            break
                        end
                    end
                    SetResourceKvp("corrupt_gang_colour", w)
                    TriggerServerEvent("CORRUPT:setPersonalGangBlipColour", w)
                end
            end
        else
            DrawAdvancedText(
                0.5,
                0.406,
                0.005,
                0.0028,
                0.4,
                "Purchase Advanced License\n(£25,000,000)",
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.5,
                0.476,
                0.005,
                0.0028,
                0.4,
                "NOTE:\nThis purchase is tied to the gang.\nAny member will be able to use the features.",
                255,
                255,
                255,
                255,
                6,
                0
            )
            if CursorInArea(0.3187, 0.4932, 0.3712, 0.5462) then
                DrawRect(0.407, 0.46, 0.175, 0.176, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    TriggerServerEvent("CORRUPT:purchaseAdvancedGangLicense")
                end
            else
                DrawRect(0.407, 0.46, 0.175, 0.176, 0, 0, 0, 150)
            end
        end
    end
    if a == "turfs" then
        DrawRect(0.501, 0.525, 0.481, 0.497, 0, 0, 0, 150)
        DrawRect(0.501, 0.3, 0.481, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.303, 0.005, 0.0028, 0.48, "CORRUPT gang - Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.5,
            0.345,
            0.005,
            0.0028,
            0.325,
            "Turf profits updated every 15 minutes",
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.38,
            0.005,
            0.0028,
            0.4,
            "Weed Turf - (Owned by " ..
                turfData[1].gangOwner ..
                    ") Commission - " ..
                        globalWeedCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[1].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.44,
            0.005,
            0.0028,
            0.4,
            "Cocaine Turf - (Owned by " ..
                turfData[2].gangOwner ..
                    ") Commission - " ..
                        globalCocaineCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[2].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.50,
            0.005,
            0.0028,
            0.4,
            "Meth Turf - (Owned by " ..
                turfData[3].gangOwner ..
                    ") Commission - " ..
                        globalMethCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[3].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.56,
            0.005,
            0.0028,
            0.4,
            "Heroin Turf - (Owned by " ..
                turfData[4].gangOwner ..
                    ") Commission - " ..
                        globalHeroinCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[4].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.62,
            0.005,
            0.0028,
            0.4,
            "Large Arms - (Owned by " ..
                turfData[5].gangOwner ..
                    ") Commission - " ..
                        globalLargeArmsCommission .. "% Profit - £" .. getMoneyStringFormatted(turfData[5].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.68,
            0.005,
            0.0028,
            0.4,
            "LSD North Turf - (Owned by " ..
                turfData[6].gangOwner ..
                    ") Commission - " ..
                        globalLSDNorthCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[6].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(
            0.369,
            0.74,
            0.005,
            0.0028,
            0.4,
            "LSD South Turf - (Owned by " ..
                turfData[7].gangOwner ..
                    ") Commission - " ..
                        globalLSDSouthCommissionPercent .. "% Profit - £" .. getMoneyStringFormatted(turfData[7].profit),
            255,
            255,
            255,
            255,
            0,
            1
        )
        DrawAdvancedText(0.804, 0.744, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6873, 0.7346, 0.7222, 0.7574) then
            DrawRect(0.71, 0.74, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "gang"
            end
        else
            DrawRect(0.71, 0.74, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "security" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CORRUPT gang - security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(
            0.4,
            0.375,
            0.005,
            0.0028,
            0.46,
            "Maximum withdraw amount per member:",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawAdvancedText(
            0.4,
            0.405,
            0.005,
            0.0028,
            0.4,
            "Sets the maximum amount of money a member can withdraw within a 24 hour time period.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.377, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(
            0.575,
            0.377,
            0.005,
            0.0028,
            0.44,
            "£" .. getMoneyStringFormatted(h.maxWithdraw),
            255,
            255,
            255,
            255,
            6,
            1
        )
        if CursorInArea(0.31, 0.65, 0.36, 0.41) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if a2() >= 4 then
                    local amount = G()
                    if amount and tonumber(amount) and tonumber(amount) >= 0 then
                        TriggerServerEvent("CORRUPT:setGangMaximumWithdrawAmount", tonumber(amount))
                    else
                        notify("~r~Invalid amount entered.")
                    end
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(
            0.4,
            0.475,
            0.005,
            0.0028,
            0.46,
            "Limit withdraw amount to deposit amount:",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawAdvancedText(
            0.4,
            0.505,
            0.005,
            0.0028,
            0.4,
            "Prevents a member withdrawing more money then they have deposited into the funds.",
            255,
            255,
            255,
            255,
            6,
            1
        )
        DrawRect(0.525, 0.475, 0.1, 0.03, 0, 0, 0, 175)
        DrawAdvancedText(
            0.575,
            0.475,
            0.005,
            0.0028,
            0.46,
            h.limitWithdrawDeposit and "Yes" or "No",
            255,
            255,
            255,
            255,
            6,
            1
        )
        if CursorInArea(0.31, 0.65, 0.46, 0.51) then
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if a2() >= 4 then
                    local H = K("Enable?")
                    TriggerServerEvent("CORRUPT:setGangLimitWithdrawDeposit", H)
                else
                    notify("~r~You must be a leader to change security.")
                end
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "gang"
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "guest" then
        DrawRect(0.501, 0.525, 0.421, 0.387, 0, 0, 0, 150)
        DrawRect(0.501, 0.308, 0.421, 0.047, 18, 82, 228, 248)
        DrawAdvancedText(0.591, 0.312, 0.005, 0.0028, 0.48, "CORRUPT gang - guest", 255, 255, 255, 255, 7, 0)
        if o then
            DrawRect(0.448, 0.52, 0.295, 0.291, 0, 0, 0, 150)
            DrawAdvancedText(0.449, 0.359, 0.005, 0.0028, 0.4, "Name", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.506, 0.359, 0.005, 0.0028, 0.4, "ID", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.555, 0.359, 0.005, 0.0028, 0.4, "Rank", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.625, 0.359, 0.005, 0.0028, 0.4, "Last Seen", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(0.675, 0.359, 0.005, 0.0028, 0.4, "Pin", 255, 255, 255, 255, 6, 0)
            if h and o then
                local ar = s and "Remove Selection" or "Set As Selected"
                DrawAdvancedText(0.746, 0.465, 0.005, 0.0028, 0.4, ar, 255, 255, 255, 255, 4, 0)
            end
            DrawAdvancedText(0.746, 0.54, 0.005, 0.0028, 0.4, "Leave", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.491, 0.695, 0.005, 0.0028, 0.4, "Previous", 255, 255, 255, 255, 4, 0)
            DrawAdvancedText(0.581, 0.695, 0.005, 0.0028, 0.4, "Next", 255, 255, 255, 255, 4, 0)
            local U = table.count(o.members) + table.count(o.guests)
            DrawAdvancedText(
                0.536,
                0.695,
                0.005,
                0.0028,
                0.4,
                tostring(r) .. "/" .. tostring(math.ceil(U / 10.0)),
                255,
                255,
                255,
                255,
                4,
                0
            )
            DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
            for a5, C in pairs(M(o)) do
                local a7 = "Unknown"
                if C.rank == 0 then
                    a7 = "Guest"
                elseif C.rank == 1 then
                    a7 = "Recruit"
                elseif C.rank == 2 then
                    a7 = "Member"
                elseif C.rank == 3 then
                    a7 = "Senior"
                elseif C.rank >= 4 then
                    a7 = "Leader"
                end
                DrawAdvancedText(0.449, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, C.name, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.506, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, C.user_id, 255, 255, 255, 255, 6, 0)
                DrawAdvancedText(0.555, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, a7, 255, 255, 255, 255, 6, 0)
                local a8 = C.lastLogin
                if fullPlayerListData[C.user_id] then
                    a8 = "~g~Online"
                end
                DrawAdvancedText(0.625, 0.361 + 0.0287 * a5, 0.005, 0.0028, 0.4, a8, 255, 255, 255, 255, 6, 0)
                local a9 = k.pinnedPlayers[C.user_id] and o.isAdvanced and "📌" or "⭕"
                DrawAdvancedText(0.675, 0.3665 + 0.0287 * a5, 0.005, 0.0028, 0.2, a9, 255, 255, 255, 255, 6, 0)
                if CursorInArea(0.5755, 0.5955, 0.3731 + 0.0287 * (a5 - 1), 0.4018 + 0.0287 * (a5 - 1)) then
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        if o.isAdvanced then
                            if k.pinnedPlayers[C.user_id] then
                                k.pinnedPlayers[C.user_id] = nil
                            else
                                k.pinnedPlayers[C.user_id] = true
                            end
                            SetResourceKvp("corrupt_gang_pinned", json.encode(k.pinnedPlayers))
                        else
                            notify("~r~You must have the advanced gang license to pin a player.")
                        end
                    end
                end
            end
            if h and o then
                if CursorInArea(0.6182, 0.6822, 0.435, 0.491) then
                    DrawRect(0.651, 0.463, 0.065, 0.056, e, f, g, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        if s then
                            notify("~g~Set main gang as selected")
                            s = false
                        else
                            notify("~g~Set guest gang as selected")
                            s = true
                        end
                        TriggerEvent("CORRUPT:deleteGangBlips")
                        local z = x()
                        if z and z.isAdvanced and k.blips then
                            local ah = x() == h and "own" or "guest"
                            TriggerServerEvent("CORRUPT:setGangBlipsEnabled", ah)
                        end
                    end
                else
                    DrawRect(0.651, 0.463, 0.065, 0.056, 0, 0, 0, 150)
                end
            end
            if CursorInArea(0.6182, 0.6822, 0.510, 0.566) then
                DrawRect(0.651, 0.538, 0.065, 0.056, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if K("Are you sure?") then
                        TriggerServerEvent("CORRUPT:leaveGangAsGuest")
                    end
                end
            else
                DrawRect(0.651, 0.538, 0.065, 0.056, 0, 0, 0, 150)
            end
            if CursorInArea(0.3735, 0.4185, 0.6768, 0.7074) then
                DrawRect(0.396, 0.693, 0.045, 0.033, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if r <= 1 then
                        tvRP.notify("~r~Lowest page reached")
                    else
                        r = r - 1
                    end
                end
            else
                DrawRect(0.396, 0.693, 0.045, 0.033, 0, 0, 0, 150)
            end
            if CursorInArea(0.4635, 0.5085, 0.6712, 0.7064) then
                DrawRect(0.486, 0.693, 0.045, 0.033, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if r >= math.ceil(U / 10.0) then
                        tvRP.notify("~r~Max page reached")
                    else
                        r = r + 1
                    end
                end
            else
                DrawRect(0.486, 0.693, 0.045, 0.033, 0, 0, 0, 150)
            end
            if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
                DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    a = "gang"
                end
            else
                DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
            end
        else
            DrawAdvancedText(0.501, 0.378, 0.105, 0.0028, 0.46, "Guest Guide", 255, 255, 255, 255, 6, 0)
            DrawAdvancedText(
                0.501,
                0.416,
                0.105,
                0.0028,
                0.46,
                "A guest is a player who will temporarily have access to a limited area of your gang.",
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.501,
                0.454,
                0.105,
                0.0028,
                0.46,
                "They will be able to pin members, see pings, see blips and name tags.",
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.501,
                0.492,
                0.105,
                0.0028,
                0.46,
                "They will not be able to see or access your funds, logs, settings and security.",
                255,
                255,
                255,
                255,
                6,
                0
            )
            DrawAdvancedText(
                0.501,
                0.53,
                0.105,
                0.0028,
                0.46,
                "Being a guest of another gang will not remove you from your current gang.",
                255,
                255,
                255,
                255,
                6,
                0
            )
            if h then
                DrawAdvancedText(0.478, 0.642, 0.005, 0.0028, 0.473, "Invite Guest", 255, 255, 255, 255, 4, 0)
            end
            DrawAdvancedText(0.564, 0.643, 0.005, 0.0028, 0.473, "Accept Invite", 255, 255, 255, 255, 4, 0)
            DrawRect(0.561, 0.577, 0.065, -0.003, 0, 168, 255, 204)
            DrawAdvancedText(0.654, 0.57, 0.005, 0.0028, 0.364, "Guest Invite list", 255, 255, 255, 255, 4, 0)
            for a5, a6 in pairs(p) do
                DrawAdvancedText(0.656, 0.598 + 0.020 * a5, 0.005, 0.0028, 0.234, a6, 255, 255, 255, 255, 0, 0)
                if CursorInArea(0.525, 0.59, 0.58 + 0.02 * a5, 0.596 + 0.02 * a5) and a5 ~= q then
                    DrawRect(0.56, 0.59 + 0.02 * a5, 0.062, 0.019, 0, 168, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        q = a5
                    end
                elseif a5 == q then
                    DrawRect(0.56, 0.59 + 0.02 * a5, 0.062, 0.019, 0, 168, 255, 150)
                end
            end
            if h then
                if CursorInArea(0.35, 0.415, 0.615, 0.66) then
                    DrawRect(0.383, 0.642, 0.066, 0.046, 0, 168, 255, 150)
                    if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                        PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                        local aa = J()
                        if aa ~= nil and tonumber(aa) then
                            if a2() >= 2 then
                                TriggerServerEvent("CORRUPT:inviteUserAsGuestToGang", tonumber(aa))
                            else
                                tvRP.notify("~r~You don't have permission to invite players")
                            end
                        else
                            tvRP.notify("Invalid Perm ID entered")
                        end
                    end
                else
                    DrawRect(0.383, 0.642, 0.066, 0.046, 0, 0, 0, 150)
                end
            end
            if CursorInArea(0.435, 0.51, 0.615, 0.66) then
                DrawRect(0.469, 0.642, 0.066, 0.046, 0, 168, 255, 150)
                if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                    PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                    if q ~= nil then
                        q = p[q]
                        TriggerServerEvent("CORRUPT:addUserAsGuestToGang", q)
                        p = {}
                    else
                        tvRP.notify("~r~No guest invite selected")
                    end
                end
            else
                DrawRect(0.469, 0.642, 0.066, 0.046, 0, 0, 0, 150)
            end
        end
        DrawAdvancedText(0.775, 0.693, 0.005, 0.0028, 0.4, "Back", 255, 255, 255, 255, 4, 0)
        if CursorInArea(0.6583, 0.7056, 0.6712, 0.7064) then
            DrawRect(0.681, 0.689, 0.045, 0.036, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if h then
                    a = "gang"
                else
                    a = "noGang"
                end
            end
        else
            DrawRect(0.681, 0.689, 0.045, 0.036, 0, 0, 0, 150)
        end
    end
    if a == "gang" then
        DisableControlAction(0, 200, true)
        if CORRUPT.isNewPlayer() then
            drawNativeNotification("Press ~INPUT_SELECT_CHARACTER_MICHAEL~ to toggle the Gang Menu.")
        end
        DrawRect(0.501, 0.532, 0.375, 0.225, 0, 0, 0, 150)
        DrawRect(0.501, 0.396, 0.375, 0.046, 19, 86, 223, 255)
        DrawAdvancedText(0.591, 0.399, 0.005, 0.003, 0.51, "CORRUPT Gangs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.46, 0.534, 0.005, 0.0028, 0.4, "funds", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.554, 0.534, 0.005, 0.0028, 0.4, "members", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.642, 0.534, 0.005, 0.0028, 0.4, "logs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.732, 0.534, 0.005, 0.0028, 0.4, "settings", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.51, 0.604, 0.005, 0.0028, 0.4, "Turfs", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.598, 0.604, 0.005, 0.0028, 0.4, "Security", 255, 255, 255, 255, 7, 0)
        DrawAdvancedText(0.686, 0.604, 0.005, 0.0028, 0.4, "Guest", 255, 255, 255, 255, 7, 0)
        if CursorInArea(0.3333, 0.3973, 0.4981, 0.5537) then
            DrawRect(0.366, 0.527, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "funds"
            end
        else
            DrawRect(0.366, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.4244, 0.4903, 0.4981, 0.5537) then
            DrawRect(0.458, 0.527, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "members"
            end
        else
            DrawRect(0.458, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.5140, 0.5776, 0.4981, 0.5537) then
            DrawRect(0.546, 0.527, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                if not h.logs then
                    TriggerServerEvent("CORRUPT:requestGangLogs")
                end
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "logs"
            end
        else
            DrawRect(0.546, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.6020, 0.6677, 0.4981, 0.5537) then
            DrawRect(0.635, 0.527, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "settings"
            end
        else
            DrawRect(0.635, 0.527, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.3804, 0.4463, 0.5722, 0.6259) then
            DrawRect(0.414, 0.6, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "turfs"
            end
        else
            DrawRect(0.414, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.47, 0.5336, 0.5722, 0.6259) then
            DrawRect(0.502, 0.6, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                if h.isAdvanced then
                    a = "security"
                else
                    notify("~r~You must have the advanced gang license to access this page.")
                end
            end
        else
            DrawRect(0.502, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
        if CursorInArea(0.558, 0.6216, 0.5722, 0.6259) then
            DrawRect(0.59, 0.6, 0.065, 0.056, e, f, g, 150)
            if IsControlJustPressed(1, 329) or IsDisabledControlJustPressed(1, 329) then
                PlaySound(-1, "SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 0, 0, 1)
                a = "guest"
            end
        else
            DrawRect(0.59, 0.6, 0.065, 0.056, 0, 0, 0, 150)
        end
    end
end
CORRUPT.createThreadOnTick(a4)
Citizen.CreateThread(
    function()
        local as = json.decode(GetResourceKvpString("corrupt_gang_pinned") or "{}") or {}
        k = {
            blips = GetResourceKvpString("corrupt_gang_blips") == "true",
            pings = GetResourceKvpString("corrupt_gang_pings") == "true",
            names = GetResourceKvpString("corrupt_gang_names") == "true",
            pinnedPlayers = {}
        }
        for B in pairs(as) do
            k.pinnedPlayers[tonumber(B)] = true
        end
        while true do
            if
                IsControlJustPressed(0, 166) or IsDisabledControlJustPressed(0, 166) or
                    IsDisabledControlJustReleased(0, 200) and (a == "noGang" or a == "gang")
             then
                if not h then
                    if a == "noGang" then
                        a = nil
                        setCursor(0)
                        inGUICORRUPT = false
                        c = nil
                    else
                        a = "noGang"
                        setCursor(1)
                        inGUICORRUPT = true
                    end
                end
                if h then
                    if a == "gang" then
                        a = nil
                        setCursor(0)
                        inGUICORRUPT = false
                        d = nil
                    else
                        a = "gang"
                        setCursor(1)
                        inGUICORRUPT = true
                    end
                end
                Wait(100)
            end
            Wait(0)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:setGangData",
    function(at, au, av, aw, ax, ay, az)
        h = {
            name = at,
            displayMoney = au,
            members = av,
            guests = aw,
            isAdvanced = ax,
            maxWithdraw = ay,
            limitWithdrawDeposit = az,
            pings = {}
        }
        if h.isAdvanced then
            RequestStreamedTextureDict("corrupt_gang", false)
            if k.blips then
                TriggerEvent("CORRUPT:deleteGangBlips")
                TriggerServerEvent("CORRUPT:setGangBlipsEnabled", "own")
            end
            TriggerServerEvent("CORRUPT:setPersonalGangBlipColour", w)
        end
        if a then
            a = "gang"
        end
    end
)
RegisterNetEvent(
    "CORRUPT:setGuestGangData",
    function(av, aw, ax)
        o = {members = av, guests = aw, isAdvanced = ax, pings = {}}
        if o.isAdvanced then
            RequestStreamedTextureDict("corrupt_gang", false)
            if not h and k.blips then
                TriggerEvent("CORRUPT:deleteGangBlips")
                TriggerServerEvent("CORRUPT:setGangBlipsEnabled", "guest")
            end
            TriggerServerEvent("CORRUPT:setPersonalGangBlipColour", w)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:updateGangName",
    function(at)
        h.name = at
    end
)
RegisterNetEvent(
    "CORRUPT:updateGangDisplayMoney",
    function(au)
        h.displayMoney = au
    end
)
RegisterNetEvent(
    "CORRUPT:setIsAdvanced",
    function()
        RequestStreamedTextureDict("corrupt_gang", false)
        h.isAdvanced = true
    end
)
RegisterNetEvent(
    "CORRUPT:setGuestGangIsAdvanced",
    function()
        RequestStreamedTextureDict("corrupt_gang", false)
        o.isAdvanced = true
    end
)
RegisterNetEvent(
    "CORRUPT:addGangMember",
    function(O, C)
        h.members[O] = C
    end
)
RegisterNetEvent(
    "CORRUPT:addGuestGangMember",
    function(O, C)
        o.members[O] = C
    end
)
RegisterNetEvent(
    "CORRUPT:addGangGuest",
    function(O, E)
        h.guests[O] = E
    end
)
RegisterNetEvent(
    "CORRUPT:addGuestGangGuest",
    function(O, E)
        o.guests[O] = E
    end
)
RegisterNetEvent(
    "CORRUPT:updateGangMemberRank",
    function(O, aA)
        h.members[O].rank = aA
    end
)
RegisterNetEvent(
    "CORRUPT:updateGuestGangMemberRank",
    function(O, aA)
        o.members[O].rank = aA
    end
)
RegisterNetEvent(
    "CORRUPT:updateGangMemberLastLogin",
    function(O, a8)
        h.members[O].lastLogin = a8
    end
)
RegisterNetEvent(
    "CORRUPT:updateGuestGangMemberLastLogin",
    function(O, a8)
        o.members[O].lastLogin = a8
    end
)
RegisterNetEvent(
    "CORRUPT:removeGangMember",
    function(O)
        h.members[O] = nil
    end
)
RegisterNetEvent(
    "CORRUPT:removeGuestGangMember",
    function(O)
        o.members[O] = nil
    end
)
RegisterNetEvent(
    "CORRUPT:removeGangGuest",
    function(O)
        h.guests[O] = nil
    end
)
RegisterNetEvent(
    "CORRUPT:removeGuestGangGuest",
    function(O)
        o.guests[O] = nil
    end
)
RegisterNetEvent(
    "CORRUPT:setGangLogs",
    function(X)
        h.logs = X
    end
)
RegisterNetEvent(
    "CORRUPT:addGangLog",
    function(Z)
        if h.logs then
            table.insert(h.logs, 1, Z)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:removeCachedGang",
    function()
        if k.blips then
            TriggerEvent("CORRUPT:deleteGangBlips")
        end
        if a then
            a = "noGang"
        end
        h = nil
    end
)
RegisterNetEvent(
    "CORRUPT:removeCachedGuestGang",
    function()
        if k.blips then
            TriggerEvent("CORRUPT:deleteGangBlips")
        end
        o = nil
    end
)
RegisterNetEvent(
    "CORRUPT:sendGangPinnedData",
    function(aB)
        l = aB
    end
)
RegisterNetEvent(
    "CORRUPT:setGangMaximumWithdrawAmount",
    function(amount)
        h.maxWithdraw = amount
    end
)
RegisterNetEvent(
    "CORRUPT:setGangLimitWithdrawDeposit",
    function(aC)
        h.limitWithdrawDeposit = aC
    end
)
RegisterNetEvent(
    "CORRUPT:setGangMemberColour",
    function(O, aq)
        h.members[O].colour = aq
    end
)
RegisterNetEvent(
    "CORRUPT:setGuestGangMemberColour",
    function(O, aq)
        o.members[O].colour = aq
    end
)
RegisterNetEvent(
    "CORRUPT:setGangGuestColour",
    function(O, aq)
        h.guests[O].colour = aq
    end
)
RegisterNetEvent(
    "CORRUPT:setGuestGangGuestColour",
    function(O, aq)
        o.guests[O].colour = aq
    end
)
function CORRUPT.isInGang()
    return h ~= nil
end
function CORRUPT.isGuestGangSelected()
    return s and o or not h and o
end
function CORRUPT.isSelectedGangAdvanced()
    local z = x()
    return z and z.isAdvanced
end
function CORRUPT.hasGangBlipsEnabled()
    local z = x()
    return z and z.isAdvanced and k.blips and not CORRUPT.inEvent()
end
function CORRUPT.hasGangNamesEnabled()
    local z = x()
    return z and z.isAdvanced and k.names and not CORRUPT.inEvent()
end
function CORRUPT.isPlayerInSelectedGang(aD)
    local z = x()
    if z and not CORRUPT.inEvent() then
        local O = CORRUPT.clientGetUserIdFromSource(aD)
        if O then
            local C = z.members[O]
            if C then
                return true, u[C.colour] or v
            end
            local E = z.guests[O]
            if E then
                return true, u[E.colour] or v
            end
        end
    end
    return false, v
end
RegisterCommand(
    "pinglocation",
    function()
        local z = x()
        if z and z.isAdvanced and k.pings and not CORRUPT.isEmergencyService() and not CORRUPT.inEvent() then
            local aE = GetGameplayCamCoord()
            local aF = CORRUPT.rotationToDirection(GetGameplayCamRot(2))
            local aG = aE + aF * 500.0
            local aH =
                StartExpensiveSynchronousShapeTestLosProbe(aE.x, aE.y, aE.z, aG.x, aG.y, aG.z, -1, PlayerPedId(), 8)
            local Y, aI, aJ = GetShapeTestResult(aH)
            if not aI or aI == 0 then
                local aK = nil
                local aL = 2.0
                for aM = 20, 500 do
                    if aM > 50 and not aK then
                        aL = 10.0
                    end
                    local aN = aE + aF * aM
                    local aO, aP = GetGroundZFor_3dCoord(aN.x, aN.y, aN.z, 0.0, false)
                    if aO then
                        local aQ = vector3(aN.x, aN.y, aP)
                        local aR = #(aN - aQ)
                        if aR < aL then
                            aK = aQ
                            aL = aR
                        end
                    end
                end
                if aK then
                    aI = true
                    aJ = aK
                end
            end
            if aI and aI ~= 0 then
                t = GetGameTimer()
                TriggerServerEvent("CORRUPT:pingGangLocation", aJ, CORRUPT.isGuestGangSelected())
            end
        end
    end,
    false
)
RegisterKeyMapping("pinglocation", "Create Gang Ping", "MOUSE_BUTTON", "MOUSE_MIDDLE")
RegisterCommand(
    "deletepinglocation",
    function()
        local z = x()
        if z.pings[CORRUPT.getUserId()] then
            TriggerServerEvent("CORRUPT:pingGangLocation", nil, CORRUPT.isGuestGangSelected())
        end
    end,
    false
)
RegisterKeyMapping("deletepinglocation", "Delete Gang Ping", "MOUSE_BUTTON", "MOUSE_MIDDLE")
local function aS(aT)
    if CORRUPT.getGangPingMarkerIndex() == 2 and not CORRUPT.isEmergencyService() and not CORRUPT.inEvent() then
        local Y, aP = GetGroundZFor_3dCoord(aT.x, aT.y, aT.z, aT.z, false)
        local aR = math.abs(aP - aT.z)
        local aU = (aR > 10.0 and aT.z or aP) - 1.0
        return CreateCheckpoint(47, aT.x, aT.y, aU, aT.x, aT.y, aT.z + 200.0, 1.0, 255, 50, 50, 125, 0)
    else
        return nil
    end
end
RegisterNetEvent(
    "CORRUPT:pingGangLocation",
    function(aV, aT)
        local aW = h.pings[aV]
        if aW and aW.checkpoint then
            DeleteCheckpoint(aW.checkpoint)
            aW.checkpoint = nil
        end
        if aT then
            h.pings[aV] = {position = aT, checkpoint = aS(aT)}
        else
            h.pings[aV] = nil
        end
    end
)
RegisterNetEvent(
    "CORRUPT:pingGuestGangLocation",
    function(aV, aT)
        local aW = o.pings[aV]
        if aW and aW.checkpoint then
            DeleteCheckpoint(aW.checkpoint)
            aW.checkpoint = nil
        end
        if aT then
            o.pings[aV] = {position = aT, checkpoint = aS(aT)}
        else
            o.pings[aV] = nil
        end
    end
)
local aX = 0.0239
local aY = 0.35
local aZ = {0, 0, 0, 255}
local a_ = 0.8
local function b0(b1, b2, b3, b4, al, am, an, b5)
    DrawRect(b1 + b3 / 2.0, b2 + b4 / 2.0, b3, b4, al, am, an, b5)
end
local function b6()
    local b7 = 0
    local z = x()
    if z and z.isAdvanced and not CORRUPT.isEmergencyService() and not globalHideUi and not CORRUPT.inEvent() then
        if k.pings then
            local b8 = GetGameplayCamCoord()
            local b9 = HasStreamedTextureDictLoaded("corrupt_gang")
            local ba, bb = GetActiveScreenResolution()
            local bc = ba / bb
            for aV, bd in pairs(z.pings) do
                local be, b1, b2 = GetScreenCoordFromWorldCoord(bd.position.x, bd.position.y, bd.position.z)
                if be then
                    local C = y(z)[aV]
                    if C then
                        local bf = #(b8 - bd.position)
                        local bg = tostring(math.floor(bf)) .. "m"
                        if bf > 1000.0 then
                            bg = tostring(math.round(bf / 1000.0, 1)) .. "km"
                        end
                        local bh = 0.4 * math.min(bf / 1000.0, 1.0)
                        CORRUPT.DrawText(b1, b2, C.name .. "\n" .. bg, 0.2 * (1.0 - bh) * a_, 0, 0, nil, true)
                        if b9 and CORRUPT.getGangPingMarkerIndex() == 3 then
                            local bi = 1.0 - bh * 1.25
                            DrawSprite(
                                "corrupt_gang",
                                "ping",
                                b1,
                                b2 - 0.01 * bi * a_,
                                0.03 / bc * bi * a_,
                                0.03 * bi * a_,
                                0,
                                255,
                                255,
                                255,
                                255
                            )
                        end
                    end
                end
            end
        end
        local a5 = 0
        local bj = CORRUPT.getShowHealthPercentageFlag()
        for B, C in pairs(y(z)) do
            if k.pinnedPlayers[B] and fullPlayerListData[B] and CORRUPT.getJobType(B) == "" then
                local bk = true
                local bl = nil
                local bm = nil
                local aB = l[B]
                if aB then
                    bl = aB.health
                    bm = aB.armour
                end
                local bn = fullPlayerListData[B][1]
                if bn then
                    local bo = GetPlayerFromServerId(bn)
                    if bo ~= -1 then
                        local bp = GetPlayerPed(bo)
                        if bp ~= 0 then
                            bl = GetEntityHealth(bp)
                            bm = GetPedArmour(bp)
                            bk = false
                        end
                    end
                end
                if bl and bm then
                    local bq = a5 * 0.05 + aY
                    CORRUPT.DrawText(aX, bq, C.name, 0.3)
                    b0(aX + 0.0011, bq + 0.025, 0.125, 0.0035, 9, 31, 0, 100)
                    local br = 0.125 * bm / 100
                    if bl <= 102 then
                        br = 0.0
                    end
                    b0(aX + 0.0011, bq + 0.025, br, 0.0035, 66, 145, 243, 255)
                    b0(aX + 0.0011, bq + 0.032, 0.125, 0.009, 9, 31, 0, 100)
                    if bl >= 198 then
                        bl = 200
                    end
                    local bs = 0.125 * (bl - 100) / 100
                    if bs < 0.0 then
                        bs = 0.0
                    end
                    b0(aX + 0.0011, bq + 0.032, bs, 0.009, 104, 212, 73, 255)
                    if bj then
                        local bt = math.floor((bl - 100) / 100.0 * 100)
                        if bt < 0 then
                            bt = 0
                        end
                        CORRUPT.DrawText(aX + 0.125 / 2.0 - 0.0025, bq + 0.03, tostring(bt) .. "%", 0.15, nil, nil, aZ)
                    end
                    a5 = a5 + 1
                end
                if bk then
                    b7 = b7 + 1
                end
            end
        end
    end
    if m and m == z then
        if b7 <= 0 then
            TriggerServerEvent("CORRUPT:setGangPinnedEnabled", nil)
            m = nil
        end
    else
        if b7 > 0 then
            local ah = z == h and "own" or "guest"
            TriggerServerEvent("CORRUPT:setGangPinnedEnabled", ah)
            m = z
        end
    end
end
CORRUPT.createThreadOnTick(b6)
RegisterNetEvent(
    "CORRUPT:onLicenseBought",
    function(bu)
        local z = x()
        if bu == "polblips" and z and z.isAdvanced and k.blips then
            local ah = z == h and "own" or "guest"
            TriggerEvent("CORRUPT:deleteGangBlips")
            TriggerServerEvent("CORRUPT:setGangBlipsEnabled", ah)
        end
    end
)
Citizen.CreateThread(
    function()
        while true do
            if t > 0 and GetGameTimer() - t > 300000 then
                local O = CORRUPT.getUserId()
                if h and h.pings and h.pings[O] then
                    TriggerServerEvent("CORRUPT:pingGangLocation", nil, false)
                end
                if o and o.pings and o.pings[O] then
                    TriggerServerEvent("CORRUPT:pingGangLocation", nil, true)
                end
                t = 0
            end
            Citizen.Wait(15000)
        end
    end
)
