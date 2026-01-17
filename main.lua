-- [[ PAINEL UNIVERSAL-HUB-V1.9.7 SLIM LUXURY + AIMBOT ASSIST ]]
-- Codename: @ayuks78 & @GmAI
-- Features: Lock-On, Smooth Aim, FOV Circle, Hitbox Expander

local Players = game:GetService("Players")
local RS = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local lp = Players.LocalPlayer
local mouse = lp:GetMouse()
local camera = workspace.CurrentCamera

-- [[ SETTINGS GLOBAIS ]]
getgenv().Aimbot = false
getgenv().Hitbox = false
getgenv().HitSize = 5
getgenv().AimPart = "HumanoidRootPart" -- Pode ser "Head" se preferir
getgenv().Sensitivity = 0.25 -- Sensibilidade Média (Luxo)
getgenv().FOV = 120 -- Tamanho do círculo de assistência

-- [ CÍRCULO FOV (Invisível/Visual) ]
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 1
FOVCircle.Color = Color3.fromRGB(65, 120, 255)
FOVCircle.Filled = false
FOVCircle.Transparency = 0.5
FOVCircle.Visible = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "UniversalHub_v197"
ScreenGui.Parent = (gethui and gethui()) or game:GetService("CoreGui")

-- [ FRAME PRINCIPAL SLIM ]
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 580, 0, 310)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)

-- [ SIDEBAR ]
local Sidebar = Instance.new("Frame", MainFrame)
Sidebar.Size = UDim2.new(0, 140, 1, -20)
Sidebar.Position = UDim2.new(0, 10, 0, 10)
Sidebar.BackgroundColor3 = Color3.fromRGB(13, 13, 15)
Instance.new("UICorner", Sidebar).CornerRadius = UDim.new(0, 4)

local WelcomeLabel = Instance.new("TextLabel", Sidebar)
WelcomeLabel.Size = UDim2.new(1, -10, 0, 25); WelcomeLabel.Position = UDim2.new(0, 10, 0, 8)
WelcomeLabel.Text = "Bem Vindo: " .. lp.Name; WelcomeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
WelcomeLabel.Font = Enum.Font.GothamBold; WelcomeLabel.TextSize = 10; WelcomeLabel.TextXAlignment = 0; WelcomeLabel.BackgroundTransparency = 1

local PremiumTag = Instance.new("TextLabel", Sidebar)
PremiumTag.Size = UDim2.new(1, -10, 0, 15); PremiumTag.Position = UDim2.new(0, 10, 0, 22)
PremiumTag.Text = "Premium"; PremiumTag.TextColor3 = Color3.fromRGB(65, 120, 255)
PremiumTag.Font = Enum.Font.GothamBold; PremiumTag.TextSize = 9; PremiumTag.TextXAlignment = 0; PremiumTag.BackgroundTransparency = 1

local TabContainer = Instance.new("Frame", Sidebar)
TabContainer.Size = UDim2.new(1, 0, 1, -70); TabContainer.Position = UDim2.new(0, 0, 0, 60); TabContainer.BackgroundTransparency = 1
local TabList = Instance.new("UIListLayout", TabContainer); TabList.Padding = UDim.new(0, 5)

-- [ CONTEÚDO ]
local Content = Instance.new("Frame", MainFrame)
Content.Size = UDim2.new(1, -170, 1, -40); Content.Position = UDim2.new(0, 160, 0, 10); Content.BackgroundTransparency = 1

local HeaderTitle = Instance.new("TextLabel", Content)
HeaderTitle.Size = UDim2.new(1, 0, 0, 30); HeaderTitle.Text = "Main Hub"; HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
HeaderTitle.Font = Enum.Font.GothamBold; HeaderTitle.TextSize = 14; HeaderTitle.TextXAlignment = 0; HeaderTitle.BackgroundTransparency = 1

