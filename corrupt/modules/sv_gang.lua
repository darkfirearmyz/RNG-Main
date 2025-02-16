local gangTable = {}
local gang_invites = {}
local guest_invites = {}
local fundscooldown = {}
local cooldown = 5

-- Main Gang Sql Commands
MySQL.createCommand("corrupt_edit_user_gang_name", "UPDATE corrupt_user_gangs SET gangname = @gangname WHERE user_id = @user_id")
MySQL.createCommand("corrupt_edit_user_gang_colour", "UPDATE corrupt_user_gangs SET gangcolour = @gangcolour WHERE user_id = @user_id")
MySQL.createCommand("corrupt_edit_user_gang_rank", "UPDATE corrupt_user_gangs SET gangrank = @gangrank WHERE user_id = @user_id")
MySQL.createCommand("corrupt_create_gang", "INSERT INTO corrupt_gangs (gangname,owner) VALUES(@gangname,@owner)")
-- Guest Gang Sql Commands
MySQL.createCommand("corrupt_edit_user_guest_name", "UPDATE corrupt_user_gangs SET guestname = @guestname WHERE user_id = @user_id")
MySQL.createCommand("corrupt_edit_user_guest_colour", "UPDATE corrupt_user_gangs SET guestcolour = @guestcolour WHERE user_id = @user_id")


MySQL.createCommand("corrupt_add_gang", "INSERT IGNORE INTO corrupt_user_gangs (user_id,gangname) VALUES (@user_id,@gangname)")

function CORRUPT.lastLogin(user_id, callback)
    exports['corrupt']:execute('SELECT last_login FROM corrupt_users WHERE id = @id', { id = user_id }, function(userData)
        local lastLogin = 0
        if userData[1] then
            lastLogin = userData[1].last_login
        end
        callback(lastLogin)
    end)
end

function CORRUPT.getGangName(user_id)
    return exports["corrupt"]:scalarSync("SELECT gangname FROM corrupt_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end

function CORRUPT.getGuestName(user_id)
    return exports["corrupt"]:scalarSync("SELECT guestname FROM corrupt_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or ""
end

function CORRUPT.getGangRank(user_id)
    return exports["corrupt"]:scalarSync("SELECT gangrank FROM corrupt_user_gangs WHERE user_id = @user_id", {user_id = user_id}) or 1
end

function CORRUPT.getGangWithdrawLimit(gangname)
    exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if ganginfo[1] then
            if tobool(ganginfo[1].limit) == true then
                return ganginfo[1].withdraw
            else
                return nil
            end
        end
    end) 
end

function CORRUPT.isAdvanced(gangname)
    exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
        if ganginfo[1] then
            local advanced = tobool(ganginfo[1].advanced)
            if advanced == true then
                return true
            else
                return false
            end
        end
    end) 
end

function CORRUPT.getUserGangBlipColour(user_id)
    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE user_id = @user_id", {user_id = user_id}, function(ganginfo)
        if ganginfo[1] then
            return ganginfo[1].colour
        end
    end)
end

function CORRUPT.IsPingsEnabled(user_id)
    return tobool(exports["corrupt"]:scalarSync("SELECT pings FROM corrupt_user_gangs WHERE id = @id", {id = user_id}))
end 
local spawnedmembers = {}
local spawnedguests = {}
AddEventHandler("CORRUPT:playerSpawn", function(user_id, source, first_spawn)
    if first_spawn then
        gang_invites[source] = {}
        guest_invites[source] = {}
        local gangName = CORRUPT.getGangName(user_id)
        local guestName = CORRUPT.getGuestName(user_id)

        exports["corrupt"]:execute("INSERT IGNORE INTO corrupt_user_gangs (user_id) VALUES (@user_id)", {user_id = user_id})
        if gangName and gangName ~= "" then
            local gangmembers = {}
            local guestmembers = {}
            local memberids = {}
            exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {gangname = gangName}, function(gangInfo)
                local gangInfo = gangInfo[1]
                if gangInfo ~= "" and gangInfo and gangInfo.gangname then
                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {gangname = gangName}, function(gangMembers)
                        for _, member in ipairs(gangMembers) do
                            memberids[#memberids+1] = tonumber(member.user_id)
                            gangmembers[member.user_id] = {
                                rank = tonumber(member.gangrank)
                            }
                        end
                        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @gangname", {gangname = gangName}, function(gangMembers)
                            for _, member in ipairs(gangMembers) do
                                memberids[#memberids+1] = tonumber(member.user_id)
                                guestmembers[member.user_id] = {}
                            end
                            local placeholders = string.rep('?,', #memberids):sub(1, -2)
                            exports["corrupt"]:execute("SELECT * FROM corrupt_users WHERE id IN (" .. placeholders .. ")", memberids, function(playerData)
                                for _, playerRow in ipairs(playerData) do
                                    local member_id = tonumber(playerRow.id)
                                    if gangmembers[member_id] then
                                        gangmembers[member_id].lastLogin =  playerRow.last_login
                                        gangmembers[member_id].name = playerRow.username
                                    elseif guestmembers[member_id] then
                                        guestmembers[member_id].name = playerRow.username
                                    end
                                end
                                local gangFunds = tonumber(gangInfo.funds)
                                local gangIsAdvanced = tobool(gangInfo.advanced)
                                local ganglogs = json.decode(gangInfo.logs)
                                local ganglock = tobool(gangInfo.lockedfunds)
                                local maxWithdraw = tonumber(gangInfo.withdraw)
                                local limit = tobool(gangInfo.limit)
                                spawnedmembers[source] = true
                                TriggerClientEvent('CORRUPT:setGangData', source, gangName, gangFunds, gangmembers, guestmembers, gangIsAdvanced, maxWithdraw, limit, ganglock)
                            end)
                        end)
                    end)
                end
            end)
        end
        if guestName and guestName ~= "" then
            local gangmembers = {}
            local guestmembers = {}
            local memberids = {}
            exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {gangname = guestName}, function(gangInfo)
                local gangInfo = gangInfo[1]
                if gangInfo ~= "" and gangInfo and gangInfo.gangname then
                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {gangname = guestName}, function(gangMembers)
                        for _, member in ipairs(gangMembers) do
                            memberids[#memberids+1] = tonumber(member.user_id)
                            gangmembers[member.user_id] = {
                                rank = tonumber(member.gangrank)
                            }
                        end
                        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @gangname", {gangname = guestName}, function(gangMembers)
                            for _, member in ipairs(gangMembers) do
                                memberids[#memberids+1] = tonumber(member.user_id)
                                guestmembers[member.user_id] = {}
                            end
                            local placeholders = string.rep('?,', #memberids):sub(1, -2)
                            exports["corrupt"]:execute("SELECT * FROM corrupt_users WHERE id IN (" .. placeholders .. ")", memberids, function(playerData)
                                for _, playerRow in ipairs(playerData) do
                                    local member_id = tonumber(playerRow.id)
                                    if gangmembers[member_id] then
                                        gangmembers[member_id].lastLogin =  playerRow.last_login
                                        gangmembers[member_id].name = playerRow.username
                                    elseif guestmembers[member_id] then
                                        guestmembers[member_id].name = playerRow.username
                                    end
                                end
                                local gangIsAdvanced = tobool(gangInfo.advanced)
                                spawnedguests[source] = true
                                TriggerClientEvent('CORRUPT:setGuestGangData', source, gangmembers, guestmembers, gangIsAdvanced)
                            end)
                        end)
                    end)
                end
            end)
        end
    end
end)

