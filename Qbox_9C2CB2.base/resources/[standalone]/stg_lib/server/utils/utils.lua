local Framework, frameworkName = getFramework()

local playerCache = {
    nationality = {},
    dob = {},
    gender = {}
}

function getPlayer(source)
    local Player
    if frameworkName == "esx" then
        Player = Framework.GetPlayerFromId(source)
    else
        Player = Framework.Functions.GetPlayer(source)
    end

    if not Player then
        return nil
    end

    if frameworkName ~= "esx" then
        Player.identifier = Player.PlayerData.citizenid
    end

    Player.stg_getMoney = function(method)
        return getMoney(Player, method)
    end

    Player.stg_addMoney = function(method, amount)
        return addMoney(Player, method, amount)
    end

    Player.stg_removeMoney = function(method, amount)
        return removeMoney(Player, method, amount)
    end

    Player.stg_getItem = function(item)
        return getItem(Player, item)
    end

    Player.stg_addItem = function(item, count)
        return addItem(Player, item, count)
    end

    Player.stg_removeItem = function(item, count)
        return removeItem(Player, item, count)
    end

    Player.stg_getJob = function()
        return getJob(Player)
    end

    Player.stg_setJob = function(job, grade)
        return setJob(Player, job, grade)
    end

    Player.stg_getPermission = function()
        return getPermission(Player)
    end

    Player.stg_getGender = function()
        local identifier = Player.identifier or Player.PlayerData.citizenid
        return getGender(identifier, Player)
    end

    Player.stg_getNationality = function()
        local identifier = Player.identifier or Player.PlayerData.citizenid
        return getNationality(identifier, Player)
    end

    Player.stg_getDob = function()
        local identifier = Player.identifier or Player.PlayerData.citizenid
        return getDob(identifier, Player)
    end

    Player.stg_getName = function()
        local identifier = Player.identifier or Player.PlayerData.citizenid
        return getName(identifier, Player)
    end

    Player.stg_getVehicles = function()
        local identifier = Player.identifier or Player.PlayerData.citizenid
        return getVehicles(identifier)
    end

    return Player
end

function addItem(Player, item, count)
    if frameworkName == "esx" then
        Player.addInventoryItem(item, count)
    else
        Player.Functions.AddItem(item, count)
    end
end

function removeItem(Player, item, count)
    if frameworkName == "esx" then
        Player.removeInventoryItem(item, count)
    else
        Player.Functions.RemoveItem(item, count)
    end
end

function registerUsableItem(itemName, callback)
    if frameworkName == "esx" then
        Framework.RegisterUsableItem(itemName, callback)
    elseif frameworkName == "qbx" then
        exports.qbx_core:CreateUseableItem(itemName, callback)
    else
        Framework.Functions.CreateUseableItem(itemName, callback)
    end
end

function getItem(Player, item)
    if frameworkName == "esx" then
        return Player.getInventoryItem(item)
    else
        return Player.Functions.GetItemByName(item)
    end
end

function getMoney(Player, method)
    if frameworkName == "esx" then
        if method == "cash" then
            return Player.getMoney()
        else
            return Player.getAccount('bank').money
        end
    else
        if method == "cash" then
            return Player.PlayerData.money["cash"]
        else
            return Player.PlayerData.money["bank"]
        end
    end
end

function addMoney(Player, method, money)
    if frameworkName == "esx" then
        if method == "cash" then
            Player.addMoney(money)
        else
            Player.addAccountMoney('bank', money)
        end
    else
        if method == "cash" then
            Player.Functions.AddMoney('cash', money)
        else
            Player.Functions.AddMoney('bank', money)
        end
    end
end

function setJob(Player, job, grade)
    grade = grade or 0

    if frameworkName == "esx" then
        Player.setJob(job, grade)
    else
        Player.Functions.SetJob(job, grade)
    end
end

function removeMoney(Player, method, money)
    if frameworkName == "esx" then
        if method == "cash" then
            Player.removeMoney(money)
        else
            Player.removeAccountMoney('bank', money)
        end
    else
        if method == "cash" then
            Player.Functions.RemoveMoney("cash", money)
        else
            Player.Functions.RemoveMoney('bank', money)
        end
    end
end

local cachedNames = {}

