---@class Vehicle

Vehicle = {
    allVehicleModels = GetAllVehicleModels()
}

--- Receives the information of the given vehicle as a parameter (if no parameter is provided, it retrieves the information of the current vehicle you are in).
--- @param veh Vehicle|nil -> vehicle entity
--- @return table|nil  -> vehicle properties
Vehicle.getInfo = function(veh)
    local vehicle = veh or GetVehiclePedIsIn(PlayerPedId(), false);
    if DoesEntityExist(vehicle) then
        --- get colors
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        if GetIsVehiclePrimaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomPrimaryColour(vehicle)
            colorPrimary = { r, g, b }
        end
        if GetIsVehicleSecondaryColourCustom(vehicle) then
            local r, g, b = GetVehicleCustomSecondaryColour(vehicle)
            colorSecondary = { r, g, b }
        end

        --- get extras
        local extras = {}
        for extraId = 0, 12 do
            if DoesExtraExist(vehicle, extraId) then
                local state = IsVehicleExtraTurnedOn(vehicle, extraId) == 1
                extras[tostring(extraId)] = state
            end
        end

        --- get mod livery
        local modLivery = GetVehicleMod(vehicle, 48)
        if GetVehicleMod(vehicle, 48) == -1 and GetVehicleLivery(vehicle) ~= 0 then
            modLivery = GetVehicleLivery(vehicle)
        end

        --- get wheels healt
        local tireHealth = {}
        for i = 0, 3 do
            tireHealth[i] = GetVehicleWheelHealth(vehicle, i)
        end

        --- get Tyre burst
        local tireBurstState = {}
        for i = 0, 5 do
            tireBurstState[i] = IsVehicleTyreBurst(vehicle, i, false)
        end

        --- get Tyre burst completely
        local tireBurstCompletely = {}
        for i = 0, 5 do
            tireBurstCompletely[i] = IsVehicleTyreBurst(vehicle, i, true)
        end

        --- get windows status
        local windowStatus = {}
        for i = 0, 7 do
            windowStatus[i] = IsVehicleWindowIntact(vehicle, i) == 1
        end

        --- get doors Status
        local doorStatus = {}
        for i = 0, 5 do
            doorStatus[i] = IsVehicleDoorDamaged(vehicle, i) == 1
        end

        --- get neon enabled status
        local neonEnabled = {}
        for i = 0, 3 do
            neonEnabled[i] = IsVehicleNeonLightEnabled(vehicle, i)
        end

        local plateInfos = Vehicle.getPlate(vehicle)

        local vehicleNames = Vehicle.getModelName(vehicle)

        return {
            model = GetEntityModel(vehicle),
            modelName = vehicleNames.modelName,
            displayName = vehicleNames.displayName,
            stats = Vehicle.getStats(vehicle),
            plate = plateInfos.plate,
            plateIndex = plateInfos.plateIndex,
            categoryClass = GetVehicleClass(vehicle),
            bodyHealth = Nakres.Round(GetVehicleBodyHealth(vehicle), 0.1),
            engineHealth = Nakres.Round(GetVehicleEngineHealth(vehicle), 0.1),
            tankHealth = Nakres.Round(GetVehiclePetrolTankHealth(vehicle), 0.1),
            fuelLevel = Nakres.Round(GetVehicleFuelLevel(vehicle), 0.1),
            dirtLevel = Nakres.Round(GetVehicleDirtLevel(vehicle), 0.1),
            oilLevel = Nakres.Round(GetVehicleOilLevel(vehicle), 0.1),
            color1 = colorPrimary,
            color2 = colorSecondary,
            pearlescentColor = pearlescentColor,
            dashboardColor = GetVehicleDashboardColour(vehicle),
            wheelColor = wheelColor,
            wheels = GetVehicleWheelType(vehicle),
            wheelSize = GetVehicleWheelSize(vehicle),
            wheelWidth = GetVehicleWheelWidth(vehicle),
            tireHealth = tireHealth,
            tireBurstState = tireBurstState,
            tireBurstCompletely = tireBurstCompletely,
            windowTint = GetVehicleWindowTint(vehicle),
            windowStatus = windowStatus,
            doorStatus = doorStatus,
            xenonColor = GetVehicleXenonLightsColour(vehicle),
            neonEnabled = neonEnabled,
            neonColor = table.pack(GetVehicleNeonLightsColour(vehicle)),
            headlightColor = GetVehicleHeadlightsColour(vehicle),
            interiorColor = GetVehicleInteriorColour(vehicle),
            extras = extras,
            tyreSmokeColor = table.pack(GetVehicleTyreSmokeColor(vehicle)),
            modSpoilers = GetVehicleMod(vehicle, 0),
            modFrontBumper = GetVehicleMod(vehicle, 1),
            modRearBumper = GetVehicleMod(vehicle, 2),
            modSideSkirt = GetVehicleMod(vehicle, 3),
            modExhaust = GetVehicleMod(vehicle, 4),
            modFrame = GetVehicleMod(vehicle, 5),
            modGrille = GetVehicleMod(vehicle, 6),
            modHood = GetVehicleMod(vehicle, 7),
            modFender = GetVehicleMod(vehicle, 8),
            modRightFender = GetVehicleMod(vehicle, 9),
            modRoof = GetVehicleMod(vehicle, 10),
            modEngine = GetVehicleMod(vehicle, 11),
            modBrakes = GetVehicleMod(vehicle, 12),
            modTransmission = GetVehicleMod(vehicle, 13),
            modHorns = GetVehicleMod(vehicle, 14),
            modSuspension = GetVehicleMod(vehicle, 15),
            modArmor = GetVehicleMod(vehicle, 16),
            modKit17 = GetVehicleMod(vehicle, 17),
            modTurbo = IsToggleModOn(vehicle, 18),
            modKit19 = GetVehicleMod(vehicle, 19),
            modSmokeEnabled = IsToggleModOn(vehicle, 20),
            modKit21 = GetVehicleMod(vehicle, 21),
            modXenon = IsToggleModOn(vehicle, 22),
            modFrontWheels = GetVehicleMod(vehicle, 23),
            modBackWheels = GetVehicleMod(vehicle, 24),
            modCustomTiresF = GetVehicleModVariation(vehicle, 23),
            modCustomTiresR = GetVehicleModVariation(vehicle, 24),
            modPlateHolder = GetVehicleMod(vehicle, 25),
            modVanityPlate = GetVehicleMod(vehicle, 26),
            modTrimA = GetVehicleMod(vehicle, 27),
            modOrnaments = GetVehicleMod(vehicle, 28),
            modDashboard = GetVehicleMod(vehicle, 29),
            modDial = GetVehicleMod(vehicle, 30),
            modDoorSpeaker = GetVehicleMod(vehicle, 31),
            modSeats = GetVehicleMod(vehicle, 32),
            modSteeringWheel = GetVehicleMod(vehicle, 33),
            modShifterLeavers = GetVehicleMod(vehicle, 34),
            modAPlate = GetVehicleMod(vehicle, 35),
            modSpeakers = GetVehicleMod(vehicle, 36),
            modTrunk = GetVehicleMod(vehicle, 37),
            modHydrolic = GetVehicleMod(vehicle, 38),
            modEngineBlock = GetVehicleMod(vehicle, 39),
            modAirFilter = GetVehicleMod(vehicle, 40),
            modStruts = GetVehicleMod(vehicle, 41),
            modArchCover = GetVehicleMod(vehicle, 42),
            modAerials = GetVehicleMod(vehicle, 43),
            modTrimB = GetVehicleMod(vehicle, 44),
            modTank = GetVehicleMod(vehicle, 45),
            modWindows = GetVehicleMod(vehicle, 46),
            modKit47 = GetVehicleMod(vehicle, 47),
            modLivery = modLivery,
            modKit49 = GetVehicleMod(vehicle, 49),
            liveryRoof = GetVehicleRoofLivery(vehicle)
        }
    else
        return nil;
    end
