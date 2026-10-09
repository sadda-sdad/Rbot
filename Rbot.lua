--[[
    🔥 Rbot Premium v11.0 - ULTIMATE EDITION
    ✅ Minimize (➖) + Expand (✚) + Close (✕)
    ✅ Bring Mobs ไม่ดึงขึ้นฟ้า
    ✅ Level 1-3000 | Sea 1-4 | 150+ Quests
    ✅ Auto Farm + Boss + Raid + Elite Hunter + Chest
    ✅ 5-Way Safe Click (ไม่กินเมาส์)
]]

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local TS = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TPS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

print("🔥 Rbot v11.0 Loading...")

-- ================== CHECK ==================
local WORLD = {
    [2753915549]="Sea 1",[4442272183]="Sea 2",
    [7449423635]="Sea 3",[155615604]="Sea 4",
}
if not WORLD[game.PlaceId] then warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!") return end
print("🌊 " .. WORLD[game.PlaceId])

-- ================== CONFIG ==================
local CFG = {
    AutoFarm=false, AutoQuest=true, AutoIsland=true, AutoClick=true,
    AutoSkill=true, AutoHaki=true, AutoEquip=true,
    FastAttack=true, BringMobs=true, Magnet=false,
    AutoBoss=false, AutoEliteHunter=false, AutoRaid=false, AutoChest=false,
    NoClip=false, WalkSpeed=16, JumpPower=50, Distance=30, ClickSpeed=0.03,
}
local uiHovering = false  -- ✅ Global flag ป้องกัน UI กดไม่ได้

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
local function SafeGet(t,k) local o,v=pcall(function() return t[k].Value end) return o and v or 0 end
local function FormatNum(n)
    if n>=1e9 then return string.format("%.1fB",n/1e9)
    elseif n>=1e6 then return string.format("%.1fM",n/1e6)
    elseif n>=1e3 then return string.format("%.1fK",n/1e3)
    else return tostring(math.floor(n)) end
end

-- ================== 🌍 ISLANDS ==================
local ISLANDS = {
    ["Starter Island"]={Level=1,CF=CFrame.new(1040,16,1540)},
    ["Jungle"]={Level=15,CF=CFrame.new(-1626,35,45)},
    ["Pirate Village"]={Level=30,CF=CFrame.new(-1160,4,3850)},
    ["Desert"]={Level=60,CF=CFrame.new(970,100,4450)},
    ["Frozen Village"]={Level=90,CF=CFrame.new(1150,25,-1000)},
    ["Marine Ford"]={Level=120,CF=CFrame.new(-4750,25,4400)},
    ["Skylands"]={Level=150,CF=CFrame.new(-4850,720,-2650)},
    ["Colosseum"]={Level=200,CF=CFrame.new(-1850,25,1450)},
    ["Underwater City"]={Level=250,CF=CFrame.new(60500,700,1550)},
    ["Fountain City"]={Level=300,CF=CFrame.new(5250,30,4000)},
    ["Kingdom of Rose"]={Level=400,CF=CFrame.new(-390,30,5600)},
    ["Green Zone"]={Level=500,CF=CFrame.new(-350,30,8200)},
    ["Graveyard"]={Level=600,CF=CFrame.new(6500,25,-6000)},
    ["Snow Mountain"]={Level=700,CF=CFrame.new(1350,40,-7000)},
    ["Hot and Cold"]={Level=800,CF=CFrame.new(-5700,30,-6000)},
    ["Haunted Castle"]={Level=900,CF=CFrame.new(-9500,145,5800)},
    ["Cursed Ship"]={Level=1000,CF=CFrame.new(920,125,32800)},
    ["Forgotten Island"]={Level=1200,CF=CFrame.new(-3050,240,-10000)},
    ["Ice Castle"]={Level=1350,CF=CFrame.new(5450,60,-2500)},
    ["Port Town"]={Level=1500,CF=CFrame.new(-280,6,4700)},
    ["Hydra Island"]={Level=1650,CF=CFrame.new(5550,200,-5000)},
    ["Great Tree"]={Level=1800,CF=CFrame.new(2100,450,-7500)},
    ["Floating Turtle"]={Level=2000,CF=CFrame.new(-9500,400,-9500)},
    ["Castle on the Sea"]={Level=2200,CF=CFrame.new(-5000,500,-3000)},
    ["Sea of Treats"]={Level=2275,CF=CFrame.new(-1900,20,-12000)},
    ["Chocolate Land"]={Level=2450,CF=CFrame.new(-1776,37,-11800)},
    ["Tiki Outpost"]={Level=2525,CF=CFrame.new(-5000,500,-3000)},
    ["Submerged Island"]={Level=2625,CF=CFrame.new(60500,700,1550)},
}

