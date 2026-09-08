-- This config is made to work with the Kiiya's Tuner Shop MLO
-- Check: https://kiiya.tebex.io/package/5148409

local workshopConfig = {
    enabled = false,
    label = 'Tuner Shop',
    job = 'tunershop',
    blip = { enabled = true, coords = vec3(726.68, -1280.26, 26.28), color = 4, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(714.05, -1260.52, 26.10),
            vec3(712.6, -1313.59, 26.10),
            vec3(783.82, -1314.01, 26.10),
            vec3(784.11, -1257.41, 26.10)
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(761.05, -1298.9, 26.25), radius = 0.5 },
    },
    stashes = {
        { coords = vec3(760.05, -1272.05, 26.8), radius = 0.9, slots = 50, weight = 100 },
    },
    crafts = {
        { coords = vec3(744.5, -1264.7, 27.0), radius = 0.6, categories = { 'performance', 'others' } },
    },
    shops = {
        { coords = vec3(735.75, -1266.3, 26.8), radius = 0.6, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(739.0, -1266.4, 27.3), radius = 0.3, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(757.0, -1293.2, 26.1), radius = 0.2, prop = 'hei_prop_hei_bank_phone_01', propHeading = 139.31+180, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(733.41, -1290.31, 25.29, 89.3+180),
            spawnCoords = vec4(726.33, -1290.74, 26.28, 89.37),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}

AddWorkshop(workshopConfig)