# 🕶️ SERVERBLIGHT Utility Script

![Lua](https://img.shields.io/badge/Language-Lua-blue?style=for-the-badge&logo=lua)
![Roblox](https://img.shields.io/badge/Platform-Roblox-red?style=for-the-badge)
![Status](https://img.shields.io/badge/Status-Work_In_Progress-yellow?style=for-the-badge)

A multifunctional utility script designed for the fan-made Roblox game **SERVERBLIGHT**. 
This project aims to enhance the survival experience for the Red Team by providing essential visual overlays and automation tools to counter the Blue Team and the Serverblight entity.

> ⚠️ **DISCLAIMER:** This project is created **strictly for educational purposes**. Using third-party software (exploits) violates the Roblox Terms of Service. The author is not responsible for any account bans or penalties. Use at your own risk.

---

## ✨ Features

- **🌓 Fullbright** — Instantly removes fog, disables global shadows, and maximizes brightness. Perfect for spotting monsters hiding in dark corners.
- **👁️ Advanced ESP (Wallhack)** — Highlights entities through walls for full situational awareness:
  - 🟢 **Green:** Red Team (Allies).
  - 🔴 **Red:** Blue Team (Enemies).
  - 🟣 **Purple:** Serverblight / Monsters.
- **⚡ Teleportation System** — Quickly reposition yourself:
  - Teleport to specific players.
  - Teleport to death zones (for quick escapes).
  - Teleport directly to the Intel or the Red Base.
- **🤖 Auto-Intel (Farming)** — Fully automates the objective:
  - Checks for Intel spawn every second.
  - Teleports to the Intel, picks it up, and teleports back to the Red Base to capture.
  - Optionally returns to the previous position after a successful capture.

---

## 🚀 Installation & Usage

1. Launch **Roblox** and join the SERVERBLIGHT game.
2. Open your preferred script executor (Delta, Fluxus, Wave, Synapse, etc.).
3. Copy the contents of `src/main.lua`.
4. Paste the code into the executor and click **Execute**.
5. (Optional) Adjust object names and coordinates in `src/config.lua` if the game has been updated.

---

## ⚙️ Configuration

All core settings are located in `src/config.lua`. If a feature stops working, the game developers likely changed the object names. You can update them here:

```lua
return {
    -- Object Names (Use dump_names.lua to find them)
    INTEL_NAME = "Intel", 
    MONSTER_NAMES = {"Serverblight", "Blight"},
    
    -- Coordinates
    BASE_POSITION = Vector3.new(0, 0, 0), -- Red Base coordinates
    
    -- Toggles
    ESP_ENABLED = true,
    AUTO_INTEL_ENABLED = false,
    FULLBRIGHT_ENABLED = true,
}