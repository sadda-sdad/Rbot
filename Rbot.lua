--[[
    🔥 RBOT v13.1 - FINAL FIX
    ✅ แก้ Infinite Yield (CombatFramework timeout)
    ✅ แก้ Islands count
    ✅ UI ขึ้น 100%
    ✅ คลิกในเกมเท่านั้น
]]

print("━━━━━━━━━━━━━━━━━━━━━━━━━")
print("🔥 RBOT v13.1 FINAL เริ่ม...")
print("Executor:", identifyexecutor and identifyexecutor() or "unknown")
print("━━━━━━━━━━━━━━━━━━━━━━━━━")

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

print("✅ Services OK")

-- ================== CLEANUP ==================
pcall(function()
    local cg = game:GetService("CoreGui")
    for _, n in ipairs({"RbotPremium","RbotPremium_Floating"}) do
        local o = cg:FindFirstChild(n)
        if o then o:Destroy() end
    end
end)
pcall(function()
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then
        for _, n in ipairs({"RbotPremium","RbotPremium_Floating"}) do
            local o = pg:FindFirstChild(n)
            if o then o:Destroy() end
        end
    end
end)
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BlurEffect") and v.Name == "RbotBlur" then v:Destroy() end
end
print("✅ Cleanup OK")

-- ================== CHECK GAME ==================
local WORLD = {
    [2753915549]="Sea 1",[4442272183]="Sea 2",
    [7449423635]="Sea 3",[155615604]="Sea 4",
}
if not WORLD[game.PlaceId] then warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!") return end
print("🌊 " .. WORLD[game.PlaceId])

-- ================== UTILS ==================
local function CountTable(t)
    local n = 0
    for _ in pairs(t) do n = n + 1 end
    return n
end

-- ================== CONFIG ==================
local CFG = {
    AutoFarm=false, AutoQuest=true, AutoIsland=true, AutoClick=true,
    AutoSkill=true, AutoHaki=true, AutoEquip=true,
    FastAttack=true, BringMobs=true, Magnet=false,
    AutoBoss=false, AutoEliteHunter=false, AutoRaid=false, AutoChest=false,
    NoClip=false, WalkSpeed=16, JumpPower=50, Distance=30,
    ClickSpeed=0.01,
}
local uiHovering = false
print("✅ Config OK")

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

-- ================== ISLANDS ==================
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
print("✅ Islands ("..CountTable(ISLANDS)..")")

-- ================== QUESTS ==================
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
print("✅ Quests ("..#QUESTS..")")

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

-- ================== QUEST SYSTEM ==================
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
    print("📜 "..best.Name.." (Lv."..best.Level..")")
    return true
end
print("✅ Quest System OK")

-- ================== COMBAT FRAMEWORK (ค้นหาหลายตำแหน่ง + fallback) ==================
local CombatF = nil
local CombatFrameworkModule = nil

-- ค้นหาเฉพาะ ModuleScript ที่ชื่อ CombatFramework ในตำแหน่งที่ client มองเห็นได้
local function FindCombatFramework(timeout)
    timeout = timeout or 45
    local deadline = os.clock() + timeout
    local containers = {}
    local function rebuildContainers()
        containers = {}
        local ps = LP:FindFirstChild("PlayerScripts")
        if ps then table.insert(containers, ps) end
        for _, serviceName in ipairs({"ReplicatedStorage", "ReplicatedFirst", "StarterPlayer"}) do
            local ok, service = pcall(function() return game:GetService(serviceName) end)
            if ok and service then table.insert(containers, service) end
        end
    end
    rebuildContainers()
    repeat
        -- ตรวจชื่อแบบ recursive ใน containers ที่เกี่ยวข้อง
        for _, root in ipairs(containers) do
            local ok, found = pcall(function() return root:FindFirstChild("CombatFramework", true) end)
            if ok and found and found:IsA("ModuleScript") then return found end
        end
        -- บางเวอร์ชันย้ายโมดูล: สแกน descendants ที่ client เห็นได้ โดยไม่ require โมดูลอื่น
        local ok, descendants = pcall(function() return game:GetDescendants() end)
        if ok and descendants then
            for _, obj in ipairs(descendants) do
                if obj.Name == "CombatFramework" and obj:IsA("ModuleScript") then
                    return obj
                end
            end
        end
        task.wait(1)
        rebuildContainers()
    until os.clock() >= deadline
    return nil
end

task.spawn(function()
    local module = FindCombatFramework(45)
    if not module then
        warn("⚠️ CombatFramework ไม่เปิดให้ client เข้าถึงในเวอร์ชันนี้ — ปิดเฉพาะ FastAttack; AutoClick/ระบบอื่นยังทำงานตามปกติ")
        return
    end
    CombatFrameworkModule = module
    local ok, result = pcall(require, module)
    if ok and type(result) == "table" then
        CombatF = result
        print("✅ CombatFramework โหลดแล้วจาก: " .. module:GetFullName())
    else
        warn("⚠️ พบ CombatFramework แต่โหลด/รูปแบบไม่รองรับ: " .. tostring(result))
    end
end)

-- ================== CLICK SYSTEM (IN-GAME FAST) ==================
local lastClick = 0
local lastVIMClick = 0
local VIM_CLICK_DELAY = 0.02

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

RunService.Heartbeat:Connect(function()
    if uiHovering then return end
    if not CFG.AutoClick then return end
    local tool = GetTool()
    if not tool then return end
    pcall(function() tool:Activate() end)
    local now = tick()
    if now - lastVIMClick >= VIM_CLICK_DELAY then
        lastVIMClick = now
        pcall(function()
            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 1)
            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 1)
        end)
    end
    if CFG.AutoFarm and HasEnemy(80) and CombatF then
        if now - lastClick >= CFG.ClickSpeed then
            lastClick = now
            pcall(function()
                if CombatF.activeController and CombatF.activeController.attack then
                    CombatF.activeController:attack()
                end
            end)
        end
    end
