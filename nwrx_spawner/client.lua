RegisterCommand('car', function(source, args, rawCommand)
    local modelName = args[1] or 'neon'  -- Default to 'neon' if no model provided
    local model = GetHashKey(modelName)
    
    if not IsModelInCdimage(model) or not IsModelAVehicle(model) then
        TriggerEvent('chat:addMessage', {
            args = {'Invalid vehicle model.'}
        })
        return
    end
    
    RequestModel(model)
    while not HasModelLoaded(model) do
        Citizen.Wait(0)
    end
    
    local playerPed = PlayerPedId()
    local coords = GetEntityCoords(playerPed)
    local heading = GetEntityHeading(playerPed)
    
    local vehicle = CreateVehicle(model, coords.x + 2, coords.y + 2, coords.z, heading, true, false)
    SetPedIntoVehicle(playerPed, vehicle, -1)
    SetModelAsNoLongerNeeded(model)
    
    TriggerEvent('chat:addMessage', {
        args = {'Spawned vehicle: ' .. modelName}
    })
end, false)

RegisterCommand('dv', function(source, args, rawCommand)
    local playerPed = PlayerPedId()
    local vehicle = nil
    
    if IsPedInAnyVehicle(playerPed, false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)
    else
        local coords = GetEntityCoords(playerPed)
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 5.0, 0, 71)  -- Radius 5.0
    end
    
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        TriggerEvent('chat:addMessage', {
            args = {'Vehicle deleted.'}
        })
    else
        TriggerEvent('chat:addMessage', {
            args = {'No vehicle found to delete.'}
        })
    end
end, false)