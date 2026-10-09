--[[
    🤖 Rbot - Blox Fruits Premium Edition
    UI สวย Glassmorphism + Animation
    ใช้กับ Alt Account เท่านั้น!
]]

-- ================== SERVICES ==================
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local UserInput = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer

-- ================== CHECK ==================
local WORLD = {[2753915549]="Sea 1",[4442272183]="Sea 2",[7449423635]="Sea 3"}
if not WORLD[game.PlaceId] then warn("❌ ใช้กับ Blox Fruits เท่านั้น!") return end

local CommF = RS:WaitForChild("Remotes"):WaitForChild("CommF_")

-- ================== CONFIG ==================
local CFG = {
    AutoFarmLevel = false, AutoFarmBoss = false, AutoFarmChest = false,
    MagnetToken = false, AutoEquipWeapon = false, SelectedWeapon = "-- None --",
    SelectedBoss = "-- None --", AutoSkill = true, AutoHaki = true,
    FastAttack = true, NoClip = false, AntiAFK = true,
    WalkSpeed = 16, JumpPower = 50, FarmDistance = 30,
}

-- ================== HELPERS ==================
local function C() return LP.Character or LP.CharacterAdded:Wait() end
local function HRP() return C():WaitForChild("HumanoidRootPart") end
local function HUM() return C():WaitForChild("Humanoid") end

local function Equip(n)
    local bp = LP:FindFirstChild("Backpack"); local ch = C()
    if bp and bp:FindFirstChild(n) then HUM():EquipTool(bp[n])
    elseif ch:FindFirstChild(n) then HUM():EquipTool(ch[n]) end
end

local function Click()
    VirtualUser:CaptureController()
    VirtualUser:ClickButton1(Vector2.new(851, 158))
end

local function Key(k)
    VIM:SendKeyEvent(true, k, false, game); task.wait(0.1)
    VIM:SendKeyEvent(false, k, false, game)
end

local function Tween(cf)
    local h = HRP()
    local d = (cf.Position - h.Position).Magnitude
    local s = d > 1000 and 250 or 350
    local t = TweenService:Create(h, TweenInfo.new(d/s, Enum.EasingStyle.Linear), {CFrame = cf})
    t:Play(); return t
end

local function Skills()
    if not CFG.AutoSkill then return end
    for _, k in pairs({"Z","X","C","V"}) do
        if C():FindFirstChildOfClass("Tool") then Key(k) end
    end
end

