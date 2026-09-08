return {
    framework = "qbox",

    maxJobs = 5,

    allowedGroups = {
        ["admin"] = true,
        ["mod"] = true,
    },

    defaultJob = {
        name = "unemployed",
        label = "Civilian",
        grade = 0,
        gradeLabel = "Freelancer",
    },

    command = "multijob",
    keybind = "j",
    locale = "en",

    locales = {
        en = {
            title = "Job Selection",
            hintClose = "Close",
            hintSelect = "Select",
            hintResign = "Resign",
            keyClose = "ESC",
            keySelect = "ENTER",
            keyResign = "RMB",
            keybindLabel = "Open Multijob Menu",
        },
    },

    jobIcons = {
        unemployed = "User",

        police = "Shield",
        bcso = "Shield",
        sasp = "Shield",

        ambulance = "Stethoscope",

        judge = "Scale",
        lawyer = "Briefcase",

        realestate = "House",

        taxi = "Car",
        bus = "Bus",
        trucker = "Truck",

        cardealer = "Car",

        mechanic = "Wrench",
        tow = "Truck",

        reporter = "Newspaper",

        garbage = "Trash2",
        vineyard = "Grape",
        hotdog = "Utensils",
    },

    jobColors = {
        unemployed = "#9ca3af",

        police = "#3b82f6",
        bcso = "#2563eb",
        sasp = "#60a5fa",

        ambulance = "#ef4444",

        judge = "#a855f7",
        lawyer = "#8b5cf6",

        realestate = "#14b8a6",

        taxi = "#fbbf24",
        bus = "#f59e0b",
        trucker = "#d97706",

        cardealer = "#06b6d4",

        mechanic = "#f97316",
        tow = "#ea580c",

        reporter = "#ec4899",

        garbage = "#84cc16",
        vineyard = "#22c55e",
        hotdog = "#ef4444",
    },

    defaultIcon = "Briefcase",
    defaultColor = "#94a3b8",
}