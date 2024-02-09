Config = {}
-- Key bindings
Config.MOVE_FORWARDS = 32 -- Default: W
Config.MOVE_BACKWARDS = 33 -- Default: S
Config.MOVE_LEFT = 34 -- Default: A
Config.MOVE_RIGHT = 35 -- Default: D
Config.MOVE_UP = 44 -- Default: Q
Config.MOVE_DOWN = 46 -- Default: E
Config.wheel_up = 15 -- Default: Mouse wheel up
Config.wheel_down = 14 -- Default: Mouse wheel down
Config.CAM_FOCUS_OBJECT = 348 -- Default: Mouse wheel click
Config.FOCUS_SELECT = 69 -- Default: Mouse Left click
Config.FOCUS_UI = 70 -- Default: Mouse Right click
Config.SPEED_FAST_MODIFIER = 21 -- Default: Left Shift

local isOpenCretor, Cam = false, nil
local MinY, MaxY = -89.0, 89.0
local MAX_CAM_DISTANCE = 30
local spawnCoord, focusObject, isPointCam, camFocusObject
local MinY, MaxY = -89.0, 89.0
local MoveSpeed = 0.1

RegisterCommand("polyzone-create", function()
    toggleCretor()
end)

function toggleCretor()
    local playerPed = PlayerPedId()
    if not isOpenCretor then
        local x, y, z = table.unpack(GetGameplayCamCoord())
        local pitch, roll, yaw = table.unpack(GetGameplayCamRot(2))
        local fov = GetGameplayCamFov()
        Cam = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
        SetCamCoord(Cam, x, y, z)
        SetCamRot(Cam, pitch, roll, yaw, 2)
        SetCamFov(Cam, fov)
        RenderScriptCams(true, true, 500, true, true)
        FreezeEntityPosition(playerPed, true)
    else
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
            CheckInputRotation()
            CheckInputCoords()
            DisabledControls()
            Citizen.Wait(0)
        end
    end)
end

local points = {}
function startRaycast()
    local position = GetCamCoord(Cam)
    local hit, coords, entity = RayCastGamePlayCamera(50.0)
    if hit then
        DrawLine(coords.x, coords.y, coords.z, coords.x, coords.y, coords.z + 10.0, 250.0, 0.0, 0.0, 250.0)
        if checkInput(0, Config.FOCUS_SELECT) then
            local newVector2<const> = vector2(coords.x, coords.y)
            table.insert(points, newVector2)
            addPolyzone()
        end
    end
end

local pinkPoly = nil
function addPolyzone(vec)
    if pinkPoly then
        pinkPoly:destroy();
    end

    pinkPoly = PolyZone:Create(points, {
        name = "pink_cage",
        maxZ = 62.0,
        debugGrid = true,
        gridDivisions = 25
    })
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

function CheckInputRotation()
    local newX
    local rAxisX = GetControlNormal(0, 220)
    local rAxisY = GetControlNormal(0, 221)
    local rotation = GetCamRot(Cam, 2)
    local yValue = rAxisY * 5
    local newZ = rotation.z + (rAxisX * -10)
    local newXval = rotation.x - yValue
    if (newXval >= MinY) and (newXval <= MaxY) then
        newX = newXval
    end
    if newX ~= nil and newZ ~= nil then
        SetCamRot(Cam, vector3(newX, rotation.y, newZ), 2)
    end
end

function checkInput(index, input)
    return IsControlPressed(index, input)
end

function CheckInputCoords()
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
        z = z + dz
    elseif checkInput(0, Config.MOVE_BACKWARDS) then
        x = x - dx
        y = y - dy
        z = z - dz
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

function DisabledControls()
    DisableAllControlActions(2)
    EnableControlAction(0, 32, true)
    EnableControlAction(0, 33, true)
    EnableControlAction(0, 34, true)
    EnableControlAction(0, 35, true)
    EnableControlAction(0, 44, true)
    EnableControlAction(0, 46, true)
    EnableControlAction(0, 172, true)
    EnableControlAction(0, 173, true)
    EnableControlAction(0, 174, true)
    EnableControlAction(0, 175, true)
    EnableControlAction(0, 14, true)
    EnableControlAction(0, 15, true)
    EnableControlAction(0, 348, true)
    EnableControlAction(0, 69, true)
    EnableControlAction(0, 70, true)
    EnableControlAction(0, 21, true)
    EnableControlAction(0, 29, true)
    EnableControlAction(0, 236, true)
    EnableControlAction(0, 253, true)
    EnableControlAction(0, 322, true)
    EnableControlAction(0, 220, true)
    EnableControlAction(0, 221, true)
    EnableControlAction(0, 249, true)
end
