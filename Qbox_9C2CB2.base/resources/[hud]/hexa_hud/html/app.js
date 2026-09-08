const $ = (selector) => document.querySelector(selector)
const hud = $('#hud')
const preview = typeof GetParentResourceName !== 'function'
let autoHide = { armorWhenEmpty: true, staminaWhenFull: true, unsupportedNeeds: true }
let mapOptions = { enabled: true, onlyInVehicle: true, rounded: false, showFrame: false }
let features = { vehicleIndicators:true, smartAlerts:true, tripComputer:true, policeMode:true, electricMode:true, profiles:true, snapGrid:10 }
let alertLimits = { lowFuel:15, criticalEngine:300, lowHealth:25, lowOxygen:20, seatbeltSpeed:25, highEngineTemperature:115 }
let alertSignature = ''
let globalShow = {}
let fixedModules = {}
let allowPlayerVisibility = false
let language = 'fr'
const locales = {
  fr: { citizen:'Citoyen', civil:'Civil', cash:'Liquide', bank:'Banque', voice:'VOCAL', proximity:'Proximité', speed:'VITESSE', engine:'MOTEUR', belt:'CEINTURE', gear:'RAPPORT', fuel:'CARBURANT', customization:'Personnalisation', appearance:'Apparence', scale:'Échelle', accent:'Couleur principale', visible:'Modules visibles', statuses:'Statuts', identity:'Identité', money:'Argent', location:'Localisation', speedometer:'Compteur', minimap:'Minimap', vehicle:'Compteur voiture', type:'Type', unit:'Unité', size:'Taille', opacity:'Opacité', profile:'Profil', needle:'Couleur de l’aiguille', redline:'Zone rouge', rpm:'RPM', indicators:'Voyants', alerts:'Alertes', trip:'Trajet', placement:'Placement', move:'Déplacer les éléments à la souris', resetPositions:'Réinitialiser les positions', reset:'Réinitialiser', save:'Enregistrer', saved:'✓ Enregistré', drag:'Glisse les blocs pour les déplacer · clic droit pour restaurer un bloc', done:'Terminer le placement', close:'Fermer', unknown:'Position inconnue', onDuty:'EN SERVICE', offDuty:'HORS SERVICE', radio:'Radio', customized:'Personnalisé', immersion:'Immersion', racing:'Course', minimal:'Minimal', police:'Police', discreet:'Discret', compact:'Compact', gauge:'Jauge', light:'FEUX', door:'PORTE', cruise:'RÉGUL.', tripShort:'TRAJET' },
  en: { citizen:'Citizen', civil:'Civilian', cash:'Cash', bank:'Bank', voice:'VOICE', proximity:'Proximity', speed:'SPEED', engine:'ENGINE', belt:'SEATBELT', gear:'GEAR', fuel:'FUEL', customization:'Customization', appearance:'Appearance', scale:'Scale', accent:'Accent color', visible:'Visible modules', statuses:'Statuses', identity:'Identity', money:'Money', location:'Location', speedometer:'Speedometer', minimap:'Minimap', vehicle:'Vehicle speedometer', type:'Style', unit:'Unit', size:'Size', opacity:'Opacity', profile:'Profile', needle:'Needle color', redline:'Redline', rpm:'RPM', indicators:'Indicators', alerts:'Alerts', trip:'Trip computer', placement:'Placement', move:'Move elements with the mouse', resetPositions:'Reset positions', reset:'Reset', save:'Save', saved:'✓ Saved', drag:'Drag modules · right-click to reset one module', done:'Finish placement', close:'Close', unknown:'Unknown location', onDuty:'ON DUTY', offDuty:'OFF DUTY', radio:'Radio', customized:'Custom', immersion:'Immersion', racing:'Racing', minimal:'Minimal', police:'Police', discreet:'Discreet', compact:'Compact', gauge:'Gauge', light:'LIGHT', door:'DOOR', cruise:'CRUISE', tripShort:'TRIP' }
}
const tr = (key) => (locales[language] || locales.fr)[key] || key
let settings = { version:4, scale:1, accent:'#66e3ff', mapOffsetX:0, mapOffsetY:0, showMap:true, showLocation:true, showStatus:true, showIdentity:true, showEconomy:true, showVehicle:true, positions:{}, vehicleStyle:'racing', vehicleScale:1, vehicleOpacity:.94, vehicleUnit:'kmh', showRpm:true, showGear:true, showFuel:true, profile:'custom', needleColor:'#66e3ff', redline:85, showIndicators:true, showAlerts:true, showTrip:false }