-- ================== QUEST DATA ==================
local QUEST = {
    [2753915549] = {
        {min=1,max=9,mob="Bandit [Lv. 5]",name="Bandit",quest="BanditQuest1",level=1,qCF=CFrame.new(1059,15,1550),mCF=CFrame.new(1353,3,1376)},
        {min=10,max=14,mob="Monkey [Lv. 14]",name="Monkey",quest="JungleQuest",level=1,qCF=CFrame.new(-1598,35,153),mCF=CFrame.new(-1402,98,90)},
        {min=15,max=29,mob="Gorilla [Lv. 20]",name="Gorilla",quest="JungleQuest",level=2,qCF=CFrame.new(-1598,35,153),mCF=CFrame.new(-1267,66,-531)},
        {min=30,max=39,mob="Pirate [Lv. 35]",name="Pirate",quest="BuggyQuest1",level=1,qCF=CFrame.new(-1141,4,3831),mCF=CFrame.new(-1169,5,3933)},
        {min=40,max=59,mob="Brute [Lv. 45]",name="Brute",quest="BuggyQuest1",level=2,qCF=CFrame.new(-1141,4,3831),mCF=CFrame.new(-1165,15,4363)},
        {min=60,max=74,mob="Desert Bandit [Lv. 60]",name="Desert Bandit",quest="DesertQuest",level=1,qCF=CFrame.new(894,5,4392),mCF=CFrame.new(932,6,4488)},
        {min=75,max=89,mob="Desert Officer [Lv. 70]",name="Desert Officer",quest="DesertQuest",level=2,qCF=CFrame.new(894,5,4392),mCF=CFrame.new(1617,1,4295)},
        {min=90,max=99,mob="Snow Bandit [Lv. 90]",name="Snow Bandits",quest="SnowQuest",level=1,qCF=CFrame.new(1389,86,-1298),mCF=CFrame.new(1412,55,-1260)},
        {min=100,max=119,mob="Snowman [Lv. 100]",name="Snowman",quest="SnowQuest",level=2,qCF=CFrame.new(1389,86,-1298),mCF=CFrame.new(1376,97,-1396)},
        {min=120,max=149,mob="Chief Petty Officer [Lv. 120]",name="Chief Petty Officer",quest="MarineQuest2",level=1,qCF=CFrame.new(-5039,27,4324),mCF=CFrame.new(-4882,22,4255)},
        {min=150,max=174,mob="Sky Bandit [Lv. 150]",name="Sky Bandit",quest="SkyQuest",level=1,qCF=CFrame.new(-4839,716,-2619),mCF=CFrame.new(-4959,365,-2974)},
        {min=175,max=189,mob="Dark Master [Lv. 175]",name="Dark Master",quest="SkyQuest",level=2,qCF=CFrame.new(-4839,716,-2619),mCF=CFrame.new(-5079,376,-2194)},
        {min=190,max=209,mob="Prisoner [Lv. 190]",name="Prisoner",quest="PrisonerQuest",level=1,qCF=CFrame.new(5308,1,475),mCF=CFrame.new(5433,88,514)},
        {min=210,max=249,mob="Dangerous Prisoner [Lv. 210]",name="Dangerous Prisoner",quest="PrisonerQuest",level=2,qCF=CFrame.new(5308,1,475),mCF=CFrame.new(5433,88,514)},
        {min=250,max=274,mob="Toga Warrior [Lv. 250]",name="Toga Warrior",quest="ColosseumQuest",level=1,qCF=CFrame.new(-1576,7,-2983),mCF=CFrame.new(-1779,44,-2736)},
        {min=275,max=299,mob="Gladiator [Lv. 275]",name="Gladiator",quest="ColosseumQuest",level=2,qCF=CFrame.new(-1576,7,-2983),mCF=CFrame.new(-1274,58,-3188)},
        {min=300,max=329,mob="Military Soldier [Lv. 300]",name="Military Soldier",quest="MagmaQuest",level=1,qCF=CFrame.new(-5316,12,8517),mCF=CFrame.new(-5363,41,8548)},
        {min=330,max=374,mob="Military Spy [Lv. 325]",name="Military Spy",quest="MagmaQuest",level=2,qCF=CFrame.new(-5316,12,8517),mCF=CFrame.new(-5787,120,8762)},
        {min=375,max=399,mob="Fishman Warrior [Lv. 375]",name="Fishman Warrior",quest="FishmanQuest",level=1,qCF=CFrame.new(61122,18,1568),mCF=CFrame.new(60946,48,1525)},
        {min=400,max=449,mob="Fishman Commando [Lv. 400]",name="Fishman Commando",quest="FishmanQuest",level=2,qCF=CFrame.new(61122,18,1568),mCF=CFrame.new(60946,48,1525)},
        {min=450,max=474,mob="God's Guard [Lv. 450]",name="God's Guards",quest="SkyExp1Quest",level=1,qCF=CFrame.new(-4721,845,-1954),mCF=CFrame.new(-4716,853,-1933)},
        {min=475,max=524,mob="Shanda [Lv. 475]",name="Shandas",quest="SkyExp1Quest",level=2,qCF=CFrame.new(-7859,5544,-381),mCF=CFrame.new(-7904,5584,-459)},
        {min=525,max=549,mob="Royal Squad [Lv. 525]",name="Royal Squad",quest="SkyExp2Quest",level=1,qCF=CFrame.new(-7906,5634,-1411),mCF=CFrame.new(-7555,5606,-1303)},
        {min=550,max=624,mob="Royal Soldier [Lv. 550]",name="Royal Soldier",quest="SkyExp2Quest",level=2,qCF=CFrame.new(-7906,5634,-1411),mCF=CFrame.new(-7837,5649,-1791)},
        {min=625,max=649,mob="Galley Pirate [Lv. 625]",name="Galley Pirate",quest="FountainQuest",level=1,qCF=CFrame.new(5259,37,4050),mCF=CFrame.new(5569,38,3849)},
        {min=650,max=699,mob="Galley Captain [Lv. 650]",name="Galley Captain",quest="FountainQuest",level=2,qCF=CFrame.new(5259,37,4050),mCF=CFrame.new(5782,94,4716)},
    },
    [4442272183] = {
        {min=700,max=724,mob="Raider [Lv. 700]",name="Raider",quest="Area1Quest",level=1,qCF=CFrame.new(-429,71,1836),mCF=CFrame.new(-737,10,2392)},
        {min=725,max=774,mob="Mercenary [Lv. 725]",name="Mercenary",quest="Area1Quest",level=2,qCF=CFrame.new(-429,71,1836),mCF=CFrame.new(-1022,72,1891)},
        {min=775,max=799,mob="Swan Pirate [Lv. 775]",name="Swan Pirate",quest="Area2Quest",level=1,qCF=CFrame.new(638,71,918),mCF=CFrame.new(976,111,1229)},
        {min=800,max=874,mob="Factory Staff [Lv. 800]",name="Factory Staff",quest="Area2Quest",level=2,qCF=CFrame.new(638,71,918),mCF=CFrame.new(336,73,-224)},
        {min=875,max=899,mob="Marine Lieutenant [Lv. 875]",name="Marine Lieutenant",quest="MarineQuest3",level=1,qCF=CFrame.new(-2440,71,-3216),mCF=CFrame.new(-2842,72,-2901)},
        {min=900,max=949,mob="Marine Captain [Lv. 900]",name="Marine Captain",quest="MarineQuest3",level=2,qCF=CFrame.new(-2440,71,-3216),mCF=CFrame.new(-1814,72,-3208)},
        {min=950,max=974,mob="Zombie [Lv. 950]",name="Zombie",quest="ZombieQuest",level=1,qCF=CFrame.new(-5497,47,-795),mCF=CFrame.new(-5649,126,-737)},
        {min=975,max=999,mob="Vampire [Lv. 975]",name="Vampire",quest="ZombieQuest",level=2,qCF=CFrame.new(-5497,47,-795),mCF=CFrame.new(-6030,0,-1313)},
        {min=1000,max=1049,mob="Snow Trooper [Lv. 1000]",name="Snow Trooper",quest="SnowMountainQuest",level=1,qCF=CFrame.new(609,400,-5372),mCF=CFrame.new(621,391,-5335)},
        {min=1050,max=1099,mob="Winter Warrior [Lv. 1050]",name="Winter Warrior",quest="SnowMountainQuest",level=2,qCF=CFrame.new(609,400,-5372),mCF=CFrame.new(1295,429,-5087)},
        {min=1100,max=1124,mob="Lab Subordinate [Lv. 1100]",name="Lab Subordinate",quest="IceSideQuest",level=1,qCF=CFrame.new(-6064,15,-4902),mCF=CFrame.new(-5769,37,-4468)},
        {min=1125,max=1174,mob="Horned Warrior [Lv. 1125]",name="Horned Warrior",quest="IceSideQuest",level=2,qCF=CFrame.new(-6064,15,-4902),mCF=CFrame.new(-6401,15,-5948)},
        {min=1175,max=1199,mob="Magma Ninja [Lv. 1175]",name="Magma Ninja",quest="FireSideQuest",level=1,qCF=CFrame.new(-5428,15,-5299),mCF=CFrame.new(-5466,57,-5837)},
        {min=1200,max=1249,mob="Lava Pirate [Lv. 1200]",name="Lava Pirate",quest="FireSideQuest",level=2,qCF=CFrame.new(-5431,15,-5296),mCF=CFrame.new(-5169,34,-4669)},
        {min=1250,max=1274,mob="Ship Deckhand [Lv. 1250]",name="Ship Deckhand",quest="ShipQuest1",level=1,qCF=CFrame.new(1037,125,32911),mCF=CFrame.new(1163,138,33058)},
        {min=1275,max=1299,mob="Ship Engineer [Lv. 1275]",name="Ship Engineer",quest="ShipQuest1",level=2,qCF=CFrame.new(1037,125,32911),mCF=CFrame.new(921,125,32937)},
        {min=1300,max=1324,mob="Ship Steward [Lv. 1300]",name="Ship Steward",quest="ShipQuest2",level=1,qCF=CFrame.new(968,125,33244),mCF=CFrame.new(917,136,33343)},
        {min=1325,max=1349,mob="Ship Officer [Lv. 1325]",name="Ship Officer",quest="ShipQuest2",level=2,qCF=CFrame.new(968,125,33244),mCF=CFrame.new(944,181,33278)},
        {min=1350,max=1374,mob="Arctic Warrior [Lv. 1350]",name="Arctic Warrior",quest="FrostQuest",level=1,qCF=CFrame.new(5667,26,-6486),mCF=CFrame.new(5878,81,-6136)},
        {min=1375,max=1424,mob="Snow Lurker [Lv. 1375]",name="Snow Lurker",quest="FrostQuest",level=2,qCF=CFrame.new(5667,26,-6486),mCF=CFrame.new(5513,60,-6809)},
        {min=1425,max=1449,mob="Sea Soldier [Lv. 1425]",name="Sea Soldier",quest="ForgottenQuest",level=1,qCF=CFrame.new(-3054,235,-10142),mCF=CFrame.new(-3115,63,-9808)},
        {min=1450,max=1499,mob="Water Fighter [Lv. 1450]",name="Water Fighter",quest="ForgottenQuest",level=2,qCF=CFrame.new(-3054,235,-10142),mCF=CFrame.new(-3212,263,-10551)},
    },
    [7449423635] = {
        {min=1500,max=1524,mob="Pirate Millionaire [Lv. 1500]",name="Pirate Millionaire",quest="PiratePortQuest",level=1,qCF=CFrame.new(-290,42,5581),mCF=CFrame.new(81,43,5724)},
        {min=1525,max=1574,mob="Pistol Billionaire [Lv. 1525]",name="Pistol Billionaire",quest="PiratePortQuest",level=2,qCF=CFrame.new(-290,42,5581),mCF=CFrame.new(81,43,5724)},
        {min=1575,max=1599,mob="Dragon Crew Warrior [Lv. 1575]",name="Dragon Crew Warrior",quest="AmazonQuest",level=1,qCF=CFrame.new(5832,51,-1101),mCF=CFrame.new(6241,51,-1243)},
        {min=1600,max=1624,mob="Dragon Crew Archer [Lv. 1600]",name="Dragon Crew Archer",quest="AmazonQuest",level=2,qCF=CFrame.new(5832,51,-1101),mCF=CFrame.new(6488,383,-110)},
        {min=1625,max=1649,mob="Female Islander [Lv. 1625]",name="Female Islander",quest="AmazonQuest2",level=1,qCF=CFrame.new(5448,601,751),mCF=CFrame.new(4770,758,1069)},
        {min=1650,max=1699,mob="Giant Islander [Lv. 1650]",name="Giant Islander",quest="AmazonQuest2",level=2,qCF=CFrame.new(5448,601,751),mCF=CFrame.new(4530,656,-131)},
        {min=1700,max=1724,mob="Marine Commodore [Lv. 1700]",name="Marine Commodore",quest="MarineTreeIsland",level=1,qCF=CFrame.new(2180,27,-6741),mCF=CFrame.new(2490,190,-7160)},
        {min=1725,max=1774,mob="Marine Rear Admiral [Lv. 1725]",name="Marine Rear Admiral",quest="MarineTreeIsland",level=2,qCF=CFrame.new(2180,27,-6741),mCF=CFrame.new(3951,229,-6912)},
        {min=1775,max=1799,mob="Fishman Raider [Lv. 1775]",name="Fishman Raider",quest="DeepForestIsland3",level=1,qCF=CFrame.new(-10581,330,-8761),mCF=CFrame.new(-10322,390,-8580)},
        {min=1800,max=1824,mob="Fishman Captain [Lv. 1800]",name="Fishman Captain",quest="DeepForestIsland3",level=2,qCF=CFrame.new(-10581,330,-8761),mCF=CFrame.new(-11194,442,-8608)},
        {min=1825,max=1849,mob="Forest Pirate [Lv. 1825]",name="Forest Pirate",quest="DeepForestIsland",level=1,qCF=CFrame.new(-13234,331,-7625),mCF=CFrame.new(-13225,428,-7753)},
        {min=1850,max=1899,mob="Mythological Pirate [Lv. 1850]",name="Mythological Pirate",quest="DeepForestIsland",level=2,qCF=CFrame.new(-13234,331,-7625),mCF=CFrame.new(-13869,564,-7084)},
        {min=1900,max=1924,mob="Jungle Pirate [Lv. 1900]",name="Jungle Pirate",quest="DeepForestIsland2",level=1,qCF=CFrame.new(-12680,389,-9902),mCF=CFrame.new(-11982,376,-10451)},
        {min=1925,max=1974,mob="Musketeer Pirate [Lv. 1925]",name="Musketeer Pirate",quest="DeepForestIsland2",level=2,qCF=CFrame.new(-12680,389,-9902),mCF=CFrame.new(-13282,496,-9565)},
        {min=1975,max=1999,mob="Reborn Skeleton [Lv. 1975]",name="Reborn Skeleton",quest="HauntedQuest1",level=1,qCF=CFrame.new(-9480,142,5566),mCF=CFrame.new(-8817,191,6298)},
        {min=2000,max=2024,mob="Living Zombie [Lv. 2000]",name="Living Zombie",quest="HauntedQuest1",level=2,qCF=CFrame.new(-9480,142,5566),mCF=CFrame.new(-10125,183,6242)},
        {min=2025,max=2049,mob="Demonic Soul [Lv. 2025]",name="Demonic Soul",quest="HauntedQuest2",level=1,qCF=CFrame.new(-9516,178,6078),mCF=CFrame.new(-9712,204,6193)},
        {min=2050,max=2074,mob="Posessed Mummy [Lv. 2050]",name="Posessed Mummy",quest="HauntedQuest2",level=2,qCF=CFrame.new(-9516,178,6078),mCF=CFrame.new(-9545,69,6339)},
        {min=2075,max=2099,mob="Peanut Scout [Lv. 2075]",name="Peanut Scout",quest="NutsIslandQuest",level=1,qCF=CFrame.new(-2104,38,-10194),mCF=CFrame.new(-2098,192,-10248)},
        {min=2100,max=2124,mob="Peanut President [Lv. 2100]",name="Peanut President",quest="NutsIslandQuest",level=2,qCF=CFrame.new(-2104,38,-10194),mCF=CFrame.new(-1876,192,-10542)},
        {min=2125,max=2149,mob="Ice Cream Chef [Lv. 2125]",name="Ice Cream Chef",quest="IceCreamIslandQuest",level=1,qCF=CFrame.new(-820,65,-10965),mCF=CFrame.new(-821,208,-10990)},
        {min=2150,max=2199,mob="Ice Cream Commander [Lv. 2150]",name="Ice Cream Commander",quest="IceCreamIslandQuest",level=2,qCF=CFrame.new(-819,67,-10967),mCF=CFrame.new(-610,208,-11253)},
        {min=2200,max=2224,mob="Cookie Crafter [Lv. 2200]",name="Cookie Crafter",quest="CakeQuest1",level=1,qCF=CFrame.new(-2020,37,-12027),mCF=CFrame.new(-2286,146,-12226)},
        {min=2225,max=2249,mob="Cake Guard [Lv. 2225]",name="Cake Guard",quest="CakeQuest1",level=2,qCF=CFrame.new(-2020,37,-12027),mCF=CFrame.new(-1817,209,-12288)},
        {min=2250,max=2274,mob="Baking Staff [Lv. 2250]",name="Baking Staff",quest="CakeQuest2",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-1818,93,-12887)},
        {min=2275,max=2299,mob="Head Baker [Lv. 2275]",name="Head Baker",quest="CakeQuest2",level=2,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2300,max=2349,mob="Cocoa Warrior [Lv. 2300]",name="Cocoa Warrior",quest="ChocoQuest1",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2350,max=2399,mob="Sweet Thief [Lv. 2350]",name="Sweet Thief",quest="ChocoQuest2",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2400,max=2449,mob="Candy Pirate [Lv. 2400]",name="Candy Pirate",quest="CandyQuest1",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2450,max=2499,mob="Isle Outlaw [Lv. 2450]",name="Isle Outlaw",quest="TikiQuest1",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2500,max=2549,mob="Sun-kissed Warrior [Lv. 2500]",name="Sun-kissed Warrior",quest="TikiQuest2",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2550,max=2599,mob="Reef Bandit [Lv. 2600]",name="Reef Bandit",quest="SubmergedQuest1",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2600,max=2649,mob="Reef Bandit [Lv. 2600]",name="Reef Bandit",quest="SubmergedQuest1",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2650,max=2699,mob="Sea Chanter [Lv. 2650]",name="Sea Chanter",quest="SubmergedQuest2",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2700,max=2749,mob="Grand Devotee [Lv. 2725]",name="Grand Devotee",quest="SubmergedQuest3",level=1,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
        {min=2750,max=9999,mob="High Disciple [Lv. 2750]",name="High Disciple",quest="SubmergedQuest3",level=3,qCF=CFrame.new(-1928,37,-12840),mCF=CFrame.new(-2288,106,-12811)},
    },
}

