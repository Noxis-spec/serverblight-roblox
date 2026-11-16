# SERVERBLIGHT Utility Script

![Lua](https://img.shields.io/badge/Language-Lua-blue?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

A multifunctional utility script designed for the fan-made Roblox game **SERVERBLIGHT**. 
This project aims to enhance the survival experience for the Red Team by providing essential visual overlays and automation tools to counter the Serverblight entity.

> **DISCLAIMER:** This project is created **strictly for educational purposes**. Using third-party software (exploits) violates the Roblox Terms of Service. The author is not responsible for any account bans or penalties. Use at your own risk.

---

## Features

- **Fullbright:** Instantly removes fog, disables global shadows, and maximizes brightness. Perfect for spotting monsters hiding in dark corners.
- **Advanced ESP (Wallhack):** Highlights entities through walls for full situational awareness:
  - **Green:** Red Team (Allies).
  - **Red:** Serverblight / Monsters.
- **Health Bars:** Compact health indicators displayed above the heads of players and monsters. Turns red when health is low.
- **Teleportation System:** Quickly reposition yourself.
  - Teleport directly to the Red Base (Coordinates can be configured).
- **Modern UI:** Built with the Rayfield Gen2 library. Features a custom dark-purple theme, smooth animations, and draggable windows.
- **Auto-Intel (In Development):** Fully automates the objective.
  - *Coming soon: Will check for Intel spawn, teleport to it, pick it up, and deliver it to the base.*

---

## Quick Start (Loadstring)

The easiest way to use the script is to run it directly from GitHub using a `loadstring`. No need to copy the entire code manually.

1. Launch **Roblox** and join the SERVERBLIGHT game.
2. Open your preferred script executor (Delta, Fluxus, Wave, Synapse, etc.).
3. Paste the following line into the executor and press **Execute**:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Noxis-spec/serverblight-roblox/main/main.lua"))()