RegisterNetEvent('CORRUPT:createGang')
AddEventHandler('CORRUPT:createGang', function(gangname)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if CORRUPT.hasGroup(user_id, "Gang") then
        local hasgang = CORRUPT.getGangName(user_id)
        if hasgang and hasgang ~= "" then
            CORRUPT.notify(source, {"~r~You are already in a gang."})
            return
        end
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", { gangname = gangname }, function(gangData)
            if #gangData <= 0 then
                MySQL.execute("corrupt_edit_user_gang_name", { user_id = user_id, gangname = gangname })
                MySQL.execute("corrupt_edit_user_gang_rank", { user_id = user_id, gangrank = 4 })
                MySQL.execute("corrupt_create_gang", { gangname = gangname, owner = user_id })
                local gangmembers = {}
                gangmembers[user_id] = {["rank"] = 4, ["name"] = CORRUPT.getPlayerName(source)}
                TriggerClientEvent('CORRUPT:setGangData', source, gangname, 0, gangmembers, {}, false, 0, false)
                CORRUPT.notify(source, {"~g~Gang created."})
            else
                CORRUPT.notify(source, {"~r~Gang name is already taken."})
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You do not have permission to create a gang."})
    end
end)


RegisterNetEvent("CORRUPT:deleteGang")
AddEventHandler("CORRUPT:deleteGang", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        exports['corrupt']:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                    for _, member in ipairs(gangmembers) do
                        if user_id == member.user_id then
                            if tonumber(ganginfo[1].owner) == user_id then
                                exports['corrupt']:execute("DELETE FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname})
                                for _, member in ipairs(gangmembers) do
                                    MySQL.execute("corrupt_edit_user_gang_name", {user_id = member.user_id, gangname = nil})
                                    MySQL.execute("corrupt_edit_user_gang_rank", {user_id = member.user_id, gangrank = 1})
                                    local memberSource = CORRUPT.getUserSource(member.user_id)
                                    if memberSource then
                                        TriggerClientEvent('CORRUPT:removeCachedGang', memberSource)
                                    end
                                end
                            else
                                CORRUPT.notify(source, {"~r~You do not have permission to delete this gang."})
                            end
                        end
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~Gang not found."})
            end
        end)
    end
end)

RegisterNetEvent("CORRUPT:inviteUserToGang")
AddEventHandler("CORRUPT:inviteUserToGang", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        if source ~= target_source then
            if target_source == nil then
                CORRUPT.notify(source, {"~r~Player is not online."})
                return
            else
                table.insert(gang_invites[target_source], gangname)
                TriggerClientEvent("CORRUPT:inviteRecieved", target_source, gangname)
                CORRUPT.notify(source, {"~g~Successfully invited " ..CORRUPT.getPlayerName(target_source).. " to the gang."})
            end
        else
            CORRUPT.notify(source, {"~r~You cannot invite yourself."})
        end
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)

RegisterNetEvent("CORRUPT:inviteUserAsGuestToGang")
AddEventHandler("CORRUPT:inviteUserAsGuestToGang", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        if source ~= target_source then
            if target_source == nil then
                CORRUPT.notify(source, {"~r~Player is not online."})
                return
            else
                table.insert(guest_invites[target_source], gangname)
                TriggerClientEvent("CORRUPT:guestInviteRecieved", target_source, gangname)
                CORRUPT.notify(source, {"~g~Successfully invited " ..CORRUPT.getPlayerName(target_source).. " to the gang."})
            end
        else
            CORRUPT.notify(source, {"~r~You cannot invite yourself."})
        end
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)




