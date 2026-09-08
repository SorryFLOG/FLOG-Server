local fn = {}
local ESX = exports.es_extended:getSharedObject()

function fn:GetPlayer(id)
    return ESX.GetPlayerFromId(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player and player.identifier or tostring(id)
end

function fn:GetJob(id)
    local player = self:GetPlayer(id)
    local job = player and player.job or {}
    return {
        name = job.name or "unemployed",
        label = job.label or "Unemployed",
        grade = job.grade or 0,
        gradeLabel = job.grade_label or "Unemployed",
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    if not player then return end
    if ESX.DoesJobExist(name, grade) then
        player.setJob(name, grade)
    else
        print(("cu_multijob: ESX job not found (%s:%s)"):format(name, grade))
    end
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    return {
        name = player and player.get("firstName") or GetPlayerName(id) or "Player",
        lastname = player and player.get("lastName") or "",
        group = player and player.group or "user",
    }
end

AddEventHandler("esx:playerLoaded", function(playerId)
    TriggerEvent("cu_multijob:server:playerLoaded", playerId)
end)

AddEventHandler("esx:setJob", function(playerId, job, lastJob)
    TriggerEvent("cu_multijob:server:onJobChange", playerId, {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label,
    }, lastJob)
end)

return fn
