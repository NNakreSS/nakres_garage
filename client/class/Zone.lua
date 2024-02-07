---@class Zones
--- use Polyzone

Zone                           = {};

local garageZones              = {};
local garageNpcs               = {};

--- Used to create area functions using the Polyzone script.
--- @param type string Type of boxZone -> garageArea / parkOut / parkIn
--- @param garage table Garage table from garages.lua
--- @param index string Garage table index
Zone.create                    = function(type, garage, index)
    local types   = {
        ['parkIn'] = {
            coords  = garage.putVehicle,
            size    = 4,
            minEq   = -1.0,
            maxEq   = 2.0,
            heading = garage.spawnPoint.w
        },
        ['garageArea'] = {
            coords  = garage.takeVehicle,
            size    = 60,
            minEq   = -7.5,
            maxEq   = 7.0,
            heading = garage.spawnPoint.w
        },
        ['house'] = {
            coords  = garage.takeVehicle,
            size    = 10,
            minEq   = -1.0,
            maxEq   = 2.0,
            heading = garage.takeVehicle.w
        },
    }

    local size    = types[type].size
    local coords  = vector3(types[type].coords.x, types[type].coords.y, types[type].coords.z)
    local heading = types[type].heading
    local minz    = coords.z + types[type].minEq
    local maxz    = coords.z + types[type].maxEq

    if type ~= "parkOut" then
        garageZones[type .. "_" .. index] = {}
        garageZones[type .. "_" .. index].boxZone = BoxZone:Create(
            coords, size, size, {
                minZ = minz,
                maxZ = maxz,
                name = type,
                debugPoly = Config.debugMode,
                heading = heading
            })

        garageZones[type .. "_" .. index].comboZone = ComboZone:Create({ garageZones[type .. "_" .. index].boxZone },
            { name = "box" .. type, debugPoly = Config.debugMode })

        garageZones[type .. "_" .. index].comboZone:onPlayerInOut(function(isEntered)
            if isEntered then
                if type ~= "parkIn" then
                    CurrentGarage = garage
                    CurrentGarageIndex = index
                    if garage.type ~= "depot" then
                        Zone.create("parkIn", garage, index)
                        Markers = true
                    end
                    HouseMarkers = garage.type == "house" and true or false;
                else
                    EnteredParked = true
                end
            else
                if type ~= "parkIn" then
                    if CurrentGarage == garage then
                        CurrentGarage = nil
                        CurrentGarageIndex = nil
                        if garage.type ~= "depot" then
                            Markers = false
                        end
                        HouseMarkers = garage.type == "house" and false
                        Zone.destroy("parkIn", index)
                    end
                else
                    EnteredParked = false
                end
            end
        end)
    end
end

--- Deletes the created polyzone area.
--- @param type string The type of garage.
--- @param index string The name index of the garage.
Zone.destroy                   = function(type, index)
    if garageZones[type .. "_" .. index] then
        garageZones[type .. "_" .. index].comboZone:destroy()
        garageZones[type .. "_" .. index].boxZone:destroy()
    end
end

--- Adds NPC information for each garage to the garage NPCs table.
--- @param index string Garages value index
--- @param garage table Garages value
Zone.createTargetPed           = function(index, garage)
    if garage.type ~= 'house' then
        garageNpcs[index] = {
            label = garage.label,
            ped = garage.npc and garage.npc.model or 's_m_y_valet_01',
            npc = nil,
            coord = garage.takeVehicle,
            heading = garage.npc and garage.npc.heading or (garage.takeVehicle.w or 0.0),
            created = false,
            garageType = garage.type,
            job = (garage.type == 'job' or garage.type == 'gang') and { job = garage.job, jobType = garage.jobType }
        }
    end
end