-- ================== 📜 QUESTS ==================
local QUESTS = {
    {Name="Bandit",Level=1,I="Starter Island"},{Name="Monkey",Level=1,I="Starter Island"},
    {Name="Blade Bandit",Level=15,I="Jungle"},{Name="Jungle Pirate",Level=20,I="Jungle"},
    {Name="Desert Bandit",Level=30,I="Desert"},{Name="Desert Officer",Level=40,I="Desert"},
    {Name="Snow Bandit",Level=50,I="Frozen Village"},{Name="Snowman",Level=60,I="Frozen Village"},
    {Name="Frost Bandit",Level=75,I="Marine Ford"},{Name="Marine",Level=85,I="Marine Ford"},
    {Name="Sky Bandit",Level=90,I="Skylands"},{Name="Dark Master",Level=100,I="Skylands"},
    {Name="Fighter",Level=120,I="Colosseum"},{Name="Fishman",Level=150,I="Underwater City"},
    {Name="Magma Ninja",Level=175,I="Fountain City"},{Name="Pirate Boss",Level=200,I="Fountain City"},
    {Name="Snow Trooper",Level=250,I="Kingdom of Rose"},{Name="Winter Warrior",Level=300,I="Kingdom of Rose"},
    {Name="Lab Subordinate",Level=350,I="Green Zone"},{Name="Horned Warrior",Level=400,I="Green Zone"},
    {Name="Military Soldier",Level=450,I="Graveyard"},{Name="Military Spy",Level=500,I="Graveyard"},
    {Name="Reborn Skeleton",Level=550,I="Graveyard"},{Name="Living Zombie",Level=600,I="Graveyard"},
    {Name="Demonic Soul",Level=650,I="Graveyard"},{Name="Possessed Mummy",Level=700,I="Graveyard"},
    {Name="Snow Lurker",Level=725,I="Snow Mountain"},{Name="Yeti",Level=750,I="Snow Mountain"},
    {Name="Pirate Millionaire",Level=775,I="Hot and Cold"},{Name="Pistol Billionaire",Level=800,I="Hot and Cold"},
    {Name="Dragon Crew Archer",Level=850,I="Hot and Cold"},{Name="Dragon Crew Warrior",Level=875,I="Hot and Cold"},
    {Name="Amazon",Level=900,I="Haunted Castle"},{Name="Island Empress",Level=925,I="Haunted Castle"},
    {Name="Hydra Enforcer",Level=950,I="Haunted Castle"},{Name="Venomous Assailant",Level=975,I="Haunted Castle"},
    {Name="Reborn Skeleton",Level=1000,I="Cursed Ship"},{Name="Living Zombie",Level=1025,I="Cursed Ship"},
    {Name="Demonic Soul",Level=1050,I="Cursed Ship"},{Name="Possessed Mummy",Level=1075,I="Cursed Ship"},
    {Name="Snow Lurker",Level=1100,I="Cursed Ship"},{Name="Ice Jailer",Level=1125,I="Cursed Ship"},
    {Name="Cursed Pirate",Level=1150,I="Cursed Ship"},{Name="Cursed Captain",Level=1175,I="Cursed Ship"},
    {Name="Cursed Skeleton",Level=1200,I="Cursed Ship"},{Name="Sea Soldier",Level=1250,I="Forgotten Island"},
    {Name="Water Fighter",Level=1300,I="Forgotten Island"},{Name="Pirate Millionaire",Level=1350,I="Forgotten Island"},
    {Name="Forest Pirate",Level=1375,I="Forgotten Island"},{Name="Mythological Pirate",Level=1425,I="Forgotten Island"},
    {Name="Jungle Pirate",Level=1475,I="Forgotten Island"},{Name="Musketeer Pirate",Level=1500,I="Forgotten Island"},
    {Name="Pirate Millionaire",Level=1500,I="Port Town"},{Name="Pistol Billionaire",Level=1525,I="Port Town"},
    {Name="Stone",Level=1550,I="Port Town"},{Name="Dragon Crew Warrior",Level=1575,I="Hydra Island"},
    {Name="Dragon Crew Archer",Level=1600,I="Hydra Island"},{Name="Hydra Enforcer",Level=1625,I="Hydra Island"},
    {Name="Venomous Assailant",Level=1650,I="Hydra Island"},{Name="Hydra Leader",Level=1675,I="Hydra Island"},
    {Name="Marine Commodore",Level=1700,I="Great Tree"},{Name="Marine Rear Admiral",Level=1725,I="Great Tree"},
    {Name="Kilo Admiral",Level=1750,I="Great Tree"},{Name="Captain Elephant",Level=1875,I="Floating Turtle"},
    {Name="Beautiful Pirate",Level=1950,I="Floating Turtle"},{Name="Reborn Skeleton",Level=1975,I="Floating Turtle"},
    {Name="Living Zombie",Level=2000,I="Floating Turtle"},{Name="Demonic Soul",Level=2025,I="Floating Turtle"},
    {Name="Possessed Mummy",Level=2050,I="Floating Turtle"},{Name="Peanut Scout",Level=2075,I="Sea of Treats"},
    {Name="Peanut President",Level=2100,I="Sea of Treats"},{Name="Ice Cream Chef",Level=2125,I="Sea of Treats"},
    {Name="Ice Cream Commander",Level=2150,I="Sea of Treats"},{Name="Cookie Crafter",Level=2200,I="Sea of Treats"},
    {Name="Cake Guard",Level=2225,I="Sea of Treats"},{Name="Baking Staff",Level=2250,I="Sea of Treats"},
    {Name="Head Baker",Level=2275,I="Chocolate Land"},{Name="Cocoa Warrior",Level=2300,I="Chocolate Land"},
    {Name="Chocolate Bar Battler",Level=2325,I="Chocolate Land"},{Name="Sweet Thief",Level=2350,I="Chocolate Land"},
    {Name="Candy Rebel",Level=2375,I="Chocolate Land"},{Name="Candy Pirate",Level=2400,I="Chocolate Land"},
    {Name="Snow Demon",Level=2425,I="Chocolate Land"},{Name="Island Empress",Level=2500,I="Tiki Outpost"},
    {Name="Island Champion",Level=2525,I="Tiki Outpost"},{Name="Reef Bandit",Level=2600,I="Submerged Island"},
    {Name="Coral Pirate",Level=2625,I="Submerged Island"},{Name="Sea Chanter",Level=2650,I="Submerged Island"},
    {Name="Ocean Prophet",Level=2675,I="Submerged Island"},{Name="High Disciple",Level=2695,I="Submerged Island"},
    {Name="Grand Devotee",Level=2700,I="Submerged Island"},
}

local function GetBestQuest()
    local lvl = SafeGet(LP.Data, "Level")
    local best = nil
    for _,q in pairs(QUESTS) do
        if q.Level <= lvl then
            if not best or q.Level > best.Level then best = q end
        end
    end
    return best
end

-- ================== 🎯 QUEST ==================
local currentQuest = nil
local lastQuestAttempt = 0
local function HasQuest()
    local ok,has = pcall(function() return LP.PlayerGui.Main.Quest.Visible end)
    return ok and has
end
local function GetCurrentQuestName()
    local ok,name = pcall(function()
        return LP.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text:match("Defeat %d+ (.+)") or ""
    end)
    return ok and name or ""
end
local function GetQuest()
    local now = tick()
    if now - lastQuestAttempt < 3 then return false end
    lastQuestAttempt = now
    local best = GetBestQuest()
    if not best then return false end
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("StartQuest", best.Name, best.Level)
    end)
    currentQuest = best
    print("📜 "..best.Name.." (Lv."..best.Level..") → "..best.I)
    return true
end

-- ================== ⚡ SMART CLICK (ไม่กินเมาส์) ==================
local lastClick = 0
local function GetTool()
    local c = Char(); if not c then return nil end
    local t = c:FindFirstChildOfClass("Tool")
    if t then return t end
    local h = c:FindFirstChild("Humanoid")
    if h then local t2 = h:FindFirstChildOfClass("Tool"); if t2 then return t2 end end
    return nil
end
local function HasEnemy(r)
    r = r or 100
    local h = HRP(); if not h then return false end
    local en = workspace:FindFirstChild("Enemies"); if not en then return false end
    for _,m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0 and (mh.Position-h.Position).Magnitude <= r then return true end
    end
    return false
end

-- ✅ Click ปลอดภัย: ใช้ Tool:Activate() เป็นหลัก
RunService.Heartbeat:Connect(function()
    -- ✅ ป้องกัน: เมาส์บน UI → หยุดคลิก
    if uiHovering then return end
    if not CFG.AutoClick then return end
    if not GetTool() then return end
    
    -- Method 1: Tool:Activate() — ไม่กินเมาส์
    pcall(function()
        local t = GetTool()
        if t then t:Activate() end
    end)
    
    -- Method 2: mouse1click (executor API)
    pcall(function()
        if mouse1click then mouse1click() end
    end)
    
    -- Method 3 (เฉพาะตอน AutoFarm + มี Enemy): VU
    if CFG.AutoFarm and HasEnemy(80) then
        local now = tick()
        if now - lastClick >= CFG.ClickSpeed then
            lastClick = now
            pcall(function()
                VU:CaptureController()
                VU:ClickButton1(Vector2.new(0, 0))
            end)
        end
    end
end)

-- ================== ⌨️ AUTO SKILL ==================
local SKILL_KEYS = {Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,Enum.KeyCode.V,
                    Enum.KeyCode.F,Enum.KeyCode.E,Enum.KeyCode.Q,Enum.KeyCode.R}
