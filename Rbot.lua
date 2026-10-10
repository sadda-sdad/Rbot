-- Rbot HUD: ระบบฟาร์มอย่างเดียว (UI สำหรับ Roblox Studio / LocalScript)
-- วางใน StarterPlayer > StarterPlayerScripts
-- หมายเหตุ: ปุ่มนี้เป็น UI เท่านั้น ต้องเชื่อมกับระบบฟาร์มของเกมที่คุณพัฒนาเอง

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BLUE = Color3.fromRGB(40, 160, 255)
local BG = Color3.fromRGB(17, 24, 35)
local PANEL = Color3.fromRGB(25, 35, 49)
local TEXT = Color3.fromRGB(235, 245, 255)
local MUTED = Color3.fromRGB(145, 165, 185)
local enabled = false

local old = playerGui:FindFirstChild("RbotFarmOnly")
if old then old:Destroy() end

local function create(class, props, parent)
    local obj = Instance.new(class)
    for k, v in pairs(props) do obj[k] = v end
    obj.Parent = parent
    return obj
end
local function corner(obj, radius)
    create("UICorner", {CornerRadius = UDim.new(0, radius)}, obj)
end

local gui = create("ScreenGui", {Name = "RbotFarmOnly", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling}, playerGui)
local main = create("Frame", {
    Name = "หน้าต่างหลัก", AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(0, 300, 0, 154), BackgroundColor3 = BG, BorderSizePixel = 0
}, gui)
corner(main, 14)
create("UIStroke", {Color = Color3.fromRGB(47, 74, 103), Thickness = 1}, main)
create("UISizeConstraint", {MinSize = Vector2.new(260, 154), MaxSize = Vector2.new(340, 154)}, main)

local header = create("Frame", {Size = UDim2.new(1, 0, 0, 48), BackgroundColor3 = PANEL, BorderSizePixel = 0}, main)
corner(header, 14)
create("Frame", {Position = UDim2.new(0, 0, 1, -12), Size = UDim2.new(1, 0, 0, 12), BackgroundColor3 = PANEL, BorderSizePixel = 0}, header)
create("Frame", {Position = UDim2.fromOffset(14, 15), Size = UDim2.fromOffset(4, 18), BackgroundColor3 = BLUE, BorderSizePixel = 0}, header)
create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(27, 0), Size = UDim2.new(1, -75, 1, 0), Font = Enum.Font.GothamBold, Text = "Rbot HUD", TextSize = 17, TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left}, header)
local close = create("TextButton", {BackgroundTransparency = 1, AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -8, 0.5, 0), Size = UDim2.fromOffset(32, 32), Text = "×", Font = Enum.Font.GothamMedium, TextSize = 25, TextColor3 = MUTED, AutoButtonColor = false}, header)

create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 61), Size = UDim2.new(1, -32, 0, 22), Font = Enum.Font.GothamMedium, Text = "ระบบฟาร์มอัตโนมัติ", TextSize = 14, TextColor3 = TEXT, TextXAlignment = Enum.TextXAlignment.Left}, main)
local stateText = create("TextLabel", {BackgroundTransparency = 1, Position = UDim2.fromOffset(16, 88), Size = UDim2.new(1, -120, 0, 22), Font = Enum.Font.Gotham, Text = "สถานะ: ปิดอยู่", TextSize = 12, TextColor3 = MUTED, TextXAlignment = Enum.TextXAlignment.Left}, main)
local toggle = create("TextButton", {AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -16, 0, 99), Size = UDim2.fromOffset(76, 32), BackgroundColor3 = Color3.fromRGB(53, 65, 80), Text = "ปิด", Font = Enum.Font.GothamBold, TextSize = 13, TextColor3 = TEXT, AutoButtonColor = false}, main)
corner(toggle, 9)

local function onFarmChanged(isOn)
    -- เชื่อมระบบฟาร์มของเกมที่คุณพัฒนาเองตรงนี้
    -- ยังไม่มีการเคลื่อนที่/โจมตีอัตโนมัติ เพราะแต่ละเกมใช้ระบบต่างกัน
end
local function render()
    local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(toggle, info, {BackgroundColor3 = enabled and BLUE or Color3.fromRGB(53, 65, 80)}):Play()
    toggle.Text = enabled and "เปิด" or "ปิด"
    stateText.Text = enabled and "สถานะ: กำลังเปิดใช้งาน" or "สถานะ: ปิดอยู่"
    stateText.TextColor3 = enabled and Color3.fromRGB(100, 220, 160) or MUTED
    onFarmChanged(enabled)
end
toggle.Activated:Connect(function() enabled = not enabled; render() end)
close.Activated:Connect(function() gui.Enabled = false end)

-- แตะ/กด RightShift เพื่อแสดงหรือซ่อนหน้าต่าง
UIS.InputBegan:Connect(function(input, processed)
    if not processed and input.KeyCode == Enum.KeyCode.RightShift then gui.Enabled = not gui.Enabled end
end)

-- ลากหน้าต่างได้ทั้งเมาส์และจอสัมผัส
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = input.Position; startPos = main.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UIS.InputChanged:Connect(function(input)
    if dragging and (input == dragInput or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- ปรับขนาดหน้าต่างให้เหมาะกับจอมือถือ
local camera = workspace.CurrentCamera
local function fitScreen()
    if not camera then return end
    local viewport = camera.ViewportSize
    main.Size = UDim2.new(0, math.clamp(viewport.X - 32, 260, 300), 0, 154)
end
if camera then camera:GetPropertyChangedSignal("ViewportSize"):Connect(fitScreen); fitScreen() end
render()
