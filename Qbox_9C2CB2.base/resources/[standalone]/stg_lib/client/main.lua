local Framework, frameworkName = getFramework()

exports('getFramework', function()
    return Framework, frameworkName
end)

exports('getMoney', function(method)
    local money = lib.callback.await('stg_lib:getMoney', false, method)
    return money or 0
end)

exports('getJob', function()
    local job = lib.callback.await('stg_lib:getJob', false)
    return job
end)

exports('getJobs', function()
    local jobs = lib.callback.await('stg_lib:getJobs', false)
    return jobs
end)

exports('getPermission', function()
    local perm = lib.callback.await('stg_lib:getPermission', false)
    return perm
end)

exports('getPlayerData', function(target)
    local data = lib.callback.await('stg_lib:getPlayerData', false, target)
    return data
end)