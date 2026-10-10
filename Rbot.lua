-- Rbot Hud : UIเฉพาะระบบฟาร์ม (LocalScript)
-- วางไว้ที่: StarterPlayer > StarterPlayerScripts

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local MAX_SPEED = 300

local State = {
	autoFarm = false,
	weapon = "Melee",
	autoStats = false,
	stats = { Melee = true, Defense = true, Sword = false, Gun = false, Fruit = false },
	speed = 50,
}

-- ====== ส่วนเชื่อมต่อลอจิก (Hooks) ======
local Hooks = {
	onAutoFarm = function(on)
		-- ใส่โค้ดเปิด/ปิดระบบฟาร์มของคุณตรงนี้
		print("Auto Farm:", on)
	end,
	onWeapon = function(name)
		-- ใส่โค้ดเปลี่ยนอาวุธตรงนี้
		print("Selected Weapon:", name)
	end,
	onAutoStats = function(on)
		print("Auto Stats:", on)
	end,
	onStatPick = function(name, picked)
		print("Stat Toggle:", name, picked)
	end,
	onSpeed = function(value)
		print("Speed Changed:", value)
	end,
}
-- ===============================================

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
	mute = Color3.fromRGB(154, 154, 159),
	green = Color3.fromRGB(74, 222, 128),
	off = Color3.fromRGB(95, 95, 101),
	red = Color3.fromRGB(255, 138, 122),
}

local function make(class, props, parent)
	local o = Instance.new(class)
	for k, v in pairs(props) do
		o[k] = v
	end
	o.Parent = parent
	return o
end

local function round(o, r)
	return make("UICorner", { CornerRadius = UDim.new(0, r) }, o)
end

local function outline(o, color)
	return make("UIStroke", {
		Color = color,
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, o)
end

-- ====== สร้างหน้าต่างหลัก ======
local gui = make("ScreenGui", {
	Name = "RbotFarmHud",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

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

-- ====== หัวหน้าต่าง ======
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
make("UIPadding", {
	PaddingTop = UDim.new(0, 12),
	PaddingBottom = UDim.new(0, 12),
	PaddingLeft = UDim.new(0, 12),
	PaddingRight = UDim.new(0, 12),
}, content)
make("UIListLayout", {
	Padding = UDim.new(0, 8),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, content)

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
	make("UIPadding", {
		PaddingTop = UDim.new(0, 12),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 14),
		PaddingRight = UDim.new(0, 14),
	}, f)
	make("UIListLayout", {
		Padding = UDim.new(0, gap or 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, f)
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
	local line = make("Frame", {
		Size = UDim2.new(1, 0, 0, 24),
		BackgroundTransparency = 1,
		LayoutOrder = order or 1,
	}, parent)
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
	local knob = make("Frame", {
		Size = UDim2.fromOffset(18, 18),
		Position = UDim2.fromOffset(3, 3),
		BackgroundColor3 = C.soft,
		BorderSizePixel = 0,
	}, btn)
	round(knob, 9)

	local on = initial
	local info = TweenInfo.new(0.15)
	local function render()
		TweenService:Create(knob, info, {
			Position = on and UDim2.fromOffset(23, 3) or UDim2.fromOffset(3, 3),
			BackgroundColor3 = on and C.blue or C.soft,
		}):Play()
		TweenService:Create(btn, info, {
			BackgroundColor3 = on and C.chipOn or C.chip,
		}):Play()
	end
	btn.Activated:Connect(function()
		on = not on
		render()
		onChange(on)
	end)
	render()
	return btn
end

local function chipGrid(parent, order)
	local g = make("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		LayoutOrder = order or 2,
	}, parent)
	make("UIGridLayout", {
		CellSize = UDim2.new(0.5, -4, 0, 36),
		CellPadding = UDim2.fromOffset(8, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, g)
	return g
end

local function chip(parent, text, selected)
	local b = make("TextButton", {
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 14,
		AutoButtonColor = false,
		BackgroundColor3 = C.chip,
		TextColor3 = C.soft,
	}, parent)
	round(b, 8)
	local stroke = make("UIStroke", { Color = C.line, Thickness = 1 }, b)
	local function set(v)
		b.BackgroundColor3 = v and C.chipOn or C.chip
		b.TextColor3 = v and C.blueText or C.soft
		stroke.Color = v and C.blue or Color3.fromRGB(60, 60, 64)
	end
	set(selected)
	return b, set
end

-- ====== แผงแสดงสถานะฟาร์ม ======
local statusRow = newRow(6)
local lines = {}
for i = 1, 5 do
	lines[i] = label(statusRow, "", i)
end

local Info = { level = "-", quest = "-", mob = "-", dist = "-" }
local function refreshStatus()
	local on = State.autoFarm
	if on then
		lines[1].Text = string.format('<font color="#6dff9f">สถานะ: เปิด • Level %s</font>', Info.level)
	else
		lines[1].Text = '<font color="#9a9a9f">สถานะ: ปิด</font>'
	end
	lines[2].Text = 'เควส: <font color="#b8c8f0">' .. (on and Info.quest or "-") .. "</font>"
	lines[3].Text = 'มอน: <font color="#ffd2a8">' .. (on and Info.mob or "-") .. "</font>"
	lines[4].Text = 'ระยะ: <font color="#ffe08a">' .. (on and Info.dist or "-") .. "</font>"
	lines[5].Text = 'อาวุธ: <font color="#f0b4e0">' .. State.weapon .. "</font>"
	dot.BackgroundColor3 = on and C.green or C.off
end
refreshStatus()

-- ====== 1. AUTO FARM (สวิตช์เปิดปิดหลัก) ======
local farmRow = newRow()
local farmLine = titleLine(farmRow, "AUTO FARM")
switch(farmLine, State.autoFarm, function(on)
	State.autoFarm = on
	refreshStatus()
	Hooks.onAutoFarm(on)
end)

-- ====== 2. เลือกอาวุธ ======
local weaponRow = newRow()
label(weaponRow, "เลือกอาวุธ", 1)
local weaponGrid = chipGrid(weaponRow, 2)
local weaponChips = {}
for _, name in ipairs({ "Melee", "Sword", "Gun", "Fruit" }) do
	local b, set = chip(weaponGrid, name, name == State.weapon)
	weaponChips[name] = set
	b.Activated:Connect(function()
		State.weapon = name
		for n, s in pairs(weaponChips) do
			s(n == name)
		end
		refreshStatus()
		Hooks.onWeapon(name)
	end)
end

-- ====== ควบคุมการเปิด-ปิดหน้าต่าง HUD ======
closeBtn.Activated:Connect(function()
	main.Visible = false
end)

UIS.InputBegan:Connect(function(input, processed)
	if processed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		main.Visible = not main.Visible
	end
end)
