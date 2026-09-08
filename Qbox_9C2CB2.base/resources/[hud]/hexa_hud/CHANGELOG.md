# Changelog — Hexa HUD

## 1.1.0 — 2026-08-29

### Corrigé
- Le HUD pouvait rester invisible pour les joueurs QBCore après un chargement de personnage (l'état de visibilité n'était pas réappliqué).
- Faute de frappe dans le nom de texture du cache minimap (`radarmask1g` au lieu de `radarmasklg`), pouvant laisser un résidu visuel selon la résolution.
- Le panneau de réglages et le mode de placement des blocs pouvaient rester bloqués ouverts dans certains enchaînements de fermeture.
- Le glisser-déposer de la minimap en mode édition ne répondait pas.
- Écouteur de fin de glisser manquant pour les événements pointeur annulés (ex. changement de fenêtre pendant un déplacement), pouvant laisser un bloc « collé » au curseur.
- Les réglages envoyés au serveur (`Config.ServerSettings`) n'étaient pas validés : un client modifié pouvait envoyer des clés arbitraires ou un payload excessif.

### Ajouté
- Confirmation visuelle « ✓ Enregistré » lors de la sauvegarde des réglages.
- Profil « Discret » en plus d'Immersion, Racing, Minimal et Police.
- Nettoyage et consolidation du CSS des jauges (aucun changement visuel).

## 1.0.0
Version initiale.
