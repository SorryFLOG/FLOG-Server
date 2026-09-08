return {
    maxStatusValues = {
        engine = 1000.0,
        body = 1000.0,
        radiator = 100,
        axle = 100,
        brakes = 100,
        clutch = 100,
        fuel = 100,
    },
    repairCost = {
        body = 'plastic',
        radiator = 'plastic',
        axle = 'steel',
        brakes = 'iron',
        clutch = 'aluminum',
        fuel = 'plastic',
    },
    repairCostAmount = {
        engine = {
            item = 'metalscrap',
            costs = 2,
        },
        body = {
            item = 'plastic',
            costs = 3,
        },
        radiator = {
            item = 'steel',
            costs = 5,
        },
        axle = {
            item = 'aluminum',
            costs = 7,
        },
        brakes = {
            item = 'copper',
            costs = 5,
        },
        clutch = {
            item = 'copper',
            costs = 6,
        },
        fuel = {
            item = 'plastic',
            costs = 5,
        },
    },
    plates = {
        {
            coords = vec4(2528.08, 4114.99, 37.62, 71.82),
            boxData = {
                heading = 340,
                length = 5,
                width = 2.5,
                debugPoly = false
            },
            AttachedVehicle = nil,
        },
        {
            coords = vec4(-327.91, -144.34, 38.86, 70.34),
            boxData = {
                heading = 249,
                length = 6.5,
                width = 5,
                debugPoly = false
            },
            AttachedVehicle = nil,
        },
    },
    locations = {
        exit = vec3(2520.29, 4124.9, 37.63),
        duty = vec3(2527.4, 4119.68, 37.92),
        stash = vec3(2521.43, 4119.38, 37.92),
        vehicle = vec4(2515.41, 4122.05, 37.53, 260.92),
    }
}