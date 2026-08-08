# Vespera UI - Severe External Luau VM Library

A modern, high-performance **Obsidian Black & Neon Purple** external UI library built specifically for Severe's Luau VM drawing engine and input capture system (`block_roblox_window`).

---

## 🎨 Design & Aesthetic Highlights

- **Palette**: Obsidian Black (`#0c0a12`), Dark Violet Cards (`#151221`), Neon Purple Accents (`#a855f7`), Bright Violet Hover (`#c084fc`).
- **Input Capture**: Integrates with `block_roblox_window(true)` to capture keyboard & mouse input seamlessly when open.
- **Performance Modes**:
  - **Smooth**: Interpolated animations.
  - **Minimal**: Subtle transition effects.
  - **Performance Mode**: Zero animations for lowest possible overlay latency and maximum FPS.

---

## 📦 Component Overview

| Component | Description | Example Usage |
| :--- | :--- | :--- |
| `CreateWindow` | Initializes window frame, title, subtitle, toggle key, and sidebar. | `VesperaUI:CreateWindow({ Title = "VESPERA" })` |
| `CreateTab` | Adds a new category tab in the navigation sidebar. | `Window:CreateTab("Visuals")` |
| `CreateToggle` | Smooth switch for boolean features. | `Tab:CreateToggle({ Name = "ESP", Callback = fn })` |
| `CreateSlider` | Value range slider with step resolution. | `Tab:CreateSlider({ Min = 0, Max = 100, Step = 5 })` |
| `CreateDropdown` | Option selection list. | `Tab:CreateDropdown({ Options = { "Head", "Torso" } })` |
| `CreateKeybind` | Keybind assignment listener. | `Tab:CreateKeybind({ Default = Enum.KeyCode.E })` |
| `CreateColorPicker` | Custom color picker widget with preset palettes. | `Tab:CreateColorPicker({ Default = Color3.new() })` |

---

## 🚀 Quick Start Example

```luau
local VesperaUI = require("library/severe_ui.luau")

local Window = VesperaUI:CreateWindow({
    Title = "VESPERA",
    Subtitle = "Severe External",
    Keybind = Enum.KeyCode.RightShift
})

local VisualsTab = Window:CreateTab("Visuals")

VisualsTab:CreateToggle({
    Name = "Player ESP",
    Default = true,
    Callback = function(enabled)
        print("ESP Enabled:", enabled)
    end
})

VisualsTab:CreateSlider({
    Name = "Max Render Distance",
    Min = 100,
    Max = 2000,
    Default = 1000,
    Step = 50,
    Callback = function(val)
        print("Distance:", val)
    end
})
```

---

## 📂 Repository Structure

```
severre/
├── README.md
├── library/
│   └── severe_ui.luau        # Core Vespera UI Library
├── examples/
│   └── demo_ui.luau          # Showcase Demo Script
├── types/
│   └── severe.d.luau        # Full Luau Type Definitions
└── scripts/
    ├── esp_framework.luau   # Dynamic 3D ESP Framework
    ├── aimbot_helper.luau   # Relative Mouse Aimbot
    ├── memory_inspector.luau# RTTI & Offset Inspector
    └── severe_suite_runner.luau # UNC & SNC Benchmark Runner
```

---

## 🐙 Git Release & Push Instructions

To push this repository to your GitHub account:

```bash
git add .
git commit -m "feat: Add Vespera Obsidian & Neon Purple UI Library for Severe"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/YOUR_REPOSITORY.git
git push -u origin main
```
