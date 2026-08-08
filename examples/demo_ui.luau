--!strict
-- Vespera UI Showcase Demo
-- Features Obsidian Black & Neon Purple theme with Toggles, Sliders, Dropdowns, Keybinds, Color Pickers, and Performance Modes

local VesperaUI = require(script.Parent.Parent:FindFirstChild("library"):FindFirstChild("severe_ui") or "library/severe_ui.luau")

-- Create Vespera Window
local Window = VesperaUI:CreateWindow({
    Title = "VESPERA",
    Subtitle = "Severe External UI v1.0",
    Size = Vector2.new(520, 360),
    Position = Vector2.new(200, 180),
    Keybind = Enum.KeyCode.RightShift
})

-- 1. Visuals Tab
local VisualsTab = Window:CreateTab("Visuals")

VisualsTab:CreateToggle({
    Name = "Enable Player ESP",
    Default = true,
    Callback = function(state)
        print("[Demo] ESP Toggled:", state)
    end
})

VisualsTab:CreateToggle({
    Name = "Show 3D Bounding Boxes",
    Default = true,
    Callback = function(state)
        print("[Demo] 3D Boxes Toggled:", state)
    end
})

VisualsTab:CreateColorPicker({
    Name = "ESP Box Accent Color",
    Default = Color3.fromRGB(168, 85, 247),
    Callback = function(color)
        print("[Demo] Color Changed:", color)
    end
})

VisualsTab:CreateSlider({
    Name = "ESP Max Render Distance",
    Min = 50,
    Max = 2000,
    Default = 1000,
    Step = 50,
    Callback = function(dist)
        print("[Demo] Max Distance:", dist)
    end
})

-- 2. Combat Tab
local CombatTab = Window:CreateTab("Combat")

CombatTab:CreateToggle({
    Name = "Enable Smooth Aimbot",
    Default = false,
    Callback = function(state)
        print("[Demo] Aimbot Toggled:", state)
    end
})

CombatTab:CreateDropdown({
    Name = "Target Hitbox",
    Options = { "Head", "Torso", "HumanoidRootPart", "Nearest" },
    Default = "Head",
    Callback = function(selected)
        print("[Demo] Hitbox Selected:", selected)
    end
})

CombatTab:CreateSlider({
    Name = "Aimbot Smoothness",
    Min = 1,
    Max = 10,
    Default = 5,
    Step = 1,
    Callback = function(smooth)
        print("[Demo] Smoothness:", smooth)
    end
})

CombatTab:CreateKeybind({
    Name = "Aimbot Activation Key",
    Default = Enum.KeyCode.E,
    Callback = function(key)
        print("[Demo] Keybind Set:", key.Name)
    end
})

-- 3. Memory Tab
local MemoryTab = Window:CreateTab("Memory Engine")

MemoryTab:CreateToggle({
    Name = "Enable RTTI Inspection",
    Default = true,
    Callback = function(state)
        print("[Demo] RTTI Toggled:", state)
    end
})

MemoryTab:CreateToggle({
    Name = "Real-Time Offset Change Hooks",
    Default = true,
    Callback = function(state)
        print("[Demo] Memory Hooks Toggled:", state)
    end
})

send_notification("Vespera Demo Active! Press RIGHT SHIFT to toggle UI.")
