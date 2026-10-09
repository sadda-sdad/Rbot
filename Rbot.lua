--[[
    🔥 Rbot v11.2 - DEBUG EDITION
    UI ต้องขึ้นแน่นอน 100% + Print บอกทุกขั้นตอน
]]

print("━━━━━━━━━━━━━━━━━━━━━")
print("🔥 Rbot v11.2 เริ่มโหลด...")
print("━━━━━━━━━━━━━━━━━━━━━")

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

print("✅ Services โหลดเสร็จ")

-- ================== CHECK ==================
local WORLD = {
    [2753915549]="Sea 1",[4442272183]="Sea 2",
    [7449423635]="Sea 3",[155615604]="Sea 4",
}
if not WORLD[game.PlaceId] then 
    warn("⚠️ ใช้กับ Blox Fruits เท่านั้น! PlaceId: "..game.PlaceId) 
    return 
end
print("✅ Game: " .. WORLD[game.PlaceId])

-- ================== CONFIG ==================
local CFG = {
    AutoFarm=false, AutoQuest=true, AutoIsland=true, AutoClick=true,
    AutoSkill=true, AutoHaki=true, AutoEquip=true,
    FastAttack=true, BringMobs=true, AutoBoss=false, NoClip=false,
    WalkSpeed=16, JumpPower=50, Distance=30,
}
print("✅ Config โหลดเสร็จ")

-- ================== UI - ส่วนที่ต้องขึ้นแน่นอน ==================
print("🎨 กำลังสร้าง UI...")

-- ลบ UI เก่า
local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end
print("✅ ลบ UI เก่าเสร็จ")

local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = Lighting
print("✅ Blur สร้างเสร็จ")

local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.Parent = game.CoreGui
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999
print("✅ ScreenGui สร้างเสร็จ")

-- สี
local COLORS = {
    Bg=Color3.fromRGB(6,4,14),
    Glass=Color3.fromRGB(26,20,40),
    Border=Color3.fromRGB(120,80,200),
    Purple=Color3.fromRGB(160,80,255),
    Pink=Color3.fromRGB(255,60,180),
    Cyan=Color3.fromRGB(80,220,255),
    Text=Color3.fromRGB(240,235,255),
    TextDim=Color3.fromRGB(150,140,180),
}

-- Main Frame
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -350, 0.5, -240)
Main.BackgroundColor3 = COLORS.Bg
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG
print("✅ Main Frame สร้างเสร็จ")

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 20)
MC.Parent = Main

local MStroke = Instance.new("UIStroke")
MStroke.Color = COLORS.Border
MStroke.Thickness = 1.5
MStroke.Transparency = 0.3
MStroke.Parent = Main

-- เปิด UI ทันที ไม่ใช้ Tween (เพื่อทดสอบ)
Main.Size = UDim2.new(0, 700, 0, 480)
Main.Visible = true
Blur.Size = 14
print("✅ UI เปิดแล้ว! ขนาด 700x480")
print("👀 มองที่มุมซ้ายบนของจอ ควรเห็นกล่องสีดำ")

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = Color3.fromRGB(16,12,26)
Header.BackgroundTransparency = 0.3
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 20)
HC.Parent = Header

-- Logo
local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0, 46, 0, 46)
LogoIcon.Position = UDim2.new(0, 16, 0.5, -23)
LogoIcon.BackgroundColor3 = COLORS.Purple
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = Header

local LIC = Instance.new("UICorner")
LIC.CornerRadius = UDim.new(1, 0)
LIC.Parent = LogoIcon

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1, 0, 1, 0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "R"
LogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.TextSize = 24
LogoTxt.Parent = LogoIcon

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 300, 0, 24)
Title.Position = UDim2.new(0, 72, 0, 14)
Title.BackgroundTransparency = 1
Title.Text = "🔥 RBOT v11.2"
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 300, 0, 18)
SubTitle.Position = UDim2.new(0, 72, 0, 38)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = WORLD[game.PlaceId].." • "..LP.Name
SubTitle.TextColor3 = COLORS.TextDim
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Close Btn
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 34, 0, 34)
CloseBtn.Position = UDim2.new(1, -46, 0.5, -17)
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

CloseBtn.MouseButton1Click:Connect(function()
    SG:Destroy()
    Blur:Destroy()
    print("❌ UI ปิดแล้ว")
end)
print("✅ Header สร้างเสร็จ")

-- ============ SIDEBAR ============
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 190, 1, -85)
Sidebar.Position = UDim2.new(0, 15, 0, 80)
Sidebar.BackgroundColor3 = COLORS.Glass
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 14)
SBC.Parent = Sidebar