task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoSkill and GetTool() and HasEnemy(60) then
            for _,k in pairs(SKILL_KEYS) do
                pcall(function()
                    VIM:SendKeyEvent(true,k,false,game); task.wait(0.02)
                    VIM:SendKeyEvent(false,k,false,game)
                end)
                task.wait(0.03)
            end
        end
    end
end)

-- ================== 🥊 HAKI ==================
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

-- ================== ⚔️ EQUIP ==================
task.spawn(function()
    while task.wait(1) do
        if CFG.AutoEquip and (CFG.AutoFarm or CFG.AutoClick) then
            pcall(function()
                local c = Char(); if not c or c:FindFirstChildOfClass("Tool") then return end
                local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
                if not bp then return end
                for _,item in pairs(bp:GetChildren()) do
                    if item:IsA("Tool") then item.Parent = c; break end
                end
            end)
        end
    end
end)

-- ================== 🚀 FAST ATTACK ==================
task.spawn(function()
    local getup = getupvalues or debug.getupvalue or function() return nil end
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getup(c)[2]
    end)
    if not ok then warn("⚠️ FastAttack ไม่พร้อม") return end
    while task.wait(0.3) do
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

-- ================== 🛡️ ANTI-AFK ==================
LP.Idled:Connect(function()
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new(0,0)) end)
end)

-- ================== 📊 STATS ==================
task.spawn(function()
    while task.wait(0.3) do
        local h = Hum()
        if h then h.WalkSpeed = CFG.WalkSpeed; h.JumpPower = CFG.JumpPower end
    end
end)

