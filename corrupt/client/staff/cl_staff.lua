usingDelgun = false
local a = false
local b = {
    "a_c_westy",
    "a_c_cat_01",
    "a_c_poodle",
    "a_c_pug",
    "a_c_retriever",
    "a_c_chop",
    "a_c_cow",
    "a_c_chimp",
    "a_c_cormorant",
    "a_c_coyote",
    "a_c_husky",
    "a_c_mtlion",
    "a_c_pig",
    "a_c_rabbit_01",
    "a_c_rat",
    "a_c_seagull",
    "a_c_crow"
}
local c = function(d)
    local e = {}
    local f = GetGameTimer() / 200
    e.r = math.floor(math.sin(f * d + 0) * 127 + 128)
    e.g = math.floor(math.sin(f * d + 2) * 127 + 128)
    e.b = math.floor(math.sin(f * d + 4) * 127 + 128)
    return e
end
RegisterCommand(
    "delgun",
    function()
        if CORRUPT.getStaffLevel() > 0 then
            usingDelgun = not usingDelgun
            local g = CORRUPT.getPlayerPed()
            local h = "WEAPON_STAFFGUN"
            if usingDelgun then
                a = HasPedGotWeapon(g, h, false)
                CORRUPT.allowweapon(h)
                GiveWeaponToPed(g, h, nil, false, true)
                drawNativeText("~b~Aim ~w~at an object and press ~b~Enter ~w~to delete it. ~r~Have fun!")
                drawNativeNotification("Don't forget to use ~b~/delgun ~w~to disable the delete gun!")
            else
                if not a then
                    RemoveWeaponFromPed(g, h)
                end
                a = false
            end
        end
    end,
    false
)
RegisterNetEvent(
    "CORRUPT:returnObjectDeleted",
    function(i)
        drawNativeNotification(i)
    end
)
local j = 0
function func_staffDelGun(k)
    if usingDelgun then
        j = j + 1
        if j > 1000 then
            j = 0
        end
        DisableControlAction(1, 18, true)
        DisablePlayerFiring(PlayerId(), true)
        if IsPlayerFreeAiming(k.playerId) then
            local l, m = GetEntityPlayerIsFreeAimingAt(k.playerId)
            if l then
                local n = GetEntityType(m)
                local o = true
                if o then
                    local p = GetEntityCoords(m)
                    local q = c(0.5)
                    DrawMarker(
                        1,
                        p.x,
                        p.y,
                        p.z - 1.02,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0,
                        0.7,
                        0.7,
                        1.5,
                        q.r,
                        q.g,
                        q.b,
                        200,
                        0,
                        0,
                        2,
                        0,
                        0,
                        0,
                        0
                    )
                    if IsDisabledControlJustPressed(1, 18) then
                        local r = NetworkGetNetworkIdFromEntity(m)
                        TriggerServerEvent("CORRUPT:delGunDelete", r)
                        if GetEntityType(m) == 2 then
                            SetEntityAsMissionEntity(m, false, true)
                            DeleteVehicle(m)
                        end
                    end
                else
                    print("not alowed")
                end
            end
        end
    end
end
RegisterNetEvent(
    "CORRUPT:deletePropClient",
    function(r)
        local s = CORRUPT.getObjectId(r)
        if DoesEntityExist(s) then
            DeleteEntity(s)
        end
    end
)
CORRUPT.createThreadOnTick(func_staffDelGun)
local t = {}
function CORRUPT.isLocalPlayerHidden()
    if t[CORRUPT.getUserId()] then
        return true
    else
        return false
    end
end
function CORRUPT.isUserHidden(u)
    if t[u] and not CORRUPT.isDeveloper(CORRUPT.getUserId()) and CORRUPT.getUserId() ~= u then
        return true
    else
        return false
    end
end
RegisterNetEvent(
    "CORRUPT:setHiddenUsers",
    function(v)
        t = v
    end
)