local function CreatePage(name)
    local Page = Instance.new("ScrollingFrame", Content)
    Page.Size = UDim2.new(1, 0, 1, -40); Page.Position = UDim2.new(0,0,0,35); Page.BackgroundTransparency = 1; Page.Visible = false; Page.ScrollBarThickness = 0
    Instance.new("UIListLayout", Page).Padding = UDim.new(0, 6)
    local TabBtn = Instance.new("TextButton", TabContainer)
    TabBtn.Size = UDim2.new(0, 125, 0, 28); TabBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 22); TabBtn.Text = name; TabBtn.TextColor3 = Color3.fromRGB(120, 120, 120); TabBtn.Font = Enum.Font.GothamBold; TabBtn.TextSize = 10; Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 4)
    TabBtn.MouseButton1Click:Connect(function()
        for _, p in pairs(Content:GetChildren()) do if p:IsA("ScrollingFrame") then p.Visible = false end end
        for _, b in pairs(TabContainer:GetChildren()) do if b:IsA("TextButton") then b.TextColor3 = Color3.fromRGB(120, 120, 120); b.BackgroundColor3 = Color3.fromRGB(18, 18, 22) end end
        Page.Visible = true; TabBtn.TextColor3 = Color3.fromRGB(65, 120, 255); TabBtn.BackgroundColor3 = Color3.fromRGB(22, 22, 26)
    end)
    return Page
end

local MainP = CreatePage("Main")
CreatePage("Visual"); CreatePage("Misc"); CreatePage("Créditos")

-- [ FUNÇÕES DE UI ]
local function AddToggle(parent, text, var)
    local Card = Instance.new("Frame", parent); Card.Size = UDim2.new(1, -5, 0, 38); Card.BackgroundColor3 = Color3.fromRGB(14, 14, 17); Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)
    local L = Instance.new("TextLabel", Card); L.Size = UDim2.new(0.7, 0, 1, 0); L.Position = UDim2.new(0, 12, 0, 0); L.Text = text; L.TextColor3 = Color3.fromRGB(100, 100, 100); L.Font = Enum.Font.GothamSemibold; L.TextSize = 11; L.TextXAlignment = 0; L.BackgroundTransparency = 1
    local B = Instance.new("TextButton", Card); B.Size = UDim2.new(0, 36, 0, 18); B.Position = UDim2.new(1, -48, 0.5, -9); B.BackgroundColor3 = Color3.fromRGB(25, 25, 30); B.Text = ""; Instance.new("UICorner", B).CornerRadius = UDim.new(0, 9)
    B.MouseButton1Click:Connect(function()
        getgenv()[var] = not getgenv()[var]
        TS:Create(B, TweenInfo.new(0.3), {BackgroundColor3 = getgenv()[var] and Color3.fromRGB(65, 120, 255) or Color3.fromRGB(25, 25, 30)}):Play()
        if var == "Aimbot" then FOVCircle.Visible = getgenv().Aimbot end
    end)
end

