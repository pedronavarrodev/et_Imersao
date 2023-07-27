local Tunnel = module("vrp","lib/Tunnel")
local Proxy = module("vrp","lib/Proxy")
vRP = Proxy.getInterface("vRP")
src = Tunnel.getInterface(GetCurrentResourceName(),src)

local spawnedPeds = {} -- Tabela para manter o controle dos peds spawnados
local isPedsModeActive = false -- Variável para controlar o modo de peds

-- Seta tudo para desligado
ClearTimecycleModifier() -- reseta as definições do player
ResetScenarioTypesEnabled() -- reseta as definições do player
ResetPedMovementClipset(PlayerPedId()) -- reseta as definições do player

-- Evento para iniciar o script
RegisterNetEvent("npcIgualSeguir")
AddEventHandler("npcIgualSeguir", function()
isPedsModeActive = true
-- Verifica se o jogador já possui peds spawnados
if #spawnedPeds > 0 then
   -- Se já existirem peds, remove todos antes de spawnar novos
   for _, ped in ipairs(spawnedPeds) do
      if DoesEntityExist(ped) then
         DeletePed(ped)
      end
   end
   spawnedPeds = {}
end

-- Obtém a posição atual do jogador
local playerPed = PlayerPedId()
local playerCoords = GetEntityCoords(playerPed)

-- Loop para spawnar os peds
for i = 1, config.quantidadePeds do -- Neste exemplo, spawnaremos 5 peds
   -- Spawna o ped como clone do jogador
   local spawnedPed = ClonePed(playerPed, GetEntityHeading(playerPed), true, true)
   table.insert(spawnedPeds, spawnedPed)

   -- Configura o ped para seguir o jogador
   TaskFollowToOffsetOfEntity(spawnedPed, playerPed, 0.5, 0.5, 0.5, 1, -1, 0, true)
   local mascara = math.random( 149,153) -- valor randomico para mascara de moranguinho/abacaxi/cereja/uva
   SetPedComponentVariation(spawnedPed, 1, mascara, 0, 0, 0) -- coloca a mascara (149 moranguinho)
   -- Configura o ped para não ser visível para outros jogadores
   NetworkSetEntityInvisibleToNetwork(spawnedPed, true)

   -- Define o ped como invencível
   SetEntityInvincible(spawnedPed, true)

   -- Desativa os efeitos de ragdoll para o ped
   SetPedCanRagdoll(spawnedPed, false)

   -- Remove o ataque padrão do ped
   SetBlockingOfNonTemporaryEvents(spawnedPed, true)

end
-- Deixa o jogador bêbado por 30 segundos e com a visão turva
    RequestAnimSet(config.requestAnim)
    while not HasAnimSetLoaded(config.requestAnim) do
      Citizen.Wait(0)
    end
    SetTimecycleModifier(config.efeitoTela)
    Citizen.Wait(config.tempoDuracao * 1000)
    ClearTimecycleModifier()
    ResetScenarioTypesEnabled()
    ResetPedMovementClipset(playerPed)
    src.cancelAnims()
    TriggerEvent("npcsDeletarEfeitos") -- Se o modo estiver ativado, deleta  os peds
end)

-- Função para fazer o ped entrar no carro
function PedEnterVehicle(ped, vehicle)
   TaskEnterVehicle(ped, vehicle, -1, 2, 1.0, 1, 0)
end

-- Evento para receber a notificação sobre o modo de peds
RegisterNetEvent("npcsDeletarEfeitos")
AddEventHandler("npcsDeletarEfeitos", function(status)
    if status then
      TriggerEvent("spawnPeds") -- Se o modo estiver ativado, cria os peds
    else
      for _, ped in ipairs(spawnedPeds) do
          if DoesEntityExist(ped) then
            DeletePed(ped)
            ClearTimecycleModifier()
            ResetScenarioTypesEnabled()
            ResetPedMovementClipset(playerPed)
            src.cancelAnims()
          end
      end
      spawnedPeds = {}
    end
end)

-- Comando para ativar/desativar o modo de peds
local efeitoIniciado = false

