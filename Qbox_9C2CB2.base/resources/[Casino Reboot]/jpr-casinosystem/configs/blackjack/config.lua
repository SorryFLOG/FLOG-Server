
BlackJack = {}
BlackJack.CanInteract = {member = true, vip = true, none = false}

BlackJack.Tables = { -- Spawns Ped Only
	{
		coords = vector4(1004.09, 53.11, 68.45, 55.30),
		highStakes = false
	},
	{
		coords = vector4(1002.36, 60.52, 68.45, 142.53), 
		highStakes = false
	},
	{
	 	coords = vector4(985.95, 60.56, 69.25, 187.91), 
	 	highStakes = true
	},
	{
	 	coords = vector4(982.50, 62.85, 69.25, 101.44), 
	 	highStakes = true
	},
	{
	 	coords = vector4(989.05, 45.69, 69.25, 22.31),
	 	highStakes = true
	},
	{
	 	coords = vector4(987.30, 42.19, 69.25, 102.30), 
	 	highStakes = true
	},
}

BlackJack.ResultNames = {
	["good"] = "WON",
	["bad"] = "BUST",
	["impartial"] = "Got a PUSH",
}

BlackJack.RequestCardAnims = {
	"request_card",
	"request_card_alt1",
	"request_card_alt2",
}

BlackJack.DeclineCardAnims = {
	"decline_card_001",
	"decline_card_alt1",
	"decline_card_alt2",
}

BlackJack.LowTableLimit = 40

BlackJack.BettingTime = 50

BlackJack.MoveTime = 30

BlackJack.ChipModels = {
	[10] = "vw_prop_chip_10dollar_x1",
	[50] = "vw_prop_chip_50dollar_x1",
	[100] = "vw_prop_chip_100dollar_x1",
	[120] = "vw_prop_chip_10dollar_st",
	[500] = "vw_prop_chip_500dollar_x1",
	[600] = "vw_prop_chip_50dollar_st",
	[1000] = "vw_prop_chip_1kdollar_x1",
	[1200] = "vw_prop_chip_100dollar_st",
	[5000] = "vw_prop_chip_5kdollar_x1",
	[6000] = "vw_prop_chip_500dollar_st",
	[10000] = "vw_prop_chip_10kdollar_x1",
	[60000] = "vw_prop_chip_5kdollar_st",
	[120000] = "vw_prop_chip_10kdollar_st",
}

BlackJack.ChipValues = {
	10,
	50,
	100,
	120,
	500,
	600,
	1000,
	1200,
	5000,
	6000,
	10000,
	60000,
	120000,
}