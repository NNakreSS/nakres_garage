QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject();
ESX = (Config.newEsx and GetResourceState('es_extended') == 'started') and exports["es_extended"]:getSharedObject();
if GetResourceState('es_extended') == 'started' and not ESX then
    TriggerEvent('esx:getSharedObject', function(obj)
        ESX = obj
    end)
end

getPlayerData = function(source)
    local data = nil;
    if QBCore then
        data = QBCore.Functions.GetPlayer(source)
    elseif Esx then
        ESX.GetPlayerFromId(source)
    end
    return data
end

spawnVehicle = function(source, model, coords)
    local ped = GetPlayerPed(source)
    model = type(model) == 'string' and joaat(model) or model
    local veh = CreateVehicle(model, coords.x, coords.y, coords.z, coords.w or 0.0, true, true)
    while not DoesEntityExist(veh) do
        Wait(0)
    end
    while GetVehiclePedIsIn(ped) ~= veh do
        Wait(0)
        TaskWarpPedIntoVehicle(ped, veh, -1)
    end
    while NetworkGetEntityOwner(veh) ~= source do
        Wait(0)
    end
    return veh
end

getCategoriFromClass = function(class)
    for categoriname, value in pairs(Config.vehicleCatagories) do
        if Nakres.Contains(value, class) then
            return categoriname;
        end
    end
    return nil;
end

-- json server

local jsonPath = ("/servers/adminGarages.json")
getJsonData = function()
    return json.decode(LoadResourceFile(ResourceName, jsonPath)) or {}
end

addJsonData = function(index, garage)
    local data = json.decode(LoadResourceFile(ResourceName, jsonPath)) or {}
    data[index] = garage
    SaveResourceFile(ResourceName, jsonPath, json.encode(data), -1)
end

addHouseGarage = function(houseindex, garageinfo)
    if not Config.Garages[houseindex] then
        garageinfo.type = 'house'
        Config.Garages[houseindex] = garageinfo;
        TriggerClientEvent(ResourceName .. 'client:addNewGarage', -1, houseindex, garageinfo)
        return true
    end
    return false
end

exports("addHouseGarage", addHouseGarage)
