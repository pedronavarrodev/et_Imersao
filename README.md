Olá, fico feliz em te ver aqui :D

Aqui vai um tutorial para te auxiliar no uso

# Para ativar o efeito com item
TriggerClientEvent("npcIgualSeguir", source)

# Para desativar o efeito
TriggerClientEvent("npcsDeletarEfeitos", source)

# Para testar o efeito utilize ( o tempo é em segundos )
/efeitos TEMPO

# Exemplo
/efeitos 60

# Para cancelar o efeito imediatamente
/efeitosc

Isso te dará 60 segundos com o efeito

# Exemplo de utilização no item do seu inventário ( Inventário do DopeNuis )

```
elseif item == "moranguinho" then
  if vRP.tryGetInventoryItem(user_id,"moranguinho",1,slot) then
      actived[user_id] = true
      TriggerClientEvent("dpn_inventory_chest:updateInventory", source)
      TriggerClientEvent('cancelando',source,true)
      -- vRPclient._CarregarObjeto(source,"mp_player_intdrink","loop_bottle","mah_coke",49,60309)
      vRPclient._playAnim(source,true,{{"mp_suicide","pill"}},false)
      TriggerClientEvent("progress",source,6900,"Experimentando...")
      Wait(3600)
      vRPclient._playAnim(source,true,{{"anim@amb@nightclub@peds@","missfbi3_party_snort_coke_b_male3"}},true)
      Wait(2500)
      -- Exemplo de chamada do evento
      TriggerClientEvent("startScreenFadeOut", source)
      Wait(2000)
      TriggerClientEvent('cancelando',source,false)
      vRPclient._stopAnim(source,false)
      vRPclient._DeletarObjeto(source)
      TriggerClientEvent("npcIgualSeguir",source)
      SetTimeout(1000,function()
          actived[user_id] = nil
          TriggerClientEvent('cancelando',source,false)
          vRPclient._DeletarObjeto(source)
          vRPclient._stopAnim(source,false)
      end)
  end
```
# Para mais configurações, utilize o arquivo config.lua
Nesse arquivo tem tudo que você precisa alterar se quiser

# Se não souber como fazer funcionar, basta abrir um ticket na minha loja ou me chamar no privado ( Meu discord está no Fxmanifest )
A instalação do script em seu inventário/base é cobrada uma pequena taxa

# Obrigado por baixar ♥
Minha loja: https://discord.gg/KNNW93QD2P