end

--- @param vehicle any
--- @return table -- Vehicle displayName - modelName
Vehicle.getModelName = function(vehicle)
    vehicle = vehicle or GetVehiclePedIsIn(PlayerPedId(), false);
    local modelHash = GetEntityModel(vehicle)
    local displayName = GetLabelText(GetDisplayNameFromVehicleModel(modelHash))
    local modelName;

    for index, modelname in ipairs(Vehicle.allVehicleModels) do
        if modelHash == GetHashKey(modelname) then
            modelName = modelname
            break
        end
    end

    return {
        displayName = displayName,
        modelName = modelName
    }
end

--- @param vehicle vehicle|nil
--- @return table -- acceleration , brakes , topspeed , traction
Vehicle.getStats = function(vehicle)
    vehicle = vehicle or GetVehiclePedIsIn(PlayerPedId(), false);
    local fInitialDriveMaxFlatVel = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fInitialDriveMaxFlatVel')
    local fTractionBiasFront = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionBiasFront')
    local fTractionCurveMax = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMax')
    local fTractionCurveMin = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fTractionCurveMin')
    return {
        acceleration = GetVehicleModelAcceleration(GetEntityModel(vehicle)),
        brakes = GetVehicleHandlingFloat(vehicle, 'CHandlingData', 'fBrakeForce'),
        topspeed = math.ceil(fInitialDriveMaxFlatVel * 1.3),
        traction = (fTractionBiasFront + fTractionCurveMax * fTractionCurveMin)
    }
