--!strict
-- Severe External Aimbot Helper Template
-- Demonstrates hardware mouse input simulation using `mousemoverel` and `isrightpressed`

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local AimbotConfig = {
    Enabled = true,
    FOVRadius = 120,
    Smoothness = 0.25, -- 0.0 to 1.0 (lower = smoother)
    AimPart = "Head",
    TargetCheckTeam = true,
}

-- FOV Circle Visualizer (Immediate/Static Drawing)
local FOVCircle = Drawing.new("Circle")
FOVCircle.Visible = true
FOVCircle.Color = Color3.fromRGB(255, 100, 100)
FOVCircle.Thickness = 1
FOVCircle.NumSides = 32
FOVCircle.Radius = AimbotConfig.FOVRadius
FOVCircle.Filled = false

local function GetClosestTargetInFOV()
    local Camera = Workspace.CurrentCamera
    if not Camera then return nil end

    local MousePos = UserInputService:GetMouseLocation()
    local ClosestTarget: BasePart? = nil
    local ShortestDistance = AimbotConfig.FOVRadius

    local LocalPlayer = Players.LocalPlayer
    if not LocalPlayer or not LocalPlayer.Character then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if AimbotConfig.TargetCheckTeam and is_team_check_active() and player.Team == LocalPlayer.Team then
                continue
            end

            local character = player.Character
            if character and character:FindFirstChild(AimbotConfig.AimPart) then
                local targetPart = character[AimbotConfig.AimPart] :: BasePart
                local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

                if onScreen then
                    local dx = screenPos.X - MousePos.X
                    local dy = screenPos.Y - MousePos.Y
                    local dist = math.sqrt(dx * dx + dy * dy)
                    if dist < ShortestDistance then
                        ShortestDistance = dist
                        ClosestTarget = targetPart
                    end
                end
            end
        end
    end

    return ClosestTarget
end

-- Main Aimbot Loop
RunService.RenderStepped:Connect(function()
    local MousePos = UserInputService:GetMouseLocation()
    FOVCircle.Position = MousePos

    -- Check if Roblox window is active & Right Mouse Button is held down
    if AimbotConfig.Enabled and isrbxactive() and isrightpressed() then
        local targetPart = GetClosestTargetInFOV()
        if targetPart then
            local Camera = Workspace.CurrentCamera
            local screenPos = Camera:WorldToViewportPoint(targetPart.Position)
            
            local deltaX = (screenPos.X - MousePos.X) * AimbotConfig.Smoothness
            local deltaY = (screenPos.Y - MousePos.Y) * AimbotConfig.Smoothness
            
            -- Smooth relative mouse input move via Severe API
            mousemoverel(deltaX, deltaY)
        end
    end
end)

send_notification("Severe Aimbot Helper Loaded (Hold RMB to Lock)")
