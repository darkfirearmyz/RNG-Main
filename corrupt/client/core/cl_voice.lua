RegisterNetEvent(
    "CORRUPT:mutePlayers",
    function(a)
        for b, c in pairs(a) do
            exports["corrupt"]:mutePlayer(c, true)
        end
    end
)
RegisterNetEvent(
    "CORRUPT:mutePlayer",
    function(c)
        exports["corrupt"]:mutePlayer(c, true)
    end
)
RegisterNetEvent(
    "CORRUPT:unmutePlayer",
    function(c)
        exports["corrupt"]:mutePlayer(c, false)
    end
)
RegisterNetEvent(
    "CORRUPT:ToggleMutePlayer",
    function(c)
        exports["corrupt"]:mutePlayer(c, true)
        Citizen.Wait(60000)
        exports["corrupt"]:mutePlayer(c, false)
    end
)
function unmute(c)
    MumbleSetActive(false)
end
