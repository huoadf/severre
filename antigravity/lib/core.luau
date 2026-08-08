--!strict
-- â•”â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•—
-- â•‘              AntiGravity UI Library  Â·  v1.0                    â•‘
-- â•‘              Severe API â€” Native Only                            â•‘
-- â•‘              github.com/antigravity                              â•‘
-- â•šâ•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--
-- Severe API reference: https://v-severe.gitbook.io/landing/llms-full.txt
--
-- All 18 audit fixes applied (see AUDIT_FIXES.md in same folder).
-- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")

local LocalPlayer  = Players.LocalPlayer
local _localName   = LocalPlayer and LocalPlayer.Name        or "Unknown"
local _localDisp   = LocalPlayer and LocalPlayer.DisplayName or "Unknown"

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  COLOUR PALETTE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local C = {
    WinBg        = Color3.fromRGB( 12,  12,  16),
    Sidebar      = Color3.fromRGB(  8,   8,  11),
    Panel        = Color3.fromRGB( 18,  18,  24),
    PanelBorder  = Color3.fromRGB( 32,  32,  42),
    TabActive    = Color3.fromRGB( 24,  24,  32),
    Input        = Color3.fromRGB( 22,  22,  30),
    InputBorder  = Color3.fromRGB( 38,  38,  50),
    DropBg       = Color3.fromRGB( 14,  14,  18),
    DropBorder   = Color3.fromRGB( 42,  42,  56),
    DropHover    = Color3.fromRGB( 28,  28,  38),
    TrackOff     = Color3.fromRGB( 40,  40,  52),
    KnobOff      = Color3.fromRGB(100, 100, 115),
    Accent       = Color3.fromRGB(255,  77,  77),
    AccentDim    = Color3.fromRGB(160,  46,  46),
    KnobOn       = Color3.fromRGB(245, 245, 250),
    TxtPrimary   = Color3.fromRGB(235, 235, 242),
    TxtMuted     = Color3.fromRGB(130, 130, 148),
    TxtCategory  = Color3.fromRGB( 85,  85, 105),
    KeybindBg    = Color3.fromRGB( 30,  30,  40),
    BtnBg        = Color3.fromRGB( 32,  32,  44),
    BtnBorder    = Color3.fromRGB( 50,  50,  68),
    BtnHover     = Color3.fromRGB( 44,  44,  62),
    ResizeGrip   = Color3.fromRGB( 70,  70,  90),
    AvatarBg     = Color3.fromRGB( 50,  50,  65),
    Separator    = Color3.fromRGB( 28,  28,  38),
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  ZINDEX TIERS
--  Lower = behind, higher = in front.
--  Dropdown popup sits at Z=80+ so it ALWAYS renders above sections.
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local Z = {
    WinBg      = 10,
    Sidebar    = 12,
    SidebarFg  = 14,
    Content    = 16,
    SectionBg  = 18,
    ElemBg     = 20,
    ElemFg     = 22,
    ElemKnob   = 24,
    ElemText   = 26,
    Watermark  = 28,
    DropBg     = 80,
    DropItem   = 82,
    DropText   = 84,
}

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  DRAWING POOL
--  Pools grow on-demand.  On every allocation ALL properties are
--  reset to clean defaults to prevent bleed between reuses.
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local Pool = {
    squares = {},
    texts   = {},
    circles = {},
    sqIdx   = 0,
    txtIdx  = 0,
    circIdx = 0,
}

local function ResetPoolCounters()
    Pool.sqIdx   = 0
    Pool.txtIdx  = 0
    Pool.circIdx = 0
end

local function AcquireSquare(z: number)
    Pool.sqIdx += 1
    local p = Pool.squares
    if not p[Pool.sqIdx] then
        local sq = Drawing.new("Square")
        sq.Visible = false
        p[Pool.sqIdx] = sq
    end
    local sq = p[Pool.sqIdx]
    sq.Visible   = true
    sq.Filled    = true
    sq.Thickness = 1
    sq.Rounding  = 0
    sq.Opacity   = 1
    sq.ZIndex    = z
    return sq
end

local function AcquireText(z: number)
    Pool.txtIdx += 1
    local p = Pool.texts
    if not p[Pool.txtIdx] then
        local t = Drawing.new("Text")
        t.Visible = false
        p[Pool.txtIdx] = t
    end
    local t = p[Pool.txtIdx]
    t.Visible      = true
    t.Outline      = false
    t.OutlineColor = Vector3.new(0, 0, 0)
    t.Center       = false
    t.Opacity      = 1
    t.ZIndex       = z
    return t
end

local function AcquireCircle(z: number)
    Pool.circIdx += 1
    local p = Pool.circles
    if not p[Pool.circIdx] then
        local c = Drawing.new("Circle")
        c.Visible = false
        p[Pool.circIdx] = c
    end
    local c = p[Pool.circIdx]
    c.Visible   = true
    c.Filled    = true
    c.Thickness = 1
    c.Opacity   = 1
    c.ZIndex    = z
    return c
end

local function HidePoolTail()
    for i = Pool.sqIdx + 1, #Pool.squares do
        if Pool.squares[i] then Pool.squares[i].Visible = false end
    end
    for i = Pool.txtIdx + 1, #Pool.texts do
        if Pool.texts[i] then Pool.texts[i].Visible = false end
    end
    for i = Pool.circIdx + 1, #Pool.circles do
        if Pool.circles[i] then Pool.circles[i].Visible = false end
    end
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  DRAW PRIMITIVES
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function Fill(x, y, w, h, col, rounding, z)
    local sq = AcquireSquare(z or Z.Content)
    sq.Position = Vector2.new(x, y)
    sq.Size     = Vector2.new(w, h)
    sq.Color    = col
    sq.Filled   = true
    sq.Rounding = rounding or 0
end

local function Border(x, y, w, h, col, thickness, rounding, z)
    local sq = AcquireSquare(z or Z.Content)
    sq.Position  = Vector2.new(x, y)
    sq.Size      = Vector2.new(w, h)
    sq.Color     = col
    sq.Filled    = false
    sq.Thickness = thickness or 1
    sq.Rounding  = rounding or 0
end

local function Circ(x, y, r, col, z)
    local c = AcquireCircle(z or Z.ElemFg)
    c.Position = Vector2.new(x, y)
    c.Radius   = r
    c.Color    = col
    c.Filled   = true
end

local function Txt(x, y, text, col, size, z, outline)
    local t = AcquireText(z or Z.ElemText)
    t.Position     = Vector2.new(x, y)
    t.Text         = tostring(text)
    t.Color        = col
    t.Size         = size or 13
    t.Outline      = outline or false
    t.OutlineColor = Vector3.new(0, 0, 0)
end

local function Trunc(s, maxC)
    if #s > maxC then return string.sub(s, 1, maxC - 1) .. "..." end
    return s
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  INPUT STATE
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local Input = {
    Mouse        = Vector2.new(0, 0),
    LeftDown     = false,
    LeftClick    = false,
    _WasDown     = false,
    Drag         = false,
    DragOfs      = Vector2.new(0, 0),
    Resize       = false,
    ResizeStart  = { w = 760, h = 480, mx = 0, my = 0 },
    ActiveSlider = nil,
    PrevKeys     = {},
    KeyJustDown  = {},
}

local function _GetMouse()
    if typeof(getmouseposition) == "function" then
        local ok, p = pcall(getmouseposition)
        if ok and p then return Vector2.new(p.x, p.y) end
    end
    return UserInputService:GetMouseLocation()
end

local function _UpdateInput()
    -- Cache mouse once per frame
    Input.Mouse = _GetMouse()

    local down = false
    pcall(function()
        if typeof(isleftpressed) == "function" then
            down = isleftpressed() == true
        else
            down = UserInputService:IsMouseButtonPressed(Enum.MouseButton.MouseButton1)
        end
    end)
    Input.LeftClick = down and not Input._WasDown
    Input.LeftDown  = down
    Input._WasDown  = down

    -- Track key just-pressed events via getpressedkeys()
    local curKeys = {}
    pcall(function()
        if typeof(getpressedkeys) == "function" then
            curKeys = getpressedkeys()
        end
    end)
    local prevSet = {}
    for _, k in ipairs(Input.PrevKeys) do prevSet[k] = true end
    Input.KeyJustDown = {}
    for _, k in ipairs(curKeys) do
        if not prevSet[k] then Input.KeyJustDown[k] = true end
    end
    Input.PrevKeys = curKeys
end

local function InBox(m, x, y, w, h)
    return m.X >= x and m.X <= (x + w) and m.Y >= y and m.Y <= (y + h)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  CONFIG  (sandboxed to C:\v2\workspace)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local CFG_DIR  = "antigravity"
local CFG_FILE = "antigravity/config.json"

local function SaveConfig(flags)
    pcall(function()
        if typeof(isfolder) == "function" and not isfolder(CFG_DIR) then
            makefolder(CFG_DIR)
        end
        local ok, json = pcall(function()
            return HttpService:JSONEncode(flags)
        end)
        if ok then writefile(CFG_FILE, json) end
    end)
end

local function LoadConfig(flags)
    pcall(function()
        if typeof(isfile) == "function" and isfile(CFG_FILE) then
            local ok, data = pcall(function()
                return HttpService:JSONDecode(readfile(CFG_FILE))
            end)
            if ok and type(data) == "table" then
                for k, v in pairs(data) do flags[k] = v end
            end
        end
    end)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  NOTIFICATION  (native Severe overlay toast)
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local function Notify(msg)
    pcall(function()
        if typeof(send_notification) == "function" then
            send_notification(msg)
        end
    end)
end

-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
--  LIBRARY OBJECT
-- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
local AGY = {
    Flags         = {},
    _OpenDropdown = nil,
    _MenuVisible  = true,
    _ToggleKey    = "Insert",
    Version       = "1.0",
}

function AGY:Window(cfg)
    local SIDEBAR_W = 200
    local MIN_W     = 760
    local MIN_H     = 480
    local HEADER_H  = 40

    local win = {
        Title  = cfg.name or "AntiGravity",
        Pos    = Vector2.new(100, 80),
        Size   = Vector2.new(
            math.max(MIN_W, cfg.width  or MIN_W),
            math.max(MIN_H, cfg.height or MIN_H)
        ),
        Tabs   = {},
        CurTab = nil,
    }

    if cfg.toggleKey then AGY._ToggleKey = cfg.toggleKey end

    -- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Tab
    function win:Tab(tcfg)
        local tab = { Name = tcfg.name or "Tab", Sections = {} }
        table.insert(win.Tabs, tab)
        if #win.Tabs == 1 then win.CurTab = tab end

        -- â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€ Section
        function tab:Section(scfg)
            local sec = { Name = scfg.name or "Section", Side = scfg.side or "left", Elements = {} }

            -- Toggle
            function sec:Toggle(ecfg)
                local el = {
                    Type     = "toggle",
                    Name     = ecfg.name or "Toggle",
                    Flag     = ecfg.flag,
                    Value    = ecfg.default or false,
                    Callback = ecfg.callback,
                    HasDots  = ecfg.hasOptions or false,
                    KeyTag   = nil,
                }
                if el.Flag then AGY.Flags[el.Flag] = el.Value end

                function el:Set(v)
                    el.Value = v
                    if el.Flag then AGY.Flags[el.Flag] = v end
                    if el.Callback then pcall(el.Callback, v) end
                    Notify(el.Name .. ": " .. (v and "Enabled" or "Disabled"))
                end

                function el:AddKeybind(kbcfg)
                    el.KeyTag = kbcfg.default or "?"
                    return el
                end

                table.insert(sec.Elements, el)
                return el
            end

            -- Slider
            function sec:Slider(ecfg)
                local el = {
                    Type     = "slider",
                    Name     = ecfg.name or "Slider",
                    Flag     = ecfg.flag,
                    Min      = ecfg.min or 0,
                    Max      = ecfg.max or 100,
                    Value    = ecfg.default or 50,
                    Suffix   = ecfg.suffix or "",
                    Callback = ecfg.callback,
                    _TrackX  = 0,
                    _TrackW  = 1,
                }
                el.Value = math.clamp(el.Value, el.Min, el.Max)
                if el.Flag then AGY.Flags[el.Flag] = el.Value end

                function el:Set(v)
                    el.Value = math.clamp(v, el.Min, el.Max)
                    if el.Flag then AGY.Flags[el.Flag] = el.Value end
                    if el.Callback then pcall(el.Callback, el.Value) end
                end

                table.insert(sec.Elements, el)
                return el
            end

            -- Dropdown
            function sec:Dropdown(ecfg)
                local items = ecfg.options or { "Option 1" }
                local el = {
                    Type     = "dropdown",
                    Name     = ecfg.name or "Dropdown",
                    Flag     = ecfg.flag,
                    Items    = items,
                    Selected = ecfg.default or (items[1] or ""),
                    Callback = ecfg.callback,
                    _BtnX = 0, _BtnY = 0, _BtnW = 108, _BtnH = 22,
                }
                if el.Flag then AGY.Flags[el.Flag] = el.Selected end

                function el:Set(v)
                    el.Selected = v
                    if el.Flag then AGY.Flags[el.Flag] = v end
                    if el.Callback then pcall(el.Callback, v) end
                end

                table.insert(sec.Elements, el)
                return el
            end

            -- Button
            function sec:Button(ecfg)
                local el = {
                    Type     = "button",
                    Name     = ecfg.name or "Button",
                    Callback = ecfg.callback or function() end,
                }
                table.insert(sec.Elements, el)
                return el
            end

            -- Separator
            function sec:Separator()
                table.insert(sec.Elements, { Type = "separator" })
            end

            table.insert(tab.Sections, sec)
            return sec
        end

        return tab
    end

    -- Block Roblox input passthrough
    pcall(function()
        if typeof(block_roblox_window) == "function" then
            block_roblox_window(true)
        end
    end)

    -- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    --  RENDER FUNCTION
    -- â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•â•
    local function Render()
        -- Skip when Roblox not active
        pcall(function()
            if typeof(isrbxactive) == "function" and not isrbxactive() then
                return
            end
        end)

        -- Release block when Severe native menu is open
        pcall(function()
            if typeof(ismenuopened) == "function" and typeof(block_roblox_window) == "function" then
                block_roblox_window(not ismenuopened())
            end
        end)

        ResetPoolCounters()
        _UpdateInput()

        local m = Input.Mouse

        -- Menu toggle key
        if Input.KeyJustDown[AGY._ToggleKey] then
            AGY._MenuVisible = not AGY._MenuVisible
        end

        if not AGY._MenuVisible then HidePoolTail() return end

        local pX, pY = win.Pos.X, win.Pos.Y
        local sW, sH = win.Size.X, win.Size.Y

        -- Resize
        if Input.LeftClick and InBox(m, pX + sW - 20, pY + sH - 20, 20, 20) then
            Input.Resize = true
            Input.ResizeStart = { w = sW, h = sH, mx = m.X, my = m.Y }
        end
        if not Input.LeftDown then Input.Resize = false end
        if Input.Resize then
            win.Size = Vector2.new(
                math.max(MIN_W, Input.ResizeStart.w + (m.X - Input.ResizeStart.mx)),
                math.max(MIN_H, Input.ResizeStart.h + (m.Y - Input.ResizeStart.my))
            )
            sW, sH = win.Size.X, win.Size.Y
        end

        -- Drag
        if Input.LeftClick and not Input.Resize
            and InBox(m, pX + SIDEBAR_W, pY, sW - SIDEBAR_W, HEADER_H) then
            Input.Drag = true
            Input.DragOfs = Vector2.new(m.X - pX, m.Y - pY)
        end
        if not Input.LeftDown then Input.Drag = false end
        if Input.Drag then
            win.Pos = Vector2.new(m.X - Input.DragOfs.X, m.Y - Input.DragOfs.Y)
            pX, pY  = win.Pos.X, win.Pos.Y
        end

        -- Sticky slider drag (release on mouse-up regardless of cursor position)
        if not Input.LeftDown then Input.ActiveSlider = nil end
        if Input.ActiveSlider then
            local sl   = Input.ActiveSlider
            local tW   = math.max(1, sl._TrackW)
            local relX = math.clamp(m.X - sl._TrackX, 0, tW)
            sl:Set(math.floor(sl.Min + (relX / tW) * (sl.Max - sl.Min)))
        end

        -- â”€â”€ Window frame â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        Fill(pX, pY, sW, sH, C.WinBg, 12, Z.WinBg)
        Border(pX, pY, sW, sH, C.PanelBorder, 1, 12, Z.WinBg)

        -- â”€â”€ Sidebar â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        Fill(pX, pY, SIDEBAR_W, sH, C.Sidebar, 12, Z.Sidebar)
        Txt(pX + 16, pY + 16, win.Title, C.TxtPrimary, 14, Z.SidebarFg)
        Fill(pX + 12, pY + 42, SIDEBAR_W - 24, 1, C.Separator, 0, Z.SidebarFg)
        Txt(pX + 16, pY + 52, "UPDATES", C.TxtCategory, 10, Z.SidebarFg)
        Txt(pX + 24, pY + 66, "Changelist", C.TxtMuted, 12, Z.SidebarFg)
        Fill(pX + 12, pY + 92, SIDEBAR_W - 24, 1, C.Separator, 0, Z.SidebarFg)
        Txt(pX + 16, pY + 100, "NAVIGATION", C.TxtCategory, 10, Z.SidebarFg)

        -- Tabs (clipped above profile bar)
        local PROFILE_H = 52
        local TAB_H     = 32
        local TAB_START = pY + 116
        local TAB_MAX_Y = pY + sH - PROFILE_H - 10

        for _, t in ipairs(win.Tabs) do
            local tIdx = _ -- iterator index
            local tY   = TAB_START + ((tIdx - 1) * TAB_H)
            if tY + TAB_H > TAB_MAX_Y then break end

            local isActive = (win.CurTab == t)
            if isActive then
                Fill(pX + 10, tY, SIDEBAR_W - 20, TAB_H - 4, C.TabActive, 6, Z.SidebarFg)
                Fill(pX + 10, tY + 7, 3, 14, C.Accent, 1, Z.SidebarFg + 1)
            end
            Txt(pX + 22, tY + 7, t.Name, isActive and C.TxtPrimary or C.TxtMuted, 12, Z.SidebarFg + 1)

            if Input.LeftClick and InBox(m, pX + 10, tY, SIDEBAR_W - 20, TAB_H - 4) then
                win.CurTab = t
                AGY._OpenDropdown = nil
            end
        end

        -- Profile bar
        local profY = pY + sH - PROFILE_H
        Fill(pX, profY, SIDEBAR_W, PROFILE_H, C.Sidebar, 0, Z.Sidebar)
        Fill(pX + 10, profY, SIDEBAR_W - 20, 1, C.Separator, 0, Z.SidebarFg)
        Circ(pX + 28, profY + 26, 14, C.AvatarBg, Z.SidebarFg)
        Txt(pX + 23, profY + 17, string.upper(string.sub(_localDisp, 1, 1)), C.TxtPrimary, 13, Z.SidebarFg + 1)
        Txt(pX + 48, profY + 12, Trunc(_localDisp, 16), C.TxtPrimary, 12, Z.SidebarFg)
        Txt(pX + 48, profY + 27, "@" .. Trunc(_localName, 14), C.TxtMuted, 10, Z.SidebarFg)
        Txt(pX + SIDEBAR_W - 16, profY + 22, ">", C.TxtMuted, 10, Z.SidebarFg)

        -- FPS watermark
        local fps = 0
        pcall(function()
            if typeof(get_overlay_fps) == "function" then fps = math.floor(get_overlay_fps()) end
        end)
        local wStr = "[AGY] " .. tostring(fps) .. " fps"
        Txt(pX + sW - (#wStr * 6) - 10, pY + 16, wStr, C.TxtCategory, 11, Z.Watermark)

        -- Resize grip
        Txt(pX + sW - 16, pY + sH - 14, "//", C.ResizeGrip, 10, Z.Watermark)

        -- â”€â”€ Content â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
        if win.CurTab then
            local wsX  = pX + SIDEBAR_W + 14
            local wsW  = sW - SIDEBAR_W - 28
            local colW = math.floor(wsW / 2) - 6
            local leftY  = pY + 52
            local rightY = pY + 52

            for _, sec in ipairs(win.CurTab.Sections) do
                local isLeft = (sec.Side ~= "right")
                local secX   = isLeft and wsX or (wsX + colW + 12)
                local secY   = isLeft and leftY or rightY

                local innerH = 10
                for _, el in ipairs(sec.Elements) do
                    innerH += (el.Type == "separator") and 10 or 28
                end
                local boxH = innerH + 10
                local boxY = secY + 18

                Txt(secX + 2, secY, sec.Name, C.TxtMuted, 11, Z.Content)
                Fill(secX, boxY, colW, boxH, C.Panel, 8, Z.SectionBg)
                Border(secX, boxY, colW, boxH, C.PanelBorder, 1, 8, Z.SectionBg)

                local eY = boxY + 10
                for _, el in ipairs(sec.Elements) do

                    if el.Type == "separator" then
                        Fill(secX + 8, eY + 4, colW - 16, 1, C.Separator, 0, Z.ElemBg)
                        eY += 10
                        continue
                    end

                    -- Label for all non-buttons
                    if el.Type ~= "button" then
                        Txt(secX + 12, eY + 5, el.Name, C.TxtPrimary, 11, Z.ElemText)
                    end

                    if el.Type == "toggle" then
                        -- Keybind listening via getpressedkeys()
                        if el.KeyTag and Input.KeyJustDown[el.KeyTag] then
                            el:Set(not el.Value)
                        end

                        -- Keybind badge
                        if el.KeyTag then
                            local lblPx = math.floor(#el.Name * 6.5)
                            local kX    = secX + 14 + lblPx
                            Fill(kX, eY + 5, 18, 14, C.KeybindBg, 3, Z.ElemBg)
                            Txt(kX + 3, eY + 6, el.KeyTag, C.TxtMuted, 9, Z.ElemText)
                        end

                        local pillX = secX + colW - 52
                        if el.HasDots then Txt(pillX - 18, eY + 5, "...", C.TxtMuted, 10, Z.ElemText) end

                        Fill(pillX, eY + 4, 36, 18, el.Value and C.Accent or C.TrackOff, 9, Z.ElemFg)
                        Circ(el.Value and (pillX + 27) or (pillX + 9), eY + 13, 6.5,
                             el.Value and C.KnobOn or C.KnobOff, Z.ElemKnob)

                        if Input.LeftClick and InBox(m, secX + 10, eY, colW - 20, 26) then
                            el:Set(not el.Value)
                        end

                    elseif el.Type == "slider" then
                        local valStr = tostring(el.Value) .. el.Suffix
                        local badgeW = math.max(32, #valStr * 7 + 8)
                        local badgeX = secX + colW - badgeW - 10

                        Fill(badgeX, eY + 3, badgeW, 20, C.Input, 4, Z.ElemBg)
                        Border(badgeX, eY + 3, badgeW, 20, C.InputBorder, 1, 4, Z.ElemBg)
                        Txt(badgeX + 5, eY + 6, valStr, C.TxtPrimary, 10, Z.ElemText)

                        local lblPx = math.floor(#el.Name * 6.5) + 20
                        local tX    = secX + math.min(lblPx, 90)
                        local tW    = math.max(1, badgeX - tX - 6)  -- tW always >= 1

                        el._TrackX = tX
                        el._TrackW = tW

                        Fill(tX, eY + 13, tW, 4, C.TrackOff, 2, Z.ElemFg)

                        local pct   = math.clamp((el.Value - el.Min) / math.max(1, el.Max - el.Min), 0, 1)
                        local fillW = math.max(0, math.floor(tW * pct))
                        if fillW > 0 then Fill(tX, eY + 13, fillW, 4, C.Accent, 2, Z.ElemFg) end
                        Circ(tX + fillW, eY + 15, 6, C.KnobOn, Z.ElemKnob)

                        if Input.LeftClick and not Input.ActiveSlider and InBox(m, tX - 8, eY, tW + 16, 26) then
                            Input.ActiveSlider = el
                        end

                    elseif el.Type == "dropdown" then
                        local bW    = 108
                        local bX    = secX + colW - bW - 10
                        local isOpen = (AGY._OpenDropdown == el)

                        el._BtnX = bX
                        el._BtnY = eY + 2
                        el._BtnW = bW
                        el._BtnH = 22

                        Fill(bX, eY + 2, bW, 22, isOpen and C.TabActive or C.Input, 6, Z.ElemBg)
                        Border(bX, eY + 2, bW, 22, C.InputBorder, 1, 6, Z.ElemBg)
                        Txt(bX + 7, eY + 6, Trunc(tostring(el.Selected), 11), C.TxtPrimary, 11, Z.ElemText)
                        Txt(bX + bW - 12, eY + 7, isOpen and "^" or "v", C.TxtMuted, 9, Z.ElemText)

                        if Input.LeftClick and InBox(m, bX, eY + 2, bW, 22) then
                            AGY._OpenDropdown = isOpen and nil or el
                        end

                    elseif el.Type == "button" then
                        local bW      = colW - 24
                        local bX      = secX + 12
                        local isHover = InBox(m, bX, eY + 2, bW, 22)

                        Fill(bX, eY + 2, bW, 22, isHover and C.BtnHover or C.BtnBg, 6, Z.ElemBg)
                        Border(bX, eY + 2, bW, 22, C.BtnBorder, 1, 6, Z.ElemBg)

                        local lblPx = math.floor(#el.Name * 6.5)
                        local lblX  = bX + math.floor((bW - lblPx) / 2)
                        Txt(lblX, eY + 6, el.Name, C.TxtPrimary, 11, Z.ElemText)

                        if Input.LeftClick and isHover then pcall(el.Callback) end
                    end

                    eY += 28
                end

                if isLeft then leftY  += boxH + 22
                else            rightY += boxH + 22 end
            end
        end

        -- â”€â”€ Dropdown popup â€” rendered LAST at highest ZIndex â”€â”€
        local drop = AGY._OpenDropdown
        if drop then
            local bX, bY, bW, bH = drop._BtnX, drop._BtnY, drop._BtnW, drop._BtnH
            local popH = (#drop.Items * 22) + 6

            -- Flip upward if it would overflow the window bottom
            local popY = bY + bH + 2
            if popY + popH > win.Pos.Y + win.Size.Y - 20 then popY = bY - popH - 2 end

            Fill(bX, popY, bW, popH, C.DropBg, 6, Z.DropBg)
            Border(bX, popY, bW, popH, C.DropBorder, 1, 6, Z.DropBg)

            for i, opt in ipairs(drop.Items) do
                local optY  = popY + 3 + ((i - 1) * 22)
                local isHov = InBox(m, bX + 2, optY, bW - 4, 20)
                local isSel = (opt == drop.Selected)

                -- BG before text to prevent text occlusion
                if isHov then
                    Fill(bX + 2, optY, bW - 4, 20, C.DropHover, 4, Z.DropItem)
                elseif isSel then
                    Fill(bX + 2, optY, bW - 4, 20, C.TabActive, 4, Z.DropItem)
                end
                Txt(bX + 8, optY + 4, tostring(opt), isSel and C.Accent or (isHov and C.TxtPrimary or C.TxtMuted), 11, Z.DropText)

                if Input.LeftClick and isHov then
                    drop:Set(opt)
                    AGY._OpenDropdown = nil
                end
            end

            if Input.LeftClick and not InBox(m, bX - 2, popY - 2, bW + 4, popH + bH + 6) then
                AGY._OpenDropdown = nil
            end
        end

        HidePoolTail()
    end

    -- â”€â”€ Render task loop â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€â”€
    task.spawn(function()
        while true do
            local ok, err = pcall(Render)
            if not ok then print("[AGY Error]:", err) end
            task.wait()
        end
    end)

    -- Load saved config on startup
    LoadConfig(AGY.Flags)

    -- Public API surface
    function win:SaveConfig()  SaveConfig(AGY.Flags); Notify("Config saved!") end
    function win:LoadConfig()  LoadConfig(AGY.Flags); Notify("Config loaded!") end
    function win:Toggle()      AGY._MenuVisible = not AGY._MenuVisible end
    function win:Notify(msg)   Notify(msg) end

    return win
end

return AGY