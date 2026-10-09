--[[
    🤖 Rbot Premium v4.0 - ULTIMATE EDITION
    🎨 Neon Glassmorphism UI 2026
    ✅ Auto Quest + Auto Farm + Fast Click + Bring Mobs + Auto Island
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
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

print("=== Rbot v4.0 ULTIMATE Loading ===")

-- ================== CHECK ==================
local WORLD = {
    [2753915549] = "Sea 1",
    [4442272183] = "Sea 2",
    [7449423635] = "Sea 3",
}
if not WORLD[game.PlaceId] then
    warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!")
    return
end

-- ================== CONFIG ==================
local CFG = {
    AutoFarm = false, AutoQuest = true, Magnet = false,
    AutoSkill = true, AutoHaki = true, FastAttack = true,
    AutoClick = true, NoClip = false, BringMobs = true,
    AutoIsland = true, AutoEquip = true,
    WalkSpeed = 16, JumpPower = 50, Distance = 30, BringDistance = 25,
}

-- ================== HELPERS ==================
local cachedChar, cachedHRP, cachedHum
local function OnChar(c)
    cachedChar = c
    cachedHRP = c:WaitForChild("HumanoidRootPart", 10)
    cachedHum = c:WaitForChild("Humanoid", 10)
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

-- ================== ISLANDS ==================
local ISLANDS = {
    ["Starter Island"]={Level=1,CFrame=CFrame.new(1040,16,1540)},
    ["Jungle"]={Level=15,CFrame=CFrame.new(-1626,35,45)},
    ["Pirate Village"]={Level=30,CFrame=CFrame.new(-1160,4,3850)},
    ["Desert"]={Level=60,CFrame=CFrame.new(970,100,4450)},
    ["Frozen Village"]={Level=90,CFrame=CFrame.new(1150,25,-1000)},
    ["Marine Ford"]={Level=120,CFrame=CFrame.new(-4750,25,4400)},
    ["Skylands"]={Level=150,CFrame=CFrame.new(-4850,720,-2650)},
    ["Colosseum"]={Level=200,CFrame=CFrame.new(-1850,25,1450)},
    ["Underwater City"]={Level=250,CFrame=CFrame.new(60500,700,1550)},
    ["Fountain City"]={Level=300,CFrame=CFrame.new(5250,30,4000)},
    ["Kingdom of Rose"]={Level=400,CFrame=CFrame.new(-390,30,5600)},
    ["Green Zone"]={Level=500,CFrame=CFrame.new(-350,30,8200)},
    ["Graveyard"]={Level=600,CFrame=CFrame.new(6500,25,-6000)},
    ["Snow Mountain"]={Level=700,CFrame=CFrame.new(1350,40,-7000)},
    ["Hot and Cold"]={Level=800,CFrame=CFrame.new(-5700,30,-6000)},
    ["Haunted Castle"]={Level=900,CFrame=CFrame.new(-9500,145,5800)},
    ["Cursed Ship"]={Level=1000,CFrame=CFrame.new(920,125,32800)},
    ["Forgotten Island"]={Level=1200,CFrame=CFrame.new(-3050,240,-10000)},
    ["Ice Castle"]={Level=1350,CFrame=CFrame.new(5450,60,-2500)},
    ["Port Town"]={Level=1500,CFrame=CFrame.new(-280,6,4700)},
    ["Hydra Island"]={Level=1650,CFrame=CFrame.new(5550,200,-5000)},
    ["Great Tree"]={Level=1800,CFrame=CFrame.new(2100,450,-7500)},
    ["Floating Turtle"]={Level=2000,CFrame=CFrame.new(-9500,400,-9500)},
    ["Castle on the Sea"]={Level=2750,CFrame=CFrame.new(-5000,500,-3000)},
}

-- ================== QUESTS ==================
local QUESTS = {
    {Name="Bandit",Level=1,Island="Starter Island"},
    {Name="Monkey",Level=1,Island="Starter Island"},
    {Name="Blade Bandit",Level=15,Island="Jungle"},
    {Name="Jungle Pirate",Level=20,Island="Jungle"},
    {Name="Desert Bandit",Level=30,Island="Desert"},
    {Name="Desert Officer",Level=40,Island="Desert"},
    {Name="Snow Bandit",Level=50,Island="Frozen Village"},
    {Name="Snowman",Level=60,Island="Frozen Village"},
    {Name="Frost Bandit",Level=75,Island="Marine Ford"},
    {Name="Marine",Level=85,Island="Marine Ford"},
    {Name="Sky Bandit",Level=90,Island="Skylands"},
    {Name="Dark Master",Level=100,Island="Skylands"},
    {Name="Fighter",Level=120,Island="Colosseum"},
    {Name="Fishman",Level=150,Island="Underwater City"},
    {Name="Magma Ninja",Level=175,Island="Fountain City"},
    {Name="Pirate Boss",Level=200,Island="Fountain City"},
    {Name="Snow Trooper",Level=250,Island="Kingdom of Rose"},
    {Name="Winter Warrior",Level=300,Island="Kingdom of Rose"},
    {Name="Lab Subordinate",Level=350,Island="Green Zone"},
    {Name="Horned Warrior",Level=400,Island="Green Zone"},
    {Name="Military Soldier",Level=450,Island="Graveyard"},
    {Name="Military Spy",Level=500,Island="Graveyard"},
    {Name="Reborn Skeleton",Level=550,Island="Graveyard"},
    {Name="Living Zombie",Level=600,Island="Graveyard"},
    {Name="Demonic Soul",Level=650,Island="Graveyard"},
    {Name="Possessed Mummy",Level=700,Island="Graveyard"},
    {Name="Snow Lurker",Level=725,Island="Snow Mountain"},
    {Name="Yeti",Level=750,Island="Snow Mountain"},
    {Name="Pirate Millionaire",Level=775,Island="Hot and Cold"},
    {Name="Pistol Billionaire",Level=800,Island="Hot and Cold"},
    {Name="Dragon Crew Archer",Level=850,Island="Hot and Cold"},
    {Name="Dragon Crew Warrior",Level=875,Island="Hot and Cold"},
    {Name="Amazon",Level=900,Island="Haunted Castle"},
    {Name="Island Empress",Level=925,Island="Haunted Castle"},
    {Name="Hydra Enforcer",Level=950,Island="Haunted Castle"},
    {Name="Venomous Assailant",Level=975,Island="Haunted Castle"},
    {Name="Reborn Skeleton",Level=1000,Island="Cursed Ship"},
    {Name="Living Zombie",Level=1025,Island="Cursed Ship"},
    {Name="Demonic Soul",Level=1050,Island="Cursed Ship"},
    {Name="Possessed Mummy",Level=1075,Island="Cursed Ship"},
    {Name="Snow Lurker",Level=1100,Island="Cursed Ship"},
    {Name="Ice Jailer",Level=1125,Island="Cursed Ship"},
    {Name="Cursed Pirate",Level=1150,Island="Cursed Ship"},
    {Name="Cursed Captain",Level=1175,Island="Cursed Ship"},
    {Name="Cursed Skeleton",Level=1200,Island="Cursed Ship"},
    {Name="Sea Soldier",Level=1250,Island="Forgotten Island"},
    {Name="Water Fighter",Level=1300,Island="Forgotten Island"},
    {Name="Pirate Millionaire",Level=1350,Island="Forgotten Island"},
    {Name="Forest Pirate",Level=1375,Island="Forgotten Island"},
    {Name="Mythological Pirate",Level=1425,Island="Forgotten Island"},
    {Name="Jungle Pirate",Level=1475,Island="Forgotten Island"},
    {Name="Musketeer Pirate",Level=1500,Island="Forgotten Island"},
    {Name="Pirate Luffy",Level=1500,Island="Port Town"},
    {Name="Pirate Crew Member",Level=1525,Island="Port Town"},
    {Name="Marine Recruit",Level=1550,Island="Port Town"},
    {Name="Marine Grunt",Level=1575,Island="Port Town"},
    {Name="Fishman Raider",Level=1625,Island="Hydra Island"},
    {Name="Fishman Captain",Level=1675,Island="Hydra Island"},
    {Name="Forest Pirate",Level=1725,Island="Hydra Island"},
    {Name="Mythological Pirate",Level=1775,Island="Hydra Island"},
    {Name="Jungle Pirate",Level=1825,Island="Hydra Island"},
    {Name="Musketeer Pirate",Level=1875,Island="Hydra Island"},
}

local function GetBestQuest()
    local lvl = SafeGet(LP.Data, "Level")
    local best = nil
    for _, q in pairs(QUESTS) do
        if q.Level <= lvl then
            if not best or q.Level > best.Level then best = q end
        end
    end
    return best
end

-- ================== QUEST SYSTEM ==================
local currentQuest = nil

local function GetQuest()
    local best = GetBestQuest()
    if not best then return false end
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("StartQuest", best.Name, best.Level)
    end)
    currentQuest = best
    print("📜 รับเควสต์: " .. best.Name .. " → " .. best.Island)
    return true
end

local function HasQuest()
    local ok, has = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and has
end

-- ================== TELEPORT ==================
local function TeleportToIsland(islandName)
    local island = ISLANDS[islandName]
    if not island then return false end
    pcall(function()
        local h = HRP()
        if h then h.CFrame = island.CFrame + Vector3.new(0, 30, 0) end
    end)
    return true
end

-- ================== BRING MOBS ==================
local function BringMobToPlayer(mob)
    pcall(function()
        local h = HRP()
        if not h then return end
        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChild("Humanoid")
        if not mobHRP or not mobHum then return end
        
        local offset = Vector3.new(
            math.random(-15, 15), 3, math.random(-15, 15)
        )
        mobHRP.CFrame = CFrame.new(h.Position + offset)
        mobHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        mobHum.WalkSpeed = 0
        mobHum.JumpPower = 0
        mobHum.PlatformStand = true
    end)
end

task.spawn(function()
    while task.wait(0.05) do
        if CFG.BringMobs and (CFG.AutoFarm or CFG.Magnet) then
            pcall(function()
                local h = HRP()
                if not h then return end
                local en = workspace:FindFirstChild("Enemies")
                if not en then return end
                for _, m in pairs(en:GetChildren()) do
                    local mobHRP = m:FindFirstChild("HumanoidRootPart")
                    local mobHum = m:FindFirstChild("Humanoid")
                    if mobHRP and mobHum and mobHum.Health > 0 
                       and (mobHRP.Position - h.Position).Magnitude <= 300 then
                        BringMobToPlayer(m)
                    end
                end
            end)
        end
    end
end)

-- ================== FAST CLICK ==================
local function Click()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(
            workspace.CurrentCamera.ViewportSize.X / 2,
            workspace.CurrentCamera.ViewportSize.Y / 2
        ))
    end)