RegisterCommand("efeitos", function(source, args, rawCommand)
    if src.checkPerm() then
        if not parseInt(args[1]) then
            return
        else
            local timeInMinutes = tonumber(args[1])
            if timeInMinutes and timeInMinutes > 0 then
                local timeInMilliseconds = timeInMinutes * 1000 -- Converter milisegundos para segundos
                if not efeitoIniciado then
                    efeitoIniciado = true
                     TriggerEvent("npcIgualSeguir")
                     TriggerEvent('Notify', 'aviso', 'Testando efeito por '..timeInMinutes..' segundos.', 4000)

                    SetTimeout(timeInMilliseconds, function()
                        for _, ped in ipairs(spawnedPeds) do
                            if DoesEntityExist(ped) then
                                DeletePed(ped)
                                efeitoIniciado = false
                            end
                        end
                        spawnedPeds = {}
                        isPedsModeActive = false
                        ClearTimecycleModifier()
                        ResetScenarioTypesEnabled()
                        ResetPedMovementClipset(PlayerPedId())
                        TriggerEvent('Notify', 'aviso', 'O efeito passou e durou '..timeInMinutes..' segundos.', 4000)
                        efeitoIniciado = false
                    end)
                else
                    TriggerEvent('Notify', 'aviso', 'O efeito já está em andamento.', 4000)
                end
            else
                TriggerEvent('Notify', 'aviso', 'Você precisa colocar o tempo válido do efeito em segundos.', 4000)
            end
        end
    else
        TriggerEvent('Notify', 'negado', 'Sem permissão para utilizar esse comando.', 4000)
    end
end)


RegisterCommand("efeitosc", function(source, args, rawCommand)
    if src.checkPerm() then
      TriggerEvent("npcsDeletarEfeitos") -- Se o modo estiver ativado, cria os peds
      ClearTimecycleModifier() -- reseta as definições do player
      ResetScenarioTypesEnabled() -- reseta as definições do player
      ResetPedMovementClipset(PlayerPedId()) -- reseta as definições do player
      TriggerEvent('Notify', 'aviso', 'Todos os efeitos foram cancelados.', 4000)
    else
      TriggerEvent('Notify', 'negado', 'Sem permissão para utilizar esse comando.', 4000)
    end
end)

function GetEmptyVehicleSeat(vehicle)
   for i = -1, GetVehicleMaxNumberOfPassengers(vehicle) do
      print(GetVehicleMaxNumberOfPassengers(vehicle))
      if IsVehicleSeatFree(vehicle, i) then
         return i
      end
   end
   return -1 -- Retorna -1 se não encontrar nenhum banco vazio
end

-- Verifica se o jogador está em um carro e faz os peds entrar no carro junto com ele
Citizen.CreateThread(function()
while true do
   if isPedsModeActive then
      local playerPed = PlayerPedId()
      local vehicle = GetVehiclePedIsIn(playerPed, false)

      if DoesEntityExist(vehicle) and GetPedInVehicleSeat(vehicle, -1) == playerPed then
         local emptySeat = GetEmptyVehicleSeat(vehicle)

         for _, ped in ipairs(spawnedPeds) do
            if DoesEntityExist(ped) and not IsEntityDead(ped) then
               if emptySeat ~= -1 then
                  PedEnterVehicle(ped, vehicle, -1, emptySeat, 1.0, 1, 0)
               else
                  -- Caso todos os bancos estejam ocupados, faça o ped seguir o jogador
                  TaskFollowToOffsetOfEntity(ped, playerPed, 0.5, 0.5, 0.5, 1, -1, 0, true)
               end
            end
         end
      end
   end
   Citizen.Wait(3000)
  end
end)


-- Função para realizar o efeito de fade out
function DoScreenFadeOutEvent()
   DoScreenFadeOut(1000)
   Wait(4000)
   DoScreenFadeIn(1000) -- 1000 milissegundos = 1 segundo
end

-- Registro do evento personalizado
RegisterNetEvent("startScreenFadeOut")
AddEventHandler("startScreenFadeOut", function()
    DoScreenFadeOutEvent()
end)
