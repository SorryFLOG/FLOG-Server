local Framework, frameworkName = getFramework()

exports('getPlayer', function(source)
    return getPlayer(source)
end)

exports('getAllPlayers', function()
    return getAllPlayers()
end)

exports('getJobs', function()
    return getJobs()
end)

exports('registerUsableItem', function(itemName, callback)
    registerUsableItem(itemName, callback)
end)

exports('getFramework', function()
    return Framework, frameworkName
end)

lib.callback.register('stg_lib:getMoney', function(source, method)
    local Player = getPlayer(source)
    if Player then
        return getMoney(Player, method)
    end
    return 0
end)

lib.callback.register('stg_lib:getJob', function(source)
    local Player = getPlayer(source)
    if Player then
        return getJob(Player)
    end
    return nil
end)

lib.callback.register('stg_lib:getJobs', function(source)
    return getJobs()
end)

lib.callback.register('stg_lib:getPermission', function(source)
    local Player = getPlayer(source)
    if Player then
        return getPermission(Player)
    end
    return "user"
end)

lib.callback.register('stg_lib:getPlayerData', function(source, target)
    local id = source
    target = tonumber(target)

    if target and target ~= source then
        local requester = getPlayer(source)
        if not requester then
            return false
        end

        if getPermission(requester) == "user" then
            return false
        end

        id = target
    end

    local Player = getPlayer(id)
    if Player then
        local identifier = Player.identifier or Player.PlayerData.citizenid
        local name = getName(identifier, Player)

        return {
            identifier = identifier,
            firstname = name.firstname,
            lastname = name.lastname,
            job = getJob(Player),
            dob = getDob(identifier, Player),
            gender = getGender(identifier, Player),
            nation = getNationality(identifier, Player),
            identifiers = id == source and GetPlayerIdentifiers(source) or nil
        }
    else
        return false
    end
end)