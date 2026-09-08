Target = {}

local function resolveSystem()
    if Config.Target == false or Config.Target == nil or Config.Target == 'false' then
        return false
    end
    if Config.Target == true or Config.Target == 'auto' or Config.Target == 'true' then
        if GetResourceState('ox_target') == 'started' then return 'ox_target' end
        if GetResourceState('qb-target') == 'started' then return 'qb-target' end
        return false
    end
    if Config.Target == 'ox_target' and GetResourceState('ox_target') == 'started' then
        return 'ox_target'
    end
    if Config.Target == 'qb-target' and GetResourceState('qb-target') == 'started' then
        return 'qb-target'
    end
    return false
end

Target.system = resolveSystem()
Target.enabled = Target.system ~= false

local function buildOxOptions(options)
    local out = {}
    for i, opt in ipairs(options) do
        out[i] = {
            name = opt.name,
            icon = opt.icon or 'fas fa-hammer',
            label = opt.label or 'Interact',
            distance = opt.distance or 2.0,
            onSelect = opt.action and function(data)
                opt.action(data and data.entity or nil)
            end or nil,
            canInteract = opt.canInteract,
            groups = opt.groups,
            items = opt.items,
        }
    end
    return out
end

local function buildQbOptions(options)
    local out = {}
    for i, opt in ipairs(options) do
        out[i] = {
            icon = opt.icon or 'fas fa-hammer',
            label = opt.label or 'Interact',
            action = opt.action and function(entity)
                opt.action(entity)
            end or nil,
            canInteract = opt.canInteract,
            job = opt.job,
            gang = opt.gang,
            item = opt.items,
        }
    end
    return out
end

function Target.addEntity(entity, options)
    if not Target.enabled then return end
    if not entity or entity == 0 or not DoesEntityExist(entity) then return end

    if Target.system == 'ox_target' then
        exports.ox_target:addLocalEntity(entity, buildOxOptions(options))
    elseif Target.system == 'qb-target' then
        exports['qb-target']:AddTargetEntity(entity, {
            options = buildQbOptions(options),
            distance = options[1] and options[1].distance or 2.0,
        })
    end
end

function Target.removeEntity(entity, names)
    if not Target.enabled then return end
    if not entity or entity == 0 then return end

    if Target.system == 'ox_target' then
        exports.ox_target:removeLocalEntity(entity, names)
    elseif Target.system == 'qb-target' then
        exports['qb-target']:RemoveTargetEntity(entity, names)
    end
end

function Target.addBoxZone(id, coords, size, heading, options)
    if not Target.enabled then return end
    if not coords or not size then return end

    if Target.system == 'ox_target' then
        return exports.ox_target:addBoxZone({
            name = id,
            coords = coords,
            size = size,
            rotation = heading or 0.0,
            debug = false,
            options = buildOxOptions(options),
        })
    elseif Target.system == 'qb-target' then
        exports['qb-target']:AddBoxZone(id, coords, size.x, size.y, {
            name = id,
            heading = heading or 0.0,
            debugPoly = false,
            minZ = coords.z - (size.z / 2.0),
            maxZ = coords.z + (size.z / 2.0),
        }, {
            options = buildQbOptions(options),
            distance = options[1] and options[1].distance or 2.0,
        })
        return id
    end
end

function Target.removeBoxZone(id)
    if not Target.enabled or not id then return end

    if Target.system == 'ox_target' then
        exports.ox_target:removeZone(id)
    elseif Target.system == 'qb-target' then
        exports['qb-target']:RemoveZone(id)
    end
end