end)
print("✅ Click System")

-- ================== AUTO SKILL ==================
local SKILL_KEYS = {Enum.KeyCode.Z,Enum.KeyCode.X,Enum.KeyCode.C,Enum.KeyCode.V,
                    Enum.KeyCode.F,Enum.KeyCode.E,Enum.KeyCode.Q,Enum.KeyCode.R}
task.spawn(function()
    while task.wait(0.1) do
        if CFG.AutoSkill and GetTool() and HasEnemy(60) then
            for _,k in pairs(SKILL_KEYS) do
                pcall(function()
                    VIM:SendKeyEvent(true,k,false,game); task.wait(0.01)
                    VIM:SendKeyEvent(false,k,false,game)
                end)
                task.wait(0.01)
            end
        end
    end
end)
print("✅ Auto Skill")

-- ================== HAKI ==================
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

-- ================== EQUIP ==================
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

-- ================== FAST ATTACK (ใช้โมดูลที่โหลดร่วมกัน) ==================
task.spawn(function()
    local deadline = os.clock() + 50
    while not CombatF and os.clock() < deadline do
        task.wait(0.25)
    end
    if not CombatF then
        -- ไม่หยุดสคริปต์หลัก: ระบบโจมตีปกติยังทำงานผ่าน AutoClick/tool:Activate()
        warn("ℹ️ FastAttack ใช้ไม่ได้ใน client นี้; ใช้ระบบโจมตีปกติแทน")
        return
    end
    local CF = CombatF
    print("✅ FastAttack เชื่อมกับ CombatFramework แล้ว")
    while task.wait(0.05) do
        if CFG.FastAttack then
            pcall(function()
                local controller = CF.activeController
                if controller then
                    controller.timeToNextAttack = 0
                    controller.attacking = false
                    controller.increment = 5
                    controller.hitboxMagnitude = 80
                    controller.blocking = false
                end
            end)
        end
    end
end)

-- ================== ANTI-AFK ==================
LP.Idled:Connect(function()
    pcall(function() VU:CaptureController(); VU:ClickButton2(Vector2.new(0,0)) end)
end)

-- ================== STATS ==================
task.spawn(function()
    while task.wait(0.3) do
        local h = Hum()
        if h then h.WalkSpeed = CFG.WalkSpeed; h.JumpPower = CFG.JumpPower end
    end
end)

-- ================== NOCLIP ==================
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

-- ================== BRING MOBS ==================
local BRING_PROPS = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0)
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
                            local angle = math.random() * math.pi * 2
                            local radius = math.random(8, 14)
                            local targetPos = h.Position + Vector3.new(
                                math.cos(angle) * radius, 0, math.sin(angle) * radius
                            )
                            mh.CFrame = CFrame.new(targetPos)
                            mh.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                            mh.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
                            if mh.CustomPhysicalProperties ~= BRING_PROPS then
                                mh.CustomPhysicalProperties = BRING_PROPS
                            end
                            mhum.WalkSpeed = 0
                            mhum.JumpPower = 0
                            mhum.PlatformStand = true
                        end
                    end
                end
            end)
        end
    end
