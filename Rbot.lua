--[[
    🤖 Rbot Premium v3.2
    ✅ Fast Click + Auto Farm + Logo Toggle
    Beautiful Modern Design 2026
]]

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local TPS = game:GetService("TeleportService")
local LP = Players.LocalPlayer

print("=== Rbot v3.2 Loading ===")

-- ================== CHECK GAME ==================
local WORLD = {
    [2753915549] = "Sea 1",
    [4442272183] = "Sea 2",
    [7449423635] = "Sea 3",
}
if not WORLD[game.PlaceId] then
    warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!")
    return
end
print("🎮 Game: " .. WORLD[game.PlaceId])

-- ================== CONFIG ==================
local CFG = {
    AutoFarm = false,
    Magnet = false,
    AutoSkill = true,
    AutoHaki = true,
    FastAttack = true,
    AutoClick = true,
    NoClip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Distance = 30,
    ClickDelay = 0.05,  -- ความเร็วคลิก (ยิ่งน้อยยิ่งเร็ว)
}

-- ================== HELPERS ==================
local cachedChar, cachedHRP, cachedHum

local function OnChar(c)
    cachedChar = c
    cachedHRP = c:WaitForChild("HumanoidRootPart", 10)
    cachedHum = c:WaitForChild("Humanoid", 10)
    -- Anti-fall
    task.spawn(function()
        while cachedChar == c and c.Parent do
            task.wait(1)
            local h = c:FindFirstChild("Humanoid")
            if h and h.Health > 0 and h:GetState() == Enum.HumanoidStateType.Freefall then
                if h.FloorMaterial == Enum.Material.Air and c:FindFirstChild("HumanoidRootPart") then
                    -- กำลังตก ไม่ต้องทำอะไร
                end
            end
        end
    end)
end

if LP.Character then OnChar(LP.Character) end
LP.CharacterAdded:Connect(OnChar)

local function Char() return cachedChar or LP.Character end
local function HRP() return cachedHRP end
local function Hum() return cachedHum end

local function SafeGet(tbl, key)
    local ok, v = pcall(function() return tbl[key].Value end)
    return ok and v or 0
end

local function FormatNum(n)
    if n >= 1e9 then return string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- ================== ⚡ FAST CLICK ==================
local function Click()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(0, 0))
    end)
end

-- Fast Click Loop (สำคัญ! ทำให้คลิกเร็วมาก)
task.spawn(function()
    while task.wait() do
        if CFG.AutoClick then
            pcall(function()
                local h = HRP()
                if not h then return end
                -- เช็คว่ามีมอนใกล้ๆ หรือ AutoFarm เปิดอยู่
                local shouldClick = CFG.AutoFarm
                if not shouldClick then
                    local en = workspace:FindFirstChild("Enemies")
                    if en then
                        for _, m in pairs(en:GetChildren()) do
                            local hrp = m:FindFirstChild("HumanoidRootPart")
                            local hum = m:FindFirstChild("Humanoid")
                            if hrp and hum and hum.Health > 0 
                               and (hrp.Position - h.Position).Magnitude <= 100 then
                                shouldClick = true
                                break
                            end
                        end
                    end
                end
                if shouldClick then Click() end
            end)
        end
    end
end)

-- ================== ⌨️ SKILL COMBO ==================
local SKILL_KEYS = {
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V,
    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R,
}

local function PressKey(keyCode)
    pcall(function()
        VIM:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.02)
        VIM:SendKeyEvent(false, keyCode, false, game)
    end)
end

-- Fast Skill Loop
task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoSkill then
            pcall(function()
                local c = Char()
                local h = HRP()
                if not c or not h then return end
                
                -- เช็คว่ามีมอนใกล้ๆ
                local hasEnemy = false
                local en = workspace:FindFirstChild("Enemies")
                if en then
                    for _, m in pairs(en:GetChildren()) do
                        local hrp = m:FindFirstChild("HumanoidRootPart")
                        local hum = m:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 
                           and (hrp.Position - h.Position).Magnitude <= 60 then
                            hasEnemy = true
                            break
                        end
                    end
                end
                
                if hasEnemy then
                    for _, k in pairs(SKILL_KEYS) do
                        PressKey(k)
                        task.wait(0.05)
                    end
                end
            end)
        end
    end
end)

-- ================== ANTI-AFK ==================
LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ================== STATS ==================
task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local h = Hum()
            if h then
                h.WalkSpeed = CFG.WalkSpeed
                h.JumpPower = CFG.JumpPower
            end
        end)
    end
