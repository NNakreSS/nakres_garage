---@class Player
Player = {
    gang = nil,
    job = nil
}

--- @return table { gang = " ", job = { name = " ", type = " " } }
Player.getInfo = function()
    local pData, result;
    if QBCore then
        pData = QBCore.Functions.GetPlayerData()
        result = {
            gang = pData.gang and pData.gang.name or "",
            job = {
                name = pData.job.name,
                type = pData.job.type
            }
        }
    elseif ESX then
        pData = ESX.GetPlayerData()
        result = {
            gang = pData.job.name,
            job = {
                name = pData.job.name,
                type = pData.job.grade_name
            }
        }
    end
    return result;
end

RegisterNetEvent('esx:setJob', function(job)
    Player.gang = job.name
    Player.job = {
        name = job.name,
        type = job.grade_name
    }
    Zone.removeAll();
    Garages.createAll();
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(job)
    Player.job = {
        name = job.name,
        type = job.type
    }
    Zone.removeAll();
    Garages.createAll();
end)

RegisterNetEvent('QBCore:Client:OnGangUpdate', function(gang)
    Player.gang = gang.name
    Zone.removeAll();
    Garages.createAll();
end)
