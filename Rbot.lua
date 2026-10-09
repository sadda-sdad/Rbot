--[[
    🤖 Rbot Premium v3.4
    ✅ Bring Mobs + Fast Click + Auto Island
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

print("=== Rbot v3.4 Loading ===")

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
print("🎮 Game: " .. WORLD[game.PlaceId])

-- ================== CONFIG ==================
local CFG = {
    AutoFarm = false,
    AutoQuest = true,
    Magnet = false,
    AutoSkill = true,
    AutoHaki = true,
    FastAttack = true,
    AutoClick = true,
    NoClip = false,
    BringMobs = true,       -- ดึงมอนมาหา (default เปิด)
    AutoIsland = true,      -- ย้ายเกาะอัตโนมัติ
    WalkSpeed = 16,
    JumpPower = 50,
    Distance = 30,
    BringDistance = 25,     -- ระยะที่ดึงมอนมา
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

-- ================== 🌍 ISLAND DATABASE ==================
-- เกาะทั้งหมดพร้อม CFrame หลัก
local ISLANDS = {
    -- Sea 1
    ["Starter Island"]   = {Level = 1,    CFrame = CFrame.new(1040, 16, 1540)},
    ["Jungle"]           = {Level = 15,   CFrame = CFrame.new(-1626, 35, 45)},
    ["Pirate Village"]   = {Level = 30,   CFrame = CFrame.new(-1160, 4, 3850)},
    ["Desert"]           = {Level = 60,   CFrame = CFrame.new(970, 100, 4450)},
    ["Frozen Village"]   = {Level = 90,   CFrame = CFrame.new(1150, 25, -1000)},
    ["Marine Ford"]      = {Level = 120,  CFrame = CFrame.new(-4750, 25, 4400)},
    ["Skylands"]         = {Level = 150,  CFrame = CFrame.new(-4850, 720, -2650)},
    ["Colosseum"]        = {Level = 200,  CFrame = CFrame.new(-1850, 25, 1450)},
    ["Underwater City"]  = {Level = 250,  CFrame = CFrame.new(60500, 700, 1550)},
    ["Fountain City"]    = {Level = 300,  CFrame = CFrame.new(5250, 30, 4000)},
    ["Kingdom of Rose"]  = {Level = 400,  CFrame = CFrame.new(-390, 30, 5600)},
    ["Green Zone"]       = {Level = 500,  CFrame = CFrame.new(-350, 30, 8200)},
    ["Graveyard"]        = {Level = 600,  CFrame = CFrame.new(6500, 25, -6000)},
    ["Snow Mountain"]    = {Level = 700,  CFrame = CFrame.new(1350, 40, -7000)},
    ["Hot and Cold"]     = {Level = 800,  CFrame = CFrame.new(-5700, 30, -6000)},
    ["Haunted Castle"]   = {Level = 900,  CFrame = CFrame.new(-9500, 145, 5800)},
    ["Cursed Ship"]      = {Level = 1000, CFrame = CFrame.new(920, 125, 32800)},
    ["Forgotten Island"] = {Level = 1200, CFrame = CFrame.new(-3050, 240, -10000)},
    -- Sea 2
    ["Kingdom of Rose S2"] = {Level = 700, CFrame = CFrame.new(-390, 30, 5600)},
    ["Cursed Ship S2"]     = {Level = 1000,CFrame = CFrame.new(920, 125, 32800)},
    ["Forgotten Island S2"]= {Level = 1200,CFrame = CFrame.new(-3050, 240, -10000)},
    ["Ice Castle"]         = {Level = 1350,CFrame = CFrame.new(5450, 60, -2500)},
    ["Forgotten Island S2b"]={Level = 1425,CFrame = CFrame.new(-3050, 240, -10000)},
    ["Haunted Castle S2"]  = {Level = 1500,CFrame = CFrame.new(-9500, 145, 5800)},
    ["Cursed Ship S2b"]    = {Level = 1625,CFrame = CFrame.new(920, 125, 32800)},
    ["Forgotten Island S2c"]={Level = 1700,CFrame = CFrame.new(-3050, 240, -10000)},
    -- Sea 3
    ["Port Town"]          = {Level = 1500,CFrame = CFrame.new(-280, 6, 4700)},
    ["Hydra Island"]       = {Level = 1650,CFrame = CFrame.new(5550, 200, -5000)},
    ["Great Tree"]         = {Level = 1800,CFrame = CFrame.new(2100, 450, -7500)},
    ["Floating Turtle"]    = {Level = 2000,CFrame = CFrame.new(-9500, 400, -9500)},
    ["Haunted Castle S3"]  = {Level = 2200,CFrame = CFrame.new(-9500, 145, 5800)},
    ["Snow Mountain S3"]   = {Level = 2350,CFrame = CFrame.new(1350, 40, -7000)},
    ["Fountain City S3"]   = {Level = 2500,CFrame = CFrame.new(5250, 30, 4000)},
    ["Castle on the Sea"]  = {Level = 2750,CFrame = CFrame.new(-5000, 500, -3000)},
    ["Pirate Village S3"]  = {Level = 2900,CFrame = CFrame.new(-1160, 4, 3850)},
    ["Hydra Island S3"]    = {Level = 3050,CFrame = CFrame.new(5550, 200, -5000)},
    ["Great Tree S3"]      = {Level = 3200,CFrame = CFrame.new(2100, 450, -7500)},
    ["Floating Turtle S3"] = {Level = 3350,CFrame = CFrame.new(-9500, 400, -9500)},
    ["Haunted Castle S3b"] = {Level = 3500,CFrame = CFrame.new(-9500, 145, 5800)},
}

-- ================== QUEST DATABASE ==================
local QUESTS = {
    -- Sea 1
    {Name="Bandit", Level=1, Island="Starter Island"},
    {Name="Monkey", Level=1, Island="Starter Island"},
    {Name="Blade Bandit", Level=15, Island="Jungle"},
    {Name="Jungle Pirate", Level=20, Island="Jungle"},
    {Name="Desert Bandit", Level=30, Island="Desert"},
    {Name="Desert Officer", Level=40, Island="Desert"},
    {Name="Snow Bandit", Level=50, Island="Frozen Village"},
    {Name="Snowman", Level=60, Island="Frozen Village"},
    {Name="Frost Bandit", Level=75, Island="Marine Ford"},
    {Name="Marine", Level=85, Island="Marine Ford"},
    {Name="Sky Bandit", Level=90, Island="Skylands"},
    {Name="Dark Master", Level=100, Island="Skylands"},
    {Name="Fighter", Level=120, Island="Colosseum"},
    {Name="Fishman", Level=150, Island="Underwater City"},
    {Name="Magma Ninja", Level=175, Island="Fountain City"},
    {Name="Pirate Boss", Level=200, Island="Fountain City"},
    {Name="Snow Trooper", Level=250, Island="Kingdom of Rose"},
    {Name="Winter Warrior", Level=300, Island="Kingdom of Rose"},
    {Name="Lab Subordinate", Level=350, Island="Green Zone"},
    {Name="Horned Warrior", Level=400, Island="Green Zone"},
    {Name="Military Soldier", Level=450, Island="Graveyard"},
    {Name="Military Spy", Level=500, Island="Graveyard"},
    {Name="Reborn Skeleton", Level=550, Island="Graveyard"},
    {Name="Living Zombie", Level=600, Island="Graveyard"},
    {Name="Demonic Soul", Level=650, Island="Graveyard"},
    {Name="Possessed Mummy", Level=700, Island="Graveyard"},
    {Name="Snow Lurker", Level=725, Island="Snow Mountain"},
    {Name="Yeti", Level=750, Island="Snow Mountain"},
    {Name="Pirate Millionaire", Level=775, Island="Hot and Cold"},
    {Name="Pistol Billionaire", Level=800, Island="Hot and Cold"},
    {Name="Dragon Crew Archer", Level=850, Island="Hot and Cold"},
    {Name="Dragon Crew Warrior", Level=875, Island="Hot and Cold"},
    {Name="Amazon", Level=900, Island="Haunted Castle"},
    {Name="Island Empress", Level=925, Island="Haunted Castle"},
    {Name="Hydra Enforcer", Level=950, Island="Haunted Castle"},
    {Name="Venomous Assailant", Level=975, Island="Haunted Castle"},
    {Name="Reborn Skeleton", Level=1000, Island="Cursed Ship"},
    {Name="Living Zombie", Level=1025, Island="Cursed Ship"},
    {Name="Demonic Soul", Level=1050, Island="Cursed Ship"},
    {Name="Possessed Mummy", Level=1075, Island="Cursed Ship"},
    {Name="Snow Lurker", Level=1100, Island="Cursed Ship"},
    {Name="Ice Jailer", Level=1125, Island="Cursed Ship"},
    {Name="Cursed Pirate", Level=1150, Island="Cursed Ship"},
    {Name="Cursed Captain", Level=1175, Island="Cursed Ship"},
    {Name="Cursed Skeleton", Level=1200, Island="Cursed Ship"},
    {Name="Sea Soldier", Level=1250, Island="Forgotten Island"},
    {Name="Water Fighter", Level=1300, Island="Forgotten Island"},
    {Name="Pirate Millionaire", Level=1350, Island="Forgotten Island"},
    {Name="Forest Pirate", Level=1375, Island="Forgotten Island"},
    {Name="Mythological Pirate", Level=1425, Island="Forgotten Island"},
    {Name="Jungle Pirate", Level=1475, Island="Forgotten Island"},
    {Name="Musketeer Pirate", Level=1500, Island="Forgotten Island"},
    -- Sea 2
    {Name="Raider", Level=700, Island="Kingdom of Rose S2"},
    {Name="Mercenary", Level=725, Island="Kingdom of Rose S2"},
    {Name="Swan Pirate", Level=775, Island="Kingdom of Rose S2"},
    {Name="Factory Staff", Level=800, Island="Kingdom of Rose S2"},
    {Name="Marine Captain", Level=850, Island="Kingdom of Rose S2"},
    {Name="Zombie", Level=900, Island="Kingdom of Rose S2"},
    {Name="Snow Lurker", Level=1100, Island="Snow Mountain"},
    {Name="Snow Trooper", Level=1150, Island="Snow Mountain"},
    {Name="Winter Warrior", Level=1200, Island="Snow Mountain"},
    {Name="Snow Bandit", Level=1250, Island="Snow Mountain"},
    {Name="Reborn Skeleton", Level=1300, Island="Cursed Ship S2"},
    {Name="Living Zombie", Level=1350, Island="Cursed Ship S2"},
    {Name="Demonic Soul", Level=1400, Island="Cursed Ship S2"},
    {Name="Possessed Mummy", Level=1450, Island="Cursed Ship S2"},
    {Name="Snow Lurker", Level=1500, Island="Cursed Ship S2"},
    {Name="Ice Jailer", Level=1550, Island="Cursed Ship S2"},
    {Name="Cursed Pirate", Level=1600, Island="Cursed Ship S2"},
    {Name="Cursed Captain", Level=1650, Island="Cursed Ship S2"},
    {Name="Cursed Skeleton", Level=1700, Island="Cursed Ship S2"},
    {Name="Sea Soldier", Level=1750, Island="Forgotten Island S2"},
    {Name="Water Fighter", Level=1800, Island="Forgotten Island S2"},
    {Name="Pirate Millionaire", Level=1850, Island="Forgotten Island S2"},
    {Name="Forest Pirate", Level=1900, Island="Forgotten Island S2"},
    {Name="Mythological Pirate", Level=1950, Island="Forgotten Island S2"},
    {Name="Jungle Pirate", Level=2000, Island="Forgotten Island S2"},
    {Name="Musketeer Pirate", Level=2050, Island="Forgotten Island S2"},
    {Name="Reborn Skeleton", Level=2100, Island="Haunted Castle S2"},
    {Name="Living Zombie", Level=2150, Island="Haunted Castle S2"},
    {Name="Demonic Soul", Level=2200, Island="Haunted Castle S2"},
    {Name="Possessed Mummy", Level=2250, Island="Haunted Castle S2"},
    {Name="Snow Lurker", Level=2300, Island="Haunted Castle S2"},
    {Name="Ice Jailer", Level=2350, Island="Haunted Castle S2"},
    {Name="Cursed Pirate", Level=2400, Island="Haunted Castle S2"},
    {Name="Cursed Captain", Level=2450, Island="Haunted Castle S2"},
    -- Sea 3
    {Name="Pirate Luffy", Level=1500, Island="Port Town"},
    {Name="Pirate Crew Member", Level=1525, Island="Port Town"},
    {Name="Marine Recruit", Level=1550, Island="Port Town"},
    {Name="Marine Grunt", Level=1575, Island="Port Town"},
    {Name="Fishman Raider", Level=1625, Island="Hydra Island"},
    {Name="Fishman Captain", Level=1675, Island="Hydra Island"},
    {Name="Forest Pirate", Level=1725, Island="Hydra Island"},
    {Name="Mythological Pirate", Level=1775, Island="Hydra Island"},
    {Name="Jungle Pirate", Level=1825, Island="Hydra Island"},
    {Name="Musketeer Pirate", Level=1875, Island="Hydra Island"},
    {Name="Reborn Skeleton", Level=1925, Island="Haunted Castle S3"},
    {Name="Living Zombie", Level=1975, Island="Haunted Castle S3"},
    {Name="Demonic Soul", Level=2025, Island="Haunted Castle S3"},
    {Name="Possessed Mummy", Level=2075, Island="Haunted Castle S3"},
    {Name="Snow Lurker", Level=2125, Island="Snow Mountain S3"},
    {Name="Ice Jailer", Level=2175, Island="Snow Mountain S3"},
    {Name="Cursed Pirate", Level=2225, Island="Snow Mountain S3"},
    {Name="Cursed Captain", Level=2275, Island="Snow Mountain S3"},
    {Name="Cursed Skeleton", Level=2325, Island="Snow Mountain S3"},
    {Name="Sea Soldier", Level=2375, Island="Floating Turtle S3"},
    {Name="Water Fighter", Level=2425, Island="Floating Turtle S3"},
    {Name="Pirate Millionaire", Level=2475, Island="Floating Turtle S3"},
    {Name="Forest Pirate", Level=2525, Island="Floating Turtle S3"},
    {Name="Mythological Pirate", Level=2575, Island="Floating Turtle S3"},
    {Name="Jungle Pirate", Level=2625, Island="Floating Turtle S3"},
    {Name="Musketeer Pirate", Level=2675, Island="Floating Turtle S3"},
    {Name="Reborn Skeleton", Level=2725, Island="Haunted Castle S3b"},
    {Name="Living Zombie", Level=2775, Island="Haunted Castle S3b"},
    {Name="Demonic Soul", Level=2825, Island="Haunted Castle S3b"},
    {Name="Possessed Mummy", Level=2875, Island="Haunted Castle S3b"},
}

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
    
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("StartQuest", best.Name, best.Level)
    end)
    
    currentQuest = best
    print("📜 รับเควสต์: " .. best.Name .. " (Lv." .. best.Level .. ") → " .. best.Island)
    return true
end

local function HasQuest()
    local ok, has = pcall(function()
        return LP.PlayerGui.Main.Quest.Visible
    end)
    return ok and has
end

-- ================== 📍 TELEPORT ==================
local function TeleportTo(cf)
    pcall(function()
        local h = HRP()
        if not h then return end
        h.CFrame = cf
    end)
end

local function TeleportToIsland(islandName)
    local island = ISLANDS[islandName]
    if not island then
        warn("⚠️ ไม่เจอเกาะ: " .. islandName)
        return false
    end
    pcall(function()
        local h = HRP()
        if h then
            h.CFrame = island.CFrame + Vector3.new(0, 30, 0)
        end
    end)
    return true
end

-- ================== 🎯 BRING MOBS (แก้ไม่ให้ขึ้นฟ้า) ==================
-- ดึงมอนมารวมที่ตัวเรา ระยะ 25 studs ด้านหน้า
local function BringMobToPlayer(mob)
    pcall(function()
        local h = HRP()
        if not h then return end
        local mobHRP = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChild("Humanoid")
        if not mobHRP or not mobHum then return end
        
        -- ✅ ดึงมารวมที่ตัวเรา (ระยะ 15 studs ด้านหน้า ไม่ขึ้นฟ้า)
        local offset = Vector3.new(
            math.random(-15, 15),
            3,  -- ความสูง 3 studs (เท่าตัวเรา)
            math.random(-15, 15)
        )
        local targetPos = h.Position + offset
        
        -- ใช้ CFrame ตรงๆ ไม่ให้ลอย
        mobHRP.CFrame = CFrame.new(targetPos)
        mobHRP.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
        
        -- หยุดการเคลื่อนที่ของมอน
        mobHum.WalkSpeed = 0
        mobHum.JumpPower = 0
        mobHum.PlatformStand = true  -- ✅ ป้องกันการลอย
        
        -- ล็อค Position ไว้ (ทุก 0.1 วิ จะ re-position)
        mobHRP.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0)
    end)
end

-- Bring Mobs Loop
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
                    if mobHRP and mobHum and mobHum.Health > 0 then
                        local dist = (mobHRP.Position - h.Position).Magnitude
                        if dist <= 300 then
                            BringMobToPlayer(m)
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== ⚡ FAST CLICK (แก้ให้เร็วสุด) ==================
local lastClick = 0
local function Click()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton1(Vector2.new(0, 0))
    end)
