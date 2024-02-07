Admin = {
    currentNewGarage = nil,
    currentNewIndex = nil
}

Admin.checkPermission = function()
    return Nakres.Client.AwaitTriggerCallback(ResourceName .. ':server:Callback:checkAdminPermission')
end

Admin.createGarage = function(data)
    Admin.currentNewGarage = data
end

Admin.addGaragePrevCoords = function(coord)
    if Admin.currentNewGarage then
        Admin.currentNewGarage['previewsCoords'] = Admin.currentNewGarage['previewsCoords'] or {}
        Admin.currentNewGarage['previewsCoords'][#Admin.currentNewGarage['previewsCoords'] + 1] = coord
        Config.Notify(Text[Config.locale].success.add_prev_coord, 'success')
    end
end

Admin.setGarageNpcModel = function(model, heading)
    if Admin.currentNewGarage then
        Admin.currentNewGarage['npc'].model = model
        Admin.currentNewGarage['npc'].heading = heading
        local text = string.format(Text[Config.locale].success.set_npc_model, model, heading)
        Config.Notify(tostring(text), 'success')
    end
end

Admin.saveNewGarage = function()
    if Admin.currentNewIndex then
        if Admin.currentNewGarage then
            TriggerServerEvent(ResourceName .. 'server:addNewGarage', Admin.currentNewIndex, Admin.currentNewGarage)
            Config.Notify(Text[Config.locale].success.created_garage, 'success')
        else
            Config.Notify(Text[Config.locale].error.not_create_garage, 'error')
        end
        Admin.currentNewGarage = nil
        Admin.currentNewIndex = nil
    end
end
