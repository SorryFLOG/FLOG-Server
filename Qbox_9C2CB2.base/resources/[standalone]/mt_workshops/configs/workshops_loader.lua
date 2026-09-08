Config = Config or {}
Config.workshops = {}

-- This file will be loaded after all workshop files
-- It will collect all the returned workshop configurations and add them to Config.workshops

AddWorkshop = function(workshopConfig)
    if workshopConfig and type(workshopConfig) == 'table' then
        if Config.workshops[workshopConfig.job] then
            print('^3[MT-Workshops]^7 Warning: Workshop with job ' .. workshopConfig.job .. ' already exists')
            return
        end

        Config.workshops[workshopConfig.job] = workshopConfig
    end
end
