FW = {}

local frameworks <const> = { "LEGACYCORE", "es_extended", "qb-core", "qbox", "nd_core", "ox_core" }
local path <const> = "bridge/framework/"

local function isValidFramework(name)
    if name == "custom" then return true end
    for i = 1, #frameworks do
        if frameworks[i] == name then return true end
    end
    return false
end

local function getFw()
    local config = lib.load("shared/config") or {}
    local selected = config.framework

    if selected and selected ~= "auto" then
        if not isValidFramework(selected) then
            print(("cu_multijob: invalid framework in config (%s), falling back to auto"):format(tostring(selected)))
        else
            print(("cu_multijob: framework set in config: %s"):format(selected))
            return (path .. "%s/%s"):format(lib.context, selected)
        end
    end

    for i = 1, #frameworks do
        local f = frameworks[i]
        local state = GetResourceState(f)
        if state == "starting" or state == "started" then
            print(("cu_multijob: framework found: %s"):format(f))
            return (path .. "%s/%s"):format(lib.context, f)
        end
    end
    print("cu_multijob: no supported framework found, using custom bridge")
    return (path .. "%s/%s"):format(lib.context, "custom")
end

local dir = getFw()
FW = lib.load(dir)
