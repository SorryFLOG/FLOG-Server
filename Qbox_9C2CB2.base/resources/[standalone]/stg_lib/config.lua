Config = {}

Config.Framework = "auto" -- Determines which framework to use: auto, esx, or qb, or qbox

function getFramework()
    if Config.Framework == "esx" then
        return exports['es_extended']:getSharedObject(), "esx"
    elseif Config.Framework == "qb" then
        return exports["qb-core"]:GetCoreObject(), "qb"
    elseif Config.Framework == "qbox" then
        return exports["qb-core"]:GetCoreObject(), "qbx"
    elseif Config.Framework == "auto" then
        if GetResourceState('qbx_core') == 'started' then
            return exports["qb-core"]:GetCoreObject(), "qbx"
        elseif GetResourceState('qb-core') == 'started' then
            return exports["qb-core"]:GetCoreObject(), "qb"
        elseif GetResourceState('es_extended') == 'started' then
            return exports['es_extended']:getSharedObject(), "esx"
        end
    end
end