end)
print("✅ Bring Mobs")

-- ================== TELEPORT ==================
local function TeleportToIsland(name)
    local isl = ISLANDS[name]; if not isl then return false end
    pcall(function() local h = HRP(); if h then h.CFrame = isl.CF + Vector3.new(0,30,0) end end)
    return true
end

-- ================== AUTO FARM ==================
local function GetClosestEnemy(questName)
    local h = HRP(); if not h then return nil end
    local en = workspace:FindFirstChild("Enemies"); if not en then return nil end
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
    return closest
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
                local target = GetClosestEnemy(qName)
                if not target then target = GetClosestEnemy(nil) end
                if target then
                    local mh = target:FindFirstChild("HumanoidRootPart")
                    if mh then h.CFrame = mh.CFrame * CFrame.new(0, CFG.Distance, 0) end
                end
            end)
        end
    end
end)
print("✅ Auto Farm")

-- ================== AUTO BOSS ==================
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
print("✅ Auto Boss")

-- ================== ELITE HUNTER ==================
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
print("✅ Elite Hunter")

-- ================== AUTO RAID ==================
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
print("✅ Auto Raid")

-- ================== AUTO CHEST ==================
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
print("✅ Auto Chest")

print("━━━━━━━━━━━━━━━━━━━━━")
print("✅ Systems ทั้งหมดพร้อม!")
print("🎨 กำลังสร้าง UI...")
print("━━━━━━━━━━━━━━━━━━━━━")

-- ================================================================
-- ========== 🎨 UI (FIXED) =======================================
-- ================================================================

local COLORS = {
    Bg=Color3.fromRGB(6,4,14), Glass=Color3.fromRGB(26,20,40),
    Border=Color3.fromRGB(120,80,200), Purple=Color3.fromRGB(160,80,255),
    Pink=Color3.fromRGB(255,60,180), Cyan=Color3.fromRGB(80,220,255),
    Text=Color3.fromRGB(240,235,255), TextDim=Color3.fromRGB(150,140,180),
}

-- ✅ หา parent (gethui → CoreGui → PlayerGui)
local GUIPARENT = nil
local PARENT_NAME = "?"

if gethui then
    local ok, hui = pcall(gethui)
    if ok and hui then GUIPARENT = hui; PARENT_NAME = "gethui" end
end
if not GUIPARENT then
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then GUIPARENT = cg; PARENT_NAME = "CoreGui" end
end
if not GUIPARENT then
    GUIPARENT = LP:FindFirstChild("PlayerGui")
    PARENT_NAME = "PlayerGui"
end
if not GUIPARENT then warn("❌ หา parent ไม่ได้") return end
print("🖼️ Parent: "..PARENT_NAME)

-- Blur
local Blur = Instance.new("BlurEffect")
Blur.Name = "RbotBlur"
Blur.Size = 0
Blur.Parent = Lighting

-- ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.DisplayOrder = 999
SG.Enabled = true
SG.Parent = GUIPARENT
print("✅ ScreenGui สร้างแล้ว")

-- Main (ขนาดเต็มทันที)
local OPEN_SIZE = UDim2.new(0, 800, 0, 560)

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = OPEN_SIZE
Main.Position = UDim2.new(0.5, -400, 0.5, -280)
Main.BackgroundColor3 = COLORS.Bg
Main.BackgroundTransparency = 0.05
Main.BorderSizePixel = 0
Main.Visible = true
Main.Active = true
Main.Parent = SG

local MC = Instance.new("UICorner"); MC.CornerRadius = UDim.new(0,22); MC.Parent = Main
local MStroke = Instance.new("UIStroke")
MStroke.Color = COLORS.Border; MStroke.Thickness = 1.5; MStroke.Transparency = 0.3
MStroke.Parent = Main

TS:Create(Blur, TweenInfo.new(0.3), {Size = 14}):Play()
print("✅ Main Frame สร้างแล้ว — ควรเห็นกล่องดำกลางจอ!")

-- ============ TOGGLE ============
local uiOpen = true
local FloatingBtn = nil

