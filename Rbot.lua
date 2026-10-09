--[[
    🔥 RBOT v12.0 FINAL — UI ขึ้น 100%
    เทคนิค: ใช้ PlayerGui เป็นหลัก, สร้าง synchronous, ไม่ Tween
]]

print("━━━━━━━━━━━━━━━━━━━━━")
print("🔥 RBOT v12.0 เริ่ม...")
print("━━━━━━━━━━━━━━━━━━━━━")

-- ============ SERVICES ============
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")
local VU = game:GetService("VirtualUser")
local VIM = game:GetService("VirtualInputManager")
local Lighting = game:GetService("Lighting")
local RunService = game:GetService("RunService")
local TPS = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer

print("✅ Services OK")

-- ============ CLEANUP ============
for _, n in ipairs({"RbotPremium", "RbotPremium_Floating", "RbotBlur"}) do
    local cg = game:GetService("CoreGui")
    local pg = LP:FindFirstChild("PlayerGui")
    if cg then pcall(function() local o = cg:FindFirstChild(n); if o then o:Destroy() end end) end
    if pg then pcall(function() local o = pg:FindFirstChild(n); if o then o:Destroy() end end) end
end
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("BlurEffect") and v.Name == "RbotBlur" then v:Destroy() end
end
print("✅ Cleanup OK")

-- ============ CHECK GAME ============
local WORLD = {
    [2753915549]="Sea 1",[4442272183]="Sea 2",
    [7449423635]="Sea 3",[155615604]="Sea 4",
}
if not WORLD[game.PlaceId] then
    warn("⚠️ ใช้กับ Blox Fruits เท่านั้น!")
    return
end
print("🌊 " .. WORLD[game.PlaceId])

-- ============ CONFIG ============
local CFG = {
    AutoFarm=false, AutoQuest=true, AutoIsland=true, AutoClick=true,
    AutoSkill=true, AutoHaki=true, AutoEquip=true,
    FastAttack=true, BringMobs=true, Magnet=false,
    AutoBoss=false, AutoEliteHunter=false, AutoRaid=false, AutoChest=false,
    NoClip=false, WalkSpeed=16, JumpPower=50, Distance=30, ClickSpeed=0.03,
}
local uiHovering = false
print("✅ Config OK")

-- ============ HELPERS ============
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
local function SafeGet(t,k)
    local o, v = pcall(function() return t[k].Value end)
    return o and v or 0
end
local function FormatNum(n)
    if n >= 1e9 then return string.format("%.1fB", n/1e9)
    elseif n >= 1e6 then return string.format("%.1fM", n/1e6)
    elseif n >= 1e3 then return string.format("%.1fK", n/1e3)
    else return tostring(math.floor(n)) end
end