RegisterNetEvent("CORRUPT:addUserToGang")
AddEventHandler("CORRUPT:addUserToGang", function(gangName)
    local source = source
    local user_id = CORRUPT.getUserId(source)

    if table.includes(gang_invites[source], gangName) then
        exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangName}, function(gangInfo)
            if not gangInfo or #gangInfo == 0 then
                CORRUPT.notify(source, {"~b~Gang no longer exists."})
                return
            end

            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname AND user_id = @user_id", {['@gangname'] = gangName, ['@user_id'] = user_id}, function(existingMember)
                if #existingMember > 0 then
                    CORRUPT.notify(source, {"~r~You are already in this gang."})
                    return
                end
                MySQL.execute("corrupt_edit_user_gang_name", {['@user_id'] = user_id, ['@gangname'] = gangName})
                Wait(100)
                local gangmembers = {}
                local guestmembers = {}
                local memberids = {}
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangName}, function(gangMembers)
                    for _, member in ipairs(gangMembers) do
                        memberids[#memberids+1] = tonumber(member.user_id)
                        gangmembers[member.user_id] = {
                            rank = tonumber(member.gangrank)
                        }
                    end

                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @gangname", {['@gangname'] = gangName}, function(guestMembers)
                        for _, member in ipairs(guestMembers) do
                            memberids[#memberids+1] = tonumber(member.user_id)
                            guestmembers[member.user_id] = {}
                        end

                        local placeholders = string.rep('?,', #memberids):sub(1, -2)
                        exports["corrupt"]:execute("SELECT * FROM corrupt_users WHERE id IN (" .. placeholders .. ")", memberids, function(playerData)
                            for _, playerRow in ipairs(playerData) do
                                local member_id = tonumber(playerRow.id)
                                if gangmembers[member_id] then
                                    gangmembers[member_id].lastLogin =  playerRow.last_login
                                    gangmembers[member_id].name = playerRow.username
                                elseif guestmembers[member_id] then
                                    guestmembers[member_id].name = playerRow.username
                                end
                            end
                            local gangFunds = tonumber(gangInfo[1].funds)
                            local gangIsAdvanced = tobool(gangInfo[1].advanced)
                            local gangLock = tobool(gangInfo[1].lockedfunds)
                            local maxWithdraw = tonumber(gangInfo[1].withdraw)
                            local limit = tobool(gangInfo[1].limit)

                            TriggerClientEvent('CORRUPT:setGangData', source, gangName, gangFunds, gangmembers, guestmembers, gangIsAdvanced, maxWithdraw, limit, gangLock)

                            for member_id, _ in pairs(gangmembers) do
                                local memberSource = CORRUPT.getUserSource(member_id)
                                if memberSource and memberSource ~= source then
                                    TriggerClientEvent("CORRUPT:addGangMember", memberSource, user_id, {["name"] = CORRUPT.getPlayerName(source), ["lastLogin"] = gangmembers[member_id]["lastLogin"], ["rank"] = 1})
                                end
                            end

                            for member_id, _ in pairs(guestmembers) do
                                local memberSource = CORRUPT.getUserSource(member_id)
                                if memberSource and memberSource ~= source then
                                    TriggerClientEvent("CORRUPT:addGuestGangMember", memberSource, user_id, {["name"] = CORRUPT.getPlayerName(source), ["lastLogin"] = gangmembers[member_id]["lastLogin"], ["rank"] = 1})
                                end
                            end
                        end)
                    end)
                end)
            end)
            syncRadio(source)
        end)
    else
        CORRUPT.notify(source, {"~r~You have not been invited to this gang."})
    end
end)




RegisterNetEvent("CORRUPT:addUserAsGuestToGang")
AddEventHandler("CORRUPT:addUserAsGuestToGang", function(gangname)
    local source = source
    local user_id = CORRUPT.getUserId(source)

    if table.includes(guest_invites[source], gangname) then
        exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(ganginfo)
            if not ganginfo or #ganginfo == 0 then
                CORRUPT.notify(source, {"~b~Gang no longer exists."})
                return
            end

            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                for _, member in ipairs(gangmembers) do
                    if tonumber(member.user_id) == user_id then
                        CORRUPT.notify(source, {"~r~You are already in this gang."})
                        return
                    end
                end
                MySQL.execute("corrupt_edit_user_guest_name", {['@user_id'] = user_id, ['@guestname'] = gangname})
                Wait(100)

                local memberids = {}
                local gangmembers = {}
                local guestmembers = {}
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangMembers)
                    for _, member in ipairs(gangMembers) do
                        memberids[#memberids+1] = tonumber(member.user_id)
                        gangmembers[member.user_id] = {
                            rank = tonumber(member.gangrank),
                            lastLogin = nil,
                            name = nil
                        }
                    end
                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestMembers)
                        for _, member in ipairs(guestMembers) do
                            memberids[#memberids+1] = tonumber(member.user_id)
                            guestmembers[member.user_id] = {
                                name = nil
                            }
                        end
                        local placeholders = string.rep('?,', #memberids):sub(1, -2)
                        exports["corrupt"]:execute("SELECT * FROM corrupt_users WHERE id IN (" .. placeholders .. ")", memberids, function(playerData)
                            for _, playerRow in ipairs(playerData) do
                                local member_id = tonumber(playerRow.id)
                                if gangmembers[member_id] then
                                    gangmembers[member_id].lastLogin = playerRow.last_login
                                    gangmembers[member_id].name = playerRow.username
                                elseif guestmembers[member_id] then
                                    guestmembers[member_id].name = playerRow.username
                                end
                            end
                            local gangIsAdvanced = tobool(ganginfo[1].advanced)
                            TriggerClientEvent('CORRUPT:setGuestGangData', source, gangmembers, guestmembers, gangIsAdvanced)
                            for member_id, _ in pairs(gangmembers) do
                                local memberSource = CORRUPT.getUserSource(member_id)
                                if memberSource and memberSource ~= source then
                                    TriggerClientEvent("CORRUPT:addGangGuest", memberSource, user_id, {["name"] = CORRUPT.getPlayerName(source)})
                                end
                            end
                            for member_id, _ in pairs(guestmembers) do
                                local memberSource = CORRUPT.getUserSource(member_id)
                                if memberSource and memberSource ~= source then
                                    TriggerClientEvent("CORRUPT:addGuestGangGuest", memberSource, user_id, {["name"] = CORRUPT.getPlayerName(source)})
                                end
                            end
                        end)
                    end)
                end)
            end)
            syncRadio(source)
        end)
    else
        CORRUPT.notify(source, {"~r~You have not been invited to this gang."})
    end
