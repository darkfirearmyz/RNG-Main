local cfg=module("cfg/cfg_groupselector")

function CORRUPT.getJobSelectors(source)
    local source=source
    local jobSelectors={}
    local user_id = CORRUPT.getUserId(source)
    for k,v in pairs(cfg.selectors) do
        for i,j in pairs(cfg.selectorTypes) do
            if v.type == i then
                if j._config.permissions[1]~=nil then
                    if CORRUPT.hasPermission(CORRUPT.getUserId(source),j._config.permissions[1])then
                        v['_config'] = j._config
                        v['jobs'] = {}
                        for a,b in pairs(j.jobs) do
                            if CORRUPT.hasGroup(user_id, b[1]) then
                                table.insert(v['jobs'], b)
                            end
                        end
                        jobSelectors[k] = v
                    end
                else
                    v['_config'] = j._config
                    v['jobs'] = j.jobs
                    jobSelectors[k] = v
                end
            end
        end
    end
    TriggerClientEvent("CORRUPT:gotJobSelectors",source,jobSelectors)
end

RegisterNetEvent("CORRUPT:getJobSelectors")
AddEventHandler("CORRUPT:getJobSelectors",function()
    local source = source
    CORRUPT.getJobSelectors(source)
end)

function CORRUPT.removeAllJobs(user_id)
    local source = CORRUPT.getUserSource(user_id)
    for i,j in pairs(cfg.selectorTypes) do
        for k,v in pairs(j.jobs)do
            if i == 'default' and CORRUPT.hasGroup(user_id, v[1]) then
                CORRUPT.removeUserGroup(user_id, v[1])
            elseif i ~= 'default' and CORRUPT.hasGroup(user_id, v[1]..' Clocked') then
                CORRUPT.removeUserGroup(user_id, v[1]..' Clocked')
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                CORRUPT.setArmour(source, 0)
                TriggerEvent('CORRUPT:clockedOffRemoveRadio', source)
            end
        end
    end
    -- remove all faction ranks
    CORRUPTclient.setPolice(source, {false})
    TriggerClientEvent('CORRUPT:globalOnPoliceDuty', source, false)
    CORRUPTclient.setNHS(source, {false})
    TriggerClientEvent('CORRUPT:globalOnNHSDuty', source, false)
    CORRUPTclient.setHMP(source, {false})
    TriggerClientEvent('CORRUPT:globalOnPrisonDuty', source, false)
    TriggerClientEvent('CORRUPT:disableFactionBlips', source)
    TriggerClientEvent('CORRUPT:radiosClearAll', source)
    TriggerClientEvent('CORRUPT:toggleTacoJob', source, false)
    CORRUPT.RefreshUserJob(user_id)
end

RegisterNetEvent("CORRUPT:jobSelector")
AddEventHandler("CORRUPT:jobSelector",function(a,b)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if #(GetEntityCoords(GetPlayerPed(source)) - cfg.selectors[a].position) > 20 then
        TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Triggering job selections from too far away')
        return
    end
    if b == "Unemployed" then
        CORRUPT.removeAllJobs(user_id)
        CORRUPT.notify(source, {"~g~You are now unemployed."})
    else
        if cfg.selectors[a].type == 'police' then
            if CORRUPT.hasGroup(user_id, b) then
                CORRUPT.removeAllJobs(user_id)
                CORRUPT.addUserGroup(user_id,b..' Clocked')
                CORRUPTclient.setPolice(source, {true})
                TriggerClientEvent('CORRUPT:globalOnPoliceDuty', source, true)
                CORRUPT.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                CORRUPT.sendWebhook('pd-clock', 'Corrupt Police Clock On Logs',"> Officer Name: **"..CORRUPT.getPlayerName(source).."**\n> Officer TempID: **"..source.."**\n> Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                CORRUPT.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'nhs' then
            if CORRUPT.hasGroup(user_id, b) then
                CORRUPT.removeAllJobs(user_id)
                CORRUPT.addUserGroup(user_id,b..' Clocked')
                CORRUPTclient.setNHS(source, {true})
                TriggerClientEvent('CORRUPT:globalOnNHSDuty', source, true)
                CORRUPT.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                CORRUPT.sendWebhook('nhs-clock', 'Corrupt NHS Clock On Logs',"> Medic Name: **"..CORRUPT.getPlayerName(source).."**\n> Medic TempID: **"..source.."**\n> Medic PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                CORRUPT.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        elseif cfg.selectors[a].type == 'hmp' then
            if CORRUPT.hasGroup(user_id, b) then
                CORRUPT.removeAllJobs(user_id)
                CORRUPT.addUserGroup(user_id,b..' Clocked')
                CORRUPTclient.setHMP(source, {true})
                TriggerClientEvent('CORRUPT:globalOnPrisonDuty', source, true)
                CORRUPT.notify(source, {"~g~Clocked on as "..b.."."})
                RemoveAllPedWeapons(GetPlayerPed(source), true)
                CORRUPT.sendWebhook('hmp-clock', 'Corrupt HMP Clock On Logs',"> Prison Officer Name: **"..CORRUPT.getPlayerName(source).."**\n> Prison Officer TempID: **"..source.."**\n> Prison Officer PermID: **"..user_id.."**\n> Clocked Rank: **"..b.."**")
            else
                CORRUPT.notify(source, {"You do not have permission to clock on as "..b.."."})
            end
        else
            CORRUPT.removeAllJobs(user_id)
            CORRUPT.addUserGroup(user_id,b)
            CORRUPT.notify(source, {"~g~Employed as "..b.."."})
            TriggerClientEvent('CORRUPT:jobInstructions',source,b)
            if b == 'Taco Seller' then
                TriggerClientEvent('CORRUPT:toggleTacoJob', source, true)
            end
        end
        TriggerEvent('CORRUPT:clockedOnCreateRadio', source)
        TriggerClientEvent('CORRUPT:radiosClearAll', source)
        TriggerClientEvent('CORRUPT:refreshGunStorePermissions', source)
        CORRUPT.RefreshUserJob(user_id)
    end
end)