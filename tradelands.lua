-- Tradelands Hub [Stylish] — красивый интерфейс, сворачивание
local player = game.Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local rootPart = character:WaitForChild("HumanoidRootPart")

-- GUI с красивым дизайном
local screenGui = Instance.new("ScreenGui")
screenGui.Parent = player:WaitForChild("PlayerGui")
screenGui.Name = "TradelandsHub"
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 420, 0, 480)
mainFrame.Position = UDim2.new(0.5, -210, 0.5, -240)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
mainFrame.BackgroundTransparency = 0.08
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

-- === ЗАГОЛОВОК С ПАНЕЛЬЮ ===
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 38)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 25, 42)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 12, 0, 0)
title.BackgroundTransparency = 1
title.Text = "✦ Tradelands Hub"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

-- Кнопка сворачивания
local minimizeBtn = Instance.new("TextButton")
minimizeBtn.Size = UDim2.new(0, 30, 1, 0)
minimizeBtn.Position = UDim2.new(1, -70, 0, 0)
minimizeBtn.BackgroundTransparency = 1
minimizeBtn.Text = "─"
minimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 210)
minimizeBtn.TextSize = 22
minimizeBtn.Font = Enum.Font.GothamBold
minimizeBtn.Parent = titleBar
minimizeBtn.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
    -- Показываем иконку, если скрыто
    if not mainFrame.Visible then
        miniIcon.Visible = true
    end
end)

-- Кнопка закрытия
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 18
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

-- Иконка для сворачивания (маленький кружок)
local miniIcon = Instance.new("TextButton")
miniIcon.Size = UDim2.new(0, 44, 0, 44)
miniIcon.Position = UDim2.new(0, 20, 0, 100)
miniIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
miniIcon.BackgroundTransparency = 0.2
miniIcon.BorderSizePixel = 0
miniIcon.Text = "⚡"
miniIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
miniIcon.TextSize = 22
miniIcon.Font = Enum.Font.GothamBold
miniIcon.Parent = screenGui
miniIcon.Visible = false
miniIcon.Active = true
miniIcon.Draggable = true
miniIcon.MouseButton1Click:Connect(function()
    mainFrame.Visible = true
    miniIcon.Visible = false
end)

-- === ВКЛАДКИ ===
local tabs = {"Главная", "Фарм", "Транспорт", "Прочее"}
local tabButtons = {}
local tabContents = {}

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 34)
tabBar.Position = UDim2.new(0, 0, 0, 38)
tabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 32)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.Position = UDim2.new((i - 1) / #tabs, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(160, 160, 185)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = tabBar
    table.insert(tabButtons, btn)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -12, 1, -85)
    content.Position = UDim2.new(0, 6, 0, 78)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 5
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    content.ScrollBarImageTransparency = 0.3
    content.BorderSizePixel = 0
    content.Parent = mainFrame
    content.Visible = (i == 1)
    table.insert(tabContents, content)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabButtons) do
            b.TextColor3 = Color3.fromRGB(160, 160, 185)
        end
        btn.TextColor3 = Color3.fromRGB(0, 255, 200)
        for _, c in ipairs(tabContents) do
            c.Visible = false
        end
        content.Visible = true
    end)
end

-- === СТИЛЬНЫЕ КНОПКИ ===
local function createToggle(parent, text, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(1, 0, 0, 36)
    frame.BackgroundColor3 = Color3.fromRGB(38, 38, 52)
    frame.BackgroundTransparency = 0.3
    frame.BorderSizePixel = 0
    frame.Parent = parent
    
    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, -70, 1, 0)
    label.Position = UDim2.new(0, 12, 0, 0)
    label.BackgroundTransparency = 1
    label.Text = text
    label.TextColor3 = Color3.fromRGB(210, 210, 225)
    label.TextSize = 13
    label.Font = Enum.Font.Gotham
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.Parent = frame
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 60, 0, 28)
    btn.Position = UDim2.new(1, -70, 0, 4)
    btn.BackgroundColor3 = default and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(60, 60, 75)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = default and "ON" or "OFF"
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 12
    btn.Font = Enum.Font.GothamBold
    btn.Parent = frame
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(60, 60, 75)
        btn.Text = state and "ON" or "OFF"
        callback(state)
    end)
    callback(default)