local function GetCurrentQuest()
    local lvl = LP.Data.Level.Value
    for _, q in pairs(QUEST[game.PlaceId]) do
        if lvl >= q.min and lvl <= q.max then return q end
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
        return getupvalues(require(LP.PlayerScripts:WaitForChild("CombatFramework")))[2]
    end)
    if not ok then return end
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
                if not C():FindFirstChild("HasBuso") then CommF:InvokeServer("Buso") end
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
                local q = GetCurrentQuest()
                if not q then return end
                local qUI = LP.PlayerGui.Main.Quest
                local qText = qUI.Container.QuestTitle.Title.Text
                if not qUI.Visible or not string.find(qText, q.name) then
                    local d = (q.qCF.Position - HRP().Position).Magnitude
                    if d > 200 then Tween(q.qCF)
                    else
                        HRP().CFrame = q.qCF
                        task.wait(0.5)
                        CommF:InvokeServer("StartQuest", q.quest, q.level)
                        task.wait(0.5)
                    end
                else
                    for _, m in pairs(workspace.Enemies:GetChildren()) do
                        if m.Name == q.mob then
                            local hrp = m:FindFirstChild("HumanoidRootPart")
                            local hum = m:FindFirstChild("Humanoid")
                            if hrp and hum and hum.Health > 0 then
                                local t = hrp.CFrame * CFrame.new(0, CFG.FarmDistance, 0)
                                if (hrp.Position - HRP().Position).Magnitude > 300 then Tween(t)
                                else
                                    HRP().CFrame = t
                                    if CFG.SelectedWeapon ~= "-- None --" then Equip(CFG.SelectedWeapon) end
                                    Click(); Skills()
                                end
                                break
                            end
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(0.5) do
        if CFG.AutoFarmBoss and CFG.SelectedBoss ~= "-- None --" then
            pcall(function()
                for _, m in pairs(workspace.Enemies:GetChildren()) do
                    if m.Name == CFG.SelectedBoss then
                        local hrp = m:FindFirstChild("HumanoidRootPart")
                        local hum = m:FindFirstChild("Humanoid")
                        if hrp and hum and hum.Health > 0 then
                            local t = hrp.CFrame * CFrame.new(0, CFG.FarmDistance, 0)
                            if (hrp.Position - HRP().Position).Magnitude > 300 then Tween(t)
                            else
                                HRP().CFrame = t
                                if CFG.SelectedWeapon ~= "-- None --" then Equip(CFG.SelectedWeapon) end
                                Click(); Skills()
                            end
                            break
                        end
                    end
                end
            end)
        end
    end
