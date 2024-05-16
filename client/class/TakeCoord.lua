local isOpenCretor, Cam = false, nil
local MAX_CAM_DISTANCE = 100
local MinY, MaxY = -90.0, 90.0
local MoveSpeed = 0.15
local zoneHeight = 4
local coordsPoints = {}
local currentZone, currentZ, currentH = nil, nil, nil
local objectIndex, limit = nil, nil;
local hitCoord, heading = nil, 0.0;
local previewObject = nil;
local spawnedPreviewObjects = {};

function toggleCretor(polyzoneName, _object, _limit)
    local playerPed = PlayerPedId()
    if not isOpenCretor then
        objectIndex, limit = _object, _limit
        local x, y, z = table.unpack(GetGameplayCamCoord())
        local pitch, roll, yaw = table.unpack(GetGameplayCamRot(2))
        local fov = GetGameplayCamFov()
        Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(Cam, x, y, z + 20.0)
        SetCamRot(Cam, pitch, roll, yaw, 2)
        SetCamFov(Cam, fov)
        RenderScriptCams(true, true, 500, true, true)
        FreezeEntityPosition(playerPed, true)
        if _object then
            createObjectPreview()
        end
    else
        DeleteEntity(previewObject)

        for i, obj in ipairs(spawnedPreviewObjects) do
            DeleteEntity(obj)
        end

        SendReactMessage('takeCoordMode', false)
        G_CallBackFuntion = nil;
        currentH, currentZone, currentZ, coordsPoints, zoneHeight = polyzoneName, nil, nil, {}, 4
        objectIndex, limit, previewObject = nil, nil, nil
        hitCoord, heading = nil, 0.0;
        spawnedPreviewObjects = {};
        FreezeEntityPosition(playerPed, false)
        if Cam then
            RenderScriptCams(false, true, 500, true, true)
            SetCamActive(Cam, false)
            DetachCam(Cam)
            DestroyCam(Cam, true)
            Cam = nil
        end
    end
    isOpenCretor = not isOpenCretor
    ToggleInputThread()
end

function ToggleInputThread()
    Citizen.CreateThread(function()
        while isOpenCretor do
            startRaycast()
            camControls()
            DisabledControls()
            Citizen.Wait(0)
        end
    end)
end

-- #region Raycasting Functions
function startRaycast()
    local position = GetCamCoord(Cam)
    local hit, coords = RayCastGamePlayCamera(80.0)
    if hit then
        hitCoord = vector4(coords.x, coords.y, coords.z, heading)
        DrawLine(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 15.0, 250.0, 80.0, 0.0, 250.0)
        keyControls(hitCoord)
        setPreviewObjectCoord()
    end
end

function RayCastGamePlayCamera(distance)
    local playerPed = PlayerPedId()
    local cameraRotation = GetCamRot(Cam, 2)
    local cameraCoord = GetCamCoord(Cam)
    local direction = RotationToDirection(cameraRotation)
    local destination = {
        x = cameraCoord.x + direction.x * distance,
        y = cameraCoord.y + direction.y * distance,
        z = cameraCoord.z + direction.z * distance
    }
    local _, hits, coords, _, entity = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z,
        destination.x, destination.y, destination.z, -1, playerPed, 0))
    return hits, coords, entity
end

function RotationToDirection(rotation)
    local adjustedRotation = {
        x = (math.pi / 180) * rotation.x,
        y = (math.pi / 180) * rotation.y,
        z = (math.pi / 180) * rotation.z
    }
    local direction = {
        x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
        z = math.sin(adjustedRotation.x)
    }
    return direction
end

-- #endregion

function setPreviewObjectCoord()
    if previewObject then
        SetEntityCoords(previewObject, hitCoord.x, hitCoord.y, hitCoord.z, false, false, false, true)
        SetEntityHeading(previewObject, heading)
        PlaceObjectOnGroundProperly(previewObject)
    end
end

