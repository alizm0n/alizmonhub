--[[
    UNIVERSAL SCRIPT HUB (SAFE KILL)
    Вкладки: ESP, Player (все функции), Aimbot, Visual.
    При нажатии Kill все функции отключаются, настройки сбрасываются, меню закрывается.
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local Lighting = game:GetService("Lighting")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local camera = Workspace.CurrentCamera

-- ========== НАСТРОЙКА КЛАВИШИ АИМБОТА ==========
local AIM_KEY = Enum.KeyCode.RightShift
-- ==============================================

-- ========== 1. КОРНЕВОЙ ScreenGui ==========
local gui = Instance.new("ScreenGui")
gui.Name           = "UniversalHubGui"
gui.ResetOnSpawn   = false
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.DisplayOrder   = 999
gui.Parent         = playerGui

-- ========== 2. ГЛАВНОЕ ОКНО ==========
local window = Instance.new("Frame")
window.Name             = "Window"
window.Size             = UDim2.new(0, 420, 0, 480)
window.Position         = UDim2.new(0.5, -210, 0.5, -240)
window.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
window.BorderSizePixel  = 0
window.Active           = true
window.Parent           = gui

local windowCorner = Instance.new("UICorner")
windowCorner.CornerRadius = UDim.new(0, 10)
windowCorner.Parent       = window

local windowStroke = Instance.new("UIStroke")
windowStroke.Color        = Color3.fromRGB(60, 200, 90)
windowStroke.Thickness    = 1.5
windowStroke.Parent       = window

-- ========== 3. ЗАГОЛОВОК ==========
local titleBar = Instance.new("Frame")
titleBar.Name             = "TitleBar"
titleBar.Size             = UDim2.new(1, 0, 0, 36)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
titleBar.BorderSizePixel  = 0
titleBar.ZIndex           = 2
titleBar.Parent           = window

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 10)
titleCorner.Parent       = titleBar

local titleFix = Instance.new("Frame")
titleFix.Size             = UDim2.new(1, 0, 0, 12)
titleFix.Position         = UDim2.new(0, 0, 1, -12)
titleFix.BackgroundColor3 = Color3.fromRGB(25, 35, 30)
titleFix.BorderSizePixel  = 0
titleFix.Parent           = titleBar

local titleLabel = Instance.new("TextLabel")
titleLabel.Size             = UDim2.new(1, -80, 1, 0)
titleLabel.Position         = UDim2.new(0, 12, 0, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text             = "UNIVERSAL HUB"
titleLabel.TextColor3       = Color3.fromRGB(255, 255, 255)
titleLabel.TextXAlignment   = Enum.TextXAlignment.Left
titleLabel.Font             = Enum.Font.GothamBold
titleLabel.TextSize         = 16
titleLabel.Parent           = titleBar

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 0, 30)
minimizeBtn.Position = UDim2.new(1, -36, 0, 3)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.TextSize = 16
minimizeBtn.ZIndex = 3
minimizeBtn.Parent = titleBar
local minCorner = Instance.new("UICorner"); minCorner.CornerRadius = UDim.new(0, 6); minCorner.Parent = minimizeBtn

-- Невидимая панель перетаскивания
local dragArea = Instance.new("TextButton")
dragArea.Size = UDim2.new(1, -40, 1, 0)
dragArea.BackgroundTransparency = 1
dragArea.Text = ""
dragArea.ZIndex = 2
dragArea.Parent = titleBar

local dragging, dragStart, startPos = false, nil, nil
dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then 
        dragging = false 
    end
end)

-- Логика сворачивания
local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 140, 0, 30)
miniBtn.Position = UDim2.new(0.5, -70, 0, 10)
miniBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
miniBtn.Text = "РАЗВЕРНУТЬ МЕНЮ"
miniBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
miniBtn.Font = Enum.Font.GothamBold
miniBtn.TextSize = 12
miniBtn.Visible = false
miniBtn.Parent = gui
local miniCorner = Instance.new("UICorner"); miniCorner.CornerRadius = UDim.new(0, 6); miniCorner.Parent = miniBtn

minimizeBtn.MouseButton1Click:Connect(function()
    window.Visible = false
    miniBtn.Visible = true
end)

miniBtn.MouseButton1Click:Connect(function()
    window.Visible = true
    miniBtn.Visible = false
end)