end)



RegisterNetEvent("CORRUPT:leaveGang")
AddEventHandler("CORRUPT:leaveGang", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local userRank = 1
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if tonumber(member.user_id) == user_id then
                    userRank = tonumber(member.gangrank)
                end
                if userRank == 4 then
                    CORRUPT.notify(source, {"~r~You do cannot leave the gang as the owner."})
                    return
                end
                if memberSource and memberSource ~= source then
                    TriggerClientEvent('CORRUPT:removeGangMember', memberSource, user_id)
                end
            end
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                for _, member in ipairs(guestmembers) do
                    local memberSource = CORRUPT.getUserSource(member.user_id)
                    if memberSource and memberSource ~= source then
                        TriggerClientEvent('CORRUPT:removeGuestGangMember', memberSource, user_id)
                    end
                end
            end)
            MySQL.execute("corrupt_edit_user_gang_name", {['@user_id'] = user_id, ['@gangname'] = nil})
            MySQL.execute("corrupt_edit_user_gang_rank", {['@user_id'] = user_id, ['@gangrank'] = 1})
            TriggerClientEvent('CORRUPT:removeCachedGang', source)
            CORRUPT.notify(source, {"~g~You have left the gang."})
        end)
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)


RegisterNetEvent("CORRUPT:leaveGangAsGuest")
AddEventHandler("CORRUPT:leaveGangAsGuest", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local guestname = CORRUPT.getGuestName(user_id)
    if guestname and guestname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = guestname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource and memberSource ~= source then
                    TriggerClientEvent('CORRUPT:removeGangGuest', memberSource, user_id)
                end
            end
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = guestname}, function(guestmembers)
                for _, member in ipairs(guestmembers) do
                    local memberSource = CORRUPT.getUserSource(member.user_id)
                    if memberSource and memberSource ~= source then
                        TriggerClientEvent('CORRUPT:removeGuestGangGuest', memberSource, user_id)
                    end
                end
            end)
            MySQL.execute("corrupt_edit_user_guest_name", {['@user_id'] = user_id, ['@gangname'] = nil})
            TriggerClientEvent('CORRUPT:removeCachedGuestGang', source)
            CORRUPT.notify(source, {"~g~You have left the gang."})
        end)
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)


RegisterNetEvent("CORRUPT:kickMemberFromGang")
AddEventHandler("CORRUPT:kickMemberFromGang", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    local targetRank = CORRUPT.getGangRank(target_id)
    local userRank = CORRUPT.getGangRank(user_id)
    if gangname and gangname ~= "" then
        if userRank >= 3 then
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                for _, member in ipairs(gangmembers) do
                    local memberSource = CORRUPT.getUserSource(member.user_id)
                    if targetRank >= userRank then
                        CORRUPT.notify(source, {"~r~You do not have permission to kick."})
                        return
                    end
                    if memberSource and memberSource ~= target_source then
                        TriggerClientEvent('CORRUPT:removeGangMember', memberSource, target_id)
                    end
                end
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                    for _, member in ipairs(guestmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource and memberSource ~= target_source then
                            TriggerClientEvent('CORRUPT:removeGuestGangMember', memberSource, target_id)
                        end
                    end
                end)
                MySQL.execute("corrupt_edit_user_gang_name", {['@user_id'] = target_id, ['@gangname'] = nil})
                MySQL.execute("corrupt_edit_user_gang_rank", {['@user_id'] = target_id, ['@gangrank'] = 1})
                if target_source then
                    CORRUPT.notify(target_source, {"~r~You have been kicked from the gang."})
                    TriggerClientEvent('CORRUPT:removeCachedGang', target_source)
                end
                CORRUPT.notify(source, {"~g~You have successfully kicked the member from the gang."})
            end)
        else
            CORRUPT.notify(source, {"~r~You are not in a gang."})
        end
    end
end)



RegisterNetEvent("CORRUPT:kickGuestFromGang")
AddEventHandler("CORRUPT:kickGuestFromGang", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    local userRank = CORRUPT.getGangRank(user_id)
    if gangname and gangname ~= "" then
        if userRank >= 3 then
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                for _, member in ipairs(gangmembers) do
                    local memberSource = CORRUPT.getUserSource(member.user_id)
                    if memberSource and memberSource ~= target_source then
                        TriggerClientEvent('CORRUPT:removeGangGuest', memberSource, target_id)
                    end
                end
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                    for _, member in ipairs(guestmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource and memberSource ~= target_source then
                            TriggerClientEvent('CORRUPT:removeGuestGangGuest', memberSource, target_id)
                        end
                    end
                end)
                MySQL.execute("corrupt_edit_user_guest_name", {['@user_id'] = target_id, ['@gangname'] = nil})
                if target_source then
                    CORRUPT.notify(target_source, {"~r~You have been kicked from the guest gang."})
                    TriggerClientEvent('CORRUPT:removeCachedGuestGang', target_source)
                end
                CORRUPT.notify(source, {"~g~You have successfully kicked the member from the guest gang."})
            end)
        else
            CORRUPT.notify(source, {"~r~You are not in a gang."})
        end
    end
end)


