local fn = {}
local nd = require "@ND_Core/init"
local config = lib.load("shared/config")

function fn:GetPlayer(id)
    return nd.getPlayer(id)
end

function fn:GetIdentifier(id)
    local player = self:GetPlayer(id)
    return player and player.identifier or tostring(id)
end

function fn:GetJob(id)
    local player = self:GetPlayer(id)
    if not player then
        return { name = "unemployed", label = "Unemployed", grade = 0, gradeLabel = "Unemployed" }
    end
    local _, job = player.getJob()
    return {
        name = job.name,
        label = job.label,
        grade = job.rank,
        gradeLabel = job.rankName,
    }
end

function fn:SetJob(id, name, grade)
    local player = self:GetPlayer(id)
    if not player then return end
    player.setJob(name, grade)
    local _, job = player.getJob()
    TriggerEvent("cu_multijob:server:onJobChange", id, {
        name = job.name,
        label = job.label,
        grade = job.rank,
        gradeLabel = job.rankName,
    })
end

function fn:GetData(id)
    local player = self:GetPlayer(id)
    local group = "user"
    if player then
        for key, _ in pairs(config.allowedGroups) do
            if player.getGroup(key) then
                group = key
            end
        end
    end
    return {
        name = player and player.firstname or GetPlayerName(id) or "Player",
        lastname = player and player.lastname or "",
        group = group,
    }
end

return fn