end

local function HasTool()
    local c = Char()
    return c and c:FindFirstChildOfClass("Tool") ~= nil
end

local function HasEnemyNearby(radius)
    radius = radius or 80
    local h = HRP()
    if not h then return false end
    local en = workspace:FindFirstChild("Enemies")
    if not en then return false end
    for _, m in pairs(en:GetChildren()) do
        local mobHRP = m:FindFirstChild("HumanoidRootPart")
        local mobHum = m:FindFirstChild("Humanoid")
        if mobHRP and mobHum and mobHum.Health > 0 
           and (mobHRP.Position - h.Position).Magnitude <= radius then
            return true
        end
    end
    return false
end

RunService.Heartbeat:Connect(function()
    if not CFG.AutoClick then return end
    if not HasTool() then return end
    if not HasEnemyNearby(100) then return end
    Click()
end)

-- Auto Equip
task.spawn(function()
    while task.wait(2) do
        if CFG.AutoEquip and CFG.AutoFarm then
            pcall(function()
                local c = Char()
                if c and not c:FindFirstChildOfClass("Tool") then
                    local bp = LP:FindFirstChild("Backpack")
                    if bp then
                        for _, item in pairs(bp:GetChildren()) do
                            if item:IsA("Tool") then item.Parent = c break end
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== SKILL ==================
local SKILL_KEYS = {
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V,
    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R,
}

local function PressKey(k)
    pcall(function()
        VIM:SendKeyEvent(true, k, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, k, false, game)
    end)
end

task.spawn(function()
    while task.wait(0.2) do
        if CFG.AutoSkill and HasEnemyNearby(60) then
            for _, k in pairs(SKILL_KEYS) do
                PressKey(k)
                task.wait(0.03)
            end
        end
    end
end)

-- ================== SYSTEMS ==================
LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new(0, 0))
    end)
