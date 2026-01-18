-- [[ UNIVERSAL-HUB v2.5 SUPREMA FINAL ]]
-- @ayuks78 & @GmAI
-- FOCO: PERFORMANCE REAL-TIME | ESP SEM GHOSTS | AIMBOT STICKY

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local camera = workspace.CurrentCamera

-- [[ CONFIGURAÇÃO ]]
getgenv().Config = {
    Aimbot = false,
    Hitbox = false,
    HitSize = 15,
    Esp = false,
    EspBox = false,
    Noclip = false,
    Boost = false,
    FovSize = 180,
    MaxDist = 700,
    Smoothness = 0.35 -- Puxada Mediana-Forte
}

-- [[ FOV FIXA NO CENTRO ]]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1.5; FOVCircle.Color = Color3.fromRGB(0, 150, 255); FOVCircle.Filled = false; FOVCircle.Visible = false

-- [[ INTERFACE ARRASTÁVEL ]]
local UI = Instance.new("ScreenGui", (gethui and gethui()) or game:GetService("CoreGui"))
local Main = Instance.new("Frame", UI)
Main.Size = UDim2.new(0, 580, 0, 320); Main.Position = UDim2.new(0.5, -290, 0.5, -160); Main.BackgroundColor3 = Color3.fromRGB(5, 5, 7); Main.BorderSizePixel = 0; Main.Active = true; Main.Draggable = true -- Ativado Arrastar
Instance.new("UICorner", Main)

-- Barra RGB Azul
local RGB = Instance.new("Frame", Main)
RGB.Size = UDim2.new(1, 0, 0, 3); RGB.Position = UDim2.new(0, 0, 1, -3); RGB.BackgroundColor3 = Color3.fromRGB(0, 100, 255); RGB.BorderSizePixel = 0

-- Sidebar Lateral
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, 0); Sidebar.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", Sidebar)

local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -160, 1, -20); Container.Position = UDim2.new(0, 150, 0, 10); Container.BackgroundTransparency = 1

local Tabs = {}
function CreateTab(name, id)
    local P = Instance.new("ScrollingFrame", Container)
    P.Size = UDim2.new(1, 0, 1, 0); P.Visible = (id == 1); P.BackgroundTransparency = 1; P.ScrollBarThickness = 0
    Instance.new("UIListLayout", P).Padding = UDim.new(0, 10)
    local B = Instance.new("TextButton", Sidebar)
    B.Size = UDim2.new(1, -20, 0, 35); B.Position = UDim2.new(0, 10, 0, 50 + (id-1)*42); B.Text = name; B.BackgroundColor3 = (id == 1) and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(20, 20, 25); B.TextColor3 = Color3.fromRGB(255, 255, 255); B.Font = "GothamBold"; B.TextSize = 11; Instance.new("UICorner", B)
    B.MouseButton1Click:Connect(function()
        for _, v in pairs(Tabs) do v.P.Visible = false; v.B.BackgroundColor3 = Color3.fromRGB(20, 20, 25) end
        P.Visible = true; B.BackgroundColor3 = Color3.fromRGB(0, 100, 255)
    end)
    Tabs[id] = {P = P, B = B}; return P
end

function AddToggle(parent, text, key)
    local f = Instance.new("Frame", parent); f.Size = UDim2.new(1, -10, 0, 42); f.BackgroundColor3 = Color3.fromRGB(15, 15, 20); Instance.new("UICorner", f)
    local l = Instance.new("TextLabel", f); l.Size = UDim2.new(1, 0, 1, 0); l.Position = UDim2.new(0, 12, 0, 0); l.Text = text; l.TextColor3 = Color3.fromRGB(255, 255, 255); l.TextXAlignment = 0; l.BackgroundTransparency = 1; l.Font = "GothamBold"; l.TextSize = 11
    local b = Instance.new("TextButton", f); b.Size = UDim2.new(0, 36, 0, 18); b.Position = UDim2.new(1, -48, 0.5, -9); b.BackgroundColor3 = Color3.fromRGB(40, 40, 45); b.Text = ""; Instance.new("UICorner", b).CornerRadius = UDim.new(0, 10)
    b.MouseButton1Click:Connect(function()
        getgenv().Config[key] = not getgenv().Config[key]
        TS:Create(b, TweenInfo.new(0.3), {BackgroundColor3 = getgenv().Config[key] and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(40, 40, 45)}):Play()
    end)
end