end)

task.spawn(function()
    while task.wait(1) do
        if CFG.AutoEquipWeapon and CFG.SelectedWeapon ~= "-- None --" then
            pcall(function() Equip(CFG.SelectedWeapon) end)
        end
    end
end)

-- ================================================================
-- ================== 🎨 PREMIUM UI (GLASSMORPHISM) ===============
-- ================================================================

local SG = Instance.new("ScreenGui")
SG.Name = "RbotPremium"
SG.Parent = game:GetService("CoreGui")
SG.ResetOnSpawn = false
SG.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
SG.IgnoreGuiInset = true

-- ========== BACKGROUND BLUR ==========
local Blur = Instance.new("BlurEffect")
Blur.Size = 0
Blur.Parent = game:GetService("Lighting")

-- ========== MAIN FRAME ==========
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 0, 0, 0)
Main.Position = UDim2.new(0.5, -380, 0.5, -260)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Main.BackgroundTransparency = 0.1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Parent = SG

local MC = Instance.new("UICorner")
MC.CornerRadius = UDim.new(0, 16)
MC.Parent = Main

-- Glow border
local Glow = Instance.new("ImageLabel")
Glow.Name = "Glow"
Glow.Size = UDim2.new(1, 20, 1, 20)
Glow.Position = UDim2.new(0, -10, 0, -10)
Glow.BackgroundTransparency = 1
Glow.Image = "rbxassetid://4996891970"
Glow.ImageColor3 = Color3.fromRGB(255, 60, 60)
Glow.ImageTransparency = 0.7
Glow.ScaleType = Enum.ScaleType.Slice
Glow.SliceCenter = Rect.new(20, 20, 280, 280)
Glow.Parent = Main

