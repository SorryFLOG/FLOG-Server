local fn = {}

function fn:keytoindex(tbl)
    local nt = {}
    for k in pairs(tbl) do
        nt[#nt + 1] = k
    end
    return nt
end

function fn:countJobs(jobs)
    return #self:keytoindex(jobs)
end

return fn
