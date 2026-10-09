--[[
    🤖 Rbot v6.0 - REAL AUTO ATTACK
    ✅ ใช้ CombatFramework จริงแบบสคริปต์ขาย
    ✅ ใช้ RS.Remotes.CommF_ ยิงตรง
    ✅ Debug บอกทุกอย่างที่เกิดขึ้น
]]

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

print("=== Rbot v6.0 - REAL AUTO ATTACK ===")

-- ================== CHECK GAME ==================
local WORLD = {
    [2753915549] = "Sea 1", [4442272183] = "Sea 2", [7449423635] = "Sea 3",
}
if not WORLD[game.PlaceId] then
    warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!")
    return
end

-- ================== CONFIG ==================
local CFG = {
    AutoFarm = false, AutoClick = true, AutoSkill = true,
    AutoHaki = true, BringMobs = true, AutoQuest = true,
    WalkSpeed = 16, JumpPower = 50, Distance = 30,
}

-- ================== HELPERS ==================
local function Char() return LP.Character end
local function HRP() 
    local c = Char()
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function Hum()
    local c = Char()
    return c and c:FindFirstChild("Humanoid")
end

local function SafeGet(tbl, key)
    local ok, v = pcall(function() return tbl[key].Value end)
    return ok and v or 0
end

-- ================== ⚔️ GET COMBAT FRAMEWORK (สำคัญที่สุด!) ==================
local CombatFramework
local getup = getupvalues or debug.getupvalue

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            local c = require(LP.PlayerScripts:WaitForChild("CombatFramework", 5))
            if c then
                CombatFramework = getup(c)[2]
                if CombatFramework and CombatFramework.activeController then
                    print("✅ CombatFramework โหลดแล้ว")
                    return
                end
            end
        end)
    end
end)

-- รอให้โหลดเสร็จก่อน
repeat task.wait(0.5) until CombatFramework and CombatFramework.activeController
print("✅ CombatFramework พร้อม!")

-- ================== ⚔️ AUTO ATTACK (ใช้ CombatFramework จริง) ==================
-- นี่คือหัวใจของ v6.0 - ใช้ระบบต่อสู้ของเกมเอง
local attackCooldown = 0

local function ForceAttack()
    if not CombatFramework or not CombatFramework.activeController then return end
    
    local ac = CombatFramework.activeController
    pcall(function()
        -- Reset cooldown
        ac.timeToNextAttack = 0
        ac.attacking = false
        ac.blocking = false
        ac.increment = 6
        ac.hitboxMagnitude = 60
        ac:attack()
    end)
end

-- ================== ⚔️ ATTACK LOOP (Heartbeat - เร็วที่สุด) ==================
local clickCount = 0
local lastPrint = tick()

RunService.Heartbeat:Connect(function()
    if not CFG.AutoClick then return end
    
    -- เช็ค Tool ในมือ
    local c = Char()
    if not c then return end
    local tool = c:FindFirstChildOfClass("Tool")
    if not tool then return end
    
    -- เช็คศัตรู
    local h = HRP()
    if not h then return end
    local en = workspace:FindFirstChild("Enemies")
    if not en then return end
    
    local hasEnemy = false
    for _, m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0 then
            if (mh.Position - h.Position).Magnitude <= 60 then
                hasEnemy = true
                break
            end
        end
    end
    
    if not hasEnemy then return end
    
    -- ✅ ยิง Attack!
    ForceAttack()
    clickCount = clickCount + 1
end)

-- Print rate ทุก 5 วิ
task.spawn(function()
    while task.wait(5) do
        if CFG.AutoClick then
            print("⚔️ Attack rate: " .. math.floor(clickCount / 5) .. "/sec")
            clickCount = 0
        end
    end
end)