local function SetUIVisible(v)
    if uiOpen == v then return end
    uiOpen = v
    if v then
        Main.Visible = true
        Main.Size = OPEN_SIZE
        Main.BackgroundTransparency = 0.05
        Blur.Size = 14
        if FloatingBtn then FloatingBtn.Visible = false end
    else
        Blur.Size = 0
        if FloatingBtn then
            FloatingBtn.Visible = true
            FloatingBtn.Position = UDim2.new(0, 20, 0.5, -28)
        end
        Main.Visible = false
    end
end

-- ============ HEADER ============
local Header = Instance.new("Frame")
Header.Size = UDim2.new(1,0,0,72)
Header.BackgroundColor3 = Color3.fromRGB(16,12,26)
Header.BackgroundTransparency = 0.35
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner"); HC.CornerRadius = UDim.new(0,22); HC.Parent = Header

local HLine = Instance.new("Frame")
HLine.Size = UDim2.new(1,-40,0,2)
HLine.Position = UDim2.new(0,20,1,-1)
HLine.BackgroundColor3 = COLORS.Purple
HLine.BorderSizePixel = 0
HLine.Parent = Header

local HLC = Instance.new("UICorner"); HLC.CornerRadius = UDim.new(1,0); HLC.Parent = HLine
local HLG = Instance.new("UIGradient")
HLG.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0,COLORS.Purple),
    ColorSequenceKeypoint.new(0.5,COLORS.Pink),
    ColorSequenceKeypoint.new(1,COLORS.Cyan),
}
HLG.Parent = HLine

local LogoIcon = Instance.new("Frame")
LogoIcon.Size = UDim2.new(0,48,0,48)
LogoIcon.Position = UDim2.new(0,18,0.5,-24)
LogoIcon.BackgroundColor3 = COLORS.Purple
LogoIcon.BorderSizePixel = 0
LogoIcon.Parent = Header

local LIC = Instance.new("UICorner"); LIC.CornerRadius = UDim.new(1,0); LIC.Parent = LogoIcon

local LogoTxt = Instance.new("TextLabel")
LogoTxt.Size = UDim2.new(1,0,1,0)
LogoTxt.BackgroundTransparency = 1
LogoTxt.Text = "R"
LogoTxt.TextColor3 = Color3.fromRGB(255,255,255)
LogoTxt.Font = Enum.Font.GothamBlack
LogoTxt.TextSize = 26
LogoTxt.Parent = LogoIcon

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0,400,0,26)
Title.Position = UDim2.new(0,78,0,14)
Title.BackgroundTransparency = 1
Title.Text = "🔥 RBOT v13.1"
Title.TextColor3 = COLORS.Text
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 20
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0,400,0,18)
SubTitle.Position = UDim2.new(0,78,0,40)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = WORLD[game.PlaceId].." • "..LP.Name.." • Lv."..SafeGet(LP.Data,"Level")
SubTitle.TextColor3 = COLORS.TextDim
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextSize = 10
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

task.spawn(function()
    while task.wait(1) do
        pcall(function()
            SubTitle.Text = WORLD[game.PlaceId].." • "..LP.Name.." • Lv."..SafeGet(LP.Data,"Level").." • 💰"..FormatNum(SafeGet(LP.Data,"Beli"))
        end)
    end
end)

-- Close Btn
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0,34,0,34)
CloseBtn.Position = UDim2.new(1,-46,0.5,-17)
CloseBtn.BackgroundColor3 = COLORS.Glass
CloseBtn.BackgroundTransparency = 0.3
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = COLORS.Text
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.AutoButtonColor = false
CloseBtn.Parent = Header

local CBC = Instance.new("UICorner"); CBC.CornerRadius = UDim.new(1,0); CBC.Parent = CloseBtn
CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() SG:Destroy() end)
    pcall(function() Blur:Destroy() end)
end)

-- ============ SIDEBAR ============
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0,200,1,-92)
Sidebar.Position = UDim2.new(0,16,0,82)
Sidebar.BackgroundColor3 = COLORS.Glass
Sidebar.BackgroundTransparency = 0.5
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBC = Instance.new("UICorner"); SBC.CornerRadius = UDim.new(0,14); SBC.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1,-16,1,-16)
TabList.Position = UDim2.new(0,8,0,8)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TLLay = Instance.new("UIListLayout")
TLLay.Parent = TabList
TLLay.SortOrder = Enum.SortOrder.LayoutOrder
TLLay.Padding = UDim.new(0,6)

