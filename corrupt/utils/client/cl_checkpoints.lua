local a = {}
function CORRUPT.createCheckpoint(b, c, d, e, f, g, h, i, j, k, l, m, n, o, p)
    if a[b] == nil then
        a[b] = {}
    end
    local q = "checkpoint_" .. generateUUID("checkpoints", 7, "alphanumeric")
    local r = CreateCheckpoint(c, d, e, f, g, h, i, j, k, l, m, n, o)
    SetCheckpointRgba2(r, 0, 204, 204, 150)
    local s = tvRP.addBlip(d, e, f, 570, 5)
    a[b][q] = {checkpointId = r, blipId = s}
    local function t()
    end
    local function u()
    end
    local function v()
        p(q, r)
    end
    CORRUPT.useIncreasedAreaRefreshRate(true)
    CORRUPT.createArea(q, vector3(d, e, f), j * 1.25, 10, v, t, u, {})
    return r, q
end
function CORRUPT.deleteCheckpoint(b, r)
    if a[b] ~= nil then
        if a[b][r] then
            if a[b][r].checkpointId then
                DeleteCheckpoint(a[b][r].checkpointId)
            end
        end
        if a[b][r] then
            if a[b][r].blipId then
                tvRP.removeBlip(a[b][r].blipId)
            end
        end
        tvRP.removeArea(r)
        a[b][r] = nil
        if table.count(a) == 0 then
            CORRUPT.useIncreasedAreaRefreshRate(false)
        end
    else
        print(b .. " is not valid.")
    end
end