-- Animate open
TweenService:Create(Main, TweenInfo.new(0.6, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Size = UDim2.new(0, 760, 0, 520)
}):Play()
TweenService:Create(Blur, TweenInfo.new(0.6), {Size = 12}):Play()

-- ========== HEADER ==========
local Header = Instance.new("Frame")
Header.Name = "Header"
Header.Size = UDim2.new(1, 0, 0, 60)
Header.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
Header.BackgroundTransparency = 0
Header.BorderSizePixel = 0
Header.Parent = Main

local HC = Instance.new("UICorner")
HC.CornerRadius = UDim.new(0, 16)
HC.Parent = Header

-- Cover bottom corners of header
local HeaderCover = Instance.new("Frame")
HeaderCover.Size = UDim2.new(1, 0, 0, 20)
HeaderCover.Position = UDim2.new(0, 0, 1, -20)
HeaderCover.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
HeaderCover.BorderSizePixel = 0
HeaderCover.Parent = Header

-- Gradient
local HGrad = Instance.new("UIGradient")
HGrad.Color = ColorSequence.new{
    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 100))
}
HGrad.Rotation = 30
HGrad.Parent = Header

-- Logo
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0, 400, 1, 0)
Title.Position = UDim2.new(0, 25, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "🤖 RBOT • PREMIUM"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBlack
Title.TextSize = 22
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Header

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(0, 400, 0, 20)
SubTitle.Position = UDim2.new(0, 25, 0, 35)
SubTitle.BackgroundTransparency = 1
SubTitle.Text = "Blox Fruits | " .. WORLD[game.PlaceId] .. " | v2.2"
SubTitle.TextColor3 = Color3.fromRGB(255, 220, 220)
SubTitle.Font = Enum.Font.Gotham
SubTitle.TextSize = 12
SubTitle.TextXAlignment = Enum.TextXAlignment.Left
SubTitle.Parent = Header

-- User info
local UserInfo = Instance.new("TextLabel")
UserInfo.Size = UDim2.new(0, 250, 0, 30)
UserInfo.Position = UDim2.new(1, -270, 0.5, -15)
UserInfo.BackgroundTransparency = 1
UserInfo.Text = "👤 " .. LP.Name .. " | Lv." .. LP.Data.Level.Value
UserInfo.TextColor3 = Color3.fromRGB(255, 255, 255)
UserInfo.Font = Enum.Font.GothamBold
UserInfo.TextSize = 13
UserInfo.TextXAlignment = Enum.TextXAlignment.Right
UserInfo.Parent = Header

-- Close button
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

CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), {BackgroundTransparency = 0.85}):Play()
end)
CloseBtn.MouseButton1Click:Connect(function()
    TweenService:Create(Main, TweenInfo.new(0.4), {Size = UDim2.new(0,0,0,0), BackgroundTransparency = 1}):Play()
    TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
    task.wait(0.4)
    SG:Destroy()
    Blur:Destroy()
end)

