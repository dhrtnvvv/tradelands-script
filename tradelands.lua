-- Tradelands Hub [Delta Mobile] — автофарм + функции
-- Интерфейс как Thunder Hub MM2
local plr = game.Players.LocalPlayer
local uis = game:GetService("UserInputService")
local camera = workspace.CurrentCamera
local runService = game:GetService("RunService")

-- Проверка на Delta
local isMobile = uis.TouchEnabled

-- GUI
local gui = Instance.new("ScreenGui")
gui.Parent = game:GetService("CoreGui")
gui.Name = "TradelandsHub"

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = gui
mainFrame.Active = true
mainFrame.Draggable = true

-- Заголовок
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -70, 1, 0)
title.Position = UDim2.new(0, 10, 0, 0)
title.BackgroundTransparency = 1
title.Text = "Tradelands Hub [Delta]"
title.TextColor3 = Color3.fromRGB(0, 255, 200)
title.TextSize = 16
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 30, 1, 0)
closeBtn.Position = UDim2.new(1, -35, 0, 0)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "✕"
closeBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
closeBtn.TextSize = 20
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = titleBar
closeBtn.MouseButton1Click:Connect(function() mainFrame.Visible = false end)

-- Вкладки
local tabs = {"Главная", "Фарм", "Транспорт", "Другое"}
local tabBtns = {}
local tabContents = {}

