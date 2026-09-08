return {
    -- =========================================================
    -- FOOD & DRINK
    -- =========================================================

    ['testburger'] = {
        label = 'Test Burger',
        weight = 220,
        degrade = 60,
        consume = 0.3,

        client = {
            image = 'burger_chicken.png',
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            export = 'ox_inventory_examples.testburger',
        },

        server = {
            export = 'ox_inventory_examples.testburger',
            test = 'what an amazingly delicious burger, amirite?',
        },

        buttons = {
            {
                label = 'Lick it',
                action = function(slot)
                    print('You licked the burger')
                end,
            },
            {
                label = 'Squeeze it',
                action = function(slot)
                    print('You squeezed the burger :(')
                end,
            },
            {
                label = 'What do you call a vegan burger?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('A misteak.')
                end,
            },
            {
                label = 'What do frogs like to eat with their hamburgers?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print('French flies.')
                end,
            },
            {
                label = 'Why were the burger and fries running?',
                group = 'Hamburger Puns',
                action = function(slot)
                    print("Because they're fast food.")
                end,
            },
        },
    },

    ['burger'] = {
        label = 'Burger',
        weight = 220,

        client = {
            status = { hunger = 200000 },
            anim = 'eating',
            prop = 'burger',
            usetime = 2500,
            notification = 'You ate a delicious burger',
        },
    },

    ['sprunk'] = {
        label = 'Sprunk',
        weight = 350,

        client = {
            status = { thirst = 200000 },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
            },
            prop = {
                model = `prop_ld_can_01`,
                pos = vec3(0.01, 0.01, 0.06),
                rot = vec3(5.0, 5.0, -180.5),
            },
            usetime = 2500,
            notification = 'You quenched your thirst with a Sprunk',
        },
    },

    ['water'] = {
        label = 'Water',
        weight = 500,

        client = {
            status = { thirst = 200000 },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
            },
            prop = {
                model = `prop_ld_flow_bottle`,
                pos = vec3(0.03, 0.03, 0.02),
                rot = vec3(0.0, 0.0, -1.5),
            },
            usetime = 2500,
            cancel = true,
            notification = 'You drank some refreshing water',
        },
    },

    ['mustard'] = {
        label = 'Mustard',
        weight = 500,

        client = {
            status = {
                hunger = 25000,
                thirst = 25000,
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
            },
            prop = {
                model = `prop_food_mustard`,
                pos = vec3(0.01, 0.0, -0.07),
                rot = vec3(1.0, 1.0, -1.5),
            },
            usetime = 2500,
            notification = 'You... drank mustard',
        },
    },

    ['wine'] = {
        label = 'Wine',
        weight = 500,
    },

    ['grape'] = {
        label = 'Grape',
        weight = 10,
    },

    ['grapejuice'] = {
        label = 'Grape Juice',
        weight = 200,
    },

    ['coffee'] = {
        label = 'Coffee',
        weight = 200,
    },

    ['vodka'] = {
        label = 'Vodka',
        weight = 500,
    },

    ['whiskey'] = {
        label = 'Whiskey',
        weight = 200,
    },

    ['beer'] = {
        label = 'Beer',
        weight = 200,
    },

    ['sandwich'] = {
        label = 'Sandwich',
        weight = 200,
    },

    -- =========================================================
    -- MEDICAL
    -- =========================================================

    ['bandage'] = {
        label = 'Bandage',
        weight = 115,
    },

    ['firstaid'] = {
        label = 'First Aid',
        weight = 2500,
    },

    ['ifaks'] = {
        label = 'Individual First Aid Kit',
        weight = 2500,
    },

    ['painkillers'] = {
        label = 'Painkillers',
        weight = 400,
    },

    -- =========================================================
    -- CLOTHING / PERSONAL
    -- =========================================================

    ['parachute'] = {
        label = 'Parachute',
        weight = 8000,
        stack = false,

        client = {
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d',
            },
            usetime = 1500,
        },
    },

    ['paperbag'] = {
        label = 'Paper Bag',
        weight = 1,
        stack = false,
        close = false,
        consume = 0,
    },

    ['panties'] = {
        label = 'Knickers',
        weight = 10,
        consume = 0,

        client = {
            status = {
                thirst = -100000,
                stress = -25000,
            },
            anim = {
                dict = 'mp_player_intdrink',
                clip = 'loop_bottle',
            },
            prop = {
                model = `prop_cs_panties_02`,
                pos = vec3(0.03, 0.0, 0.02),
                rot = vec3(0.0, -13.5, -1.5),
            },
            usetime = 2500,
        },
    },

    ['clothing'] = {
        label = 'Clothing',
        consume = 0,
    },

    -- =========================================================
    -- COMMUNICATION
    -- =========================================================

    ['phone'] = {
        label = 'Phone',
        weight = 190,
        stack = false,
        consume = 0,

        client = {
            add = function(total)
                if total > 0 then
                    pcall(function()
                        return exports.npwd:setPhoneDisabled(false)
                    end)
                end
            end,

            remove = function(total)
                if total < 1 then
                    pcall(function()
                        return exports.npwd:setPhoneDisabled(true)
                    end)
                end
            end,
        },
    },

    ['radio'] = {
        label = 'Radio',
        weight = 1000,
        allowArmed = true,
        consume = 0,

        client = {
            event = 'mm_radio:client:use',
        },
    },

    ['jammer'] = {
        label = 'Radio Jammer',
        weight = 10000,
        allowArmed = true,

        client = {
            event = 'mm_radio:client:usejammer',
        },
    },

    ['radiocell'] = {
        label = 'AAA Cells',
        weight = 1000,
        stack = true,
        allowArmed = true,

        client = {
            event = 'mm_radio:client:recharge',
        },
    },

    -- =========================================================
    -- CASINO
    -- =========================================================

    ["casinochips"] = {
        label = "Casino Chips",
        weight = 1,
        stack = true,
        close = true,
    },
    ["casino_member"] = {
        label = "Casino Member",
        weight = 1,
        stack = true,
        close = true,
    },
    ["casino_vip"] = {
        label = "Casino VIP",
        weight = 1,
        stack = true,
        close = true,
    },

    -- =========================================================
    -- TOOLS
    -- =========================================================

    ['lockpick'] = {
        label = 'Lockpick',
        weight = 160,
    },

    ['advancedlockpick'] = {
        label = 'Advanced Lockpick',
        weight = 500,
    },

    ['screwdriverset'] = {
        label = 'Screwdriver Set',
        weight = 500,
    },

    ['electronickit'] = {
        label = 'Electronic Kit',
        weight = 500,
    },

    ['gatecrack'] = {
        label = 'Gatecrack',
        weight = 1000,
    },

    ['cryptostick'] = {
        label = 'Crypto Stick',
        weight = 100,
    },

    ['trojan_usb'] = {
        label = 'Trojan USB',
        weight = 100,
    },

    ['drill'] = {
        label = 'Drill',
        weight = 5000,
    },

    ['thermite'] = {
        label = 'Thermite',
        weight = 1000,
    },

    ['lighter'] = {
        label = 'Lighter',
        weight = 200,
    },

    ['binoculars'] = {
        label = 'Binoculars',
        weight = 800,
    },

    ['stickynote'] = {
        label = 'Sticky Note',
        weight = 0,
    },

    -- =========================================================
    -- MINING
    -- =========================================================

    ['ls_pickaxe'] = {
        label = 'Pickaxe',
        weight = 100
    },

    ['ls_copper_pickaxe'] = {
        label = 'Copper Pickaxe',
        weight = 100
    },

    ['ls_iron_pickaxe'] = {
        label = 'Iron Pickaxe',
        weight = 100
    },

    ['ls_silver_pickaxe'] = {
        label = 'Silver Pickaxe',
        weight = 100
    },

    ['ls_gold_pickaxe'] = {
        label = 'Gold Pickaxe',
        weight = 100
    },

    ['ls_copper_ore'] = {
        label = 'Copper Ore',
        weight = 100
    },

    ['ls_coal_ore'] = {
        label = 'Coal Ore',
        weight = 100
    },

    ['ls_iron_ore'] = {
        label = 'Iron Ore',
        weight = 100
    },

    ['ls_silver_ore'] = {
        label = 'Silver Ore',
        weight = 100
    },

    ['ls_gold_ore'] = {
        label = 'Gold Ore',
        weight = 100
    },

    ['ls_copper_ingot'] = {
        label = 'Copper Ingot',
        weight = 500
    },

    ['ls_iron_ingot'] = {
        label = 'Iron Ingot',
        weight = 500
    },

    ['ls_silver_ingot'] = {
        label = 'Silver Ingot',
        weight = 500
    },

    ['ls_gold_ingot'] = {
        label = 'Gold Ingot',
        weight = 500
    },

    -- =========================================================
    -- ARMOUR / POLICE
    -- =========================================================

    ['armour'] = {
        label = 'Bulletproof Vest',
        weight = 3000,
        stack = false,

        client = {
            anim = {
                dict = 'clothingshirt',
                clip = 'try_shirt_positive_d',
            },
            usetime = 3500,
        },
    },

    ['handcuffs'] = {
        label = 'Handcuffs',
        weight = 200,
    },

    ['empty_evidence_bag'] = {
        label = 'Empty Evidence Bag',
        weight = 200,
    },

    ['filled_evidence_bag'] = {
        label = 'Filled Evidence Bag',
        weight = 200,
    },

    ['harness'] = {
        label = 'Harness',
        weight = 200,
    },

    -- =========================================================
    -- IDENTIFICATION / MONEY
    -- =========================================================

    ['money'] = {
        label = 'Money',
    },

    ['black_money'] = {
        label = 'Dirty Money',
    },

    ['id_card'] = {
        label = 'Identification Card',
    },

    ['driver_license'] = {
        label = "Driver's License",
    },

    ['weaponlicense'] = {
        label = 'Weapon License',
    },

    ['lawyerpass'] = {
        label = 'Lawyer Pass',
    },

    -- =========================================================
    -- RECYCLING / MATERIALS
    -- =========================================================

    ['steel'] = {
        label = 'Steel',
        weight = 100,
    },

    ['rubber'] = {
        label = 'Rubber',
        weight = 100,
    },

    ['metalscrap'] = {
        label = 'Metal Scrap',
        weight = 100,
    },

    ['iron'] = {
        label = 'Iron',
        weight = 100,
    },

    ['copper'] = {
        label = 'Copper',
        weight = 100,
    },

    ['aluminum'] = {
        label = 'Aluminium',
        weight = 100,
    },

    ['plastic'] = {
        label = 'Plastic',
        weight = 100,
    },

    ['glass'] = {
        label = 'Glass',
        weight = 100,
    },

    -- =========================================================
    -- VALUABLES / LOOT
    -- =========================================================

    ['diamond_ring'] = {
        label = 'Diamond',
        weight = 1500,
    },

    ['rolex'] = {
        label = 'Golden Watch',
        weight = 1500,
    },

    ['goldbar'] = {
        label = 'Gold Bar',
        weight = 1500,
    },

    ['goldchain'] = {
        label = 'Golden Chain',
        weight = 1500,
    },

    ['toaster'] = {
        label = 'Toaster',
        weight = 5000,
    },

    ['small_tv'] = {
        label = 'Small TV',
        weight = 100,
    },

    -- =========================================================
    -- SECURITY
    -- =========================================================

    ['security_card_01'] = {
        label = 'Security Card A',
        weight = 100,
    },

    ['security_card_02'] = {
        label = 'Security Card B',
        weight = 100,
    },

    -- =========================================================
    -- DRUGS
    -- =========================================================

    ['crack_baggy'] = {
        label = 'Crack Baggy',
        weight = 100,
    },

    ['cokebaggy'] = {
        label = 'Bag of Coke',
        weight = 100,
    },

    ['coke_brick'] = {
        label = 'Coke Brick',
        weight = 2000,
    },

    ['coke_small_brick'] = {
        label = 'Coke Package',
        weight = 1000,
    },

    ['xtcbaggy'] = {
        label = 'Bag of Ecstasy',
        weight = 100,
    },

    ['meth'] = {
        label = 'Methamphetamine',
        weight = 100,
    },

    ['oxy'] = {
        label = 'Oxycodone',
        weight = 100,
    },

    ['weed_ak47'] = {
        label = 'AK47 2g',
        weight = 200,
    },

    ['weed_ak47_seed'] = {
        label = 'AK47 Seed',
        weight = 1,
    },

    ['weed_skunk'] = {
        label = 'Skunk 2g',
        weight = 200,
    },

    ['weed_skunk_seed'] = {
        label = 'Skunk Seed',
        weight = 1,
    },

    ['weed_amnesia'] = {
        label = 'Amnesia 2g',
        weight = 200,
    },

    ['weed_amnesia_seed'] = {
        label = 'Amnesia Seed',
        weight = 1,
    },

    ['weed_og-kush'] = {
        label = 'OG Kush 2g',
        weight = 200,
    },

    ['weed_og-kush_seed'] = {
        label = 'OG Kush Seed',
        weight = 1,
    },

    ['weed_white-widow'] = {
        label = 'White Widow 2g',
        weight = 200,
    },

    ['weed_white-widow_seed'] = {
        label = 'White Widow Seed',
        weight = 1,
    },

    ['weed_purple-haze'] = {
        label = 'Purple Haze 2g',
        weight = 200,
    },

    ['weed_purple-haze_seed'] = {
        label = 'Purple Haze Seed',
        weight = 1,
    },

    ['weed_brick'] = {
        label = 'Weed Brick',
        weight = 2000,
    },

    ['weed_nutrition'] = {
        label = 'Plant Fertilizer',
        weight = 2000,
    },

    ['joint'] = {
        label = 'Joint',
        weight = 200,
    },

    ['rolling_paper'] = {
        label = 'Rolling Paper',
        weight = 0,
    },

    ['empty_weed_bag'] = {
        label = 'Empty Weed Bag',
        weight = 0,
    },

    -- =========================================================
    -- DIVING
    -- =========================================================

    ['diving_gear'] = {
        label = 'Diving Gear',
        weight = 30000,
    },

    ['diving_fill'] = {
        label = 'Diving Tube',
        weight = 3000,
    },

    ['antipatharia_coral'] = {
        label = 'Antipatharia',
        weight = 1000,
    },

    ['dendrogyra_coral'] = {
        label = 'Dendrogyra',
        weight = 1000,
    },

    -- =========================================================
    -- FIREWORKS
    -- =========================================================

    ['firework1'] = {
        label = '2Brothers',
        weight = 1000,
    },

    ['firework2'] = {
        label = 'Poppelers',
        weight = 1000,
    },

    ['firework3'] = {
        label = 'WipeOut',
        weight = 1000,
    },

    ['firework4'] = {
        label = 'Weeping Willow',
        weight = 1000,
    },

    -- =========================================================
    -- VEHICLE / FUEL
    -- =========================================================

    ['jerry_can'] = {
        label = 'Jerrycan',
        weight = 3000,
    },

    ['nitrous'] = {
        label = 'Nitrous',
        weight = 1000,
    },

     -- =========================================================
    -- MT WORKSHOP ITEMS
    -- =========================================================

    ['cosmetics'] = {
        label = 'Cosmetics',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Vehicle cosmetics',
    },

    -- Performance - Engine
    ['engine_s'] = {
        label = 'S Class Engine',
        weight = 1000,
    },

    ['engine_a'] = {
        label = 'A Class Engine',
        weight = 1000,
    },

    ['engine_b'] = {
        label = 'B Class Engine',
        weight = 1000,
    },

    ['engine_c'] = {
        label = 'C Class Engine',
        weight = 1000,
    },

    ['engine_d'] = {
        label = 'D Class Engine',
        weight = 1000,
    },

    -- Performance - Transmission
    ['transmission_s'] = {
        label = 'S Class Transmission',
        weight = 1000,
    },

    ['transmission_a'] = {
        label = 'A Class Transmission',
        weight = 1000,
    },

    ['transmission_b'] = {
        label = 'B Class Transmission',
        weight = 1000,
    },

    ['transmission_c'] = {
        label = 'C Class Transmission',
        weight = 1000,
    },

    ['transmission_d'] = {
        label = 'D Class Transmission',
        weight = 1000,
    },

    -- Performance - Brakes
    ['brake_s'] = {
        label = 'S Class Brakes',
        weight = 1000,
    },

    ['brake_a'] = {
        label = 'A Class Brakes',
        weight = 1000,
    },

    ['brake_b'] = {
        label = 'B Class Brakes',
        weight = 1000,
    },

    ['brake_c'] = {
        label = 'C Class Brakes',
        weight = 1000,
    },

    ['brake_d'] = {
        label = 'D Class Brakes',
        weight = 1000,
    },

    -- Performance - Suspension
    ['suspension_s'] = {
        label = 'S Class Suspension',
        weight = 1000,
    },

    ['suspension_a'] = {
        label = 'A Class Suspension',
        weight = 1000,
    },

    ['suspension_b'] = {
        label = 'B Class Suspension',
        weight = 1000,
    },

    ['suspension_c'] = {
        label = 'C Class Suspension',
        weight = 1000,
    },

    ['suspension_d'] = {
        label = 'D Class Suspension',
        weight = 1000,
    },

    -- Performance - Armour
    ['armour_s'] = {
        label = 'S Class Armour',
        weight = 1000,
    },

    ['armour_a'] = {
        label = 'A Class Armour',
        weight = 1000,
    },

    ['armour_b'] = {
        label = 'B Class Armour',
        weight = 1000,
    },

    ['armour_c'] = {
        label = 'C Class Armour',
        weight = 1000,
    },

    ['armour_d'] = {
        label = 'D Class Armour',
        weight = 1000,
    },

    -- Performance - Turbo
    ['turbo_s'] = {
        label = 'S Class Turbo',
        weight = 1000,
    },

    ['turbo_a'] = {
        label = 'A Class Turbo',
        weight = 1000,
    },

    ['turbo_b'] = {
        label = 'B Class Turbo',
        weight = 1000,
    },

    ['turbo_c'] = {
        label = 'C Class Turbo',
        weight = 1000,
    },

    ['turbo_d'] = {
        label = 'D Class Turbo',
        weight = 1000,
    },

    -- Workshop Controllers / Tools
    ['neons_controller'] = {
        label = 'Neon Controller',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Vehicle neon controller',
    },

    ['engine_repair_kit'] = {
        label = 'Engine Repair Kit',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Used to repair vehicle engines',
    },

    ['body_repair_kit'] = {
        label = 'Body Repair Kit',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Used to repair vehicle body',
    },

    ['mechanic_toolbox'] = {
        label = 'Mechanic Toolbox',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Mechanic toolbox',
    },

    ['extras_controller'] = {
        label = 'Extras Controller',
        weight = 1000,
        stack = true,
        close = true,
        description = 'Vehicle extras controller',
    },

    -- Mods List
    ['mods_list'] = {
        label = 'Vehicle Mods List',
        weight = 0,
        stack = true,
        close = true,
        description = 'List of vehicle modifications to install',
        client = {
            export = 'mt_workshops.openCosmeticsMenu',
        },
    },

    -- =========================================================
    -- MISC
    -- =========================================================

    ['garbage'] = {
        label = 'Garbage',
    },
}
