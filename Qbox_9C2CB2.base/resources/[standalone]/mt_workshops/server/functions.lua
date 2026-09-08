lib.locale()

---@param plate string
---@return any
isVehicleOwned = function(plate)
    if Config.framework == 'esx' then
        return MySQL.scalar.await('SELECT plate FROM owned_vehicles WHERE plate = ?', { plate })
    else
        return MySQL.scalar.await('SELECT plate FROM player_vehicles WHERE plate = ?', { plate })
    end
    return false
end

---@param vehicle any
---@param mods any
saveVehicleMods = function(vehicle, mods)
    if Config.framework == 'esx' then
        MySQL.update('UPDATE owned_vehicles SET vehicle = ? WHERE plate = ?', { json.encode(mods), mods.plate })
    else
        MySQL.update('UPDATE player_vehicles SET mods = ? WHERE plate = ?', { json.encode(mods), mods.plate })
    end
end

---@param plate string
---@return any
getVehicleDatabaseMods = function(plate)
    if Config.framework == 'esx' then
        return MySQL.scalar.await('SELECT vehicle FROM owned_vehicles WHERE plate = ?', { plate })
    else
        return MySQL.scalar.await('SELECT mods FROM player_vehicles WHERE plate = ?', { plate })
    end
end

---@param account string
---@param amount integer
addAccountMoney = function(account, amount)
    if Config.banking == 'Renewed-Banking' then
        exports['Renewed-Banking']:addAccountMoney(account, amount)
    elseif Config.banking == 'esx_addonaccount' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. account, function(account)
            account.addMoney(amount)
        end)
    else
        exports[Config.banking]:AddMoney(account, amount)
    end
end

isValidItem = function(item)
    local isValidItem = false
    local workshopItems = {
        'body_repair_kit',
        'cosmetics',
        'mechanic_toolbox',
        'neons_controller',
        'mods_list',
        'extras_controller'
    }

    for _, workshopItem in pairs(workshopItems) do
        if workshopItem == item then
            isValidItem = true
            break
        end
    end

    if not isValidItem then
        for _, performance in pairs(Config.performance) do
            if performance.item == item then
                isValidItem = true
                break
            end
        end
    end

    return isValidItem
end

---@param item string
---@return boolean | table
isValidCraftItem = function(item)
    ---@type boolean | table
    local isValidItem = false
    for category, _ in pairs(Config.crafts) do
        for _, craftItem in pairs(Config.crafts[category].items) do
            if craftItem.name == item then
                isValidItem = craftItem.ingredients
                break
            end
        end
    end
    return isValidItem
end

---@param id string
---@param label string
---@param passedItems table
registerShop = function(id, label, passedItems)
    if Config.inventory == 'ox_inventory' then
        exports.ox_inventory:RegisterShop(id, { name = label, slots = #passedItems, inventory = passedItems })
    else
        local items = {}
        for k, v in pairs(passedItems) do
            items[#items + 1] = { name = v.name, price = tonumber(v.price), amount = tonumber(v.count), info = {}, slot = k }
        end
        exports[Config.inventory]:CreateShop({ name = id, label = label, slots = #items, items = items })
    end
end

registerStash = function(id, label, slots, weight)
    if Config.inventory == 'ox_inventory' then
        exports.ox_inventory:RegisterStash(id, label, slots, (weight * 1000))
    else
        exports[Config.inventory]:CreateInventory(id, {
            label = label,
            maxweight = (weight * 1000),
            slots = slots
        })
    end
end

registerCraft = function(id, label, items)
    if Config.inventory == 'ox_inventory' then
        exports.ox_inventory:RegisterCraftStation(id, { name = label, items = items })
    end
end

---@param coords vector3
---@param distance number
---@return table
getPlayersNearCoords = function(coords, distance)
    local nearbyPlayers = {}
    distance = distance or 150.0
    local allPlayerIds = {}

    if Config.framework == 'qb' or Config.framework == 'qbx' then
        local players = Config.framework == 'qb' and Config.core.Functions.GetQBPlayers() or exports.qbx_core:GetQBPlayers()
        for _, player in pairs(players) do
            if player then
                allPlayerIds[#allPlayerIds + 1] = player.PlayerData.source
            end
        end
    elseif Config.framework == 'esx' then
        for _, playerId in pairs(GetPlayers()) do
            local src = tonumber(playerId)
            if src then
                allPlayerIds[#allPlayerIds + 1] = src
            end
        end
    end

    local coordsX = type(coords) == 'table' and (coords.x or coords[1]) or 0
    local coordsY = type(coords) == 'table' and (coords.y or coords[2]) or 0
    local coordsZ = type(coords) == 'table' and (coords.z or coords[3]) or 0

    for _, playerId in pairs(allPlayerIds) do
        local success, playerCoords = pcall(function()
            local ped = GetPlayerPed(playerId)
            if ped and ped > 0 then
                return GetEntityCoords(ped)
            end
            return nil
        end)

        if success and playerCoords then
            local playerX = type(playerCoords) == 'table' and (playerCoords.x or playerCoords[1]) or 0
            local playerY = type(playerCoords) == 'table' and (playerCoords.y or playerCoords[2]) or 0
            local playerZ = type(playerCoords) == 'table' and (playerCoords.z or playerCoords[3]) or 0
            local dx = playerX - coordsX
            local dy = playerY - coordsY
            local dz = playerZ - coordsZ
            local dist = math.sqrt(dx * dx + dy * dy + dz * dz)

            if dist <= distance then
                nearbyPlayers[#nearbyPlayers + 1] = playerId
            end
        end
    end

    return nearbyPlayers
end

if Config.inventory ~= 'qb-inventory-old' then
    for k, v in pairs(Config.workshops) do
        if v.enabled then
            if v.shops then
                for sk, sv in pairs(v.shops) do
                    for _, cv in pairs(sv.categories) do
                        registerShop(("shop_%s_%s_%s"):format(k, sk, cv), locale("shop_label", Config.shops[cv].categoryLabel), Config.shops[cv].items)
                    end
                end
            end

            if v.stashes then
                for stashId, stash in pairs(v.stashes) do
                    registerStash(("stash_%s_%s"):format(k, stashId), locale("stash_label", stash.label), stash.slots, stash.weight)
                end
            end

            if v.crafts and Config.inventory == 'ox_inventory' and Config.useOxInventoryCraft then
                for craftId, craft in pairs(v.crafts) do
                    for _, ccv in pairs(craft.categories) do
                        registerCraft(("craft_%s_%s_%s"):format(k, craftId, ccv), locale("craft_label", craft.label), Config.crafts[ccv].items)
                    end
                end
            end
        end
    end
end