end

--- @param vehicle vehicle
---@param mods table vehicleproperties
Vehicle.setProperties = function(vehicle, mods)
    if Config.nakresLightbar then exports['nakres_lightbar']:loadLightbarInCar(vehicle); end
    if DoesEntityExist(vehicle) then
        if mods.extras then
            for id, enabled in pairs(mods.extras) do
                if enabled then
                    SetVehicleExtra(vehicle, tonumber(id), 0)
                else
                    SetVehicleExtra(vehicle, tonumber(id), 1)
                end
            end
        end

        local colorPrimary, colorSecondary = GetVehicleColours(vehicle)
        local pearlescentColor, wheelColor = GetVehicleExtraColours(vehicle)
        SetVehicleModKit(vehicle, 0)
        if mods.plate then
            SetVehicleNumberPlateText(vehicle, mods.plate)
        end
        if mods.plateIndex then
            SetVehicleNumberPlateTextIndex(vehicle, mods.plateIndex)
        end
        if mods.bodyHealth then
            SetVehicleBodyHealth(vehicle, mods.bodyHealth + 0.0)
        end
        if mods.engineHealth then
            SetVehicleEngineHealth(vehicle, mods.engineHealth + 0.0)
        end
        if mods.tankHealth then
            SetVehiclePetrolTankHealth(vehicle, mods.tankHealth)
        end
        if mods.fuelLevel then
            SetVehicleFuelLevel(vehicle, mods.fuelLevel + 0.0)
        end
        if mods.dirtLevel then
            SetVehicleDirtLevel(vehicle, mods.dirtLevel + 0.0)
        end
        if mods.oilLevel then
            SetVehicleOilLevel(vehicle, mods.oilLevel)
        end
        if mods.color1 then
            if type(mods.color1) == "number" then
                ClearVehicleCustomPrimaryColour(vehicle)
                SetVehicleColours(vehicle, mods.color1, colorSecondary)
            else
                SetVehicleCustomPrimaryColour(vehicle, mods.color1[1], mods.color1[2], mods.color1[3])
            end
        end
        if mods.color2 then
            if type(mods.color2) == "number" then
                ClearVehicleCustomSecondaryColour(vehicle)
                SetVehicleColours(vehicle, mods.color1 or colorPrimary, mods.color2)
            else
                SetVehicleCustomSecondaryColour(vehicle, mods.color2[1], mods.color2[2], mods.color2[3])
            end
        end
        if mods.pearlescentColor then
            SetVehicleExtraColours(vehicle, mods.pearlescentColor, wheelColor)
        end
        if mods.interiorColor then
            SetVehicleInteriorColor(vehicle, mods.interiorColor)
        end
        if mods.dashboardColor then
            SetVehicleDashboardColour(vehicle, mods.dashboardColor)
        end
        if mods.wheelColor then
            SetVehicleExtraColours(vehicle, mods.pearlescentColor or pearlescentColor, mods.wheelColor)
        end
        if mods.wheels then
            SetVehicleWheelType(vehicle, mods.wheels)
        end
        if mods.tireHealth then
            for wheelIndex, health in pairs(mods.tireHealth) do
                SetVehicleWheelHealth(vehicle, wheelIndex, health)
            end
        end
        if mods.tireBurstState then
            for wheelIndex, burstState in pairs(mods.tireBurstState) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), false, 1000.0)
                end
            end
        end
        if mods.tireBurstCompletely then
            for wheelIndex, burstState in pairs(mods.tireBurstCompletely) do
                if burstState then
                    SetVehicleTyreBurst(vehicle, tonumber(wheelIndex), true, 1000.0)
                end
            end
        end
        if mods.windowTint then
            SetVehicleWindowTint(vehicle, mods.windowTint)
        end
        if mods.windowStatus then
            for windowIndex, smashWindow in pairs(mods.windowStatus) do
                if not smashWindow then SmashVehicleWindow(vehicle, windowIndex) end
            end
        end
        if mods.doorStatus then
            for doorIndex, breakDoor in pairs(mods.doorStatus) do
                if breakDoor then
                    SetVehicleDoorBroken(vehicle, tonumber(doorIndex), true)
                end
            end
        end
        if mods.neonEnabled then
            SetVehicleNeonLightEnabled(vehicle, 0, mods.neonEnabled[1])
            SetVehicleNeonLightEnabled(vehicle, 1, mods.neonEnabled[2])
            SetVehicleNeonLightEnabled(vehicle, 2, mods.neonEnabled[3])
            SetVehicleNeonLightEnabled(vehicle, 3, mods.neonEnabled[4])
        end
        if mods.neonColor then
            SetVehicleNeonLightsColour(vehicle, mods.neonColor[1], mods.neonColor[2], mods.neonColor[3])
        end
        if mods.headlightColor then
            SetVehicleHeadlightsColour(vehicle, mods.headlightColor)
        end
        if mods.interiorColor then
            SetVehicleInteriorColour(vehicle, mods.interiorColor)
        end
        if mods.wheelSize then
            SetVehicleWheelSize(vehicle, mods.wheelSize)
        end
        if mods.wheelWidth then
            SetVehicleWheelWidth(vehicle, mods.wheelWidth)
        end
        if mods.tyreSmokeColor then
            SetVehicleTyreSmokeColor(vehicle, mods.tyreSmokeColor[1], mods.tyreSmokeColor[2], mods.tyreSmokeColor[3])
        end
        if mods.modSpoilers then
            SetVehicleMod(vehicle, 0, mods.modSpoilers, false)
        end
        if mods.modFrontBumper then
            SetVehicleMod(vehicle, 1, mods.modFrontBumper, false)
        end
        if mods.modRearBumper then
            SetVehicleMod(vehicle, 2, mods.modRearBumper, false)
        end
        if mods.modSideSkirt then
            SetVehicleMod(vehicle, 3, mods.modSideSkirt, false)
        end
        if mods.modExhaust then
            SetVehicleMod(vehicle, 4, mods.modExhaust, false)
        end
        if mods.modFrame then
            SetVehicleMod(vehicle, 5, mods.modFrame, false)
        end
        if mods.modGrille then
            SetVehicleMod(vehicle, 6, mods.modGrille, false)
        end
        if mods.modHood then
            SetVehicleMod(vehicle, 7, mods.modHood, false)
        end
        if mods.modFender then
            SetVehicleMod(vehicle, 8, mods.modFender, false)
        end
        if mods.modRightFender then
            SetVehicleMod(vehicle, 9, mods.modRightFender, false)
        end
        if mods.modRoof then
            SetVehicleMod(vehicle, 10, mods.modRoof, false)
        end
        if mods.modEngine then
            SetVehicleMod(vehicle, 11, mods.modEngine, false)
        end
        if mods.modBrakes then
            SetVehicleMod(vehicle, 12, mods.modBrakes, false)
        end
        if mods.modTransmission then
            SetVehicleMod(vehicle, 13, mods.modTransmission, false)
        end
        if mods.modHorns then
            SetVehicleMod(vehicle, 14, mods.modHorns, false)
        end
        if mods.modSuspension then
            SetVehicleMod(vehicle, 15, mods.modSuspension, false)
        end
        if mods.modArmor then
            SetVehicleMod(vehicle, 16, mods.modArmor, false)
        end
        if mods.modKit17 then
            SetVehicleMod(vehicle, 17, mods.modKit17, false)
        end
        if mods.modTurbo then
            ToggleVehicleMod(vehicle, 18, mods.modTurbo)
        end
        if mods.modKit19 then
            SetVehicleMod(vehicle, 19, mods.modKit19, false)
        end
        if mods.modSmokeEnabled then
            ToggleVehicleMod(vehicle, 20, mods.modSmokeEnabled)
        end
        if mods.modKit21 then
            SetVehicleMod(vehicle, 21, mods.modKit21, false)
        end
        if mods.modXenon then
            ToggleVehicleMod(vehicle, 22, mods.modXenon)
        end
        if mods.xenonColor then
            SetVehicleXenonLightsColor(vehicle, mods.xenonColor)
        end
        if mods.modFrontWheels then
            SetVehicleMod(vehicle, 23, mods.modFrontWheels, false)
        end
        if mods.modBackWheels then
            SetVehicleMod(vehicle, 24, mods.modBackWheels, false)
        end
        if mods.modCustomTiresF then
            SetVehicleMod(vehicle, 23, mods.modFrontWheels, mods.modCustomTiresF)
        end
        if mods.modCustomTiresR then
            SetVehicleMod(vehicle, 24, mods.modBackWheels, mods.modCustomTiresR)
        end
        if mods.modPlateHolder then
            SetVehicleMod(vehicle, 25, mods.modPlateHolder, false)
        end
        if mods.modVanityPlate then
            SetVehicleMod(vehicle, 26, mods.modVanityPlate, false)
        end
        if mods.modTrimA then
            SetVehicleMod(vehicle, 27, mods.modTrimA, false)
        end
        if mods.modOrnaments then
            SetVehicleMod(vehicle, 28, mods.modOrnaments, false)
        end
        if mods.modDashboard then
            SetVehicleMod(vehicle, 29, mods.modDashboard, false)
        end
        if mods.modDial then
            SetVehicleMod(vehicle, 30, mods.modDial, false)
        end
        if mods.modDoorSpeaker then
            SetVehicleMod(vehicle, 31, mods.modDoorSpeaker, false)
        end
        if mods.modSeats then
            SetVehicleMod(vehicle, 32, mods.modSeats, false)
        end
        if mods.modSteeringWheel then
            SetVehicleMod(vehicle, 33, mods.modSteeringWheel, false)
        end
        if mods.modShifterLeavers then
            SetVehicleMod(vehicle, 34, mods.modShifterLeavers, false)
        end
        if mods.modAPlate then
            SetVehicleMod(vehicle, 35, mods.modAPlate, false)
        end
        if mods.modSpeakers then
            SetVehicleMod(vehicle, 36, mods.modSpeakers, false)
        end
        if mods.modTrunk then
            SetVehicleMod(vehicle, 37, mods.modTrunk, false)
        end
        if mods.modHydrolic then
            SetVehicleMod(vehicle, 38, mods.modHydrolic, false)
        end
        if mods.modEngineBlock then
            SetVehicleMod(vehicle, 39, mods.modEngineBlock, false)
        end
        if mods.modAirFilter then
            SetVehicleMod(vehicle, 40, mods.modAirFilter, false)
        end
        if mods.modStruts then
            SetVehicleMod(vehicle, 41, mods.modStruts, false)
        end
        if mods.modArchCover then
            SetVehicleMod(vehicle, 42, mods.modArchCover, false)
        end
        if mods.modAerials then
            SetVehicleMod(vehicle, 43, mods.modAerials, false)
        end
        if mods.modTrimB then
            SetVehicleMod(vehicle, 44, mods.modTrimB, false)
        end
        if mods.modTank then
            SetVehicleMod(vehicle, 45, mods.modTank, false)
        end
        if mods.modWindows then
            SetVehicleMod(vehicle, 46, mods.modWindows, false)
        end
        if mods.modKit47 then
            SetVehicleMod(vehicle, 47, mods.modKit47, false)
        end
        if mods.modLivery then
            SetVehicleMod(vehicle, 48, mods.modLivery, false)
            SetVehicleLivery(vehicle, mods.modLivery)
        end
        if mods.modKit49 then
            SetVehicleMod(vehicle, 49, mods.modKit49, false)
        end
        if mods.liveryRoof then
            SetVehicleRoofLivery(vehicle, mods.liveryRoof)
        end
    end
