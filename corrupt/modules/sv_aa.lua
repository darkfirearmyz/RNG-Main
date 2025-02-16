RegisterServerEvent('CORRUPT:openAAMenu')
AddEventHandler('CORRUPT:openAAMenu', function()
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and CORRUPT.hasPermission(user_id, "aa.menu")then
      CORRUPTclient.openAAMenu(source,{})
    end
end)

RegisterServerEvent('CORRUPT:setAAMenu')
AddEventHandler('CORRUPT:setAAMenu', function(status)
    local source = source
    local user_id = CORRUPT.getUserId(source)
end)