end)

-- ================== AUTO HAKI ==================
task.spawn(function()
    while task.wait(0.5) do
        if CFG.AutoHaki then
            pcall(function()
                local c = Char()
                if c and not c:FindFirstChild("HasBuso") then
                    RS.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

-- ================== FAST ATTACK ==================
task.spawn(function()
    local getup = getupvalues or debug.getupvalue
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getup(c)[2]
    end)
    if not ok then
        warn("⚠️ FastAttack ไม่พร้อม")
        return
    end
    while task.wait(0.1) do
        if CFG.FastAttack then
            pcall(function()
                if CF.activeController then
                    CF.activeController.timeToNextAttack = 0
                    CF.activeController.attacking = false
                    CF.activeController.increment = 4
                    CF.activeController.hitboxMagnitude = 60
                    CF.activeController.blocking = false
                end
            end)
        end
    end
end)

-- ================== NOCLIP ==================
task.spawn(function()
    while task.wait(0.2) do
        if CFG.NoClip then
            pcall(function()
                local c = Char()
                if c then
                    for _, v in pairs(c:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then
                            v.CanCollide = false
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== MAGNET ==================
task.spawn(function()
    while task.wait(0.1) do
        if CFG.Magnet then
            pcall(function()
                local en = workspace:FindFirstChild("Enemies")
                local h = HRP()
                if not en or not h then return end
                for _, m in pairs(en:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 
                       and (hrp.Position - h.Position).Magnitude <= 350 then
                        hrp.CFrame = h.CFrame * CFrame.new(0, 30, 0)
                        hrp.Size = Vector3.new(50, 50, 50)
                        hum.WalkSpeed = 0
                    end
                end
            end)
        end
    end
end)

-- ================== AUTO FARM ==================
task.spawn(function()
    while task.wait(0.2) do
        if CFG.AutoFarm then
            pcall(function()
                local en = workspace:FindFirstChild("Enemies")
                local h = HRP()
                if not en or not h then return end
                
                -- หามอนที่ใกล้ที่สุด
                local closest, closestDist = nil, math.huge
                for _, m in pairs(en:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local d = (hrp.Position - h.Position).Magnitude
                        if d < closestDist then
                            closest = m
                            closestDist = d
                        end
                    end
                end
                
                if closest then
                    local hrp = closest:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetCF = hrp.CFrame * CFrame.new(0, CFG.Distance, 0)
                        if closestDist > 20 then
                            -- Teleport ไปหามอน
                            h.CFrame = targetCF
                        else
                            h.CFrame = targetCF
                        end
                    end
                end
            end)
        end
    end
end)

print("✅ Systems loaded")

-- ================================================================
-- ================== 🎨 PREMIUM UI ===============================
-- ================================================================

local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end
local oldBlur = Lighting:FindFirstChild("RbotBlur")
if oldBlur then oldBlur:Destroy() end

-- Blur
local Blur = Instance.new("BlurEffect")
Blur.Name = "RbotBlur"
Blur.Size = 0
Blur.Parent = Lighting

-- ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.Parent = game.CoreGui
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

-- ============ MAIN FRAME ============
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -370, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(12, 12, 18)
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 18)
MC.Parent = Main

local MStroke = Instance.new("UIStroke")
MStroke.Color = Color3.fromRGB(80, 60, 120)
MStroke.Thickness = 1.5
MStroke.Transparency = 0.3
MStroke.Parent = Main

local Glow = Instance.new("ImageLabel")
Glow.Size = UDim2.new(1, 40, 1, 40)
Glow.Position = UDim2.new(0, -20, 0, -20)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://4996891970"
Glow.ImageColor3 = Color3.fromRGB(138, 43, 226)
Glow.ImageTransparency = 0.5
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(20, 20, 280, 280)
Glow.ZIndex = 0
Glow.Parent = Main

-- ============ 🔓 TOGGLE SYSTEM ============
local uiOpen = true
local FloatingBtn
local OPEN_SIZE = UDim2.new(0, 740, 0, 500)

local function SetUIVisible(visible)
    if uiOpen == visible then return end
    uiOpen = visible

    if visible then
        Main.Visible = true
        TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = OPEN_SIZE,
            BackgroundTransparency = 0.05
        }):Play()
        TS:Create(Blur, TweenInfo.new(0.4), {Size = 14}):Play()
        if FloatingBtn then
            TS:Create(FloatingBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, -60, 0.5, -22)
            }):Play()
        end
    else
        TS:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        if FloatingBtn then
            TS:Create(FloatingBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 20, 0.5, -22)
            }):Play()
        end
        local t = TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
            Size = UDim2.new(0, 0, 0, 0)
        })
        t:Play()
        t.Completed:Connect(function()
            if not uiOpen then Main.Visible = false end
        end)
    end