function number(value) {
  return new Intl.NumberFormat(language === 'en' ? 'en-US' : 'fr-FR').format(Math.max(0, Number(value) || 0)) + ' $'
}

function setLanguage(next) {
  language = next === 'en' ? 'en' : 'fr'
  document.documentElement.lang = language
  const texts = [
    ['.identity-copy #job','citizen'], ['.identity-copy #grade','civil'], ['.economy>div:first-child small','cash'], ['.economy>div:last-child small','bank'],
    ['#voice strong','voice'], ['#radio','proximity'], ['.gauge-dial>span','speed'], ['#engine','engine'], ['#seatbelt b','belt'], ['.gear small','gear'], ['.fuel small','fuel'],
    ['#settings-panel h1','customization'], ['.settings-content section:nth-child(1) h2','appearance'], ['#setting-scale','scale'], ['#setting-accent','accent'],
    ['.settings-content section:nth-child(2) h2','visible'], ['#setting-showStatus','statuses'], ['#setting-showIdentity','identity'], ['#setting-showEconomy','money'], ['#setting-showLocation','location'], ['#setting-showVehicle','speedometer'], ['#setting-showMap','minimap'],
    ['.settings-content section:nth-child(3) h2','vehicle'], ['#setting-profile','profile'], ['#setting-vehicleStyle','type'], ['#setting-vehicleUnit','unit'], ['#setting-vehicleScale','size'], ['#setting-vehicleOpacity','opacity'], ['#setting-needleColor','needle'], ['#setting-redline','redline'], ['#setting-showRpm + span','rpm'], ['#setting-showGear + span','gear'], ['#setting-showFuel + span','fuel'], ['#setting-showIndicators + span','indicators'], ['#setting-showAlerts + span','alerts'], ['#setting-showTrip + span','trip'],
    ['.settings-content section:nth-child(4) h2','placement'], ['#settings-layout','move'], ['#settings-reset','reset'], ['#settings-save','save'], ['#layout-toolbar span','drag'], ['#layout-reset','resetPositions'], ['#layout-done','done']
  ]
  texts.forEach(([selector,key]) => {
    const node = $(selector)
    if (!node) return
    const target = node.matches('input,select') ? node.closest('label')?.querySelector('span') : node
    if (!target) return
    if (target.querySelector('output')) target.firstChild.nodeValue = `${tr(key)} `
    else target.textContent = tr(key)
  })
  $('#settings-close').setAttribute('aria-label', tr('close'))
  $('#save-toast').textContent = tr('saved')
  const optionLabels = {
    '#setting-profile': { custom:'customized', immersion:'immersion', racing:'racing', minimal:'minimal', police:'police', discreet:'discreet' },
    '#setting-vehicleStyle': { racing:'racing', gauge:'gauge', compact:'compact', minimal:'minimal' }
  }
  Object.entries(optionLabels).forEach(([selector, labels]) => {
    const select = $(selector)
    if (!select) return
    Object.entries(labels).forEach(([value, key]) => {
      const option = select.querySelector(`option[value="${value}"]`)
      if (option) option.textContent = tr(key)
    })
  })
  const indicatorLabels = { engine:'engine', lights:'light', doors:'door', cruise:'cruise' }
  Object.entries(indicatorLabels).forEach(([indicator, key]) => {
    const node = $(`[data-indicator="${indicator}"]`)
    if (node) node.textContent = tr(key)
  })
  const tripLabel = $('#trip-computer span:first-child')
  if (tripLabel?.firstChild) tripLabel.firstChild.nodeValue = `${tr('tripShort')} `
  $('.status-row').setAttribute('aria-label', language === 'en' ? 'Player status' : 'État du joueur')
}

function setStatus(name, value) {
  const node = document.querySelector(`[data-status="${name}"]`)
  if (!node) return
  const safe = Math.max(0, Math.min(100, Number(value) || 0))
  node.style.setProperty('--value', `${safe}%`)
  node.querySelector('small').textContent = Math.round(safe)
}