end)

task.spawn(function()
    while task.wait(0.3) do
        pcall(function()
            local h = Hum()
            if h then h.WalkSpeed = CFG.WalkSpeed h.JumpPower = CFG.JumpPower end
        end)
    end
end)

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

task.spawn(function()
    local getup = getupvalues or debug.getupvalue
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getup(c)[2]
    end)
    if not ok then return end
    while task.wait(0.1) do
        if CFG.FastAttack then
            pcall(function()
                if CF.activeController then
                    CF.activeController.timeToNextAttack = 0
                    CF.activeController.attacking = false
                    CF.activeController.increment = 4
                    CF.activeController.hitboxMagnitude = 65
                    CF.activeController.blocking = false
                end
            end)
        end
    end
end)

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

-- ================== AUTO FARM ==================
local function GetClosestEnemy(questName)
    local h = HRP()
    if not h then return nil, math.huge end
    local en = workspace:FindFirstChild("Enemies")
    if not en then return nil, math.huge end
    local closest, closestDist = nil, math.huge
    for _, m in pairs(en:GetChildren()) do
        local mobHRP = m:FindFirstChild("HumanoidRootPart")
        local mobHum = m:FindFirstChild("Humanoid")
        if mobHRP and mobHum and mobHum.Health > 0 then
            if questName and m.Name == questName then
                local d = (mobHRP.Position - h.Position).Magnitude
                if d < closestDist then closest = m closestDist = d end
            end
        end
    end
    return closest, closestDist