local tabBar = Instance.new("Frame")
tabBar.Size = UDim2.new(1, 0, 0, 32)
tabBar.Position = UDim2.new(0, 0, 0, 35)
tabBar.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
tabBar.BorderSizePixel = 0
tabBar.Parent = mainFrame

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1 / #tabs, 0, 1, 0)
    btn.Position = UDim2.new((i - 1) / #tabs, 0, 0, 0)
    btn.BackgroundTransparency = 1
    btn.Text = name
    btn.TextColor3 = (i == 1) and Color3.fromRGB(0, 255, 200) or Color3.fromRGB(160, 160, 180)
    btn.TextSize = 12
    btn.Font = Enum.Font.Gotham
    btn.Parent = tabBar
    table.insert(tabBtns, btn)
    
    local content = Instance.new("ScrollingFrame")
    content.Size = UDim2.new(1, -10, 1, -82)
    content.Position = UDim2.new(0, 5, 0, 72)
    content.BackgroundTransparency = 1
    content.CanvasSize = UDim2.new(0, 0, 0, 0)
    content.ScrollBarThickness = 4
    content.ScrollBarImageColor3 = Color3.fromRGB(0, 255, 200)
    content.Parent = mainFrame
    content.Visible = (i == 1)
    table.insert(tabContents, content)
    
    local layout = Instance.new("UIListLayout")
    layout.Padding = UDim.new(0, 6)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Parent = content
    
    btn.MouseButton1Click:Connect(function()
        for _, b in ipairs(tabBtns) do
            b.TextColor3 = Color3.fromRGB(160, 160, 180)
        end
        btn.TextColor3 = Color3.fromRGB(0, 255, 200)
        for _, c in ipairs(tabContents) do
            c.Visible = false
        end
        content.Visible = true
    end)
end

-- === ФУНКЦИИ GUI ===
local function toggle(parent, text, default, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
    btn.BorderSizePixel = 0
    btn.Text = text .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.fromRGB(210, 210, 225)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    
    local state = default
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
    callback(default)
end

local function button(parent, text, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    btn.BorderSizePixel = 0
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(210, 210, 225)
    btn.TextSize = 13
    btn.Font = Enum.Font.Gotham
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
end

-- === ПЕРЕМЕННЫЕ ===
local char = plr.Character or plr.CharacterAdded:Wait()
local root = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChild("Humanoid")

plr.CharacterAdded:Connect(function(c)
    char = c
    root = c:FindFirstChild("HumanoidRootPart")
    hum = c:FindFirstChild("Humanoid")
end)

-- === ФУНКЦИИ ФАРМА ===
local function getNearbyNPC()
    local closest = nil
    local dist = math.huge
    if not root then return nil end
    for _, npc in pairs(workspace:GetDescendants()) do
        if npc:IsA("Model") and npc:FindFirstChild("HumanoidRootPart") and npc:FindFirstChild("Humanoid") then
            if npc.Name:find("NPC") or npc.Name:find("Merchant") or npc.Name:find("Trader") then
                local d = (root.Position - npc.HumanoidRootPart.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = npc
                end
            end
        end
    end
    return closest
end

local function getNearbyTree()
    local closest = nil
    local dist = math.huge
    if not root then return nil end
    for _, tree in pairs(workspace:GetDescendants()) do
        if tree:IsA("Part") and tree.Name:find("Tree") or tree.Name:find("Wood") then
            if tree.Parent and tree.Parent:FindFirstChild("HumanoidRootPart") then
                local d = (root.Position - tree.Position).Magnitude
                if d < dist then
                    dist = d
                    closest = tree
                end
            end
        end
    end
    return closest
end

local function getNearestOre()
    local closest = nil
    local dist = math.huge
    if not root then return nil end
    for _, ore in pairs(workspace:GetDescendants()) do
        if ore:IsA("Part") and (ore.Name:find("Rock") or ore.Name:find("Ore") or ore.Name:find("Stone")) then
            local d = (root.Position - ore.Position).Magnitude
            if d < dist then
                dist = d
                closest = ore
            end
        end
    end
    return closest
end

-- === НАПОЛНЕНИЕ ВКЛАДОК ===
local mainTab = tabContents[1]
local farmTab = tabContents[2]
local transportTab = tabContents[3]
local otherTab = tabContents[4]

-- ГЛАВНАЯ
button(mainTab, "Телепорт к NPC", function()
    local npc = getNearbyNPC()
    if npc and npc:FindFirstChild("HumanoidRootPart") and root then
        root.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
    end
end)

button(mainTab, "Телепорт к дереву", function()
    local tree = getNearbyTree()
    if tree and root then
        root.CFrame = CFrame.new(tree.Position + Vector3.new(0, 3, 0))
    end
end)

button(mainTab, "Телепорт к руде", function()
    local ore = getNearestOre()
    if ore and root then
        root.CFrame = CFrame.new(ore.Position + Vector3.new(0, 3, 0))
    end
end)

-- ФАРМ
local autoFarmWood = false
toggle(farmTab, "Автофарм дерева", false, function(v)
    autoFarmWood = v
    spawn(function()
        while autoFarmWood do
            if not root then break end
            local tree = getNearbyTree()
            if tree then
                root.CFrame = CFrame.new(tree.Position + Vector3.new(0, 3, 0))
                wait(0.5)
                -- Симуляция рубки (если есть инструмент)
                if char and char:FindFirstChild("Tool") then
                    local tool = char:FindFirstChild("Tool")
                    tool:Activate()
                end
            end
            wait(1)
        end
    end)
end)

local autoFarmOre = false
toggle(farmTab, "Автофарм руды", false, function(v)
    autoFarmOre = v
    spawn(function()
        while autoFarmOre do
            if not root then break end
            local ore = getNearestOre()
            if ore then
                root.CFrame = CFrame.new(ore.Position + Vector3.new(0, 3, 0))
                wait(0.5)
                if char and char:FindFirstChild("Tool") then
                    local tool = char:FindFirstChild("Tool")
                    tool:Activate()
                end
            end
            wait(1)
        end
    end)
end)

local autoFarmNPC = false
toggle(farmTab, "Автофарм NPC (торговля)", false, function(v)
    autoFarmNPC = v
    spawn(function()
        while autoFarmNPC do
            if not root then break end
            local npc = getNearbyNPC()
            if npc and npc:FindFirstChild("HumanoidRootPart") then
                root.CFrame = npc.HumanoidRootPart.CFrame + Vector3.new(0, 3, 0)
                wait(0.5)
                -- Имитация взаимодействия
                local click = Instance.new("ClickDetector")
                click.Parent = npc
                click:Click()
                wait(0.5)
                click:Destroy()
            end
            wait(2)
        end
    end)
end)

-- ТРАНСПОРТ
button(transportTab, "Призвать лодку", function()
    -- Попытка найти лодку в инвентаре
    if char and char:FindFirstChild("Backpack") then
        for _, item in pairs(char.Backpack:GetChildren()) do
            if item:IsA("Tool") and item.Name:find("Boat") or item.Name:find("Ship") then
                item:Activate()
            end
        end
    end
end)

local fly = false
local flySpeed = 50
local bv, bg = nil, nil
toggle(transportTab, "Fly (WASD + Space/Shift)", false, function(v)
    fly = v
    if v then
        if hum then hum.PlatformStand = true end
        if root then
            bv = Instance.new("BodyVelocity")
            bv.MaxForce = Vector3.new(1e6, 1e6, 1e6)
            bv.Parent = root
            bg = Instance.new("BodyGyro")
            bg.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
            bg.CFrame = root.CFrame
            bg.Parent = root
            runService.RenderStepped:Connect(function()
                if not fly then return end
                if not root then return end
                local d = Vector3.new(0, 0, 0)
                if uis:IsKeyDown(Enum.KeyCode.W) then d = d + camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
                if uis:IsKeyDown(Enum.KeyCode.S) then d = d - camera.CFrame.LookVector * Vector3.new(1, 0, 1) end
                if uis:IsKeyDown(Enum.KeyCode.A) then d = d - camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.D) then d = d + camera.CFrame.RightVector end
                if uis:IsKeyDown(Enum.KeyCode.Space) then d = d + Vector3.new(0, 1, 0) end
                if uis:IsKeyDown(Enum.KeyCode.LeftShift) then d = d - Vector3.new(0, 1, 0) end
                if d.Magnitude > 0 then d = d.Unit * flySpeed end
                if bv then bv.Velocity = d end
                if bg then bg.CFrame = camera.CFrame end
            end)
        end
    else
        if hum then hum.PlatformStand = false end
        if bv then bv:Destroy(); bv = nil end
        if bg then bg:Destroy(); bg = nil end
    end
end)

local noclip = false
local noclipParts = {}
toggle(transportTab, "NoClip", false, function(v)
    noclip = v
    spawn(function()
        while noclip do
            if char then
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") and not part:FindFirstChild("NCP") then
                        local nc = Instance.new("NoClip")
                        nc.Name = "NCP"
                        nc.Parent = part
                        table.insert(noclipParts, nc)
                    end
                end
            end
            wait(0.3)
        end
        for _, obj in pairs(noclipParts) do
            if obj and obj.Parent then obj:Destroy() end
        end
        noclipParts = {}
    end)
end)

-- ДРУГОЕ
local antiAfk = false
toggle(otherTab, "Anti-AFK", false, function(v)
    antiAfk = v
    spawn(function()
        while antiAfk do
            if hum then hum:ChangeState(Enum.HumanoidStateType.Running) end
            wait(15)
        end
    end)
end)

button(otherTab, "Перезагрузить персонажа", function()
    if plr and plr.Character then
        plr.Character:BreakJoints()
        wait(1)
        plr.CharacterAdded:Wait()
    end
end)

-- Обновление скролла
for _, c in ipairs(tabContents) do
    local function updateScroll()
        c.CanvasSize = UDim2.new(0, 0, 0, c.AbsoluteContentSize.Y + 20)
    end
    c:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateScroll)
    updateScroll()
end

-- Скрытие по Insert (для мобильных — двойной тап)
uis.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.Insert then
        mainFrame.Visible = not mainFrame.Visible
    end
end)

-- Для мобильных: двойной тап по пустому месту (не реализовано, но можно добавить)