-- ============ ISLANDS (ย่อให้สั้น) ============
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
print("✅ Islands OK ("..#ISLANDS..")")

-- ============ QUESTS (ย่อ) ============
local QUESTS = {
    {Name="Bandit",Level=1,I="Starter Island"},
    {Name="Monkey",Level=1,I="Starter Island"},
    {Name="Blade Bandit",Level=15,I="Jungle"},
    {Name="Jungle Pirate",Level=20,I="Jungle"},
    {Name="Desert Bandit",Level=30,I="Desert"},
    {Name="Desert Officer",Level=40,I="Desert"},
    {Name="Snow Bandit",Level=50,I="Frozen Village"},
    {Name="Snowman",Level=60,I="Frozen Village"},
    {Name="Frost Bandit",Level=75,I="Marine Ford"},
    {Name="Marine",Level=85,I="Marine Ford"},
    {Name="Sky Bandit",Level=90,I="Skylands"},
    {Name="Dark Master",Level=100,I="Skylands"},
    {Name="Fighter",Level=120,I="Colosseum"},
    {Name="Fishman",Level=150,I="Underwater City"},
    {Name="Magma Ninja",Level=175,I="Fountain City"},
    {Name="Pirate Boss",Level=200,I="Fountain City"},
    {Name="Snow Trooper",Level=250,I="Kingdom of Rose"},
    {Name="Winter Warrior",Level=300,I="Kingdom of Rose"},
    {Name="Lab Subordinate",Level=350,I="Green Zone"},
    {Name="Horned Warrior",Level=400,I="Green Zone"},
    {Name="Military Soldier",Level=450,I="Graveyard"},
    {Name="Military Spy",Level=500,I="Graveyard"},
    {Name="Reborn Skeleton",Level=550,I="Graveyard"},
    {Name="Living Zombie",Level=600,I="Graveyard"},
    {Name="Demonic Soul",Level=650,I="Graveyard"},
    {Name="Possessed Mummy",Level=700,I="Graveyard"},
    {Name="Snow Lurker",Level=725,I="Snow Mountain"},
    {Name="Yeti",Level=750,I="Snow Mountain"},
    {Name="Pirate Millionaire",Level=775,I="Hot and Cold"},
    {Name="Pistol Billionaire",Level=800,I="Hot and Cold"},
    {Name="Dragon Crew Archer",Level=850,I="Hot and Cold"},
    {Name="Dragon Crew Warrior",Level=875,I="Hot and Cold"},
    {Name="Amazon",Level=900,I="Haunted Castle"},
    {Name="Island Empress",Level=925,I="Haunted Castle"},
    {Name="Hydra Enforcer",Level=950,I="Haunted Castle"},
    {Name="Venomous Assailant",Level=975,I="Haunted Castle"},
    {Name="Cursed Pirate",Level=1150,I="Cursed Ship"},
    {Name="Cursed Captain",Level=1175,I="Cursed Ship"},
    {Name="Cursed Skeleton",Level=1200,I="Cursed Ship"},
    {Name="Sea Soldier",Level=1250,I="Forgotten Island"},
    {Name="Water Fighter",Level=1300,I="Forgotten Island"},
    {Name="Forest Pirate",Level=1375,I="Forgotten Island"},
    {Name="Mythological Pirate",Level=1425,I="Forgotten Island"},
    {Name="Jungle Pirate",Level=1475,I="Forgotten Island"},
    {Name="Musketeer Pirate",Level=1500,I="Forgotten Island"},
    {Name="Stone",Level=1550,I="Port Town"},
    {Name="Dragon Crew Warrior",Level=1575,I="Hydra Island"},
    {Name="Dragon Crew Archer",Level=1600,I="Hydra Island"},
    {Name="Hydra Enforcer",Level=1625,I="Hydra Island"},
    {Name="Venomous Assailant",Level=1650,I="Hydra Island"},
    {Name="Hydra Leader",Level=1675,I="Hydra Island"},
    {Name="Marine Commodore",Level=1700,I="Great Tree"},
    {Name="Marine Rear Admiral",Level=1725,I="Great Tree"},
    {Name="Kilo Admiral",Level=1750,I="Great Tree"},
    {Name="Captain Elephant",Level=1875,I="Floating Turtle"},
    {Name="Beautiful Pirate",Level=1950,I="Floating Turtle"},
    {Name="Peanut Scout",Level=2075,I="Sea of Treats"},
    {Name="Peanut President",Level=2100,I="Sea of Treats"},
    {Name="Ice Cream Chef",Level=2125,I="Sea of Treats"},
    {Name="Ice Cream Commander",Level=2150,I="Sea of Treats"},
    {Name="Cookie Crafter",Level=2200,I="Sea of Treats"},
    {Name="Cake Guard",Level=2225,I="Sea of Treats"},
    {Name="Baking Staff",Level=2250,I="Sea of Treats"},
    {Name="Head Baker",Level=2275,I="Chocolate Land"},
    {Name="Cocoa Warrior",Level=2300,I="Chocolate Land"},
    {Name="Chocolate Bar Battler",Level=2325,I="Chocolate Land"},
    {Name="Sweet Thief",Level=2350,I="Chocolate Land"},
    {Name="Candy Rebel",Level=2375,I="Chocolate Land"},
    {Name="Candy Pirate",Level=2400,I="Chocolate Land"},
    {Name="Snow Demon",Level=2425,I="Chocolate Land"},
    {Name="Island Empress",Level=2500,I="Tiki Outpost"},
    {Name="Island Champion",Level=2525,I="Tiki Outpost"},
    {Name="Reef Bandit",Level=2600,I="Submerged Island"},
    {Name="Coral Pirate",Level=2625,I="Submerged Island"},
    {Name="Sea Chanter",Level=2650,I="Submerged Island"},
    {Name="Ocean Prophet",Level=2675,I="Submerged Island"},
    {Name="High Disciple",Level=2695,I="Submerged Island"},
    {Name="Grand Devotee",Level=2700,I="Submerged Island"},
}
print("✅ Quests OK ("..#QUESTS..")")

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

-- ============ QUEST SYSTEM ============
local currentQuest = nil
local lastQuestAttempt = 0
local function HasQuest()
    local ok, has = pcall(function() return LP.PlayerGui.Main.Quest.Visible end)
    return ok and has
end
local function GetCurrentQuestName()
    local ok, name = pcall(function()
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
    print("📜 " .. best.Name .. " (Lv." .. best.Level .. ")")
    return true
end
print("✅ Quest System OK")

-- ============ CLICK SYSTEM (IN-GAME ONLY) ============
local lastClick = 0
local function GetTool()
    local c = Char(); if not c then return nil end
    local t = c:FindFirstChildOfClass("Tool")
    if t then return t end
    local h = c:FindFirstChild("Humanoid")
    if h then
        local t2 = h:FindFirstChildOfClass("Tool")
        if t2 then return t2 end
    end
    return nil
end
local function HasEnemy(r)
    r = r or 100
    local h = HRP(); if not h then return false end
    local en = workspace:FindFirstChild("Enemies"); if not en then return false end
    for _, m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0
           and (mh.Position - h.Position).Magnitude <= r then
            return true
        end
    end
    return false
end

local CombatF = nil
pcall(function()
    CombatF = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
end)

RunService.Heartbeat:Connect(function()
    if uiHovering then return end
    if not CFG.AutoClick then return end
    local tool = GetTool()
    if not tool then return end
    pcall(function() tool:Activate() end)
    if CFG.AutoFarm and HasEnemy(80) then
        local now = tick()
        if now - lastClick >= CFG.ClickSpeed then
            lastClick = now
            pcall(function()
                if CombatF and CombatF.activeController and CombatF.activeController.attack then
                    CombatF.activeController:attack()
                end
            end)
        end
    end
end)
print("✅ Click System OK")

-- ============ AUTO SKILL ============
local SKILL_KEYS = {Enum.KeyCode.Z, Enum.KeyCode.X, Enum.KeyCode.C, Enum.KeyCode.V,
                    Enum.KeyCode.F, Enum.KeyCode.E, Enum.KeyCode.Q, Enum.KeyCode.R}
task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoSkill and GetTool() and HasEnemy(60) then
            for _, k in pairs(SKILL_KEYS) do
                pcall(function()
                    VIM:SendKeyEvent(true, k, false, game); task.wait(0.02)
                    VIM:SendKeyEvent(false, k, false, game)
                end)
                task.wait(0.03)
            end
        end
    end
end)
print("✅ Auto Skill OK")

-- ============ HAKI ============
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

-- ============ EQUIP ============
task.spawn(function()
    while task.wait(1) do
        if CFG.AutoEquip and (CFG.AutoFarm or CFG.AutoClick) then
            pcall(function()
                local c = Char(); if not c or c:FindFirstChildOfClass("Tool") then return end
                local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
                if not bp then return end
                for _, item in pairs(bp:GetChildren()) do
                    if item:IsA("Tool") then item.Parent = c; break end
                end
            end)
        end
    end
end)

-- ============ FAST ATTACK ============
task.spawn(function()
    local ok, CF = pcall(function()
        local c = require(LP.PlayerScripts:WaitForChild("CombatFramework"))
        return getupvalues(c)[2]
    end)
    if not ok then return end
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
print("✅ Fast Attack OK")

-- ============ ANTI-AFK ============
LP.Idled:Connect(function()
    pcall(function()
        VU:CaptureController()
        VU:ClickButton2(Vector2.new(0, 0))
    end)
end)

-- ============ STATS ============
task.spawn(function()
    while task.wait(0.3) do
        local h = Hum()
        if h then
            h.WalkSpeed = CFG.WalkSpeed
            h.JumpPower = CFG.JumpPower
        end
    end
end)

-- ============ NOCLIP ============
task.spawn(function()
    while task.wait(0.2) do
        if CFG.NoClip then
            pcall(function()
                local c = Char()
                if c then
                    for _, v in pairs(c:GetDescendants()) do
                        if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
                    end
                end
            end)
        end
    end
end)

-- ============ BRING MOBS ============
local BRING_PROPS = PhysicalProperties.new(0.01, 0.01, 0.01, 0, 0)
task.spawn(function()
    while task.wait(0.05) do
        if (CFG.BringMobs or CFG.Magnet) and CFG.AutoFarm then
            pcall(function()
                local h = HRP(); if not h then return end
                local en = workspace:FindFirstChild("Enemies"); if not en then return end
                for _, m in pairs(en:GetChildren()) do
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
print("✅ Bring Mobs OK")

-- ============ TELEPORT ============
local function TeleportToIsland(name)
    local isl = ISLANDS[name]; if not isl then return false end
    pcall(function()
        local h = HRP()
        if h then h.CFrame = isl.CF + Vector3.new(0, 30, 0) end
    end)
    return true
end

-- ============ AUTO FARM ============
local function GetClosestEnemy(questName)
    local h = HRP(); if not h then return nil end
    local en = workspace:FindFirstChild("Enemies"); if not en then return nil end
    local closest, dist = nil, math.huge
    for _, m in pairs(en:GetChildren()) do
        local mh = m:FindFirstChild("HumanoidRootPart")
        local mhum = m:FindFirstChild("Humanoid")
        if mh and mhum and mhum.Health > 0 then
            if questName and m.Name == questName then
                local d = (mh.Position - h.Position).Magnitude
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
print("✅ Auto Farm OK")

-- ============ AUTO BOSS ============
task.spawn(function()
    while task.wait(0.3) do
        if CFG.AutoBoss then
            pcall(function()
                local h = HRP(); if not h then return end
                local en = workspace:FindFirstChild("Enemies"); if not en then return end
                for _, m in pairs(en:GetChildren()) do
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
print("✅ Auto Boss OK")

-- ============ ELITE HUNTER ============
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
                    for _, m in pairs(en:GetChildren()) do
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
print("✅ Elite Hunter OK")

-- ============ AUTO RAID ============
task.spawn(function()
    while task.wait(3) do
        if CFG.AutoRaid then
            pcall(function()
                local pg = LP.PlayerGui.Main
                if pg and pg.Timer and pg.Timer.Visible then
                    for i = 5, 1, -1 do
                        local isl = workspace:FindFirstChild("_WorldOrigin")
                        if isl and isl.Locations:FindFirstChild("Island " .. i) then
                            local loc = isl.Locations["Island " .. i]
                            local h = HRP()
                            if h then h.CFrame = loc.CFrame end
                            break
                        end
                    end
                else
                    if RS.Remotes.CommF_:InvokeServer("Candies", "Check") then
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
print("✅ Auto Raid OK")

-- ============ AUTO CHEST ============
task.spawn(function()
    while task.wait(1) do
        if CFG.AutoChest then
            pcall(function()
                local h = HRP(); if not h then return end
                for _, v in pairs(workspace:GetChildren()) do
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
print("✅ Auto Chest OK")

-- ================================================================
-- ========== 🎨 UI — SIMPLE MODE (ขึ้น 100%) =====================
-- ================================================================

print("")
print("═══════════════════════════════════════")
print("🎨 เริ่มสร้าง UI...")
print("═══════════════════════════════════════")

-- ✅ หา parent: ใช้ PlayerGui ก่อน (ปลอดภัยสุด)
local GUIPARENT = nil

local pg = LP:FindFirstChild("PlayerGui")
if not pg then
    pg = LP:WaitForChild("PlayerGui", 5)
end

if pg then
    GUIPARENT = pg
    print("✅ ใช้ PlayerGui เป็น parent")
else
    -- fallback: CoreGui
    local ok, cg = pcall(function() return game:GetService("CoreGui") end)
    if ok and cg then
        GUIPARENT = cg
        print("⚠️ PlayerGui ไม่มี → ใช้ CoreGui")
    end
end

if not GUIPARENT then
    warn("❌ หา parent ไม่ได้ — หยุด")
    return
end

-- ✅ สร้าง ScreenGui
local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.DisplayOrder = 999
SG.Enabled = true
SG.Parent = GUIPARENT
print("✅ ScreenGui สร้างเสร็จ: " .. tostring(SG.Parent))

-- ================================================================
-- COLORS (ใช้สีทึบ ไม่มี gradient)
-- ================================================================
local C = {
    Bg = Color3.fromRGB(15, 10, 25),
    Panel = Color3.fromRGB(30, 22, 45),
    Card = Color3.fromRGB(45, 35, 65),
    Purple = Color3.fromRGB(160, 80, 255),
    PurpleDark = Color3.fromRGB(100, 50, 170),
    Text = Color3.fromRGB(240, 235, 255),
    TextDim = Color3.fromRGB(160, 150, 190),
    Green = Color3.fromRGB(80, 220, 120),
    Red = Color3.fromRGB(255, 80, 100),
    Cyan = Color3.fromRGB(80, 200, 255),
}

-- ================================================================
-- MAIN FRAME (ขนาดเต็มทันที)
-- ================================================================
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 700, 0, 480)          -- ✅ ขนาดเต็มทันที
Main.Position = UDim2.new(0.5, -350, 0.5, -240)
Main.BackgroundColor3 = C.Bg
Main.BorderSizePixel = 0
Main.Visible = true                            -- ✅ บังคับโชว์
Main.Active = true
Main.Parent = SG
print("✅ Main Frame สร้างเสร็จ — ควรเห็นกล่องดำกลางจอ")

-- ขอบม่วง
local MainStroke = Instance.new("UIStroke")
MainStroke.Color = C.Purple
MainStroke.Thickness = 2
MainStroke.Parent = Main

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

-- ================================================================
-- HEADER
-- ================================================================
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = C.Panel
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 16)
HC.Parent = Header

local HeaderFix = Instance.new("Frame")
HeaderFix.Size = UDim2.new(1, 0, 0, 20)
HeaderFix.Position = UDim2.new(0, 0, 1, -20)
HeaderFix.BackgroundColor3 = C.Panel
HeaderFix.BorderSizePixel = 0
HeaderFix.Parent = Header

-- Title
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(0, 400, 0, 30)
Title.Position = UDim2.new(0, 20, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "🔥 RBOT v12.0"
Title.TextColor3 = C.Purple
Title.TextSize = 22
Title.Font = Enum.Font.GothamBlack
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

-- SubTitle
local SubTitle = Instance.new("TextLabel")
SubTitle.Name = "SubTitle"
SubTitle.Size = UDim2.new(0, 400, 0, 18)
SubTitle.Position = UDim2.new(0, 20, 0, 36)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = WORLD[game.PlaceId] .. " • " .. LP.Name .. " • Lv." .. SafeGet(LP.Data, "Level")
SubTitle.TextColor3 = C.TextDim
SubTitle.TextSize = 11
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- ปุ่มปิด
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -42, 0, 14)
CloseBtn.BackgroundColor3 = C.Red
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Color3.new(1, 1, 1)
CloseBtn.TextSize = 16
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Header

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    pcall(function() SG:Destroy() end)
end)

print("✅ Header สร้างเสร็จ")

-- ================================================================
-- SIDEBAR (แท็บ)
-- ================================================================
local Sidebar = Instance.new("Frame")
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 160, 1, -80)
Sidebar.Position = UDim2.new(0, 10, 0, 70)
Sidebar.BackgroundColor3 = C.Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBCorner = Instance.new("UICorner")
SBCorner.CornerRadius = UDim.new(0, 12)
SBCorner.Parent = Sidebar

local TabList = Instance.new("Frame")
TabList.Size = UDim2.new(1, -16, 1, -16)
TabList.Position = UDim2.new(0, 8, 0, 8)
TabList.BackgroundTransparency = 1
TabList.Parent = Sidebar

local TabLayout = Instance.new("UIListLayout")
TabLayout.Parent = TabList
TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
TabLayout.Padding = UDim.new(0, 6)

print("✅ Sidebar สร้างเสร็จ")

-- ================================================================
-- CONTENT AREA
-- ================================================================
local Content = Instance.new("Frame")
Content.Name = "Content"
Content.Size = UDim2.new(1, -190, 1, -80)
Content.Position = UDim2.new(0, 180, 0, 70)
Content.BackgroundColor3 = C.Panel
Content.BorderSizePixel = 0
Content.Parent = Main

local CNCorner = Instance.new("UICorner")
CNCorner.CornerRadius = UDim.new(0, 12)
CNCorner.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Name = "Scroll"
Scroll.Size = UDim2.new(1, -16, 1, -16)
Scroll.Position = UDim2.new(0, 8, 0, 8)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 6
Scroll.ScrollBarImageColor3 = C.Purple
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Content

local ScrollLayout = Instance.new("UIListLayout")
ScrollLayout.Parent = Scroll
ScrollLayout.SortOrder = Enum.SortOrder.LayoutOrder
ScrollLayout.Padding = UDim.new(0, 6)

ScrollLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ScrollLayout.AbsoluteContentSize.Y + 20)
end)

print("✅ Content สร้างเสร็จ")

-- ================================================================
-- HOVER LOCK
-- ================================================================
Main.MouseEnter:Connect(function() uiHovering = true end)
Main.MouseLeave:Connect(function() uiHovering = false end)

-- ================================================================
-- DRAG
-- ================================================================
local dragging = false
local dragStart, startPos
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

-- ================================================================
-- UI FACTORY
-- ================================================================
local Tabs = {}
local FirstTab = true

-- ฟังก์ชันสร้างแท็บ
local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 40)
    Btn.BackgroundColor3 = C.Card
    Btn.BackgroundTransparency = 0.5
    Btn.Text = " " .. icon .. "  " .. name
    Btn.TextColor3 = C.TextDim
    Btn.TextSize = 13
    Btn.Font = Enum.Font.GothamBold
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.BorderSizePixel = 0
    Btn.AutoButtonColor = false
    Btn.Parent = TabList

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 8)
    BC.Parent = Btn

    local Page = Instance.new("Frame")
    Page.Name = "Page_" .. name
    Page.Size = UDim2.new(1, 0, 0, 0)
    Page.BackgroundTransparency = 1
    Page.BorderSizePixel = 0
    Page.Visible = false
    Page.AutomaticSize = Enum.AutomaticSize.Y
    Page.Parent = Scroll

    local PageLayout = Instance.new("UIListLayout")
    PageLayout.Parent = Page
    PageLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PageLayout.Padding = UDim.new(0, 6)

    table.insert(Tabs, {Btn = Btn, Page = Page})

    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            t.Btn.BackgroundTransparency = 0.5
            t.Btn.TextColor3 = C.TextDim
        end
        Page.Visible = true
        Btn.BackgroundTransparency = 0.2
        Btn.TextColor3 = C.Text
    end)

    if FirstTab then
        FirstTab = false
        Page.Visible = true
        Btn.BackgroundTransparency = 0.2
        Btn.TextColor3 = C.Text
    end

    return Page
end

-- Section
local function Section(parent, title)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, 0, 0, 24)
    S.BackgroundTransparency = 1
    S.Text = "▸ " .. title
    S.TextColor3 = C.Purple
    S.TextSize = 12
    S.Font = Enum.Font.GothamBold
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.LayoutOrder = 0
    S.Parent = parent
end

-- Toggle
local function Toggle(parent, name, desc, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 50)
    F.BackgroundColor3 = C.Card
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.LayoutOrder = 1
    F.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -80, 0, 20)
    L.Position = UDim2.new(0, 12, 0, 6)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = C.Text
    L.TextSize = 13
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -80, 0, 16)
    D.Position = UDim2.new(0, 12, 0, 26)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = C.TextDim
    D.TextSize = 10
    D.Font = Enum.Font.Gotham
    D.TextXAlignment = Enum.TextXAlignment.Left
    D.Parent = F

    local Bg = Instance.new("Frame")
    Bg.Size = UDim2.new(0, 44, 0, 22)
    Bg.Position = UDim2.new(1, -56, 0.5, -11)
    Bg.BackgroundColor3 = CFG[key] and C.Purple or C.Card
    Bg.BorderSizePixel = 0
    Bg.Parent = F

    local BgC = Instance.new("UICorner")
    BgC.CornerRadius = UDim.new(1, 0)
    BgC.Parent = Bg

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 18, 0, 18)
    Dot.Position = CFG[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    Dot.BackgroundColor3 = Color3.new(1, 1, 1)
    Dot.BorderSizePixel = 0
    Dot.Parent = Bg

    local DotC = Instance.new("UICorner")
    DotC.CornerRadius = UDim.new(1, 0)
    DotC.Parent = Dot

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = F

    Btn.MouseButton1Click:Connect(function()
        CFG[key] = not CFG[key]
        Bg.BackgroundColor3 = CFG[key] and C.Purple or C.Card
        Dot.Position = CFG[key] and UDim2.new(1, -20, 0.5, -9) or UDim2.new(0, 2, 0.5, -9)
    end)
end

-- Slider
local function Slider(parent, name, minV, maxV, key)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 60)
    F.BackgroundColor3 = C.Card
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.LayoutOrder = 1
    F.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -24, 0, 20)
    L.Position = UDim2.new(0, 12, 0, 6)
    L.BackgroundTransparency = 1
    L.Text = name .. " : " .. CFG[key]
    L.TextColor3 = C.Text
    L.TextSize = 13
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local BarBg = Instance.new("Frame")
    BarBg.Size = UDim2.new(1, -24, 0, 8)
    BarBg.Position = UDim2.new(0, 12, 0, 36)
    BarBg.BackgroundColor3 = C.Bg
    BarBg.BorderSizePixel = 0
    BarBg.Parent = F

    local BarBgC = Instance.new("UICorner")
    BarBgC.CornerRadius = UDim.new(1, 0)
    BarBgC.Parent = BarBg

    local ratio = math.clamp((CFG[key] - minV) / (maxV - minV), 0, 1)
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new(ratio, 0, 1, 0)
    Fill.BackgroundColor3 = C.Purple
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local FillC = Instance.new("UICorner")
    FillC.CornerRadius = UDim.new(1, 0)
    FillC.Parent = Fill

    local dragging = false
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 3, 0)
    Btn.Position = UDim2.new(0, 0, -1, 0)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""
    Btn.Parent = BarBg

    local function Update(input)
        local r = math.clamp((input.Position.X - BarBg.AbsolutePosition.X) / BarBg.AbsoluteSize.X, 0, 1)
        local v = math.floor(minV + r * (maxV - minV))
        Fill.Size = UDim2.new(r, 0, 1, 0)
        L.Text = name .. " : " .. v
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