RegisterNetEvent("CORRUPT:promoteUser")
AddEventHandler("CORRUPT:promoteUser", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    local targetRank = CORRUPT.getGangRank(target_id)
    local userRank = CORRUPT.getGangRank(user_id)
    if user_id == target_id then CORRUPT.notify(source, {"~r~You cannot promote yourself"}) return end
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            if userRank == 4 then
                if targetRank < 4 then
                    for _, member in ipairs(gangmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource then
                            TriggerClientEvent('CORRUPT:updateGangMemberRank', memberSource, target_id, targetRank + 1)
                        end
                    end
                    exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                        for _, member in ipairs(guestmembers) do
                            local memberSource = CORRUPT.getUserSource(member.user_id)
                            if memberSource and memberSource ~= target_source then
                                TriggerClientEvent('CORRUPT:updateGuestGangMemberRank', memberSource, target_id, targetRank + 1)
                            end
                        end
                    end)
                    MySQL.execute("corrupt_edit_user_gang_rank", {['@user_id'] = target_id, ['@gangrank'] = targetRank + 1})
                    if target_source then
                        CORRUPT.notify(target_source, {"~g~You have been promoted."})
                    end
                    CORRUPT.notify(source, {"~g~You have successfully promoted the member."})
                end
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)

RegisterNetEvent("CORRUPT:demoteUser")
AddEventHandler("CORRUPT:demoteUser", function(target_id)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local target_source = CORRUPT.getUserSource(target_id)
    local gangname = CORRUPT.getGangName(user_id)
    local targetRank = CORRUPT.getGangRank(target_id)
    local userRank = CORRUPT.getGangRank(user_id)
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                if userRank ~= 4 then
                    CORRUPT.notify(source, {"~r~You do not have permission to demote."})
                    return
                end
                if targetRank == 1 then
                    CORRUPT.notify(source, {"~r~You cannot demote this member any further."})
                    return
                end
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent('CORRUPT:updateGangMemberRank', memberSource, target_id, targetRank - 1)
                end
            end
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                for _, member in ipairs(guestmembers) do
                    local memberSource = CORRUPT.getUserSource(member.user_id)
                    if memberSource and memberSource ~= target_source then
                        TriggerClientEvent('CORRUPT:updateGuestGangMemberRank', memberSource, target_id, targetRank -1)
                    end
                end
            end)
            MySQL.execute("corrupt_edit_user_gang_rank", {['@user_id'] = target_id, ['@gangrank'] = targetRank - 1})
            if target_source then
                CORRUPT.notify(target_source, {"~r~You have been demoted."})
            end
            CORRUPT.notify(source, {"~g~You have successfully demoted the member."})
        end)
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)



RegisterNetEvent("CORRUPT:purchaseAdvancedGangLicense")
AddEventHandler("CORRUPT:purchaseAdvancedGangLicense", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if not gangname or gangname == "" then
        return
    end
    if CORRUPT.tryFullPayment(user_id, 25000000) then
        exports["corrupt"]:execute("UPDATE corrupt_gangs SET advanced = @advanced WHERE gangname = @gangname", {advanced = true, gangname = gangname}) 
        CORRUPT.notify(source, {"~g~You have purchased advanced gang license."})
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:setIsAdvanced", memberSource, true)
                end
            end
        end)
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
            for _, member in ipairs(guestmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:setGuestGangIsAdvanced", memberSource, true)
                end
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You do not have enough money."})
    end
end)



RegisterNetEvent("CORRUPT:requestGangLogs")
AddEventHandler("CORRUPT:requestGangLogs", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local logs = json.decode(ganginfo[1].logs)
                TriggerClientEvent("CORRUPT:setGangLogs", source, logs)
            else
                CORRUPT.notify(source, {"~r~Gang not found."})
            end
        end)
    end
end)


RegisterNetEvent("CORRUPT:depositGangBalance")
AddEventHandler("CORRUPT:depositGangBalance", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if not gangname or gangname == "" then
        CORRUPT.notify(source, {"~r~You are not in a gang."})
        return
    end
    if tonumber(amount) <= 0 then
        CORRUPT.notify(source, {"~r~Invalid Amount"})
        return
    end
    local funds = exports["corrupt"]:scalarSync("SELECT funds FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}) 
    local newBalance = tonumber(amount) - tonumber(amount) * 0.02
    local AddedFunds = tonumber(funds) + tonumber(newBalance)
    AddedFunds = math.floor(AddedFunds)
    newBalance = math.floor(newBalance)
    if CORRUPT.tryBankPayment(user_id, newBalance) then
        CORRUPT.notify(source, {"~g~Deposited £" .. getMoneyStringFormatted(newBalance) .. " with 2% tax paid."})
        CORRUPT.addGangLog(CORRUPT.getPlayerName(source), user_id, AddedFunds, newBalance)
        exports['corrupt']:execute("UPDATE corrupt_gangs SET funds = @funds WHERE gangname = @gangname", {['@funds'] = AddedFunds, ['@gangname'] = gangname})
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:updateGangDisplayMoney", memberSource, AddedFunds)
                end
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You do not have enough money."})
    end
end)

RegisterNetEvent("CORRUPT:depositAllGangBalance")
AddEventHandler("CORRUPT:depositAllGangBalance", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local currenttime = os.time()
    local amount = CORRUPT.getBankMoney(user_id)
    if gangname and gangname ~= "" then
        if not fundscooldown[gangname] or (currenttime - fundscooldown[gangname]) >= cooldown then
            fundscooldown[gangname] = currenttime
            local funds = exports["corrupt"]:scalarSync("SELECT funds FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}) 
            local newBalance = tonumber(amount) - tonumber(amount) * 0.02
            local AddedFunds = tonumber(funds) + tonumber(newBalance)
            AddedFunds = math.floor(AddedFunds)
            newBalance = math.floor(newBalance)
        
            if CORRUPT.tryBankPayment(user_id, newBalance) then
                CORRUPT.notify(source, {"~g~Deposited £" .. getMoneyStringFormatted(newBalance) .. " with 2% tax paid."})
                CORRUPT.addGangLog(CORRUPT.getPlayerName(source), user_id, AddedFunds, newBalance)
                exports['corrupt']:execute("UPDATE corrupt_gangs SET funds = @funds WHERE gangname = @gangname", {['@funds'] = AddedFunds, ['@gangname'] = gangname})
                exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                    for _, member in ipairs(gangmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource then
                            TriggerClientEvent("CORRUPT:updateGangDisplayMoney", memberSource, AddedFunds)
                        end
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~You do not have enough money."})
            end
        else
            CORRUPT.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[gangname])) .. " seconds"})
        end
    end