-- ========== SIDEBAR ==========
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 180, 1, -80)
Sidebar.Position = UDim2.new(0, 15, 0, 70)
Sidebar.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Sidebar.BackgroundTransparency = 0.4
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SBC = Instance.new("UICorner")
SBC.CornerRadius = UDim.new(0, 12)
SBC.Parent = Sidebar

local SBStroke = Instance.new("UIStroke")
SBStroke.Color = Color3.fromRGB(60, 60, 75)
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

-- ========== CONTENT ==========
local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -220, 1, -80)
Content.Position = UDim2.new(0, 205, 0, 70)
Content.BackgroundColor3 = Color3.fromRGB(22, 22, 30)
Content.BackgroundTransparency = 0.4
Content.BorderSizePixel = 0
Content.Parent = Main

local CNC = Instance.new("UICorner")
CNC.CornerRadius = UDim.new(0, 12)
CNC.Parent = Content

local CNStroke = Instance.new("UIStroke")
CNStroke.Color = Color3.fromRGB(60, 60, 75)
CNStroke.Thickness = 1
CNStroke.Transparency = 0.5
CNStroke.Parent = Content

local Scroll = Instance.new("ScrollingFrame")
Scroll.Size = UDim2.new(1, -20, 1, -20)
Scroll.Position = UDim2.new(0, 10, 0, 10)
Scroll.BackgroundTransparency = 1
Scroll.BorderSizePixel = 0
Scroll.ScrollBarThickness = 3
Scroll.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
Scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
Scroll.Parent = Content

local SLLay = Instance.new("UIListLayout")
SLLay.Parent = Scroll
SLLay.SortOrder = Enum.SortOrder.LayoutOrder
SLLay.Padding = UDim.new(0, 8)

local SLPad = Instance.new("UIPadding")
SLPad.PaddingTop = UDim.new(0, 4)
SLPad.PaddingLeft = UDim.new(0, 4)
SLPad.PaddingRight = UDim.new(0, 4)
SLPad.Parent = Scroll

SLLay:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    Scroll.CanvasSize = UDim2.new(0, 0, 0, SLLay.AbsoluteContentSize.Y + 20)
end)

-- ========== DRAG ==========
local dragging, dragStart, startPos
Header.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = i.Position; startPos = Main.Position
    end
end)
Header.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)
UserInput.InputChanged:Connect(function(i)
    if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (i.Position.X - dragStart.X), startPos.Y.Scale, startPos.Y.Offset + (i.Position.Y - dragStart.Y))
    end
end)

-- ========== UI FACTORY ==========
local Tabs = {}
local firstTab = false

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 42)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    Btn.BackgroundTransparency = 0.5
    Btn.BorderSizePixel = 0
    Btn.Text = "  " .. icon .. "   " .. name
    Btn.TextColor3 = Color3.fromRGB(180, 180, 200)
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 13
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.AutoButtonColor = false
    Btn.Parent = TabList

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 8)
    c.Parent = Btn

    local indicator = Instance.new("Frame")
    indicator.Size = UDim2.new(0, 3, 0, 0)
    indicator.Position = UDim2.new(0, 0, 0.5, 0)
    indicator.AnchorPoint = Vector2.new(0, 0.5)
    indicator.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    indicator.BorderSizePixel = 0
    indicator.Parent = Btn

    local iC = Instance.new("UICorner")
    iC.CornerRadius = UDim.new(1, 0)
    iC.Parent = indicator

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

    table.insert(Tabs, {Btn = Btn, Page = page, Indicator = indicator})

    Btn.MouseEnter:Connect(function()
        if not page.Visible then
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.2, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end
    end)
    Btn.MouseLeave:Connect(function()
        if not page.Visible then
            TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(180,180,200)}):Play()
        end
    end)
    Btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Page.Visible = false
            TweenService:Create(t.Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.5, TextColor3 = Color3.fromRGB(180,180,200)}):Play()
            TweenService:Create(t.Indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 0)}):Play()
        end
        page.Visible = true
        TweenService:Create(Btn, TweenInfo.new(0.2), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(indicator, TweenInfo.new(0.2), {Size = UDim2.new(0, 3, 0, 24)}):Play()
    end)

    if not firstTab then
        firstTab = true
        page.Visible = true
        Btn.BackgroundTransparency = 0
        Btn.TextColor3 = Color3.fromRGB(255,255,255)
        indicator.Size = UDim2.new(0, 3, 0, 24)
    end

    return page
end

local function CreateSection(parent, title)
    local S = Instance.new("TextLabel")
    S.Size = UDim2.new(1, 0, 0, 28)
    S.BackgroundTransparency = 1
    S.Text = "  " .. title
    S.TextColor3 = Color3.fromRGB(255, 120, 120)
    S.Font = Enum.Font.GothamBold
    S.TextSize = 12
    S.TextXAlignment = Enum.TextXAlignment.Left
    S.Parent = parent
end