-- Control Panel ➖✚
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, -16, 0, 42)
ControlPanel.Position = UDim2.new(0, 8, 0, 8)
ControlPanel.BackgroundColor3 = COLORS.Glass
ControlPanel.BackgroundTransparency = 0.3
ControlPanel.BorderSizePixel = 0
ControlPanel.Parent = Sidebar

local CPC = Instance.new("UICorner")
CPC.CornerRadius = UDim.new(0, 10)
CPC.Parent = ControlPanel

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0.5, -4, 1, -8)
MinBtn.Position = UDim2.new(0, 4, 0, 4)
MinBtn.BackgroundColor3 = COLORS.Purple
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "➖"
MinBtn.TextColor3 = COLORS.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = ControlPanel

local MinBtnC = Instance.new("UICorner")
MinBtnC.CornerRadius = UDim.new(0, 8)
MinBtnC.Parent = MinBtn

local ExpBtn = Instance.new("TextButton")
ExpBtn.Size = UDim2.new(0.5, -4, 1, -8)
ExpBtn.Position = UDim2.new(0.5, 0, 0, 4)
ExpBtn.BackgroundColor3 = COLORS.Cyan
ExpBtn.BackgroundTransparency = 0.2
ExpBtn.Text = "✚"
ExpBtn.TextColor3 = COLORS.Text
ExpBtn.Font = Enum.Font.GothamBold
ExpBtn.TextSize = 16
ExpBtn.Parent = ControlPanel

local ExpBtnC = Instance.new("UICorner")
ExpBtnC.CornerRadius = UDim.new(0, 8)
ExpBtnC.Parent = ExpBtn

MinBtn.MouseButton1Click:Connect(function()
    Main.Size = UDim2.new(0, 0, 0, 0)
    Blur.Size = 0
    Main.Visible = false
    print("➖ ย่อ UI")
end)

ExpBtn.MouseButton1Click:Connect(function()
    Main.Size = UDim2.new(0, 700, 0, 480)
    Blur.Size = 14
    Main.Visible = true
    print("✚ ขยาย UI")
end)
print("✅ Sidebar + ปุ่ม ➖✚ สร้างเสร็จ")

-- ============ CONTENT ============
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -220, 1, -85)
Content.Position = UDim2.new(0, 215, 0, 80)
Content.BackgroundColor3 = COLORS.Glass
Content.BackgroundTransparency = 0.5
Content.BorderSizePixel = 0
Content.Parent = Main

local CNC = Instance.new("UICorner")
CNC.CornerRadius = UDim.new(0, 14)
CNC.Parent = Content

-- Header ใน Content
local ContentTitle = Instance.new("TextLabel")
ContentTitle.Size = UDim2.new(1, -20, 0, 30)
ContentTitle.Position = UDim2.new(0, 10, 0, 10)
ContentTitle.BackgroundTransparency = 1
ContentTitle.Text = "🎯 เมนูหลัก"
ContentTitle.TextColor3 = COLORS.Purple
ContentTitle.Font = Enum.Font.GothamBold
ContentTitle.TextSize = 14
ContentTitle.TextXAlignment = Enum.TextXAlignment.Left
ContentTitle.Parent = Content

-- Info
local InfoTxt = Instance.new("TextLabel")
InfoTxt.Size = UDim2.new(1, -20, 0, 60)
InfoTxt.Position = UDim2.new(0, 10, 0, 50)
InfoTxt.BackgroundTransparency = 1
InfoTxt.Text = "✅ UI ขึ้นแล้ว!\n\nถ้าเห็นกล่องนี้ = สคริปต์ทำงานปกติ\nกด ✕ ปิด / ➖ ย่อ / ✚ ขยาย"
InfoTxt.TextColor3 = COLORS.Text
InfoTxt.Font = Enum.Font.Gotham
InfoTxt.TextSize = 14
InfoTxt.TextWrapped = true
InfoTxt.TextXAlignment = Enum.TextXAlignment.Left
InfoTxt.TextYAlignment = Enum.TextYAlignment.Top
InfoTxt.Parent = Content

print("✅ Content สร้างเสร็จ")

-- ============ DRAG ============
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
print("✅ Drag เปิดใช้งาน")

print("━━━━━━━━━━━━━━━━━━━━━")
print("🎉 เสร็จสิ้น! UI ควรขึ้นแล้ว")
print("━━━━━━━━━━━━━━━━━━━━━")
