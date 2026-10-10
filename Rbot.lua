-- Rbot Hud : UI ระบบฟาร์มแบบสมบูรณ์ (รวมลูปฟาร์ม + ลากได้ + โลโก้ซ้ายบน)
-- วางไว้ที่: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MAX_SPEED = 300

local State = {
	autoFarm = false,
	weapon = "Melee",
	speed = 50,
}

-- ข้อมูลสถานะสำหรับแสดงผลบน UI
local Info = { level = "-", quest = "-", mob = "-", dist = "-" }

-- ====== ฟังก์ชันและลอจิกการฟาร์ม (ดึงจากสคริปต์หลักของคุณ)[span_2](start_span)[span_2](end_span) ======
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF_ = Remotes:WaitForChild("CommF_")
local Enemies = Workspace:FindFirstChild("Enemies")

-- ฟังก์ชันเช็คว่าตัวละครยังมีชีวิตอยู่หรือไม่[span_3](start_span)[span_3](end_span)
local function IsEntityAlive(char)
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	return humanoid and humanoid.Health > 0
end

-- ฟังก์ชันคำนวณระยะห่าง[span_4](start_span)[span_4](end_span)
local function GetDistance(pos)
	local char = player.Character
	if not char or not char.PrimaryPart then return math.huge end
	return (char.PrimaryPart.Position - pos).Magnitude
end

-- ฟังก์ชันเปิดฮาคิ[span_5](start_span)[span_5](end_span)
local function ActivateHaki()
	local char = player.Character
	if char and not char:FindFirstChild("HasBuso") then
		pcall(function()
			CommF_:InvokeServer("Buso")
		end)
	end
end

-- ฟังก์ชันเลือกอาวุธตามที่ผู้เล่นเลือก[span_6](start_span)[span_6](end_span)
local function EquipSelectedTool()
	local backpack = player.Backpack
	local char = player.Character
	if not (backpack and char) then return end
	local humanoid = char:FindFirstChildOfClass("Humanoid")
	
	for _, tool in ipairs(backpack:GetChildren()) do
		if tool:IsA("Tool") and tool.ToolTip == State.weapon then
			if humanoid then
				humanoid:EquipTool(tool)
			end
			return
		end
	end
end

-- ฟังก์ชันเช็คว่าเปิดเควสต์อยู่ไหม[span_7](start_span)[span_7](end_span)
local function IsQuestOn()
	local trackFrame = player.PlayerGui:FindFirstChild("TrackedQuestFrame")
	return trackFrame and trackFrame.Frame.Visible or false
end

-- ฟังก์ชันค้นหามอนสเตอร์[span_8](start_span)[span_8](end_span)
local function FindEnemy(names)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
	local pos = char.HumanoidRootPart.Position
	local nearest, minDist = nil, math.huge
	
	if not Enemies then return nil end
	for _, v in ipairs(Enemies:GetChildren()) do
		local humanoid = v:FindFirstChild("Humanoid")
		local hrp = v:FindFirstChild("HumanoidRootPart")
		if humanoid and hrp and humanoid.Health > 0 then
			local match = v.Name:match("^(.-)%s*%[") or v.Name
			for _, targetName in ipairs(names) do
				if match == targetName then
					local dist = (hrp.Position - pos).Magnitude
					if dist < minDist then
						minDist = dist
						nearest = v
					end
				end
			end
		end
	end
	return nearest
end

-- ฟังก์ชัน Tween เคลื่อนที่ตัวละคร[span_9](start_span)[span_9](end_span)
local activeTween = nil
local function ExecuteTween(targetCFrame)
	local char = player.Character
	if not char or not char:FindFirstChild("HumanoidRootPart") then return end
	local hrp = char.HumanoidRootPart
	
	if activeTween then
		activeTween:Cancel()
	end
	
	local dist = (hrp.Position - targetCFrame.Position).Magnitude
	local speed = math.max(State.speed, 50)
	local timeVal = math.max(0.05, dist / speed)
	
	-- ปิดการชนชั่วคราวเพื่อกันติดสิ่งกีดขวาง
	for _, part in ipairs(char:GetDescendants()) do
		if part:IsA("BasePart") then
			part.CanCollide = false
		end
	end
	
	hrp.AssemblyLinearVelocity = Vector3.zero
	activeTween = TweenService:Create(hrp, TweenInfo.new(timeVal, Enum.EasingStyle.Linear), {CFrame = targetCFrame})
	activeTween:Play()
