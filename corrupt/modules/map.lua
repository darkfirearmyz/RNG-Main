
local client_areas = {}

-- free client areas when leaving
AddEventHandler("CORRUPT:playerLeave",function(user_id,source)
  client_areas[source] = nil 
end)

-- create/update a player area
function CORRUPT.setArea(source,name,x,y,z,radius,height,cb_enter,cb_leave)
  local areas = client_areas[source] or {}
  client_areas[source] = areas

  areas[name] = {enter=cb_enter,leave=cb_leave}
  CORRUPTclient.setArea(source,{name,x,y,z,radius,height})
end

-- delete a player area
function CORRUPT.removeArea(source,name)
  -- delete remote area
  CORRUPTclient.removeArea(source,{name})

  -- delete local area
  local areas = client_areas[source]
  if areas then
    areas[name] = nil
  end
end

-- TUNNER SERVER API
RegisterNetEvent("CORRUPT:enterArea")
AddEventHandler("CORRUPT:enterArea",function(name)
  CORRUPT.enterArea(name)
end)
function CORRUPT.enterArea(name)
  local areas = client_areas[source]
  if areas then
    local area = areas[name] 
    if area and area.enter then -- trigger enter callback
      area.enter(source,name)
    end
  end
end
RegisterNetEvent("CORRUPT:leaveArea")
AddEventHandler("CORRUPT:leaveArea",function(name)
  CORRUPT.leaveArea(name)
end)
function CORRUPT.leaveArea(name)
  local areas = client_areas[source]

  if areas then
    local area = areas[name] 
    if area and area.leave then -- trigger leave callback
      area.leave(source,name)
    end
  end
end

