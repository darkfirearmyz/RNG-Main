local a = module("corrupt-assets", "cfg/cfg_weaponsonback")
local b = module("corrupt-assets", "cfg/weapons")
Citizen.CreateThread(function()
    for c, d in pairs(b.weapons) do
        if not a.weapons[d.hash] then
            if d.class == "SMG" then
                a.weapons[d.hash] = {bone = 58271,offset = vector3(-0.01, 0.1, -0.07),rotation = vector3(-55.0, 0.10, 0.0),model = GetHashKey(d.model),type = "SMG"}
            elseif d.class == "AR" then
                a.weapons[d.hash] = {bone = 24818,offset = vector3(-0.12, -0.12, -0.13),rotation = vector3(100.0, -3.0, 5.0),model = GetHashKey(d.model),type = "AR"}
            elseif d.class == "Heavy" then
                a.weapons[d.hash] = {bone = 24818,offset = vector3(-0.12, -0.12, -0.13),rotation = vector3(100.0, -3.0, 5.0),model = GetHashKey(d.model),type = "Heavy"}
            elseif d.class == "Melee" then
                a.weapons[d.hash] = {bone = 24818,offset = vector3(0.32, -0.15, 0.13),rotation = vector3(0.0, -90.0, 0.0),model = GetHashKey(d.model),type = "Melee"}
            elseif d.class == "Shotgun" then
                a.weapons[d.hash] = {bone = 24818,offset = vector3(-0.12, -0.12, -0.13),rotation = vector3(100.0, -3.0, 5.0),model = GetHashKey(d.model),type = "Shotgun"}
            end
        end
    end
end)
AddEventHandler("CORRUPT:setDiagonalWeapons",function()
    if not LocalPlayer.state.weaponsDiagonal then
        LocalPlayer.state:set("weaponsDiagonal", true, true)
    end
end)
AddEventHandler("CORRUPT:setVerticalWeapons",function()
    if LocalPlayer.state.weaponsDiagonal then
        LocalPlayer.state:set("weaponsDiagonal", nil, true)
    end
end)
AddEventHandler("CORRUPT:setFrontAR",function()
    if not LocalPlayer.state.frontAR then
        LocalPlayer.state:set("frontAR", true, true)
    end
end)
AddEventHandler("CORRUPT:setBackAR",function()
    if LocalPlayer.state.frontAR then
        LocalPlayer.state:set("frontAR", nil, true)
    end
end)
AddEventHandler("CORRUPT:setFrontSMG",function()
    if not LocalPlayer.state.frontSMG then
        LocalPlayer.state:set("frontSMG", true, true)
    end
end)
AddEventHandler("CORRUPT:setBackSMG",function()
    if LocalPlayer.state.frontSMG then
        LocalPlayer.state:set("frontSMG", nil, true)
    end
end)
local e = {}
local f = {}
local function g()
    local h = GetSelectedPedWeapon(PlayerPedId())
    local i = tvRP.getWeapons()
    local j = false
    local k = globalOnPoliceDuty and CORRUPT.getPlayerVehicle() ~= 0
    for l in pairs(i) do
        local m = GetHashKey(l)
        local n = a.weapons[m]
        if n then
            local o = (not k or n.type ~= "Heavy") and (CORRUPT.isEmergencyService() or not isInGreenzone) and not CORRUPT.isPlayerInAnimalForm()
            if e[m] and not o then
                e[m] = nil
                j = true
            elseif not e[m] and m ~= h and o then
                e[m] = l
                j = true
            end
        end
    end
    for m, l in pairs(e) do
        if not i[l] or m == h then
            e[m] = nil
            j = true
        end
    end
    if j then
        local p = {}
        for m in pairs(e) do
            table.insert(p, m)
        end
        if #p > 0 then
            LocalPlayer.state:set("weapons", p, true)
        else
            LocalPlayer.state:set("weapons", nil, true)
        end
    end
