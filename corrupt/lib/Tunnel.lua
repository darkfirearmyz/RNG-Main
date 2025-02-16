local Tools = module("lib/Tools")

-- this file describe a two way proxy between the server and the clients (request system)
local Tunnel = {}

-- define per dest regulator
Tunnel.delays = {}

-- set the base delay between Triggers for this destination in milliseconds (0 for instant trigger)
function Tunnel.setDestDelay(dest, delay)
  Tunnel.delays[dest] = {delay, 0}
end
local function tunnel_resolve(itable,key)
  local mtable = getmetatable(itable)
  local iname = mtable.name
  local ids = mtable.tunnel_ids
  local callbacks = mtable.tunnel_callbacks
  local identifier = mtable.identifier
  local fcall = function(dest,args,callback)
    if args == nil then
      args = {}
    end
    local delay_data = Tunnel.delays[dest]
    if delay_data == nil then
      delay_data = {0,0}
    end
    local add_delay = delay_data[1]
    delay_data[2] = delay_data[2]+add_delay
    if delay_data[2] > 0 then
      SetTimeout(delay_data[2], function() 
        delay_data[2] = delay_data[2]-add_delay

        if type(callback) == "function" then
          local rid = ids:gen()
          callbacks[rid] = callback
          TriggerClientEvent(iname..":tunnel_req",dest,key,args,identifier,rid)
        else
          TriggerClientEvent(iname..":tunnel_req",dest,key,args,"",-1)
        end
      end)
    else
      if type(callback) == "function" then 
        local rid = ids:gen()
        callbacks[rid] = callback
        TriggerClientEvent(iname..":tunnel_req",dest,key,args,identifier,rid)
      else
        TriggerClientEvent(iname..":tunnel_req",dest,key,args,"",-1)
      end
    end
  end

  itable[key] = fcall 
  return fcall
end


function Tunnel.bindInterface(name,interface)
  RegisterServerEvent(name..":tunnel_req")
  AddEventHandler(name..":tunnel_req",function(member,args,identifier,rid)
    local source = source
    local delayed = false
    local f = interface[member]
    local rets = {}
    if type(f) == "function" then
      TUNNEL_DELAYED = function()
        delayed = true
        return function(rets)
          rets = rets or {}
          if rid >= 0 then
            TriggerClientEvent(name..":"..identifier..":tunnel_res",source,rid,rets)
          end
        end
      end
      rets = {f(table.unpack(args))}
    end
    if not delayed and rid >= 0 then
      TriggerClientEvent(name..":"..identifier..":tunnel_res",source,rid,rets)
    end
  end)
end

function Tunnel.getInterface(name,identifier)
  local ids = Tools.newIDGenerator()
  local callbacks = {}
  local r = setmetatable({},{ __index = tunnel_resolve, name = name, tunnel_ids = ids, tunnel_callbacks = callbacks, identifier = identifier })
  RegisterServerEvent(name..":"..identifier..":tunnel_res")
  AddEventHandler(name..":"..identifier..":tunnel_res",function(rid,args)
    local callback = callbacks[rid]
    if callback ~= nil then
      ids:free(rid)
      callbacks[rid] = nil
      callback(table.unpack(args))
    end

  end)

  return r
end

return Tunnel