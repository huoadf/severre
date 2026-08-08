--!strict
-- Severe External ESP Framework Template
-- Uses Severe's high-speed background model thread (`add_model_data`) & Dynamic Drawing Attachments

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")

send_notification("Severe ESP Framework Loading...")

type ESPCacheEntry = {
    HeadPoint: any,
    Box: any,
    Text: any,
    Cluster: any,
}

local ESPCache: { [string]: ESPCacheEntry } = {}

local function RegisterPlayerModel(player: Player)
    if player == Players.LocalPlayer then return end
    
    local character = player.Character
    if not character or not character:FindFirstChild("HumanoidRootPart") or not character:FindFirstChild("Head") then
        return
    end

    local key = player.Name .. "_" .. tostring(player.UserId)

    -- Register character model data with Severe's internal engine
    local modelData = {
        Username = player.Name,
        Displayname = player.DisplayName,
        Userid = player.UserId,
        Character = character,
        PrimaryPart = character.HumanoidRootPart,
        Head = character.Head,
        Torso = character:FindFirstChild("Torso") or character:FindFirstChild("UpperTorso"),
        Health = 100,
        MaxHealth = 100,
        Whitelisted = false,
        Archenemies = false,
    }
    
    add_model_data(modelData, key)

    -- Create dynamic 3D attachment drawing objects
    local headPoint = PointInstance.new(character.Head)
    
    local box = Drawing.new("Square")
    box.Visible = true
    box.Color = Color3.fromRGB(0, 255, 170)
    box.Thickness = 1.5
    box.Filled = false

    local label = Drawing.new("Text")
    label.Visible = true
    label.Color = Color3.fromRGB(255, 255, 255)
    label.Text = player.DisplayName
    label.Size = 14
    label.Center = true

    -- Attach drawing objects to the Head 3D point
    local cluster = Drawing.attach({
        [box] = {
            Link = headPoint,
            Size = UDim2.new(0, 40, 0, 60),
            AnchorPoint = Vector2.new(0.5, 0.2)
        },
        [label] = {
            Link = headPoint,
            Size = UDim2.fromScale(1, 1),
            AnchorPoint = Vector2.new(0.5, 1.2)
        }
    })

    ESPCache[key] = {
        HeadPoint = headPoint,
        Box = box,
        Text = label,
        Cluster = cluster,
    }
end

local function UnregisterPlayerModel(player: Player)
    local key = player.Name .. "_" .. tostring(player.UserId)
    if ESPCache[key] then
        ESPCache[key].Cluster:Destroy()
        ESPCache[key].HeadPoint:Destroy()
        ESPCache[key] = nil
        remove_model_data(key)
    end
end

-- Initialize for current players
for _, player in ipairs(Players:GetPlayers()) do
    task.spawn(function()
        if player.Character then
            RegisterPlayerModel(player)
        end
        player.CharacterAdded:Connect(function()
            task.wait(0.5)
            RegisterPlayerModel(player)
        end)
    end)
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        task.wait(0.5)
        RegisterPlayerModel(player)
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    UnregisterPlayerModel(player)
end)

send_notification("Severe ESP Framework Active!")