end

local function StopTween()
	if activeTween then
		activeTween:Cancel()
		activeTween = nil
	end
end

-- ฟังก์ชันดึงข้อมูลเควสต์ตามเลเวล[span_10](start_span)[span_10](end_span)
local function GetQuestInfo()
	local level = player.Data.Level.Value
	local n3, cframe, str4, str5, n4, str6 = 1, CFrame.new(), "", "", level, ""
	
	pcall(function()
		local GuideModule = require(ReplicatedStorage.GuideModule)
		for k, v in pairs(GuideModule.Data.NPCList) do
			for _, v20 in ipairs(v.Levels) do
				if level >= v20 and v20 > n4 then
					n4 = v20
					cframe = k.CFrame
				end
			end
		end
		
		local Quests = require(ReplicatedStorage.Quests)
		for k, Quest in pairs(Quests) do
			if k ~= "CitizenQuest" then
				for k2, v19 in pairs(Quest) do
					if v19.LevelReq == n4 then
						str5 = k
						n3 = k2
						for k3 in pairs(v19.Task) do
							str4 = k3
							str6 = string.split(k3, " [Lv. " .. v19.LevelReq .. "]")[1]
						end
					end
				end
			end
		end
	end)
	return { n3, cframe, str4, str6, n4, str5 }
end

-- ฟังก์ชันสู้กับมอนสเตอร์ (เข้าประชิด + โจมตี)[span_11](start_span)[span_11](end_span)
local function EngageEnemy(enemyNames)
	local enemy = FindEnemy(enemyNames)
	if enemy and enemy:FindFirstChild("HumanoidRootPart") then
		local hrp = enemy.HumanoidRootPart
		Info.mob = enemy.Name
		Info.dist = math.floor(GetDistance(hrp.Position)) .. "m"
		
		ExecuteTween(hrp.CFrame + Vector3.new(0, 20, 0))
		ActivateHaki()
		EquipSelectedTool()
		
		-- ส่งรีโมตโจมตีพื้นฐาน
		pcall(function()
			local tool = player.Character and player.Character:FindFirstChildOfClass("Tool")
			if tool and tool:FindFirstChild("LeftClickRemote") then
				tool.LeftClickRemote:FireServer(hrp.Position, 1)
			else
				Remotes.Net:FindFirstChild("RE/RegisterAttack"):FireServer(0)
			end
		end)
	end
end

-- ลูปการทำงานหลักของ Auto Farm[span_12](start_span)[span_12](end_span)
task.spawn(function()
	while true do
		task.wait()
		if State.autoFarm then
			pcall(function()
				local qInfo = GetQuestInfo()
				Info.level = tostring(qInfo[5])
				Info.quest = tostring(qInfo[4])
				
				if IsQuestOn() then
					local enemy = FindEnemy({qInfo[4]})
					if enemy then
						EngageEnemy({qInfo[4]})
					else
						-- ถ้ายังหามอนไม่เจอ ให้วิ่งไปจุดเกิดมอนสเตอร์
						if qInfo[2] then
							ExecuteTween(qInfo[2] * CFrame.new(0, 30, 5))
						end
					end
				else
					-- ถ้ายังไม่ได้รับเควสต์ ให้เดินไปรับเควสต์
					if qInfo[2] then
						local dist = GetDistance(qInfo[2].Position)
						if dist <= 10 then
							CommF_:InvokeServer("StartQuest", qInfo[6], qInfo[1])
						else
							ExecuteTween(qInfo[2])
						end
					end
				end
			end)
		else
			StopTween()
			Info.mob = "-"
			Info.dist = "-"
		end
	end
end)


-- ==========================================
-- ====== ส่วนการสร้าง UI (Minimal UI) ======
-- ==========================================

local C = {
	bg = Color3.fromRGB(28, 28, 30),
	head = Color3.fromRGB(36, 36, 38),
	row = Color3.fromRGB(38, 38, 40),
	line = Color3.fromRGB(48, 48, 51),
	chip = Color3.fromRGB(46, 46, 49),
	chipOn = Color3.fromRGB(27, 58, 85),
	blue = Color3.fromRGB(26, 143, 224),
	blueText = Color3.fromRGB(143, 203, 255),
	text = Color3.fromRGB(236, 236, 238),
	soft = Color3.fromRGB(200, 200, 204),
	green = Color3.fromRGB(74, 222, 128),
	off = Color3.fromRGB(95, 95, 101),
	red = Color3.fromRGB(255, 138, 122),
}

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do o[k] = v end
	o.Parent = parent
	return o