-- ========== 4. ХЕЛПЕРЫ UI ==========
local function makeButton(name, text, color, parent, yPos)
    local btn = Instance.new("TextButton")
    btn.Name             = name
    btn.Size             = UDim2.new(1, 0, 0, 35)
    btn.Position         = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = color
    btn.BorderSizePixel  = 0
    btn.Text             = text
    btn.TextColor3       = Color3.fromRGB(255, 255, 255)
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 14
    btn.AutoButtonColor  = true
    btn.Parent           = parent

    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 8); c.Parent = btn
    local s = Instance.new("UIStroke"); s.Color = Color3.fromRGB(0,0,0); s.Thickness = 1; s.Transparency = 0.6; s.Parent = btn
    return btn
end

local function createSlider(parent, name, min, max, default, yPos, callback)
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 0, 20)
    label.Position = UDim2.new(0, 0, 0, yPos)
    label.BackgroundTransparency = 1
    label.Text = name .. ": " .. default
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = parent

    local bar = Instance.new("Frame")
    bar.Size = UDim2.new(1, 0, 0, 10)
    bar.Position = UDim2.new(0, 0, 0, yPos + 25)
    bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    bar.BorderSizePixel = 0
    bar.Parent = parent

    local barCorner = Instance.new("UICorner"); barCorner.CornerRadius = UDim.new(0, 5); barCorner.Parent = bar

    local fill = Instance.new("Frame")
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
    fill.BorderSizePixel = 0
    fill.Parent = bar

    local fillCorner = Instance.new("UICorner"); fillCorner.CornerRadius = UDim.new(0, 5); fillCorner.Parent = fill

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 20, 0, 20)
    knob.Position = UDim2.new((default - min) / (max - min), -10, 0.5, -10)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 2
    knob.Parent = bar

    local knobCorner = Instance.new("UICorner"); knobCorner.CornerRadius = UDim.new(1, 0); knobCorner.Parent = knob
    local knobStroke = Instance.new("UIStroke"); knobStroke.Color = Color3.fromRGB(0,0,0); knobStroke.Thickness = 1; knobStroke.Parent = knob

    local draggingSlider = false

    local function updateSlider(input)
        local barAbsPos = bar.AbsolutePosition.X
        local barSize = bar.AbsoluteSize.X
        local mouseX = input.Position.X
        
        local percent = math.clamp((mouseX - barAbsPos) / barSize, 0, 1)
        local value = math.floor(min + (max - min) * percent)
        
        fill.Size = UDim2.new(percent, 0, 1, 0)
        knob.Position = UDim2.new(percent, -10, 0.5, -10)
        label.Text = name .. ": " .. value
        
        if callback then callback(value) end
    end

    bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingSlider and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end)
    
    -- Возвращаем объекты для возможности сброса
    return label, bar, fill, knob
end

-- ========== 5. ВКЛАДКИ ==========
local tabHolder = Instance.new("Frame")
tabHolder.Size = UDim2.new(1, -40, 0, 30)
tabHolder.Position = UDim2.new(0, 20, 0, 45)
tabHolder.BackgroundTransparency = 1
tabHolder.Parent = window

local tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.Padding = UDim.new(0, 5)
tabLayout.Parent = tabHolder

local pages = {}

local function createTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 80, 1, 0)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(150, 150, 150)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    btn.Parent = tabHolder
    
    local c = Instance.new("UICorner"); c.CornerRadius = UDim.new(0, 6); c.Parent = btn
    
    local page = Instance.new("Frame")
    page.Name = name .. "Page"
    page.Size = UDim2.new(1, -40, 1, -120)
    page.Position = UDim2.new(0, 20, 0, 85)
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = window
    
    pages[name] = page
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        page.Visible = true
        
        for _, b in ipairs(tabHolder:GetChildren()) do
            if b:IsA("TextButton") then
                b.TextColor3 = Color3.fromRGB(150, 150, 150)
                b.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
            end
        end
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
    end)
    
    return page
end

local espTab = createTab("ESP")
local playerTab = createTab("Player")
local aimTab = createTab("Aimbot")
local visualTab = createTab("Visual")

task.wait(0.1)
local firstTab = tabHolder:GetChildren()[1]
if firstTab and firstTab:IsA("TextButton") then
    firstTab.TextColor3 = Color3.fromRGB(255, 255, 255)
    firstTab.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
    espTab.Visible = true
end

-- Список активных функций для сброса при Kill
local activeFunctions = {}