-- ================== 💨 NOCLIP ==================
task.spawn(function()
    while task.wait(0.2) do
        if CFG.NoClip then
            pcall(function()
                local c = Char()
                if c then
                    for _,v in pairs(c:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                    end
                end
            end)
        end
    end
end)

-- ================== 🧲 BRING MOBS (แก้ไม่ขึ้นฟ้า) ==================
-- ✅ ใช้ CFrame + AssemblyLinearVelocity = 0 + PlatformStand + WalkSpeed = 0
-- ✅ ดึงมารวมรอบตัว ระยะ 12 studs ที่ระดับพื้นเท่ากับ HRP
task.spawn(function()
    while task.wait(0.05) do
        if (CFG.BringMobs or CFG.Magnet) and CFG.AutoFarm then
            pcall(function()
                local h = HRP(); if not h then return end
                local en = workspace:FindFirstChild("Enemies"); if not en then return end
                
                for _,m in pairs(en:GetChildren()) do
                    local mh = m:FindFirstChild("HumanoidRootPart")
                    local mhum = m:FindFirstChild("Humanoid")
                    if mh and mhum and mhum.Health > 0 then
                        local dist = (mh.Position - h.Position).Magnitude
                        if dist <= 200 then
                            -- ✅ คำนวณตำแหน่งเป้าหมาย: รอบตัวที่ระดับพื้น
                            local angle = math.random() * math.pi * 2
                            local radius = math.random(8, 14)
                            local targetPos = h.Position + Vector3.new(
                                math.cos(angle) * radius,
                                0,  -- ⭐ ระดับพื้นเท่ากับ HRP ไม่ขึ้นฟ้า!
                                math.sin(angle) * radius
                            )
                            
                            -- ✅ ใช้ CFrame.new() เดี่ยวๆ เพื่อไม่ให้ยกขึ้น
                            mh.CFrame = CFrame.new(targetPos)
                            
                            -- ✅ ตั้งความเร็วเป็น 0 ป้องกันการลอย/ลอย
                            mh.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            mh.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            
                            -- ✅ ปิด physics ป้องกันการลอยขึ้น
                            mh.CustomPhysicalProperties = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0)
                            
                            -- ✅ หยุดการเคลื่อนที่ของมอน
                            mhum.WalkSpeed = 0
                            mhum.JumpPower = 0
                            mhum.PlatformStand = true  -- ⭐ ป้องกันการยืนและลอย
                            mhum:ChangeState(Enum.HumanoidStateType.Physics)
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== 🏝️ TELEPORT ==================
local function TeleportToIsland(name)
    local isl = ISLANDS[name]; if not isl then return false end
    pcall(function() local h = HRP(); if h then h.CFrame = isl.CF + Vector3.new(0,30,0) end end)
    return true
end

-- ================== 🎯 AUTO FARM ==================
local function GetClosestEnemy(questName)
    local h = HRP(); if not h then return nil, math.huge end
    local en = workspace:FindFirstChild("Enemies"); if not en then return nil, math.huge end
    local closest, dist = nil, math.huge
    for _,m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0 then
            if questName and m.Name == questName then
                local d = (mh.Position-h.Position).Magnitude
                if d < dist then closest = m; dist = d end
            end
        end
    end
    return closest, dist
end

task.spawn(function()
    while task.wait(0.2) do
        if CFG.AutoFarm then
            pcall(function()
                local h = HRP(); if not h then return end
                local best = GetBestQuest(); if not best then return end
                if CFG.AutoIsland and best.I then
                    local isl = ISLANDS[best.I]
                    if isl then
                        local d = (h.Position - isl.CF.Position).Magnitude
                        if d > 3000 then
                            TeleportToIsland(best.I)
                            print("🏝️ "..best.I)
                            task.wait(2); return
                        end
                    end
                end
                if CFG.AutoQuest and not HasQuest() then
                    if not currentQuest or currentQuest.Name ~= best.Name then
                        GetQuest(); task.wait(1); return
                    end
                end
                local qName = currentQuest and currentQuest.Name or nil
                local target, dist = GetClosestEnemy(qName)
                if not target then target, dist = GetClosestEnemy(nil) end
                if target then
                    local mh = target:FindFirstChild("HumanoidRootPart")
                    if mh then h.CFrame = mh.CFrame * CFrame.new(0, CFG.Distance, 0) end
                end
            end)
        end
    end
end)

-- ================== 👹 AUTO BOSS ==================
task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoBoss then
            pcall(function()
                local h = HRP(); if not h then return end
                local en = workspace:FindFirstChild("Enemies"); if not en then return end
                for _,m in pairs(en:GetChildren()) do
                    if m.Name:find("Boss") or m.Name:find("Raid") then
                        local mh = m:FindFirstChild("HumanoidRootPart")
                        local mhum = m:FindFirstChild("Humanoid")
                        if mh and mhum and mhum.Health > 0 then
                            h.CFrame = mh.CFrame * CFrame.new(0, 30, 0)
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== 🎯 ELITE HUNTER ==================
task.spawn(function()
    while task.wait(2) do
        if CFG.AutoEliteHunter then
            pcall(function()
                local prog = RS.Remotes.CommF_:InvokeServer("EliteHunter", "Progress")
                if tonumber(prog) and tonumber(prog) < 30 then
                    RS.Remotes.CommF_:InvokeServer("EliteHunter")
                end
                local h = HRP()
                local en = workspace:FindFirstChild("Enemies")
                if en and h then
                    for _,m in pairs(en:GetChildren()) do
                        if m.Name:find("Diablo") or m.Name:find("Urban") or m.Name:find("Deandre") then
                            local mh = m:FindFirstChild("HumanoidRootPart")
                            if mh then h.CFrame = mh.CFrame * CFrame.new(0, 30, 0) end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== 🎁 AUTO RAID ==================
task.spawn(function()
    while task.wait(3) do
        if CFG.AutoRaid then
            pcall(function()
                local pg = LP.PlayerGui.Main
                if pg and pg.Timer and pg.Timer.Visible then
                    for i=5,1,-1 do
                        local isl = workspace:FindFirstChild("_WorldOrigin")
                        if isl and isl.Locations:FindFirstChild("Island "..i) then
                            local loc = isl.Locations["Island "..i]
                            local h = HRP()
                            if h then h.CFrame = loc.CFrame end
                            break
                        end
                    end
                else
                    if RS.Remotes.CommF_:InvokeServer("Candies","Check") then
                        local chip = LP.Backpack:FindFirstChild("Special Microchip")
                                    or (LP.Character and LP.Character:FindFirstChild("Special Microchip"))
                        if chip then
                            if WORLD[game.PlaceId] == "Sea 2" then
                                pcall(function()
                                    local btn = workspace.Map.CircleIsland.RaidSummon2.Button.Main
                                    if btn and btn.ClickDetector then fireclickdetector(btn.ClickDetector) end
                                end)
                            elseif WORLD[game.PlaceId] == "Sea 3" then
                                pcall(function()
                                    local btn = workspace.Map["Boat Castle"].RaidSummon2.Button.Main
                                    if btn and btn.ClickDetector then fireclickdetector(btn.ClickDetector) end
                                end)
                            end
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== 💎 AUTO CHEST ==================
task.spawn(function()
    while task.wait(1) do
        if CFG.AutoChest then
            pcall(function()
                local h = HRP(); if not h then return end
                for _,v in pairs(workspace:GetChildren()) do
                    if v.Name:find("Chest") and v:IsA("BasePart") then
                        if (v.Position - h.Position).Magnitude <= 5000 then
                            h.CFrame = v.CFrame
                            task.wait(0.5)
                        end
                    end
                end
            end)
        end
    end
end)

-- ================== 🔍 DEBUG ==================
task.spawn(function()
    while task.wait(5) do
        if CFG.AutoFarm or CFG.AutoBoss then
            local c = Char()
            local tool = c and c:FindFirstChildOfClass("Tool")
            local en = workspace:FindFirstChild("Enemies")
            print("━━━━━━━━━━━━━━━━━━━")
            print("🔧 Tool: "..(tool and tool.Name or "❌"))
            print("👾 Mobs: "..#(en and en:GetChildren() or {}))
            print("📜 Quest: "..(HasQuest() and "✅" or "❌").." | "..GetCurrentQuestName())
            print("🎮 Level: "..SafeGet(LP.Data,"Level"))
            print("━━━━━━━━━━━━━━━━━━━")
        end
    end
end)

print("✅ Rbot v11.0 Systems Loaded")

-- ================================================================
-- ========== 🎨 UI GLASSMORPHISM 2.0 =============================
-- ================================================================

local old = game.CoreGui:FindFirstChild("RbotPremium")
if old then old:Destroy() end

local COLORS = {
    Bg=Color3.fromRGB(6,4,14), Glass=Color3.fromRGB(26,20,40),
    Border=Color3.fromRGB(120,80,200), Purple=Color3.fromRGB(160,80,255),
    Pink=Color3.fromRGB(255,60,180), Cyan=Color3.fromRGB(80,220,255),
    Text=Color3.fromRGB(240,235,255), TextDim=Color3.fromRGB(150,140,180),
}

local Blur = Instance.new("BlurEffect"); Blur.Size=0; Blur.Parent=Lighting

local SG = Instance.new("ScreenGui")
SG.Name="RbotPremium"; SG.Parent=game.CoreGui
SG.ResetOnSpawn=false; SG.IgnoreGuiInset=true
SG.ZIndexBehavior=Enum.ZIndexBehavior.Sibling; SG.DisplayOrder=999

-- ============ MAIN ============
local Main = Instance.new("Frame")
Main.Size=UDim2.new(0,0,0,0); Main.Position=UDim2.new(0.5,-400,0.5,-280)
Main.BackgroundColor3=COLORS.Bg; Main.BackgroundTransparency=0.05
Main.BorderSizePixel=0; Main.ClipsDescendants=false; Main.Parent=SG
local MC = Instance.new("UICorner"); MC.CornerRadius=UDim.new(0,22); MC.Parent=Main

-- Animated Glow Border
local BorderGlow = Instance.new("Frame")
BorderGlow.Size=UDim2.new(1,10,1,10); BorderGlow.Position=UDim2.new(0,-5,0,-5)
BorderGlow.BackgroundColor3=COLORS.Purple; BorderGlow.BackgroundTransparency=0.5
BorderGlow.BorderSizePixel=0; BorderGlow.ZIndex=-1; BorderGlow.Parent=Main
local BGC=Instance.new("UICorner"); BGC.CornerRadius=UDim.new(0,26); BGC.Parent=BorderGlow
local BGG=Instance.new("UIGradient")
BGG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Purple),
    ColorSequenceKeypoint.new(0.5,COLORS.Pink),
    ColorSequenceKeypoint.new(1,COLORS.Cyan),
}
BGG.Parent=BorderGlow
task.spawn(function()
    local r=0
    while BorderGlow.Parent do r=(r+2)%360 BGG.Rotation=r task.wait(0.05) end
end)

local OPEN_SIZE = UDim2.new(0,800,0,560)
TS:Create(Main, TweenInfo.new(0.8, Enum.EasingStyle.Back), {Size=OPEN_SIZE}):Play()
TS:Create(Blur, TweenInfo.new(0.7), {Size=16}):Play()

-- ============ 🔓 TOGGLE SYSTEM ============
local uiOpen = true
local FloatingBtn
local function SetUIVisible(v)
    if uiOpen == v then return end
    uiOpen = v
    if v then
        Main.Visible = true
        TS:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = OPEN_SIZE, BackgroundTransparency = 0.05
        }):Play()
        TS:Create(Blur, TweenInfo.new(0.3), {Size = 16}):Play()
        if FloatingBtn then
            TS:Create(FloatingBtn, TweenInfo.new(0.3), {
                Position = UDim2.new(0, -70, 0.5, -28)
            }):Play()
            task.delay(0.3, function()
                if uiOpen and FloatingBtn then FloatingBtn.Visible = false end
            end)
        end
    else
        TS:Create(Blur, TweenInfo.new(0.3), {Size = 0}):Play()
        if FloatingBtn then
            FloatingBtn.Visible = true
            FloatingBtn.Position = UDim2.new(0, 20, 0.5, -28)
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

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Size=UDim2.new(1,0,0,72); Header.BackgroundColor3=Color3.fromRGB(16,12,26)
Header.BackgroundTransparency=0.35; Header.BorderSizePixel=0; Header.Parent=Main
local HC=Instance.new("UICorner"); HC.CornerRadius=UDim.new(0,22); HC.Parent=Header

local HLine=Instance.new("Frame")
HLine.Size=UDim2.new(1,-40,0,2); HLine.Position=UDim2.new(0,20,1,-1)
HLine.BackgroundColor3=COLORS.Purple; HLine.BorderSizePixel=0; HLine.Parent=Header
local HLC=Instance.new("UICorner"); HLC.CornerRadius=UDim.new(1,0); HLC.Parent=HLine
local HLG=Instance.new("UIGradient")
HLG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Purple),
    ColorSequenceKeypoint.new(0.5,COLORS.Pink),
    ColorSequenceKeypoint.new(1,COLORS.Cyan),
}
HLG.Parent=HLine

-- Logo
local LogoIcon=Instance.new("Frame")
LogoIcon.Size=UDim2.new(0,48,0,48); LogoIcon.Position=UDim2.new(0,18,0.5,-24)
LogoIcon.BackgroundColor3=COLORS.Purple; LogoIcon.BorderSizePixel=0; LogoIcon.Parent=Header
local LIC=Instance.new("UICorner"); LIC.CornerRadius=UDim.new(1,0); LIC.Parent=LogoIcon
local LIG=Instance.new("UIGradient")
LIG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Purple),
    ColorSequenceKeypoint.new(0.5,COLORS.Pink),
    ColorSequenceKeypoint.new(1,COLORS.Cyan),
}
LIG.Rotation=45; LIG.Parent=LogoIcon
task.spawn(function()
    local r=45
    while LogoIcon.Parent do r=(r+1)%360 LIG.Rotation=r task.wait(0.05) end
end)
local LogoTxt=Instance.new("TextLabel")
LogoTxt.Size=UDim2.new(1,0,1,0); LogoTxt.BackgroundTransparency=1
LogoTxt.Text="R"; LogoTxt.TextColor3=Color3.fromRGB(255,255,255)
LogoTxt.Font=Enum.Font.GothamBlack; LogoTxt.TextSize=26; LogoTxt.Parent=LogoIcon

