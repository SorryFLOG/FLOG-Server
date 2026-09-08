RegisterCommand('callmedic', function(source)
    print('[AI Medic] /callmedic triggered by source: ' .. source)

    local onlineEMS = 0
    local players = exports.qbx_core:GetQBPlayers()

    for _, player in pairs(players) do
        if player.PlayerData.job.name == 'ambulance'
            or player.PlayerData.job.type == 'ems' then
            onlineEMS = onlineEMS + 1
        end
    end

    print('[AI Medic] Online EMS count: ' .. onlineEMS)

    if onlineEMS > Config.MaxEMSOnline then
        Utils.Notify(source, 'EMS are available, please call them instead.', 'error')
        return
    end

    local ped = GetPlayerPed(source)
    local coords = GetEntityCoords(ped)

    if not coords then
        Utils.Notify(source, 'Error: Could not get your location.', 'error')
        return
    end

    print('[AI Medic] Sending AI medic to player ' .. source)

    TriggerClientEvent('custom_aimedic:revivePlayer', source, coords)
end, false)

RegisterNetEvent('custom_aimedic:chargePlayer')
AddEventHandler('custom_aimedic:chargePlayer', function(target)
    local src = target or source
    print('[AI Medic] Charging player: ' .. src)
    local Player = Utils.GetPlayerFramework(src)
    if Player then
        if Utils.RemoveMoney(Player, Config.Fee) then
            Utils.Notify(src, "You were charged $" .. Config.Fee .. " for EMS service.", "success")
        else
            Utils.Notify(src, "You don't have enough money to pay for EMS!", "error")
        end
    else
        print('[AI Medic] No player framework for source: ' .. src)
        Utils.Notify(src, "EMS fee skipped due to server error.", "error")
    end
end)

-- Custom revive event for standalone mode
RegisterNetEvent('custom_aimedic:revivePlayer')
AddEventHandler('custom_aimedic:revivePlayer', function(target)
    local src = target or source

    print('[AI Medic] Reviving player: ' .. src)

    -- Proper Qbox medical revive
    exports.qbx_medical:Revive(src)

    -- Fully heal injuries and restore health
    exports.qbx_medical:Heal(src)

    print('[AI Medic] Player ' .. src .. ' successfully revived and healed')
end)