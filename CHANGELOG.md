# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Planned
- Auto-Intel module (Teleport to Intel, Pick up, Teleport to Base).
- Teleport to specific death zones / Void.
- Configuration saving for object names.

## [1.0.0] - 2024-05-24

### Added
- **Core:** Initial public release of the SERVERBLIGHT utility.
- **UI:** Integrated Rayfield Gen2 library for a modern, draggable interface with a custom dark-purple theme.
- **Visuals:** 
  - `Fullbright` toggle (removes fog, disables shadows, max brightness).
  - `ESP Players` toggle (Green for allies, Red for enemies).
  - `ESP Monsters` toggle (Purple highlights for Serverblight models).
- **Player:**
  - `Teleport to Base` button (configured via `BASE_POSITION` in `main.lua`).
- **Utility:** Added `scripts/dump_names.lua` to help users find updated object names after game patches.