-- ================== 🎯 AUTO FARM ==================
local function GetClosestEnemy()
    local h = HRP()
    if not h then return nil end
    local en = workspace:FindFirstChild("Enemies")
    if not en then return nil end
    local closest, dist = nil, math.huge
    for _, m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0 then
            local d = (mh.Position - h.Position).Magnitude
            if d < dist then
                closest = m
                dist = d
            end
        end
    end
    return closest, dist
end

task.spawn(function()
    while task.wait(0.15) do
        if CFG.AutoFarm then
            pcall(function()
                local h = HRP()
                if not h then return end
                local target = GetClosestEnemy()
                if target then
                    local mh = target:FindFirstChild("HumanoidRootPart")
                    if mh then
                        h.CFrame = mh.CFrame * CFrame.new(0, CFG.Distance, 0)
                    end
                end
            end)
        end
    end
end)

-- ================== 🧲 BRING MOBS ==================
task.spawn(function()
    while task.wait(0.05) do
        if CFG.BringMobs and CFG.AutoFarm then
            pcall(function()
                local h = HRP()
                if not h then return end
                local en = workspace:FindFirstChild("Enemies")
                if not en then return end
                for _, m in pairs(en:GetChildren()) do
                    local mh = m:FindFirstChild("HumanoidRootPart")
                    local mhum = m:FindFirstChild("Humanoid")
                    if mh and mhum and mhum.Health > 0 
                       and (mh.Position - h.Position).Magnitude <= 200 then
                        mh.CFrame = CFrame.new(h.Position + Vector3.new(
                            math.random(-12, 12), 3, math.random(-12, 12)
                        ))
                        mhum.WalkSpeed = 0
                        mhum.PlatformStand = true
                    end
                end
            end)
        end
    end
end)

-- ================== 🥋 SKILL ==================
local SKILL_KEYS = {
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V,
    Enum.KeyCode.F,
}

local function PressKey(k)
    pcall(function()
        VIM:SendKeyEvent(true, k, false, game)
        task.wait(0.02)
        VIM:SendKeyEvent(false, k, false, game)
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        if CFG.AutoSkill then
            local c = Char()
            if c and c:FindFirstChildOfClass("Tool") then
                local h = HRP()
                local en = workspace:FindFirstChild("Enemies")
                if h and en then
                    for _, m in pairs(en:GetChildren()) do
                        local mh = m:FindFirstChild("HumanoidRootPart")
                        local mhum = m:FindFirstChild("Humanoid")
                        if mh and mhum and mhum.Health > 0 
                           and (mh.Position - h.Position).Magnitude <= 60 then
                            for _, k in pairs(SKILL_KEYS) do
                                PressKey(k)
                                task.wait(0.05)
                            end
                            break
                        end
                    end
                end
            end
        end
    end
end)

-- ================== 🥊 AUTO HAKI ==================
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

-- ================== 🛡️ ANTI-AFK ==================
LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ================== 📊 WALKSPEED ==================
task.spawn(function()
    while task.wait(0.3) do
        local h = Hum()
        if h then
            h.WalkSpeed = CFG.WalkSpeed
            h.JumpPower = CFG.JumpPower
        end
    end
end)

-- ================== 📜 AUTO QUEST ==================
local QUESTS = {
    {Name="Bandit",Level=1},{Name="Monkey",Level=1},
    {Name="Blade Bandit",Level=15},{Name="Jungle Pirate",Level=20},
    {Name="Desert Bandit",Level=30},{Name="Desert Officer",Level=40},
    {Name="Snow Bandit",Level=50},{Name="Snowman",Level=60},
    {Name="Frost Bandit",Level=75},{Name="Marine",Level=85},
    {Name="Sky Bandit",Level=90},{Name="Dark Master",Level=100},
    {Name="Fighter",Level=120},{Name="Fishman",Level=150},
    {Name="Magma Ninja",Level=175},{Name="Pirate Boss",Level=200},
    {Name="Snow Trooper",Level=250},{Name="Winter Warrior",Level=300},
    {Name="Lab Subordinate",Level=350},{Name="Horned Warrior",Level=400},
    {Name="Military Soldier",Level=450},{Name="Military Spy",Level=500},
    {Name="Reborn Skeleton",Level=550},{Name="Living Zombie",Level=600},
    {Name="Demonic Soul",Level=650},{Name="Possessed Mummy",Level=700},
    {Name="Snow Lurker",Level=725},{Name="Yeti",Level=750},
    {Name="Pirate Millionaire",Level=775},{Name="Pistol Billionaire",Level=800},
}