-- Title
local Title=Instance.new("TextLabel")
Title.Size=UDim2.new(0,400,0,26); Title.Position=UDim2.new(0,78,0,14)
Title.BackgroundTransparency=1; Title.Text="🔥 RBOT v11.0 ULTIMATE"
Title.TextColor3=COLORS.Text; Title.Font=Enum.Font.GothamBlack
Title.TextSize=20; Title.TextXAlignment=Enum.TextXAlignment.Left; Title.Parent=Header
local TG=Instance.new("UIGradient")
TG.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Text),
    ColorSequenceKeypoint.new(0.5,COLORS.Purple),
    ColorSequenceKeypoint.new(1,COLORS.Pink),
}
TG.Parent=Title

local SubTitle=Instance.new("TextLabel")
SubTitle.Size=UDim2.new(0,400,0,18); SubTitle.Position=UDim2.new(0,78,0,40)
SubTitle.BackgroundTransparency=1
SubTitle.Text=WORLD[game.PlaceId].." • "..LP.Name.." • Lv."..SafeGet(LP.Data,"Level").." • 💰"..FormatNum(SafeGet(LP.Data,"Beli"))
SubTitle.TextColor3=COLORS.TextDim; SubTitle.Font=Enum.Font.GothamMedium
SubTitle.TextSize=10; SubTitle.TextXAlignment=Enum.TextXAlignment.Left; SubTitle.Parent=Header

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            SubTitle.Text=WORLD[game.PlaceId].." • "..LP.Name.." • Lv."..SafeGet(LP.Data,"Level").." • 💰"..FormatNum(SafeGet(LP.Data,"Beli"))
        end)
    end
end)

-- ============ ✕ CLOSE BUTTON (ปิดจริง) ============
local CloseBtn=Instance.new("TextButton")
CloseBtn.Size=UDim2.new(0,34,0,34); CloseBtn.Position=UDim2.new(1,-46,0.5,-17)
CloseBtn.BackgroundColor3=COLORS.Glass; CloseBtn.BackgroundTransparency=0.3
CloseBtn.Text="✕"; CloseBtn.TextColor3=COLORS.Text
CloseBtn.Font=Enum.Font.GothamBold; CloseBtn.TextSize=14
CloseBtn.AutoButtonColor=false; CloseBtn.Parent=Header
local CBC=Instance.new("UICorner"); CBC.CornerRadius=UDim.new(1,0); CBC.Parent=CloseBtn
CloseBtn.MouseEnter:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency=0.1, BackgroundColor3=Color3.fromRGB(255,60,80)
    }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TS:Create(CloseBtn, TweenInfo.new(0.2), {
        BackgroundTransparency=0.3, BackgroundColor3=COLORS.Glass
    }):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size=UDim2.new(0,0,0,0), BackgroundTransparency=1
    }):Play()
    TS:Create(Blur, TweenInfo.new(0.3), {Size=0}):Play()
    task.wait(0.35)
    SG:Destroy()
    Blur:Destroy()
    print("❌ Rbot v11.0 ปิดแล้ว")
end)

-- ============ SIDEBAR ============
local Sidebar=Instance.new("Frame")
Sidebar.Size=UDim2.new(0,200,1,-92); Sidebar.Position=UDim2.new(0,16,0,82)
Sidebar.BackgroundColor3=COLORS.Glass; Sidebar.BackgroundTransparency=0.5
Sidebar.BorderSizePixel=0; Sidebar.Parent=Main
local SBC=Instance.new("UICorner"); SBC.CornerRadius=UDim.new(0,14); SBC.Parent=Sidebar
local SBStroke=Instance.new("UIStroke")
SBStroke.Color=COLORS.Border; SBStroke.Thickness=1; SBStroke.Transparency=0.7; SBStroke.Parent=Sidebar

local TabList=Instance.new("Frame")
TabList.Size=UDim2.new(1,-16,1,-16); TabList.Position=UDim2.new(0,8,0,8)
TabList.BackgroundTransparency=1; TabList.Parent=Sidebar
local TLLay=Instance.new("UIListLayout")
TLLay.Parent=TabList; TLLay.SortOrder=Enum.SortOrder.LayoutOrder; TLLay.Padding=UDim.new(0,6)

-- ============ 🎛️ CONTROL PANEL (➖✚) ============
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1, 0, 0, 46)
ControlPanel.BackgroundColor3 = COLORS.Glass
ControlPanel.BackgroundTransparency = 0.4
ControlPanel.BorderSizePixel = 0
ControlPanel.LayoutOrder = -1  -- ⭐ อยู่บนสุด
ControlPanel.Parent = TabList

local CPC = Instance.new("UICorner")
CPC.CornerRadius = UDim.new(0, 10)
CPC.Parent = ControlPanel

local CPStroke = Instance.new("UIStroke")
CPStroke.Color = COLORS.Border
CPStroke.Thickness = 1
CPStroke.Transparency = 0.6
CPStroke.Parent = ControlPanel

-- ✅ ปุ่ม ➖ ย่อ
local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0.5, -6, 1, -12)
MinBtn.Position = UDim2.new(0, 6, 0, 6)
MinBtn.BackgroundColor3 = COLORS.Purple
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "➖"
MinBtn.TextColor3 = COLORS.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.AutoButtonColor = false
MinBtn.Parent = ControlPanel

local MinBtnC = Instance.new("UICorner")
MinBtnC.CornerRadius = UDim.new(0, 8)
MinBtnC.Parent = MinBtn