end

-- ✅ ใช้ RunService.Heartbeat เพื่อคลิกทุกเฟรม (เร็วที่สุด)
-- + เพิ่ม VIM สำหรับ executor ที่ VU ไม่ทำงาน
local ClickConn = RunService.Heartbeat:Connect(function()
    if not CFG.AutoClick then return end
    if not CFG.AutoFarm then return end
    
    pcall(function()
        local h = HRP()
        if not h then return end
        
        -- เช็คว่ามีมอนใกล้ไหม
        local hasEnemy = false
        local en = workspace:FindFirstChild("Enemies")
        if en then
            for _, m in pairs(en:GetChildren()) do
                local mobHRP = m:FindFirstChild("HumanoidRootPart")
                local mobHum = m:FindFirstChild("Humanoid")
                if mobHRP and mobHum and mobHum.Health > 0 
                   and (mobHRP.Position - h.Position).Magnitude <= 80 then
                    hasEnemy = true
                    break
                end
            end
        end
        
        if hasEnemy then
            -- คลิก 2 วิธีพร้อมกันเพื่อความชัวร์
            VU:CaptureController()
            VU:ClickButton1(Vector2.new(0, 0))
        end
    end)
end)

-- ================== ⌨️ SKILL COMBO ==================
local SKILL_KEYS = {
    Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V,
    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R,
}