-- #region Manage Polygon Functions
function keyControls(coords)
    if IsControlJustPressed(0, Keys[Config.CLICK_ADD_POINT]) then
        if limit == nil or limit > #coordsPoints then
            SendReactMessage('pointCount', 1)
            table.insert(coordsPoints, coords)
            if objectIndex then
                local obj = createObject(objectIndex)
                table.insert(spawnedPreviewObjects, obj)
            end
        end
    elseif IsControlJustPressed(0, Keys[Config.CLICK_DELETE_POINT]) then
        if #coordsPoints > 0 then
            SendReactMessage('pointCount', -1)
            table.remove(coordsPoints, #coordsPoints)
            if #spawnedPreviewObjects > 0 then
                local obj = spawnedPreviewObjects[#spawnedPreviewObjects]
                DeleteObject(obj)
                table.remove(spawnedPreviewObjects, #spawnedPreviewObjects)
            end
        end
    elseif IsControlPressed(0, Keys[Config.SCROLL_DOWN]) then
        if zoneHeight > 4 then
            zoneHeight = zoneHeight - 1
        end
    elseif IsControlPressed(0, Keys[Config.SCROLL_UP]) then
        zoneHeight = zoneHeight + 1
    elseif IsControlPressed(0, Keys[Config.RIGHT]) then
        heading = heading + 1
    elseif IsControlPressed(0, Keys[Config.LEFT]) then
        heading = heading - 1
    elseif IsControlPressed(0, Keys[Config.CLICK_SAVE_POLYZONE]) then
        if #coordsPoints > 0 then
            SavePolygon()
        else
            cancelPolygonCreator()
        end
    end
end

function SavePolygon()
    local success, result = pcall(function()
        G_CallBackFuntion({
            succes = true,
            coords = coordsPoints
        })
    end)
    if not success then
        G_CallBackFuntion({
            succes = false,
            error = result
        })
    end
    toggleCretor()
end

function cancelPolygonCreator()
    G_CallBackFuntion({
        succes = false,
        error = "Cancel"
    })
    toggleCretor()
end

-- #endregion

-- #region Cam Controls Functions
function camControls()
    rotateCamInputs()
    moveCamInputs()
end

function rotateCamInputs()
    local newX
    local rAxisX = GetControlNormal(0, 220)
    local rAxisY = GetControlNormal(0, 221) -- mouse up mowe down mowe
    local rotation = GetCamRot(Cam, 2)
    local yValue = rAxisY * 5
    local newZ = rotation.z + (rAxisX * -10)
    local newXval = rotation.x - yValue
    if (newXval >= MinY) and (newXval <= MaxY) then
        newX = newXval
    end
    if newX and newZ then
        SetCamRot(Cam, vector3(newX, rotation.y, newZ), 2)
    end
end

function checkInput(index, input)
    return IsControlPressed(index, Keys[input])
end

function moveCamInputs() --
    local x, y, z = table.unpack(GetCamCoord(Cam))
    local pitch, roll, yaw = table.unpack(GetCamRot(Cam, 2))

    local dx = math.sin(-yaw * math.pi / 180) * MoveSpeed
    local dy = math.cos(-yaw * math.pi / 180) * MoveSpeed
    local dz = math.tan(pitch * math.pi / 180) * MoveSpeed

    local dx2 = math.sin(math.floor(yaw + 90.0) % 360 * -1.0 * math.pi / 180) * MoveSpeed
    local dy2 = math.cos(math.floor(yaw + 90.0) % 360 * -1.0 * math.pi / 180) * MoveSpeed

    if checkInput(0, Config.MOVE_FORWARDS) then
        x = x + dx
        y = y + dy
    elseif checkInput(0, Config.MOVE_BACKWARDS) then
        x = x - dx
        y = y - dy
    elseif checkInput(0, Config.MOVE_RIGHT) then
        x = x - dx2
        y = y - dy2
    elseif checkInput(0, Config.MOVE_LEFT) then
        x = x + dx2
        y = y + dy2
    elseif checkInput(0, Config.MOVE_UP) then
        z = z + MoveSpeed
    elseif checkInput(0, Config.MOVE_DOWN) then
        z = z - MoveSpeed
    end
    local playerPed = PlayerPedId()
    local playercoords = GetEntityCoords(playerPed)
    if GetDistanceBetweenCoords(playercoords - vector3(x, y, z), true) <= MAX_CAM_DISTANCE then
        SetCamCoord(Cam, x, y, z)
    end
end

-- #endregion

function DisabledControls()
    EnableControlAction(0, 32, true)
    EnableControlAction(0, 33, true)
    EnableControlAction(0, 34, true)
    EnableControlAction(0, 35, true)
    EnableControlAction(0, 44, true)
    EnableControlAction(0, 46, true)
    EnableControlAction(0, 69, true)
    EnableControlAction(0, 70, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
    DisableControlAction(0, 24, true) -- Attack
    DisableControlAction(0, 257, true) -- Attack 2
    DisableControlAction(0, 25, true) -- Aim
    DisableControlAction(0, 263, true) -- Melee Attack 1
    DisableControlAction(0, 45, true) -- Reload
    DisableControlAction(0, 73, true) -- Disable clearing animation
    DisableControlAction(2, 199, true) -- Disable pause screen
    DisableControlAction(0, 59, true) -- Disable steering in vehicle
    DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
    DisableControlAction(0, 72, true) -- Disable reversing in vehicle
    DisableControlAction(2, 36, true) -- Disable going stealth
    DisableControlAction(0, 47, true) -- Disable weapon
    DisableControlAction(0, 264, true) -- Disable melee
    DisableControlAction(0, 140, true) -- Disable melee
    DisableControlAction(0, 141, true) -- Disable melee
    DisableControlAction(0, 142, true) -- Disable melee
    DisableControlAction(0, 143, true) -- Disable melee
end

function createObjectPreview()
    local obj = createObject(objectIndex)
    previewObject = obj
end

function createObject(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        while not HasModelLoaded(hash) do
            Citizen.Wait(1)
        end
    end

    local obj = CreateObject(hash, hitCoord, false, false)
    PlaceObjectOnGroundProperly(obj)
    SetEntityHeading(obj, heading)
    SetEntityAlpha(obj, 150)
    SetEntityCollision(obj, false, false)
    return obj
end

function takeCoord(data, cbFunc)
    G_CallBackFuntion = cbFunc;
    toggleCretor(data.name, data.object, data.limit)
    SendReactMessage('takeCoordMode', true)
end


RegisterNUICallback('getKeyInfos', function(_, cb)
    local keyInfos = {{
        key = Config.MOVE_FORWARDS,
        type = "forward"
    }, {
        key = Config.MOVE_BACKWARDS,
        type = "back"
    }, {
        key = Config.MOVE_LEFT,
        type = "left"
    }, {
        key = Config.MOVE_RIGHT,
        type = "right"
    }, {
        key = Config.MOVE_DOWN,
        type = "down"
    }, {
        key = Config.MOVE_UP,
        type = "up"
    }, {
        key = Config.CLICK_SAVE_POLYZONE,
        type = "save"
    }}
    cb(keyInfos)
end)