local currentQuest = nil

local function HasQuest()
    local ok, has = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and has
end

task.spawn(function()
    while task.wait(2) do
        if CFG.AutoQuest and CFG.AutoFarm and not HasQuest() then
            pcall(function()
                local lvl = SafeGet(LP.Data, "Level")
                local best = nil
                for _, q in pairs(QUESTS) do
                    if q.Level <= lvl then
                        if not best or q.Level > best.Level then best = q end
                    end
                end
                if best then
                    RS.Remotes.CommF_:InvokeServer("StartQuest", best.Name, best.Level)
                    currentQuest = best
                    print("📜 รับเควสต์: " .. best.Name)
                end
            end)
        end
    end
end)

-- ================== 🔍 DEBUG ==================
task.spawn(function()
    while task.wait(5) do
        if CFG.AutoFarm or CFG.AutoClick then
            local c = Char()
            local tool = c and c:FindFirstChildOfClass("Tool")
            local h = HRP()
            local en = workspace:FindFirstChild("Enemies")
            local mobCount = 0
            if en then mobCount = #en:GetChildren() end
            print("━━━━━━━━━━━━━━━━━━━")
            print("🔧 Tool: " .. (tool and tool.Name or "❌ ไม่มี!"))
            print("👾 Mobs in folder: " .. mobCount)
            print("🎮 CF: " .. (CombatFramework and CombatFramework.activeController and "✅" or "❌"))
            print("━━━━━━━━━━━━━━━━━━━")
        end
    end
end)

print("✅ Rbot v6.0 - REAL AUTO ATTACK ACTIVE")

-- ================================================================
-- ========== 🎨 UI ==============================================
-- ================================================================

local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end

local COLORS = {
    Bg=Color3.fromRGB(8,6,16), Glass=Color3.fromRGB(28,22,42),
    Border=Color3.fromRGB(120,80,200), Purple=Color3.fromRGB(160,80,255),
    Pink=Color3.fromRGB(255,60,180), Cyan=Color3.fromRGB(80,220,255),
    Text=Color3.fromRGB(240,235,255), TextDim=Color3.fromRGB(150,140,180),
}

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting

local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.Parent = game.CoreGui
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 999

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -370, 0.5, -250)
Main.BackgroundColor3 = COLORS.Bg
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 22)
MC.Parent = Main

local MStroke = Instance.new("UIStroke")
MStroke.Color = COLORS.Border
MStroke.Thickness = 1.5
MStroke.Transparency = 0.3
MStroke.Parent = Main

TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Back), {
    Size = UDim2.new(0, 740, 0, 500)
}):Play()
TS:Create(Blur, TweenInfo.new(0.7), {Size = 16}):Play()

-- HEADER
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(18, 14, 28)
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 22)
HC.Parent = Header

local HLine = Instance.new("Frame")
HLine.Size = UDim2.new(1, -40, 0, 2)
HLine.Position = UDim2.new(0, 20, 1, -1)
HLine.BackgroundColor3 = COLORS.Purple
HLine.BorderSizePixel = 0
HLine.Parent = Header

local HLineC = Instance.new("UICorner")
HLineC.CornerRadius = UDim.new(1, 0)
HLineC.Parent = HLine

local HLineG = Instance.new("UIGradient")
HLineG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.Purple),
    ColorSequenceKeypoint.new(0.5, COLORS.Pink),
    ColorSequenceKeypoint.new(1, COLORS.Cyan),
}
HLineG.Parent = HLine

