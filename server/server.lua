local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
local Tools = module("vrp","lib/Tools")
vRP = Proxy.getInterface("vRP")
src = {}
Tunnel.bindInterface(GetCurrentResourceName(),src)
vRPclient = Tunnel.getInterface("vRP")
-----------------------------------------------------------------------------------------------------------------------------------------
-- CHECK ROUPAS
-----------------------------------------------------------------------------------------------------------------------------------------
function src.checkPerm()
   local source = source
   local user_id = vRP.getUserId(source)
   if user_id then
      if vRP.hasPermission(user_id,config.perm) then
         return true
      else
         return false
      end
   end
end

function src.cancelAnims()
   local source = source
   local user_id = vRP.getUserId(source)
   if user_id then
      TriggerClientEvent('cancelando',source,false)
      vRPclient._stopAnim(source,false)
      vRPclient._DeletarObjeto(source)
      TriggerClientEvent("npcsDeletarEfeitos", source)
   end
end