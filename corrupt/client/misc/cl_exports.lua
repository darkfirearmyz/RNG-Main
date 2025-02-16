local a
local function b(c, d, e, f)
    if f == nil then
        f = function()
        end
    end
    if a then
        SendNUIMessage({act = "close_prompt"})
        while a do
            Wait(0)
        end
    end
    SendNUIMessage({act = "open_prompt", type = e, title = c, text = tostring(d)})
    SetNuiFocus(true, false)
    a = f
end
function CORRUPT.clientPrompt(c, d, f)
    b(c, d, "client", f)
end
function tvRP.prompt(c, d)
    b(c, d, "server", nil)
end
RegisterNUICallback(
    "prompt",
    function(g, f)
        if g.act == "close" then
            SetNuiFocus(false, false)
            if g.type ~= "client" then
                TriggerServerEvent("CORRUPT:promptResult", g.result)
            end
            if a then
                a(g.result)
                a = nil
            end
        end
    end
)
RegisterNetEvent("CORRUPT:OpenUrl", function(url)
    SendNUIMessage({act = "openurl", url = url})
end)
function CORRUPT.OpenUrl(j)
    SendNUIMessage({act = "openurl", url = j})
end
exports("prompt", CORRUPT.clientPrompt)
exports(
    "playSound",
    function(h)
        SendNUIMessage({transactionType = h})
    end
)
function tvRP.copyToClipboard(i)
    SendNUIMessage({act = "copy_clipboard", text = tostring(i)})
end