function configure(data) {
  setLanguage(data.language)
  autoHide = { ...autoHide, ...(data.autoHide || {}) }
  mapOptions = { ...mapOptions, ...(data.map || {}) }
  features = { ...features, ...(data.features || {}) }
  alertLimits = { ...alertLimits, ...(data.alerts || {}) }
  globalShow = data.show || {}
  fixedModules = data.fixedModules || {}
  allowPlayerVisibility = data.allowPlayerVisibility === true
  $('#setting-profile').disabled = features.profiles === false
  Object.entries(data.colors || {}).forEach(([key, value]) => document.documentElement.style.setProperty(`--${key}`, value))
  Object.entries(data.theme || {}).forEach(([key, value]) => document.documentElement.style.setProperty(`--ui-${key}`, typeof value === 'number' ? `${value}px` : value))
  const show = globalShow
  $('.economy').classList.toggle('hidden', show.money === false && show.bank === false)
  $('.identity').classList.toggle('hidden', show.job === false && show.playerId === false)
  $('.location').classList.toggle('hidden', show.street === false && show.compass === false)
  const visibilityKeys = { showStatus:'status', showIdentity:'identity', showEconomy:'economy', showLocation:'location', showVehicle:'vehicle', showMap:'minimap', showRpm:'rpm', showGear:'gear', showFuel:'fuel', showIndicators:'indicators', showAlerts:'alerts', showTrip:'trip' }
  Object.entries(visibilityKeys).forEach(([key, configKey]) => {
    const input = $(`#setting-${key}`)
    if (input) input.disabled = !allowPlayerVisibility || globalShow[configKey] === false
  })
  if (data.settings) applySettings(data.settings)
}

function applySettings(next) {
  settings = { ...settings, ...next }
  document.documentElement.style.setProperty('--accent', settings.accent)
  document.documentElement.style.setProperty('--hud-scale', settings.scale)
  document.documentElement.style.setProperty('--map-offset-x', `${settings.mapOffsetX}px`)
  document.documentElement.style.setProperty('--map-offset-y', `${-settings.mapOffsetY}px`)
  const visible = (configKey, settingKey) => globalShow[configKey] !== false && (!allowPlayerVisibility || settings[settingKey] !== false)
  $('.status-row').classList.toggle('settings-hidden', !visible('status', 'showStatus'))
  $('.identity').classList.toggle('settings-hidden', !visible('identity', 'showIdentity'))
  $('.economy').classList.toggle('settings-hidden', !visible('economy', 'showEconomy'))
  $('.location').classList.toggle('settings-hidden', !visible('location', 'showLocation'))
  $('.vehicle').classList.toggle('settings-hidden', !visible('vehicle', 'showVehicle'))
  $('#map-frame').classList.toggle('settings-hidden', !visible('minimap', 'showMap'))
  const vehicle = $('.vehicle')
  ;['racing','gauge','compact','minimal'].forEach((style) => vehicle.classList.toggle(`style-${style}`, settings.vehicleStyle === style))
  vehicle.style.setProperty('--vehicle-scale', Number(settings.vehicleScale) || 1)
  vehicle.style.setProperty('--vehicle-opacity', Number(settings.vehicleOpacity) || .94)
  vehicle.style.setProperty('--needle-color', settings.needleColor || settings.accent)
  vehicle.style.setProperty('--redline', `${Number(settings.redline) || 85}%`)
  vehicle.classList.toggle('hide-rpm', globalShow.rpm === false || (allowPlayerVisibility && !settings.showRpm))
  vehicle.classList.toggle('hide-gear', globalShow.gear === false || (allowPlayerVisibility && !settings.showGear))
  vehicle.classList.toggle('hide-fuel', globalShow.fuel === false || (allowPlayerVisibility && !settings.showFuel))
  $('#vehicle-indicators').classList.toggle('settings-hidden', globalShow.indicators === false || !features.vehicleIndicators || !settings.showIndicators)
  $('#trip-computer').classList.toggle('settings-hidden', globalShow.trip === false || !features.tripComputer || !settings.showTrip)
  $('#alert-stack').classList.toggle('settings-hidden', globalShow.alerts === false || !features.smartAlerts || !settings.showAlerts)
  const positions = settings.positions || {}
  ;['identity','economy','status','location','vehicle'].forEach((key) => {
    const node = key === 'status' ? $('.status-row') : $(`.${key}`)
    const position = fixedModules[key] ? { x:0, y:0 } : (positions[key] || { x:0, y:0 })
    node.style.setProperty('--drag-x', `${Number(position.x) || 0}px`)
    node.style.setProperty('--drag-y', `${Number(position.y) || 0}px`)
  })
}

