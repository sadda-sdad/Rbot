--[[
    🤖 Rbot Premium v3.3
    ✅ Auto Quest + Auto Attack + Logo Toggle
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

print("=== Rbot v3.3 Loading ===")

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
    AutoQuest = true,       -- รับเควสต์ก่อนฟาร์ม
    Magnet = false,
    AutoSkill = true,
    AutoHaki = true,
    FastAttack = true,
    AutoClick = true,
    NoClip = false,
    BringMobs = false,      -- ดึงมอนเข้าหา
    WalkSpeed = 16,
    JumpPower = 50,
    Distance = 30,
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

-- ================== QUEST DATABASE ==================
-- เควสต์ทั้งหมดใน Blox Fruits (ชื่อ, Level ที่ต้องการ)
local QUESTS = {
    -- Sea 1
    {Name = "Bandit",        Level = 1,    NPC = "Bandit",       Island = "Starter Island"},
    {Name = "Monkey",        Level = 1,    NPC = "Monkey",       Island = "Starter Island"},
    {Name = "Blade Bandit",  Level = 15,   NPC = "Blade Bandit", Island = "Jungle"},
    {Name = "Jungle Pirate", Level = 20,   NPC = "Jungle Pirate",Island = "Jungle"},
    {Name = "Desert Bandit", Level = 30,   NPC = "Desert Bandit",Island = "Desert"},
    {Name = "Desert Officer",Level = 40,   NPC = "Desert Officer",Island = "Desert"},
    {Name = "Snow Bandit",   Level = 50,   NPC = "Snow Bandit",  Island = "Frozen Village"},
    {Name = "Snowman",       Level = 60,   NPC = "Snowman",      Island = "Frozen Village"},
    {Name = "Frost Bandit",  Level = 75,   NPC = "Frost Bandit", Island = "Marine Ford"},
    {Name = "Marine",        Level = 85,   NPC = "Marine",       Island = "Marine Ford"},
    {Name = "Sky Bandit",    Level = 90,   NPC = "Sky Bandit",   Island = "Skylands"},
    {Name = "Dark Master",   Level = 100,  NPC = "Dark Master",  Island = "Skylands"},
    {Name = "Fighter",       Level = 120,  NPC = "Fighter",      Island = "Colosseum"},
    {Name = "Fishman",       Level = 150,  NPC = "Fishman",      Island = "Underwater City"},
    {Name = "Magma Ninja",   Level = 175,  NPC = "Magma Ninja",  Island = "Fountain City"},
    {Name = "Pirate Boss",   Level = 200,  NPC = "Pirate Boss",  Island = "Fountain City"},
    {Name = "Snow Trooper",  Level = 250,  NPC = "Snow Trooper", Island = "Kingdom of Rose"},
    {Name = "Winter Warrior",Level = 300,  NPC = "Winter Warrior",Island = "Kingdom of Rose"},
    {Name = "Lab Subordinate",Level = 350, NPC = "Lab Subordinate",Island = "Green Zone"},
    {Name = "Horned Warrior",Level = 400,  NPC = "Horned Warrior",Island = "Green Zone"},
    {Name = "Military Soldier",Level = 450,NPC = "Military Soldier",Island = "Graveyard"},
    {Name = "Military Spy",  Level = 500,  NPC = "Military Spy", Island = "Graveyard"},
    {Name = "Reborn Skeleton",Level = 550, NPC = "Reborn Skeleton",Island = "Graveyard"},
    {Name = "Living Zombie", Level = 600,  NPC = "Living Zombie",Island = "Graveyard"},
    {Name = "Demonic Soul",  Level = 650,  NPC = "Demonic Soul", Island = "Graveyard"},
    {Name = "Possessed Mummy",Level = 700, NPC = "Possessed Mummy",Island = "Graveyard"},
    {Name = "Snow Lurker",   Level = 725,  NPC = "Snow Lurker",  Island = "Snow Mountain"},
    {Name = "Yeti",          Level = 750,  NPC = "Yeti",         Island = "Snow Mountain"},
    {Name = "Pirate Millionaire",Level = 775,NPC = "Pirate Millionaire",Island = "Hot and Cold"},
    {Name = "Pistol Billionaire",Level = 800,NPC = "Pistol Billionaire",Island = "Hot and Cold"},
    {Name = "Dragon Crew Archer",Level = 850,NPC = "Dragon Crew Archer",Island = "Hot and Cold"},
    {Name = "Dragon Crew Warrior",Level = 875,NPC = "Dragon Crew Warrior",Island = "Hot and Cold"},
    {Name = "Amazon",        Level = 900,  NPC = "Amazon",       Island = "Haunted Castle"},
    {Name = "Island Empress",Level = 925,  NPC = "Island Empress",Island = "Haunted Castle"},
    {Name = "Hydra Enforcer",Level = 950,  NPC = "Hydra Enforcer",Island = "Haunted Castle"},
    {Name = "Venomous Assailant",Level = 975,NPC = "Venomous Assailant",Island = "Haunted Castle"},
    {Name = "Reborn Skeleton",Level = 1000,NPC = "Reborn Skeleton",Island = "Cursed Ship"},
    {Name = "Living Zombie", Level = 1025, NPC = "Living Zombie",Island = "Cursed Ship"},
    {Name = "Demonic Soul",  Level = 1050, NPC = "Demonic Soul", Island = "Cursed Ship"},
    {Name = "Possessed Mummy",Level = 1075,NPC = "Possessed Mummy",Island = "Cursed Ship"},
    {Name = "Snow Lurker",   Level = 1100, NPC = "Snow Lurker",  Island = "Cursed Ship"},
    {Name = "Ice Jailer",    Level = 1125, NPC = "Ice Jailer",   Island = "Cursed Ship"},
    {Name = "Cursed Pirate", Level = 1150, NPC = "Cursed Pirate",Island = "Cursed Ship"},
    {Name = "Cursed Captain",Level = 1175, NPC = "Cursed Captain",Island = "Cursed Ship"},
    {Name = "Cursed Skeleton",Level = 1200,NPC = "Cursed Skeleton",Island = "Cursed Ship"},
    {Name = "Sea Soldier",   Level = 1250, NPC = "Sea Soldier",  Island = "Forgotten Island"},
    {Name = "Water Fighter", Level = 1300, NPC = "Water Fighter",Island = "Forgotten Island"},
    {Name = "Pirate Millionaire",Level = 1350,NPC = "Pirate Millionaire",Island = "Forgotten Island"},
    {Name = "Forest Pirate", Level = 1375, NPC = "Forest Pirate",Island = "Forgotten Island"},
    {Name = "Mythological Pirate",Level = 1425,NPC = "Mythological Pirate",Island = "Forgotten Island"},
    {Name = "Jungle Pirate", Level = 1475, NPC = "Jungle Pirate",Island = "Forgotten Island"},
    {Name = "Musketeer Pirate",Level = 1500,NPC = "Musketeer Pirate",Island = "Forgotten Island"},
    -- Sea 2 (เริ่มที่ Lv 700)
    {Name = "Raider",        Level = 700,  NPC = "Raider",       Island = "Kingdom of Rose"},
    {Name = "Mercenary",     Level = 725,  NPC = "Mercenary",    Island = "Kingdom of Rose"},
    {Name = "Swan Pirate",   Level = 775,  NPC = "Swan Pirate",  Island = "Kingdom of Rose"},
    {Name = "Factory Staff", Level = 800,  NPC = "Factory Staff",Island = "Kingdom of Rose"},
    {Name = "Marine Captain",Level = 850,  NPC = "Marine Captain",Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 900,  NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 950,  NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1000, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1050, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1100, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1150, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1200, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1250, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1300, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1350, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1400, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1450, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Zombie",        Level = 1500, NPC = "Zombie",       Island = "Kingdom of Rose"},
    {Name = "Reborn Skeleton",Level = 1550,NPC = "Reborn Skeleton",Island = "Cursed Ship"},
    {Name = "Living Zombie", Level = 1625, NPC = "Living Zombie",Island = "Cursed Ship"},
    {Name = "Demonic Soul",  Level = 1700, NPC = "Demonic Soul", Island = "Cursed Ship"},
    {Name = "Possessed Mummy",Level = 1775,NPC = "Possessed Mummy",Island = "Cursed Ship"},
    {Name = "Snow Lurker",   Level = 1850, NPC = "Snow Lurker",  Island = "Cursed Ship"},
    {Name = "Ice Jailer",    Level = 1900, NPC = "Ice Jailer",   Island = "Cursed Ship"},
    {Name = "Cursed Pirate", Level = 1950, NPC = "Cursed Pirate",Island = "Cursed Ship"},
    {Name = "Cursed Captain",Level = 2000, NPC = "Cursed Captain",Island = "Cursed Ship"},
    {Name = "Cursed Skeleton",Level = 2050,NPC = "Cursed Skeleton",Island = "Cursed Ship"},
    {Name = "Sea Soldier",   Level = 2100, NPC = "Sea Soldier",  Island = "Forgotten Island"},
    {Name = "Water Fighter", Level = 2150, NPC = "Water Fighter",Island = "Forgotten Island"},
    {Name = "Pirate Millionaire",Level = 2200,NPC = "Pirate Millionaire",Island = "Forgotten Island"},
    {Name = "Forest Pirate", Level = 2250, NPC = "Forest Pirate",Island = "Forgotten Island"},
    {Name = "Mythological Pirate",Level = 2300,NPC = "Mythological Pirate",Island = "Forgotten Island"},
    {Name = "Jungle Pirate", Level = 2350, NPC = "Jungle Pirate",Island = "Forgotten Island"},
    {Name = "Musketeer Pirate",Level = 2400,NPC = "Musketeer Pirate",Island = "Forgotten Island"},
    -- Sea 3
    {Name = "Pirate Luffy",  Level = 1500, NPC = "Pirate Luffy", Island = "Port Town"},
    {Name = "Pirate Crew Member",Level = 1525,NPC = "Pirate Crew Member",Island = "Port Town"},
    {Name = "Marine Recruit",Level = 1550, NPC = "Marine Recruit",Island = "Port Town"},
    {Name = "Marine Grunt",  Level = 1575, NPC = "Marine Grunt", Island = "Port Town"},
    {Name = "Fishman Raider",Level = 1625, NPC = "Fishman Raider",Island = "Hydra Island"},
    {Name = "Fishman Captain",Level = 1675,NPC = "Fishman Captain",Island = "Hydra Island"},
    {Name = "Forest Pirate", Level = 1725, NPC = "Forest Pirate",Island = "Hydra Island"},
    {Name = "Mythological Pirate",Level = 1775,NPC = "Mythological Pirate",Island = "Hydra Island"},
    {Name = "Jungle Pirate", Level = 1825, NPC = "Jungle Pirate",Island = "Hydra Island"},
    {Name = "Musketeer Pirate",Level = 1875,NPC = "Musketeer Pirate",Island = "Hydra Island"},
    {Name = "Reborn Skeleton",Level = 1925,NPC = "Reborn Skeleton",Island = "Haunted Castle"},
    {Name = "Living Zombie", Level = 1975, NPC = "Living Zombie",Island = "Haunted Castle"},
    {Name = "Demonic Soul",  Level = 2025, NPC = "Demonic Soul", Island = "Haunted Castle"},
    {Name = "Possessed Mummy",Level = 2075,NPC = "Possessed Mummy",Island = "Haunted Castle"},
    {Name = "Snow Lurker",   Level = 2125, NPC = "Snow Lurker",  Island = "Snow Mountain"},
    {Name = "Ice Jailer",    Level = 2175, NPC = "Ice Jailer",   Island = "Snow Mountain"},
    {Name = "Cursed Pirate", Level = 2225, NPC = "Cursed Pirate",Island = "Snow Mountain"},
    {Name = "Cursed Captain",Level = 2275, NPC = "Cursed Captain",Island = "Snow Mountain"},
    {Name = "Cursed Skeleton",Level = 2325,NPC = "Cursed Skeleton",Island = "Snow Mountain"},
    {Name = "Sea Soldier",   Level = 2375, NPC = "Sea Soldier",  Island = "Floating Turtle"},
    {Name = "Water Fighter", Level = 2425, NPC = "Water Fighter",Island = "Floating Turtle"},
    {Name = "Pirate Millionaire",Level = 2475,NPC = "Pirate Millionaire",Island = "Floating Turtle"},
    {Name = "Forest Pirate", Level = 2525, NPC = "Forest Pirate",Island = "Floating Turtle"},
    {Name = "Mythological Pirate",Level = 2575,NPC = "Mythological Pirate",Island = "Floating Turtle"},
}

-- หาเควสต์ที่ตรงกับ Level ปัจจุบัน
local function GetBestQuest()
    local lvl = SafeGet(LP.Data, "Level")
    local best = nil
    for _, q in pairs(QUESTS) do
        if q.Level <= lvl then
            if not best or q.Level > best.Level then
                best = q
            end
        end
    end
    return best
end

-- ================== QUEST SYSTEM ==================
local currentQuest = nil

local function GetQuest()
    local best = GetBestQuest()
    if not best then return false end
    
    -- รับเควสต์ผ่าน Remote
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("StartQuest", best.Name, best.Level)
    end)
    
    currentQuest = best
    print("📜 รับเควสต์: " .. best.Name .. " (Lv." .. best.Level .. ")")
    return true
end

-- เช็คว่ารับเควสต์อยู่หรือไม่
local function HasQuest()
    local ok, has = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and has
end

-- เช็คจำนวนมอนที่ฆ่า
local function GetQuestProgress()
    local ok, txt = pcall(function()
        return LP.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
    end)
    if ok and txt then
        -- format: "Defeat 5 Bandit"
        local current, total = txt:match("(%d+)/(%d+)")
        return tonumber(current) or 0, tonumber(total) or 0
    end
    return 0, 0
end

-- ================== CLICK ==================
local function Click()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(0, 0))
    end)
