local config = lib.load("shared/config")

local isOpen = false
local function getStrings()
    local locales = config.locales or {}
    if config.locale and locales[config.locale] then
        return locales[config.locale]
    end
    return locales.en or locales.ru or {}
end

local strings = getStrings()

local function buildJobList(jobs)
    local list = {}
    for name, data in pairs(jobs or {}) do
        list[#list + 1] = {
            id = name,
            name = name,
            label = data.label,
            grade = data.grade,
            gradeLabel = data.gradeLabel,
            icon = config.jobIcons[name] or config.defaultIcon,
            color = config.jobColors[name] or config.defaultColor,
        }
    end
    table.sort(list, function(a, b)
        return a.label < b.label
    end)
    return list
end

local function setMenuState(state, jobs, activeJob)
    isOpen = state
    SetNuiFocus(state, state)
    SendNUIMessage({
        action = "setData",
        visible = state,
        jobs = jobs or {},
        activeJob = activeJob,
        strings = strings,
    })
end

local function openMenu()
    if isOpen then return end
    local jobs, activeJob = lib.callback.await("cu_multijob:server:getJobs", false)
    setMenuState(true, buildJobList(jobs), activeJob)
end

local function closeMenu()
    if not isOpen then return end
    setMenuState(false)
end

RegisterNUICallback("close", function(_, cb)
    closeMenu()
    cb({})
end)

RegisterNUICallback("selectJob", function(data, cb)
    if data and data.name then
        TriggerServerEvent("cu_multijob:server:setJob", data.name)
    end
    cb({})
end)

RegisterNUICallback("resignJob", function(data, cb)
    if data and data.name then
        TriggerServerEvent("cu_multijob:server:removeJob", data.name)
    end
    cb({})
end)

RegisterNetEvent("cu_multijob:client:jobRemoved", function()
    if isOpen then
        local jobs, activeJob = lib.callback.await("cu_multijob:server:getJobs", false)
        setMenuState(true, buildJobList(jobs), activeJob)
    end
end)

RegisterCommand(config.command, function()
    if isOpen then
        closeMenu()
    else
        openMenu()
    end
end, false)

RegisterKeyMapping(config.command, strings.keybindLabel or "Open multijob menu", "keyboard", config.keybind)