-- ➖✚
local ControlPanel = Instance.new("Frame")
ControlPanel.Size = UDim2.new(1,0,0,46)
ControlPanel.BackgroundColor3 = COLORS.Glass
ControlPanel.BackgroundTransparency = 0.4
ControlPanel.BorderSizePixel = 0
ControlPanel.LayoutOrder = -1
ControlPanel.Parent = TabList

local CPC = Instance.new("UICorner"); CPC.CornerRadius = UDim.new(0,10); CPC.Parent = ControlPanel

local MinBtn = Instance.new("TextButton")
MinBtn.Size = UDim2.new(0.5,-6,1,-12)
MinBtn.Position = UDim2.new(0,6,0,6)
MinBtn.BackgroundColor3 = COLORS.Purple
MinBtn.BackgroundTransparency = 0.2
MinBtn.Text = "➖"
MinBtn.TextColor3 = COLORS.Text
MinBtn.Font = Enum.Font.GothamBold
MinBtn.TextSize = 16
MinBtn.Parent = ControlPanel
local MinBtnC = Instance.new("UICorner"); MinBtnC.CornerRadius = UDim.new(0,8); MinBtnC.Parent = MinBtn
MinBtn.MouseButton1Click:Connect(function() SetUIVisible(false) end)

local ExpBtn = Instance.new("TextButton")
ExpBtn.Size = UDim2.new(0.5,-6,1,-12)
ExpBtn.Position = UDim2.new(0.5,0,0,6)
ExpBtn.BackgroundColor3 = COLORS.Cyan
ExpBtn.BackgroundTransparency = 0.2
ExpBtn.Text = "✚"
ExpBtn.TextColor3 = COLORS.Text
ExpBtn.Font = Enum.Font.GothamBold
ExpBtn.TextSize = 16
ExpBtn.Parent = ControlPanel
local ExpBtnC = Instance.new("UICorner"); ExpBtnC.CornerRadius = UDim.new(0,8); ExpBtnC.Parent = ExpBtn
ExpBtn.MouseButton1Click:Connect(function()
    Main.Visible = true
    Main.Size = OPEN_SIZE
    uiOpen = true
    if FloatingBtn then FloatingBtn.Visible = false end
    Blur.Size = 14
end)

-- ============ CONTENT ============
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1,-240,1,-92)
Content.Position = UDim2.new(0,226,0,82)
Content.BackgroundColor3 = COLORS.Glass
Content.BackgroundTransparency = 0.5
Content.BorderSizePixel = 0
Content.Parent = Main

local CNC = Instance.new("UICorner"); CNC.CornerRadius = UDim.new(0,14); CNC.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1,-20,1,-20)
Scroll.Position = UDim2.new(0,10,0,10)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 4
Scroll.ScrollBarImageColor3 = COLORS.Purple
Scroll.CanvasSize = UDim2.new(0,0,0,0)
Scroll.Parent = Content

local SLLay = Instance.new("UIListLayout")
SLLay.Parent = Scroll
SLLay.SortOrder = Enum.SortOrder.LayoutOrder
SLLay.Padding = UDim.new(0,8)

SLLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0,0,0,SLLay.AbsoluteContentSize.Y + 40)
end)

-- Hover lock
Main.MouseEnter:Connect(function() uiHovering = true end)
Main.MouseLeave:Connect(function() uiHovering = false end)
Header.MouseEnter:Connect(function() uiHovering = true end)
Header.MouseLeave:Connect(function() uiHovering = false end)

-- Drag
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1
       or i.UserInputType==Enum.UserInputType.Touch then
        dragging=true; dragStart=i.Position; startPos=Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType==Enum.UserInputType.MouseButton1
       or i.UserInputType==Enum.UserInputType.Touch then
        dragging=false
    end
