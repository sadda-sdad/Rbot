--[[
    🤖 Rbot - PC Edition (Safe Version)
    UI ขึ้นก่อน แล้วค่อย Save
]]

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local LP = Players.LocalPlayer

print("═══════════════════════════════════")
print("🚀 Rbot กำลังโหลด...")

-- ================== CHECK ==================
local WORLD = {[2753915549]="Sea 1",[4442272183]="Sea 2",[7449423635]="Sea 3"}
if not WORLD[game.PlaceId] then 
    warn("❌ ใช้กับ Blox Fruits เท่านั้น!") 
    return 
end
print("✅ ตรวจสอบเกมผ่าน: " .. WORLD[game.PlaceId])

local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ================== SAFE SAVE SYSTEM ==================
local SAVE_SYSTEM = {}
local SAVE_ENABLED = false  -- ปิดไว้ก่อน จะเปิดตอนหา path เจอ

-- ตรวจว่า Executor รองรับ writefile ไหม
if writefile and readfile and isfile then
    SAVE_ENABLED = true
    print("✅ Executor รองรับ writefile")
else
    warn("⚠️ Executor ไม่รองรับ writefile - Save จะไม่ทำงาน")
end

function SAVE_SYSTEM:GetPath()
    if not SAVE_ENABLED then return nil end
    
    -- ดึง username
    local username = "User"
    pcall(function()
        username = os.getenv("USERNAME") or os.getenv("username") or "User"
    end)
    
    local paths = {
        "C:\\Users\\" .. username .. "\\Downloads\\Rbot\\",
        "C:\\Users\\" .. username .. "\\Downloads\\",
        "workspace\\",
        "workspace/",
    }
    
    for _, path in pairs(paths) do
        local ok = pcall(function()
            if makefolder and isfolder then
                if not isfolder(path) then
                    makefolder(path)
                end
            end
            local testFile = path .. "_rbot_test.txt"
            writefile(testFile, "test")
            delfile(testFile)
        end)
        
        if ok then
            print("✅ ใช้ path: " .. path)
            return path
        end
    end
    
    return nil
end

local SAVE_PATH = SAVE_SYSTEM:GetPath()
if SAVE_PATH then
    print("📁 Save path: " .. SAVE_PATH)
else
    warn("⚠️ หา path ไม่ได้ - Save จะใช้ workspace")
    SAVE_PATH = "workspace/"
end

function SAVE_SYSTEM:Save(data)
    if not SAVE_ENABLED then return false end
    
    local fullPath = SAVE_PATH .. "Rbot_Save_" .. LP.Name .. ".json"
    
    local ok = pcall(function()
        local json = game:GetService("HttpService"):JSONEncode(data)
        writefile(fullPath, json)
    end)
    
    return ok
end

function SAVE_SYSTEM:Load()
    if not SAVE_ENABLED then return nil end
    
    local fullPath = SAVE_PATH .. "Rbot_Save_" .. LP.Name .. ".json"
    
    if not isfile(fullPath) then return nil end
    
    local ok, data = pcall(function()
        return game:GetService("HttpService"):JSONDecode(readfile(fullPath))
    end)
    
    if ok then return data end
    return nil
end

function SAVE_SYSTEM:GetFullPath()
    return SAVE_PATH .. "Rbot_Save_" .. LP.Name .. ".json"
end

-- ================== CONFIG ==================
local DEFAULT_CFG = {
    AutoFarmLevel = false,
    MagnetToken = false,
    AutoSkill = true,
    AutoHaki = true,
    FastAttack = true,
    WalkSpeed = 16,
    JumpPower = 50,
    FarmDistance = 30,
    NoClip = false,
    AntiAFK = true,
    Version = "PC-Safe",
}

local CFG = {}
for k, v in pairs(DEFAULT_CFG) do CFG[k] = v end

-- โหลดค่าเก่า (ถ้ามี)
pcall(function()
    local saved = SAVE_SYSTEM:Load()
    if saved then
        for k, v in pairs(saved) do
            if DEFAULT_CFG[k] ~= nil then CFG[k] = v end
        end
        print("✅ โหลดค่าที่เคยบันทึกไว้")
    end
end)

local function AutoSave()
    pcall(function() SAVE_SYSTEM:Save(CFG) end)
end

task.spawn(function()
    while task.wait(30) do AutoSave() end
end)

game:BindToClose(function() AutoSave() end)

