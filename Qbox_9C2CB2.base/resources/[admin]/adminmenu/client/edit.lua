local QBCore = exports['qb-core']:GetCoreObject()

function Notify(message, type, duration)
    if duration == nil then
        duration = 3000
    end

    if Config.Settings.Notify == 'ft_notification' then
        exports.ft_notification:ShowNotify(message, type, duration)
    elseif Config.Settings.Notify == 'qb-core' then
        QBCore.Functions.Notify(message, type, duration)
    elseif Config.Settings.Notify == 'ox_lib' then
        lib.notify({ title = L('notify.title'), description = message, position = 'top', type = type, showDuration = duration })
    end
end

RegisterNetEvent("ft_qb_adminmenu:applyHeal", function()
    local ped = PlayerPedId()
    SetEntityHealth(ped, GetEntityMaxHealth(ped))
    ClearPedBloodDamage(ped)
    ResetPedVisibleDamage(ped)
    ClearPedLastWeaponDamage(ped)
    Notify(L('notify.healed'), 'success')
end)

RegisterNetEvent("ft_qb_adminmenu:doSelfRevive", function()
    TriggerServerEvent("txsv:req:healMyself")
    Notify(L('notify.revived'), 'success')
end)

-- Reports Action
RegisterNetEvent("ft_qb_adminmenu:teleportToCoords")
AddEventHandler("ft_qb_adminmenu:teleportToCoords", function(x, y, z)
    local ped = PlayerPedId()
    SetEntityCoords(ped, x, y, z, false, false, false, true)
end)
-- end

RegisterNetEvent('ft_qb_adminmenu:TeleportToPlayerCoords', function(coords)
    local ped = PlayerPedId()
    SetEntityCoords(ped, coords.x, coords.y, coords.z + 1.0, false, false, false, true)
end)

function GiveVehicleKey(vehicle, plate)
    TriggerEvent("vehiclekeys:client:SetOwner", plate)
end