-- Logo
local LogoWrap = Instance.new("Frame")
LogoWrap.Size = UDim2.new(0, 46, 0, 46)
LogoWrap.Position = UDim2.new(0, 18, 0.5, -23)
LogoWrap.BackgroundColor3 = COLORS.Purple
LogoWrap.BorderSizePixel = 0
LogoWrap.Parent = Header

local LWC = Instance.new("UICorner")
LWC.CornerRadius = UDim.new(1, 0)
LWC.Parent = LogoWrap

local LWG = Instance.new("UIGradient")
LWG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.Purple),
    ColorSequenceKeypoint.new(0.5, COLORS.Pink),
    ColorSequenceKeypoint.new(1, COLORS.Cyan),
}
LWG.Rotation = 45
LWG.Parent = LogoWrap

task.spawn(function()
    local rot = 45
    while LogoWrap.Parent do
        rot = (rot + 1) % 360
        LWG.Rotation = rot
        task.wait(0.05)
    end
end)

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1, 0, 1, 0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "R"
LogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.TextSize = 26
LogoTxt.Parent = LogoWrap

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 350, 0, 26)
Title.Position = UDim2.new(0, 76, 0, 14)
Title.BackgroundTransparency = 1
Title.Text = "RBOT v6.0"
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local TitleGrad = Instance.new("UIGradient")
TitleGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.Text),
    ColorSequenceKeypoint.new(0.5, COLORS.Purple),
    ColorSequenceKeypoint.new(1, COLORS.Pink),
}
TitleGrad.Parent = Title

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 350, 0, 18)
SubTitle.Position = UDim2.new(0, 76, 0, 38)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "REAL AUTO ATTACK • " .. WORLD[game.PlaceId]
SubTitle.TextColor3 = COLORS.TextDim
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Min / Close
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinBtn.BackgroundColor3 = COLORS.Glass
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "−"
MinBtn.TextColor3 = COLORS.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.Parent = Header

local MBC = Instance.new("UICorner")
MBC.CornerRadius = UDim.new(1, 0)
MBC.Parent = MinBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = COLORS.Glass
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = COLORS.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.Parent = Header

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(1, 0)
CBC.Parent = CloseBtn

local uiOpen = true
local FloatingBtn

local function SetUIVisible(v)
    uiOpen = v
    if v then
        Main.Visible = true
        TS:Create(Main, TweenInfo.new(0.4), {Size = UDim2.new(0, 740, 0, 500)}):Play()
        TS:Create(Blur, TweenInfo.new(0.3), {Size = 16}):Play()
    else
        TS:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        local t = TS:Create(Main, TweenInfo.new(0.3), {Size = UDim2.new(0,0,0,0)})
        t:Play()
        t.Completed:Connect(function() if not uiOpen then Main.Visible = false end end)
    end
end

MinBtn.MouseButton1Click:Connect(function() SetUIVisible(false) end)
CloseBtn.MouseButton1Click:Connect(function() SetUIVisible(false) end)

-- SIDEBAR + CONTENT
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, -90)
Sidebar.Position = UDim2.new(0, 18, 0, 80)
Sidebar.BackgroundColor3 = COLORS.Glass
Sidebar.BackgroundTransparency = 0.55
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 16)
SBC.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, -16, 1, -16)
TabList.Position = UDim2.new(0, 8, 0, 8)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TLLay = Instance.new("UIListLayout")
TLLay.Parent = TabList
TLLay.SortOrder = Enum.SortOrder.LayoutOrder
TLLay.Padding = UDim.new(0, 8)

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -240, 1, -90)
Content.Position = UDim2.new(0, 226, 0, 80)
Content.BackgroundColor3 = COLORS.Glass
Content.BackgroundTransparency = 0.55
Content.BorderSizePixel = 0
Content.Parent = Main