function update(data) {
  hud.classList.toggle('is-hidden', data.visible === false)
  const player = data.player || {}
  ;['health','armor','hunger','thirst','stamina','oxygen'].forEach((key) => setStatus(key, player[key]))
  document.querySelector('[data-status="armor"]').classList.toggle('hidden', autoHide.armorWhenEmpty && Number(player.armor) <= 0)
  document.querySelector('[data-status="stamina"]').classList.toggle('hidden', autoHide.staminaWhenFull && Number(player.stamina) >= 99)
  document.querySelector('[data-status="oxygen"]').classList.toggle('hidden', !player.underwater)
  const hideNeeds = autoHide.unsupportedNeeds && player.needsAvailable === false
  document.querySelector('[data-status="hunger"]').classList.toggle('hidden', hideNeeds)
  document.querySelector('[data-status="thirst"]').classList.toggle('hidden', hideNeeds)
  $('#voice').classList.toggle('talking', Boolean(player.voice))
  $('#radio').textContent = Number(player.radio) > 0 ? `${tr('radio')} ${player.radio}` : (player.voiceMode || tr('proximity'))
  $('#player-id').textContent = player.id ?? '—'
  $('#job').textContent = data.info?.job || tr('citizen')
  $('#grade').textContent = data.info?.grade || tr('onDuty')
  const duty = data.info?.duty
  $('#duty').classList.toggle('hidden', typeof duty !== 'boolean')
  $('#duty').classList.toggle('off-duty', duty === false)
  $('#duty').textContent = duty === false ? tr('offDuty') : tr('onDuty')
  $('#cash').textContent = number(data.info?.cash)
  $('#bank').textContent = number(data.info?.bank)
  $('#direction').textContent = data.location?.direction || 'N'
  $('#street').textContent = data.location?.street || tr('unknown')
  $('#crossing').textContent = data.location?.crossing || 'Los Santos'

  const vehicle = data.vehicle
  const alerts = []
  if (Number(player.health) <= alertLimits.lowHealth) alerts.push({ icon:'♥', text:language === 'en' ? 'Critical health' : 'Santé critique', type:'danger' })
  if (player.underwater && Number(player.oxygen) <= alertLimits.lowOxygen) alerts.push({ icon:'≈', text:language === 'en' ? 'Low oxygen' : 'Oxygène faible', type:'danger' })
  const mapVisible = mapOptions.enabled && data.mapVisible !== false && Boolean(vehicle || !mapOptions.onlyInVehicle)
  hud.classList.toggle('map-active', mapVisible)
  $('#map-frame').classList.toggle('hidden', !mapVisible || !mapOptions.showFrame)
  $('#map-frame').classList.toggle('rounded', mapOptions.rounded)
  $('#vehicle').classList.toggle('hidden', !vehicle)
  if (!vehicle) { renderAlerts(alerts); return }
  $('#speed').textContent = String(Math.round(vehicle.speed || 0)).padStart(3, '0')
  $('#unit').textContent = vehicle.unit || 'KM/H'
  $('#gauge-speed').textContent = String(Math.round(vehicle.speed || 0)).padStart(3, '0')
  $('#gauge-unit').textContent = vehicle.unit || 'KM/H'
  $('#gauge-gear').textContent = Number(vehicle.gear) === 0 ? 'R' : vehicle.gear
  $('#vehicle').style.setProperty('--rpm-angle', `${Math.max(0, Math.min(100, vehicle.rpm || 0)) * 2.6}deg`)
  $('#vehicle').classList.toggle('at-redline', Number(vehicle.rpm) >= Number(settings.redline || 85))
  $('#rpm').style.width = `${Math.max(0, Math.min(100, vehicle.rpm || 0))}%`
  document.querySelectorAll('.shift-lights i').forEach((light, index, lights) => {
    light.classList.toggle('active', (vehicle.rpm || 0) >= ((index + 1) / lights.length) * 100)
  })
  $('#gear').textContent = Number(vehicle.gear) === 0 ? 'R' : vehicle.gear
  $('#fuel').textContent = Math.round(vehicle.fuel || 0)
  $('#gauge-fuel').textContent = Math.round(vehicle.fuel || 0)
  $('#vehicle').classList.toggle('low-fuel', Number(vehicle.fuel) <= alertLimits.lowFuel)
  $('#engine').classList.toggle('active', Boolean(vehicle.engine))
  $('#seatbelt').classList.toggle('active', Boolean(vehicle.seatbelt))
  $('#seatbelt').classList.toggle('warning', !vehicle.seatbelt)
  const indicators = {
    engine: Number(vehicle.engineHealth) < 650,
    lights: Boolean(vehicle.lights), left:Boolean(vehicle.indicatorLeft), right:Boolean(vehicle.indicatorRight),
    handbrake:Boolean(vehicle.handbrake), doors:Boolean(vehicle.doorsOpen), cruise:Boolean(vehicle.cruise)
  }
  Object.entries(indicators).forEach(([key, active]) => document.querySelector(`[data-indicator="${key}"]`)?.classList.toggle('active', active))
  $('#vehicle-indicators').classList.toggle('hidden', !features.vehicleIndicators)
  $('#trip-computer').classList.toggle('hidden', !features.tripComputer)
  $('#trip-distance').textContent = `${Number(vehicle.tripKm || 0).toFixed(1)} km`
  const seconds = Number(vehicle.tripSeconds) || 0
  $('#trip-time').textContent = `${String(Math.floor(seconds / 60)).padStart(2,'0')}:${String(seconds % 60).padStart(2,'0')}`
  $('#launch-time').textContent = vehicle.launch100 ? `0-100 ${Number(vehicle.launch100).toFixed(2)}s` : ''
  if (Number(vehicle.fuel) <= alertLimits.lowFuel) alerts.push({ icon:'⛽', text:language === 'en' ? 'Low fuel' : 'Carburant faible', type:'warning' })
  if (Number(vehicle.engineHealth) <= alertLimits.criticalEngine) alerts.push({ icon:'!', text:language === 'en' ? 'Engine critical' : 'Moteur critique', type:'danger' })
  if (Number(vehicle.engineTemperature) >= alertLimits.highEngineTemperature) alerts.push({ icon:'°', text:language === 'en' ? 'Engine overheating' : 'Surchauffe moteur', type:'danger' })
  if (vehicle.tyreHealth && Number(vehicle.tyreHealth) <= 25) alerts.push({ icon:'○', text:language === 'en' ? 'Tyres damaged' : 'Pneus endommagés', type:'warning' })
  const special = $('#special-mode')
  if (features.electricMode && vehicle.electric) {
    special.classList.remove('hidden'); $('#special-label').textContent = 'EV'; $('#special-value').textContent = `${Math.round(vehicle.battery || 0)}%`; $('#special-extra').textContent = vehicle.range ? `${Math.round(vehicle.range)} km` : ''
  } else if (features.policeMode && (vehicle.radarFront || vehicle.radarRear || vehicle.radarPlate)) {
    special.classList.remove('hidden'); $('#special-label').textContent = 'RADAR'; $('#special-value').textContent = vehicle.radarFront || vehicle.radarRear || ''; $('#special-extra').textContent = vehicle.radarPlate || ''
  } else special.classList.add('hidden')
  renderAlerts(alerts)
}

