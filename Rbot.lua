--[[
    RBOT TEST V3 - บังคับขึ้นทุกทาง
    ลอง 3 วิธี: PlayerGui → CoreGui → gethui
]]

print("=== RBOT TEST V3 ===")
print("Executor:", identifyexecutor and identifyexecutor() or "ไม่ทราบ")

-- ลบเก่าทั้งหมด
local function Cleanup()
    for _, parent in ipairs({
        game:GetService("CoreGui"),
        game.Players.LocalPlayer:FindFirstChild("PlayerGui"),
    }) do
        if parent then
            for _, v in ipairs(parent:GetChildren()) do
                if v.Name:match("^RBOT_") then
                    pcall(function() v:Destroy() end)
                end
            end
        end
    end
end
Cleanup()

-- ฟังก์ชันสร้าง UI
local function CreateUI(parent, name)
    local sg = Instance.new("ScreenGui")
    sg.Name = name
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 999
    sg.Enabled = true                    -- ✅ บังคับ enabled
    
    local ok, err = pcall(function() sg.Parent = parent end)
    if not ok then
        print("❌ set parent ไม่ได้:", err)
        return nil
    end
    
    local f = Instance.new("Frame")
    f.Size = UDim2.new(0, 400, 0, 200)
    f.Position = UDim2.new(0, 10, 0, 10)  -- ✅ มุมซ้ายบน
    f.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    f.BorderSizePixel = 3
    f.BorderColor3 = Color3.new(1, 1, 1)
    f.Parent = sg
    
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 0, 60)
    t.BackgroundTransparency = 1
    t.Text = "✅ UI ขึ้นแล้ว!\n" .. name
    t.TextColor3 = Color3.new(0, 0, 0)
    t.TextSize = 22
    t.Font = Enum.Font.GothamBlack
    t.Parent = f
    
    local info = Instance.new("TextLabel")
    info.Size = UDim2.new(1, -20, 0, 80)
    info.Position = UDim2.new(0, 10, 0, 60)
    info.BackgroundTransparency = 1
    info.Text = "Parent:\n" .. tostring(parent)
    info.TextColor3 = Color3.new(0, 0, 0)
    info.TextSize = 12
    info.TextWrapped = true
    info.Font = Enum.Font.Code
    info.Parent = f
    
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 40)
    btn.Position = UDim2.new(0, 10, 1, -50)
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 0)
    btn.Text = "กดทดสอบ"
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.Parent = f
    
    local count = 0
    btn.MouseButton1Click:Connect(function()
        count = count + 1
        btn.Text = "กดแล้ว " .. count .. " ครั้ง!"
        print("✅ ปุ่มทำงาน: " .. count)
    end)
    
    print("✅ สร้าง UI สำเร็จใน: " .. tostring(parent))
    return sg
end

-- ===== ลองทุกวิธี =====

-- วิธีที่ 1: PlayerGui (ปลอดภัยสุด)
local pg = game.Players.LocalPlayer:FindFirstChild("PlayerGui")
if pg then
    print("→ ลอง PlayerGui...")
    local ui = CreateUI(pg, "RBOT_PlayerGui")
    if ui then
        print("✅ สำเร็จด้วย PlayerGui!")
        return
    end
else
    print("❌ ไม่มี PlayerGui")
end

-- วิธีที่ 2: CoreGui
print("→ ลอง CoreGui...")
local ok, cg = pcall(function() return game:GetService("CoreGui") end)
if ok and cg then
    local ui = CreateUI(cg, "RBOT_CoreGui")
    if ui then
        print("✅ สำเร็จด้วย CoreGui!")
        return
    end
else
    print("❌ CoreGui ใช้ไม่ได้")
end

-- วิธีที่ 3: gethui
print("→ ลอง gethui...")
local ok2, hui = pcall(function() return gethui and gethui() end)
if ok2 and hui then
    local ui = CreateUI(hui, "RBOT_Hui")
    if ui then
        print("✅ สำเร็จด้วย gethui!")
        return
    end
else
    print("❌ gethui ใช้ไม่ได้")
end

warn("❌❌❌ ทุกวิธีล้มเหลว — Executor มีปัญหา")
