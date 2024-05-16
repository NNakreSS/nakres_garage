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
