RegisterCommand("bodybag",function()local a=tvRP.getNearestPlayer(3)if a then TriggerServerEvent("CORRUPT:requestBodyBag",a)else tvRP.notify("No one dead nearby")end end)RegisterNetEvent("CORRUPT:removeIfOwned",function(b)local c=CORRUPT.getObjectId(b,"bodybag_removeIfOwned")if c then if DoesEntityExist(c)then if NetworkHasControlOfEntity(c)then DeleteEntity(c)end end end end)RegisterNetEvent("CORRUPT:placeBodyBag",function()local d=CORRUPT.getPlayerPed()local e=GetEntityCoords(d)local f=GetEntityHeading(d)SetEntityVisible(d,false,0)local g=CORRUPT.loadModel(`xm_prop_body_bag`)local h=CreateObject(g,e.x,e.y,e.z,true,true,true)DecorSetInt(h,"CORRUPTACVeh",955)PlaceObjectOnGroundProperly(h)SetModelAsNoLongerNeeded(g)local b=ObjToNet(h)TriggerServerEvent("CORRUPT:removeBodybag",b)while GetEntityHealth(CORRUPT.getPlayerPed())<=102 do Wait(0)end;DeleteEntity(h)SetEntityVisible(d,true,0)end)