local function PressKey(keyCode)
    pcall(function()
        VIM:SendKeyEvent(true, keyCode, false, game)
        task.wait(0.01)
        VIM:SendKeyEvent(false, keyCode, false, game)
    end)
end

task.spawn(function()
    while task.wait(0.2) do
        if CFG.AutoSkill then
            pcall(function()
                local h = HRP()
                if not h then return end
                local hasEnemy = false
                local en = workspace:FindFirstChild("Enemies")
                if en then
                    for _, m in pairs(en:GetChildren()) do
                        local mobHRP = m:FindFirstChild("HumanoidRootPart")
                        local mobHum = m:FindFirstChild("Humanoid")
                        if mobHRP and mobHum and mobHum.Health > 0 
                           and (mobHRP.Position - h.Position).Magnitude <= 60 then
                            hasEnemy = true
                            break
                        end
                    end
                end
                if hasEnemy then
                    for _, k in pairs(SKILL_KEYS) do
                        PressKey(k)
                        task.wait(0.03)
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
                    CF.activeController.hitboxMagnitude = 65
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

-- ================== 🌍 AUTO ISLAND + FARM ==================
-- ขั้นตอน:
-- 1. ดู Level → หาเควสต์ที่ดีที่สุด
-- 2. เช็คว่าเราอยู่เกาะที่ถูกไหม → ถ้าไม่ Teleport ไป
-- 3. รับเควสต์
-- 4. ดึงมอน + ตี
-- 5. ครบเควสต์ → วนใหม่

local function GetClosestEnemy(questName)
    local h = HRP()
    if not h then return nil end
    local en = workspace:FindFirstChild("Enemies")
    if not en then return nil end
    
    local closest, closestDist = nil, math.huge
    for _, m in pairs(en:GetChildren()) do
        local mobHRP = m:FindFirstChild("HumanoidRootPart")
        local mobHum = m:FindFirstChild("Humanoid")
        if mobHRP and mobHum and mobHum.Health > 0 then
            -- ถ้ามีชื่อเควสต์ → ตรงกับเควสต์ก่อน
            if questName and m.Name == questName then
                local d = (mobHRP.Position - h.Position).Magnitude
                if d < closestDist then
                    closest = m
                    closestDist = d
                end
            end
        end
    end
    return closest, closestDist
end

task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoFarm then
            pcall(function()
                local h = HRP()
                if not h then return end

                -- STEP 1: หาเควสต์ที่ดีที่สุด
                local best = GetBestQuest()
                if not best then return end

                -- STEP 2: Auto Island - ถ้าอยู่ผิดเกาะ ให้ย้าย
                if CFG.AutoIsland and best.Island then
                    local island = ISLANDS[best.Island]
                    if island then
                        -- เช็คระยะห่างจากเกาะเป้าหมาย
                        local dist = (h.Position - island.CFrame.Position).Magnitude
                        if dist > 2000 then
                            -- ห่างเกิน → Teleport ไปเกาะ
                            TeleportToIsland(best.Island)
                            task.wait(1)
                            return
                        end
                    end
                end

                -- STEP 3: รับเควสต์ถ้ายังไม่มี
                if CFG.AutoQuest and not HasQuest() then
                    -- ถ้า currentQuest ไม่ตรงกับ best → รับใหม่
                    if not currentQuest or currentQuest.Name ~= best.Name then
                        GetQuest()
                        task.wait(1)
                        return
                    end
                end

                -- STEP 4: หามอน
                local questName = currentQuest and currentQuest.Name or nil
                local target, dist = GetClosestEnemy(questName)
                
                -- ถ้าไม่เจอมอนในเควสต์ → ใช้ตัวไหนก็ได้
                if not target then
                    target, dist = GetClosestEnemy(nil)
                end

                -- STEP 5: Teleport ไปหามอน
                if target and dist then
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
-- ================== 🎨 UI =======================================
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
            Size = OPEN_SIZE, BackgroundTransparency = 0.05
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
Title.Text = "RBOT • PREMIUM v3.4"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 300, 0, 18)
SubTitle.Position = UDim2.new(0, 72, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Bring Mobs + Auto Island | " .. WORLD[game.PlaceId]
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
                QuestTxt.Text = "📜 " .. currentQuest.Name
            else
                QuestTxt.Text = "📜 ไม่มีเควสต์"
            end
        end)
    end
end)

-- Min Btn
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
Button(HomeTab, "🤖 Rbot v3.4", "Bring Mobs + Auto Island", function() end)
Button(HomeTab, "📜 เควสต์ปัจจุบัน", "ดูเควสต์ที่ทำอยู่", function() 
    if currentQuest then
        print("📜 " .. currentQuest.Name .. " | เกาะ: " .. currentQuest.Island)
    else
        print("ยังไม่มีเควสต์")
    end
end)
Section(HomeTab, "วิธีใช้")
Button(HomeTab, "⌨️ Right Ctrl", "เปิด/ปิด UI", function() end)
Button(HomeTab, "🟣 โลโก้ R", "คลิกเปิด/ปิด UI", function() end)

Section(FarmTab, "🎯 Auto Farm System")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ", "AutoQuest")
Toggle(FarmTab, "Auto Farm", "ฟาร์ม + ตี + ย้ายเกาะ", "AutoFarm")
Toggle(FarmTab, "Auto Island", "ย้ายเกาะตาม Level", "AutoIsland")
Toggle(FarmTab, "Auto Click", "คลิกเร็วมาก (Heartbeat)", "AutoClick")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนมารวมที่ตัวเรา", "BringMobs")
Toggle(FarmTab, "Magnet", "ดึงของ + มอนทุกอย่าง", "Magnet")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")
Slider(FarmTab, "Bring Distance", 5, 50, "BringDistance")

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
print("✅ Rbot v3.4 พร้อมใช้งาน!")
print("🎯 Bring Mobs: ดึงมอนมาที่ตัว (ไม่ขึ้นฟ้า)")
print("⚡ Fast Click: คลิกทุกเฟรม (Heartbeat)")
print("🌍 Auto Island: ย้ายเกาะตาม Level")
print("═══════════════════════════════════════")
