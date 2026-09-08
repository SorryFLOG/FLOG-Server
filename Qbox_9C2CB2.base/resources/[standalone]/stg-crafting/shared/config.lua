Config = {}

Config.Language = 'en' -- en, de, fr, es, pt, it, nl, pl, sv, ar, jp, zh, he, fi, no
Config.CustomNotify = false

Config.Theme = 'blue' -- blue, red, green, purple, orange, pink, yellow, cyan, white, custom (you can customize the 'custom' theme colors in shared/themes/custom.css)

Config.Target = 'auto' -- false = press E (TextUI), true = auto detect, or force one: 'ox_target' / 'qb-target'

Config.MaxQueueSize = 5
Config.RefundOnCancel = true

Config.Creator = {
    command = 'benches',
    allowedGroups = { 'god', 'admin', 'superadmin' },
}

Config.Functions = {}

Config.Functions.Notify = function(type, message, title)
    if Config.CustomNotify then
        lib.notify({ type = type, description = message, title = title })
    else
        TriggerEvent('stg-crafting:internal:notify', type, message, title)
    end
end

Config.Functions.ShowHelpNotify = function(message)
    lib.showTextUI(message, { position = 'left-center', icon = 'hammer' })
end

Config.Functions.HideHelpNotify = function()
    lib.hideTextUI()
end

Config.Benches = {}

Config.LevelSystem = {
    enabled = true,
    xpPerCraft = 10,
    maxLevel = 50,
    Ranks = {
        { level = 1,  label = 'Novice' },
        { level = 5,  label = 'Apprentice' },
        { level = 15, label = 'Journeyman' },
        { level = 30, label = 'Expert' },
        { level = 45, label = 'Master Crafter' },
    },
}