end)



RegisterNetEvent("CORRUPT:withdrawGangBalance")
AddEventHandler("CORRUPT:withdrawGangBalance", function(amount)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local userRank = CORRUPT.getGangRank(user_id)
    local maxWithdraw = CORRUPT.getGangWithdrawLimit(gangname)
    local currenttime = os.time()
    if gangname and gangname ~= "" then
        if userRank >= 3 then
            if maxWithdraw ~= nil then
                if tonumber(amount) > maxWithdraw then
                amount = maxWithdraw
                CORRUPTclient.notify(source, {"~r~You have reached the maximum withdraw limit so the maximum amount has been withdrawn."})
                end
            end


            if not fundscooldown[gangname] or (currenttime - fundscooldown[gangname]) >= cooldown then
                fundscooldown[gangname] = currenttime



                local funds = exports["corrupt"]:scalarSync("SELECT funds FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname})
                if tonumber(amount) < 0 then
                    CORRUPT.notify(source, {"~r~Invalid Amount"})
                    return
                end
                if tonumber(funds) == 0 then
                    CORRUPT.notify(source, {"~r~Unable to withdraw funds as the gang has no money."})
                    return
                end
                if tonumber(funds) < tonumber(amount) then
                    CORRUPT.notify(source, {"~r~Not enough Money."})
                else
                    CORRUPT.setBankMoney(user_id, (CORRUPT.getBankMoney(user_id))+tonumber(amount))
                    CORRUPT.notify(source, {"~g~Withdrew £"..getMoneyStringFormatted(amount)})
                    CORRUPT.addGangLog(CORRUPT.getPlayerName(source), user_id, tonumber(funds)-tonumber(amount), tonumber(amount))
                    exports["corrupt"]:execute("UPDATE corrupt_gangs SET funds = @funds WHERE gangname = @gangname", {['@funds'] = tonumber(funds)-tonumber(amount), ['@gangname'] = gangname})
                    exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                        for _, member in ipairs(gangmembers) do
                            local memberSource = CORRUPT.getUserSource(member.user_id)
                            if memberSource then
                                TriggerClientEvent("CORRUPT:updateGangDisplayMoney", memberSource, tonumber(funds)-tonumber(amount))
                            end
                        end
                    end)
                end
            else
                CORRUPT.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[gangName])) .. " seconds"})
            end
        end
    end
end)







RegisterNetEvent("CORRUPT:withdrawAllGangBalance")
AddEventHandler("CORRUPT:withdrawAllGangBalance", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local userRank = CORRUPT.getGangRank(user_id)
    local maxWithdraw = CORRUPT.getGangWithdrawLimit(gangname)
    local newBalance = 0
    local currenttime = os.time()
    if gangname and gangname ~= "" then
        if userRank >= 3 then
            if not fundscooldown[gangname] or (currenttime - fundscooldown[gangname]) >= cooldown then
                fundscooldown[gangname] = currenttime
                local funds = exports["corrupt"]:scalarSync("SELECT funds FROM corrupt_gangs WHERE gangname = @gangname", {['@gangname'] = gangname})
                if tonumber(funds) < 0 then
                    CORRUPT.notify(source, {"~r~Invalid Amount"})
                    return
                end
                if tonumber(funds) == 0 then
                    CORRUPT.notify(source, {"~r~Unable to withdraw funds as the gang has no money."})
                    return
                end
                -- if maxWithdraw ~= nil then
                --     if tonumber(funds) > maxWithdraw then
                --         newBalance = maxWithdraw
                --         CORRUPTclient.notify(source, {"~r~You have reached the maximum withdraw limit so the maximum amount has been withdrawn."})
                --     end
                -- end
                CORRUPT.setBankMoney(user_id, (CORRUPT.getBankMoney(user_id)) + tonumber(funds))
                CORRUPT.notify(source, {"~g~Withdrew £" .. getMoneyStringFormatted(funds)})
                CORRUPT.addGangLog(CORRUPT.getPlayerName(source), user_id, 0, tonumber(funds))
                exports["corrupt"]:execute("UPDATE corrupt_gangs SET funds = @funds WHERE gangname = @gangname", {['@funds'] = newBalance ~= 0 and newBalance or 0, ['@gangname'] = gangname})
                exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
                    for _, member in ipairs(gangmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource then
                            TriggerClientEvent("CORRUPT:updateGangDisplayMoney", memberSource, newBalance ~= 0 and newBalance or 0)
                        end
                    end
                end)
            else
                CORRUPT.notify(source, {"~r~Cooldown Wait " .. (cooldown - (currenttime - fundscooldown[gangname])) .. " seconds"})
            end
        end
    end
end)


