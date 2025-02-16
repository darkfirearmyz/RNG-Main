RegisterServerEvent('CORRUPT:setCarDevMode')
AddEventHandler('CORRUPT:setCarDevMode', function(status)
    local source = source
    local user_id = CORRUPT.getUserId(source)
    if user_id ~= nil and CORRUPT.hasPermission(user_id, "cardev.menu") then 
      if status then
        CORRUPT.setBucket(source, 333)
      else
        CORRUPT.setBucket(source, 0)
      end
    else
      TriggerEvent("CORRUPT:AntiCheat", user_id, 11, CORRUPT.getPlayerName(source), source, 'Attempted to Teleport to Car Dev Universe')
    end
end)