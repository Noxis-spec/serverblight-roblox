# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased] - 2026-11-18

### Added
- **Modular Map System:** Created the `maps/` directory to separate scripts for different maps.
- **Doublecross Script (`maps/doublecross.lua`):** Added a dedicated script for `ctf_doublecross` and `ctf_doublecrossday` with specific safe zone coordinates and an invisible platform.
- **2Fort Script (`maps/2fort.lua`):** Added a dedicated script for `ctf_2fort` (and its night/wartorn variants) with specific safe zone coordinates and an invisible platform.
- **Main Hub (`main.lua`):** Created a script hub menu that allows the user to load specific map scripts via buttons.
- **Invisible Platform:** The scripts now automatically create an invisible Part (20x1x20) under the safe zone coordinates to prevent the player from falling into the void.

### Changed
- **Safe Zone Detection:** Abandoned the attempt to detect maps via `game.PlaceId` or `SubPlaces` (as the game uses a single Place ID for all maps). Replaced with a modular approach where the user selects the script for their current map.
- **UI Template:** Cleaned up the main hub UI to feature standard tabs: Main, Visuals, Farm, Teleports, Utility, Configs, and Credits.

### Fixed
- **Auto-Farm Looping Bug:** Fixed an issue where the script would endlessly teleport the player between the safe zone and the Red Intel even if the Blue Intel was not picked up or present on the map.

---

## [0.9.0] - 2026-11-17

### Added
- **Infinite Ammo (Smart):** Implemented a system that allows the magazine (`Ammo`) to deplete, but automatically refills it when it gets low, keeping `TotalAmmo` infinite.
- **Health Slider:** Added a slider in the UI to set `Humanoid.MaxHealth` from 0 to 1000.
- **ESP Items:** Added ESP highlighting for map items like `SmallHP`, `LargeAmmo`, and `Resupply`.
- **Rayfield Gen2 Integration:** Switched from basic Rayfield to Rayfield Gen2 for a smoother, modern UI with a custom dark-purple theme.

### Changed
- **ESP Outlines:** Replaced `BoxHandleAdornment` with `Highlight` (using `FillTransparency = 1`) to create clean outlines that ignore invisible hitboxes.
- **Health Bars:** Redesigned health bars to look modern (rounded corners, black outline, numbers inside) similar to Pulse Hub for MM2.

---

## [0.5.0] - 2026-11-16

### Added
- **Rayfield UI:** Initial integration of the Rayfield library to create a draggable, modern interface.
- **Auto-Intel (Beta):** Added the first logic to teleport to the Blue intel and drop it at the Red base.
- **Safe Zone Teleport:** Added a button to teleport to a specific safe zone coordinate.
- **Fullbright:** Added a toggle to remove fog and maximize lighting.
- **Basic ESP:** Added basic player and monster highlighting (Red for allies, Blue for enemies).

### Fixed
- Initial repository setup and file structuring (`.gitignore`, `LICENSE`, `README.md`).
- Fixed issues with the script failing to load on mobile executors (like Arceus X).

---

## [0.1.0] - 2026-11-16

### Added
- **Initial Release:** First version of the SERVERBLIGHT Utility.
- **Basic ESP:** Highlighted players and monsters with simple boxes.
- **Teleport to Base:** Simple teleportation feature.
- **MIT License:** Added to the repository for open-source distribution.