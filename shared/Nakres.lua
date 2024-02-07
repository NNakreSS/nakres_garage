-- Nakres table to hold utility functions
Nakres = {};
Nakres.Client = {};
Nakres.Client.ClientCallbacks = {};
Nakres.Client.ServerCallbacks = {};

Nakres.Server = {};
Nakres.Server.ServerCallbacks = {};
Nakres.Server.ClientCallbacks = {};

ResourceName = GetCurrentResourceName();

--- Trims leading and trailing whitespaces from a string.
--- @param str string The input string to trim
--- @return string|nil Trimmed string, or nil if input is nil
Nakres.Trim = function(str)
    if not str then
        return nil
    end
    return (string.gsub(str, '^%s*(.-)%s*$', '%1'))
end

Nakres.Contains = function(validateTable, value)
    for _, tableValue in pairs(validateTable) do
        if value == tableValue then
            return true;
        end
    end
    return false;
end

--- Rounds a numeric value to the specified number of decimal places.
--- If numDecimalPlaces is not provided, rounds to the nearest integer.
--- @param value number The numeric value to round
--- @param numDecimalPlaces number|nil The number of decimal places to round to. If nil, rounds to the nearest integer.
--- @return number Rounded value
Nakres.Round = function(value, numDecimalPlaces)
    if not numDecimalPlaces then
        return math.floor(value + 0.5)
    end
    local power = 10 ^ numDecimalPlaces
    return math.floor((value * power) + 0.5) / (power)
end

--- Prints a debug message if debug mode is enabled.
--- @param message string The message to print
Nakres.debugPrint = function(message)
    if Config.debugMode then
        local info = debug.getinfo(2, "Sl")
        local line = info.currentline
        local file = info.short_src
        print(string.format("^2[%s:%d]^0  ^4%s^0\n", file, line, message))
    end
end

Nakres.Client.triggerAllClient = function(triggerName, ...)
    TriggerServerEvent(ResourceName .. 'nakres:trigger:allClient', triggerName, ...)
end

RegisterNetEvent(ResourceName .. 'nakres:trigger:allClient', function(event, ...)
    TriggerClientEvent(event, -1, ...)
end)

-- Callback Functions --

--- Client Callback

--- @param name string the name of the callback function
--- @param cb function the callback function
function Nakres.Client.CreateClientCallback(name, cb)
    Nakres.Client.ClientCallbacks[name] = cb
end

--- @param name string the name of the callback function
--- @param cb function the callback function
function Nakres.Client.TriggerClientCallback(name, cb, ...)
    if not Nakres.Client.ClientCallbacks[name] then
        return
    end
    Nakres.Client.ClientCallbacks[name](cb, ...)
end

--- @param name string the name of the callback function
--- @param cb function the callback function
function Nakres.Client.TriggerCallback(name, cb, ...)
    Nakres.Client.ServerCallbacks[name] = cb
    TriggerServerEvent(ResourceName .. ":Server:TriggerCallback", name, ...)
end

--- @param name string the name of the callback function
--- @param ... any your parameters
--- @return any
function Nakres.Client.AwaitTriggerCallback(name, ...)
    local result = nil;

    local resultCallback = function(response)
        result = response
    end

    Nakres.Client.TriggerCallback(name, resultCallback, ...)

    repeat
        Citizen.Wait(5)
    until (result ~= nil)

    Nakres.debugPrint(result)

    return result
end

RegisterNetEvent(ResourceName .. ':Client:TriggerClientCallback', function(name, ...)
    Nakres.Client.TriggerClientCallback(name, function(...)
        TriggerServerEvent(ResourceName .. ':Server:TriggerClientCallback', name, ...)
    end, ...)
end)

RegisterNetEvent(ResourceName .. ':Client:TriggerCallback', function(name, ...)
    if Nakres.Client.ServerCallbacks[name] then
        Nakres.Client.ServerCallbacks[name](...)
        Nakres.Client.ServerCallbacks[name] = nil
    end
end)

--- Server Callback

RegisterNetEvent(ResourceName .. ':Server:TriggerClientCallback', function(name, ...)
    if Nakres.Server.ClientCallbacks[name] then
        Nakres.Server.ClientCallbacks[name](...)
        Nakres.Server.ClientCallbacks[name] = nil
    end
end)

RegisterNetEvent(ResourceName .. ':Server:TriggerCallback', function(name, ...)
    local src = source
    Nakres.Server.TriggerCallback(name, src, function(...)
        TriggerClientEvent(ResourceName .. ':Client:TriggerCallback', src, name, ...)
    end, ...)
end)

---Trigger Client Callback
---@param name string
---@param source any
---@param cb function
---@param ... any parameters
function Nakres.Server.TriggerClientCallback(name, source, cb, ...)
    Nakres.Server.ClientCallbacks[name] = cb
    TriggerClientEvent(ResourceName .. ':Client:TriggerClientCallback', source, name, ...)
end

---Create Server Callback
---@param name string
---@param cb function
function Nakres.Server.CreateCallback(name, cb)
    Nakres.Server.ServerCallbacks[name] = cb
end

---Trigger Server Callback
---@param name string
---@param source any
---@param cb function
---@param ... any parameters
function Nakres.Server.TriggerCallback(name, source, cb, ...)
    if not Nakres.Server.ServerCallbacks[name] then
        return
    end
    Nakres.Server.ServerCallbacks[name](source, cb, ...)
end
