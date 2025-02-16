


-- Error handling



RegisterServerEvent("CORRUPT:clientIssue")
AddEventHandler("CORRUPT:clientIssue", function(title, body, data)
    title = title or "N/A"
    body = body or "N/A"
    data = data or "N/A"
    print(title, body)
    CORRUPT.sendWebhook("client-error", title, body .. "\n" .. data)
end)

RegisterServerEvent("CORRUPT:serverIssue")
AddEventHandler("CORRUPT:serverIssue", function(title, body, data)
    title = title or "N/A"
    body = body or "N/A"
    data = data or "N/A"
    print(title, body)
    CORRUPT.sendWebhook("server-error", title, body .. "\n" .. data)
end)