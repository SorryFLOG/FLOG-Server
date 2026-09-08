local fn = {}
local qbx = exports["qbx_core"]
local config = lib.load("shared/config")

function fn:GetPlayer(id)
    return qbx:GetPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player and player.PlayerData.citizenid or tostring(id)
end

function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local job = player and player.PlayerData.job or {}
    return {
        name = job.name or "unemployed",
        label = job.label or "Unemployed",
        grade = job.grade and job.grade.level or 0,
        gradeLabel = job.grade and job.grade.name or "Unemployed",
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    if not player then return end
    player.Functions.SetJob(name, grade)
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    local group = "user"
    for key, _ in pairs(config.allowedGroups) do
        if IsPlayerAceAllowed(id, key) then
            group = key
        end
    end
    return {
        name = player and player.PlayerData.firstname or GetPlayerName(id) or "Player",
        lastname = player and player.PlayerData.lastname or "",
        group = group,
    }
end

AddEventHandler("QBCore:Server:PlayerLoaded", function(pObj)
    TriggerEvent("cu_multijob:server:playerLoaded", pObj.PlayerData.source)
end)

AddEventHandler("QBCore:Server:OnJobUpdate", function(source, job)
    TriggerEvent("cu_multijob:server:onJobChange", source, {
        name = job.name,
        label = job.label,
        grade = job.grade.level or job.grade,
        gradeLabel = job.grade.name or job.gradeLabel or tostring(job.grade),
    })
end)

return fn