-- ========== 6. ЛОГИКА: ESP ==========
local espActive = false
local espButton = makeButton("ESP", "ESP: OFF", Color3.fromRGB(70, 70, 90), espTab, 10)

local function toggleESP(state)
    espActive = state
    if espActive then
        espButton.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        espButton.Text = "ESP: ON"
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= player and p.Character then
                local hl = Instance.new("Highlight")
                hl.Name = "ESPHighlight"
                hl.Adornee = p.Character
                hl.FillColor = Color3.fromRGB(255, 0, 0)
                hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                hl.FillTransparency = 0.5
                hl.Parent = p.Character
            end
        end
        activeFunctions["ESP"] = function() toggleESP(false) end
    else
        espButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        espButton.Text = "ESP: OFF"
        for _, p in ipairs(Players:GetPlayers()) do
            if p.Character then
                local hl = p.Character:FindFirstChild("ESPHighlight")
                if hl then hl:Destroy() end
            end
        end
        activeFunctions["ESP"] = nil
    end
end

espButton.MouseButton1Click:Connect(function() toggleESP(not espActive) end)

-- ========== 7. ЛОГИКА: PLAYER (ВСЕ В ОДНОМ) ==========
-- Слайдеры (сохраняем объекты для сброса)
local wsLabel, wsBar, wsFill, wsKnob = createSlider(playerTab, "WalkSpeed", 16, 200, 16, 10, function(val)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = val
    end
end)

local jpLabel, jpBar, jpFill, jpKnob = createSlider(playerTab, "JumpPower", 50, 500, 50, 70, function(val)
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.JumpPower = val
        player.Character.Humanoid.UseJumpPower = true
    end
end)

-- Noclip
local noclipActive = false
local noclipButton = makeButton("Noclip", "Noclip: OFF", Color3.fromRGB(70, 70, 90), playerTab, 130)

local function toggleNoclip(state)
    noclipActive = state
    if noclipActive then
        noclipButton.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        noclipButton.Text = "Noclip: ON"
        
        RunService.Stepped:Connect(function()
            if noclipActive and player.Character then
                for _, v in ipairs(player.Character:GetDescendants()) do
                    if v:IsA("BasePart") and v.CanCollide then
                        v.CanCollide = false
                    end
                end
            end
        end)
        activeFunctions["Noclip"] = function() toggleNoclip(false) end
    else
        noclipButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        noclipButton.Text = "Noclip: OFF"
        if player.Character then
            for _, v in ipairs(player.Character:GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = true end
            end
        end
        activeFunctions["Noclip"] = nil
    end
end

noclipButton.MouseButton1Click:Connect(function() toggleNoclip(not noclipActive) end)

-- Fly
local flyActive = false
local flyButton = makeButton("Fly", "Fly: OFF", Color3.fromRGB(70, 70, 90), playerTab, 175)
local flySpeed = 50
local bodyVelocity = nil
local bodyGyro = nil

local function toggleFly(state)
    flyActive = state
    if flyActive then
        flyButton.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        flyButton.Text = "Fly: ON"
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            bodyVelocity = Instance.new("BodyVelocity")
            bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
            bodyVelocity.Velocity = Vector3.new(0, 0, 0)
            bodyVelocity.Parent = hrp
            
            bodyGyro = Instance.new("BodyGyro")
            bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyGyro.CFrame = hrp.CFrame
            bodyGyro.Parent = hrp
            
            task.spawn(function()
                while flyActive do
                    task.wait()
                    if player.Character and bodyVelocity then
                        local cam = Workspace.CurrentCamera
                        local moveDir = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - cam.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + cam.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0) end
                        
                        bodyVelocity.Velocity = moveDir * flySpeed
                    end
                end
            end)
        end
        activeFunctions["Fly"] = function() toggleFly(false) end
    else
        flyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        flyButton.Text = "Fly: OFF"
        
        if bodyVelocity then bodyVelocity:Destroy() bodyVelocity = nil end
        if bodyGyro then bodyGyro:Destroy() bodyGyro = nil end
        activeFunctions["Fly"] = nil
    end
end

flyButton.MouseButton1Click:Connect(function() toggleFly(not flyActive) end)

-- Spinner (Troll)
local spinnerActive = false
local spinSpeed = 5000
local bodyAngularVelocity = nil

