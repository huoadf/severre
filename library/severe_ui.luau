--!strict
-- Vespera UI Library for Severe External Luau VM
-- Theme: Obsidian Black & Neon Purple
-- Fully Draggable, Resizable, Layered with ZIndex & Mouse Tab Switching

local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local VectorUtil
if typeof(dofile) == "function" and typeof(isfile) == "function" and isfile("library/vector_polyfill.luau") then
    VectorUtil = dofile("library/vector_polyfill.luau")
elseif typeof(readfile) == "function" and typeof(isfile) == "function" and isfile("library/vector_polyfill.luau") then
    VectorUtil = loadstring(readfile("library/vector_polyfill.luau"))()
else
    VectorUtil = {
        Magnitude = function(v) return math.sqrt((v.X or 0)^2 + (v.Y or 0)^2 + (v.Z or 0)^2) end,
        Unit = function(v) local m = math.sqrt((v.X or 0)^2 + (v.Y or 0)^2 + (v.Z or 0)^2); return if m == 0 then v else v / m end,
        Dot = function(v1, v2) return (v1.X * v2.X) + (v1.Y * v2.Y) + ((v1.Z or 0) * (v2.Z or 0)) end,
        Lerp = function(v1, v2, a) return v1 + ((v2 - v1) * math.clamp(a, 0, 1)) end
    }
end

local VesperaUI = {
    Version = "1.1.0",
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
        AnimationMode = "Smooth",
        SmartFPSLimit = 60,
        KeybindToggle = Enum.KeyCode.RightShift,
    }
}