local function AddSlider(parent)
    local Card = Instance.new("Frame", parent); Card.Size = UDim2.new(1, -5, 0, 55); Card.BackgroundColor3 = Color3.fromRGB(14, 14, 17); Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 4)
    local L = Instance.new("TextLabel", Card); L.Size = UDim2.new(1, -20, 0, 20); L.Position = UDim2.new(0, 12, 0, 5); L.Text = "Hitbox Sizer"; L.TextColor3 = Color3.fromRGB(100, 100, 100); L.Font = Enum.Font.Gotham; L.TextSize = 10; L.TextXAlignment = 0; L.BackgroundTransparency = 1
    local Bk = Instance.new("Frame", Card); Bk.Size = UDim2.new(1, -24, 0, 18); Bk.Position = UDim2.new(0, 12, 0, 28); Bk.BackgroundColor3 = Color3.fromRGB(20, 20, 25); Instance.new("UICorner", Bk).CornerRadius = UDim.new(0, 3)
    local Fl = Instance.new("Frame", Bk); Fl.Size = UDim2.new(0.33, 0, 1, 0); Fl.BackgroundColor3 = Color3.fromRGB(65, 120, 255); Instance.new("UICorner", Fl).CornerRadius = UDim.new(0, 3)
    local Vl = Instance.new("TextLabel", Bk); Vl.Size = UDim2.new(1, 0, 1, 0); Vl.Text = "5 studs"; Vl.TextColor3 = Color3.fromRGB(255, 255, 255); Vl.Font = Enum.Font.GothamBold; Vl.TextSize = 10; Vl.BackgroundTransparency = 1
    local Bt = Instance.new("TextButton", Bk); Bt.Size = UDim2.new(1, 0, 1, 0); Bt.BackgroundTransparency = 1; Bt.Text = ""
    local drg = false
    Bt.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg = true end end)
    UIS.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then drg = false end end)
    UIS.InputChanged:Connect(function(i)
        if drg and i.UserInputType == Enum.UserInputType.MouseMovement then
            local p = math.clamp((i.Position.X - Bk.AbsolutePosition.X) / Bk.AbsoluteSize.X, 0, 1)
            Fl.Size = UDim2.new(p, 0, 1, 0); getgenv().HitSize = math.floor(1 + (p * 14)); Vl.Text = getgenv().HitSize .. " studs"
        end
    end)
end

AddToggle(MainP, "Aimbot Lock-On", "Aimbot")
AddToggle(MainP, "Hitbox Expander", "Hitbox")
AddSlider(MainP)

-- [ LÓGICA DO AIMBOT ]
local function GetClosestPlayer()
    local target = nil
    local dist = getgenv().FOV
    for _, v in pairs(Players:GetPlayers()) do
        if v ~= lp and v.Character and v.Character:FindFirstChild(getgenv().AimPart) and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
            local pos, onScreen = camera:WorldToViewportPoint(v.Character[getgenv().AimPart].Position)
            if onScreen then
                local magnitude = (Vector2.new(pos.X, pos.Y) - Vector2.new(mouse.X, mouse.Y)).Magnitude
                if magnitude < dist then
                    target = v
                    dist = magnitude
                end
            end
        end
    end
    return target
end

RS.RenderStepped:Connect(function()
    FOVCircle.Position = Vector2.new(mouse.X, mouse.Y + 36)
    if getgenv().Aimbot then
        local target = GetClosestPlayer()
        if target and UIS:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then -- Ativa ao segurar botão direito
            local targetPos = camera:WorldToViewportPoint(target.Character[getgenv().AimPart].Position)
            local mousePos = Vector2.new(mouse.X, mouse.Y)
            local aimPos = Vector2.new(targetPos.X, targetPos.Y)
            local move = (aimPos - mousePos) * getgenv().Sensitivity
            mousemoverel(move.X, move.Y) -- Requer executor com mousemoverel (Delta suporta)
        end
    end
    
    if getgenv().Hitbox then
        for _, v in pairs(Players:GetPlayers()) do
            if v ~= lp and v.Character and v.Character:FindFirstChild("HumanoidRootPart") then
                v.Character.HumanoidRootPart.Size = Vector3.new(getgenv().HitSize, getgenv().HitSize, getgenv().HitSize)
                v.Character.HumanoidRootPart.Transparency = 0.7
                v.Character.HumanoidRootPart.CanCollide = false
            end
        end
    end
end)

-- Botão Abrir
local OpenBtn = Instance.new("ImageButton", ScreenGui); OpenBtn.Size = UDim2.new(0, 42, 0, 42); OpenBtn.Position = UDim2.new(0, 15, 0.5, -21); OpenBtn.BackgroundColor3 = Color3.fromRGB(5, 5, 5); OpenBtn.Image = "rbxassetid://6023454774"; Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 6); OpenBtn.Draggable = true
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = not MainFrame.Visible end)

MainP.Visible = true