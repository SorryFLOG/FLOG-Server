local config = lib.load("shared/config")

Jobs = Jobs or {}

local function canManage(source)
    local data = FW:GetData(source)
    return data and data.group and config.allowedGroups[data.group] == true
end

local function removeJob(source, id, job)
    local target = tostring(id)
    local targetId = tonumber(target) or target
    if job == config.defaultJob.name then
        return false
    end
    if source and target ~= tostring(source) and not canManage(source) then
        return false
    end
    if Jobs[target] and Jobs[target][job] then
        Jobs[target][job] = nil
        if FW:GetJob(targetId).name == job then
            FW:SetJob(targetId, config.defaultJob.name, config.defaultJob.grade)
        end
        return true
    end
    return false
end

local function getJobs(source, id)
    local target = tostring(id)
    if source and target ~= tostring(source) and not canManage(source) then
        return nil
    end
    return Jobs[target] or {}
end

local function hasJob(source, id, name, grade)
    local target = tostring(id)
    if source and target ~= tostring(source) and not canManage(source) then
        return false, false
    end
    local job = Jobs[target]
    if not job or not job[name] then
        return false, false
    end
    if grade == nil then
        return true, true
    end
    return true, job[name].grade == grade
end

RegisterNetEvent("cu_multijob:server:removeJob", function(args)
    local src = source
    if type(args) == "table" then
        if removeJob(src, args.id or src, args.job) then
            TriggerClientEvent("cu_multijob:client:jobRemoved", src, args.job)
        end
    elseif type(args) == "string" then
        if removeJob(src, src, args) then
            TriggerClientEvent("cu_multijob:client:jobRemoved", src, args)
        end
    end
end)

exports("removeJob", removeJob)
exports("getJobs", getJobs)
exports("hasJob", hasJob)
