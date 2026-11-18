# SERVERBLIGHT Utility Hub

A multifunctional utility script hub designed for the fan-made Roblox game **SERVERBLIGHT**. 
This project provides essential visual overlays, survival tools, and automated farming for the Red Team.

> **DISCLAIMER:** This project is created **strictly for educational purposes**. Using third-party software (exploits) violates the Roblox Terms of Service. The author is not responsible for any account bans or penalties. Use at your own risk.

---

## Features

- **Modular Map System:** Dedicated scripts for each map to ensure coordinates and safe zones work flawlessly.
- **Visuals:**
  - **Fullbright:** Removes fog and darkness.
  - **ESP:** Highlights allies (Red), enemies (Blue), and monsters (Purple) through walls.
  - **Health Bars:** Compact HP indicators above heads.
  - **Item ESP:** Highlights medkits, ammo boxes, and resupply crates.
- **Farm:**
  - **Auto-Intel:** Automatically teleports to the enemy intel, picks it up, and delivers it to the Red base.
  - **Safe Zone Platform:** Creates an invisible platform in the air to safely wait between cycles.
- **Utility:**
  - **Smart Infinite Ammo:** Keeps your ammo topped up without breaking the game's reload logic.
  - **Noclip:** Fly through walls and objects.
  - **Custom Max Health:** Set your HP up to 1000.
- **Modern UI:** Built with the Rayfield library, featuring a sleek design and smooth animations.

---

## Quick Start (Loadstring)

To load the main hub and choose your map script:

1. Launch **Roblox** and join the SERVERBLIGHT game.
2. Open your preferred script executor (Delta, Fluxus, Arceus X, etc.).
3. Paste the following line and press **Execute**:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/serverblight-roblox/main/main.lua"))()