end
local function q(m, r)
    local d = a.weapons[m]
    if not d then
        return 0
    end
    local s = d.offset
    local t = d.rotation
    local u = d.bone
    if r.diagonal and s == vector3(-0.12, -0.12, -0.13) then
        s = vector3(0.0, -0.2, 0.0)
        t = vector3(0.0, 45.0, t.z)
    end
    if r.frontAR and d.type == "AR" then
        s = vector3(0.0, 0.18, 0.0)
        t = vector3(180.0, 148.0, 0.0)
    end
    if r.frontSMG and d.type == "SMG" then
        s = vector3(0.0, 0.18, 0.0)
        t = vector3(180.0, 148.0, 0.0)
        u = 24818
    end
    if not HasModelLoaded(d.model) then
        RequestModel(d.model)
        return 0
    end
    local v = 0
    if d.components then
        v = CreateWeaponObject(m, 0, 0.0, 0.0, 0.0, true, 1.0, false)
        for c, w in pairs(d.components) do
            GiveWeaponComponentToWeaponObject(v, w)
        end
        if d.removeComponents then
            for c, w in pairs(d.removeComponents) do
                RemoveWeaponComponentFromWeaponObject(v, w)
            end
        end
    else
        v = CreateObject(d.model, 0.0, 0.0, 0.0, false, false, false)
    end
    AttachEntityToEntity(v,r.ped,GetPedBoneIndex(r.ped, u),s.x,s.y,s.z,t.x,t.y,t.z,false,false,false,false,2,true)
    SetModelAsNoLongerNeeded(d.model)
    return v
end
local function x(r)
    for m, v in pairs(r.weapons) do
        if v ~= 0 then
            DeleteEntity(v)
            r.weapons[m] = 0
        end
    end
end
local function y(r)
    if r.ped == 0 then
        return
    end
    if not IsEntityVisible(r.ped) then
        x(r)
        return
    end
    for m, v in pairs(r.weapons) do
        if v == 0 then
            r.weapons[m] = q(m, r)
        end
    end
end
local function z()
    for A, r in pairs(f) do
        if r.playerIndex == -1 then
            r.playerIndex = GetPlayerFromServerId(A)
        end
        if r.playerIndex ~= -1 then
            for m, v in pairs(r.weapons) do
                if v ~= 0 and not IsEntityAttached(v) then
                    DeleteEntity(v)
                    r.weapons[m] = 0
                end
            end
            if r.ped == 0 or not DoesEntityExist(r.ped) then
                r.ped = GetPlayerPed(r.playerIndex)
            end
            y(r)
        end
    end
end
local B = 0
Citizen.CreateThread(function()
    while true do
        g()
        if B % 3 == 0 then
            z()
        end
        B = B + 1
        Citizen.Wait(1000)
    end
end)
RegisterNetEvent("onPlayerDropped",function(A)
    local r = f[A]
    if r then
        x(r)
        f[A] = nil
    end
end)
AddStateBagChangeHandler("weapons",nil,function(C, c, D)
    local A = tonumber(stringsplit(C, ":")[2])
    local r = f[A]
    if D == nil then
        if r then
            x(r)
            f[A] = nil
        end
        return
    end
    if r then
        for m, v in pairs(r.weapons) do
            if not table.has(D, m) then
                if v ~= 0 then
                    DeleteEntity(v)
                end
                r.weapons[m] = nil
                local d = a.weapons[m]
                if d then
                    SetModelAsNoLongerNeeded(d.model)
                end
            end
        end
        for c, m in pairs(D) do
            if not r.weapons[m] then
                r.weapons[m] = 0
            end
        end
        y(r)
    else
        local E = {}
        for c, m in pairs(D) do
            E[m] = 0
        end
        f[A] = {ped = 0,playerIndex = -1,weapons = D,diagonal = Player(A).state.weaponsDiagonal,frontAR = Player(A).state.frontAR,frontSMG = Player(A).state.frontSMG}
    end
end)
AddStateBagChangeHandler("weaponsDiagonal",nil,function(C, c, F)
    local A = tonumber(stringsplit(C, ":")[2])
    local r = f[A]
    if r and r.diagonal ~= F then
        r.diagonal = F
        x(r)
        y(r)
    end
end)
AddStateBagChangeHandler("frontAR",nil,function(C, c, F)
    local A = tonumber(stringsplit(C, ":")[2])
    local r = f[A]
    if r and r.frontAR ~= F then
        r.frontAR = F
        x(r)
        y(r)
    end
end)
AddStateBagChangeHandler("frontSMG",nil,function(C, c, F)
    local A = tonumber(stringsplit(C, ":")[2])
    local r = f[A]
    if r and r.frontSMG ~= F then
        r.frontSMG = F
        x(r)
        y(r)
    end
end)
AddEventHandler("onResourceStop",function(G)
    if GetCurrentResourceName() == G then
        for c, r in pairs(f) do
            x(r)
        end
    end
end)
