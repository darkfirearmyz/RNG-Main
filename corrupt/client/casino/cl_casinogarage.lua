AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(a, b)
        if b then
            local c = function(a)
                drawNativeNotification("Press [E] to teleport to garage")
            end
            local b = function(a)
            end
            local d = function(a)
                if IsControlJustPressed(0, 38) and tvRP.getPlayerCombatTimer() == 0 then
                    CORRUPT.teleport2(vector3(1363.3187255859, 184.85275268555, -50.02239453125), true)
                end
            end
            CORRUPT.createArea(
                "casino_garage",
                vector3(935.59118652344, 0.42197805643082, 77.7329765625),
                8,
                6,
                c,
                b,
                d,
                {}
            )
            tvRP.addMarker(
                935.59118652344,
                0.42197805643082,
                79.8329765625,
                2.5,
                2.5,
                2.5,
                0,
                30,
                255,
                170,
                50,
                30,
                false,
                false,
                true
            )
        end
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(a, b)
        if b then
            local c = function(a)
                drawNativeNotification("Press [E] to teleport outside")
            end
            local b = function(a)
                showCasinoChipsCashier(false)
            end
            local d = function(a)
                if IsControlJustPressed(0, 38) and tvRP.getPlayerCombatTimer() == 0 then
                    CORRUPT.teleport2(vector3(935.59118652344, 0.42197805643082, 77.7329765625), true)
                end
            end
            CORRUPT.createArea(
                "casino_garage_exit",
                vector3(1363.3187255859, 184.85275268555, -50.02239453125),
                10,
                6,
                c,
                b,
                d,
                {}
            )
            tvRP.addMarker(
                1363.3187255859,
                184.85275268555,
                -48.43239453125,
                2.5,
                2.5,
                2.5,
                0,
                30,
                255,
                170,
                50,
                30,
                false,
                false,
                true
            )
        end
    end
)
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(a, b)
        if b then
            local c = function(a)
                CORRUPT.teleport2(vector3(972.56701660156, 2.4923079013824, 80.007634765625), true)
                SetEntityHeading(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), 150.0)
            end
            local b = function(a)
            end
            local d = function(a)
                if IsControlJustPressed(0, 38) and tvRP.getPlayerCombatTimer() == 0 then
                    CORRUPT.teleport2(vector3(972.56701660156, 2.4923079013824, 80.007634765625), true)
                    SetEntityHeading(GetVehiclePedIsIn(CORRUPT.getPlayerPed(), false), 150.0)
                end
            end
            CORRUPT.createArea(
                "casino_office_exit",
                vector3(2638.2856445312, -328.36483764648, -65.743219726563),
                10,
                6,
                c,
                b,
                d,
                {}
            )
        end
    end
)