-- Button
local function ActionButton(parent, name, desc, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, 0, 0, 50)
    F.BackgroundColor3 = C.Card
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.LayoutOrder = 1
    F.Parent = parent

    local FC = Instance.new("UICorner")
    FC.CornerRadius = UDim.new(0, 8)
    FC.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -24, 0, 20)
    L.Position = UDim2.new(0, 12, 0, 6)
    L.BackgroundTransparency = 1
    L.Text = name
    L.TextColor3 = C.Text
    L.TextSize = 13
    L.Font = Enum.Font.GothamBold
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local D = Instance.new("TextLabel")
    D.Size = UDim2.new(1, -24, 0, 16)
    D.Position = UDim2.new(0, 12, 0, 26)
    D.BackgroundTransparency = 1
    D.Text = desc or ""
    D.TextColor3 = C.TextDim
    D.TextSize = 10
    D.Font = Enum.Font.Gotham
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

print("✅ UI Factory สร้างเสร็จ")

-- ================================================================
-- สร้างแท็บทั้งหมด
-- ================================================================
print("🎨 สร้างแท็บ...")

local HomeTab = CreateTab("หน้าหลัก", "🏠")
local FarmTab = CreateTab("ฟาร์ม", "🌾")
local BossTab = CreateTab("บอส", "👹")
local SkillTab = CreateTab("สกิล", "🥋")
local SetTab = CreateTab("ตั้งค่า", "🔧")

