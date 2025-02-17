local a = {{position = vector3(-933.89794921875, -808.49810791016, 15.908717155457), carName = "BMX", carID = "bmx"}}
local b = 0
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(c, d)
        if d then
            local e = function(f)
                PlaySound(-1, "Hit", "RESPAWN_SOUNDSET", 0, 0, 1)
                drawNativeNotification("Press ~INPUT_PICKUP~ spawn a " .. a[f.skateparkId].carName)
            end
            local g = function(f)
            end
            local h = function(f)
                print(GetGameTimer(), b)
                print(GetGameTimer() - b)
                if IsControlJustPressed(1, 38) then
                    if GetGameTimer() - b > 60000 then
                        local i = CORRUPT.loadModel(a[f.skateparkId].carID)
                        local j =
                            CreateVehicle(
                            i,
                            a[f.skateparkId].position.x,
                            a[f.skateparkId].position.y,
                            a[f.skateparkId].position.z + 0.5,
                            0.0,
                            true,
                            false
                        )
                        DecorSetInt(j, decor, 945)
                        SetVehicleOnGroundProperly(j)
                        SetEntityInvincible(j, false)
                        SetPedIntoVehicle(CORRUPT.getPlayerPed(), j, -1)
                        SetModelAsNoLongerNeeded(i)
                        b = GetGameTimer()
                    else
                        tvRP.notify("Please wait before spawning another BMX.")
                    end
                end
            end
            for k, l in pairs(a) do
                CORRUPT.createArea("skatepark_" .. k, l.position, 1.5, 6, e, g, h, {skateparkId = k})
                tvRP.addMarker(
                    l.position.x,
                    l.position.y,
                    l.position.z,
                    1.0,
                    1.0,
                    1.0,
                    255,
                    0,
                    0,
                    170,
                    50,
                    38,
                    false,
                    false,
                    true
                )
            end
        end
    end
)