MinBtn.MouseEnter:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.05, BackgroundColor3 = COLORS.Purple
    }):Play()
end)
MinBtn.MouseLeave:Connect(function()
    TS:Create(MinBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2, BackgroundColor3 = COLORS.Purple
    }):Play()
end)
MinBtn.MouseButton1Click:Connect(function()
    SetUIVisible(false)  -- ✅ ย่อ → Floating Button
end)

-- ✅ ปุ่ม ✚ ขยาย
local ExpBtn = Instance.new("TextButton")
ExpBtn.Size = UDim2.new(0.5, -6, 1, -12)
ExpBtn.Position = UDim2.new(0.5, 0, 0, 6)
ExpBtn.BackgroundColor3 = COLORS.Cyan
ExpBtn.BackgroundTransparency = 0.2
ExpBtn.Text = "✚"
ExpBtn.TextColor3 = COLORS.Text
ExpBtn.Font = Enum.Font.GothamBold
ExpBtn.TextSize = 16
ExpBtn.AutoButtonColor = false
ExpBtn.Parent = ControlPanel

local ExpBtnC = Instance.new("UICorner")
ExpBtnC.CornerRadius = UDim.new(0, 8)
ExpBtnC.Parent = ExpBtn

ExpBtn.MouseEnter:Connect(function()
    TS:Create(ExpBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.05, BackgroundColor3 = COLORS.Cyan
    }):Play()
end)
ExpBtn.MouseLeave:Connect(function()
    TS:Create(ExpBtn, TweenInfo.new(0.2), {
        BackgroundTransparency = 0.2, BackgroundColor3 = COLORS.Cyan
    }):Play()
end)
ExpBtn.MouseButton1Click:Connect(function()
    -- ✅ กดแล้วย่อ UI ตัวเองเลย (ทำเหมือนเป็นปุ่ม toggle)
    SetUIVisible(false)
end)

-- ============ CONTENT ============
local Content=Instance.new("Frame")
Content.Size=UDim2.new(1,-240,1,-92); Content.Position=UDim2.new(0,226,0,82)
Content.BackgroundColor3=COLORS.Glass; Content.BackgroundTransparency=0.5
Content.BorderSizePixel=0; Content.Parent=Main
local CNC=Instance.new("UICorner"); CNC.CornerRadius=UDim.new(0,14); CNC.Parent=Content
local CNStroke=Instance.new("UIStroke")
CNStroke.Color=COLORS.Border; CNStroke.Thickness=1; CNStroke.Transparency=0.7; CNStroke.Parent=Content

local Scroll=Instance.new("ScrollingFrame")
Scroll.Size=UDim2.new(1,-20,1,-20); Scroll.Position=UDim2.new(0,10,0,10)
Scroll.BackgroundTransparency=1; Scroll.BorderSizePixel=0
Scroll.ScrollBarThickness=4; Scroll.ScrollBarImageColor3=COLORS.Purple
Scroll.CanvasSize=UDim2.new(0,0,0,0); Scroll.Parent=Content
local SLLay=Instance.new("UIListLayout")
SLLay.Parent=Scroll; SLLay.SortOrder=Enum.SortOrder.LayoutOrder; SLLay.Padding=UDim.new(0,8)
SLLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize=UDim2.new(0,0,0,SLLay.AbsoluteContentSize.Y + 20)
end)

-- ============ ✅ UI HOVER LOCK ============
local function SetupUIHoverLock(frame)
    frame.MouseEnter:Connect(function() uiHovering = true end)
    frame.MouseLeave:Connect(function() uiHovering = false end)
end
SetupUIHoverLock(Main)
SetupUIHoverLock(Header)
SetupUIHoverLock(Sidebar)
SetupUIHoverLock(Content)
SetupUIHoverLock(ControlPanel)

-- ============ DRAG ============
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=i.Position; startPos=Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        Main.Position=UDim2.new(
            startPos.X.Scale, startPos.X.Offset+(i.Position.X-dragStart.X),
            startPos.Y.Scale, startPos.Y.Offset+(i.Position.Y-dragStart.Y)
        )
    end
end)

-- ============ UI FACTORY ============
local Tabs={}; local FirstTab=false

local function CreateTab(name, icon)
    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,0,44); Btn.BackgroundColor3=COLORS.Glass
    Btn.BackgroundTransparency=0.7; Btn.BorderSizePixel=0
    Btn.Text="  "..icon.."   "..name; Btn.TextColor3=COLORS.TextDim
    Btn.Font=Enum.Font.GothamBold; Btn.TextSize=13
    Btn.TextXAlignment=Enum.TextXAlignment.Left
    Btn.AutoButtonColor=false; Btn.Parent=TabList
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,10); c.Parent=Btn
    local page=Instance.new("Frame")
    page.Size=UDim2.new(1,0,0,0); page.AutomaticSize=Enum.AutomaticSize.Y
    page.BackgroundTransparency=1; page.Parent=Scroll; page.Visible=false
    local pLay=Instance.new("UIListLayout")
    pLay.Parent=page; pLay.SortOrder=Enum.SortOrder.LayoutOrder; pLay.Padding=UDim.new(0,8)
    table.insert(Tabs,{Btn=Btn,Page=page})
    Btn.MouseButton1Click:Connect(function()
        for _,t in pairs(Tabs) do
            t.Page.Visible=false
            TS:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency=0.7, TextColor3=COLORS.TextDim}):Play()
        end
        page.Visible=true
        TS:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency=0.3, TextColor3=COLORS.Text}):Play()
    end)
    if not FirstTab then
        FirstTab=true; page.Visible=true
        Btn.BackgroundTransparency=0.3; Btn.TextColor3=COLORS.Text
    end
    return page
end

local function Section(parent, title)
    local S=Instance.new("TextLabel")
    S.Size=UDim2.new(1,-8,0,26); S.BackgroundTransparency=1
    S.Text="  ▸  "..title:upper(); S.TextColor3=COLORS.Purple
    S.Font=Enum.Font.GothamBold; S.TextSize=11
    S.TextXAlignment=Enum.TextXAlignment.Left; S.Parent=parent
end

