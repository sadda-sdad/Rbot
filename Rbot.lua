-- ทดสอบ UI แบบง่ายที่สุด
local parent = game:GetService("CoreGui")
pcall(function() parent = gethui() end)

local sg = Instance.new("ScreenGui")
sg.Name = "RBOT_SIMPLE"
sg.ResetOnSpawn = false
sg.Parent = parent

local f = Instance.new("Frame")
f.Size = UDim2.new(0, 600, 0, 400)
f.Position = UDim2.new(0.5, -300, 0.5, -200)
f.BackgroundColor3 = Color3.fromRGB(20, 15, 30)
f.Parent = sg

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 20)
corner.Parent = f

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 50)
title.BackgroundTransparency = 1
title.Text = "🔥 RBOT TEST"
title.TextColor3 = Color3.fromRGB(160, 80, 255)
title.TextSize = 30
title.Font = Enum.Font.GothamBlack
title.Parent = f

local btn = Instance.new("TextButton")
btn.Size = UDim2.new(0, 200, 0, 60)
btn.Position = UDim2.new(0.5, -100, 0.5, -30)
btn.BackgroundColor3 = Color3.fromRGB(160, 80, 255)
btn.Text = "✅ UI ขึ้นได้!"
btn.TextColor3 = Color3.new(1,1,1)
btn.TextSize = 20
btn.Font = Enum.Font.GothamBold
btn.Parent = f

print("✅ สร้าง UI เสร็จ — ดูกลางจอ")
