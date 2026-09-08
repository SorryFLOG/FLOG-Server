local config = require 'config.client'
local sharedConfig = require 'config.shared'

local currentZones = {}
local currentLocation = {}
local currentBlip = 0
local hasBox = false
local truckVehBlip = 0
local truckerBlip = 0
local returningToStation = false
local currentPlate
local currentTrailer

-- Functions

local function returnToStation()
    if DoesBlipExist(truckVehBlip) then
        SetBlipRoute(truckVehBlip, true)
    end

    returningToStation = true
end

local function isTruckerVehicle(vehicle)
    if not vehicle or vehicle == 0 then return false end
    return config.vehicles[GetEntityModel(vehicle)] ~= nil
end

local function getTrailer()
    if not currentTrailer then return 0 end

    local trailer = NetToVeh(currentTrailer)

    if not DoesEntityExist(trailer) then
        return 0
    end

    return trailer
end

local function removeElements()
    ClearAllBlipRoutes()

    if DoesBlipExist(truckVehBlip) then
        RemoveBlip(truckVehBlip)
        truckVehBlip = 0
    end

    if DoesBlipExist(truckerBlip) then
        RemoveBlip(truckerBlip)
        truckerBlip = 0
    end

    if DoesBlipExist(currentBlip) then
        RemoveBlip(currentBlip)
        currentBlip = 0
    end

    for _, zone in ipairs(currentZones) do
        zone:remove()
    end

    currentZones = {}
end

local function getPaid()
    TriggerServerEvent('qbx_truckerjob:server:getPaid')

    if DoesBlipExist(currentBlip) then
        RemoveBlip(currentBlip)
        ClearAllBlipRoutes()
        currentBlip = 0
    end
end

local function returnVehicle()
    if cache.seat ~= -1 then
        return exports.qbx_core:Notify(locale('error.no_driver'), 'error')
    end

    if not isTruckerVehicle(cache.vehicle) then
        return exports.qbx_core:Notify(
            locale('error.vehicle_not_correct'),
            'error'
        )
    end

    local truck = cache.vehicle

    -- Delete trailer first
    local trailer = getTrailer()

    if trailer ~= 0 then
        DeleteVehicle(trailer)
    end

    currentTrailer = nil

    -- Delete tractor
    DeleteVehicle(truck)

    TriggerServerEvent('qbx_truckerjob:server:returnVehicle')

    if DoesBlipExist(currentBlip) then
        RemoveBlip(currentBlip)
        ClearAllBlipRoutes()
        currentBlip = 0
    end

    if not returningToStation and not next(currentLocation) then
        return
    end

    ClearAllBlipRoutes()
    returningToStation = false
    currentLocation = {}

    exports.qbx_core:Notify(
        locale('mission.job_completed'),
        'success'
    )
end

local function openMenuGarage()
    local truckMenu = {}

    for model, label in pairs(config.vehicles) do
        truckMenu[#truckMenu + 1] = {
            title = label,
            description = 'Rent this tractor unit',
            icon = 'truck',
            serverEvent = 'qbx_truckerjob:server:doBail',
            args = model
        }
    end

    table.sort(truckMenu, function(a, b)
        return a.title < b.title
    end)

    lib.registerContext({
        id = 'trucker_veh_menu',
        title = 'Choose Your Tractor',
        options = truckMenu
    })

    lib.showContext('trucker_veh_menu')
end

-- Third-eye depot

local function createMainTarget()
    local location = sharedConfig.locations.main

    currentZones[#currentZones + 1] = exports.ox_target:addBoxZone({
        coords = location.coords,
        size = location.size,
        rotation = location.rotation,
        debug = location.debug,

        options = {
            {
                name = 'trucker_start_job',

                onSelect = function()
                    if cache.vehicle then
                        return exports.qbx_core:Notify(
                            locale('error.get_out_vehicle'),
                            'error'
                        )
                    end

                    openMenuGarage()
                end,

                icon = 'fa-solid fa-truck',
                label = 'Start Trucking Job',
                distance = 2.0,

                canInteract = function()
                    return QBX.PlayerData.job.name == 'trucker'
                end
            }
        }
    })