end

--- Conveys vehicle license plate information in table.
--- @param veh Vehicle|nil
--- @return table|nil > {palte = |string| , plateIndex = |integer|}
Vehicle.getPlate = function(veh)
    local vehicle = veh or GetVehiclePedIsIn(PlayerPedId(), false);
    if DoesEntityExist(vehicle) then
        return {
            plate = Config.spacedPlate and GetVehicleNumberPlateText(vehicle) or
                Nakres.Trim(GetVehicleNumberPlateText(vehicle)),
            plateIndex = GetVehicleNumberPlateTextIndex(vehicle)
        }
    else
        return nil;
    end
end

Vehicle.parkInGarage = function(vehicle, garageIndex, garageType)
    if GetVehicleNumberOfPassengers(vehicle) == 0 then -- arabada kimse yoksa
        local plate = Vehicle.getPlate(vehicle).plate;
        Vehicle.checkOwnership(plate, function(result)
            if result then
                if Config.uniqueGarages and Config.limitedGarages then
                    local garageVehicles<const> = Garages.getVehicles(garageType, garageIndex);
                    local limit<const> = (CurrentGarage.limit and CurrentGarage.limit ~= 0) and CurrentGarage.limit or
                        Config.defaultLimit
                    if #garageVehicles >= limit then
                        Config.Notify(Text[Config.locale].error.garage_full, "error")
                        return;
                    end
                end
                local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
                local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
                local totalFuel = Config.getFuel(vehicle)
                local vehInfo = Vehicle.getInfo(vehicle)
                TriggerServerEvent(ResourceName .. ':server:SaveVehicleProps', (vehInfo))
                TriggerServerEvent(ResourceName .. ':server:updateVehicle', 1, bodyDamage, engineDamage, totalFuel,
                    plate,
                    garageIndex, garageType)
                Vehicle.playersLeave(vehicle);
                Vehicle.delete(vehicle);
                TriggerServerEvent(ResourceName .. ':server:UpdateSpawnedVehicle', plate)
                Nakres.Client.triggerAllClient(ResourceName .. ':client:vehicleAddGaragePreview',
                    garageIndex, { plate = plate, mods = json.encode(vehInfo) })
                Config.Notify(Text[Config.locale].success.parked_vehicle, "success")
            else
                Config.Notify(Text[Config.locale].error.not_own, "error")
            end
        end, garageType, garageIndex)
    else
        Config.Notify("Araba birileri varken bunu yapamazsın", "error")
    end
