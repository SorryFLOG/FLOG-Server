local fn = {}
local ox = require "@ox_core/lib/init"
local config = lib.load("shared/config")

function fn:GetPlayer(id)
    return ox:GetPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player and player.charId or tostring(id)
end

function fn:GetJob(id)
    local player = self:GetPlayer(id)
    if not player then
        return { name = "unemployed", label = "Unemployed", grade = 0, gradeLabel = "Unemployed" }
    end
    local jobName = player.get("activeGroup")
    local jobGrade = player.getGroup(jobName)
    return {
        name = jobName,
        label = jobName,
        grade = jobGrade,
        gradeLabel = tostring(jobGrade),
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    if not player then return end
    player.setGroup(name, grade)
    local jobName = player.get("activeGroup")
    local jobGrade = player.getGroup(jobName)
    TriggerEvent("cu_multijob:server:onJobChange", id, {
        name = jobName,
        label = jobName,
        grade = jobGrade,
        gradeLabel = tostring(jobGrade),
    })
end

function fn:GetData(id)
    local group = "user"
    for key, _ in pairs(config.allowedGroups) do
        if IsPlayerAceAllowed(id, key) then
            group = key
        end
    end
    return {
        name = GetPlayerName(id) or "Player",
        lastname = "",
        group = group,
    }
end

return fn