end

task.spawn(function()
    while task.wait(0.2) do
        if CFG.AutoFarm then
            pcall(function()
                local h = HRP()
                if not h then return end
                local best = GetBestQuest()
                if not best then return end

                if CFG.AutoIsland and best.Island then
                    local island = ISLANDS[best.Island]
                    if island then
                        local dist = (h.Position - island.CFrame.Position).Magnitude
                        if dist > 2000 then
                            TeleportToIsland(best.Island)
                            task.wait(1.5)
                            return
                        end
                    end
                end

                if CFG.AutoQuest and not HasQuest() then
                    if not currentQuest or currentQuest.Name ~= best.Name then
                        GetQuest()
                        task.wait(1)
                        return
                    end
                end

                local questName = currentQuest and currentQuest.Name or nil
                local target, dist = GetClosestEnemy(questName)
                if not target then target, dist = GetClosestEnemy(nil) end
                if target then
                    local mobHRP = target:FindFirstChild("HumanoidRootPart")
                    if mobHRP then
                        h.CFrame = mobHRP.CFrame * CFrame.new(0, CFG.Distance, 0)
                    end
                end
            end)
        end
    end
end)

print("✅ Systems loaded")

-- ================================================================
-- ========== 🎨 NEON GLASSMORPHISM UI v4.0 ======================
-- ================================================================

local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end
local oldBlur = Lighting:FindFirstChild("RbotBlur")
if oldBlur then oldBlur:Destroy() end

-- Color Palette
local COLORS = {
    Bg          = Color3.fromRGB(8, 6, 16),
    BgSecondary = Color3.fromRGB(18, 14, 28),
    Glass       = Color3.fromRGB(28, 22, 42),
    Border      = Color3.fromRGB(120, 80, 200),
    Purple      = Color3.fromRGB(160, 80, 255),
    Pink        = Color3.fromRGB(255, 60, 180),
    Cyan        = Color3.fromRGB(80, 220, 255),
    Text        = Color3.fromRGB(240, 235, 255),
    TextDim     = Color3.fromRGB(150, 140, 180),
}

local Blur = Instance.new("BlurEffect")
Blur.Name = "RbotBlur"
Blur.Size = 0
Blur.Parent = Lighting

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
Main.Position = UDim2.new(0.5, -390, 0.5, -260)
Main.BackgroundColor3 = COLORS.Bg
Main.BackgroundTransparency = 0.08
Main.BorderSizePixel = 0
Main.ClipsDescendants = false
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 22)
MC.Parent = Main

-- Animated Neon Border (2 layers)
local BorderGlow = Instance.new("Frame")
BorderGlow.Name = "BorderGlow"
BorderGlow.Size = UDim2.new(1, 8, 1, 8)
BorderGlow.Position = UDim2.new(0, -4, 0, -4)
BorderGlow.BackgroundColor3 = COLORS.Purple
BorderGlow.BackgroundTransparency = 0.5
BorderGlow.BorderSizePixel = 0
BorderGlow.ZIndex = -1
BorderGlow.Parent = Main

local BGC = Instance.new("UICorner")
BGC.CornerRadius = UDim.new(0, 24)
BGC.Parent = BorderGlow

local BGG = Instance.new("UIGradient")
BGG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.Purple),
    ColorSequenceKeypoint.new(0.5, COLORS.Pink),
    ColorSequenceKeypoint.new(1, COLORS.Cyan),
}
BGG.Rotation = 0
BGG.Parent = BorderGlow

-- Rotate gradient
task.spawn(function()
    local rot = 0
    while BorderGlow.Parent do
        rot = (rot + 2) % 360
        BGG.Rotation = rot
        task.wait(0.05)
    end
end)

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = COLORS.Border
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
MainStroke.Parent = Main

