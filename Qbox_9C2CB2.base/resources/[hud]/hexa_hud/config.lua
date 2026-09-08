Config = {}

-- auto, esx ou qb. Le mode auto est recommandé.
Config.Framework = 'auto'
Config.Language = 'en' -- fr ou en
Config.UpdateInterval = 250
Config.StatusInterval = 1000
Config.SpeedUnit = 'mph' -- kmh ou mph
Config.FuelSystem = 'auto' -- auto, native, ox_fuel ou LegacyFuel
Config.ServerSettings = true -- sauvegarde serveur sans SQL, en plus du cache local
Config.HideRadarOnFoot = true
Config.UseSeatbelt = true
Config.SeatbeltNotify = {
  enabled = true,
  reminderCooldown = 15000,
  duration = 4000
}
Config.ToggleCommand = 'togglehud'
Config.ToggleKey = 'F10'
Config.SettingsCommand = 'hudsettings'

-- Un élément activé dans Config.Show peut être masqué/réactivé par le joueur.
-- Un élément désactivé dans Config.Show reste indisponible pour tout le monde.
Config.AllowPlayerVisibility = true

-- Les modules marqués true gardent leur position d'origine pour tous.
Config.FixedModules = {
  location = true
}

Config.Features = {
  vehicleIndicators = true,
  smartAlerts = true,
  tripComputer = true,
  policeMode = true,
  electricMode = true,
  profiles = true,
  snapGrid = 10
}

Config.Alerts = {
  lowFuel = 15,
  criticalEngine = 300,
  lowHealth = 25,
  lowOxygen = 20,
  seatbeltSpeed = 25,
  highEngineTemperature = 115
}

-- Les jauges contextuelles libèrent de la place lorsqu'elles ne servent pas.
Config.AutoHide = {
  armorWhenEmpty = true,
  staminaWhenFull = true,
  unsupportedNeeds = true
}

Config.Map = {
  enabled = true,
  onlyInVehicle = true,
  rounded = false,
  showFrame = false
}

Config.Show = {
  status = true,
  identity = true,
  economy = true,
  location = true,
  vehicle = true,
  minimap = true,
  rpm = true,
  gear = true,
  fuel = true,
  indicators = false,
  alerts = true,
  trip = false,
  money = true,
  bank = true,
  job = true,
  playerId = true,
  street = true,
  compass = true
}

-- Thème partagé avec les autres ressources Hexa Studio.
Config.Theme = {
  background = '#0c1f37',
  backgroundDeep = '#051122',
  surface = 'linear-gradient(135deg, rgba(12,31,55,.94), rgba(5,17,34,.92))',
  text = '#f5f8ff',
  muted = '#8fa0b8',
  border = 'rgba(105,172,235,.20)',
  shadow = '0 10px 28px rgba(0,0,0,.30), inset 0 1px rgba(153,210,255,.06)',
  radius = 16
}

Config.Colors = {
  accent = '#66e3ff',
  health = '#ff5576',
  armor = '#6aa8ff',
  hunger = '#ffbd59',
  thirst = '#55d6c2',
  stamina = '#b38cff',
  oxygen = '#68d8ff'
}
