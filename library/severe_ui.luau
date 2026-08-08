--!strict
-- Vespera UI Library for Severe External Luau VM
-- Theme: Obsidian Black & Neon Purple
-- Author: Antigravity

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- Safe Severe External Module Loader for VectorUtil
local VectorUtil
if typeof(dofile) == "function" and typeof(isfile) == "function" and isfile("library/vector_polyfill.luau") then
    VectorUtil = dofile("library/vector_polyfill.luau")
elseif typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("library/vector_polyfill.luau") then
    VectorUtil = loadstring(readfile("library/vector_polyfill.luau"))()
elseif typeof(game) == "userdata" and typeof(game.HttpGet) == "function" then
    VectorUtil = loadstring(game:HttpGet("https://raw.githubusercontent.com/huoadf/severre/master/library/vector_polyfill.luau"))()
else
    -- Embedded Fallback Vector Utilities
    VectorUtil = {
        Magnitude = function(v) return math.sqrt((v.X or 0)^2 + (v.Y or 0)^2 + (v.Z or 0)^2) end,
        Unit = function(v) local m = math.sqrt((v.X or 0)^2 + (v.Y or 0)^2 + (v.Z or 0)^2); return if m == 0 then v else v / m end,
        Dot = function(v1, v2) return (v1.X * v2.X) + (v1.Y * v2.Y) + ((v1.Z or 0) * (v2.Z or 0)) end,
        Lerp = function(v1, v2, a) return v1 + ((v2 - v1) * math.clamp(a, 0, 1)) end
    }
end

