-- ทดสอบ UI + ปุ่มกดได้จริง
local parent
pcall(function() parent = gethui() end)
if not parent then
    pcall(function() parent = game:GetService("CoreGui") end)
end
if not parent then
    parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
end

-- ลบเก่า
local old = parent:FindFirstChild("RBOT_TEST2")
if old then old:Destroy() end

local sg = Instance.new("ScreenGui")
sg.Name = "RBOT_TEST2"
sg.ResetOnSpawn = false
sg.IgnoreGuiInset = true
sg.DisplayOrder = 999
sg.Parent = parent

local f = Instance.new("Frame")
f.Name = "MainFrame"
f.Size = UDim2.new(0, 500, 0, 300)
f.Position = UDim2.new(0.5, -250, 0.5, -150)
f.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
f.BorderSizePixel = 0
f.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = f

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(160, 80, 255)
stroke.Thickness = 2
stroke.Parent = f

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 60)
title.BackgroundTransparency = 1
title.Text = "🔥 RBOT TEST v2"
title.TextColor3 = Color3.fromRGB(160, 80, 255)
title.TextSize = 28
title.Font = Enum.Font.GothamBlack
title.Parent = f

local info = Instance.new("TextLabel")
info.Size = UDim2.new(1, -20, 0, 40)
info.Position = UDim2.new(0, 10, 0, 60)
info.BackgroundTransparency = 1
info.Text = "Parent: " .. tostring(parent):sub(1, 50)
info.TextColor3 = Color3.fromRGB(200, 200, 200)
info.TextSize = 12
info.Font = Enum.Font.Code
info.Parent = f

local counter = 0
local countLabel = Instance.new("TextLabel")
countLabel.Size = UDim2.new(1, 0, 0, 50)
countLabel.Position = UDim2.new(0, 0, 0, 120)
countLabel.BackgroundTransparency = 1
countLabel.Text = "กดปุ่ม: 0 ครั้ง"
countLabel.TextColor3 = Color3.new(1,1,1)
countLabel.TextSize = 22
countLabel.Font = Enum.Font.GothamBold
countLabel.Parent = f

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 60)
btn.Position = UDim2.new(0.5, -100, 1, -80)
btn.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
btn.Text = "กดทดสอบ"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextSize = 18
btn.Font = Enum.Font.GothamBold
btn.Parent = f

local bc = Instance.new("UICorner")
bc.CornerRadius = UDim.new(0, 12)
bc.Parent = btn

btn.MouseButton1Click:Connect(function()
    counter = counter + 1
    countLabel.Text = "กดปุ่ม: " .. counter .. " ครั้ง"
    print("✅ ปุ่มทำงาน! ครั้งที่ " .. counter)
end)

-- ปุ่มปิด
local close = Instance.new("TextButton")
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -40, 0, 10)
close.BackgroundColor3 = Color3.fromRGB(255, 60, 80)
close.Text = "✕"
close.TextColor3 = Color3.new(1,1,1)
close.TextSize = 14
close.Font = Enum.Font.GothamBold
close.Parent = f

local cc = Instance.new("UICorner")
cc.CornerRadius = UDim.new(1, 0)
cc.Parent = close

close.MouseButton1Click:Connect(function()
    sg:Destroy()
    print("ปิด UI แล้ว")
end)

print("✅ UI สร้างเสร็จ — Parent: " .. tostring(parent))
print("✅ ลองกดปุ่มกลางจอ")