end

local function round(o, r) return make("UICorner", { CornerRadius = UDim.new(0, r) }, o) end
local function outline(o, color) return make("UIStroke", { Color = color, Thickness = 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border }, o) end

local gui = make("ScreenGui", {
	Name = "RbotFarmHud",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

-- ปุ่มโลโก้ลอยมุมซ้ายบน (แสดงขึ้นมาตอนกดปิด UI)[span_13](start_span)[span_13](end_span)
local toggleLogoBtn = make("TextButton", {
	Name = "ToggleLogoButton",
	Text = "RBOT",
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	TextColor3 = C.text,
	BackgroundColor3 = C.chipOn,
	Position = UDim2.fromOffset(20, 20),
	Size = UDim2.fromOffset(48, 48),
	Visible = false,
	ZIndex = 10,
}, gui)
round(toggleLogoBtn, 24)
outline(toggleLogoBtn, C.blue)

-- หน้าต่าง UI หลัก[span_14](start_span)[span_14](end_span)
local main = make("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(340, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundColor3 = C.bg,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, gui)
round(main, 10)
outline(main, C.line)
make("UIListLayout", { SortOrder = Enum.SortOrder.LayoutOrder }, main)

-- หัวหน้าต่าง (ใช้สำหรับกดลาก)[span_15](start_span)[span_15](end_span)
local header = make("Frame", {
	Size = UDim2.new(1, 0, 0, 42),
	BackgroundColor3 = C.head,
	BorderSizePixel = 0,
	LayoutOrder = 1,
}, main)

make("TextLabel", {
	Text = "Rbot Farm HUD",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = C.text,
	TextXAlignment = Enum.TextXAlignment.Left,
	BackgroundTransparency = 1,
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(1, -90, 1, 0),
}, header)

local dot = make("Frame", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -46, 0.5, 0),
	Size = UDim2.fromOffset(10, 10),
	BackgroundColor3 = C.off,
	BorderSizePixel = 0,
}, header)
round(dot, 5)

-- ปุ่มกากบาท (ปิดหน้าต่าง UI)[span_16](start_span)[span_16](end_span)
local closeBtn = make("TextButton", {
	Text = "X",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = C.red,
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(28, 28),
}, header)

local content = make("Frame", {
	Size = UDim2.new(1, 0, 0, 0),
	AutomaticSize = Enum.AutomaticSize.Y,
	BackgroundTransparency = 1,
	LayoutOrder = 2,
}, main)
make("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 12), PaddingRight = UDim.new(0, 12) }, content)
make("UIListLayout", { Padding = UDim.new(0, 8), SortOrder = Enum.SortOrder.LayoutOrder }, content)

local rowOrder = 0
local function newRow(gap)
	rowOrder += 1
	local f = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = C.row,
		BorderSizePixel = 0,
		LayoutOrder = rowOrder,
	}, content)
	round(f, 8)
	outline(f, C.line)
	make("UIPadding", { PaddingTop = UDim.new(0, 12), PaddingBottom = UDim.new(0, 12), PaddingLeft = UDim.new(0, 14), PaddingRight = UDim.new(0, 14) }, f)
	make("UIListLayout", { Padding = UDim.new(0, gap or 10), SortOrder = Enum.SortOrder.LayoutOrder }, f)
	return f
end

local function label(parent, text, order)
	return make("TextLabel", {
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, 0, 0, 18),
		LayoutOrder = order or 1,
	}, parent)
end

local function titleLine(parent, text, order)
	local line = make("Frame", { Size = UDim2.new(1, 0, 0, 24), BackgroundTransparency = 1, LayoutOrder = order or 1 }, parent)
	make("TextLabel", {
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		TextColor3 = C.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		RichText = true,
		BackgroundTransparency = 1,
		Size = UDim2.new(1, -60, 1, 0),
	}, line)
	return line
end