RegisterNetEvent("CORRUPT:setGangPinnedEnabled")
AddEventHandler("CORRUPT:setGangPinnedEnabled", function(gang)
    local GangHealth = {}
    local GangPostion = {}
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local guestname = CORRUPT.getGuestName(user_id)
    local function updateGangHealth(members)
        for _, member in ipairs(members) do
            local memberSource = CORRUPT.getUserSource(member.user_id)
            if memberSource then
                local ped = GetPlayerPed(memberSource)
                if DoesEntityExist(ped) then
                    local health = GetEntityHealth(ped)
                    local armour = GetPedArmour(ped)
                    GangHealth[member.user_id] = {health = health, armour = armour}
                end
            end
        end
    end

    if gang == "own" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            updateGangHealth(gangmembers)
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(guestmembers)
                updateGangHealth(guestmembers)
                Wait(1000)
                TriggerClientEvent("CORRUPT:sendGangPinnedData", source, GangHealth)
                if GangPostion ~= nil then
                    TriggerClientEvent("CORRUPT:sendFarBlips", source, GangPostion)
                end
            end)
        end)
    elseif gang == "guest" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = guestname}, function(gangmembers)
            updateGangHealth(gangmembers)
            exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = guestname}, function(guestmembers)
                updateGangHealth(guestmembers)
                Wait(1000)
                TriggerClientEvent("CORRUPT:sendGangPinnedData", source, GangHealth)
                if GangPostion ~= nil then
                    TriggerClientEvent("CORRUPT:sendFarBlips", source, GangPostion)
                end
            end)
        end)
    end
end)



local colourwait = false
RegisterNetEvent("CORRUPT:setPersonalGangBlipColour")
AddEventHandler("CORRUPT:setPersonalGangBlipColour", function(color)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local guestname = CORRUPT.getGuestName(user_id)
    if gangname and gangname ~= "" then
        -- set it sql 
        exports['corrupt']:execute("UPDATE corrupt_user_gangs SET colour = @colour WHERE user_id = @user_id", {['@colour'] = color, ['@user_id'] = user_id})
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    if spawnedmembers[memberSource] then
                        TriggerClientEvent("CORRUPT:setGangMemberColour", memberSource, user_id, color)
                    end
                end
            end
        end)
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    if spawnedguests[memberSource] then
                        TriggerClientEvent("CORRUPT:setGuestGangMemberColour", memberSource, user_id, color)
                    end
                end
            end
        end)
    end
    if gangname and gangname ~= "" then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = guestname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    if spawnedmembers[memberSource] then
                        TriggerClientEvent("CORRUPT:setGangGuestColour", memberSource, user_id, color)
                    end
                end
            end
        end)
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = guestname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    if spawnedguests[memberSource] then
                        TriggerClientEvent("CORRUPT:setGuestGangGuestColour", memberSource, user_id, color)
                    end
                end
            end
        end)
    end
end)

RegisterNetEvent("CORRUPT:renameGang")
AddEventHandler("CORRUPT:renameGang", function(newname)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local gangnamecheck = exports["corrupt"]:scalarSync("SELECT gangname FROM corrupt_gangs WHERE gangname = @gangname", {gangname = newname})
    if gangnamecheck == nil then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:updateGangName", memberSource, newname)
                end
            end
        end)
        exports["corrupt"]:execute("UPDATE corrupt_gangs SET gangname = @newname WHERE gangname = @gangname", {newname = newname, gangname = gangname})
        exports["corrupt"]:execute("UPDATE corrupt_user_gangs SET gangname = @newname WHERE gangname = @gangname", {newname = newname, gangname = gangname})
        exports["corrupt"]:execute("UPDATE corrupt_user_gangs SET guestname = @newname WHERE guestname = @gangname", {newname = newname, gangname = gangname})
    else
        CORRUPT.notify(source, {"~r~Gang name is already taken."})
    end
end)

RegisterNetEvent("CORRUPT:setGangLimitWithdrawDeposit")
AddEventHandler("CORRUPT:setGangLimitWithdrawDeposit", function(state)
    local source = source
    CORRUPT.notify(source, {"~r~Currently disabled."})
    -- local user_id = CORRUPT.getUserId(source)
    -- local gangname = CORRUPT.getGangName(user_id)
    -- local userRank = CORRUPT.getGangRank(user_id)
    -- if gangname and gangname ~= "" then
    --    if userRank == 4 then
    --         exports["corrupt"]:execute("UPDATE corrupt_gangs SET limit = @limit WHERE gangname = @gangname", {limit = state, gangname = gangname})

    --         exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
    --             for _, member in ipairs(gangmembers) do
    --                 local memberSource = CORRUPT.getUserSource(member.user_id)
    --                 if memberSource then
    --                     TriggerClientEvent("CORRUPT:setGangLimitWithdrawDeposit", memberSource, state)
    --                 end
    --             end
    --         end)
    --         CORRUPT.notify(source, {"~g~You have set the gang limit to " ..(state and "true" or "false")})
    --     else
    --         CORRUPT.notify(source, {"~r~You do not have permission to set the gang limit."})
    --     end
    -- end
end)
RegisterNetEvent("CORRUPT:pingGangLocation")
AddEventHandler("CORRUPT:pingGangLocation", function(coords, guest)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    local guestname = CORRUPT.getGuestName(user_id)
    if not guest and gangname and gangname ~= "" then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:pingGangLocation", memberSource, user_id, coords)
                end
            end
        end)
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = gangname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:pingGuestGangLocation", memberSource, user_id, coords)
                end
            end
        end)
    elseif guest and gangname and gangname ~= "" then
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", {['@gangname'] = guestname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:pingGangLocation", memberSource, user_id, coords)
                end
            end
        end)
        exports['corrupt']:execute("SELECT * FROM corrupt_user_gangs WHERE guestname = @guestname", {['@guestname'] = guestname}, function(gangmembers)
            for _, member in ipairs(gangmembers) do
                local memberSource = CORRUPT.getUserSource(member.user_id)
                if memberSource then
                    TriggerClientEvent("CORRUPT:pingGuestGangLocation", memberSource, user_id, coords)
                end
            end
        end)
    end