-- ================== FARM FUNCTIONS ==================
local function C() return LP.Character or LP.CharacterAdded:Wait() end
local function HRP() return C():WaitForChild("HumanoidRootPart") end
local function HUM() return C():WaitForChild("Humanoid") end

local function Equip(n)
    local bp = LP:FindFirstChild("Backpack")
    local ch = C()
    if bp and bp:FindFirstChild(n) then HUM():EquipTool(bp[n])
    elseif ch:FindFirstChild(n) then HUM():EquipTool(ch[n]) end
end

local function Click()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(851, 158))
end

local function Key(k)
    VIM:SendKeyEvent(true, k, false, game)
    task.wait(0.1)
    VIM:SendKeyEvent(false, k, false, game)
end

local function Tween(cf)
    local h = HRP()
    local d = (cf.Position - h.Position).Magnitude
    local s = d > 1000 and 250 or 350
    local t = TweenService:Create(h, TweenInfo.new(d/s, Enum.EasingStyle.Linear), {CFrame = cf})
    t:Play()
    return t
end

local function Skills()
    if not CFG.AutoSkill then return end
    for _, k in pairs({"Z","X","C","V"}) do
        if C():FindFirstChildOfClass("Tool") then Key(k) end
    end
end

-- ================== SYSTEMS ==================
LP.Idled:Connect(function()
    if CFG.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

task.spawn(function()
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getupvalues(c)[2]
    end)
    if not ok then 
        warn("⚠️ FastAttack ไม่พร้อม")
        return 
    end
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
    while task.wait(1) do
        if CFG.AutoHaki then
            pcall(function()
                if not C():FindFirstChild("HasBuso") then
                    CommF:InvokeServer("Buso")
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        pcall(function()
            local h = HUM()
            if h then
                h.WalkSpeed = CFG.WalkSpeed
                h.JumpPower = CFG.JumpPower
            end
        end)
    end
end)

task.spawn(function()
    while task.wait() do
        if CFG.NoClip and C() then
            for _, v in pairs(C():GetDescendants()) do
                if v:IsA("BasePart") then v.CanCollide = false end
            end
        end
    end
end)

task.spawn(function()
    while task.wait() do
        if CFG.MagnetToken then
            pcall(function()
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 and (hrp.Position - HRP().Position).Magnitude <= 350 then
                        hrp.CFrame = HRP().CFrame * CFrame.new(0, 30, 0)
                        hrp.Size = Vector3.new(50,50,50)
                        hum.WalkSpeed = 0
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if CFG.AutoFarmLevel then
            pcall(function()
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        local t = hrp.CFrame * CFrame.new(0, CFG.FarmDistance, 0)
                        if (hrp.Position - HRP().Position).Magnitude > 300 then Tween(t)
                        else
                            HRP().CFrame = t
                            Click(); Skills()
                        end
                        break
                    end
                end
            end)
        end
    end
end)

print("✅ ระบบทั้งหมดโหลดเสร็จ - กำลังสร้าง UI...")

-- ================================================================
-- ================== 🎨 UI =======================================
-- ================================================================

-- ลบ UI เก่า (ถ้ามี)
local oldUI = game.CoreGui:FindFirstChild("RbotPC")
if oldUI then oldUI:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "RbotPC"
SG.Parent = game.CoreGui
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 700, 0, 500)
Main.Position = UDim2.new(0.5, -350, 0.5, -250)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BackgroundTransparency = 0
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 14)
MC.Parent = Main

-- Header
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 14)
HC.Parent = Header

local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 20)
HeaderCover.Position = UDim2.new(0, 0, 1, -20)
HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 0, 30)
Title.Position = UDim2.new(0, 25, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "🤖 RBOT • PC EDITION"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 500, 0, 18)
SubTitle.Position = UDim2.new(0, 25, 0, 34)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Blox Fruits | " .. WORLD[game.PlaceId] .. " | " .. LP.Name
SubTitle.TextColor3 = Color3.fromRGB(255, 220, 220)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 11
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.BackgroundTransparency = 0.85
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 22
CloseBtn.Parent = Header

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(1, 0)
CBC.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    AutoSave()
    SG:Destroy()
end)

-- Content
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -30, 1, -80)
Content.Position = UDim2.new(0, 15, 0, 70)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, 0, 1, 0)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Content

local SLay = Instance.new("UIListLayout")
SLay.Parent = Scroll
SLay.Padding = UDim.new(0, 8)

SLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, SLay.AbsoluteContentSize.Y + 20)
end)

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
end)
UserInput.InputChanged:Connect(function(i)
    if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
        Main.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X),
            startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y)
        )
    end