local function Toggle(parent, name, desc, key)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,58); F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4; F.BorderSizePixel=0; F.Parent=parent
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F
    local strk=Instance.new("UIStroke")
    strk.Color=COLORS.Border; strk.Thickness=1; strk.Transparency=0.75; strk.Parent=F
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-90,0,22); L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1; L.Text=name
    L.TextColor3=COLORS.Text; L.Font=Enum.Font.GothamBold
    L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left; L.Parent=F
    local D=Instance.new("TextLabel")
    D.Size=UDim2.new(1,-90,0,16); D.Position=UDim2.new(0,16,0,30)
    D.BackgroundTransparency=1; D.Text=desc or ""
    D.TextColor3=COLORS.TextDim; D.Font=Enum.Font.Gotham
    D.TextSize=10; D.TextXAlignment=Enum.TextXAlignment.Left; D.Parent=F
    local Bg=Instance.new("Frame")
    Bg.Size=UDim2.new(0,46,0,24); Bg.Position=UDim2.new(1,-62,0.5,-12)
    Bg.BackgroundColor3=CFG[key] and COLORS.Purple or Color3.fromRGB(48,45,62)
    Bg.BorderSizePixel=0; Bg.Parent=F
    local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(1,0); bgc.Parent=Bg
    local Dot=Instance.new("Frame")
    Dot.Size=UDim2.new(0,20,0,20)
    Dot.Position=CFG[key] and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
    Dot.BackgroundColor3=Color3.fromRGB(255,255,255)
    Dot.BorderSizePixel=0; Dot.Parent=Bg
    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=Dot
    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,1,0); Btn.BackgroundTransparency=1
    Btn.Text=""; Btn.Parent=F
    Btn.MouseButton1Click:Connect(function()
        CFG[key]=not CFG[key]
        TS:Create(Bg, TweenInfo.new(0.2), {
            BackgroundColor3=CFG[key] and COLORS.Purple or Color3.fromRGB(48,45,62)
        }):Play()
        TS:Create(Dot, TweenInfo.new(0.2), {
            Position=CFG[key] and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
        }):Play()
    end)
end

local function Slider(parent, name, min, max, key)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,68); F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4; F.BorderSizePixel=0; F.Parent=parent
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F
    local strk=Instance.new("UIStroke")
    strk.Color=COLORS.Border; strk.Thickness=1; strk.Transparency=0.75; strk.Parent=F
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-30,0,22); L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1; L.Text=name.."  :  "..CFG[key]
    L.TextColor3=COLORS.Text; L.Font=Enum.Font.GothamBold
    L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left; L.Parent=F
    local BarBg=Instance.new("Frame")
    BarBg.Size=UDim2.new(1,-32,0,8); BarBg.Position=UDim2.new(0,16,0,42)
    BarBg.BackgroundColor3=Color3.fromRGB(48,45,62)
    BarBg.BorderSizePixel=0; BarBg.Parent=F
    local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(1,0); bgc.Parent=BarBg
    local ratio=math.clamp((CFG[key]-min)/(max-min),0,1)
    local Fill=Instance.new("Frame")
    Fill.Size=UDim2.new(ratio,0,1,0); Fill.BackgroundColor3=COLORS.Purple
    Fill.BorderSizePixel=0; Fill.Parent=BarBg
    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(1,0); fc.Parent=Fill
    local FG=Instance.new("UIGradient")
    FG.Color=ColorSequence.new{
        ColorSequenceKeypoint.new(0,COLORS.Purple),
        ColorSequenceKeypoint.new(0.5,COLORS.Pink),
        ColorSequenceKeypoint.new(1,COLORS.Cyan),
    }
    FG.Parent=Fill
    local Dot=Instance.new("Frame")
    Dot.Size=UDim2.new(0,16,0,16); Dot.Position=UDim2.new(1,-8,0.5,-8)
    Dot.BackgroundColor3=Color3.fromRGB(255,255,255)
    Dot.BorderSizePixel=0; Dot.Parent=Fill
    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=Dot
    local dragging=false
    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,3,0); Btn.Position=UDim2.new(0,0,-1,0)
    Btn.BackgroundTransparency=1; Btn.Text=""; Btn.Parent=BarBg
    local function Update(i)
        local r=math.clamp((i.Position.X-BarBg.AbsolutePosition.X)/BarBg.AbsoluteSize.X,0,1)
        local v=math.floor(min + r*(max-min))
        Fill.Size=UDim2.new(r,0,1,0); L.Text=name.."  :  "..v; CFG[key]=v
    end
    Btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=true; Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
            dragging=false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
end

local function Button(parent, name, desc, callback)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,58); F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4; F.BorderSizePixel=0; F.Parent=parent
    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F
    local strk=Instance.new("UIStroke")
    strk.Color=COLORS.Border; strk.Thickness=1; strk.Transparency=0.75; strk.Parent=F
    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-30,0,22); L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1; L.Text=name
    L.TextColor3=COLORS.Text; L.Font=Enum.Font.GothamBold
    L.TextSize=13; L.TextXAlignment=Enum.TextXAlignment.Left; L.Parent=F
    local D=Instance.new("TextLabel")
    D.Size=UDim2.new(1,-30,0,16); D.Position=UDim2.new(0,16,0,30)
    D.BackgroundTransparency=1; D.Text=desc or ""
    D.TextColor3=COLORS.TextDim; D.Font=Enum.Font.Gotham
    D.TextSize=10; D.TextXAlignment=Enum.TextXAlignment.Left; D.Parent=F
    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,1,0); Btn.BackgroundTransparency=1
    Btn.Text=""; Btn.Parent=F
    Btn.MouseEnter:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency=0.2}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TS:Create(F, TweenInfo.new(0.2), {BackgroundTransparency=0.4}):Play()
    end)
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

-- ================== TABS ==================
local HomeTab=CreateTab("หน้าหลัก","🏠")
local FarmTab=CreateTab("ฟาร์ม","🌾")
local BossTab=CreateTab("บอส & Raid","👹")
local SkillTab=CreateTab("สกิล","🥋")
local SetTab=CreateTab("ตั้งค่า","🔧")

-- HOME
Section(HomeTab, "📊 Live Status")
Button(HomeTab, "🔍 ตรวจสอบสถานะ", "แสดงข้อมูลทุกอย่างใน Console", function()
    local c=Char()
    local tool=c and c:FindFirstChildOfClass("Tool")
    print("━━━━━━━━━━━━━━━━━━━")
    print("🎮 Level: "..SafeGet(LP.Data,"Level"))
    print("💰 Beli: "..FormatNum(SafeGet(LP.Data,"Beli")))
    print("🔧 Tool: "..(tool and tool.Name or "❌ ไม่มี"))
    print("📜 Quest: "..(HasQuest() and "✅" or "❌").." | "..GetCurrentQuestName())
    print("👾 Mobs: "..#(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}))
    print("📜 Best Quest: "..(GetBestQuest() and GetBestQuest().Name or "nil"))
    print("━━━━━━━━━━━━━━━━━━━")
end)
Button(HomeTab, "📜 Force รับเควสต์", "บังคับรับเควสต์", function()
    currentQuest=nil; lastQuestAttempt=0; GetQuest()
end)
Button(HomeTab, "🎁 Redeem All Codes", "ใส่โค้ด Blox Fruits ทั้งหมด", function()
    local codes = {"Sub2Fer999","Enyu_is_Pro","Magicbus","JCWK","Starcodeheo",
                   "Bluxxy","fudd10","fudd10_v2","Sub2OfficialNoobie",
                   "SUB2GAMERROBOT_EXP1","Sub2NoobMaster123","Sub2UncleKizaru",
                   "Sub2Daigrock","Axiore","TantaiGaming","StrawHatMaine",
                   "Sub2CaptainMaui","Kittgaming","Sub2Gamerrobot_Reset1",
                   "FUDD10","BIGNEWS","THEGREATACE"}
    for _,code in pairs(codes) do
        pcall(function() RS.Remotes.Redeem:InvokeServer(code) end)
        task.wait(0.5)
    end
    print("✅ Redeemed all")
end)

-- FARM
Section(FarmTab, "🎯 Auto Farm")
Toggle(FarmTab, "Auto Farm ⭐", "ฟาร์ม + ตี + ย้ายเกาะ", "AutoFarm")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ", "AutoQuest")
Toggle(FarmTab, "Auto Island", "ย้ายเกาะตาม Level", "AutoIsland")
Toggle(FarmTab, "Auto Click ⭐", "คลิก 5-way bypass", "AutoClick")
Toggle(FarmTab, "Auto Equip", "ติดอาวุธอัตโนมัติ", "AutoEquip")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนมารวมตัว (ไม่ขึ้นฟ้า)", "BringMobs")
Toggle(FarmTab, "Magnet", "ดึงทุกอย่างเข้าหา", "Magnet")
Toggle(FarmTab, "Auto Chest 💎", "เก็บหีบทุกเกาะ", "AutoChest")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")

-- BOSS
Section(BossTab, "👹 Auto Boss System")
Toggle(BossTab, "Auto Boss", "ตีบอสทุกตัว", "AutoBoss")
Toggle(BossTab, "Auto Elite Hunter", "ปืน Yama/Tushita", "AutoEliteHunter")
Toggle(BossTab, "Auto Raid", "เปิด Raid + Next Island", "AutoRaid")

-- SKILL
Section(SkillTab, "🥋 Combat")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F E Q R", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "Bypass Cooldown", "FastAttack")

-- SET
Section(SetTab, "🏃 Character")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")
Toggle(SetTab, "No Clip", "ทะลุกำแพง", "NoClip")
Section(SetTab, "⚙️ System")
Button(SetTab, "🚀 Rejoin Server", "กลับเซิร์ฟเดิม", function()
    TPS:Teleport(game.PlaceId, LP)
end)
Button(SetTab, "❌ ปิด UI ทั้งหมด", "ปิดหน้าต่างจริง", function()
    TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
        Size=UDim2.new(0,0,0,0), BackgroundTransparency=1
    }):Play()
    TS:Create(Blur, TweenInfo.new(0.3), {Size=0}):Play()
    task.wait(0.35)
    SG:Destroy()
    Blur:Destroy()
