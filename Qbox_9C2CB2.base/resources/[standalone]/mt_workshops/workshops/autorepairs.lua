-- This config is made to work with the Kiiya's Auto Repairs MLO
-- Check: https://kiiya.tebex.io/package/6629013

local workshopConfig = {
    enabled = true,
    label = 'Auto Repairs',
    job = 'autorepairs',
    blip = { enabled = true, coords = vec3(1144.52, -773.53, 57.65), color = 6, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(1187.0, 2674.0, 38.0),
            vec3(1162.0, 2676.0, 38.0),
            vec3(1162.0, 2633.0, 38.0),
            vec3(1189.0, 2632.0, 38.0),
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(1165.55, 2649.95, 37.85), radius = 0.25 },
    },
    stashes = {
        { coords = vec3(1175.2, 2635.4, 37.8), radius = 0.8, slots = 50, weight = 100 },
    },
    crafts = {
        { coords = vec3(1178.15, 2635.35, 37.95), radius = 0.4, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(1165.7, 2649.2, 37.9), radius = 0.25, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(1165.65, 2650.4, 37.85), radius = 0.25, prop = 'hei_prop_hei_bank_phone_01', propHeading = 139.31+180, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(1170.13, 2652.93, 36.82, 356.76+180),
            spawnCoords = vec4(1173.56, 2663.89, 37.84, 358.05),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}

AddWorkshop(workshopConfig)