function VesperaUI:CreateWindow(config: any)
    local theme = VesperaUI.Themes.ObsidianPurple
    local titleText = config.Title or "VESPERA"
    local subtitleText = config.Subtitle or "Severe External Edition"
    local windowSize = config.Size or Vector2.new(540, 370)
    local windowPos = config.Position or Vector2.new(150, 150)
    local toggleKey = config.Keybind or VesperaUI.Settings.KeybindToggle

    local windowState = {
        Open = true,
        Position = windowPos,
        Size = windowSize,
        CurrentTab = 1,
        Tabs = {},
        IsDragging = false,
        DragOffset = Vector2.new(0, 0),
        IsResizing = false,
        ResizeStartMouse = Vector2.new(0, 0),
        ResizeStartSize = windowSize,
    }

    -- 1. Root Background Frame (ZIndex = 1)
    local MainFrame = Drawing.new("Square")
    MainFrame.Size = windowSize
    MainFrame.Position = windowPos
    MainFrame.Color = theme.Background
    MainFrame.Filled = true
    MainFrame.Transparency = 0.98
    MainFrame.ZIndex = 1
    MainFrame.Visible = true

    -- 2. Outer Border (ZIndex = 2)
    local Border = Drawing.new("Square")
    Border.Size = windowSize + Vector2.new(2, 2)
    Border.Position = windowPos - Vector2.new(1, 1)
    Border.Color = theme.Border
    Border.Filled = false
    Border.Thickness = 1.5
    Border.ZIndex = 2
    Border.Visible = true

    -- 3. Header Bar (ZIndex = 3)
    local Header = Drawing.new("Square")
    Header.Size = Vector2.new(windowSize.X, 42)
    Header.Position = windowPos
    Header.Color = theme.HeaderBackground
    Header.Filled = true
    Header.ZIndex = 3
    Header.Visible = true

    -- 4. Accent Line (ZIndex = 4)
    local AccentBar = Drawing.new("Square")
    AccentBar.Size = Vector2.new(windowSize.X, 2)
    AccentBar.Position = windowPos + Vector2.new(0, 40)
    AccentBar.Color = theme.Accent
    AccentBar.Filled = true
    AccentBar.ZIndex = 4
    AccentBar.Visible = true

    -- 5. Title Text (ZIndex = 10)
    local TitleLabel = Drawing.new("Text")
    TitleLabel.Text = titleText
    TitleLabel.Size = 16
    TitleLabel.Color = theme.Accent
    TitleLabel.Position = windowPos + Vector2.new(15, 12)
    TitleLabel.ZIndex = 10
    TitleLabel.Visible = true

    -- 6. Subtitle Text (ZIndex = 10)
    local SubtitleLabel = Drawing.new("Text")
    SubtitleLabel.Text = "  |  " .. subtitleText
    SubtitleLabel.Size = 13
    SubtitleLabel.Color = theme.TextMuted
    SubtitleLabel.Position = windowPos + Vector2.new(95, 14)
    SubtitleLabel.ZIndex = 10
    SubtitleLabel.Visible = true

    -- 7. Sidebar Background (ZIndex = 3)
    local Sidebar = Drawing.new("Square")
    Sidebar.Size = Vector2.new(135, math.max(100, windowSize.Y - 42))
    Sidebar.Position = windowPos + Vector2.new(0, 42)
    Sidebar.Color = theme.CardBackground
    Sidebar.Filled = true
    Sidebar.ZIndex = 3
    Sidebar.Visible = true

    -- 8. Sidebar Divider (ZIndex = 4)
    local SidebarDivider = Drawing.new("Square")
    SidebarDivider.Size = Vector2.new(1, math.max(100, windowSize.Y - 42))
    SidebarDivider.Position = windowPos + Vector2.new(135, 42)
    SidebarDivider.Color = theme.Border
    SidebarDivider.Filled = true
    SidebarDivider.ZIndex = 4
    SidebarDivider.Visible = true

    -- 9. Resize Grip Handle in Bottom-Right Corner (ZIndex = 10)
    local ResizeGrip = Drawing.new("Square")
    ResizeGrip.Size = Vector2.new(12, 12)
    ResizeGrip.Position = windowPos + windowSize - Vector2.new(14, 14)
    ResizeGrip.Color = theme.Accent
    ResizeGrip.Filled = true
    ResizeGrip.ZIndex = 10
    ResizeGrip.Visible = true

    if typeof(block_roblox_window) == "function" then
        block_roblox_window(true)
    end
    if typeof(send_notification) == "function" then
        pcall(function()
            send_notification("Vespera UI", "Vespera UI Loaded successfully!")
        end)
    end

    local WindowAPI = {}

    local function LayoutUI()
        local pos = windowState.Position
        local sz = windowState.Size

        MainFrame.Position = pos
        MainFrame.Size = sz

        Border.Position = pos - Vector2.new(1, 1)
        Border.Size = sz + Vector2.new(2, 2)

        Header.Position = pos
        Header.Size = Vector2.new(sz.X, 42)

        AccentBar.Position = pos + Vector2.new(0, 40)
        AccentBar.Size = Vector2.new(sz.X, 2)

        TitleLabel.Position = pos + Vector2.new(15, 12)
        SubtitleLabel.Position = pos + Vector2.new(95, 14)

        Sidebar.Position = pos + Vector2.new(0, 42)
        Sidebar.Size = Vector2.new(135, math.max(100, sz.Y - 42))

        SidebarDivider.Position = pos + Vector2.new(135, 42)
        SidebarDivider.Size = Vector2.new(1, math.max(100, sz.Y - 42))

        ResizeGrip.Position = pos + sz - Vector2.new(14, 14)

        -- Update Tabs Position & Elements Position/Size
        for i, tab in ipairs(windowState.Tabs) do
            local tabY = pos.Y + 48 + ((i - 1) * 36)
            tab.TabBtn.Position = Vector2.new(pos.X + 5, tabY)
            tab.TabLabel.Position = Vector2.new(pos.X + 15, tabY + 8)

            for _, el in ipairs(tab.Elements) do
                el:UpdateLayout(pos, sz)
            end
        end
    end

    function WindowAPI:UpdateTabVisibilities()
        for i, tab in ipairs(windowState.Tabs) do
            local isCurrent = (i == windowState.CurrentTab)
            tab.TabBtn.Color = if isCurrent then theme.HeaderBackground else theme.CardBackground
            tab.TabLabel.Color = if isCurrent then theme.Accent else theme.TextMuted
            for _, el in ipairs(tab.Elements) do
                el:SetVisible(windowState.Open and isCurrent)
            end
        end
    end

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
        ResizeGrip.Visible = visible

        if typeof(block_roblox_window) == "function" then
            block_roblox_window(visible)
        end

        WindowAPI:UpdateTabVisibilities()
    end

    -- Toggle Keybind Listener
    UserInputService.InputBegan:Connect(function(input)
        if input.KeyCode == toggleKey then
            WindowAPI:SetVisible(not windowState.Open)
        end
    end)

    -- Mouse Input Listener (Click & Drag & Resize Handle Start)
    UserInputService.InputBegan:Connect(function(input)
        if windowState.Open and input.UserInputType == Enum.UserInputType.MouseButton1 then
            local mPos = UserInputService:GetMouseLocation()
            local pos = windowState.Position
            local sz = windowState.Size

            -- 1. Check Resize Grip Click (Bottom-Right 16x16 box)
            if mPos.X >= (pos.X + sz.X - 16) and mPos.X <= (pos.X + sz.X) and
               mPos.Y >= (pos.Y + sz.Y - 16) and mPos.Y <= (pos.Y + sz.Y) then
                windowState.IsResizing = true
                windowState.ResizeStartMouse = mPos
                windowState.ResizeStartSize = sz
                return
            end

            -- 2. Check Header Bar Click (Dragging Start)
            if mPos.X >= pos.X and mPos.X <= (pos.X + sz.X) and
               mPos.Y >= pos.Y and mPos.Y <= (pos.Y + 42) then
                windowState.IsDragging = true
                windowState.DragOffset = mPos - pos
                return
            end

            -- 3. Check Tab Button Clicks
            for i, tab in ipairs(windowState.Tabs) do
                local btnPos = tab.TabBtn.Position
                local btnSize = tab.TabBtn.Size
                if mPos.X >= btnPos.X and mPos.X <= (btnPos.X + btnSize.X) and
                   mPos.Y >= btnPos.Y and mPos.Y <= (btnPos.Y + btnSize.Y) then
                    windowState.CurrentTab = i
                    WindowAPI:UpdateTabVisibilities()
                    break
                end
            end
        end
    end)

    -- Mouse Button Release Listener
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            windowState.IsDragging = false
            windowState.IsResizing = false
        end
    end)

    -- Continuous RenderStepped Drag & Resize Loop
    RunService.RenderStepped:Connect(function()
        if not windowState.Open then return end
        local mPos = UserInputService:GetMouseLocation()

        if windowState.IsDragging then
            windowState.Position = mPos - windowState.DragOffset
            LayoutUI()
        elseif windowState.IsResizing then
            local delta = mPos - windowState.ResizeStartMouse
            local newX = math.max(420, windowState.ResizeStartSize.X + delta.X)
            local newY = math.max(260, windowState.ResizeStartSize.Y + delta.Y)
            windowState.Size = Vector2.new(newX, newY)
            LayoutUI()
        end
    end)

    function WindowAPI:CreateTab(tabName: string)
        local tabIndex = #windowState.Tabs + 1
        local tabYPos = windowPos.Y + 48 + ((tabIndex - 1) * 36)

        local TabBtn = Drawing.new("Square")
        TabBtn.Size = Vector2.new(125, 32)
        TabBtn.Position = Vector2.new(windowPos.X + 5, tabYPos)
        TabBtn.Color = if tabIndex == 1 then theme.HeaderBackground else theme.CardBackground
        TabBtn.Filled = true
        TabBtn.ZIndex = 8
        TabBtn.Visible = true

        local TabLabel = Drawing.new("Text")
        TabLabel.Text = tabName
        TabLabel.Size = 14
        TabLabel.Color = if tabIndex == 1 then theme.Accent else theme.TextMuted
        TabLabel.Position = Vector2.new(windowPos.X + 15, tabYPos + 8)
        TabLabel.ZIndex = 10
        TabLabel.Visible = true

        local TabAPI = {
            Index = tabIndex,
            Name = tabName,
            TabBtn = TabBtn,
            TabLabel = TabLabel,
            Elements = {},
            YOffset = 52,
        }

        function TabAPI:CreateToggle(toggleCfg: any)
            local relYOffset = TabAPI.YOffset
            local isToggled = toggleCfg.Default or false

            local Box = Drawing.new("Square")
            Box.Size = Vector2.new(18, 18)
            Box.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset)
            Box.Color = if isToggled then theme.Accent else theme.ToggleOff
            Box.Filled = true
            Box.ZIndex = 10
            Box.Visible = (tabIndex == windowState.CurrentTab)

            local Label = Drawing.new("Text")
            Label.Text = toggleCfg.Name
            Label.Size = 14
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(windowPos.X + 178, windowPos.Y + relYOffset + 1)
            Label.ZIndex = 10
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local ToggleAPI = {}
            function ToggleAPI:SetVisible(visible: boolean)
                Box.Visible = visible
                Label.Visible = visible
            end

            function ToggleAPI:UpdateLayout(wPos: Vector2, wSize: Vector2)
                Box.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset)
                Label.Position = Vector2.new(wPos.X + 178, wPos.Y + relYOffset + 1)
            end

            function ToggleAPI:SetValue(val: boolean)
                isToggled = val
                Box.Color = if isToggled then theme.Accent else theme.ToggleOff
                toggleCfg.Callback(isToggled)
            end

            -- Click listener for toggle
            UserInputService.InputBegan:Connect(function(input)
                if windowState.Open and windowState.CurrentTab == tabIndex and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mPos = UserInputService:GetMouseLocation()
                    local boxPos = Box.Position
                    if mPos.X >= boxPos.X and mPos.X <= (boxPos.X + 180) and
                       mPos.Y >= boxPos.Y and mPos.Y <= (boxPos.Y + 20) then
                        ToggleAPI:SetValue(not isToggled)
                    end
                end
            end)

            table.insert(TabAPI.Elements, ToggleAPI)
            TabAPI.YOffset += 30
            return ToggleAPI
        end

        function TabAPI:CreateSlider(sliderCfg: any)
            local relYOffset = TabAPI.YOffset
            local min = sliderCfg.Min or 0
            local max = sliderCfg.Max or 100
            local val = sliderCfg.Default or min
            local isSliding = false

            local Label = Drawing.new("Text")
            Label.Text = string.format("%s: %d", sliderCfg.Name, val)
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset)
            Label.ZIndex = 10
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local TrackWidth = math.max(150, windowState.Size.X - 190)
            local Track = Drawing.new("Square")
            Track.Size = Vector2.new(TrackWidth, 8)
            Track.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset + 20)
            Track.Color = theme.ToggleOff
            Track.Filled = true
            Track.ZIndex = 10
            Track.Visible = (tabIndex == windowState.CurrentTab)

            local pct = math.clamp((val - min) / (max - min), 0, 1)
            local Fill = Drawing.new("Square")
            Fill.Size = Vector2.new(math.floor(TrackWidth * pct), 8)
            Fill.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset + 20)
            Fill.Color = theme.Accent
            Fill.Filled = true
            Fill.ZIndex = 11
            Fill.Visible = (tabIndex == windowState.CurrentTab)

            local SliderAPI = {}
            function SliderAPI:SetVisible(visible: boolean)
                Label.Visible = visible
                Track.Visible = visible
                Fill.Visible = visible
            end

            function SliderAPI:UpdateLayout(wPos: Vector2, wSize: Vector2)
                local tw = math.max(150, wSize.X - 190)
                Label.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset)
                Track.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset + 20)
                Track.Size = Vector2.new(tw, 8)
                local fp = math.clamp((val - min) / (max - min), 0, 1)
                Fill.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset + 20)
                Fill.Size = Vector2.new(math.floor(tw * fp), 8)
            end

            function SliderAPI:SetValue(newVal: number)
                val = math.clamp(newVal, min, max)
                Label.Text = string.format("%s: %d", sliderCfg.Name, val)
                local tw = math.max(150, windowState.Size.X - 190)
                local fillPct = (val - min) / (max - min)
                Fill.Size = Vector2.new(math.floor(tw * fillPct), 8)
                sliderCfg.Callback(val)
            end

            -- Interactive Slider Dragging
            UserInputService.InputBegan:Connect(function(input)
                if windowState.Open and windowState.CurrentTab == tabIndex and input.UserInputType == Enum.UserInputType.MouseButton1 then
                    local mPos = UserInputService:GetMouseLocation()
                    local tPos = Track.Position
                    local tw = Track.Size.X
                    if mPos.X >= tPos.X and mPos.X <= (tPos.X + tw) and
                       mPos.Y >= (tPos.Y - 5) and mPos.Y <= (tPos.Y + 15) then
                        isSliding = true
                        local relativeX = math.clamp(mPos.X - tPos.X, 0, tw)
                        local calculatedVal = math.floor(min + ((relativeX / tw) * (max - min)))
                        SliderAPI:SetValue(calculatedVal)
                    end
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then isSliding = false end
            end)

            RunService.RenderStepped:Connect(function()
                if isSliding and windowState.Open and windowState.CurrentTab == tabIndex then
                    local mPos = UserInputService:GetMouseLocation()
                    local tPos = Track.Position
                    local tw = Track.Size.X
                    local relativeX = math.clamp(mPos.X - tPos.X, 0, tw)
                    local calculatedVal = math.floor(min + ((relativeX / tw) * (max - min)))
                    SliderAPI:SetValue(calculatedVal)
                end
            end)

            table.insert(TabAPI.Elements, SliderAPI)
            TabAPI.YOffset += 40
            return SliderAPI
        end

        function TabAPI:CreateDropdown(dropCfg: any)
            local relYOffset = TabAPI.YOffset
            local selected = dropCfg.Default or (dropCfg.Options[1] or "None")

            local Label = Drawing.new("Text")
            Label.Text = dropCfg.Name .. ": [" .. selected .. "]"
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset)
            Label.ZIndex = 10
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local DropAPI = {}
            function DropAPI:SetVisible(visible: boolean) Label.Visible = visible end
            function DropAPI:UpdateLayout(wPos: Vector2, wSize: Vector2)
                Label.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset)
            end
            function DropAPI:SetSelected(option: string)
                selected = option
                Label.Text = dropCfg.Name .. ": [" .. selected .. "]"
                dropCfg.Callback(selected)
            end

            table.insert(TabAPI.Elements, DropAPI)
            TabAPI.YOffset += 28
            return DropAPI
        end

        function TabAPI:CreateKeybind(keyCfg: any)
            local relYOffset = TabAPI.YOffset
            local key = keyCfg.Default or Enum.KeyCode.E

            local Label = Drawing.new("Text")
            Label.Text = string.format("%s: [%s]", keyCfg.Name, key.Name)
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset)
            Label.ZIndex = 10
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local KeyAPI = {}
            function KeyAPI:SetVisible(visible: boolean) Label.Visible = visible end
            function KeyAPI:UpdateLayout(wPos: Vector2, wSize: Vector2)
                Label.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset)
            end

            table.insert(TabAPI.Elements, KeyAPI)
            TabAPI.YOffset += 28
            return KeyAPI
        end

        function TabAPI:CreateColorPicker(colorCfg: any)
            local relYOffset = TabAPI.YOffset
            local currentColor = colorCfg.Default or theme.Accent

            local Label = Drawing.new("Text")
            Label.Text = colorCfg.Name
            Label.Size = 13
            Label.Color = theme.TextPrimary
            Label.Position = Vector2.new(windowPos.X + 150, windowPos.Y + relYOffset)
            Label.ZIndex = 10
            Label.Visible = (tabIndex == windowState.CurrentTab)

            local ColorBox = Drawing.new("Square")
            ColorBox.Size = Vector2.new(24, 14)
            ColorBox.Position = Vector2.new(windowPos.X + 330, windowPos.Y + relYOffset + 1)
            ColorBox.Color = currentColor
            ColorBox.Filled = true
            ColorBox.ZIndex = 10
            ColorBox.Visible = (tabIndex == windowState.CurrentTab)

            local ColorAPI = {}
            function ColorAPI:SetVisible(visible: boolean)
                Label.Visible = visible
                ColorBox.Visible = visible
            end
            function ColorAPI:UpdateLayout(wPos: Vector2, wSize: Vector2)
                Label.Position = Vector2.new(wPos.X + 150, wPos.Y + relYOffset)
                ColorBox.Position = Vector2.new(wPos.X + 330, wPos.Y + relYOffset + 1)
            end

            table.insert(TabAPI.Elements, ColorAPI)
            TabAPI.YOffset += 28
            return ColorAPI
        end

        table.insert(windowState.Tabs, TabAPI)
        return TabAPI
    end

    return WindowAPI
end

return VesperaUI