local spinButton = makeButton("SpinButton", "Spinner: OFF", Color3.fromRGB(70, 70, 90), playerTab, 220)

local spinLabel, spinBar, spinFill, spinKnob = createSlider(playerTab, "Spin Force", 1000, 50000, 5000, 270, function(val)
    spinSpeed = val
    if bodyAngularVelocity then
        bodyAngularVelocity.AngularVelocity = Vector3.new(0, val, 0)
    end
end)

local function toggleSpinner(state)
    spinnerActive = state
    if spinnerActive then
        spinButton.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        spinButton.Text = "Spinner: ON"
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            
            bodyAngularVelocity = Instance.new("BodyAngularVelocity")
            bodyAngularVelocity.AngularVelocity = Vector3.new(0, spinSpeed, 0)
            bodyAngularVelocity.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
            bodyAngularVelocity.Parent = hrp
        end
        activeFunctions["Spinner"] = function() toggleSpinner(false) end
    else
        spinButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        spinButton.Text = "Spinner: OFF"
        
        if bodyAngularVelocity then
            bodyAngularVelocity:Destroy()
            bodyAngularVelocity = nil
        end
        
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        end
        activeFunctions["Spinner"] = nil
    end
end

spinButton.MouseButton1Click:Connect(function() toggleSpinner(not spinnerActive) end)

-- ========== 8. ЛОГИКА: AIMBOT ==========
local aimbotActive = false
local aimbotFOV = 150
local aimbotSmoothness = 0.2
local targetPart = "Head"

local fovCircle = Instance.new("Frame")
fovCircle.Name = "FOVCircle"
fovCircle.Size = UDim2.new(0, aimbotFOV, 0, aimbotFOV)
fovCircle.Position = UDim2.new(0.5, -aimbotFOV/2, 0.5, -aimbotFOV/2)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel = 0
fovCircle.Visible = false
fovCircle.Parent = gui

local fovCorner = Instance.new("UICorner"); fovCorner.CornerRadius = UDim.new(1, 0); fovCorner.Parent = fovCircle
local fovStroke = Instance.new("UIStroke"); fovStroke.Color = Color3.fromRGB(255, 50, 50); fovStroke.Thickness = 1.5; fovStroke.Parent = fovCircle

local function getClosestPlayerInFOV()
    local closest = nil
    local shortestDist = aimbotFOV
    
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= player and p.Character and p.Character:FindFirstChild(targetPart) then
            local part = p.Character[targetPart]
            local screenPos, onScreen = camera:WorldToViewportPoint(part.Position)
            
            if onScreen then
                local dist = (Vector2.new(screenPos.X, screenPos.Y) - Vector2.new(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    closest = part
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if not aimbotActive or not UserInputService:IsKeyDown(AIM_KEY) then return end
    local targetPartObj = getClosestPlayerInFOV()
    if targetPartObj then
        local targetPos = targetPartObj.Position
        local camPos = camera.CFrame.Position
        local newCFrame = CFrame.new(camPos, targetPos)
        camera.CFrame = camera.CFrame:Lerp(newCFrame, aimbotSmoothness)
    end
end)

local aimButton = makeButton("AimButton", "Aimbot: OFF", Color3.fromRGB(70, 70, 90), aimTab, 10)

local function toggleAimbot(state)
    aimbotActive = state
    if aimbotActive then
        aimButton.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        aimButton.Text = "Aimbot: ON"
        fovCircle.Visible = true
        activeFunctions["Aimbot"] = function() toggleAimbot(false) end
    else
        aimButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        aimButton.Text = "Aimbot: OFF"
        fovCircle.Visible = false
        activeFunctions["Aimbot"] = nil
    end
end

aimButton.MouseButton1Click:Connect(function() toggleAimbot(not aimbotActive) end)

local fovLabel, fovBar, fovFill, fovKnob = createSlider(aimTab, "Aimbot FOV", 50, 500, 150, 60, function(val)
    aimbotFOV = val
    fovCircle.Size = UDim2.new(0, val, 0, val)
    fovCircle.Position = UDim2.new(0.5, -val/2, 0.5, -val/2)
end)

local smoothLabel, smoothBar, smoothFill, smoothKnob = createSlider(aimTab, "Smoothness", 1, 100, 20, 120, function(val)
    aimbotSmoothness = val / 100
end)

local targetButton = makeButton("TargetButton", "Target: Head", Color3.fromRGB(70, 70, 90), aimTab, 180)
targetButton.MouseButton1Click:Connect(function()
    if targetPart == "Head" then
        targetPart = "HumanoidRootPart"
        targetButton.Text = "Target: Body"
    else
        targetPart = "Head"
        targetButton.Text = "Target: Head"
    end
end)

local keyButton = makeButton("KeyButton", "Aim Key: " .. AIM_KEY.Name, Color3.fromRGB(70, 70, 90), aimTab, 230)
keyButton.MouseButton1Click:Connect(function()
    keyButton.Text = "Нажми клавишу..."
    keyButton.BackgroundColor3 = Color3.fromRGB(200, 150, 50)
    
    local connection
    connection = UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end
        if input.UserInputType == Enum.UserInputType.Keyboard then
            AIM_KEY = input.KeyCode
            keyButton.Text = "Aim Key: " .. AIM_KEY.Name
            keyButton.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
            connection:Disconnect()
        end
    end)
end)

