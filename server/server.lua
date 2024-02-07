local SpawnedVehicles = {};

Nakres.Server.CreateCallback(ResourceName .. ":server:Callback:checkOwnerShip",
    function(source, cb, plate, type, garageindex)
        local plData = getPlayerData(source)
        local vehicle_table = (QBCore and 'player_vehicles') or (ESX and 'owned_vehicles')
        local query_identifier = (QBCore and 'citizenid') or (ESX and 'owner')
        local identifier = (QBCore and plData.PlayerData.citizenid) or (ESX and plData.getIdentifier())
        local query = (Config.sharedVehicle or type == "depot") and
            'SELECT * FROM ' .. vehicle_table .. ' WHERE plate = ?' or
            'SELECT * FROM ' .. vehicle_table .. ' WHERE plate = ? AND ' .. query_identifier .. ' = ?'
        local params = (Config.sharedVehicle or type == "depot") and { plate } or { plate, identifier }
        if type == "house" then
            local hasHouseKey = Config.houseHasKey(source, garageindex)
            if not hasHouseKey then
                return cb(false)
            end
        end
        MySQL.query(query, params, function(result)
            if result[1] then
                cb(true);
            else
                cb(false);
            end
        end)
    end)

Nakres.Server.CreateCallback(ResourceName .. ":server:Callback:getGarageVehicles",
    function(source, cb, garageIndex, garageType)
        local plData = getPlayerData(source)
        local vehicle_table = (QBCore and 'player_vehicles') or (ESX and 'owned_vehicles')
        local query_identifier = (QBCore and 'citizenid') or (ESX and 'owner')
        local identifier = (QBCore and plData.PlayerData.citizenid) or (ESX and plData.getIdentifier())
        local whereState = garageType == "depot" and 2 or 1
        local query = 'SELECT * FROM ' ..
            vehicle_table .. ' WHERE state = ? AND ' .. query_identifier .. ' = ? AND garage = ?';
        local params = { whereState, identifier, garageIndex }
        if not Config.uniqueGarages then
            query = 'SELECT * FROM ' ..
                vehicle_table .. ' WHERE state = ? AND ' .. query_identifier .. ' = ? ';
            params = { whereState, identifier }
        end
        if garageType ~= "public" and Config.SharedGarages then
            query = 'SELECT * FROM ' ..
                vehicle_table .. ' WHERE  state = ? AND garage = ?'
            params = { whereState, garageIndex }
        end
        if garageType == 'house' then
            local hasHouseKey = Config.houseHasKey(source, garageIndex)
            if not hasHouseKey then
                return cb(false)
            else
                query = 'SELECT * FROM ' ..
                    vehicle_table .. ' WHERE  state = ? AND garage = ?'
                params = { whereState, garageIndex }
            end
        end
        MySQL.query(query, params, function(result)
            if result[1] then
                if ESX then
                    for i, vehicle in ipairs(result) do
                        vehicle.mods = vehicle.vehicle
                    end
                end
                cb(result)
            else
                cb({})
            end
        end)
    end)

Nakres.Server.CreateCallback(ResourceName .. ':server:Callback:spawnvehicle', function(source, cb, vehInfo, coords)
    local plate = vehInfo.plate
    if SpawnedVehicles[plate] and DoesEntityExist(SpawnedVehicles[plate].entity) then
        cb({ success = false })
    else
        local veh = spawnVehicle(source, vehInfo.model, coords)
        local netId = NetworkGetNetworkIdFromEntity(veh)
        SpawnedVehicles[plate] = { netID = netId, entity = veh }
        SetVehicleNumberPlateText(veh, plate)
        TriggerEvent(ResourceName .. ':server:UpdateSpawnedState', plate, 0)
        cb({ success = true, netId = netId })
    end
end)

Nakres.Server.CreateCallback(ResourceName .. ':server:Callback:payDepotPrice', function(source, cb, price)
    local plData = getPlayerData(source)
    if QBCore then
        local cashMoney, bankMoney = plData.Functions.GetMoney('cash'), plData.Functions.GetMoney('bank')
        if cashMoney >= price then
            plData.Functions.RemoveMoney('cash', price, 'PAY IMPOUND VEHICLE PRICE')
            cb(true)
        elseif bankMoney >= price then
            plData.Functions.RemoveMoney('bank', price, 'PAY IMPOUND VEHICLE PRICE')
            cb(true)
        else
            cb(false)
        end
    elseif ESX then
        local cashMoney, bankMoney = plData.getMoney(), plData.getAccount('bank').money
        if cashMoney >= price then
            plData.removeMoney(price)
            cb(true)
        elseif bankMoney >= price then
            plData.removeAccountMoney('bank', price)
            cb(true)
        else
            cb(false)
        end
    end
end)