end

-- Open Animation
TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = OPEN_SIZE
}):Play()
TS:Create(Blur, TweenInfo.new(0.7), {Size = 14}):Play()

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 65)
Header.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
Header.BackgroundTransparency = 0.2
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 18)
HC.Parent = Header

local HLine = Instance.new("Frame")
HLine.Size = UDim2.new(1, 0, 0, 1)
HLine.Position = UDim2.new(0, 0, 1, -1)
HLine.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
HLine.BackgroundTransparency = 0.5
HLine.BorderSizePixel = 0
HLine.Parent = Header

local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 40, 0, 40)
LogoIcon.Position = UDim2.new(0, 20, 0.5, -20)
LogoIcon.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = Header

local LIC = Instance.new("UICorner")
LIC.CornerRadius = UDim.new(1, 0)
LIC.Parent = LogoIcon

local LIG = Instance.new("UIGradient")
LIG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
}
LIG.Rotation = 45
LIG.Parent = LogoIcon

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1, 0, 1, 0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "R"
LogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.TextSize = 22
LogoTxt.Parent = LogoIcon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 25)
Title.Position = UDim2.new(0, 72, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "RBOT • PREMIUM v3.2"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 300, 0, 18)
SubTitle.Position = UDim2.new(0, 72, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Blox Fruits | " .. WORLD[game.PlaceId] .. " | " .. LP.Name
SubTitle.TextColor3 = Color3.fromRGB(160, 150, 180)
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local LevelTxt = Instance.new("TextLabel")
LevelTxt.Size = UDim2.new(0, 150, 0, 20)
LevelTxt.Position = UDim2.new(1, -250, 0, 20)
LevelTxt.BackgroundTransparency = 1
LevelTxt.Text = "LV." .. SafeGet(LP.Data, "Level")
LevelTxt.TextColor3 = Color3.fromRGB(200, 180, 255)
LevelTxt.Font = Enum.Font.GothamBold
LevelTxt.TextSize = 12
LevelTxt.TextXAlignment = Enum.TextXAlignment.Right
LevelTxt.Parent = Header

local BeliTxt = Instance.new("TextLabel")
BeliTxt.Size = UDim2.new(0, 150, 0, 18)
BeliTxt.Position = UDim2.new(1, -250, 0, 35)
BeliTxt.BackgroundTransparency = 1
BeliTxt.Text = "💰 " .. FormatNum(SafeGet(LP.Data, "Beli"))
BeliTxt.TextColor3 = Color3.fromRGB(160, 150, 180)
BeliTxt.Font = Enum.Font.Gotham
BeliTxt.TextSize = 10
BeliTxt.TextXAlignment = Enum.TextXAlignment.Right
BeliTxt.Parent = Header

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelTxt.Text = "LV." .. SafeGet(LP.Data, "Level")
            BeliTxt.Text = "💰 " .. FormatNum(SafeGet(LP.Data, "Beli"))
        end)
    end
end)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 36, 0, 36)
MinBtn.Position = UDim2.new(1, -95, 0.5, -18)
MinBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.BackgroundTransparency = 0.9
MinBtn.Text = "−"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header

local MinC = Instance.new("UICorner")
MinC.CornerRadius = UDim.new(1, 0)
MinC.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.6,
        BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    }):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)
MinBtn.MouseButton1Click:Connect(function()
    SetUIVisible(false)
end)

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 36, 0, 36)
CloseBtn.Position = UDim2.new(1, -50, 0.5, -18)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 0.9
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(1, 0)
CBC.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.6,
        BackgroundColor3 = Color3.fromRGB(255, 60, 80)
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.9,
        BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    }):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    SetUIVisible(false)
end)

-- ============ SIDEBAR ============
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 190, 1, -85)
Sidebar.Position = UDim2.new(0, 15, 0, 75)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Sidebar.BackgroundTransparency = 0.3
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 14)
SBC.Parent = Sidebar

