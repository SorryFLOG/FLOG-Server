local QBCore = exports['qb-core']:GetCoreObject()

function Notify(player, message, type, duration)
    if duration == nil then
        duration = 3000
    end

    if Config.Settings.Notify == 'ft_notification' then
        TriggerClientEvent('ft_notification:ShowNotify', player, message, type, duration)
    elseif Config.Settings.Notify == 'qb-core' then
        TriggerClientEvent('QBCore:Notify', player, message, type, duration)
    elseif Config.Settings.Notify == 'ox_lib' then
        lib.notify(player, { title = L('notify.title'),  description = message, position = 'top', type, showDuration = duration })
    end
end


function IsPlayerAdmin(source, cb)
    local playerIdentifiers = GetPlayerIdentifiers(source)
    local discordId, licenseId = nil, nil

    for _, identifier in ipairs(playerIdentifiers) do
        if string.find(identifier, "discord:") then
            discordId = identifier:gsub("discord:", "")
        elseif string.find(identifier, "license:") then
            licenseId = identifier:gsub("license:", "")
        end
    end

    for _, adminId in ipairs(Config.Admins or {}) do
        if adminId == licenseId or adminId == discordId then
            local perms = {
                superadmin = true
            }
            cb(true, perms)
            return
        end
    end

    if not licenseId then
        cb(false, nil)
        return
    end

    local result = Query('SELECT permissions FROM ft_qb_admins WHERE license = ? LIMIT 1', { licenseId })

    if result and result[1] and result[1].permissions then
        local ok, perms = pcall(function()
            return json.decode(result[1].permissions)
        end)

        if ok and perms then
            cb(true, perms)
            return
        else
            cb(false, nil)
            return
        end
    else
        cb(false, nil)
    end
end

-- Reports Action

RegisterServerEvent("ft_qb_adminmenu:handleReportAction")
AddEventHandler("ft_qb_adminmenu:handleReportAction", function(data)
    local src = source
    local action = data.action
    local license = data.license
    local reportId = data.reportId

    local function GetPlayerByLicense(license)
        for _, playerId in pairs(QBCore.Functions.GetPlayers()) do
            local player = QBCore.Functions.GetPlayer(playerId)
            if player and player.PlayerData.license then
                local playerLicense = player.PlayerData.license
                playerLicense = playerLicense:gsub("^license:", "")
                if playerLicense == license then
                    return playerId
                end
            end
        end
        return nil
    end

    local target = GetPlayerByLicense(license)

    if action == 'goto' and target then
        local ped = GetPlayerPed(target)
        local coords = GetEntityCoords(ped)
        TriggerClientEvent("ft_qb_adminmenu:teleportToCoords", src, coords.x, coords.y, coords.z)

    elseif action == 'bring' and target then
        local ped = GetPlayerPed(src)
        local coords = GetEntityCoords(ped)
        TriggerClientEvent("ft_qb_adminmenu:teleportToCoords", target, coords.x, coords.y, coords.z)

    elseif action == 'conclude' then
        Query("DELETE FROM ft_qb_admin_reports WHERE id = ?", {reportId})
    end
end)
-- end