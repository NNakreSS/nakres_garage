---@class Garages
Garages = {
    allGarageVehicles = nil,
    previewVehicles = {},
    previewSpawnAreaIndex = {},
    adminGarages = {}
}

--- Creates areas and NPCs for all garages; sufficient to be initialized once when the script is started.
Garages.createAll = function()
    for index, garage in pairs(Config.Garages) do
        Garages.create(index, garage)
    end
end

--- @param index string garage index
--- @param garage table garage
Garages.create = function(index, garage)
    if garage.showBlip and garage.type ~= 'house' then
        Garages.createBlips(garage);
    end

    Zone.createTargetPed(index, garage);
    if garage.type == "job" then
        if Player.job.name == garage.job or Player.job.type == garage.jobType then
            Zone.create("garageArea", garage, index);
        end
    elseif garage.type == "gang" then
        if Player.gang == garage.job then
            Zone.create("garageArea", garage, index);
        end
    else
        Zone.create("garageArea", garage, index);
    end
end

--- Creates blips for garages on the map.
--- @param blip table garage
Garages.createBlips = function(blip)
    local Garage = AddBlipForCoord(blip.takeVehicle.x, blip.takeVehicle.y, blip.takeVehicle.z);
    SetBlipSprite(Garage, blip.blipNumber);
    SetBlipDisplay(Garage, Config.blipsDisplay);
    SetBlipScale(Garage, blip.blipScale or Config.blipsScale);
    SetBlipAsShortRange(Garage, Config.blipsAsShortRange);
    SetBlipColour(Garage, blip.blipColor);
    BeginTextCommandSetBlipName("STRING");
    AddTextComponentSubstringPlayerName(blip.blipName);
    EndTextCommandSetBlipName(Garage);
end

--- @param garageType string garage type
--- @param garageIndex string garage index
Garages.getVehicles = function(garageType, garageIndex)
    return Nakres.Client.AwaitTriggerCallback(ResourceName .. ':server:Callback:getGarageVehicles',
        garageIndex,
        garageType);
end

Garages.createPreview = function()
    if not Garages.allGarageVehicles then
        Garages.allGarageVehicles = Nakres.Client.AwaitTriggerCallback(ResourceName ..
            ':server:Callback:getAllGarageVehicles')
    end
    local pCoord = GetEntityCoords(PlayerPedId())
    for index, garage in pairs(Config.Garages) do
        if garage["type"] ~= 'depot' and garage["type"] ~= 'house' then
            if garage.previewsCoords then
                local garageCoord = vector3(garage.takeVehicle.x, garage.takeVehicle.y, garage.takeVehicle.z);
                local dst = #(pCoord - garageCoord);
                Garages.previewVehicles[index] = Garages.previewVehicles[index] or {};
                Garages.previewSpawnAreaIndex[index] = Garages.previewSpawnAreaIndex[index] or {};
                if dst <= 150 then
                    local vehicles = Garages.allGarageVehicles[index] or {};
                    for i_, vehicle in ipairs(vehicles) do
                        local plate = vehicle.plate
                        local mods = json.decode(vehicle.mods)
                        if not Garages.previewVehicles[index][plate] then
                            for i = 1, #garage.previewsCoords do
                                if garage.previewsCoords[i] then
                                    if not Garages.previewSpawnAreaIndex[index]['area_' .. i] then
                                        LoadedModel(mods.model)
                                        local x, y, z, w = table.unpack(garage.previewsCoords[i])
                                        local prevVeh = CreateVehicle(mods.model, x, y, z, w,
                                            false, false);
                                        PlaceObjectOnGroundProperly(prevVeh);
                                        FreezeEntityPosition(prevVeh, true)
                                        Vehicle.setProperties(prevVeh, mods)
                                        Garages.previewVehicles[index][plate] = {
                                            veh = prevVeh,
                                            areaIndex = i
                                        }
                                        SetVehicleDoorsLocked(prevVeh, 2)
                                        Garages.previewSpawnAreaIndex[index]['area_' .. i] = true
                                        break
                                    end
                                else
                                    break
                                end
                            end
                        end
                    end
                else
                    if Garages.previewVehicles[index] then
                        for plate, vehicle in pairs(Garages.previewVehicles[index]) do
                            if vehicle.veh then
                                Vehicle.delete(vehicle.veh)
                                Garages.previewSpawnAreaIndex[index]['area_' .. vehicle.areaIndex] = false
                            end
                            Garages.previewVehicles[index][plate] = nil
                        end
                    end
                end
            end
        end
    end
end

RegisterNetEvent(ResourceName .. ':client:vehicleDeleteGaragePreview', function(garage, plate)
    Garages.previewVehicles[garage] = Garages.previewVehicles[garage] or {}
    local veh = Garages.previewVehicles[garage][plate]
    if Garages.allGarageVehicles[garage] then
        for index, _vehicle in ipairs(Garages.allGarageVehicles[garage]) do
            if _vehicle.plate == plate then
                table.remove(Garages.allGarageVehicles[garage], index)
                break
            end
        end
    end
    if veh then
        Vehicle.delete(veh.veh)
        Garages.previewSpawnAreaIndex[garage]['area_' .. veh.areaIndex] = false
    end
    Garages.previewVehicles[garage][plate] = nil
end)

RegisterNetEvent(ResourceName .. ':client:vehicleAddGaragePreview', function(garage, vehicle)
    Garages.allGarageVehicles[garage] = Garages.allGarageVehicles[garage] or {}
    table.insert(Garages.allGarageVehicles[garage], vehicle)
    Garages.createPreview();
end)
