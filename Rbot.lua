--[[
    🤖 Rbot - Premium Glassmorphism UI
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
local LP = Players.LocalPlayer

print("=== Rbot Loading ===")

-- ================== CHECK ==================
local WORLD = {
    [2753915549] = "Sea 1",
    [4442272183] = "Sea 2",
    [7449423635] = "Sea 3",
}
if not WORLD[game.PlaceId] then
    warn("ใช้กับ Blox Fruits เท่านั้น!")
    return
end
print("Game: " .. WORLD[game.PlaceId])

-- ================== CONFIG ==================
local CFG = {
    AutoFarm = false,
    Magnet = false,
    AutoSkill = true,
    AutoHaki = true,
    FastAttack = true,
    NoClip = false,
    WalkSpeed = 16,
    JumpPower = 50,
    Distance = 30,
}

-- ================== HELPERS ==================
local function Char() return LP.Character or LP.CharacterAdded:Wait() end
local function HRP() return Char():WaitForChild("HumanoidRootPart") end
local function Hum() return Char():WaitForChild("Humanoid") end

local function Click()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(851, 158))
    end)
end

local function Key(k)
    pcall(function()
        VIM:SendKeyEvent(true, k, false, game)
        task.wait(0.1)
        VIM:SendKeyEvent(false, k, false, game)
    end)
end

local function MoveTo(cf)
    pcall(function()
        local h = HRP()
        local d = (cf.Position - h.Position).Magnitude
        local s = d > 1000 and 250 or 350
        local t = TS:Create(h, TweenInfo.new(d/s, Enum.EasingStyle.Linear), {CFrame = cf})
        t:Play()
    end)
end

-- ================== SYSTEMS ==================

LP.Idled:Connect(function()
    pcall(function()
        VU:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VU:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end)
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local h = Hum()
            if h then
                h.WalkSpeed = CFG.WalkSpeed
                h.JumpPower = CFG.JumpPower
            end
        end)
    end
end)

task.spawn(function()
    while task.wait(1) do
        if CFG.AutoHaki then
            pcall(function()
                if not Char():FindFirstChild("HasBuso") then
                    RS.Remotes.CommF_:InvokeServer("Buso")
                end
            end)
        end
    end
end)

task.spawn(function()
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getupvalues(c)[2]
    end)
    if not ok then warn("FastAttack ไม่พร้อม") return end
    while task.wait() do
        if CFG.FastAttack then
            pcall(function()
                CF.activeController.timeToNextAttack = 0
                CF.activeController.attacking = false
                CF.activeController.increment = 3
                CF.activeController.hitboxMagnitude = 60
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if CFG.NoClip then
            pcall(function()
                for _, v in pairs(Char():GetDescendants()) do
                    if v:IsA("BasePart") then v.CanCollide = false end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if CFG.Magnet then
            pcall(function()
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 and (hrp.Position - HRP().Position).Magnitude <= 350 then
                        hrp.CFrame = HRP().CFrame * CFrame.new(0, 30, 0)
                        hrp.Size = Vector3.new(50, 50, 50)
                        hum.WalkSpeed = 0
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if CFG.AutoFarm then
            pcall(function()
                local en = workspace:FindFirstChild("Enemies")
                if not en then return end
                for _, m in pairs(en:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local t = hrp.CFrame * CFrame.new(0, CFG.Distance, 0)
                        if (hrp.Position - HRP().Position).Magnitude > 300 then
                            MoveTo(t)
                        else
                            HRP().CFrame = t
                            Click()
                            if CFG.AutoSkill then
                                for _, k in pairs({"Z","X","C","V"}) do
                                    if Char():FindFirstChildOfClass("Tool") then Key(k) end
                                end
                            end
                        end
                        break
                    end
                end
            end)
        end
    end
end)

print("Systems loaded")

-- ================================================================
-- ================== 🎨 PREMIUM UI ===============================
-- ================================================================

local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end

-- Blur Effect
local Blur = Instance.new("BlurEffect")
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

-- Glow behind main
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
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

-- Open Animation
TS:Create(Main, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 740, 0, 500)
}):Play()
TS:Create(Blur, TweenInfo.new(0.7), {Size = 14}):Play()

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Name = "Header"
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

-- Logo Icon
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

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 25)
Title.Position = UDim2.new(0, 72, 0, 12)
Title.BackgroundTransparency = 1
Title.Text = "RBOT • PREMIUM"
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