local SBStroke = Instance.new("UIStroke")
SBStroke.Color = Color3.fromRGB(60, 50, 90)
SBStroke.Thickness = 1
SBStroke.Transparency = 0.5
SBStroke.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, -16, 1, -16)
TabList.Position = UDim2.new(0, 8, 0, 8)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TLLay = Instance.new("UIListLayout")
TLLay.Parent = TabList
TLLay.SortOrder = Enum.SortOrder.LayoutOrder
TLLay.Padding = UDim.new(0, 6)

-- ============ CONTENT ============
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -230, 1, -85)
Content.Position = UDim2.new(0, 215, 0, 75)
Content.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
Content.BackgroundTransparency = 0.3
Content.BorderSizePixel = 0
Content.Parent = Main

local CNC = Instance.new("UICorner")
CNC.CornerRadius = UDim.new(0, 14)
CNC.Parent = Content

local CNStroke = Instance.new("UIStroke")
CNStroke.Color = Color3.fromRGB(60, 50, 90)
CNStroke.Thickness = 1
CNStroke.Transparency = 0.5
CNStroke.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(138, 43, 226)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Content

local SLLay = Instance.new("UIListLayout")
SLLay.Parent = Scroll
SLLay.SortOrder = Enum.SortOrder.LayoutOrder
SLLay.Padding = UDim.new(0, 8)

SLLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, SLLay.AbsoluteContentSize.Y + 20)
end)

-- Drag Main
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 
       or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 
       or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement 
       or i.UserInputType == Enum.UserInputType.Touch) then
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X),
            startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y)
        )
    end
end)

-- ============ UI FACTORY ============
local Tabs = {}
local FirstTab = false

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 28, 42)
    Btn.BackgroundTransparency = 0.5
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. icon .. "   " .. name
    Btn.TextColor3 = Color3.fromRGB(160, 150, 190)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.Parent = TabList

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = Btn

    local Ind = Instance.new("Frame")
    Ind.Size = UDim2.new(0, 3, 0, 0)
    Ind.Position = UDim2.new(0, 0, 0.5, 0)
    Ind.AnchorPoint = Vector2.new(0, 0.5)
    Ind.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Ind.BorderSizePixel = 0
    Ind.Parent = Btn

    local IndC = Instance.new("UICorner")
    IndC.CornerRadius = UDim.new(1, 0)
    IndC.Parent = Ind

    local IndGrad = Instance.new("UIGradient")
    IndGrad.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
    }
    IndGrad.Rotation = 90
    IndGrad.Parent = Ind

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Parent = Scroll
    page.Visible = false

    local pLay = Instance.new("UIListLayout")
    pLay.Parent = page
    pLay.SortOrder = Enum.SortOrder.LayoutOrder
    pLay.Padding = UDim.new(0, 8)

    table.insert(Tabs, {Btn = Btn, Page = page, Ind = Ind})

    Btn.MouseEnter:Connect(function()
        if page.Visible then return end
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3, 
            TextColor3 = Color3.fromRGB(220, 210, 255)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if page.Visible then return end
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5, 
            TextColor3 = Color3.fromRGB(160, 150, 190)
        }):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TS:Create(t.Btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.5, 
                TextColor3 = Color3.fromRGB(160, 150, 190)
            }):Play()
            TS:Create(t.Ind, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 3, 0, 0)
            }):Play()
        end
        page.Visible = true
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0, 
            TextColor3 = Color3.fromRGB(255, 255, 255)
        }):Play()
        TS:Create(Ind, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 3, 0, 26)
        }):Play()
    end)

    if not FirstTab then
        FirstTab = true
        page.Visible = true
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Ind.Size = UDim2.new(0, 3, 0, 26)
    end

    return page
end

local function Section(parent, title)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, -8, 0, 26)
    S.BackgroundTransparency = 1
    S.Text = "  ▸  " .. title
    S.TextColor3 = Color3.fromRGB(200, 150, 255)
    S.Font = Enum.Font.GothamBold
    S.TextSize = 11
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = parent
end

