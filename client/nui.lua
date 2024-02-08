NUI = {}
NUI.vehicles = {}

NUI.toggleNuiFrame = function(shouldShow)
    SetNuiFocus(shouldShow, shouldShow)
    SendReactMessage('setVisible', shouldShow)
    if not shouldShow then
        Cam.TogglePrevCam(false);
        Vehicle.deletePreview();
        -- NUI.toggleAdminUi(false);
    end
end

RegisterNUICallback('hideFrame', function()
    NUI.toggleNuiFrame(false)
end)

NUI.toggleUi = function(limit)
    local data<const> = {
        vehicles = NUI.vehicles,
        garageName = CurrentGarage.label,
        garageLimit = limit or false,
        depotGarage = CurrentGarage.type == 'depot' and true or false,
        locale = Text[Config.locale].ui
    }
    NUI.toggleNuiFrame(true)
    SendReactMessage('toggleGarageUi', data)
end

NUI.toggleAdminUi = function(display)
    SendNUIMessage({
        messageType = 'adminMenu',
        display = display
    })
    SetNuiFocus(display, display)
end

NUI.localeAdminUi = function(locales)
    SendNUIMessage({
        messageType = 'localeAdminMenu',
        locale = locales
    })
end

RegisterNUICallback("previewSelectedVehicle", function(vehicle, cb)
    print("previewSelectedVehicle")
    Vehicle.createPreview(vehicle, CurrentGarage.previewPoint or CurrentGarage.spawnPoint)
    cb(true)
end)

RegisterNUICallback("setPreviewVehicleHeading", function(data)
    local rotateHeading<const> = tonumber(data)
    Vehicle.rotatePreview(rotateHeading)
end)

RegisterNUICallback("spawnSelectedVehicle", function(vehicle)
    if CurrentGarage.type == 'depot' then
        if not payDepotPrice(vehicle.depotPrice) then
            return Config.Notify(Text[Config.locale].error.not_money, 'error')
        end
    end
    if Config.checkClearSpawnPoint then
        if not isClearSpawnPoint(CurrentGarage.spawnPoint) then
            return Config.Notify(Text[Config.locale].error.not_clear_area, 'error')
        end
    end
    NUI.toggleNuiFrame(false);
    Vehicle.createOriginal(vehicle, CurrentGarage.spawnPoint);
end)

RegisterNUICallback("createGarage", function(data)
    Admin.createGarage({
        ["label"] = data.garageName,
        ["takeVehicle"] = stringToVector(data.npcCoord),
        ["spawnPoint"] = stringToVector(data.spawnCoord),
        ["putVehicle"] = stringToVector(data.enterCoord),
        ["previewPoint"] = stringToVector(data.prevCoord),
        ["showBlip"] = data.blipType and true or false,
        ["blipName"] = data.blipName,
        ["blipNumber"] = tonumber(data.blipType),
        ["blipColor"] = tonumber(data.blipColor),
        ["type"] = data.garageType, --- public, job, gang, depot
        ["vehicle"] = data.vehicleType, --- car, air, sea, rig
        ['limit'] = tonumber(data.garageLimit),
        ['job'] = data.job,
        ['jobType'] = data.jobType
    })
end)