local function CreateToggle(parent, name, desc, getter, setter)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 56)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 60, 80)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

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
    Bg.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
    Bg.BorderSizePixel = 0
    Bg.Parent = F

    local bgc = Instance.new("UICorner")
    bgc.CornerRadius = UDim.new(1, 0)
    bgc.Parent = Bg

    local Dot = Instance.new("Frame")
    Dot.Size = UDim2.new(0, 20, 0, 20)
    Dot.Position = UDim2.new(0, 2, 0.5, -10)
    Dot.BackgroundColor3 = Color3.fromRGB(200, 200, 210)
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

    local function Update(state)
        if state then
            TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(255, 60, 60)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(1, -22, 0.5, -10), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
        else
            TweenService:Create(Bg, TweenInfo.new(0.25), {BackgroundColor3 = Color3.fromRGB(50, 50, 65)}):Play()
            TweenService:Create(Dot, TweenInfo.new(0.25), {Position = UDim2.new(0, 2, 0.5, -10), BackgroundColor3 = Color3.fromRGB(200, 200, 210)}):Play()
        end
    end

    Btn.MouseButton1Click:Connect(function()
        local v = not getter(); setter(v); Update(v)
    end)

    Update(getter())
end

local function CreateButton(parent, name, desc, callback)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 56)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 60, 80)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

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

    Btn.MouseEnter:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(45, 45, 60), BackgroundTransparency = 0.1}):Play()
    end)
    Btn.MouseLeave:Connect(function()
        TweenService:Create(F, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(32, 32, 42), BackgroundTransparency = 0.3}):Play()
    end)
    Btn.MouseButton1Click:Connect(function() pcall(callback) end)
end

local function CreateSlider(parent, name, min, max, default, setter)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 66)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 60, 80)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(1, -30, 0, 24)
    L.Position = UDim2.new(0, 16, 0, 8)
    L.BackgroundTransparency = 1
    L.Text = name .. " : " .. default
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

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
    Fill.BorderSizePixel = 0
    Fill.Parent = BarBg

    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local FG = Instance.new("UIGradient")
    FG.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 30, 100))
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
        setter(v)
    end

    Btn.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true; Update(i)
        end
    end)
    Btn.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UserInput.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            Update(i)
        end
    end)
end