-- ========== 9. ЛОГИКА: VISUAL (FULLBRIGHT) ==========
local fullbrightActive = false
local oldLighting = {}
local fbLabel, fbBar, fbFill, fbKnob = nil, nil, nil, nil

local fullbrightBtn = makeButton("Fullbright", "Fullbright: OFF", Color3.fromRGB(70, 70, 90), visualTab, 10)

local function toggleFullbright(state)
    fullbrightActive = state
    if fullbrightActive then
        fullbrightBtn.BackgroundColor3 = Color3.fromRGB(60, 200, 90)
        fullbrightBtn.Text = "Fullbright: ON"
        
        oldLighting.Ambient = Lighting.Ambient
        oldLighting.OutdoorAmbient = Lighting.OutdoorAmbient
        oldLighting.Brightness = Lighting.Brightness
        oldLighting.ClockTime = Lighting.ClockTime
        oldLighting.GlobalShadows = Lighting.GlobalShadows
        
        Lighting.Ambient = Color3.fromRGB(255, 255, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
        Lighting.Brightness = 2
        Lighting.ClockTime = 12
        Lighting.GlobalShadows = false
        
        task.spawn(function()
            while fullbrightActive do
                task.wait(0.1)
                if fullbrightActive then
                    Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                    Lighting.OutdoorAmbient = Color3.fromRGB(255, 255, 255)
                    Lighting.Brightness = 2
                    Lighting.ClockTime = 12
                    Lighting.GlobalShadows = false
                end
            end
        end)
        activeFunctions["Fullbright"] = function() toggleFullbright(false) end
    else
        fullbrightBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 90)
        fullbrightBtn.Text = "Fullbright: OFF"
        
        Lighting.Ambient = oldLighting.Ambient
        Lighting.OutdoorAmbient = oldLighting.OutdoorAmbient
        Lighting.Brightness = oldLighting.Brightness
        Lighting.ClockTime = oldLighting.ClockTime
        Lighting.GlobalShadows = oldLighting.GlobalShadows
        activeFunctions["Fullbright"] = nil
    end
end

fullbrightBtn.MouseButton1Click:Connect(function() toggleFullbright(not fullbrightActive) end)

-- ========== 10. KILL (ПОЛНЫЙ СБРОС) ==========
local killButton = makeButton("Kill", "Kill", Color3.fromRGB(220, 70, 70), window, 435)
killButton.MouseButton1Click:Connect(function()
    -- 1. Отключаем все активные функции
    for name, disableFunc in pairs(activeFunctions) do
        pcall(disableFunc)
    end
    
    -- 2. Сбрасываем настройки персонажа на стандартные
    if player.Character and player.Character:FindFirstChild("Humanoid") then
        player.Character.Humanoid.WalkSpeed = 16
        player.Character.Humanoid.JumpPower = 50
    end
    
    -- 3. Убираем все физические силы с персонажа (на случай если что-то осталось)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = player.Character.HumanoidRootPart
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        for _, obj in ipairs(hrp:GetChildren()) do
            if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyAngularVelocity") then
                obj:Destroy()
            end
        end
    end
    
    -- 4. Восстанавливаем ноклип (если был включен, но функции не сработали)
    if player.Character then
        for _, v in ipairs(player.Character:GetDescendants()) do
            if v:IsA("BasePart") then v.CanCollide = true end
        end
    end
    
    -- 5. Закрываем GUI
    gui:Destroy()
end)