end

Vehicle.impoundGarage = function(vehicle, price)
    if Vehicle.isSeatsFree(vehicle) then -- arabada kimse yoksa
        local plate = Vehicle.getPlate(vehicle).plate;
        Vehicle.checkOwnership(plate, function(result)
            if result then
                local bodyDamage = math.ceil(GetVehicleBodyHealth(vehicle))
                local engineDamage = math.ceil(GetVehicleEngineHealth(vehicle))
                local totalFuel = Config.getFuel(vehicle)
                local category = Vehicle.getVehicleCategoriFromClass(vehicle)
                TriggerServerEvent(ResourceName .. ':server:SaveVehicleProps', (Vehicle.getInfo(vehicle)))
                TriggerServerEvent(ResourceName .. ':server:updateVehicle', 2, bodyDamage, engineDamage, totalFuel,
                    plate, Config.defaultImpoundGarageForCategories[category], 'depot',
                    price or Config.defaultImpoundPrice)
                Vehicle.delete(vehicle);
                TriggerServerEvent(ResourceName .. ':server:UpdateSpawnedVehicle', plate)
                Config.Notify(Text[Config.locale].success.impound, "success")
            else
                Config.Notify(Text[Config.locale].error.not_own_players, "error")
            end
        end, 'depot')
    else
        Config.Notify(Text[Config.locale].error.seats_not_free, "error")
    end
