Config = {
    debugMode = false, -- Only developer mode
    locale = 'En' -- shareds/locales.lua table (En - Tr - De)
}

-- For blips
Config.blipsDisplay = 4 -- https://docs.fivem.net/natives/?_0x9029B2F3DA924928 SetBlipDisplay displayId
Config.blipsScale = 0.60 -- Default blips scale
Config.blipsAsShortRange = true -- True to only display the blip as 'short range', false to display the blip from a longer distance.

-- Garages
Config.SharedGarages = false -- True == Gang and job garages are shared, false == Gang and Job garages are personal
Config.sharedVehicle = false -- True == Someone else can put your vehicle in the garage, false == No one else can put your vehicle in the garage
Config.checkClearSpawnPoint = true -- True == Checks if the spawn point is clear when you take a vehicle out of the garage; you cannot take it out if it's not clear.
Config.uniqueGarages = true
Config.limitedGarages = true -- True == Limits the number of vehicles a player can put in a garage; requires Config.uniqueGarages = true.
Config.defaultLimit = 10 -- Default limit assigned if garage limit is not specified; requires Config.limitedGarages = true.

-- Impounds
Config.autoPutInGarage = false -- True == Puts owned vehicles left outside back to their last garage locations when the script is restarted; false == Vehicles left outside go to the impound.
Config.autoPutImpoundMoney = 500 -- Config.autoPutInGarage == False, the amount to be paid to retrieve vehicles that went to impound due to being left outside.
Config.policeJob = 'police' -- Job with the authority to impound vehicles.
Config.defaultImpoundPrice = 1000

-- Other
Config.nakresLightbar = false -- Set to true if you are using the nakres_lightbar script / https://github.com/NNakreSS/Fivem-Lightbar
Config.vehicleGarageAnimation = true -- True == Vehicles are removed from the garage by losing opacity instead of instantly deleting.
Config.newEsx = true -- Set to true if you are using the latest version of the esx framework with exports.
Config.spacedPlate = true -- False == Saves plates by removing spaces; set to true if you are using spaced plates.
Config.garagePreview = true -- True == Creates preview coordinates for vehicles placed in the garage using the coordinates specified in the previews table of the garage data.
Config.admins = {"license:430ef51e2398d78f2cb10ce264a758fe08067aab"} -- Priority check with SteamID; if not found, checks license key.
-- Create garage commands
Config.commands = {
    createGarage = "createng", -- /createng [garageindex]
    addgaragepreviewpoint = 'addgp',
    savegarage = 'saveng',
    depot = 'depot' -- /depot [price]
}

Config.vehicleCatagories = { -- https://docs.fivem.net/natives/?_0x29439776AAA00A62
    ["car"] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 17, 18, 19, 21, 22},
    ["air"] = {15, 16},
    ['sea'] = {14},
    ['rig'] = {10, 11, 12, 20}
}

Config.defaultImpoundGarageForCategories = { --- İmpound garage index from garages.lua
    ["car"] = "impoundlot",
    ["air"] = "airdepot",
    ['sea'] = "seadepot",
    ['rig'] = "rigdepot"
}

-- Customize Functions

--- @param veh vehicle
--- @return number || vehicle fuel
Config.getFuel = function(veh)
    if GetResourceState("LegacyFuel") == 'started' then
        return exports['LegacyFuel']:GetFuel(veh)
    else
        return Nakres.Round(GetVehicleFuelLevel(veh), 0.1) -- or, the function/export of a different fuel script you use
    end
end

--- @param veh vehicle
--- @param fuel number fuel level
Config.setFuel = function(veh, fuel)
    if GetResourceState("LegacyFuel") == 'started' then
        exports['LegacyFuel']:SetFuel(veh, fuel)
    else
        SetVehicleFuelLevel(veh, fuel + 0.0) -- or, the function/export of a different fuel script you use
    end
end

--- @param text string Notify text
--- @param texttype string Notify type - error | success | info
Config.Notify = function(text, texttype)
    -- Default notifications or your notification event/export
    if QBCore then
        QBCore.Functions.Notify(text, texttype, 5000)
    elseif ESX then
        TriggerEvent('esx:showNotification', text, texttype, 5000)
    end
end

Config.vehicleKey = function(plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate) -- For qb-vehiclekeys
end

Config.houseHasKey = function(source, house)
    -- your house key check function -- retrun true or false
    return true -- defoult always true
end