function renderAlerts(items) {
  const stack = $('#alert-stack')
  const signature = JSON.stringify(items)
  if (signature === alertSignature) return
  alertSignature = signature
  stack.replaceChildren(...items.slice(0, 3).map((item) => {
    const node = document.createElement('div'); node.className = `hud-alert ${item.type}`
    node.innerHTML = `<b>${item.icon}</b><span>${item.text}</span>`; return node
  }))
}

// Ferme toute l'UI de réglages, y compris le mode placement (barre d'outils
// + contours de glissement) — appelée à chaque fermeture pour ne jamais
// laisser le mode placement affiché sans le panneau qui permet d'en sortir.
function closeSettingsUI() {
  document.body.classList.remove('hud-layout-mode')
  $('#layout-toolbar').classList.add('hidden')
  $('#settings-panel').classList.add('hidden')
}

window.addEventListener('message', ({ data }) => {
  if (data.action === 'configure') configure(data)
  if (data.action === 'update') update(data)
  if (data.action === 'visibility') hud.classList.toggle('is-hidden', data.visible === false)
  if (data.action === 'seatbelt') {
    $('#seatbelt').classList.toggle('active', Boolean(data.enabled))
    $('#seatbelt').classList.toggle('warning', !data.enabled)
  }
  if (data.action === 'settings:open') openSettings(data.settings)
  if (data.action === 'settings:close') closeSettingsUI()
  if (data.action === 'settings:apply') applySettings(data.settings)
  if (data.action === 'settings:saved') showSaveToast()
})