end

Vehicle.isSeatsFree = function(vehicle)
    if DoesEntityExist(vehicle) then
        print("------------------------")
        print(IsVehicleSeatFree(vehicle, -1))
        print(GetVehicleNumberOfPassengers(vehicle))
        print("------------------------")
        if IsVehicleSeatFree(vehicle, -1) and GetVehicleNumberOfPassengers(vehicle) == 0 then
            return true;
        else
            return false;
        end
    else
        return warn('not found vehicle');
    end
end

Vehicle.getVehicleCategoriFromClass = function(veh)
    local vehicle = veh or GetVehiclePedIsIn(PlayerPedId(), false);
    local class = GetVehicleClass(vehicle);
    for categoriname, value in pairs(Config.vehicleCatagories) do
        if checkVehicleType(value, class) then
            return categoriname;
        end
    end
    return nil;
end

--- Check if the vehicle belongs to a player and if the owner has sufficient permission to park in this garage.
--- @param plate string|nil
--- @param cb function function parameter return true or false
Vehicle.checkOwnership = function(plate, cb, ...)
    Nakres.Client.TriggerCallback(ResourceName .. ":server:Callback:checkOwnerShip", function(result)
        cb(result);
    end, plate, ...)
end

Vehicle.playersLeave = function(vehicle)
    for i = -1, 5, 1 do
        local player = GetPedInVehicleSeat(vehicle, i)
        if player then
            TaskLeaveVehicle(player, vehicle, 0)
        end
    end
    SetVehicleDoorsLocked(vehicle, 2)
    Wait(1500)
    if Config.vehicleGarageAnimation then
        local alpha = 255
        repeat
            alpha = alpha - 70
            if (alpha <= 0) then alpha = 0 end
            SetEntityAlpha(vehicle, alpha)
            Wait(alpha * 4)
        until alpha <= 20
    end