local VesperaUI = {
    Version = "1.0.0",
    Themes = {
        ObsidianPurple = {
            Background = Color3.fromRGB(12, 10, 18),
            CardBackground = Color3.fromRGB(21, 18, 33),
            HeaderBackground = Color3.fromRGB(28, 23, 44),
            Accent = Color3.fromRGB(168, 85, 247),       -- Neon Purple (#a855f7)
            AccentHover = Color3.fromRGB(192, 132, 252),  -- Bright Violet
            Border = Color3.fromRGB(46, 38, 64),
            TextPrimary = Color3.fromRGB(245, 243, 255),
            TextMuted = Color3.fromRGB(160, 150, 180),
            ToggleOff = Color3.fromRGB(35, 30, 50),
        }
    },
    Settings = {
        AnimationMode = "Smooth", -- "Smooth", "Minimal", "Performance" (No Anims)
        SmartFPSLimit = 60,
        KeybindToggle = Enum.KeyCode.RightShift,
    }
}

type WindowConfig = {
    Title: string?,
    Subtitle: string?,
    Size: Vector2?,
    Position: Vector2?,
    Keybind: Enum.KeyCode?,
}

type ToggleConfig = {
    Name: string,
    Default: boolean?,
    Callback: (state: boolean) -> (),
}

type SliderConfig = {
    Name: string,
    Min: number,
    Max: number,
    Default: number?,
    Step: number?,
    Callback: (value: number) -> (),
}

type DropdownConfig = {
    Name: string,
    Options: { string },
    Default: string?,
    Callback: (selected: string) -> (),
}

type KeybindConfig = {
    Name: string,
    Default: Enum.KeyCode?,
    Callback: (key: Enum.KeyCode) -> (),
}

type ColorPickerConfig = {
    Name: string,
    Default: Color3?,
    Callback: (color: Color3) -> (),
}

function VesperaUI:CreateWindow(config: WindowConfig)
    local theme = VesperaUI.Themes.ObsidianPurple
    local titleText = config.Title or "VESPERA"
    local subtitleText = config.Subtitle or "Severe External Edition"
    local windowSize = config.Size or Vector2.new(520, 360)
    local windowPos = config.Position or Vector2.new(150, 150)
    local toggleKey = config.Keybind or VesperaUI.Settings.KeybindToggle

    local windowState = {
        Open = true,
        Position = windowPos,
        Size = windowSize,
        CurrentTab = 1,
        Tabs = {},
        Elements = {},
    }

    -- Root Drawing Elements
    local MainFrame = Drawing.new("Square")
    MainFrame.Size = windowSize
    MainFrame.Position = windowPos
    MainFrame.Color = theme.Background
    MainFrame.Filled = true
    MainFrame.Transparency = 0.96
    MainFrame.Visible = true

    local Border = Drawing.new("Square")
    Border.Size = windowSize + Vector2.new(2, 2)
    Border.Position = windowPos - Vector2.new(1, 1)
    Border.Color = theme.Border
    Border.Filled = false
    Border.Thickness = 1.5
    Border.Visible = true

    local Header = Drawing.new("Square")
    Header.Size = Vector2.new(windowSize.X, 40)
    Header.Position = windowPos
    Header.Color = theme.HeaderBackground
    Header.Filled = true
    Header.Visible = true

    local AccentBar = Drawing.new("Square")
    AccentBar.Size = Vector2.new(windowSize.X, 2)
    AccentBar.Position = windowPos + Vector2.new(0, 38)
    AccentBar.Color = theme.Accent
    AccentBar.Filled = true
    AccentBar.Visible = true

    local TitleLabel = Drawing.new("Text")
    TitleLabel.Text = titleText
    TitleLabel.Size = 16
    TitleLabel.Color = theme.Accent
    TitleLabel.Position = windowPos + Vector2.new(15, 11)
    TitleLabel.Visible = true

    local SubtitleLabel = Drawing.new("Text")
    SubtitleLabel.Text = "  |  " .. subtitleText
    SubtitleLabel.Size = 13
    SubtitleLabel.Color = theme.TextMuted
    SubtitleLabel.Position = windowPos + Vector2.new(90, 13)
    SubtitleLabel.Visible = true

    -- Sidebar background for tabs
    local Sidebar = Drawing.new("Square")
    Sidebar.Size = Vector2.new(130, windowSize.Y - 40)
    Sidebar.Position = windowPos + Vector2.new(0, 40)
    Sidebar.Color = theme.CardBackground
    Sidebar.Filled = true
    Sidebar.Visible = true

    local SidebarDivider = Drawing.new("Square")
    SidebarDivider.Size = Vector2.new(1, windowSize.Y - 40)
    SidebarDivider.Position = windowPos + Vector2.new(130, 40)
    SidebarDivider.Color = theme.Border
    SidebarDivider.Filled = true
    SidebarDivider.Visible = true

    -- Input Pass-through capture initial state
    block_roblox_window(true)
    if typeof(send_notification) == "function" then
        send_notification("Vespera UI Loaded | Theme: Obsidian Purple")
    end

    -- Window Methods
    local WindowAPI = {}

    function WindowAPI:SetVisible(visible: boolean)
        windowState.Open = visible
        MainFrame.Visible = visible
        Border.Visible = visible
        Header.Visible = visible
        AccentBar.Visible = visible
        TitleLabel.Visible = visible
        SubtitleLabel.Visible = visible
        Sidebar.Visible = visible
        SidebarDivider.Visible = visible

        -- Toggle input pass-through for Severe overlay
        if typeof(block_roblox_window) == "function" then
            block_roblox_window(visible)
        end

        for _, tab in ipairs(windowState.Tabs) do
            tab:UpdateVisibility(visible and tab.Index == windowState.CurrentTab)
        end
    end

    -- Keybind listener to open/close menu
    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if input.KeyCode == toggleKey then
            WindowAPI:SetVisible(not windowState.Open)
        end
    end)

    function WindowAPI:CreateTab(tabName: string)
        local tabIndex = #windowState.Tabs + 1
        local tabYPos = windowPos.Y + 45 + ((tabIndex - 1) * 35)

        local TabBtn = Drawing.new("Square")
        TabBtn.Size = Vector2.new(120, 30)
        TabBtn.Position = Vector2.new(windowPos.X + 5, tabYPos)
        TabBtn.Color = if tabIndex == 1 then theme.HeaderBackground else theme.CardBackground
        TabBtn.Filled = true
        TabBtn.Visible = true

        local TabLabel = Drawing.new("Text")
        TabLabel.Text = tabName
        TabLabel.Size = 14
        TabLabel.Color = if tabIndex == 1 then theme.Accent else theme.TextMuted
        TabLabel.Position = Vector2.new(windowPos.X + 15, tabYPos + 7)
        TabLabel.Visible = true

        local TabAPI = {
            Index = tabIndex,
            Name = tabName,
            Elements = {},
            YOffset = 50,
        }

        function TabAPI:UpdateVisibility(visible: boolean)
            TabBtn.Color = if windowState.CurrentTab == tabIndex then theme.HeaderBackground else theme.CardBackground
            TabLabel.Color = if windowState.CurrentTab == tabIndex then theme.Accent else theme.TextMuted
            
            for _, el in ipairs(TabAPI.Elements) do
                el:SetVisible(visible)
            end
        end

        -- Component Generators inside Tab
        function TabAPI:CreateToggle(toggleCfg: ToggleConfig)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local isToggled = toggleCfg.Default or false

            local Box = Drawing.new("Square")
            Box.Size = Vector2.new(18, 18)
            Box.Position = Vector2.new(elX, elY)
            Box.Color = if isToggled then theme.Accent else theme.ToggleOff
            Box.Filled = true
            Box.Visible = (tabIndex == windowState.CurrentTab)

            local Label = Drawing.new("Text")
            Label.Text = toggleCfg.Name
            Label.Size = 14
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(elX + 28, elY + 1)
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local ToggleAPI = {}
            function ToggleAPI:SetVisible(visible: boolean)
                Box.Visible = visible
                Label.Visible = visible
            end

            function ToggleAPI:SetValue(val: boolean)
                isToggled = val
                Box.Color = if isToggled then theme.Accent else theme.ToggleOff
                toggleCfg.Callback(isToggled)
            end

            table.insert(TabAPI.Elements, ToggleAPI)
            TabAPI.YOffset += 28
            return ToggleAPI
        end

        function TabAPI:CreateSlider(sliderCfg: SliderConfig)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local min = sliderCfg.Min or 0
            local max = sliderCfg.Max or 100
            local val = sliderCfg.Default or min
            local step = sliderCfg.Step or 1

            local Label = Drawing.new("Text")
            Label.Text = string.format("%s: %d", sliderCfg.Name, val)
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(elX, elY)
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local Track = Drawing.new("Square")
            Track.Size = Vector2.new(340, 8)
            Track.Position = Vector2.new(elX, elY + 20)
            Track.Color = theme.ToggleOff
            Track.Filled = true
            Track.Visible = (tabIndex == windowState.CurrentTab)

            local FillPct = math.clamp((val - min) / (max - min), 0, 1)
            local Fill = Drawing.new("Square")
            Fill.Size = Vector2.new(math.floor(340 * FillPct), 8)
            Fill.Position = Vector2.new(elX, elY + 20)
            Fill.Color = theme.Accent
            Fill.Filled = true
            Fill.Visible = (tabIndex == windowState.CurrentTab)

            local SliderAPI = {}
            function SliderAPI:SetVisible(visible: boolean)
                Label.Visible = visible
                Track.Visible = visible
                Fill.Visible = visible
            end

            function SliderAPI:SetValue(newVal: number)
                val = math.clamp(newVal, min, max)
                Label.Text = string.format("%s: %d", sliderCfg.Name, val)
                local pct = (val - min) / (max - min)
                Fill.Size = Vector2.new(math.floor(340 * pct), 8)
                sliderCfg.Callback(val)
            end

            table.insert(TabAPI.Elements, SliderAPI)
            TabAPI.YOffset += 38
            return SliderAPI
        end

        function TabAPI:CreateDropdown(dropCfg: DropdownConfig)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local selected = dropCfg.Default or (dropCfg.Options[1] or "None")

            local Label = Drawing.new("Text")
            Label.Text = dropCfg.Name .. ": [" .. selected .. "]"
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(elX, elY)
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local DropAPI = {}
            function DropAPI:SetVisible(visible: boolean)
                Label.Visible = visible
            end

            function DropAPI:SetSelected(option: string)
                selected = option
                Label.Text = dropCfg.Name .. ": [" .. selected .. "]"
                dropCfg.Callback(selected)
            end

            table.insert(TabAPI.Elements, DropAPI)
            TabAPI.YOffset += 26
            return DropAPI
        end

        function TabAPI:CreateKeybind(keyCfg: KeybindConfig)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local key = keyCfg.Default or Enum.KeyCode.E

            local Label = Drawing.new("Text")
            Label.Text = string.format("%s: [%s]", keyCfg.Name, key.Name)
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(elX, elY)
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local KeyAPI = {}
            function KeyAPI:SetVisible(visible: boolean)
                Label.Visible = visible
            end

            table.insert(TabAPI.Elements, KeyAPI)
            TabAPI.YOffset += 26
            return KeyAPI
        end

        function TabAPI:CreateColorPicker(colorCfg: ColorPickerConfig)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local currentColor = colorCfg.Default or theme.Accent

            local Label = Drawing.new("Text")
            Label.Text = colorCfg.Name
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(elX, elY)
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local ColorBox = Drawing.new("Square")
            ColorBox.Size = Vector2.new(24, 14)
            ColorBox.Position = Vector2.new(elX + 180, elY + 1)
            ColorBox.Color = currentColor
            ColorBox.Filled = true
            ColorBox.Visible = (tabIndex == windowState.CurrentTab)

            local ColorAPI = {}
            function ColorAPI:SetVisible(visible: boolean)
                Label.Visible = visible
                ColorBox.Visible = visible
            end

            function ColorAPI:SetColor(newCol: Color3)
                currentColor = newCol
                ColorBox.Color = newCol
                colorCfg.Callback(newCol)
            end

            table.insert(TabAPI.Elements, ColorAPI)
            TabAPI.YOffset += 26
            return ColorAPI
        end

        table.insert(windowState.Tabs, TabAPI)
        return TabAPI
    end

    -- Create Built-in Settings Tab
    local SettingsTab = WindowAPI:CreateTab("Settings")

    SettingsTab:CreateDropdown({
        Name = "Animation Quality",
        Options = { "Smooth", "Minimal", "Performance (No Anims)" },
        Default = "Smooth",
        Callback = function(mode)
            VesperaUI.Settings.AnimationMode = mode
            if typeof(send_notification) == "function" then
                send_notification("Animation Mode: " .. mode)
            end
        end
    })

    SettingsTab:CreateSlider({
        Name = "Smart Overlay FPS Limit",
        Min = 30,
        Max = 240,
        Default = 60,
        Step = 10,
        Callback = function(fps)
            VesperaUI.Settings.SmartFPSLimit = fps
        end
    })

    SettingsTab:CreateToggle({
        Name = "Save Config on Close",
        Default = true,
        Callback = function(saveState)
            if saveState and typeof(writefile) == "function" then
                local configData = {
                    AnimMode = VesperaUI.Settings.AnimationMode,
                    FPSLimit = VesperaUI.Settings.SmartFPSLimit
                }
                if typeof(crypt) == "table" and typeof(crypt.json) == "table" then
                    writefile("vespera_config.json", crypt.json.encode(configData))
                end
            end
        end
    })

    return WindowAPI
end

return VesperaUI