end

local function createButton(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 36)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 68)
    btn.BackgroundTransparency = 0.2
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(220, 220, 230)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    
    -- Эффект при наведении
    btn.MouseEnter:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 80)
    end)
    btn.MouseLeave:Connect(function()
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 68)
    end)
end

-- === ФУНКЦИИ ===
local function getNearestTree()
    local closest = nil
    local minDist = math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find("Tree") then
            local pos = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
            if pos then
                local dist = (rootPart.Position - pos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = obj
                end
            end
        end
    end
    return closest
end

local function getNearestResource(resourceName)
    local closest = nil
    local minDist = math.huge
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Model") and obj.Name:find(resourceName) then
            local pos = obj:FindFirstChild("PrimaryPart") or obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChild("Head")
            if pos then
                local dist = (rootPart.Position - pos.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = obj
                end
            end
        end
    end
    return closest
end

local function equipTool(toolName)
    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        for _, tool in pairs(backpack:GetChildren()) do
            if tool:IsA("Tool") and tool.Name:find(toolName) then
                tool.Parent = character
                return tool
            end
        end
    end
    return nil
end

local function useTool()
    local tool = character:FindFirstChildWhichIsA("Tool")
    if tool then
        tool:Activate()
        return true
    end
    return false
end

-- === НАПОЛНЕНИЕ ВКЛАДОК ===
local mainTab = tabContents[1]
local farmTab = tabContents[2]
local transportTab = tabContents[3]
local otherTab = tabContents[4]

-- ГЛАВНАЯ
createButton(mainTab, "🌲 Телепорт к дереву", function()
    local tree = getNearestTree()
    if tree then
        local pos = tree:FindFirstChild("PrimaryPart") or tree:FindFirstChild("HumanoidRootPart") or tree:FindFirstChild("Head")
        if pos then
            rootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 3, 0))
        end
    end
end)

createButton(mainTab, "🪨 Телепорт к руде", function()
    local ore = getNearestResource("Rock")
    if not ore then ore = getNearestResource("Ore") end
    if ore then
        local pos = ore:FindFirstChild("PrimaryPart") or ore:FindFirstChild("HumanoidRootPart") or ore:FindFirstChild("Head")
        if pos then
            rootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 3, 0))
        end
    end
end)

createButton(mainTab, "👤 Телепорт к NPC", function()
    local npc = getNearestResource("NPC")
    if not npc then npc = getNearestResource("Merchant") end
    if npc then
        local pos = npc:FindFirstChild("PrimaryPart") or npc:FindFirstChild("HumanoidRootPart") or npc:FindFirstChild("Head")
        if pos then
            rootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 3, 0))
        end
    end
end)

-- ФАРМ
local farmingWood = false
createToggle(farmTab, "🌲 Автофарм дерева", false, function(v)
    farmingWood = v
    spawn(function()
        while farmingWood do
            local tree = getNearestTree()
            if tree then
                local pos = tree:FindFirstChild("PrimaryPart") or tree:FindFirstChild("HumanoidRootPart") or tree:FindFirstChild("Head")
                if pos then
                    rootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 2, 0))
                    wait(0.3)
                    equipTool("Axe") or equipTool("Hatchet")
                    wait(0.2)
                    useTool()
                end
            end
            wait(1)
        end
    end)
end)