end)
UIS.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement
       or i.UserInputType==Enum.UserInputType.Touch) then
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
    Btn.Size=UDim2.new(1,0,0,44)
    Btn.BackgroundColor3=COLORS.Glass
    Btn.BackgroundTransparency=0.7
    Btn.BorderSizePixel=0
    Btn.Text="  "..icon.."   "..name
    Btn.TextColor3=COLORS.TextDim
    Btn.Font=Enum.Font.GothamBold
    Btn.TextSize=13
    Btn.TextXAlignment=Enum.TextXAlignment.Left
    Btn.AutoButtonColor=false
    Btn.Parent=TabList

    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,10); c.Parent=Btn

    local page=Instance.new("Frame")
    page.Size=UDim2.new(1,0,0,0)
    page.AutomaticSize=Enum.AutomaticSize.Y
    page.BackgroundTransparency=1
    page.Visible=false
    page.Parent=Scroll

    local pLay=Instance.new("UIListLayout")
    pLay.Parent=page
    pLay.SortOrder=Enum.SortOrder.LayoutOrder
    pLay.Padding=UDim.new(0,8)

    table.insert(Tabs,{Btn=Btn,Page=page})

    Btn.MouseButton1Click:Connect(function()
        for _,t in pairs(Tabs) do
            t.Page.Visible=false
            t.Btn.BackgroundTransparency=0.7
            t.Btn.TextColor3=COLORS.TextDim
        end
        page.Visible=true
        Btn.BackgroundTransparency=0.3
        Btn.TextColor3=COLORS.Text
    end)

    if not FirstTab then
        FirstTab=true
        page.Visible=true
        Btn.BackgroundTransparency=0.3
        Btn.TextColor3=COLORS.Text
    end
    return page
end

local function Section(parent, title)
    local S=Instance.new("TextLabel")
    S.Size=UDim2.new(1,-8,0,26)
    S.BackgroundTransparency=1
    S.Text="  ▸  "..title:upper()
    S.TextColor3=COLORS.Purple
    S.Font=Enum.Font.GothamBold
    S.TextSize=11
    S.TextXAlignment=Enum.TextXAlignment.Left
    S.LayoutOrder = 0
    S.Parent=parent
end

local function Toggle(parent, name, desc, key)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,58)
    F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4
    F.BorderSizePixel=0
    F.LayoutOrder = 1
    F.Parent=parent

    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F

    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-90,0,22)
    L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1
    L.Text=name
    L.TextColor3=COLORS.Text
    L.Font=Enum.Font.GothamBold
    L.TextSize=13
    L.TextXAlignment=Enum.TextXAlignment.Left
    L.Parent=F

    local D=Instance.new("TextLabel")
    D.Size=UDim2.new(1,-90,0,16)
    D.Position=UDim2.new(0,16,0,30)
    D.BackgroundTransparency=1
    D.Text=desc or ""
    D.TextColor3=COLORS.TextDim
    D.Font=Enum.Font.Gotham
    D.TextSize=10
    D.TextXAlignment=Enum.TextXAlignment.Left
    D.Parent=F

    local Bg=Instance.new("Frame")
    Bg.Size=UDim2.new(0,46,0,24)
    Bg.Position=UDim2.new(1,-62,0.5,-12)
    Bg.BackgroundColor3=CFG[key] and COLORS.Purple or Color3.fromRGB(48,45,62)
    Bg.BorderSizePixel=0
    Bg.Parent=F

    local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(1,0); bgc.Parent=Bg

    local Dot=Instance.new("Frame")
    Dot.Size=UDim2.new(0,20,0,20)
    Dot.Position=CFG[key] and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
    Dot.BackgroundColor3=Color3.fromRGB(255,255,255)
    Dot.BorderSizePixel=0
    Dot.Parent=Bg

    local dc=Instance.new("UICorner"); dc.CornerRadius=UDim.new(1,0); dc.Parent=Dot

    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency=1
    Btn.Text=""
    Btn.Parent=F

    Btn.MouseButton1Click:Connect(function()
        CFG[key]=not CFG[key]
        Bg.BackgroundColor3=CFG[key] and COLORS.Purple or Color3.fromRGB(48,45,62)
        Dot.Position=CFG[key] and UDim2.new(1,-22,0.5,-10) or UDim2.new(0,2,0.5,-10)
    end)
end