local CNC = Instance.new("UICorner")
CNC.CornerRadius = UDim.new(0, 16)
CNC.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = COLORS.Purple
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Content

local SLLay = Instance.new("UIListLayout")
SLLay.Parent = Scroll
SLLay.SortOrder = Enum.SortOrder.LayoutOrder
SLLay.Padding = UDim.new(0, 10)

SLLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, SLLay.AbsoluteContentSize.Y + 20)
end)

-- Drag
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

-- UI FACTORY
local Tabs = {}
local FirstTab = false

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 44)
    Btn.BackgroundColor3 = COLORS.Glass
    Btn.BackgroundTransparency = 0.7
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. icon .. "   " .. name
    Btn.TextColor3 = COLORS.TextDim
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.Parent = TabList

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 12)
    c.Parent = Btn

    local Ind = Instance.new("Frame")
    Ind.Size = UDim2.new(0, 4, 0, 0)
    Ind.Position = UDim2.new(0, 0, 0.5, 0)
    Ind.AnchorPoint = Vector2.new(0, 0.5)
    Ind.BackgroundColor3 = COLORS.Purple
    Ind.BorderSizePixel = 0
    Ind.Parent = Btn

    local IndC = Instance.new("UICorner")
    IndC.CornerRadius = UDim.new(1, 0)
    IndC.Parent = Ind

    local page = Instance.new("Frame")
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Parent = Scroll
    page.Visible = false

    local pLay = Instance.new("UIListLayout")
    pLay.Parent = page
    pLay.SortOrder = Enum.SortOrder.LayoutOrder
    pLay.Padding = UDim.new(0, 10)

    table.insert(Tabs, {Btn = Btn, Page = page, Ind = Ind})

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TS:Create(t.Btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.7, TextColor3 = COLORS.TextDim
            }):Play()
            TS:Create(t.Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0, 0)}):Play()
        end
        page.Visible = true
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3, TextColor3 = COLORS.Text
        }):Play()
        TS:Create(Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 4, 0, 28)}):Play()
    end)

    if not FirstTab then
        FirstTab = true
        page.Visible = true
        Btn.BackgroundTransparency = 0.3
        Btn.TextColor3 = COLORS.Text
        Ind.Size = UDim2.new(0, 4, 0, 28)
    end

    return page
end

local function Section(parent, title)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, -8, 0, 28)
    S.BackgroundTransparency = 1
    S.Text = "  ▸  " .. title:upper()
    S.TextColor3 = COLORS.Purple
    S.Font = Enum.Font.GothamBold
    S.TextSize = 11
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = parent
end

local function Toggle(parent, name, desc, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 62)
    F.BackgroundColor3 = COLORS.Glass
    F.BackgroundTransparency = 0.4
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 14)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -100, 0, 22)
    L.Position = UDim2.new(0, 18, 0, 10)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = COLORS.Text
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -100, 0, 16)
    D.Position = UDim2.new(0, 18, 0, 32)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = COLORS.TextDim
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(0, 50, 0, 26)
    Bg.Position = UDim2.new(1, -68, 0.5, -13)
    Bg.BackgroundColor3 = CFG[key] and COLORS.Purple or Color3.fromRGB(40, 35, 55)
    Bg.BorderSizePixel = 0
    Bg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = Bg

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 22, 0, 22)
    Dot.Position = CFG[key] and UDim2.new(1, -24, 0.5, -11) or UDim2.new(0, 2, 0.5, -11)
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
            TS:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = COLORS.Purple}):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1, -24, 0.5, -11)}):Play()
        else
            TS:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(40, 35, 55)}):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -11)}):Play()
        end
    end)
end

