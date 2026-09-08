local Query = require "server/modules/queries"
local config = lib.load("shared/config")
local fn = lib.load("server/functions")

Jobs = {}

lib.callback.register("cu_multijob:server:getJobs", function(source)
    local key = tostring(source)
    return (Jobs[key] or {}), FW:GetJob(source).name
end)

RegisterNetEvent("cu_multijob:server:setJob", function(name)
    local key = tostring(source)
    local jobs = Jobs[key]
    if jobs and jobs[name] then
        FW:SetJob(source, name, jobs[name].grade)
    end
end)

AddEventHandler("cu_multijob:server:onJobChange", function(source, job, lastJob)
    local key = tostring(source)
    local jobs = Jobs[key] or {}

    if jobs[job.name] and jobs[job.name].grade == job.grade then return end

    local jobCount = fn:countJobs(jobs)
    if jobCount >= config.maxJobs and not jobs[job.name] then
        if lastJob and lastJob.name then
            FW:SetJob(source, lastJob.name, lastJob.grade)
        end
        return
    end

    jobs[job.name] = {
        label = job.label,
        grade = job.grade,
        gradeLabel = job.gradeLabel,
    }
    Jobs[key] = jobs
end)

AddEventHandler("cu_multijob:server:playerLoaded", function(id)
    Query:loadJobs(id)
end)

AddEventHandler("playerDropped", function()
    Query:saveJobs(source)
end)

AddEventHandler("onResourceStop", function(res)
    if res ~= GetCurrentResourceName() then return end
    for _, id in pairs(GetPlayers()) do
        Query:saveJobs(tonumber(id) or id)
    end
end)

CreateThread(function()
    if GetResourceState(GetCurrentResourceName()) == "started" then
        Wait(100)
        Query:init()
        for _, id in pairs(GetPlayers()) do
            Query:loadJobs(tonumber(id) or id)
        end
    end
end)