-- Background Pattern (Noise)
local NoiseOverlay = Instance.new("ImageLabel")
NoiseOverlay.Size = UDim2.new(1, 0, 1, 0)
NoiseOverlay.BackgroundTransparency = 1
NoiseOverlay.Image = "rbxassetid://5588597776"
NoiseOverlay.ImageTransparency = 0.94
NoiseOverlay.ImageColor3 = COLORS.Purple
NoiseOverlay.ScaleType = Enum.ScaleType.Tile
NoiseOverlay.TileSize = UDim2.new(0, 200, 0, 200)
NoiseOverlay.ZIndex = 0
NoiseOverlay.Parent = Main

-- ============ TOGGLE SYSTEM ============
local uiOpen = true
local FloatingBtn
local OPEN_SIZE = UDim2.new(0, 780, 0, 520)

local function SetUIVisible(visible)
    if uiOpen == visible then return end
    uiOpen = visible
    if visible then
        Main.Visible = true
        TS:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = OPEN_SIZE, BackgroundTransparency = 0.08
        }):Play()
        TS:Create(Blur, TweenInfo.new(0.4), {Size = 16}):Play()
        if FloatingBtn then
            TS:Create(FloatingBtn, TweenInfo.new(0.4), {
                Position = UDim2.new(0, -70, 0.5, -28)
            }):Play()
        end
    else
        TS:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        if FloatingBtn then
            TS:Create(FloatingBtn, TweenInfo.new(0.4), {
                Position = UDim2.new(0, 20, 0.5, -28)
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

TS:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
    Size = OPEN_SIZE
}):Play()
TS:Create(Blur, TweenInfo.new(0.7), {Size = 16}):Play()

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1, 0, 0, 70)
Header.BackgroundColor3 = COLORS.BgSecondary
Header.BackgroundTransparency = 0.4
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 22)
HC.Parent = Header

-- Fix bottom corners
local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 22)
HeaderFix.Position = UDim2.new(0, 0, 1, -22)
HeaderFix.BackgroundColor3 = COLORS.BgSecondary
HeaderFix.BackgroundTransparency = 0.4
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Header gradient line
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
HLineG.Transparency = NumberSequence.new{
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0),
    NumberSequenceKeypoint.new(1, 1),
}
HLineG.Parent = HLine

-- Logo (spinning)
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

-- Glow
local LogoGlow = Instance.new("ImageLabel")
LogoGlow.Size = UDim2.new(1, 30, 1, 30)
LogoGlow.Position = UDim2.new(0, -15, 0, -15)
LogoGlow.BackgroundTransparency = 1
LogoGlow.Image = "rbxassetid://4996891970"
LogoGlow.ImageColor3 = COLORS.Purple
LogoGlow.ImageTransparency = 0.3
LogoGlow.ScaleType = Enum.ScaleType.Slice
LogoGlow.SliceCenter = Rect.new(20, 20, 280, 280)
LogoGlow.ZIndex = -1
LogoGlow.Parent = LogoWrap

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1, 0, 1, 0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "R"
LogoTxt.TextColor3 = Color3.fromRGB(255, 255, 255)
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.TextSize = 26
LogoTxt.ZIndex = 2
LogoTxt.Parent = LogoWrap

-- Title
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 350, 0, 26)
Title.Position = UDim2.new(0, 76, 0, 14)
Title.BackgroundTransparency = 1
Title.Text = "RBOT PREMIUM"
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
SubTitle.Text = "v4.0 ULTIMATE • " .. WORLD[game.PlaceId] .. " • " .. LP.Name
SubTitle.TextColor3 = COLORS.TextDim
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- Live Stats Panel (right)
local StatsPanel = Instance.new("Frame")
StatsPanel.Size = UDim2.new(0, 200, 0, 42)
StatsPanel.Position = UDim2.new(1, -220, 0.5, -21)
StatsPanel.BackgroundColor3 = COLORS.Glass
StatsPanel.BackgroundTransparency = 0.5
StatsPanel.BorderSizePixel = 0
StatsPanel.Parent = Header

local SPC = Instance.new("UICorner")
SPC.CornerRadius = UDim.new(0, 12)
SPC.Parent = StatsPanel

local SPStroke = Instance.new("UIStroke")
SPStroke.Color = COLORS.Border
SPStroke.Thickness = 1
SPStroke.Transparency = 0.6
SPStroke.Parent = StatsPanel

