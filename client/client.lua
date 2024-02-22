CurrentGarage = nil;
CurrentGarageIndex = nil;
CurrentGarageVehicles = {};
EnteredParked = false;
HouseMarkers = false;
Markers = false;

QBCore = GetResourceState('qb-core') == 'started' and exports['qb-core']:GetCoreObject();
ESX = (Config.newEsx and GetResourceState('es_extended') == 'started') and exports["es_extended"]:getSharedObject();

Citizen.CreateThread(function()
    while true do
        Zone.checkDistanceGarageForNpc();
        if Config.garagePreview then
            Garages.createPreview();
        end
        Citizen.Wait(5000)
    end
end)

RegisterNetEvent(ResourceName .. ":openGarageMenu")
AddEventHandler(ResourceName .. ":openGarageMenu", function()
    local GarageVehicles = Garages.getVehicles(CurrentGarage.type, CurrentGarageIndex);
    if #GarageVehicles > 0 then
        NUI.vehicles = {};
        CurrentGarageVehicles = {};
        for _k, vehicle in pairs(GarageVehicles) do
            vehicle.mods = json.decode(vehicle.mods);
            local stats = vehicle.mods.stats or {};
            CurrentGarageVehicles[vehicle.plate] = vehicle;
            NUI.vehicles[#NUI.vehicles + 1] = {
                enginePercent = Nakres.Round(vehicle.engine / 10, 0),
                bodyPercent = Nakres.Round(vehicle.body / 10, 0),
                topSpeed = Nakres.Round((stats.topspeed or 0) / 300 * 100),
                acceleration = Nakres.Round((stats.acceleration or 0) * 150 or 0),
                brakes = Nakres.Round((stats.brakes or 0) * 80 or 0),
                traction = Nakres.Round((stats.traction or 0) * 10 or 0),
                fuelPercent = vehicle.fuel,
                plate = vehicle.plate,
                name = vehicle.mods.modelName,
                displayName = vehicle.mods.displayName,
                model = vehicle.mods.model,
                depotPrice = vehicle.depotprice
            };
        end
        local limit = (Config.uniqueGarages and Config.limitedGarages) and
                          (CurrentGarage.limit and CurrentGarage.limit or Config.defaultLimit) or
                          Text[Config.locale].ui.unlimited
        NUI.toggleUi(limit)
    else
        Config.Notify(Text[Config.locale].error.garage_not_vehicle, 'error')
    end
end)

RegisterNetEvent(ResourceName .. 'client:addNewGarage')
AddEventHandler(ResourceName .. 'client:addNewGarage', function(index, garage)
    if not Config.Garages[index] then
        Config.Garages[index] = garage
        Garages.create(index, garage)
    end
end)

RegisterNetEvent('esx:playerLoaded', function()
    startScript()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    startScript()
end)

AddEventHandler("onResourceStart", function(res)
    if res == ResourceName then
        startScript()
    end
end)

function startScript()
    if GetResourceState('es_extended') == 'started' and not ESX then
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end
    end
    Config.Garages = Nakres.Client.AwaitTriggerCallback(ResourceName .. ':server:Callback:getServerGarages');
    local playerInfo = Player.getInfo()
    Player.gang = playerInfo.gang
    Player.job = playerInfo.job
    Garages.createAll();
    checkGaragesActions();
end

function checkGaragesActions()
    local sleep
    while true do
        sleep = 3000;
        if CurrentGarage then
            if checkGarageTypeJobPerm(CurrentGarage.type, {
                job = CurrentGarage.job,
                jobType = CurrentGarage.jobType
            }) then
                if CurrentGarage.type ~= 'depot' then
                    if Markers then
                        sleep = 5
                        DrawMarker(2, CurrentGarage.putVehicle.x, CurrentGarage.putVehicle.y,
                            CurrentGarage.putVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 255, 255, 255,
                            255, false, false, false, true, false, false, false)
                        if HouseMarkers then
                            DrawMarker(2, CurrentGarage.takeVehicle.x, CurrentGarage.takeVehicle.y,
                                CurrentGarage.takeVehicle.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.3, 0.2, 0.15, 200, 0, 0,
                                222, false, false, false, true, false, false, false)
                        end
                    end
                end

                if EnteredParked then
                    sleep = 5
                    if IsControlJustReleased(0, 38) then
                        local currentVeh = GetVehiclePedIsIn(PlayerPedId())
                        if currentVeh ~= 0 then
                            local vehClass = GetVehicleClass(currentVeh)
                            if checkVehicleType(Config.vehicleCatagories[CurrentGarage.vehicle], vehClass) then
                                Vehicle.parkInGarage(currentVeh, CurrentGarageIndex, CurrentGarage.type)
                            else
                                Config.Notify(Text[Config.locale].error.not_garage_type, "error")
                            end
                        end
                    end
                end

                if HouseMarkers then
                    sleep = 5
                    local pCord = GetEntityCoords(PlayerPedId())
                    local dst = #(pCord -
                                    vector3(CurrentGarage.takeVehicle.x, CurrentGarage.takeVehicle.y,
                            CurrentGarage.takeVehicle.z))
                    if dst <= 2.0 then
                        if IsControlJustReleased(0, 38) then
                            TriggerEvent(ResourceName .. ':openGarageMenu')
                        end
                    end
                end
            end
        end
        Citizen.Wait(sleep)
    end