--- @param targetName string label of the target
--- @param ped ped Target entity to be added
--- @param _type string  || public, job, gang, depot || type of the garage to which the target NPC belongs
--- @param job table {job = '' , jobType = ''}  job that has access to the garage where the target entity belongs
Zone.createTarget              = function(targetName, ped, _type, job)
    if checkGarageTypeJobPerm(_type, job) then
        if GetResourceState('qb-target') == 'started' then
            exports['qb-target']:AddTargetEntity(ped,
                {
                    options = {
                        {
                            type = "client",
                            -- icon = 'fa-solid fa-warehouse',
                            label = targetName,
                            targeticon = 'fa-solid fa-warehouse',
                            action = function()
                                TriggerEvent(ResourceName .. ':openGarageMenu')
                            end,
                            canInteract = function()
                                return (GetVehiclePedIsIn(PlayerPedId(), false) == 0)
                            end,
                        }
                    },
                    distance = 2.5,
                })
        elseif GetResourceState('ox_target') == 'started' then
            exports.ox_target:addLocalEntity(ped, {
                label = targetName,
                name = targetName,
                icon = 'fa-solid fa-warehouse',
                distance = 2,
                onSelect = function()
                    if (GetVehiclePedIsIn(PlayerPedId(), false) == 0) then
                        TriggerEvent(ResourceName .. ':openGarageMenu')
                    end
                end
            })
        elseif GetResourceState('qtarget') == 'started' then
            exports.qtarget:AddTargetEntity(ped, {
                options = {
                    {
                        event = ResourceName .. ':openGarageMenu',
                        icon = "fa-solid fa-warehouse",
                        label = targetName,
                        num = 1
                    }
                },
                distance = 2
            })
        end
    end
end

--- Deletes the target created for the NPC.
--- @param npc ped npc ped
--- @param targetName string name of the target
Zone.removeTarget              = function(npc, targetName)
    if GetResourceState('qb-target') == 'started' then
        exports['qb-target']:RemoveTargetEntity(npc, targetName)
    elseif GetResourceState('ox_target') == 'started' then
        exports.ox_target:removeLocalEntity(npc, targetName)
    elseif GetResourceState('qtarget') == 'started' then
        Nakres.debugPrint('Bu betik için target silme işlemi mevcut değil')
    end
end

Zone.removeAll                 = function()
    for index, value in pairs(garageNpcs) do
        Zone.removeTarget(garageNpcs[index].npc, value.label)
        if DoesEntityExist(garageNpcs[index].npc) then
            DeleteEntity(garageNpcs[index].npc)
        end
        garageNpcs[index].npc = nil;
        garageNpcs[index].created = false;
    end

    for key, value in pairs(garageZones) do
        value.comboZone:destroy()
        value.boxZone:destroy()
    end
    garageZones = {};
    garageNpcs  = {};
end

Zone.checkDistanceGarageForNpc = function()
    local pcord = GetEntityCoords(PlayerPedId())
    for index, value in pairs(garageNpcs) do
        local coord = vector3(value.coord.x, value.coord.y, value.coord.z - 1.0)
        local dst = #(pcord - coord)
        if dst < 150 then
            if not value.created then
                LoadedModel(value.ped)
                value.model = type(value.model) == 'string' and joaat(value.model);
                local npc = CreatePed(0, value.ped, coord,
                    value.heading or 0.0, false, true)
                PlaceObjectOnGroundProperly(npc)
                FreezeEntityPosition(npc, true)
                SetEntityInvincible(npc, true)
                SetBlockingOfNonTemporaryEvents(npc, true)
                garageNpcs[index].created = true;
                garageNpcs[index].npc = npc;
                Zone.createTarget(value.label, npc, value.garageType, value.job)
            end
        else
            if DoesEntityExist(garageNpcs[index].npc) then
                Zone.removeTarget(garageNpcs[index].npc, value.label)
                DeleteEntity(garageNpcs[index].npc)
                garageNpcs[index].npc = nil;
                garageNpcs[index].created = false;
            end
        end
    end
end
