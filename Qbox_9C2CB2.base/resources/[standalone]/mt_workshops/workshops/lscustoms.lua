-- This config is made to work with the Kiiya's Los Santos Customs MLO
-- Check: https://kiiya.tebex.io/package/6126959

local workshopConfig = {
    enabled = true,
    label = 'Los Santos Customs',
    job = 'mechanic',
    blip = { enabled = true, coords = vec3(-354.76, -124.52, 38.78), color = 3, scale = 0.8, display = 4, sprite = 402 },
    zone = {
        points = {
            vec3(-358.57, -188.13, 37.60),
            vec3(-304.96, -169.26, 37.60),
            vec3(-286.09, -98.81, 37.60),
            vec3(-399.41, -56.21, 37.60),
            vec3(-419.7, -79.0, 37.60),
            vec3(-335.91, -136.79, 38.01)
        },
        thickness = 15
    },
    managements = {
        { coords = vec3(-325.2, -130.6, 43.8), radius = 0.45 },
    },
    stashes = {
        { coords = vec4(-340.09, -122.93, 39.05, 67.73), radius = 0.45, slots = 50, weight = 100 },
    },
    crafts = {
       
    },
    shops = {
        { coords = vec4(-344.88, -140.42, 39.05, 236.81), radius = 0.3, categories = { 'performance', 'others' } },
    },
    registers = {
        { coords = vec3(-350.6, -138.95, 39.45), radius = 0.3, comission = 10, playersRadius = 5.0 },
    },
    mission = {
        { coords = vec3(-323.4, -128.95, 39.25), radius = 0.2, minPayment = 100, maxPayment = 500, cooldown = 10 }
    },
    garage = {
        {
            coords = vec4(-353.94, -114.54, 37.7, 70.38+180),
            spawnCoords = vec4(-358.3, -113.85, 38.7, 136.86),
            vehicles = {
                { icon = 'fas fa-truck', label = 'Flatbed', id = 'flatbed' },
                { icon = 'fas fa-truck', label = 'Tow truck', id = 'towtruck' },
            },
        },
    },
}

AddWorkshop(workshopConfig)