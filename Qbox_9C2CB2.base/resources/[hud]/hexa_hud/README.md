# Services RP HUD

HUD NUI moderne avec détection automatique de **ESX Legacy** et **QBCore**.

## Installation

1. Place le dossier `hexa_hud` dans le dossier `resources` du serveur.
2. Place la ressource après le framework et les ressources de statut dans `server.cfg` :

```cfg
ensure es_extended # ou qb-core
ensure esx_status  # ESX uniquement, si utilisé
ensure hexa_hud
```

3. Modifie `config.lua` pour les couleurs, l’unité de vitesse et les éléments visibles.

La langue se règle avec `Config.Language = 'fr'` ou `Config.Language = 'en'`.

`Config.Show` définit les modules disponibles globalement : un module sur `false` est désactivé pour tout le monde. Avec `Config.AllowPlayerVisibility = true`, chaque joueur peut masquer et réactiver les modules autorisés depuis `/hudsettings`.

Les blocs listés dans `Config.FixedModules` gardent leur position d'origine pour tous. Le bloc `location` est fixe par défaut.

Le framework est détecté automatiquement. La ressource lit `esx_status` pour ESX et les métadonnées natives pour QBCore.

## Commandes

- `/togglehud` ou `F10` : masquer/afficher le HUD.
- `B` : activer/désactiver la ceinture.
- `/hudsettings` : ouvrir le menu personnel centré — échelle, couleur, modules visibles, quatre styles de compteur dont une gauge circulaire, unité, opacité et placement des blocs à la souris. Un bref message « ✓ Enregistré » confirme la sauvegarde. Les préférences sont conservées localement pour chaque joueur (et sur le serveur, sans base SQL, si `Config.ServerSettings` est actif).

## Fonctions avancées

- Profils Immersion, Racing, Minimal, Police et Discret (masque les blocs non essentiels pour un HUD réduit au minimum).
- Couleur d'aiguille, zone rouge, voyants, alertes et ordinateur de trajet configurables.
- Voyants moteur, phares, clignotants, frein à main, portes et régulateur.
- Alertes contextuelles pour santé, oxygène, carburant, ceinture, moteur, température et pneus.
- Notifications de ceinture via `hexa_notify`, avec confirmation et délai anti-spam configurable.
- Distance, durée du trajet et chronomètre 0–100 km/h.
- Mode électrique via les State Bags `isElectric`/`electric`, `battery` et `range`.
- Mode police via `radarFront`, `radarRear`, `radarPlate` et la sirène native.
- Éditeur avec grille magnétique ; clic droit pour restaurer un module seulement.
- Sauvegarde serveur KVP activable avec `Config.ServerSettings` sans base SQL.

Toutes ces fonctions peuvent être désactivées dans `Config.Features`, `Config.Show` et `Config.Alerts`.

Les jauges inutiles sont contextuelles : armure vide masquée, endurance masquée au repos, oxygène visible sous l'eau et besoins masqués lorsqu'aucun système compatible n'est détecté. Ces règles sont configurables dans `Config.AutoHide`.

Le thème défini dans `Config.Theme` et `Config.Colors` est exposé aux ressources `hexa_notify` et `hexa_police` afin de conserver une identité visuelle commune. Le HUD affiche également l'état de service publié par `hexa_police`.

La minimap GTA d'origine est affichée en véhicule. Sa texture, sa forme et sa position ne sont pas modifiées par le HUD afin de préserver sa compatibilité.

## Compatibilité voix et carburant

Le témoin vocal utilise l’état natif FiveM et affiche `LocalPlayer.state.radioChannel` lorsqu’une ressource radio le publie. Le carburant repose sur `GetVehicleFuelLevel`, compatible avec les systèmes qui synchronisent le niveau natif du véhicule.

`Config.FuelSystem = 'auto'` détecte automatiquement `ox_fuel` ou `LegacyFuel`, puis utilise le niveau natif GTA si aucun système dédié n'est installé.

## Aperçu

Ouvre `html/index.html` dans un navigateur pour afficher automatiquement des données de démonstration.