-- Right side info
local TimeTxt = Instance.new("TextLabel")
TimeTxt.Size = UDim2.new(0, 150, 0, 20)
TimeTxt.Position = UDim2.new(1, -250, 0, 20)
TimeTxt.BackgroundTransparency = 1
TimeTxt.Text = "LV." .. LP.Data.Level.Value
TimeTxt.TextColor3 = Color3.fromRGB(200, 180, 255)
TimeTxt.Font = Enum.Font.GothamBold
TimeTxt.TextSize = 12
TimeTxt.TextXAlignment = Enum.TextXAlignment.Right
TimeTxt.Parent = Header

local TimeVal = Instance.new("TextLabel")
TimeVal.Size = UDim2.new(0, 150, 0, 18)
TimeVal.Position = UDim2.new(1, -250, 0, 35)
TimeVal.BackgroundTransparency = 1
TimeVal.Text = "💰 " .. (LP.Data.Beli.Value >= 1000000 and math.floor(LP.Data.Beli.Value/1000000) .. "M" or math.floor(LP.Data.Beli.Value/1000) .. "K")
TimeVal.TextColor3 = Color3.fromRGB(160, 150, 180)
TimeVal.Font = Enum.Font.Gotham
TimeVal.TextSize = 10
TimeVal.TextXAlignment = Enum.TextXAlignment.Right
TimeVal.Parent = Header

-- Close Button
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
    TS:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(255, 60, 80)}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.9, BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    TS:Create(Blur, TweenInfo.new(0.5), {Size = 0}):Play()
    task.wait(0.5)
    SG:Destroy()
    Blur:Destroy()
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

-- ============ DRAG ============
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = i.Position
        startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
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
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3, TextColor3 = Color3.fromRGB(220, 210, 255)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if page.Visible then return end
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(160, 150, 190)}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TS:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(160, 150, 190)}):Play()
            TS:Create(t.Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
        end
        page.Visible = true
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        TS:Create(Ind, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 26)}):Play()
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

    if CFG[key] then
        local G = Instance.new("UIGradient")
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
            TS:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(138, 43, 226)}):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TS:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(48, 45, 62)}):Play()
            TS:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
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

    local ratio = (CFG[key] - min) / (max - min)

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
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
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
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.05, BackgroundColor3 = Color3.fromRGB(45, 38, 65)}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(28, 26, 38)}):Play()
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

-- HOME
Section(HomeTab, "ข้อมูล")
Button(HomeTab, "🤖 Rbot Premium", "Glassmorphism UI Edition v3.0", function() end)
Button(HomeTab, "📊 สถิติ", "Level: " .. LP.Data.Level.Value .. " | Beli: " .. LP.Data.Beli.Value, function() end)
Section(HomeTab, "วิธีใช้")
Button(HomeTab, "⌨️ ปุ่มลัด", "กด Right Ctrl เพื่อซ่อน/แสดง UI", function() end)

-- FARM
Section(FarmTab, "ฟาร์มหลัก")
Toggle(FarmTab, "Auto Farm Level", "ฟาร์มมอนอัตโนมัติ", "AutoFarm")
Toggle(FarmTab, "Magnet Token", "ดึงมอนเข้าหาตัว", "Magnet")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")

-- SKILL
Section(SkillTab, "สกิล")
Toggle(SkillTab, "Auto Skill", "กด Z X C V อัตโนมัติ", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "ตีเร็วขึ้น (Bypass Cooldown)", "FastAttack")

-- MISC
Section(MiscTab, "ระบบ")
Toggle(MiscTab, "No Clip", "ทะลุกำแพง/สิ่งกีดขวาง", "NoClip")

-- SETTING
Section(SetTab, "ตัวละคร")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")
Section(SetTab, "ระบบ")
Button(SetTab, "🔄 Rejoin", "กลับเซิร์ฟเวอร์เดิม", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)
Button(SetTab, "❌ ปิด UI", "ปิดหน้าต่าง UI", function()
    SG:Destroy()
    Blur:Destroy()
end)

-- ================== KEYBIND ==================
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        if Main.Size == UDim2.new(0, 740, 0, 500) then
            TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0)}):Play()
            TS:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        else
            TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 740, 0, 500)}):Play()
            TS:Create(Blur, TweenInfo.new(0.4), {Size = 14}):Play()
        end
    end
end)

print("═══════════════════════════════════════")
print("✅ Rbot Premium พร้อมใช้งาน!")
print("🎨 Glassmorphism UI | " .. WORLD[game.PlaceId])
print("⌨️ กด Right Ctrl เพื่อซ่อน/แสดง")
print("═══════════════════════════════════════")