end

-- Separate paycheck target

local function createPaycheckTarget()
    local paycheckCoords = vec3(1209.47, -3114.75, 5.58)

    currentZones[#currentZones + 1] = exports.ox_target:addBoxZone({
        coords = paycheckCoords,
        size = vec3(2.0, 2.0, 2.0),
        rotation = 0.0,
        debug = false,

        options = {
            {
                name = 'trucker_collect_paycheck',

                onSelect = function()
                    getPaid()
                end,

                icon = 'fa-solid fa-money-bill',
                label = 'Collect Paycheck',
                distance = 2.0,

                canInteract = function()
                    return QBX.PlayerData.job.name == 'trucker'
                end
            }
        }
    })
end

-- Non-target depot zone

local function createMainZone()
    local location = sharedConfig.locations.main

    local zone = lib.zones.sphere({
        coords = location.coords,
        radius = location.markerRadius,
        debug = location.debug
    })

    local innerZone = lib.zones.sphere({
        coords = location.coords,
        radius = location.interactionsRadius,
        debug = location.debug
    })

    local marker = lib.marker.new({
        coords = location.coords,
        type = location.markerType,
        height = 0.2,
        width = 0.3
    })

    function zone:inside()
        marker:draw()
    end

    function innerZone:onEnter()
        if not lib.isTextUIOpen() then
            lib.showTextUI('Press [E] to start trucking job')
        end
    end

    function innerZone:inside()
        if IsControlJustPressed(0, 38) then
            if cache.vehicle then
                exports.qbx_core:Notify(
                    locale('error.get_out_vehicle'),
                    'error'
                )
                return
            end

            openMenuGarage()

            lib.hideTextUI()
        end
    end

    function innerZone:onExit()
        if lib.isTextUIOpen() then
            lib.hideTextUI()
        end
    end

    currentZones[#currentZones + 1] = zone
    currentZones[#currentZones + 1] = innerZone
end

local createMain = config.useTarget
    and createMainTarget
    or createMainZone

-- Vehicle storage / return area

local function createVehicleZone()
    local location = sharedConfig.locations.vehicle

    local zone = lib.zones.sphere({
        coords = location.coords,
        radius = location.markerRadius,
        debug = location.debug
    })

    local innerZone = lib.zones.sphere({
        coords = location.coords,
        radius = location.interactionsRadius,
        debug = location.debug
    })

    local marker = lib.marker.new({
        coords = location.coords,
        type = location.markerType,
        height = 0.2,
        width = 0.3
    })

    local function hideTextUI()
        local isOpen, currentText = lib.isTextUIOpen()

        if isOpen and (
            currentText == locale('info.store_vehicle')
            or currentText == locale('info.vehicles')
        ) then
            lib.hideTextUI()
        end
    end

    function zone:inside()
        marker:draw()
    end

    function innerZone:onEnter()
        if not lib.isTextUIOpen() then
            lib.showTextUI(
                locale(
                    cache.vehicle
                    and 'info.store_vehicle'
                    or 'info.vehicles'
                )
            )
        end
    end

    local isChangeTextAllowed = false

    function innerZone:inside()

        if isChangeTextAllowed then
            local _, currentText = lib.isTextUIOpen()

            local expectedText = locale(
                cache.vehicle
                and 'info.store_vehicle'
                or 'info.vehicles'
            )

            if currentText ~= expectedText
                and not lib.getOpenContextMenu()
            then
                isChangeTextAllowed = false

                CreateThread(function()
                    Wait(1000)

                    lib.showTextUI(
                        locale(
                            cache.vehicle
                            and 'info.store_vehicle'
                            or 'info.vehicles'
                        )
                    )
                end)
            end
        end

        if IsControlJustPressed(0, 38) then

            if cache.vehicle then
                returnVehicle()
            else
                openMenuGarage()
            end

            hideTextUI()
            isChangeTextAllowed = true
        end
    end

    function innerZone:onExit()
        hideTextUI()
    end

    currentZones[#currentZones + 1] = zone
    currentZones[#currentZones + 1] = innerZone
end

-- Trailer loading

local function getTrailerRearPosition(trailer)
    if trailer == 0 or not DoesEntityExist(trailer) then
        return nil
    end

    local minDim, maxDim = GetModelDimensions(
        GetEntityModel(trailer)
    )

    -- Trailer rear is the negative Y side
    local rearOffset = minDim.y - 0.75

    return GetOffsetFromEntityInWorldCoords(
        trailer,
        0.0,
        rearOffset,
        0.0
    )
end

local function openTrailerDoors(trailer)
    if trailer == 0 or not DoesEntityExist(trailer) then
        return
    end

    -- Open the common rear trailer doors
    SetVehicleDoorOpen(trailer, 2, false, false)
    SetVehicleDoorOpen(trailer, 3, false, false)
end

local function getInTrunk()
    if cache.vehicle then
        return exports.qbx_core:Notify(
            locale('error.get_out_vehicle'),
            'error'
        )
    end

    local trailer = getTrailer()

    if trailer == 0 then
        return exports.qbx_core:Notify(
            'Your trailer could not be found.',
            'error'
        )
    end

    local pedCoords = GetEntityCoords(cache.ped)

    local trailerRear = getTrailerRearPosition(trailer)

    if not trailerRear then
        return exports.qbx_core:Notify(
            'Could not find the trailer loading area.',
            'error'
        )
    end

    local distance = #(pedCoords - trailerRear)

    if distance > 2.5 then
        return exports.qbx_core:Notify(
            'Move to the rear of your trailer.',
            'error'
        )
    end

    openTrailerDoors(trailer)

    if lib.progressCircle({
        duration = 2000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,

        disable = {
            car = true,
            mouse = false,
            combat = true,
            move = true,
        },

        anim = {
            dict = 'anim@gangops@facility@servers@',
            clip = 'hotwire'
        },
    }) then

        exports.scully_emotemenu:playEmoteByCommand('box')

        hasBox = true

        exports.qbx_core:Notify(
            locale('info.deliver_to_store'),
            'info'
        )

    else

        exports.qbx_core:Notify(
            locale('error.cancelled'),
            'error'
        )
    end
end

local function deliver()

    if lib.progressCircle({
        duration = 3000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = true,

        disable = {
            car = true,
            mouse = false,
            combat = true,
            move = true,
        },

        anim = {
            dict = 'anim@gangops@facility@servers@',
            clip = 'hotwire'
        },
    }) then

        exports.scully_emotemenu:cancelEmote()
        ClearPedTasks(cache.ped)

        hasBox = false

        currentLocation.currentCount += 1

        lib.print.debug(
            'count:',
            currentLocation.currentCount,
            '/',
            currentLocation.dropCount
        )

        if currentLocation.currentCount ==
            currentLocation.dropCount
        then

            if DoesBlipExist(currentBlip) then
                RemoveBlip(currentBlip)
                ClearAllBlipRoutes()
                currentBlip = 0
            end

            currentLocation.zoneCombo:remove()
            currentLocation = {}

            return true

        else

            exports.qbx_core:Notify(
                locale('mission.another_box'),
                'info'
            )
        end

    else

        ClearPedTasks(cache.ped)
        exports.scully_emotemenu:cancelEmote()

        exports.qbx_core:Notify(
            locale('error.cancelled'),
            'error'
        )
    end
end

local function getNewLocation(locationIndex, drop)

    local location =
        sharedConfig.locations.stores[locationIndex]

    currentLocation = {
        dropCount = drop,
        currentCount = 0
    }

    local marker = lib.marker.new({
        coords = location.coords,
        type = location.markerType or 2,
        height = 0.2,
        width = 0.3
    })

    currentLocation.zoneCombo = lib.zones.box({
        name = location.label,
        coords = location.coords,
        size = location.size,
        rotation = location.rotation,
        debug = location.debug,

        onEnter = function()
            exports.qbx_core:Notify(
                locale('mission.store_reached'),
                'info'
            )
        end,

        inside = function()

            marker:draw()

            if IsControlJustReleased(0, 38) then

                if cache.vehicle then

                    return exports.qbx_core:Notify(
                        locale('error.get_out_vehicle'),
                        'error'
                    )

                elseif not hasBox then

                    getInTrunk()

                elseif #(GetEntityCoords(cache.ped) - location.coords) < 5 then

                    if deliver() then

                        local newLocation, newDrop =
                            lib.callback.await(
                                'qbx_truckerjob:server:getNewTask',
                                false
                            )

                        if not newLocation
                            or QBX.PlayerData.job.name ~= 'trucker'
                        then
                            return

                        elseif newLocation == 0 then

                            exports.qbx_core:Notify(
                                locale('mission.return_to_station'),
                                'info'
                            )

                            returnToStation()

                        else

                            exports.qbx_core:Notify(
                                locale('mission.goto_next_point'),
                                'info'
                            )

                            getNewLocation(
                                newLocation,
                                newDrop
                            )
                        end
                    end

                else

                    exports.qbx_core:Notify(
                        locale('error.too_far_from_delivery'),
                        'error'
                    )
                end
            end
        end,
    })

    currentBlip = AddBlipForCoord(
        location.coords.x,
        location.coords.y,
        location.coords.z
    )

    SetBlipColour(currentBlip, 3)
    SetBlipRoute(currentBlip, true)
    SetBlipRouteColour(currentBlip, 3)
end

local function createElement(location, spriteId)

    local element = AddBlipForCoord(
        location.coords.x,
        location.coords.y,
        location.coords.z
    )

    SetBlipSprite(element, spriteId)
    SetBlipDisplay(element, 4)
    SetBlipScale(element, 0.6)
    SetBlipAsShortRange(element, true)
    SetBlipColour(element, 5)

    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(location.label)
    EndTextCommandSetBlipName(element)

    return element
end

local function createElements()

    if QBX.PlayerData.job.name ~= 'trucker' then
        return
    end

    truckVehBlip =
        createElement(
            sharedConfig.locations.vehicle,
            326
        )

    truckerBlip =
        createElement(
            sharedConfig.locations.main,
            479
        )

    createMain()
    createPaycheckTarget()
    createVehicleZone()
end

-- Events

local function setInitState()

    removeElements()

    currentLocation = {}
    currentBlip = 0
    hasBox = false
    currentPlate = nil
    currentTrailer = nil
    returningToStation = false
end

AddEventHandler('onResourceStart', function(resource)

    if resource ~= GetCurrentResourceName() then
        return
    end

    setInitState()
    createElements()
end)

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()

    setInitState()
    createElements()
end)

RegisterNetEvent('QBCore:Client:OnPlayerUnload', function()

    setInitState()
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function()

    removeElements()

    if next(currentLocation)
        and currentLocation.zoneCombo
    then
        currentLocation.zoneCombo:remove()
    end

    createElements()
end)

-- Tractor + trailer spawn

RegisterNetEvent(
    'qbx_truckerjob:client:spawnVehicle',
    function(veh)
    
        local netId, plate, trailerNetId =
            lib.callback.await(
                'qbx_truckerjob:server:spawnVehicle',
                false,
                veh
            )

        if not netId then
            return
        end

        currentPlate = plate
        currentTrailer = trailerNetId

        local vehicle = NetToVeh(netId)

        if not DoesEntityExist(vehicle) then
            return
        end

        SetVehicleEngineOn(
            vehicle,
            true,
            true,
            false
        )

        -- Wait for trailer to become available
        local trailer = 0

        for i = 1, 50 do

            trailer = getTrailer()

            if trailer ~= 0 then
                break
            end

            Wait(100)
        end

        if trailer == 0 then

            exports.qbx_core:Notify(
                'Trailer failed to spawn.',
                'error'
            )

            return
        end

        -- Attach trailer to selected tractor
        AttachVehicleToTrailer(
            vehicle,
            trailer,
            1.0
        )

        -- Give the game a moment to register the attachment
        Wait(500)

        local location, drop =
            lib.callback.await(
                'qbx_truckerjob:server:getNewTask',
                false,
                true
            )

        if not location then
            return
        end

        getNewLocation(
            location,
            drop
        )
    end
)