let saveToastTimer = null
function showSaveToast() {
  const toast = $('#save-toast')
  if (!toast) return
  toast.classList.add('visible')
  window.clearTimeout(saveToastTimer)
  saveToastTimer = window.setTimeout(() => toast.classList.remove('visible'), 1800)
}

const settingKeys = ['scale','accent','showStatus','showIdentity','showEconomy','showLocation','showVehicle','showMap','profile','vehicleStyle','vehicleUnit','vehicleScale','vehicleOpacity','needleColor','redline','showRpm','showGear','showFuel','showIndicators','showAlerts','showTrip']
function nui(action, data = {}) {
  if (preview) return Promise.resolve()
  return fetch(`https://${GetParentResourceName()}/${action}`, { method:'POST', headers:{'Content-Type':'application/json'}, body:JSON.stringify(data) })
}
function readForm() {
  return Object.fromEntries(settingKeys.map((key) => {
    const input = $(`#setting-${key}`)
    return [key, input.type === 'checkbox' ? input.checked : input.type === 'range' ? Number(input.value) : input.value]
  }))
}
function syncOutputs() {
  $('#scale-output').textContent = `${Math.round(Number($('#setting-scale').value) * 100)}%`
  $('#vehicle-scale-output').textContent = `${Math.round(Number($('#setting-vehicleScale').value) * 100)}%`
  $('#vehicle-opacity-output').textContent = `${Math.round(Number($('#setting-vehicleOpacity').value) * 100)}%`
  $('#redline-output').textContent = `${Math.round(Number($('#setting-redline').value))}%`
}
function openSettings(next = settings) {
  applySettings(next)
  const globalKeys = { showStatus:'status', showIdentity:'identity', showEconomy:'economy', showLocation:'location', showVehicle:'vehicle', showMap:'minimap', showRpm:'rpm', showGear:'gear', showFuel:'fuel', showIndicators:'indicators', showAlerts:'alerts', showTrip:'trip' }
  settingKeys.forEach((key) => {
    const input = $(`#setting-${key}`)
    if (input.type === 'checkbox') input.checked = globalKeys[key] && globalShow[globalKeys[key]] === false ? false : (!allowPlayerVisibility && globalKeys[key] ? true : Boolean(settings[key]))
    else input.value = settings[key]
  })
  syncOutputs()
  $('#settings-panel').classList.remove('hidden')
}
const profiles = {
  immersion:{vehicleStyle:'minimal',showStatus:false,showIdentity:false,showEconomy:false,showLocation:true,showMap:true,showIndicators:false,showAlerts:true,showTrip:false,vehicleOpacity:.82},
  racing:{vehicleStyle:'gauge',showStatus:true,showIdentity:false,showEconomy:false,showLocation:true,showMap:true,showIndicators:true,showAlerts:true,showTrip:true,vehicleOpacity:.96},
  minimal:{vehicleStyle:'minimal',showStatus:true,showIdentity:true,showEconomy:false,showLocation:true,showMap:true,showIndicators:false,showAlerts:true,showTrip:false,vehicleOpacity:.88},
  police:{vehicleStyle:'racing',showStatus:true,showIdentity:true,showEconomy:true,showLocation:true,showMap:true,showIndicators:true,showAlerts:true,showTrip:false,vehicleOpacity:.96},
  // Pensé pour les captures d'écran et le RP filmé : tout est masqué à l'exception
  // d'un compteur minimal en transparence, pour ne pas polluer le cadre.
  discreet:{vehicleStyle:'minimal',showStatus:false,showIdentity:false,showEconomy:false,showLocation:false,showMap:false,showIndicators:false,showAlerts:false,showTrip:false,vehicleOpacity:.5}
}
settingKeys.forEach((key) => $(`#setting-${key}`).addEventListener('input', () => {
  if (key === 'profile' && profiles[$('#setting-profile').value]) {
    const preset = profiles[$('#setting-profile').value]
    Object.entries(preset).forEach(([presetKey,value]) => {
      const input = $(`#setting-${presetKey}`); if (!input) return
      if (input.type === 'checkbox') input.checked = value; else input.value = value
    })
  } else if (key !== 'profile') $('#setting-profile').value = 'custom'
  syncOutputs(); const next = readForm(); applySettings(next); nui('settings:preview', next)
}))
$('#settings-save').addEventListener('click', () => nui('settings:save', readForm()))
$('#settings-reset').addEventListener('click', () => nui('settings:reset'))
$('#settings-close').addEventListener('click', () => nui('settings:close'))
document.addEventListener('keydown', (event) => { if (event.key === 'Escape' && !$('#settings-panel').classList.contains('hidden')) nui('settings:close') })