local function Toggle(parent, name, desc, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 58)
    F.BackgroundColor3 = Color3.fromRGB(28, 26, 38)
    F.BackgroundTransparency = 0.2
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 50, 90)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -90, 0, 22)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(235, 230, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -90, 0, 16)
    D.Position = UDim2.new(0, 16, 0, 30)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = Color3.fromRGB(140, 130, 165)
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(0, 46, 0, 24)
    Bg.Position = UDim2.new(1, -62, 0.5, -12)
    Bg.BackgroundColor3 = CFG[key] and Color3.fromRGB(138, 43, 226) or Color3.fromRGB(48, 45, 62)
    Bg.BorderSizePixel = 0
    Bg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = Bg

    local G
    if CFG[key] then
        G = Instance.new("UIGradient")
        G.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
        }
        G.Parent = Bg
    end

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 20, 0, 20)
    Dot.Position = CFG[key] and UDim2.new(1, -22, 0.5, -10) or UDim2.new(0, 2, 0.5, -10)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Bg

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = Dot

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = F

    Btn.MouseButton1Click:Connect(function()
        CFG[key] = not CFG[key]
        if CFG[key] then
            TS:Create(Bg, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(138, 43, 226)
            }):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {
                Position = UDim2.new(1, -22, 0.5, -10)
            }):Play()
            if not G then
                G = Instance.new("UIGradient")
                G.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
                }
                G.Parent = Bg
            end
        else
            TS:Create(Bg, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(48, 45, 62)
            }):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {
                Position = UDim2.new(0, 2, 0.5, -10)
            }):Play()
            if G then G:Destroy() G = nil end
        end
    end)
end

local function Slider(parent, name, min, max, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 68)
    F.BackgroundColor3 = Color3.fromRGB(28, 26, 38)
    F.BackgroundTransparency = 0.2
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 50, 90)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 22)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name .. "  :  " .. CFG[key]
    L.TextColor3 = Color3.fromRGB(235, 230, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -32, 0, 8)
    BarBg.Position = UDim2.new(0, 16, 0, 42)
    BarBg.BackgroundColor3 = Color3.fromRGB(48, 45, 62)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = BarBg

    local ratio = math.clamp((CFG[key] - min) / (max - min), 0, 1)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local FG = Instance.new("UIGradient")
    FG.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
    }
    FG.Parent = Fill

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 16, 0, 16)
    Dot.Position = UDim2.new(1, -8, 0.5, -8)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Fill

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = Dot

    local dragging = false
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 3, 0)
    Btn.Position = UDim2.new(0, 0, -1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = BarBg

    local function Update(input)
        local r = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + r * (max - min))
        Fill.Size = UDim2.new(r, 0, 1, 0)
        L.Text = name .. "  :  " .. v
        CFG[key] = v
    end

    Btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 
           or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 
           or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement 
           or i.UserInputType == Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
end

local function Button(parent, name, desc, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 58)
    F.BackgroundColor3 = Color3.fromRGB(28, 26, 38)
    F.BackgroundTransparency = 0.2
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 50, 90)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 22)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(235, 230, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -30, 0, 16)
    D.Position = UDim2.new(0, 16, 0, 30)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = Color3.fromRGB(140, 130, 165)
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = F

    Btn.MouseEnter:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.05, 
            BackgroundColor3 = Color3.fromRGB(45, 38, 65)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2, 
            BackgroundColor3 = Color3.fromRGB(28, 26, 38)
        }):Play()
    end)
    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- ================== TABS ==================
local HomeTab = CreateTab("หน้าหลัก", "🏠")
local FarmTab = CreateTab("ฟาร์ม", "🌾")
local SkillTab = CreateTab("สกิล", "🥋")
local MiscTab = CreateTab("อื่น ๆ", "⚙️")
local SetTab = CreateTab("ตั้งค่า", "🔧")

Section(HomeTab, "ข้อมูล")
Button(HomeTab, "🤖 Rbot Premium v3.2", "Fast Click + Logo Toggle", function() end)
Button(HomeTab, "📊 สถิติปัจจุบัน", "LV." .. SafeGet(LP.Data, "Level") .. " | 💰 " .. FormatNum(SafeGet(LP.Data, "Beli")), function() end)
Section(HomeTab, "วิธีใช้")
Button(HomeTab, "⌨️ ปุ่มลัด", "Right Ctrl = เปิด/ปิด UI", function() end)
Button(HomeTab, "🟣 โลโก้ R", "คลิกโลโก้ R เพื่อเปิด UI", function() end)

Section(FarmTab, "ฟาร์มหลัก")
Toggle(FarmTab, "Auto Farm Level", "ฟาร์มมอนอัตโนมัติ (เร็ว)", "AutoFarm")
Toggle(FarmTab, "Auto Click", "คลิกอัตโนมัติแบบ Fast", "AutoClick")
Toggle(FarmTab, "Magnet Token", "ดึงมอนเข้าหาตัว", "Magnet")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")

Section(SkillTab, "สกิล")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F E Q R อัตโนมัติ", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "ตีเร็วขึ้น (Bypass Cooldown)", "FastAttack")