local function Slider(parent, name, min, max, key)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,68)
    F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4
    F.BorderSizePixel=0
    F.LayoutOrder = 1
    F.Parent=parent

    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F

    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-30,0,22)
    L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1
    L.Text=name.."  :  "..CFG[key]
    L.TextColor3=COLORS.Text
    L.Font=Enum.Font.GothamBold
    L.TextSize=13
    L.TextXAlignment=Enum.TextXAlignment.Left
    L.Parent=F

    local BarBg=Instance.new("Frame")
    BarBg.Size=UDim2.new(1,-32,0,8)
    BarBg.Position=UDim2.new(0,16,0,42)
    BarBg.BackgroundColor3=Color3.fromRGB(48,45,62)
    BarBg.BorderSizePixel=0
    BarBg.Parent=F

    local bgc=Instance.new("UICorner"); bgc.CornerRadius=UDim.new(1,0); bgc.Parent=BarBg

    local ratio=math.clamp((CFG[key]-min)/(max-min),0,1)
    local Fill=Instance.new("Frame")
    Fill.Size=UDim2.new(ratio,0,1,0)
    Fill.BackgroundColor3=COLORS.Purple
    Fill.BorderSizePixel=0
    Fill.Parent=BarBg

    local fc=Instance.new("UICorner"); fc.CornerRadius=UDim.new(1,0); fc.Parent=Fill

    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,3,0)
    Btn.Position=UDim2.new(0,0,-1,0)
    Btn.BackgroundTransparency=1
    Btn.Text=""
    Btn.Parent=BarBg

    local dragging2=false
    local function Update(i)
        local r=math.clamp((i.Position.X-BarBg.AbsolutePosition.X)/BarBg.AbsoluteSize.X,0,1)
        local v=math.floor(min + r*(max-min))
        Fill.Size=UDim2.new(r,0,1,0)
        L.Text=name.."  :  "..v
        CFG[key]=v
    end

    Btn.InputBegan:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
           or i.UserInputType==Enum.UserInputType.Touch then
            dragging2=true; Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType==Enum.UserInputType.MouseButton1
           or i.UserInputType==Enum.UserInputType.Touch then
            dragging2=false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging2 and (i.UserInputType==Enum.UserInputType.MouseMovement
           or i.UserInputType==Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
end

local function Button(parent, name, desc, callback)
    local F=Instance.new("Frame")
    F.Size=UDim2.new(1,-8,0,58)
    F.BackgroundColor3=COLORS.Glass
    F.BackgroundTransparency=0.4
    F.BorderSizePixel=0
    F.LayoutOrder = 1
    F.Parent=parent

    local c=Instance.new("UICorner"); c.CornerRadius=UDim.new(0,12); c.Parent=F

    local L=Instance.new("TextLabel")
    L.Size=UDim2.new(1,-30,0,22)
    L.Position=UDim2.new(0,16,0,8)
    L.BackgroundTransparency=1
    L.Text=name
    L.TextColor3=COLORS.Text
    L.Font=Enum.Font.GothamBold
    L.TextSize=13
    L.TextXAlignment=Enum.TextXAlignment.Left
    L.Parent=F

    local D=Instance.new("TextLabel")
    D.Size=UDim2.new(1,-30,0,16)
    D.Position=UDim2.new(0,16,0,30)
    D.BackgroundTransparency=1
    D.Text=desc or ""
    D.TextColor3=COLORS.TextDim
    D.Font=Enum.Font.Gotham
    D.TextSize=10
    D.TextXAlignment=Enum.TextXAlignment.Left
    D.Parent=F

    local Btn=Instance.new("TextButton")
    Btn.Size=UDim2.new(1,0,1,0)
    Btn.BackgroundTransparency=1
    Btn.Text=""
    Btn.Parent=F

    Btn.MouseButton1Click:Connect(function()
        pcall(callback)
    end)
end

-- ================== TABS ==================
local HomeTab=CreateTab("หน้าหลัก","🏠")
local FarmTab=CreateTab("ฟาร์ม","🌾")
local BossTab=CreateTab("บอส & Raid","👹")
local SkillTab=CreateTab("สกิล","🥋")
local SetTab=CreateTab("ตั้งค่า","🔧")

-- HOME
Section(HomeTab, "📊 Live Status")
Button(HomeTab, "🔍 ตรวจสอบสถานะ", "แสดงข้อมูลทุกอย่าง", function()
    local c=Char()
    local tool=c and c:FindFirstChildOfClass("Tool")
    print("🎮 Level: "..SafeGet(LP.Data,"Level"))
    print("💰 Beli: "..FormatNum(SafeGet(LP.Data,"Beli")))
    print("🔧 Tool: "..(tool and tool.Name or "❌"))
    print("📜 Quest: "..(HasQuest() and "✅" or "❌").." | "..GetCurrentQuestName())
    print("👾 Mobs: "..#(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}))
end)
Button(HomeTab, "📜 Force รับเควสต์", "บังคับรับเควสต์", function()
    currentQuest=nil; lastQuestAttempt=0; GetQuest()
end)
Button(HomeTab, "🎁 Redeem All Codes", "ใส่โค้ดทั้งหมด", function()
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
end)

-- FARM
Section(FarmTab, "🎯 Auto Farm")
Toggle(FarmTab, "Auto Farm ⭐", "ฟาร์ม + ตี + ย้ายเกาะ", "AutoFarm")
Toggle(FarmTab, "Auto Quest", "รับเควสต์อัตโนมัติ", "AutoQuest")
Toggle(FarmTab, "Auto Island", "ย้ายเกาะตาม Level", "AutoIsland")
Toggle(FarmTab, "Auto Click ⭐", "คลิกในเกมเท่านั้น", "AutoClick")
Toggle(FarmTab, "Auto Equip", "ติดอาวุธอัตโนมัติ", "AutoEquip")
Toggle(FarmTab, "Bring Mobs", "ดึงมอนมารวมตัว", "BringMobs")
Toggle(FarmTab, "Magnet", "ดึงของทุกอย่าง", "Magnet")
Toggle(FarmTab, "Auto Chest 💎", "เก็บหีบทุกเกาะ", "AutoChest")
Slider(FarmTab, "Farm Distance", 5, 100, "Distance")

-- BOSS
Section(BossTab, "👹 Auto Boss")
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
Button(SetTab, "❌ ปิด UI ทั้งหมด", "ปิดหน้าต่าง", function()
    pcall(function() SG:Destroy() end)
    pcall(function() Blur:Destroy() end)
end)

print("✅ ทุกแท็บสร้างเสร็จ")

-- ============ FLOATING BUTTON ============
FloatingBtn = Instance.new("TextButton")
FloatingBtn.Size=UDim2.new(0,56,0,56)
FloatingBtn.Position=UDim2.new(0,-70,0.5,-28)
FloatingBtn.BackgroundColor3=COLORS.Purple
FloatingBtn.BorderSizePixel=0
FloatingBtn.Text="✚"
FloatingBtn.TextColor3=Color3.fromRGB(255,255,255)
FloatingBtn.Font=Enum.Font.GothamBlack
FloatingBtn.TextSize=24
FloatingBtn.AutoButtonColor=false
FloatingBtn.Visible=false
FloatingBtn.ZIndex=999
FloatingBtn.Parent=SG

local FBC = Instance.new("UICorner"); FBC.CornerRadius=UDim.new(1,0); FBC.Parent=FloatingBtn
FloatingBtn.MouseButton1Click:Connect(function()
    SetUIVisible(true)
end)

-- KEYBIND
UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode==Enum.KeyCode.RightControl then
        SetUIVisible(not uiOpen)
    end
    if i.KeyCode==Enum.KeyCode.RightShift then
        if uiOpen then SetUIVisible(false) end
    end
end)

-- SAVE/LOAD (CLIENT-SAFE)
-- BindToClose is server-only in Roblox, so do not call it from this client script.
-- Load saved settings once, then periodically save while the script is running.
if type(writefile) == "function" and type(readfile) == "function" then
    task.spawn(function()
        task.wait(2)
        pcall(function()
            if type(isfile) == "function" and isfile("rbot_v13_cfg.json") then
                local data = HttpService:JSONDecode(readfile("rbot_v13_cfg.json"))
                if type(data) == "table" then
                    for k, v in pairs(data) do
                        if CFG[k] ~= nil then CFG[k] = v end
                    end
                    print("✅ Loaded config")
                end
            end
        end)

        while task.wait(30) do
            local ok, err = pcall(function()
                writefile("rbot_v13_cfg.json", HttpService:JSONEncode(CFG))
            end)
            if not ok then
                warn("⚠️ Config save failed: " .. tostring(err))
            end
        end
    end)
else
    warn("⚠️ Config save/load unavailable in this environment")
end

print("═══════════════════════════════════════════════")
print("🔥 RBOT v13.1 FINAL พร้อมใช้งาน!")
print("✅ UI ขึ้น 100%")
print("✅ Islands: "..CountTable(ISLANDS))
print("✅ คลิกในเกมเท่านั้น")
print("⌨️ RightCtrl = Toggle | RightShift = Close")
print("═══════════════════════════════════════════════")
