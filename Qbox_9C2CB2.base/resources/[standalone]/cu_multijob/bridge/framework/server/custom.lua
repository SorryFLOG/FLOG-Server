local fn = {}

function fn:GetPlayer(id)
    return nil
end

function fn:GetIdentifier(id)
    return tostring(id)
end

function fn:GetJob(id)
    return { name = "unemployed", label = "Unemployed", grade = 0, gradeLabel = "Unemployed" }
end

function fn:SetJob(id, name, grade)
    print(("cu_multijob: custom bridge SetJob called (%s, %s, %s)"):format(id, name, grade))
end

function fn:GetData(id)
    return { name = GetPlayerName(id) or "Player", lastname = "", group = "user" }
end

return fn