Section(MiscTab, "ระบบ")
Toggle(MiscTab, "No Clip", "ทะลุกำแพง", "NoClip")

Section(SetTab, "ตัวละคร")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")
Section(SetTab, "ระบบ")
Button(SetTab, "🔄 Rejoin Server", "กลับเซิร์ฟเวอร์เดิม", function()
    TPS:Teleport(game.PlaceId, LP)
end)
Button(SetTab, "❌ ปิด UI", "ปิดหน้าต่าง UI", function()
    SetUIVisible(false)
end)

-- ================== 🟣 LOGO FLOATING BUTTON ==================
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "RbotLogo"
FloatingBtn.Size = UDim2.new(0, 56, 0, 56)
FloatingBtn.Position = UDim2.new(0, -60, 0.5, -28)  -- เริ่มซ่อน
FloatingBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Text = "R"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBlack
FloatingBtn.TextSize = 24
FloatingBtn.AutoButtonColor = false
FloatingBtn.ZIndex = 999
FloatingBtn.Parent = SG

local FBC = Instance.new("UICorner")
FBC.CornerRadius = UDim.new(1, 0)
FBC.Parent = FloatingBtn

local FBGrad = Instance.new("UIGradient")
FBGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(138, 43, 226)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 60, 100))
}
FBGrad.Rotation = 45
FBGrad.Parent = FloatingBtn

local FBStroke = Instance.new("UIStroke")
FBStroke.Color = Color3.fromRGB(255, 255, 255)
FBStroke.Thickness = 2
FBStroke.Transparency = 0.5
FBStroke.Parent = FloatingBtn

-- Glow effect
local FBGlow = Instance.new("ImageLabel")
FBGlow.Size = UDim2.new(1, 30, 1, 30)
FBGlow.Position = UDim2.new(0, -15, 0, -15)
FBGlow.BackgroundTransparency = 1
FBGlow.Image = "rbxassetid://4996891970"
FBGlow.ImageColor3 = Color3.fromRGB(138, 43, 226)
FBGlow.ImageTransparency = 0.4
FBGlow.ScaleType = Enum.ScaleType.Slice
FBGlow.SliceCenter = Rect.new(20, 20, 280, 280)
FBGlow.ZIndex = -1
FBGlow.Parent = FloatingBtn

-- Pulse animation ตอน UI ปิด
task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        task.wait(1.5)
        if not uiOpen then
            TS:Create(FloatingBtn, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 64, 0, 64)
            }):Play()
            task.wait(0.5)
            if FloatingBtn then
                TS:Create(FloatingBtn, TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 56, 0, 56)
                }):Play()
            end
        end
    end
end)

-- Drag Logo
local fbDrag, fbStart, fbStartPos
FloatingBtn.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 
       or i.UserInputType == Enum.UserInputType.Touch then
        fbDrag = true
        fbStart = i.Position
        fbStartPos = FloatingBtn.Position
    end
end)
FloatingBtn.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 
       or i.UserInputType == Enum.UserInputType.Touch then
        fbDrag = false
    end
end)
UIS.InputChanged:Connect(function(i)
    if fbDrag and (i.UserInputType == Enum.UserInputType.MouseMovement 
       or i.UserInputType == Enum.UserInputType.Touch) then
        FloatingBtn.Position = UDim2.new(
            fbStartPos.X.Scale, fbStartPos.X.Offset + (i.Position.X - fbStart.X),
            fbStartPos.Y.Scale, fbStartPos.Y.Offset + (i.Position.Y - fbStart.Y)
        )
    end
end)

-- คลิกโลโก้ = เปิด UI
FloatingBtn.MouseButton1Click:Connect(function()
    if not uiOpen then
        SetUIVisible(true)
    else
        SetUIVisible(false)
    end
end)

-- ================== ⌨️ KEYBIND ==================
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        SetUIVisible(not uiOpen)
    end
    if i.KeyCode == Enum.KeyCode.RightShift then
        if uiOpen then SetUIVisible(false) end
    end
end)

print("═══════════════════════════════════════")
print("✅ Rbot Premium v3.2 พร้อมใช้งาน!")
print("🎨 Glassmorphism UI | " .. WORLD[game.PlaceId])
print("⚡ Fast Click: เปิดอัตโนมัติ")
print("⌨️ Right Ctrl = เปิด/ปิด UI")
print("🟣 คลิกโลโก้ R = เปิด/ปิด UI")
print("═══════════════════════════════════════")