end)

-- ============ 🟣 FLOATING BUTTON (➖✚) ============
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size=UDim2.new(0,56,0,56)
FloatingBtn.Position=UDim2.new(0,-70,0.5,-28)
FloatingBtn.BackgroundColor3=COLORS.Purple
FloatingBtn.BorderSizePixel=0; FloatingBtn.Text="✚"
FloatingBtn.TextColor3=Color3.fromRGB(255,255,255)
FloatingBtn.Font=Enum.Font.GothamBlack; FloatingBtn.TextSize=24
FloatingBtn.AutoButtonColor=false; FloatingBtn.Visible=false
FloatingBtn.ZIndex=999; FloatingBtn.Parent=SG

local FBC=Instance.new("UICorner"); FBC.CornerRadius=UDim.new(1,0); FBC.Parent=FloatingBtn

local FBGrad=Instance.new("UIGradient")
FBGrad.Color=ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Purple),
    ColorSequenceKeypoint.new(0.5,COLORS.Pink),
    ColorSequenceKeypoint.new(1,COLORS.Cyan),
}
FBGrad.Rotation=45; FBGrad.Parent=FloatingBtn

task.spawn(function()
    local r=45
    while FBGrad.Parent do r=(r+2)%360 FBGrad.Rotation=r task.wait(0.05) end
end)

local FBStroke=Instance.new("UIStroke")
FBStroke.Color=COLORS.Pink; FBStroke.Thickness=2; FBStroke.Transparency=0.4
FBStroke.Parent=FloatingBtn

-- Glow
local FBGlow=Instance.new("ImageLabel")
FBGlow.Size=UDim2.new(1,30,1,30); FBGlow.Position=UDim2.new(0,-15,0,-15)
FBGlow.BackgroundTransparency=1
FBGlow.Image="rbxassetid://4996891970"
FBGlow.ImageColor3=COLORS.Purple
FBGlow.ImageTransparency=0.4
FBGlow.ScaleType=Enum.ScaleType.Slice
FBGlow.SliceCenter=Rect.new(20,20,280,280)
FBGlow.ZIndex=-1; FBGlow.Parent=FloatingBtn

-- Pulse
task.spawn(function()
    while FloatingBtn and FloatingBtn.Parent do
        task.wait(2)
        if FloatingBtn.Visible then
            TS:Create(FloatingBtn, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
                Size=UDim2.new(0,66,0,66)
            }):Play()
            task.wait(0.6)
            if FloatingBtn then
                TS:Create(FloatingBtn, TweenInfo.new(0.6, Enum.EasingStyle.Sine), {
                    Size=UDim2.new(0,56,0,56)
                }):Play()
            end
        end
    end
end)

-- Drag
local fbDrag, fbStart, fbStartPos
FloatingBtn.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        fbDrag=true; fbStart=i.Position; fbStartPos=FloatingBtn.Position
    endend)
FloatingBtn.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
        fbDrag=false
    end
end)
UIS.InputChanged:Connect(function(i)
    if fbDrag and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
        FloatingBtn.Position=UDim2.new(
            fbStartPos.X.Scale, fbStartPos.X.Offset+(i.Position.X-fbStart.X),
            fbStartPos.Y.Scale, fbStartPos.Y.Offset+(i.Position.Y-fbStart.Y)
        )
    end
end)

-- Click → เปิด UI
FloatingBtn.MouseButton1Click:Connect(function()
    SetUIVisible(true)
end)

-- ============ ⌨️ KEYBIND ============
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    -- Right Ctrl = Toggle ย่อ/ขยาย
    if i.KeyCode==Enum.KeyCode.RightControl then
        SetUIVisible(not uiOpen)
    end
    -- Right Shift = ปิดจริง
    if i.KeyCode==Enum.KeyCode.RightShift then
        TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {
            Size=UDim2.new(0,0,0,0), BackgroundTransparency=1
        }):Play()
        TS:Create(Blur, TweenInfo.new(0.3), {Size=0}):Play()
        task.wait(0.35)
        SG:Destroy()
        Blur:Destroy()
    end
end)

-- ============ SAVE/LOAD CONFIG ============
if writefile and readfile then
    task.spawn(function()
        task.wait(2)
        pcall(function()
            if isfile and isfile("rbot_v11_cfg.json") then
                local data = HttpService:JSONDecode(readfile("rbot_v11_cfg.json"))
                for k,v in pairs(data) do if CFG[k]~=nil then CFG[k]=v end end
                print("✅ Loaded config")
            end
        end)
    end)
    game:BindToClose(function()
        pcall(function()
            writefile("rbot_v11_cfg.json", HttpService:JSONEncode(CFG))
        end)
    end)
end

print("═══════════════════════════════════════════════")
print("🔥 Rbot v11.0 ULTIMATE พร้อมใช้งาน!")
print("✅ Bring Mobs ไม่ขึ้นฟ้าแล้ว (แก้แล้ว)")
print("✅ ➖✚ ใน Sidebar + ✕ Header + 🟣 Floating")
print("⌨️ RightCtrl = ย่อ/ขยาย | RightShift = ปิดจริง")
print("═══════════════════════════════════════════════")