local function CreateDropdown(parent, name, options, setter)
    local F = Instance.new("Frame")
    F.Size = UDim2.new(1, -8, 0, 48)
    F.BackgroundColor3 = Color3.fromRGB(32, 32, 42)
    F.BackgroundTransparency = 0.3
    F.BorderSizePixel = 0
    F.ClipsDescendants = true
    F.Parent = parent

    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, 10)
    c.Parent = F

    local strk = Instance.new("UIStroke")
    strk.Color = Color3.fromRGB(60, 60, 80)
    strk.Thickness = 1
    strk.Transparency = 0.6
    strk.Parent = F

    local L = Instance.new("TextButton")
    L.Size = UDim2.new(1, 0, 0, 48)
    L.BackgroundTransparency = 1
    L.Text = "  " .. name .. " : " .. (options[1] or "-- None --") .. "   ▼"
    L.TextColor3 = Color3.fromRGB(240, 240, 250)
    L.Font = Enum.Font.GothamBold
    L.TextSize = 13
    L.TextXAlignment = Enum.TextXAlignment.Left
    L.Parent = F

    local List = Instance.new("ScrollingFrame")
    List.Size = UDim2.new(1, -12, 0, 0)
    List.Position = UDim2.new(0, 6, 0, 50)
    List.BackgroundTransparency = 1
    List.BorderSizePixel = 0
    List.ScrollBarThickness = 3
    List.ScrollBarImageColor3 = Color3.fromRGB(255, 60, 60)
    List.CanvasSize = UDim2.new(0, 0, 0, #options * 30)
    List.Parent = F

    local LLay = Instance.new("UIListLayout")
    LLay.Parent = List
    LLay.Padding = UDim.new(0, 2)

    local opened = false

    for _, opt in pairs(options) do
        local O = Instance.new("TextButton")
        O.Size = UDim2.new(1, 0, 0, 28)
        O.BackgroundColor3 = Color3.fromRGB(42, 42, 55)
        O.BackgroundTransparency = 0.2
        O.Text = "  " .. opt
        O.TextColor3 = Color3.fromRGB(220, 220, 240)
        O.Font = Enum.Font.Gotham
        O.TextSize = 12
        O.TextXAlignment = Enum.TextXAlignment.Left
        O.Parent = List

        local oc = Instance.new("UICorner")
        oc.CornerRadius = UDim.new(0, 6)
        oc.Parent = O

        O.MouseEnter:Connect(function()
            TweenService:Create(O, TweenInfo.new(0.15), {BackgroundTransparency = 0}):Play()
        end)
        O.MouseLeave:Connect(function()
            TweenService:Create(O, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
        end)

        O.MouseButton1Click:Connect(function()
            L.Text = "  " .. name .. " : " .. opt .. "   ▼"
            setter(opt)
            opened = false
            TweenService:Create(F, TweenInfo.new(0.2), {Size = UDim2.new(1, -8, 0, 48)}):Play()
        end)
    end

    L.MouseButton1Click:Connect(function()
        opened = not opened
        if opened then
            local h = math.min(#options, 5) * 30 + 8
            TweenService:Create(F, TweenInfo.new(0.25), {Size = UDim2.new(1, -8, 0, 48 + h)}):Play()
        else
            TweenService:Create(F, TweenInfo.new(0.25), {Size = UDim2.new(1, -8, 0, 48)}):Play()
        end
    end)
end

-- ========== TABS ==========
local HomeTab = CreateTab("หน้าหลัก", "🏠")
local FarmTab = CreateTab("ฟาร์ม", "🌾")
local BossTab = CreateTab("บอส", "👹")
local MiscTab = CreateTab("อื่นๆ", "⚙️")
local SettingTab = CreateTab("ตั้งค่า", "🔧")

-- ========== HOME ==========
CreateSection(HomeTab, "ข้อมูลระบบ")
CreateButton(HomeTab, "🤖 Rbot Premium v2.2", "Blox Fruits Edition | " .. WORLD[game.PlaceId], function() end)
CreateButton(HomeTab, "📊 สถิติปัจจุบัน", "Level: " .. LP.Data.Level.Value .. " | " .. LP.Name, function() end)
CreateSection(HomeTab, "วิธีใช้")
CreateButton(HomeTab, "⌨️ ปุ่มลัด", "กด Right Ctrl เพื่อซ่อน/แสดง UI", function() end)

-- ========== FARM ==========
CreateSection(FarmTab, "ฟาร์มหลัก")
CreateToggle(FarmTab, "Auto Farm Level", "ฟาร์มทุกโลก Sea 1/2/3 อัตโนมัติ", function() return CFG.AutoFarmLevel end, function(v) CFG.AutoFarmLevel = v end)
CreateToggle(FarmTab, "Magnet Token", "ดึงมอนเข้าหาเพื่อเก็บ Token", function() return CFG.MagnetToken end, function(v) CFG.MagnetToken = v end)

CreateSection(FarmTab, "อาวุธ")
local WList = {"-- None --"}
for _, t in pairs(LP:FindFirstChild("Backpack"):GetChildren()) do
    if t:IsA("Tool") then table.insert(WList, t.Name) end
end
CreateDropdown(FarmTab, "เลือกอาวุธ", WList, function(v) CFG.SelectedWeapon = v end)
CreateToggle(FarmTab, "Auto Equip Weapon", "ใส่อาวุธอัตโนมัติ", function() return CFG.AutoEquipWeapon end, function(v) CFG.AutoEquipWeapon = v end)

-- ========== BOSS ==========
CreateSection(BossTab, "ฟาร์มบอส")
CreateToggle(BossTab, "Auto Farm Boss", "ฟาร์มบอสที่เลือกอัตโนมัติ", function() return CFG.AutoFarmBoss end, function(v) CFG.AutoFarmBoss = v end)

local BList = {"-- None --"}
for _, v in pairs(RS:GetChildren()) do
    if v.Name:find("Boss") then table.insert(BList, v.Name) end
end
for _, v in pairs(workspace:FindFirstChild("Enemies") and workspace.Enemies:GetChildren() or {}) do
    if v.Name:find("Boss") then table.insert(BList, v.Name) end
end
CreateDropdown(BossTab, "เลือกบอส", BList, function(v) CFG.SelectedBoss = v end)

-- ========== MISC ==========
CreateSection(MiscTab, "ระบบ")
CreateToggle(MiscTab, "Anti AFK", "กันถูกเตะออกจากเกม", function() return CFG.AntiAFK end, function(v) CFG.AntiAFK = v end)
CreateToggle(MiscTab, "No Clip", "ทะลุกำแพง/สิ่งกีดขวาง", function() return CFG.NoClip end, function(v) CFG.NoClip = v end)

CreateSection(MiscTab, "สกิล")
CreateToggle(MiscTab, "Auto Skill", "กด Z X C V อัตโนมัติ", function() return CFG.AutoSkill end, function(v) CFG.AutoSkill = v end)
CreateToggle(MiscTab, "Auto Haki", "ใช้ Buso อัตโนมัติ", function() return CFG.AutoHaki end, function(v) CFG.AutoHaki = v end)
CreateToggle(MiscTab, "Fast Attack", "ตีเร็วขึ้น (Bypass Cooldown)", function() return CFG.FastAttack end, function(v) CFG.FastAttack = v end)

-- ========== SETTING ==========
CreateSection(SettingTab, "ตัวละคร")
CreateSlider(SettingTab, "WalkSpeed", 16, 500, 16, function(v) CFG.WalkSpeed = v end)
CreateSlider(SettingTab, "JumpPower", 50, 500, 50, function(v) CFG.JumpPower = v end)
CreateSlider(SettingTab, "Farm Distance", 5, 100, 30, function(v) CFG.FarmDistance = v end)

CreateSection(SettingTab, "ระบบ")
CreateButton(SettingTab, "🔄 Rejoin", "กลับเข้าเซิร์ฟเวอร์เดิม", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)
CreateButton(SettingTab, "🌐 Server Hop", "สุ่มเปลี่ยนเซิร์ฟเวอร์ใหม่", function()
    local TS = game:GetService("TeleportService")
    local HTTP = game:GetService("HttpService")
    pcall(function()
        local site = HTTP:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        for _, s in pairs(site.data) do
            if s.playing < s.maxPlayers and s.id ~= game.JobId then
                TS:TeleportToPlaceInstance(game.PlaceId, s.id, LP); return
            end
        end
    end)
end)

-- ========== KEYBIND ==========
UserInput.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightControl then
        if Main.Size == UDim2.new(0, 760, 0, 520) then
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0,0,0,0)}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 0}):Play()
        else
            TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Quart), {Size = UDim2.new(0, 760, 0, 520)}):Play()
            TweenService:Create(Blur, TweenInfo.new(0.4), {Size = 12}):Play()
        end
    end
end)

print("✅ Rbot Premium โหลดสำเร็จ!")
print("🎨 UI Glassmorphism | " .. WORLD[game.PlaceId])
print("📌 กด Right Ctrl เพื่อซ่อน/แสดง UI")