function getName(identifier, Player)
    if not identifier then
        return {
            firstname = "Not",
            lastname = "Found"
        }
    end

    if cachedNames[identifier] then
        return cachedNames[identifier]
    end

    if frameworkName == "esx" then
        local Info = exports.oxmysql:executeSync("SELECT * FROM users WHERE identifier = @identifier", {
            ["@identifier"] = identifier
        })

        if Info[1] and Info[1].firstname and Info[1].lastname then
            cachedNames[identifier] = {
                firstname = Info[1].firstname,
                lastname = Info[1].lastname
            }
        end
    else
        if Player and Player.PlayerData and Player.PlayerData.charinfo and Player.PlayerData.charinfo.firstname and Player.PlayerData.charinfo.lastname then
            cachedNames[identifier] = {
                firstname = Player.PlayerData.charinfo.firstname,
                lastname = Player.PlayerData.charinfo.lastname
            }
        else
            local Info = exports.oxmysql:executeSync("SELECT * FROM players WHERE citizenid = @citizenid", {
                ["@citizenid"] = identifier
            })

            if Info[1] then
                local data = json.decode(Info[1].charinfo)
                if data and data.firstname and data.lastname then
                    cachedNames[identifier] = {
                        firstname = data.firstname,
                        lastname = data.lastname
                    }
                end
            end
        end
    end

    return cachedNames[identifier] or {
        firstname = "Not",
        lastname = "Found"
    }
end


function getGender(identifier, Player)
    if not identifier then
        return 0
    end

    if playerCache.gender[identifier] ~= nil then
        return playerCache.gender[identifier]
    end

    if frameworkName == "esx" then
        local Info = exports.oxmysql:executeSync("SELECT sex FROM users WHERE identifier = @identifier", {["@identifier"] = identifier})
        if Info[1] and Info[1].sex ~= nil then
            local result = (Info[1].sex == "m" or Info[1].sex == 0) and 0 or 1
            playerCache.gender[identifier] = result
            return result
        end
    else
        if Player and Player.PlayerData.charinfo.gender ~= nil then
            local result = Player.PlayerData.charinfo.gender == 0 and 0 or 1
            playerCache.gender[identifier] = result
            return result
        end
    end

    return 0
end

function getNationality(identifier, Player)
    if not identifier then
        return false
    end

    if playerCache.nationality[identifier] then
        return playerCache.nationality[identifier]
    end

    local result = false
    if frameworkName == "esx" then
        result = false
    else
        if Player then
            result = Player.PlayerData.charinfo.nationality
        else
            result = false
        end
    end

    playerCache.nationality[identifier] = result
    return result
end

function getDob(identifier, Player)
    if not identifier then
        return nil
    end

    if playerCache.dob[identifier] then
        return playerCache.dob[identifier]
    end

    local result = nil
    if frameworkName == "esx" then
        local Info = exports.oxmysql:executeSync("SELECT dateofbirth FROM users WHERE identifier = ?", {identifier})
        result = Info[1] and Info[1].dateofbirth or "Not Found"
    else
        if Player then
            result = Player.PlayerData.charinfo.birthdate
        else
            result = nil
        end
    end

    if result and result ~= "Not Found" then
        playerCache.dob[identifier] = result
    end
    return result
end

function getJob(Player)
    if frameworkName == "esx" then
        local job = Player.getJob()
        return job
    else
        local job = Player.PlayerData.job
        return job
    end
end

local permissionGroups = { "god", "superadmin", "admin", "mod" }

function getPermission(Player)
    if frameworkName == "esx" then
        local group = Player.getGroup()
        return group
    end

    local permission = Player.PlayerData and Player.PlayerData.permission
    if permission and permission ~= "user" then
        return permission
    end

    local src = Player.PlayerData and Player.PlayerData.source or Player.source
    if not src then
        return "user"
    end

    local hasPermission = Framework.Functions and Framework.Functions.HasPermission

    for i = 1, #permissionGroups do
        local group = permissionGroups[i]

        if hasPermission and hasPermission(src, group) then
            return group
        end

        if IsPlayerAceAllowed(src, "group." .. group) then
            return group
        end
    end

    if IsPlayerAceAllowed(src, "command") then
        return "admin"
    end

    return "user"
end

function getJobs()
    if frameworkName == "esx" then
        local jobs = Framework.GetJobs()
        return jobs
    else
        local jobs = Framework.Shared.Jobs
        return jobs
    end
end

function getVehicles(identifier)
    if identifier then
        if frameworkName == "esx" then
            local Info = exports.oxmysql:executeSync("SELECT * FROM owned_vehicles WHERE identifier = @identifier", {["@identifier"] = identifier})
            return Info
        else
            local Info = exports.oxmysql:executeSync("SELECT * FROM player_vehicles WHERE citizenid = @citizenid", {["@citizenid"] = identifier})
            return Info
        end
    else
        return "Not Found"
    end
end

function getAllPlayers()
    local players = {}

    if frameworkName == "esx" then
		local xPlayers = Framework.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = Framework.GetPlayerFromId(xPlayers[i])
			table.insert(players, xPlayer.source)
		end
	else
		local xPlayers = Framework.Functions.GetPlayers()
		for i=1, #xPlayers, 1 do
			local xPlayer = Framework.Functions.GetPlayer(xPlayers[i])
            table.insert(players, xPlayer.PlayerData.source)
		end
	end

    return players
end