local farmingOre = false
createToggle(farmTab, "🪨 Автофарм руды", false, function(v)
    farmingOre = v
    spawn(function()
        while farmingOre do
            local ore = getNearestResource("Rock")
            if not ore then ore = getNearestResource("Ore") end
            if ore then
                local pos = ore:FindFirstChild("PrimaryPart") or ore:FindFirstChild("HumanoidRootPart") or ore:FindFirstChild("Head")
                if pos then
                    rootPart.CFrame = CFrame.new(pos.Position + Vector3.new(0, 2, 0))
                    wait(0.3)
                    equipTool("Pickaxe")
                    wait(0.2)
                    useTool()
                end
            end
            wait(1)
        end
    end)
end)

-- ТРАНСПОРТ
local flying = false
local flySpeed = 50
local bodyVel, bodyGyro = nil, nil
local flyConnection = nil

createToggle(transportTab, "✈ Fly (WASD + Space/Shift)", false, function(v)
    flying = v
    if v then
        humanoid.PlatformStand = true
        bodyVel = Instance.new("BodyVelocity")
        bodyVel.MaxForce = Vector3.new(1e6, 1e6, 1e6)
        bodyVel.Parent = rootPart
        
        bodyGyro = Instance.new("BodyGyro")
        bodyGyro.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        bodyGyro.CFrame = rootPart.CFrame
        bodyGyro.Parent = rootPart
        
        if flyConnection then flyConnection:Disconnect() end
        flyConnection = game:GetService("RunService").RenderStepped:Connect(function()
            if not flying then return end
            local move = Vector3.new(0, 0, 0)
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.W) then
                move = move + workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.S) then
                move = move - workspace.CurrentCamera.CFrame.LookVector * Vector3.new(1, 0, 1)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.A) then
                move = move - workspace.CurrentCamera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.D) then
                move = move + workspace.CurrentCamera.CFrame.RightVector
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.Space) then
                move = move + Vector3.new(0, 1, 0)
            end
            if game:GetService("UserInputService"):IsKeyDown(Enum.KeyCode.LeftShift) then
                move = move - Vector3.new(0, 1, 0)
            end
            if move.Magnitude > 0 then
                move = move.Unit * flySpeed
            end
            if bodyVel then bodyVel.Velocity = move end
            if bodyGyro then bodyGyro.CFrame = workspace.CurrentCamera.CFrame end
        end)
    else
        humanoid.PlatformStand = false
        if bodyVel then bodyVel:Destroy(); bodyVel = nil end
        if bodyGyro then bodyGyro:Destroy(); bodyGyro = nil end
        if flyConnection then flyConnection:Disconnect(); flyConnection = nil end
    end
end)

local noClip = false
local noClipParts = {}
createToggle(transportTab, "🔓 NoClip", false, function(v)
    noClip = v
    spawn(function()
        while noClip do
            for _, part in pairs(character:GetDescendants()) do
                if part:IsA("BasePart") and not part:FindFirstChild("NoClip_") then
                    local nc = Instance.new("NoCollisionConstraint")
                    nc.Name = "NoClip_"
                    nc.Parent = part
                    table.insert(noClipParts, nc)
                end
            end
            wait(0.5)
        end
        for _, obj in pairs(noClipParts) do
            if obj and obj.Parent then obj:Destroy() end
        end
        noClipParts = {}
    end)
end)

-- ПРОЧЕЕ
local antiAFK = false
createToggle(otherTab, "🛡 Anti-AFK", false, function(v)
    antiAFK = v
    spawn(function()
        while antiAFK do
            humanoid:ChangeState(Enum.HumanoidStateType.Running)
            wait(15)
        end
    end)
end)

createButton(otherTab, "🔄 Перезагрузить персонажа", function()
    player.Character:BreakJoints()
end)

-- Обновление скролла
for _, c in ipairs(tabContents) do
    local function updateScroll()
        c.CanvasSize = UDim2.new(0, 0, 0, c.AbsoluteContentSize.Y + 20)
    end
    c:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScroll)
    updateScroll()
end

-- Скрытие/показ по Insert
game:GetService("UserInputService").InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
        if not mainFrame.Visible then
            miniIcon.Visible = true
        else
            miniIcon.Visible = false
        end
    end
end)
