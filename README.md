# 🕶️ SERVERBLIGHT Utility Script

![Lua](https://img.shields.io/badge/Language-Lua-blue?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Active-success?style=for-the-badge)

A multifunctional utility script designed for the fan-made Roblox game **SERVERBLIGHT**. 
This project aims to enhance the survival experience for the Red Team by providing essential visual overlays and automation tools to counter the Serverblight entity.

> ⚠️ **DISCLAIMER:** This project is created **strictly for educational purposes**. Using third-party software (exploits) violates the Roblox Terms of Service. The author is not responsible for any account bans or penalties. Use at your own risk.

---

## ✨ Features

- **🌓 Fullbright** — Instantly removes fog, disables global shadows, and maximizes brightness. Perfect for spotting monsters hiding in dark corners.
- **👁️ Advanced ESP (Wallhack)** — Highlights entities through walls for full situational awareness:
  - 🟢 **Green:** Red Team (Allies).
  - 🔴 **Red:** Serverblight / Monsters.
- **🩺 Health Bars** — Compact health indicators displayed above the heads of players and monsters. Turns red when health is low.
- **⚡ Teleportation System** — Quickly reposition yourself:
  - Teleport directly to the Red Base (Coordinates can be configured).
- **🎨 Modern UI** — Built with the Rayfield Gen2 library. Features a custom dark-purple theme, smooth animations, and draggable windows.
- **🤖 Auto-Intel (In Development)** — Fully automates the objective:
  - *Coming soon: Will check for Intel spawn, teleport to it, pick it up, and deliver it to the base.*

---

## 🚀 Installation & Usage

1. Launch **Roblox** and join the SERVERBLIGHT game.
2. Open your preferred script executor (Delta, Fluxus, Wave, Synapse, etc.).
3. Open the `main.lua` file in this repository.
4. Copy all the code and paste it into your executor.
5. Click **Execute**. The UI will appear in the center of your screen.

---

## ⚙️ Configuration

All core settings are located at the very top of `main.lua`. If a feature stops working, the game developers likely changed the object names or map layout. You can update them here:

```lua
local Config = {
    MONSTER_NAMES = {"Serverblight", "Blight"},
    BASE_POSITION = Vector3.new(0, 0, 0), -- Set your Red Base coordinates here
    
    -- Toggles
    ESP_PLAYERS = true,
    ESP_MONSTERS = true,
    SHOW_HEALTH = true,
    FULLBRIGHT_ENABLED = true,
}