local function switch(parent, initial, onChange)
	local btn = make("TextButton", {
		Text = "",
		AutoButtonColor = false,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(44, 24),
		BackgroundColor3 = C.chip,
	}, parent)
	round(btn, 12)
	outline(btn, Color3.fromRGB(74, 74, 80))
	local knob = make("Frame", { Size = UDim2.fromOffset(18, 18), Position = UDim2.fromOffset(3, 3), BackgroundColor3 = C.soft, BorderSizePixel = 0 }, btn)
	round(knob, 9)

	local on = initial
	local info = TweenInfo.new(0.15)
	local function render()
		TweenService:Create(knob, info, {
			Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
			BackgroundColor3 = on and C.blue or C.soft,
		}):Play()
		TweenService:Create(btn, info, { BackgroundColor3 = on and C.chipOn or C.chip }):Play()
	end
	btn.Activated:Connect(function()
		on = not on
		render()
		onChange(on)
	end)
	render()
	return btn
end

-- แผงแสดงสถานะแบบเรียลไทม์
local statusRow = newRow(6)
local lines = {}
for i = 1, 5 do lines[i] = label(statusRow, "", i) end

local function refreshStatus()
	local on = State.autoFarm
	lines[1].Text = on and string.format('<font color="#6dff9f">สถานะ: เปิด • Level %s</font>', Info.level) or '<font color="#9a9a9f">สถานะ: ปิด</font>'
	lines[2].Text = 'เควส: <font color="#b8c8f0">' .. (on and Info.quest or "-") .. "</font>"
	lines[3].Text = 'มอน: <font color="#ffd2a8">' .. (on and Info.mob or "-") .. "</font>"
	lines[4].Text = 'ระยะ: <font color="#ffe08a">' .. (on and Info.dist or "-") .. "</font>"
	lines[5].Text = 'อาวุธ: <font color="#f0b4e0">' .. State.weapon .. "</font>"
	dot.BackgroundColor3 = on and C.green or C.off
end

task.spawn(function()
	while task.wait(0.5) do
		refreshStatus()
	end
end)

-- ปุ่มสวิตช์ Auto Farm หลัก[span_17](start_span)[span_17](end_span)
local farmRow = newRow()
local farmLine = titleLine(farmRow, "AUTO FARM")
switch(farmLine, State.autoFarm, function(on)
	State.autoFarm = on
	refreshStatus()
end)

-- ปุ่มเลือกอาวุธ[span_18](start_span)[span_18](end_span)
local weaponRow = newRow()
label(weaponRow, "เลือกอาวุธ", 1)
local weaponGrid = make("Frame", { Size = UDim2.new(1, 0, 0, 0), AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, LayoutOrder = 2 }, weaponRow)
make("UIGridLayout", { CellSize = UDim2.new(0.5, -4, 0, 36), CellPadding = UDim2.fromOffset(8, 8), SortOrder = Enum.SortOrder.LayoutOrder }, weaponGrid)

local weaponChips = {}
for _, name in ipairs({ "Melee", "Sword", "Gun", "Fruit" }) do
	local b = make("TextButton", { Text = name, Font = Enum.Font.GothamMedium, TextSize = 14, AutoButtonColor = false, BackgroundColor3 = C.chip, TextColor3 = C.soft }, weaponGrid)
	round(b, 8)
	local stroke = outline(b, C.line)
	
	local function set(v)
		b.BackgroundColor3 = v and C.chipOn or C.chip
		b.TextColor3 = v and C.blueText or C.soft
		stroke.Color = v and C.blue or Color3.fromRGB(60, 60, 64)
	end
	set(name == State.weapon)
	weaponChips[name] = set
	
	b.Activated:Connect(function()
		State.weapon = name
		for n, s in pairs(weaponChips) do s(n == name) end
	end)
end

-- ระบบลากหน้าต่าง UI[span_19](start_span)[span_19](end_span)
local dragging, dragStart, startPos = false, nil, nil
header.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = true
		dragStart = input.Position
		startPos = main.Position
	end
end)

UIS.InputChanged:Connect(function(input)
	if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
		local delta = input.Position - dragStart
		main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

UIS.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
		dragging = false
	end
end)

-- ระบบปิด UI แล้วแสดงโลโก้ซ้ายบน / กดโลโก้เพื่อเปิด UI กลับมา[span_20](start_span)[span_20](end_span)
closeBtn.Activated:Connect(function()
	main.Visible = false
	toggleLogoBtn.Visible = true
end)

toggleLogoBtn.Activated:Connect(function()
	main.Visible = true
	toggleLogoBtn.Visible = false
end)

-- กดปุ่ม RightShift เพื่อสลับเปิด/ปิด[span_21](start_span)[span_21](end_span)
UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
		toggleLogoBtn.Visible = not main.Visible
	end
end)