end)

RegisterNetEvent("CORRUPT:setGangFit")
AddEventHandler("CORRUPT:setGangFit", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        if CORRUPT.getGangRank(user_id) == 4 then
            CORRUPTclient.getCustomization(source,{},function(customization)
                exports["corrupt"]:execute("UPDATE corrupt_gangs SET gangfit = @gangfit WHERE gangname = @gangname", {gangfit = json.encode(customization), gangname = gangname})
                CORRUPT.notify(source, {"~g~You have set the gang fit."})
            end)
        else
            CORRUPT.notify(source, {"~r~You do not have permission to set the gang fit."})
        end
    end
end)

RegisterNetEvent("CORRUPT:applyGangFit")
AddEventHandler("CORRUPT:applyGangFit", function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT gangfit FROM corrupt_gangs WHERE gangname = @gangname", {gangname = gangname}, function(ganginfo)
            if #ganginfo > 0 then
                local gangfit = json.decode(ganginfo[1].gangfit)
                if gangfit and gangfit ~= "" then
                    CORRUPTclient.setCustomization(source, {json.decode(ganginfo[1].gangfit)}, function()
                        CORRUPT.notify(source, {"~g~You have applied the gang fit."})
                    end)
                else
                    CORRUPT.notify(source, {"~r~Gang fit not found."})
                end
            end
        end)
    else
        CORRUPT.notify(source, {"~r~You are not in a gang."})
    end
end)


function CORRUPT.getGangTag(user_id)
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        local result = exports["corrupt"]:scalarSync("SELECT tag FROM corrupt_gangs WHERE gangname = @gangname", {gangname = gangname})
        if result then
            return result
        end
    end
    return ""
end

RegisterNetEvent("CORRUPT:setGangChatTag")
AddEventHandler("CORRUPT:setGangChatTag", function(tag)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    local gangname = CORRUPT.getGangName(user_id)
    for word in pairs(blockedWords) do
        if(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(tag:lower(), "-", ""), ",", ""), "%.", ""), " ", ""), "*", ""), "+", ""):find(blockedWords[word])) then
            CORRUPT.notify(source, {"~r~You cannot use this tag."})
            CancelEvent()
            return
        end
    end
    if gangname and gangname ~= "" then
        if CORRUPT.getGangRank(user_id) == 4 then
            exports["corrupt"]:execute("UPDATE corrupt_gangs SET tag = @tag WHERE gangname = @gangname", {tag = tag, gangname = gangname})
            CORRUPT.notify(source, {"~g~You have set the gang chat tag."})
        else
            CORRUPT.notify(source, {"~r~You do not have permission to set the gang chat tag."})
        end
    end
end)




function CORRUPT.addGangLog(name, user_id, newBalance, amount)
    if not name or not user_id or not newBalance or not amount then return end;
    local gangname = CORRUPT.getGangName(user_id)
    if gangname and gangname ~= "" then
        exports["corrupt"]:execute("SELECT * FROM corrupt_gangs WHERE gangname = @gangname", { gangname = gangname }, function(ganginfo)
            if ganginfo and #ganginfo > 0 then
                local ganglogs = {}
                if ganginfo[1].logs then
                    ganglogs = json.decode(ganginfo[1].logs)
                end
                local DataTable = {name = name, user_id = user_id, date = os.date("%d/%m/%Y at %X"), newBalance = newBalance, amount = amount}
                table.insert(ganglogs, 1, DataTable)
                exports["corrupt"]:execute("UPDATE corrupt_gangs SET logs = @logs WHERE gangname = @gangname", { logs = json.encode(ganglogs), gangname = gangname })
                exports["corrupt"]:execute("SELECT * FROM corrupt_user_gangs WHERE gangname = @gangname", { gangname = gangname }, function(gangmembers)
                    for _, member in ipairs(gangmembers) do
                        local memberSource = CORRUPT.getUserSource(member.user_id)
                        if memberSource then
                            TriggerClientEvent("CORRUPT:addGangLog", memberSource, DataTable)
                        end
                    end
                end)
            end
        end)
    end
end



RegisterNetEvent("CORRUPT:newGangPanic")
AddEventHandler("CORRUPT:newGangPanic", function(a,playerName)
    local source = source
    local user_id = CORRUPT.getUserId(source)   
    local peoplesids = {}
    local gangmembers = {}
    exports['corrupt']:execute('SELECT * FROM corrupt_gangs', function(gotGangs)
        for K,V in pairs(gotGangs) do
            local array = json.decode(V.gangmembers)
            for I,L in pairs(array) do
                if tostring(user_id) == I then
                    isingang = true
                    for U,D in pairs(array) do
                        peoplesids[tostring(U)] = tostring(D.gangPermission)
                    end
                    exports['corrupt']:execute('SELECT * FROM corrupt_users', function(gotUser)
                        for J,G in pairs(gotUser) do
                            if peoplesids[tostring(G.id)] ~= nil then
                                local player = CORRUPT.getUserSource(tonumber(G.id))
                                if player ~= nil then
                                    TriggerClientEvent("CORRUPT:returnPanic", player, player, a, playerName)
                                end
                            end
                        end
                    end)
                    break
                end
            end
        end
    end)
end)


Citizen.CreateThread(function()
    Wait(2500)
    exports['corrupt']:execute([[
    CREATE TABLE IF NOT EXISTS `corrupt_user_gangs` (
    `user_id` int(11) NOT NULL,
    `gangname` VARCHAR(100) NULL,
    PRIMARY KEY (`user_id`)
    );]])
end)