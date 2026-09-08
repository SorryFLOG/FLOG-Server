local fn = {}

local ok, core = pcall(function()
    return exports.LEGACYCORE:getSharedObject()
end)

if not ok then
    print("cu_multijob: LEGACYCORE bridge failed to load shared object")
end

function fn:GetPlayer(id)
    if not core then return nil end
    return core.GetPlayerFromId(id)
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
    if core.DoesJobExist and core.DoesJobExist(name, grade) then
        player.setJob(name, grade)
    else
        player.setJob(name, grade)
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

AddEventHandler("LEGACYCORE:playerLoaded", function(playerId)
    TriggerEvent("cu_multijob:server:playerLoaded", playerId)
end)

AddEventHandler("LEGACYCORE:setJob", function(playerId, job, lastJob)
    TriggerEvent("cu_multijob:server:onJobChange", playerId, {
        name = job.name,
        label = job.label,
        grade = job.grade,
        gradeLabel = job.grade_label,
    }, lastJob)
end)

return fn
