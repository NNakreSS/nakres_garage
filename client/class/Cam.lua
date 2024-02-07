---@class Cam
Cam = {
    cam = nil
}

--- @param bool boolean tooggle cam display mode
Cam.TogglePrevCam = function(bool)
    if bool then
        local updateCoord = Cam.cam and true or false
        if not updateCoord then
            FreezeEntityPosition(PlayerPedId(), true)
            Cam.cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        end
        Cam.startCam(updateCoord)
    else
        Cam.resetCam()
    end
end

--- @param updateCoord boolean new cam or set coord
Cam.startCam = function(updateCoord)
    local camCoord = (GetOffsetFromEntityInWorldCoords(Vehicle.prevVehicle, 1.0, 5.5, 2.0))
    SetCamCoord(Cam.cam, camCoord)
    PointCamAtCoord(Cam.cam, GetEntityCoords(Vehicle.prevVehicle))
    if not updateCoord then
        SetCamActive(Cam.cam, true)
        RenderScriptCams(1, 1, 1500, 0, 0)
    end
end

Cam.resetCam = function()
    SetCamActive(Cam.cam, false)
    DestroyCam(Cam.cam, true)
    RenderScriptCams(0, 1, 1500, 1, 1)
    FreezeEntityPosition(PlayerPedId(), false)
    Cam.cam = nil;
end