end

Vehicle.delete = function(vehicle)
    SetEntityAsMissionEntity(vehicle, true, true)
    DeleteVehicle(vehicle)
end

Vehicle.createPreview = function(vehicleInfo, coords)
    Vehicle.deletePreview();
    local vehicleProperties = CurrentGarageVehicles[vehicleInfo.plate]
    LoadedModel(vehicleInfo.model)
    Vehicle.prevVehicle = CreateVehicle(vehicleInfo.model, coords.x, coords.y, coords.z, coords.w or 0.0, false, false);
    PlaceObjectOnGroundProperly(Vehicle.prevVehicle);
    FreezeEntityPosition(Vehicle.prevVehicle, true)
    SetEntityCompletelyDisableCollision(Vehicle.prevVehicle, false, false)
    Vehicle.setProperties(Vehicle.prevVehicle, vehicleProperties.mods)
    Cam.TogglePrevCam(true);
end

Vehicle.createOriginal = function(vehicleInfo, coords)
    local vehicleProperties = CurrentGarageVehicles[vehicleInfo.plate]
    Nakres.Client.TriggerCallback(ResourceName .. ':server:Callback:spawnvehicle', function(cb)
        if cb.success then
            Nakres.Client.triggerAllClient(ResourceName .. ':client:vehicleDeleteGaragePreview', CurrentGarageIndex,
                vehicleInfo.plate)
            local vehicle = NetToVeh(cb.netId);
            Vehicle.setProperties(vehicle, vehicleProperties.mods)
            Config.setFuel(vehicle, vehicleProperties.fuel)
            SetVehicleEngineOn(veh, true, true)
            Config.vehicleKey(vehicleInfo.plate)
        end
    end, vehicleInfo, coords)
end

Vehicle.rotatePreview = function(rotate)
    local currentRotation = GetEntityHeading(Vehicle.prevVehicle)
    local newHeading = (currentRotation + rotate) % 360.0
    SetEntityHeading(Vehicle.prevVehicle, newHeading)
end

Vehicle.deletePreview = function()
    if DoesEntityExist(Vehicle.prevVehicle) then
        DeleteEntity(Vehicle.prevVehicle)
        Vehicle.prevVehicle = nil;
    end
end