print("✅ สร้างแท็บ 5 อันเสร็จ")

-- ===== HOME =====
Section(HomeTab, "📊 Live Status")
ActionButton(HomeTab, "🔍 ตรวจสอบสถานะ", "แสดงข้อมูล", function()
    local c = Char()
    local tool = c and c:FindFirstChildOfClass("Tool")
    print("🎮 Level: " .. SafeGet(LP.Data, "Level"))
    print("💰 Beli: " .. FormatNum(SafeGet(LP.Data, "Beli")))
    print("🔧 Tool: " .. (tool and tool.Name or "❌"))
    print("📜 Quest: " .. (HasQuest() and "✅" or "❌") .. " | " .. GetCurrentQuestName())
    print("👾 Mobs: " .. #(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}))
end)
ActionButton(HomeTab, "📜 Force รับเควสต์", "บังคับรับเควสต์", function()
    currentQuest = nil
    lastQuestAttempt = 0
    GetQuest()
end)
ActionButton(HomeTab, "🎁 Redeem All Codes", "ใส่โค้ดทั้งหมด", function()
    local codes = {"Sub2Fer999", "Enyu_is_Pro", "Magicbus", "JCWK", "Starcodeheo",
                   "Bluxxy", "fudd10", "fudd10_v2", "Sub2OfficialNoobie",
                   "SUB2GAMERROBOT_EXP1", "Sub2NoobMaster123", "Sub2UncleKizaru",
                   "Sub2Daigrock", "Axiore", "TantaiGaming", "StrawHatMaine",
                   "Sub2CaptainMaui", "Kittgaming", "Sub2Gamerrobot_Reset1",
                   "FUDD10", "BIGNEWS", "THEGREATACE"}
    for _, code in pairs(codes) do
        pcall(function() RS.Remotes.Redeem:InvokeServer(code) end)
        task.wait(0.5)
    end
end)

-- ===== FARM =====
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

-- ===== BOSS =====
Section(BossTab, "👹 Auto Boss")
Toggle(BossTab, "Auto Boss", "ตีบอสทุกตัว", "AutoBoss")
Toggle(BossTab, "Auto Elite Hunter", "ปืน Yama/Tushita", "AutoEliteHunter")
Toggle(BossTab, "Auto Raid", "เปิด Raid", "AutoRaid")

-- ===== SKILL =====
Section(SkillTab, "🥋 Combat")
Toggle(SkillTab, "Auto Skill", "กด Z X C V F E Q R", "AutoSkill")
Toggle(SkillTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", "AutoHaki")
Toggle(SkillTab, "Fast Attack", "Bypass Cooldown", "FastAttack")

-- ===== SETTINGS =====
Section(SetTab, "🏃 Character")
Slider(SetTab, "WalkSpeed", 16, 500, "WalkSpeed")
Slider(SetTab, "JumpPower", 50, 500, "JumpPower")
Toggle(SetTab, "No Clip", "ทะลุกำแพง", "NoClip")
Section(SetTab, "⚙️ System")
ActionButton(SetTab, "🚀 Rejoin Server", "กลับเซิร์ฟเดิม", function()
    TPS:Teleport(game.PlaceId, LP)
end)
ActionButton(SetTab, "❌ ปิด UI", "ปิดหน้าต่าง", function()
    pcall(function() SG:Destroy() end)
end)

print("✅ สร้างทุกอย่างเสร็จ — UI ควรขึ้นแล้ว!")
print("═══════════════════════════════════════")
print("🔥 ถ้าไม่เห็น UI → แจ้งผมว่า")
print("   1. Executor อะไร")
print("   2. Console ขึ้น print ถึงบรรทัดไหน")
print("   3. เห็นอะไรกลางจอไหม")
print("═══════════════════════════════════════")
