insideDiamondCasino = false
AddEventHandler(
    "CORRUPT:onClientSpawn",
    function(a, b)
        if b then
            local c = vector3(1121.7922363281, 239.42251586914, -50.440742492676)
            local d = function(e)
                insideDiamondCasino = true
                tvRP.setCanAnim(false)
                CORRUPT.overrideTime(12, 0, 0)
                TriggerEvent("CORRUPT:enteredDiamondCasino")
                TriggerServerEvent("CORRUPT:getChips")
            end
            local f = function(e)
                insideDiamondCasino = false
                tvRP.setCanAnim(true)
                CORRUPT.cancelOverrideTimeWeather()
                TriggerEvent("CORRUPT:exitedDiamondCasino")
            end
            local g = function(e)
            end
            CORRUPT.createArea("Diamondcasino", c, 100.0, 20, d, f, g, {})
        end
    end
)