local T1 = CreateTab("Main", 1); local T2 = CreateTab("Visual", 2); local T3 = CreateTab("Misc", 3)
AddToggle(T1, "Aimbot Sticky (700m)", "Aimbot"); AddToggle(T1, "Hitbox Physical 2.0", "Hitbox")
AddToggle(T2, "ESP Names Real-Time", "Esp"); AddToggle(T2, "ESP Box 3D (Team)", "EspBox")
AddToggle(T3, "Noclip Ghost Force", "Noclip"); AddToggle(T3, "Ultra Boost FPS", "Boost")

-- [[ MOTOR DE ESP (SEM GHOSTS) ]]
local PlayerGraphics = {}
local function ClearGraphics(plr)
    if PlayerGraphics[plr] then
        PlayerGraphics[plr].Text:Remove(); PlayerGraphics[plr].Box:Remove(); PlayerGraphics[plr] = nil
    end
end

-- [[ LÓGICA DE ALVO ]]
local function GetClosest()
    local target, lowest = nil, getgenv().Config.FovSize
    local screenCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character.Humanoid.Health > 0 then
            local hrp = v.Character.HumanoidRootPart
            local screenPos, vis = camera:WorldToViewportPoint(hrp.Position)
            local dist = (hrp.Position - lp.Character.HumanoidRootPart.Position).Magnitude
            if dist <= getgenv().Config.MaxDist then
                local mag = (Vector2.new(screenPos.X, screenPos.Y) - screenCenter).Magnitude
                if mag < lowest then target = v; lowest = mag end
            end
        end
    end
    return target
end

-- [[ CICLO PRINCIPAL - 60 FPS ]]
RS.RenderStepped:Connect(function()
    local center = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y / 2)
    FOVCircle.Position = center; FOVCircle.Radius = getgenv().Config.FovSize; FOVCircle.Visible = getgenv().Config.Aimbot

    -- Aimbot Sticky
    if getgenv().Config.Aimbot and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local t = GetClosest()
        if t then
            local p = camera:WorldToViewportPoint(t.Character.HumanoidRootPart.Position)
            mousemoverel((p.X - center.X) * getgenv().Config.Smoothness, (p.Y - center.Y) * getgenv().Config.Smoothness)
        end
    end

    -- ESP Lógica
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
            if not PlayerGraphics[v] then
                PlayerGraphics[v] = {
                    Text = Drawing.new("Text"),
                    Box = Drawing.new("Square")
                }
            end
            local g = PlayerGraphics[v]
            local hrp = v.Character.HumanoidRootPart
            local pos, vis = camera:WorldToViewportPoint(hrp.Position)
            local dist = (hrp.Position - camera.CFrame.Position).Magnitude
            
            if vis and (getgenv().Config.Esp or getgenv().Config.EspBox) then
                local color = (v.TeamColor == lp.TeamColor) and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(255, 0, 0)
                -- Name ESP
                g.Text.Visible = getgenv().Config.Esp
                g.Text.Position = Vector2.new(pos.X, pos.Y - 40)
                g.Text.Text = v.Name .. " | " .. math.floor(v.Character.Humanoid.Health) .. "% [" .. math.floor(dist) .. "m]"
                g.Text.Color = color; g.Text.Center = true; g.Text.Outline = true
                -- Box ESP
                g.Box.Visible = getgenv().Config.EspBox
                g.Box.Size = Vector2.new(2000 / pos.Z, 3000 / pos.Z)
                g.Box.Position = Vector2.new(pos.X - g.Box.Size.X / 2, pos.Y - g.Box.Size.Y / 2)
                g.Box.Color = color; g.Box.Thickness = 1; g.Box.Filled = false
            else
                g.Text.Visible = false; g.Box.Visible = false
            end
        elseif PlayerGraphics[v] then
            g.Text.Visible = false; g.Box.Visible = false
        end
    end
end)

-- [[ FUNÇÕES DE FÍSICA ]]
RS.Stepped:Connect(function()
    if getgenv().Config.Noclip and lp.Character then
        for _, v in pairs(lp.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
    if getgenv().Config.Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            pcall(function()
                if v ~= lp and v.Character then
                    v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().Config.HitSize, getgenv().Config.HitSize, getgenv().Config.HitSize)
                    v.Character.HumanoidRootPart.Transparency = 0.8
                    v.Character.HumanoidRootPart.CanCollide = false
                end
            end)
        end
    end
end)

-- Botão de Minimizar
local MinBtn = Instance.new("ImageButton", UI)
MinBtn.Size = UDim2.new(0, 45, 0, 45); MinBtn.Position = UDim2.new(0, 15, 0.5, -22); MinBtn.Image = "rbxassetid://6023454774"; MinBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 12); Instance.new("UICorner", MinBtn); Instance.new("UIStroke", MinBtn).Color = Color3.fromRGB(0, 120, 255)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = not Main.Visible end)

Players.PlayerRemoving:Connect(ClearGraphics)