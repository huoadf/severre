--!strict
-- Vespera UI Standalone Bundle (Zero-Dependency Single File)
-- Theme: Obsidian Black & Neon Purple

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

-- 1. Embedded Vector Polyfill Engine
local VectorUtil = {}
function VectorUtil.Magnitude(v: any): number
    local x, y, z = v.X or 0, v.Y or 0, v.Z or 0
    return math.sqrt((x * x) + (y * y) + (z * z))
end

function VectorUtil.Unit(v: any): any
    local mag = VectorUtil.Magnitude(v)
    if mag == 0 then return if v.Z ~= nil then Vector3.new(0, 0, 0) else Vector2.new(0, 0) end
    if v.Z ~= nil then return Vector3.new(v.X / mag, v.Y / mag, v.Z / mag) else return Vector2.new(v.X / mag, v.Y / mag) end
end

function VectorUtil.Dot(v1: any, v2: any): number
    return ((v1.X or 0) * (v2.X or 0)) + ((v1.Y or 0) * (v2.Y or 0)) + ((v1.Z or 0) * (v2.Z or 0))
end

function VectorUtil.Lerp(v1: any, v2: any, alpha: number): any
    local t = math.clamp(alpha, 0, 1)
    return v1 + ((v2 - v1) * t)
end

-- 2. Embedded Vespera UI Engine
local VesperaUI = {
    Version = "1.0.0",
    Themes = {
        ObsidianPurple = {
            Background = Color3.fromRGB(12, 10, 18),
            CardBackground = Color3.fromRGB(21, 18, 33),
            HeaderBackground = Color3.fromRGB(28, 23, 44),
            Accent = Color3.fromRGB(168, 85, 247),
            AccentHover = Color3.fromRGB(192, 132, 252),
            Border = Color3.fromRGB(46, 38, 64),
            TextPrimary = Color3.fromRGB(245, 243, 255),
            TextMuted = Color3.fromRGB(160, 150, 180),
            ToggleOff = Color3.fromRGB(35, 30, 50),
        }
    },
    Settings = {
        AnimationMode = "Smooth",
        SmartFPSLimit = 60,
        KeybindToggle = Enum.KeyCode.RightShift,
    }
}

function VesperaUI:CreateWindow(config: any)
    local theme = VesperaUI.Themes.ObsidianPurple
    local titleText = config.Title or "VESPERA"
    local subtitleText = config.Subtitle or "Severe Standalone Edition"
    local windowSize = config.Size or Vector2.new(520, 360)
    local windowPos = config.Position or Vector2.new(150, 150)
    local toggleKey = config.Keybind or VesperaUI.Settings.KeybindToggle

    local windowState = { Open = true, Position = windowPos, Size = windowSize, CurrentTab = 1, Tabs = {} }

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

    if typeof(block_roblox_window) == "function" then block_roblox_window(true) end
    if typeof(send_notification) == "function" then send_notification("Vespera UI Loaded | Theme: Obsidian Purple") end

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
        if typeof(block_roblox_window) == "function" then block_roblox_window(visible) end
        for _, tab in ipairs(windowState.Tabs) do
            tab:UpdateVisibility(visible and tab.Index == windowState.CurrentTab)
        end
    end

    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then WindowAPI:SetVisible(not windowState.Open) end
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

        local TabAPI = { Index = tabIndex, Name = tabName, Elements = {}, YOffset = 50 }
        function TabAPI:UpdateVisibility(visible: boolean)
            TabBtn.Color = if windowState.CurrentTab == tabIndex then theme.HeaderBackground else theme.CardBackground
            TabLabel.Color = if windowState.CurrentTab == tabIndex then theme.Accent else theme.TextMuted
            for _, el in ipairs(TabAPI.Elements) do el:SetVisible(visible) end
        end

        function TabAPI:CreateToggle(toggleCfg: any)
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
            function ToggleAPI:SetVisible(visible: boolean) Box.Visible = visible; Label.Visible = visible end
            function ToggleAPI:SetValue(val: boolean) isToggled = val; Box.Color = if isToggled then theme.Accent else theme.ToggleOff; toggleCfg.Callback(isToggled) end

            table.insert(TabAPI.Elements, ToggleAPI)
            TabAPI.YOffset += 28
            return ToggleAPI
        end

        function TabAPI:CreateSlider(sliderCfg: any)
            local elY = windowPos.Y + TabAPI.YOffset
            local elX = windowPos.X + 145
            local min, max, val = sliderCfg.Min or 0, sliderCfg.Max or 100, sliderCfg.Default or (sliderCfg.Min or 0)

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

            local pct = math.clamp((val - min) / (max - min), 0, 1)
            local Fill = Drawing.new("Square")
            Fill.Size = Vector2.new(math.floor(340 * pct), 8)
            Fill.Position = Vector2.new(elX, elY + 20)
            Fill.Color = theme.Accent
            Fill.Filled = true
            Fill.Visible = (tabIndex == windowState.CurrentTab)

            local SliderAPI = {}
            function SliderAPI:SetVisible(visible: boolean) Label.Visible = visible; Track.Visible = visible; Fill.Visible = visible end
            table.insert(TabAPI.Elements, SliderAPI)
            TabAPI.YOffset += 38
            return SliderAPI
        end

        table.insert(windowState.Tabs, TabAPI)
        return TabAPI
    end

    return WindowAPI
end

-- 3. Execute Showcase Demo
local Window = VesperaUI:CreateWindow({ Title = "VESPERA", Subtitle = "Severe Standalone v1.0" })
local MainTab = Window:CreateTab("Main Visuals")
MainTab:CreateToggle({ Name = "Enable ESP Visuals", Default = true, Callback = function(s) print("ESP:", s) end })
MainTab:CreateSlider({ Name = "Max Distance", Min = 100, Max = 2000, Default = 1000, Callback = function(v) print("Distance:", v) end })

if typeof(send_notification) == "function" then
    send_notification("Vespera Standalone UI Active! Press RightShift to toggle.")
end