local LevelTxt = Instance.new("TextLabel")
LevelTxt.Size = UDim2.new(0.5, -8, 1, 0)
LevelTxt.Position = UDim2.new(0, 8, 0, 0)
LevelTxt.BackgroundTransparency = 1
LevelTxt.Text = "LV." .. SafeGet(LP.Data, "Level")
LevelTxt.TextColor3 = COLORS.Cyan
LevelTxt.Font = Enum.Font.GothamBold
LevelTxt.TextSize = 13LevelTxt.TextXAlignment = Enum.TextXAlignment.Left
LevelTxt.Parent = StatsPanel

local QuestTxt = Instance.new("TextLabel")
QuestTxt.Size = UDim2.new(0.5, -8, 1, 0)
QuestTxt.Position = UDim2.new(0.5, 0, 0, 0)
QuestTxt.BackgroundTransparency = 1
QuestTxt.Text = "📜"
QuestTxt.TextColor3 = COLORS.Pink
QuestTxt.Font = Enum.Font.GothamBold
QuestTxt.TextSize = 13
QuestTxt.TextXAlignment = Enum.TextXAlignment.Right
QuestTxt.Parent = StatsPanel

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelTxt.Text = "LV." .. SafeGet(LP.Data, "Level")
            if currentQuest then
                QuestTxt.Text = "📜 " .. currentQuest.Name:sub(1, 12)
            else
                QuestTxt.Text = "📜 ไม่มี"
            end
        end)
    end
end)

-- Minimize
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0, 32, 0, 32)
MinBtn.Position = UDim2.new(1, -76, 0.5, -16)
MinBtn.BackgroundColor3 = COLORS.Glass
MinBtn.BackgroundTransparency = 0.3
MinBtn.Text = "−"
MinBtn.TextColor3 = COLORS.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 18
MinBtn.AutoButtonColor = false
MinBtn.Parent = Header

local MBC = Instance.new("UICorner")
MBC.CornerRadius = UDim.new(1, 0)
MBC.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.1, BackgroundColor3 = COLORS.Purple
    }):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3, BackgroundColor3 = COLORS.Glass
    }):Play()
end)
MinBtn.MouseButton1Click:Connect(function() SetUIVisible(false) end)

-- Close
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -16)
CloseBtn.BackgroundColor3 = COLORS.Glass
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = COLORS.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CBC = Instance.new("UICorner")
CBC.CornerRadius = UDim.new(1, 0)
CBC.Parent = CloseBtn

CloseBtn.MouseEnter:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.1, BackgroundColor3 = Color3.fromRGB(255, 60, 100)
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.3, BackgroundColor3 = COLORS.Glass
    }):Play()
end)
CloseBtn.MouseButton1Click:Connect(function() SetUIVisible(false) end)

-- ============ SIDEBAR ============
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

local SBStroke = Instance.new("UIStroke")
SBStroke.Color = COLORS.Border
SBStroke.Thickness = 1
SBStroke.Transparency = 0.7
SBStroke.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, -16, 1, -16)
TabList.Position = UDim2.new(0, 8, 0, 8)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TLLay = Instance.new("UIListLayout")
TLLay.Parent = TabList
TLLay.SortOrder = Enum.SortOrder.LayoutOrder
TLLay.Padding = UDim.new(0, 8)

-- ============ CONTENT ============
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

local CNStroke = Instance.new("UIStroke")
CNStroke.Color = COLORS.Border
CNStroke.Thickness = 1
CNStroke.Transparency = 0.7
CNStroke.Parent = Content

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