const draggableModules = [
  ['identity', '.identity'], ['economy', '.economy'], ['status', '.status-row'],
  ['location', '.location'], ['vehicle', '.vehicle'], ['map', '#map-frame'],
]
$('#settings-layout').addEventListener('click', () => {
  document.body.classList.add('hud-layout-mode')
  $('#settings-panel').classList.add('hidden')
  $('#layout-toolbar').classList.remove('hidden')
})
$('#layout-done').addEventListener('click', () => {
  document.body.classList.remove('hud-layout-mode')
  $('#layout-toolbar').classList.add('hidden')
  $('#settings-panel').classList.remove('hidden')
  nui('settings:preview', settings)
})
$('#layout-reset').addEventListener('click', () => {
  settings.positions = {}; applySettings(settings); nui('settings:preview', settings)
})
draggableModules.forEach(([key, selector]) => {
  const node = $(selector)
  node.addEventListener('contextmenu', (event) => {
    if (!document.body.classList.contains('hud-layout-mode') || fixedModules[key]) return
    event.preventDefault(); settings.positions = { ...(settings.positions || {}) }; delete settings.positions[key]; applySettings(settings); nui('settings:preview', settings)
  })
  node.addEventListener('pointerdown', (event) => {
    if (!document.body.classList.contains('hud-layout-mode') || fixedModules[key]) return
    event.preventDefault(); node.setPointerCapture(event.pointerId)
    const startX = event.clientX, startY = event.clientY
    const start = key === 'map'
      ? { x:Number(settings.mapOffsetX)||0, y:-(Number(settings.mapOffsetY)||0) }
      : { ...(settings.positions?.[key] || { x:0, y:0 }) }
    const move = (moveEvent) => {
      const grid = Math.max(1, Number(features.snapGrid) || 1)
      const x = Math.round((start.x + moveEvent.clientX - startX) / grid) * grid
      const screenY = Math.round((start.y + moveEvent.clientY - startY) / grid) * grid
      if (key === 'map') {
        settings.mapOffsetX = x; settings.mapOffsetY = -screenY
      } else {
        settings.positions = { ...(settings.positions || {}), [key]: { x, y:screenY } }
      }
      applySettings(settings)
    }
    const end = () => { node.removeEventListener('pointermove', move); node.removeEventListener('pointerup', end); node.removeEventListener('pointercancel', end); nui('settings:preview', settings) }
    node.addEventListener('pointermove', move); node.addEventListener('pointerup', end); node.addEventListener('pointercancel', end)
  })
})

if (preview) {
  document.body.classList.add('browser-preview')
  update({ visible:true, mapVisible:true, player:{id:24,health:92,armor:64,hunger:81,thirst:73,stamina:42,oxygen:100,needsAvailable:true,voice:true,radio:3}, info:{job:'Los Santos Police',grade:'Sergent',cash:2450,bank:18700}, location:{direction:'NE',street:'Vespucci Boulevard',crossing:'Alta Street'}, vehicle:{speed:118,unit:'KM/H',fuel:76,rpm:63,gear:4,engine:true,seatbelt:true} })
}