end

-- Fast Click Loop
task.spawn(function()
    while task.wait() do
        if CFG.AutoClick then
            pcall(function()
                if CFG.AutoFarm then
                    Click()
                    return
                end
                -- ถ้าไม่ AutoFarm คลิกเฉพาะตอนมีมอนใกล้
                local h = HRP()
                if not h then return end
                local en = workspace:FindFirstChild("Enemies")
                if en then
                    for _, m in pairs(en:GetChildren()) do
                        local hrp = m:FindFirstChild("HumanoidRootPart")
                        local hum = m:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 
                           and (hrp.Position - h.Position).Magnitude <= 100 then
                            Click()
                            return
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== SKILL COMBO ==================
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

task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoSkill then
            pcall(function()
                local h = HRP()
                if not h then return end
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

-- ================== 🎯 AUTO FARM + QUEST ==================
-- นี่คือส่วนสำคัญ! ลำดับการทำงาน:
-- 1. เช็คว่ามีเควสต์ไหม → ไม่มี = รับเควสต์
-- 2. หามอนในเควสต์
-- 3. Teleport ไปตี
-- 4. ครบ → ส่งเควสต์ → รับใหม่

task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoFarm then
            pcall(function()
                local h = HRP()
                if not h then return end

                -- STEP 1: รับเควสต์ถ้ายังไม่มี
                if CFG.AutoQuest and not HasQuest() then
                    GetQuest()
                    task.wait(1)
                    return
                end

                -- STEP 2: หามอนในเควสต์
                local en = workspace:FindFirstChild("Enemies")
                if not en then return end

                local questName = currentQuest and currentQuest.Name or nil
                local closest, closestDist = nil, math.huge

                for _, m in pairs(en:GetChildren()) do
                    local hrp = m:FindFirstChild("HumanoidRootPart")
                    local hum = m:FindFirstChild("Humanoid")
                    if hrp and hum and hum.Health > 0 then
                        -- เช็คว่าตรงกับเควสต์ไหม
                        local isQuestMob = true
                        if questName then
                            isQuestMob = (m.Name == questName) 
                        end
                        
                        if isQuestMob then
                            local d = (hrp.Position - h.Position).Magnitude
                            if d < closestDist then
                                closest = m
                                closestDist = d
                            end
                        end
                    end
                end

                -- ถ้าไม่เจอมอนในเควสต์ → ใช้ตัวแรกที่เจอ
                if not closest then
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
                end

                -- STEP 3: Teleport ไปตี
                if closest then
                    local hrp = closest:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        local targetCF = hrp.CFrame * CFrame.new(0, CFG.Distance, 0)
                        h.CFrame = targetCF
                    end
                end
            end)
        end
    end
end)

-- ================== BRING MOBS (ตัวเลือกเสริม) ==================
task.spawn(function()
    while task.wait(0.1) do
        if CFG.BringMobs then
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
                        hrp.Size = Vector3.new(30, 30, 30)
                        hum.WalkSpeed = 0
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

-- ============ MAIN ============
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

-- ============ TOGGLE ============
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
Title.Text = "RBOT • PREMIUM v3.3"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 300, 0, 18)
SubTitle.Position = UDim2.new(0, 72, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Auto Quest + Attack | " .. WORLD[game.PlaceId]
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

local QuestTxt = Instance.new("TextLabel")
QuestTxt.Size = UDim2.new(0, 150, 0, 18)
QuestTxt.Position = UDim2.new(1, -250, 0, 35)
QuestTxt.BackgroundTransparency = 1
QuestTxt.Text = "📜 รอเควสต์..."
QuestTxt.TextColor3 = Color3.fromRGB(160, 150, 180)
QuestTxt.Font = Enum.Font.Gotham
QuestTxt.TextSize = 10
QuestTxt.TextXAlignment = Enum.TextXAlignment.Right
QuestTxt.Parent = Header

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            LevelTxt.Text = "LV." .. SafeGet(LP.Data, "Level")
            if currentQuest then
                QuestTxt.Text = "📜 " .. currentQuest.Name .. " Lv." .. currentQuest.Level
            else
                QuestTxt.Text = "📜 ไม่มีเควสต์"
            end
        end)
    end
end)

-- Min Button
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
Button(HomeTab, "🤖 Rbot v3.3", "Auto Quest + Attack", function() end)
Button(HomeTab, "📜 เควสต์ปัจจุบัน", "ดูว่าได้รับเควสต์อะไรอยู่", function() 
    if currentQuest then
        print("เควสต์: " .. currentQuest.Name .. " Lv." .. currentQuest.Level)
    else
        print("ยังไม่มีเควสต์")
    end
end)
Section(HomeTab, "วิธีใช้")
Button(HomeTab, "⌨️ Right Ctrl", "เปิด/ปิด UI", function() end)
Button(HomeTab, "🟣 โลโก้ R", "คลิกเพื่อเปิด UI", function() end)

Section(FarmTab, "🎯 Auto Farm System")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ (ต้องเปิด!)", "AutoQuest")
Toggle(FarmTab, "Auto Farm", "ฟาร์ม + ตีมอน + ส่งเควสต์", "AutoFarm")
Toggle(FarmTab, "Auto Click", "คลิกอัตโนมัติ", "AutoClick")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนเข้าหาตัว (เร็ว)", "BringMobs")
Toggle(FarmTab, "Magnet Token", "ดึงทุกอย่างเข้าหา", "Magnet")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")

Section(SkillTab, "สกิล")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F E Q R", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "ตีเร็วขึ้น", "FastAttack")

Section(MiscTab, "ระบบ")
Toggle(MiscTab, "No Clip", "ทะลุกำแพง", "NoClip")

Section(SetTab, "ตัวละคร")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")
Section(SetTab, "ระบบ")
Button(SetTab, "🔄 Rejoin", "กลับเซิร์ฟเวอร์", function()
    TPS:Teleport(game.PlaceId, LP)
end)
Button(SetTab, "❌ ปิด UI", "ปิดหน้าต่าง", function()
    SetUIVisible(false)
end)

-- ================== LOGO FLOATING BUTTON ==================
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size = UDim2.new(0, 56, 0, 56)
FloatingBtn.Position = UDim2.new(0, -60, 0.5, -28)
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

task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        task.wait(1.5)
        if not uiOpen then
            TS:Create(FloatingBtn, TweenInfo.new(0.5), {
                Size = UDim2.new(0, 64, 0, 64)
            }):Play()
            task.wait(0.5)
            if FloatingBtn then
                TS:Create(FloatingBtn, TweenInfo.new(0.5), {
                    Size = UDim2.new(0, 56, 0, 56)
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

print("═══════════════════════════════════════")
print("✅ Rbot v3.3 พร้อมใช้งาน!")
print("📜 Auto Quest: เปิดอัตโนมัติ")
print("🌾 Auto Farm: เปิดในเมนู")
print("⌨️ Right Ctrl = เปิด/ปิด UI")
print("🟣 คลิกโลโก้ R = เปิด/ปิด UI")
print("═══════════════════════════════════════")