-- ============ UI FACTORY ============
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

    local IndG = Instance.new("UIGradient")
    IndG.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.Purple),
        ColorSequenceKeypoint.new(0.5, COLORS.Pink),
        ColorSequenceKeypoint.new(1, COLORS.Cyan),
    }
    IndG.Rotation = 90
    IndG.Parent = Ind

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

    Btn.MouseEnter:Connect(function()
        if page.Visible then return end
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.5, TextColor3 = COLORS.Text
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        if page.Visible then return end
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.7, TextColor3 = COLORS.TextDim
        }):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TS:Create(t.Btn, TweenInfo.new(0.2), {
                BackgroundTransparency = 0.7, TextColor3 = COLORS.TextDim
            }):Play()
            TS:Create(t.Ind, TweenInfo.new(0.2), {
                Size = UDim2.new(0, 4, 0, 0)
            }):Play()
        end
        page.Visible = true
        TS:Create(Btn, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.3, TextColor3 = COLORS.Text
        }):Play()
        TS:Create(Ind, TweenInfo.new(0.2), {
            Size = UDim2.new(0, 4, 0, 28)
        }):Play()
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

    local strk = Instance.new("UIStroke")
    strk.Color = COLORS.Border
    strk.Thickness = 1
    strk.Transparency = 0.75
    strk.Parent = F

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

    local G
    if CFG[key] then
        G = Instance.new("UIGradient")
        G.Color = ColorSequence.new{
            ColorSequenceKeypoint.new(0, COLORS.Purple),
            ColorSequenceKeypoint.new(1, COLORS.Pink),
        }
        G.Parent = Bg
    end

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

    Btn.MouseEnter:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.2}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency = 0.4}):Play()
    end)

    Btn.MouseButton1Click:Connect(function()
        CFG[key] = not CFG[key]
        if CFG[key] then
            TS:Create(Bg, TweenInfo.new(0.25), {
                BackgroundColor3 = COLORS.Purple
            }):Play()
            TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = UDim2.new(1, -24, 0.5, -11)
            }):Play()
            if not G then
                G = Instance.new("UIGradient")
                G.Color = ColorSequence.new{
                    ColorSequenceKeypoint.new(0, COLORS.Purple),
                    ColorSequenceKeypoint.new(1, COLORS.Pink),
                }
                G.Parent = Bg
            end
        else
            TS:Create(Bg, TweenInfo.new(0.25), {
                BackgroundColor3 = Color3.fromRGB(40, 35, 55)
            }):Play()
            TS:Create(Dot, TweenInfo.new(0.25, Enum.EasingStyle.Back), {
                Position = UDim2.new(0, 2, 0.5, -11)
            }):Play()
            if G then G:Destroy() G = nil end
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

    local strk = Instance.new("UIStroke")
    strk.Color = COLORS.Border
    strk.Thickness = 1
    strk.Transparency = 0.75
    strk.Parent = F

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

    local FG = Instance.new("UIGradient")
    FG.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, COLORS.Purple),
        ColorSequenceKeypoint.new(0.5, COLORS.Pink),
        ColorSequenceKeypoint.new(1, COLORS.Cyan),
    }
    FG.Parent = Fill

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = UDim2.new(1, -9, 0.5, -9)
    Dot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Dot.BorderSizePixel = 0
    Dot.Parent = Fill

    local dc = Instance.new("UICorner")
    dc.CornerRadius = UDim.new(1, 0)
    dc.Parent = Dot

    local DotGlow = Instance.new("ImageLabel")
    DotGlow.Size = UDim2.new(1, 20, 1, 20)
    DotGlow.Position = UDim2.new(0, -10, 0, -10)
    DotGlow.BackgroundTransparency = 1
    DotGlow.Image = "rbxassetid://4996891970"
    DotGlow.ImageColor3 = COLORS.Purple
    DotGlow.ImageTransparency = 0.4
    DotGlow.ScaleType = Enum.ScaleType.Slice
    DotGlow.SliceCenter = Rect.new(20, 20, 280, 280)
    DotGlow.ZIndex = -1
    DotGlow.Parent = Dot

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

    local strk = Instance.new("UIStroke")
    strk.Color = COLORS.Border
    strk.Thickness = 1
    strk.Transparency = 0.75
    strk.Parent = F

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

    Btn.MouseEnter:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.2, BackgroundColor3 = Color3.fromRGB(45, 32, 68)
        }):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {
            BackgroundTransparency = 0.4, BackgroundColor3 = COLORS.Glass
        }):Play()
    end)
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- ================== TABS ==================
local HomeTab = CreateTab("หน้าหลัก", "🏠")
local FarmTab = CreateTab("ฟาร์ม", "🌾")
local SkillTab = CreateTab("สกิล", "🥋")
local MiscTab = CreateTab("อื่น ๆ", "⚙️")
local SetTab = CreateTab("ตั้งค่า", "🔧")

Section(HomeTab, "ข้อมูลระบบ")
Button(HomeTab, "🤖 Rbot Premium v4.0", "Ultimate Edition • Neon UI", function() end)
Button(HomeTab, "📜 เควสต์ปัจจุบัน", currentQuest and currentQuest.Name or "ยังไม่มี", function()
    if currentQuest then
        print("📜 " .. currentQuest.Name .. " → " .. currentQuest.Island)
    end
end)
Button(HomeTab, "📊 สถิติ", "LV." .. SafeGet(LP.Data, "Level") .. " | 💰 " .. FormatNum(SafeGet(LP.Data, "Beli")), function() end)

Section(HomeTab, "วิธีใช้")
Button(HomeTab, "⌨️ Right Ctrl", "เปิด/ปิด UI", function() end)
Button(HomeTab, "🟣 โลโก้ R", "คลิกเปิด UI (ตอนปิด)", function() end)