Nakres.Server.CreateCallback(ResourceName .. ':server:Callback:getAllGarageVehicles', function(source, cb)
    local vehicle_table = (QBCore and 'player_vehicles') or (ESX and 'owned_vehicles')
    MySQL.query('SELECT * FROM ' .. vehicle_table .. ' WHERE state = ?', { 1 }, function(result)
        local allGarageVehicles = {};
        if result[1] then
            for i = 1, #result do
                allGarageVehicles[result[i].garage] = allGarageVehicles[result[i].garage] or {};
                if ESX then result[i].mods = result[i].vehicle end
                table.insert(allGarageVehicles[result[i].garage], result[i])
            end
            cb(allGarageVehicles)
        else
            cb({})
        end
    end)
end)

Nakres.Server.CreateCallback(ResourceName .. ':server:Callback:checkAdminPermission', function(source, cb)
    local pIdentity = GetPlayerIdentifierByType(source, 'steam') or GetPlayerIdentifierByType(source, 'license')
    for _, value in ipairs(Config.admins) do
        if pIdentity == value then
            return cb(true)
        end
    end
    cb(false)
end)

Nakres.Server.CreateCallback(ResourceName .. ':server:Callback:getServerGarages', function(source, cb)
    cb(Config.Garages)
end)

RegisterServerEvent(ResourceName .. ':server:SaveVehicleProps')
AddEventHandler(ResourceName .. ':server:SaveVehicleProps', function(vehicleProps)
    local vehicle_table = (QBCore and 'player_vehicles') or (ESX and 'owned_vehicles')
    local mods_table = QBCore and 'mods' or ESX and 'vehicle'
    MySQL.update('UPDATE ' .. vehicle_table .. ' SET ' .. mods_table .. ' = ?  WHERE plate = ?',
        { json.encode(vehicleProps), vehicleProps.plate })
end)

RegisterServerEvent(ResourceName .. ':server:updateVehicle')
AddEventHandler(ResourceName .. ':server:updateVehicle',
    function(state, body, engine, fuel, plate, garageIndex, garageType, price)
        if state == 0 or state == 1 or state == 2 then
            local vehicle_table = (QBCore and "player_vehicles") or (ESX and 'owned_vehicles')
            local query =
                'UPDATE ' .. vehicle_table ..
                ' SET state = ?, garage = ?, fuel = ?, engine = ?, body = ?  WHERE plate = ?'
            if garageType == "depot" then
                price = price or Config.defaultImpoundPrice
                MySQL.update(
                    'UPDATE ' .. vehicle_table ..
                    ' SET state = ?, garage = ?, fuel = ?, engine = ?, body = ? , depotprice = ?  WHERE plate = ?',
                    { state, garageIndex, fuel, engine, body, tonumber(price), plate })
            else
                if Config.Garages[garageIndex] or garageType == "house" then
                    MySQL.update(
                        query,
                        { state, garageIndex, fuel, engine, body, plate })
                end
            end
        end
    end)

RegisterServerEvent(ResourceName .. ':server:UpdateSpawnedVehicle')
AddEventHandler(ResourceName .. ':server:UpdateSpawnedVehicle', function(plate, vehicle)
    local entity = vehicle and NetworkGetEntityFromNetworkId(vehicle) or nil;
    SpawnedVehicles[plate] = { netID = vehicle, entity = entity }
end)

RegisterServerEvent(ResourceName .. ':server:UpdateSpawnedState')
AddEventHandler(ResourceName .. ':server:UpdateSpawnedState', function(plate, state)
    local vehicle_table = (QBCore and 'player_vehicles') or (ESX and 'owned_vehicles')
    MySQL.update('UPDATE ' .. vehicle_table .. ' SET state = ? , depotprice = ? WHERE plate = ?', { state, 0, plate })
end)

RegisterServerEvent(ResourceName .. 'server:addNewGarage')
AddEventHandler(ResourceName .. 'server:addNewGarage', function(index, garage)
    Config.Garages[index] = garage
    TriggerClientEvent(ResourceName .. 'client:addNewGarage', -1, index, garage)
    addJsonData(index, garage)
end)

AddEventHandler('onResourceStart', function(resource)
    if resource == ResourceName then
        Wait(500)
        local adminGarages = getJsonData()
        for key, value in pairs(adminGarages) do
            Config.Garages[key] = value
            TriggerClientEvent(ResourceName .. 'client:addNewGarage', -1, key, value)
        end

        local vehicle_table = (QBCore and "player_vehicles") or (ESX and 'owned_vehicles')
        if Config.autoPutInGarage then
            MySQL.update('UPDATE ' .. vehicle_table .. ' SET state = ? WHERE state = ?', { 1, 0 })
        else
            MySQL.query('SELECT mods FROM ' .. vehicle_table .. ' WHERE state = ?', { 0 }, function(result)
                if result[1] then
                    for index, value in pairs(result) do
                        local mods = json.decode(value.mods)
                        local categori = getCategoriFromClass(mods.categoryClass or 15)
                        print(categori, Config.defaultImpoundGarageForCategories[categori], mods.plate)
                        MySQL.update(
                            'UPDATE ' .. vehicle_table .. ' SET state = ? , garage = ? , depotprice = ? WHERE plate = ?',
                            { 2, Config.defaultImpoundGarageForCategories[categori], Config.autoPutImpoundMoney,
                                mods.plate })
                        Citizen.Wait(200)
                    end
                end
            end)
        end
    end
end)
