local Query = {}
local config = lib.load("shared/config")

function Query:init()
    local response = MySQL.query.await('SHOW TABLES LIKE "cu_multijob"')
    if response and #response == 0 then
        MySQL.query.await("CREATE TABLE cu_multijob (id VARCHAR(255) PRIMARY KEY, jobs LONGTEXT)", {})
    end
end

local function defaultJobs()
    return {
        [config.defaultJob.name] = {
            label = config.defaultJob.label,
            grade = config.defaultJob.grade,
            gradeLabel = config.defaultJob.gradeLabel,
        },
    }
end

function Query:loadJobs(source)
    local id = FW:GetIdentifier(source)
    local key = tostring(source)
    if not Jobs[key] then Jobs[key] = {} end
    local response = MySQL.query.await("SELECT jobs FROM cu_multijob WHERE id = ?", { id })
    if response and #response == 0 then
        self:createPlayer(id)
        Jobs[key] = defaultJobs()
        return
    end
    if response and #response == 1 then
        local row = response[1]
        local jobs = json.decode(row.jobs or "") or defaultJobs()
        Jobs[key] = jobs
    end
end

function Query:createPlayer(id)
    MySQL.insert.await("INSERT INTO cu_multijob (id, jobs) VALUES (?, ?)", {
        id,
        json.encode(defaultJobs()),
    })
end

function Query:saveJobs(source)
    local id = FW:GetIdentifier(source)
    local key = tostring(source)
    if not id then return end
    MySQL.update.await("UPDATE cu_multijob SET jobs = ? WHERE id = ?", {
        json.encode(Jobs[key] or {}),
        id,
    })
end

return Query