Section(FarmTab, "🎯 Auto Farm")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ", "AutoQuest")
Toggle(FarmTab, "Auto Farm", "ฟาร์ม + ตี + ย้ายเกาะ", "AutoFarm")
Toggle(FarmTab, "Auto Island", "ย้ายเกาะตาม Level", "AutoIsland")
Toggle(FarmTab, "Auto Click", "คลิกเร็ว (Heartbeat)", "AutoClick")
Toggle(FarmTab, "Auto Equip", "ติดอาวุธอัตโนมัติ", "AutoEquip")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนมารวมที่ตัว", "BringMobs")
Toggle(FarmTab, "Magnet", "ดึงของทุกอย่าง", "Magnet")

Section(FarmTab, "ระยะ")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")
Slider(FarmTab, "Bring Distance", 5, 50, "BringDistance")

Section(SkillTab, "🥋 สกิล")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F E Q R", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "ตีเร็วขึ้น", "FastAttack")

Section(MiscTab, "⚙️ ระบบ")
Toggle(MiscTab, "No Clip", "ทะลุกำแพง", "NoClip")

Section(SetTab, "🏃 ตัวละคร")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")

Section(SetTab, "🔧 ระบบ")
Button(SetTab, "🔄 Rejoin Server", "กลับเซิร์ฟเวอร์เดิม", function()
    TPS:Teleport(game.PlaceId, LP)
end)
Button(SetTab, "❌ ปิด UI", "ปิดหน้าต่าง UI", function()
    SetUIVisible(false)
end)

-- ================== LOGO FLOATING BUTTON ==================
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 60, 0, 60)
FloatingBtn.Position = UDim2.new(0, -70, 0.5, -30)
FloatingBtn.BackgroundColor3 = COLORS.Purple
FloatingBtn.BorderSizePixel = 0
FloatingBtn.Text = "R"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.Font = Enum.Font.GothamBlack
FloatingBtn.TextSize = 26
FloatingBtn.AutoButtonColor = false
FloatingBtn.ZIndex = 999
FloatingBtn.Parent = SG

local FBC = Instance.new("UICorner")
FBC.CornerRadius = UDim.new(1, 0)
FBC.Parent = FloatingBtn

local FBGrad = Instance.new("UIGradient")
FBGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, COLORS.Purple),
    ColorSequenceKeypoint.new(0.5, COLORS.Pink),
    ColorSequenceKeypoint.new(1, COLORS.Cyan),
}
FBGrad.Rotation = 45
FBGrad.Parent = FloatingBtn

task.spawn(function()
    local rot = 45
    while FBGrad.Parent do
        rot = (rot + 2) % 360
        FBGrad.Rotation = rot
        task.wait(0.05)
    end
end)

local FBStroke = Instance.new("UIStroke")
FBStroke.Color = COLORS.Pink
FBStroke.Thickness = 2
FBStroke.Transparency = 0.4
FBStroke.Parent = FloatingBtn

local FBGlow = Instance.new("ImageLabel")
FBGlow.Size = UDim2.new(1, 40, 1, 40)
FBGlow.Position = UDim2.new(0, -20, 0, -20)
FBGlow.BackgroundTransparency = 1
FBGlow.Image = "rbxassetid://4996891970"
FBGlow.ImageColor3 = COLORS.Purple
FBGlow.ImageTransparency = 0.3
FBGlow.ScaleType = Enum.ScaleType.Slice
FBGlow.SliceCenter = Rect.new(20, 20, 280, 280)
FBGlow.ZIndex = -1
FBGlow.Parent = FloatingBtn

-- Pulse animation
task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        task.wait(1.5)
        if not uiOpen then
            TS:Create(FloatingBtn, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                Size = UDim2.new(0, 70, 0, 70)
            }):Play()
            task.wait(0.6)
            if FloatingBtn then
                TS:Create(FloatingBtn, TweenInfo.new(0.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut), {
                    Size = UDim2.new(0, 60, 0, 60)
                }):Play()
            end
        end
    end
end)

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

FloatingBtn.MouseButton1Click:Connect(function()
    SetUIVisible(not uiOpen)
end)

-- ================== KEYBIND ==================
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        SetUIVisible(not uiOpen)
    end
end)

print("═══════════════════════════════════════════════")
print("✅ Rbot Premium v4.0 - ULTIMATE EDITION")
print("🎨 Neon Glassmorphism UI Loaded")
print("⚡ Fast Click + Auto Quest + Auto Island")
print("⌨️ Right Ctrl = เปิด/ปิด UI")
print("═══════════════════════════════════════════════")
