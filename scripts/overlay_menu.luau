--!strict
-- Severe External Overlay Menu & UI Template
-- Demonstrates input blocking (`block_roblox_window`) & Drawing primitive UI elements

local UserInputService = game:GetService("UserInputService")

local MenuState = {
    Open = false,
    ToggleKey = Enum.KeyCode.Insert,
}

-- UI Container Drawing Primitives
local Background = Drawing.new("Square")
Background.Visible = false
Background.Size = Vector2.new(300, 220)
Background.Position = Vector2.new(100, 100)
Background.Color = Color3.fromRGB(20, 22, 28)
Background.Filled = true
Background.Transparency = 0.95

local HeaderBar = Drawing.new("Square")
HeaderBar.Visible = false
HeaderBar.Size = Vector2.new(300, 30)
HeaderBar.Position = Vector2.new(100, 100)
HeaderBar.Color = Color3.fromRGB(40, 44, 56)
HeaderBar.Filled = true

local TitleText = Drawing.new("Text")
TitleText.Visible = false
TitleText.Text = "SEVERE OVERLAY MENU v1.0"
TitleText.Size = 14
TitleText.Color = Color3.fromRGB(0, 255, 170)
TitleText.Position = Vector2.new(115, 107)

local StatusText = Drawing.new("Text")
StatusText.Visible = false
StatusText.Text = "FPS: 60 | Status: Active"
StatusText.Size = 13
StatusText.Color = Color3.fromRGB(200, 200, 200)
StatusText.Position = Vector2.new(115, 145)

local function SetMenuVisible(visible: boolean)
    MenuState.Open = visible
    Background.Visible = visible
    HeaderBar.Visible = visible
    TitleText.Visible = visible
    StatusText.Visible = visible
    
    -- Block or unblock Roblox window input pass-through
    block_roblox_window(visible)
    
    if visible then
        send_notification("Overlay Menu Opened (Input Captured)")
    else
        send_notification("Overlay Menu Closed (Roblox Input Restored)")
    end
end

-- Toggle Key Listener
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.KeyCode == MenuState.ToggleKey then
        SetMenuVisible(not MenuState.Open)
    end
end)

-- Update Overlay Stats
task.spawn(function()
    while true do
        if MenuState.Open then
            StatusText.Text = string.format("Overlay FPS: %d | Rss: Active", get_overlay_fps())
        end
        task.wait(0.2)
    end
end)

send_notification("Severe Overlay Menu Script Loaded (Press INSERT to Toggle)")