end)

-- ================== UI FACTORY ==================
local function Section(title)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, -8, 0, 28)
    S.BackgroundTransparency = 1
    S.Text = "  ▸ " .. title
    S.TextColor3 = Color3.fromRGB(255, 120, 120)
    S.Font = Enum.Font.GothamBold
    S.TextSize = 12
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = Scroll
end

local function Toggle(name, desc, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 56)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BorderSizePixel = 0
    F.Parent = Scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -90, 0, 24)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(240, 240, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -90, 0, 16)
    D.Position = UDim2.new(0, 16, 0, 30)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = Color3.fromRGB(140, 140, 160)
    D.Font = Enum.Font.Gotham
    D.TextSize = 10
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(0, 46, 0, 24)
    Bg.Position = UDim2.new(1, -62, 0.5, -12)
    Bg.BackgroundColor3 = CFG[key] and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(50, 50, 65)
    Bg.BorderSizePixel = 0
    Bg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = Bg

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
            TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1, -22, 0.5, -10)}):Play()
        else
            TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        AutoSave()
    end)
end

local function Slider(name, min, max, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 66)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BorderSizePixel = 0
    F.Parent = Scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 24)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name .. " : " .. CFG[key]
    L.TextColor3 = Color3.fromRGB(240, 240, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -32, 0, 8)
    BarBg.Position = UDim2.new(0, 16, 0, 42)
    BarBg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    BarBg.BorderSizePixel = 0
    BarBg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = BarBg

    local ratio = (CFG[key] - min) / (max - min)

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

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
    Btn.Size = UDim2.new(1, 0, 2, 0)
    Btn.Position = UDim2.new(0, 0, -0.5, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = BarBg

    local function Update(input)
        local r = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(min + r * (max - min))
        Fill.Size = UDim2.new(r, 0, 1, 0)
        L.Text = name .. " : " .. v
        CFG[key] = v
    end

    Btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = false; AutoSave()
        end
    end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
            Update(i)
        end
    end)
end

local function Button(name, desc, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 56)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BorderSizePixel = 0
    F.Parent = Scroll

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 24)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = Color3.fromRGB(240, 240, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -30, 0, 16)
    D.Position = UDim2.new(0, 16, 0, 30)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = Color3.fromRGB(140, 140, 160)
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

-- ================== BUILD UI ==================
Section("📁 ไฟล์ Save")
Button("📂 Path ของไฟล์", SAVE_SYSTEM:GetFullPath(), function()
    if setclipboard then
        setclipboard(SAVE_SYSTEM:GetFullPath())
        print("📋 Copy path แล้ว: " .. SAVE_SYSTEM:GetFullPath())
    end
end)
Button("💾 บันทึกเลย", "Save ค่าปัจจุบัน", function()
    AutoSave()
    print("💾 บันทึกแล้ว!")
end)

Section("🌾 ฟาร์ม")
Toggle("Auto Farm Level", "ฟาร์มมอนอัตโนมัติ", "AutoFarmLevel")
Toggle("Magnet Token", "ดึงมอนเข้าหา", "MagnetToken")

Section("🥋 สกิล")
Toggle("Auto Skill", "กด Z X C V", "AutoSkill")
Toggle("Auto Haki", "ใช้ Buso", "AutoHaki")
Toggle("Fast Attack", "ตีเร็วขึ้น", "FastAttack")

Section("⚙️ ตัวละคร")
Slider("WalkSpeed", 16, 500, "WalkSpeed")
Slider("JumpPower", 50, 500, "JumpPower")
Slider("Farm Distance", 5, 100, "FarmDistance")
Toggle("No Clip", "ทะลุกำแพง", "NoClip")
Toggle("Anti AFK", "กันถูกเตะ", "AntiAFK")

Section("🔧 ระบบ")
Button("🔄 Rejoin", "กลับเซิร์ฟเดิม", function()
    AutoSave()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)
Button("❌ ปิด UI", "ปิดหน้าต่าง", function()
    AutoSave()
    SG:Destroy()
end)

-- Keybind
UserInput.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        Main.Visible = not Main.Visible
    end
end)

print("═══════════════════════════════════")
print("✅ Rbot พร้อมใช้งาน!")
print("📁 Save path: " .. SAVE_SYSTEM:GetFullPath())
print("⌨️ กด Right Ctrl เพื่อซ่อน/แสดง UI")
print("═══════════════════════════════════")