local function Slider(parent, name, min, max, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 72)
    F.BackgroundColor3 = COLORS.Glass
    F.BackgroundTransparency = 0.4
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 14)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 22)
    L.Position = UDim2.new(0, 18, 0, 10)
    L.BackgroundTransparency = 1
    L.Text = name .. "  :  " .. CFG[key]
    L.TextColor3 = COLORS.Text
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -36, 0, 8)
    BarBg.Position = UDim2.new(0, 18, 0, 46)
    BarBg.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = BarBg

    local ratio = math.clamp((CFG[key] - min) / (max - min), 0, 1)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = COLORS.Purple
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = UDim2.new(1, -9, 0.5, -9)
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
    F.Size = UDim2.new(1, -8, 0, 62)
    F.BackgroundColor3 = COLORS.Glass
    F.BackgroundTransparency = 0.4
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 14)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 22)
    L.Position = UDim2.new(0, 18, 0, 10)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = COLORS.Text
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -30, 0, 16)
    D.Position = UDim2.new(0, 18, 0, 32)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = COLORS.TextDim
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = F

    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- TABS
local HomeTab = CreateTab("หน้าหลัก", "🏠")
local FarmTab = CreateTab("ฟาร์ม", "🌾")
local SkillTab = CreateTab("สกิล", "🥋")
local SetTab = CreateTab("ตั้งค่า", "🔧")

Section(HomeTab, "⚔️ Auto Attack Status")
Button(HomeTab, "🔧 ตรวจสอบ Status", "ดูว่า CF โหลดไหม + Tool + Enemy", function()
    local c = Char()
    local tool = c and c:FindFirstChildOfClass("Tool")
    print("━━━━━━━━━━━━━━━━━━━━")
    print("Tool: " .. (tool and tool.Name or "❌ ไม่มี"))
    print("CombatFramework: " .. (CombatFramework and "✅" or "❌"))
    print("ActiveController: " .. (CombatFramework and CombatFramework.activeController and "✅" or "❌"))
    print("AutoClick: " .. tostring(CFG.AutoClick))
    print("AutoFarm: " .. tostring(CFG.AutoFarm))
    print("━━━━━━━━━━━━━━━━━━━━")
end)
Button(HomeTab, "⚔️ Force Attack", "บังคับโจมตี 1 ครั้ง", function()
    ForceAttack()
    print("⚔️ Force attacked!")
end)

Section(FarmTab, "🎯 ฟาร์ม")
Toggle(FarmTab, "Auto Farm", "บินไปหามอน", "AutoFarm")
Toggle(FarmTab, "Auto Attack ⭐", "ใช้ CombatFramework จริง", "AutoClick")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ", "AutoQuest")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนมาที่ตัว", "BringMobs")
Slider(FarmTab, "Distance", 5, 60, "Distance")

Section(SkillTab, "🥋 สกิล")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso", "AutoHaki")

Section(SetTab, "🏃 ตัว")
Slider(SetTab, "WalkSpeed", 16, 200, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 200, "JumpPower")

-- FLOATING LOGO
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 60, 0, 60)
FloatingBtn.Position = UDim2.new(0, 20, 0.5, -30)
FloatingBtn.BackgroundColor3 = COLORS.Purple
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Text = "R"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBlack
FloatingBtn.TextSize = 26
FloatingBtn.Visible = false
FloatingBtn.ZIndex = 999
FloatingBtn.Parent = SG

local FBC = Instance.new("UICorner")
FBC.CornerRadius = UDim.new(1, 0)
FBC.Parent = FloatingBtn

FloatingBtn.MouseButton1Click:Connect(function()
    SetUIVisible(true)
end)

-- Show floating when UI closed
task.spawn(function()
    while task.wait(0.5) do
        if FloatingBtn then
            FloatingBtn.Visible = not uiOpen
        end
    end
end)

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        SetUIVisible(not uiOpen)
    end
end)

print("═══════════════════════════════════════")
print("✅ Rbot v6.0 พร้อมใช้งาน!")
print("⚔️ ใช้ CombatFramework จริง")
print("⌨️ Right Ctrl = เปิด/ปิด UI")
print("═══════════════════════════════════════")