end

function checkGarageTypeJobPerm(_type, _job)
    if _type == "job" then
        return Player.job.name == _job.job or Player.job.type == _job.jobType
    elseif _type == "gang" then
        return Player.gang == _job.job or Player.job.type == _job.jobType
    else
        return true
    end
end

function checkVehicleType(validClasses, vehClass)
    return Nakres.Contains(validClasses, vehClass)
end

function LoadedModel(model)
    if IsModelInCdimage(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(1)
        end
    end
end

function isClearSpawnPoint(area)
    local positionEntity = _GetClosestVehicle(area.x, area.y, area.z, 4.0)
    if not DoesEntityExist(positionEntity) or Vehicle.prevVehicle == positionEntity then
        return true;
    else
        return false;
    end
end

function payDepotPrice(price)
    return Nakres.Client.AwaitTriggerCallback(ResourceName .. ':server:Callback:payDepotPrice', price)
end

function impoundVehicle(vehicle, price)
    Vehicle.impoundGarage(vehicle, price)
end

function stringToVector(str)
    local success, resultVector = pcall(load("return " .. str))
    if success and (type(resultVector) == "vector4" or type(resultVector) == "vector3") then
        return resultVector;
    else
        return nil;
    end
end

function _GetClosestVehicle(x, y, z, dst)
    local vehicles = GetGamePool('CVehicle')
    local closestDistance = -1
    local closestVehicle = -1
    local coords = vector3(x, y, z)
    for i = 1, #vehicles do
        local vehicleCoords = GetEntityCoords(vehicles[i])
        local distance = #(vehicleCoords - coords)
        if closestDistance == -1 or closestDistance > distance then
            closestVehicle = vehicles[i]
            closestDistance = distance
        end
        if dst and closestDistance > dst then
            closestVehicle, closestDistance = -1, -1
        end
    end
    return closestVehicle, closestDistance
end

RegisterCommand(Config.commands.depot, function(_i, args, rawCommand)
    if Config.policeJob == Player.job.name then
        if not IsPedInAnyVehicle(PlayerPedId(), false) then
            local price = tonumber(args[1])
            local coords = GetEntityCoords(PlayerPedId())
            local vehicle = _GetClosestVehicle(coords.x, coords.y, coords.z, 5.0)
            if vehicle then
                impoundVehicle(vehicle, price)
            end
        end
    else
        Config.Notify(Text[Config.locale].error.not_police, "error")
    end
end)

RegisterCommand(Config.commands.createGarage, function(_i, args, rawCommand)
    if Admin.checkPermission() then
        if args[1] then
            local garageindex = string.gsub(args[1], ' ', '')
            if not Config.Garages[garageindex] then
                NUI.toggleAdminUi(true)
                Admin.currentNewIndex = garageindex
            else
                Config.Notify(Text[Config.locale].error.already_exist_garage, 'error')
            end
            Admin.currentNewIndex = garageindex
        else
            Config.Notify(Text[Config.locale].error.not_garage_index, 'error')
        end
    end
end)

RegisterCommand(Config.commands.addgaragepreviewpoint, function()
    if Admin.checkPermission() then
        local coords = GetEntityCoords(PlayerPedId())
        coords = vector4(coords.x, coords.y, coords.z, GetEntityHeading(PlayerPedId()))
        Admin.addGaragePrevCoords(coords)
    end
end)

RegisterCommand(Config.commands.savegarage, function()
    if Admin.checkPermission() then
        Admin.saveNewGarage()
    end
end)

-- local PolyZoneMode = exports['polyZoneCreator']:PolyZoneMode();

-- RegisterCommand("startCreate", function()
--     PolyZoneMode.start(function(data)
--         print(json.encode(data))
--     end)
-- end)
