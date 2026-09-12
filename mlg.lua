--[[
	WARNING: Heads up! This script has not been verified by ScriptBlox. Use at your own risk!
	PUNCH + MLG v34 (manual lock, fixed)
]]
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LP = Players.LocalPlayer
local pkg = RS["ReplicatedStorage Package"]
local REM = pkg["Remote Events"]
local SendPacket = REM.SendPacket
local PunchRemote = REM.Punch
local PUNCH_ID = 81285671124281

-- =============================================
-- НАСТРОЙКИ
-- =============================================
local MIN, MAX, Range, Enabled = 5, 300, 12, true
local AUTO_ATTACK = true
local AUTO_COOLDOWN = 0.35

-- ФИЛЬТРЫ
local WALL_CHECK = true
local HEIGHT_CHECK = true
local MAX_HEIGHT_DIFF = 5
local TARGET_RADIUS = 100

-- MLG
local MLG_ENABLED = false
local MLG_ANGLE_THRESHOLD = 15
local MLG_SPIN_WAIT_MAX = 3.0
local MLG_CYCLE_DELAY = 2.0
local MLG_SPIN_THRESHOLD = 100
local AIM_BEFORE_SHOT = true

-- 🔒 РУЧНОЙ ЛОК
local MANUAL_LOCK_ENABLED = true
local MLG_LOCKED_TARGET = nil
local MLG_LOCKED_NAME = ""

if _G._SPA7 then _G._SPA7.running = false end
local oldGui = LP.PlayerGui:FindFirstChild("SilentPunchAssist")
if oldGui then oldGui:Destroy() end
local oldViz = workspace:FindFirstChild("RangeViz")
if oldViz then oldViz:Destroy() end

-- =============================================
-- ФИЛЬТРЫ
-- =============================================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function hasLineOfSight(myHRP, targetHRP, targetChar)
    if not WALL_CHECK then return true end
    rayParams.FilterDescendantsInstances = {LP.Character, targetChar}
    local dir = targetHRP.Position - myHRP.Position
    local ray = workspace:Raycast(myHRP.Position, dir, rayParams)
    if ray and ray.Instance then
        if ray.Instance.CanCollide or ray.Instance.Anchored then
            return false
        end
    end
    return true
end

local function checkHeight(myHRP, targetHRP)
    if not HEIGHT_CHECK then return true end
    return (targetHRP.Position.Y - myHRP.Position.Y) <= MAX_HEIGHT_DIFF
end

-- =============================================
-- ПОИСК БЛИЖАЙШЕГО
-- =============================================
local function getClosest()
    local me = LP.Character
    if not me then return nil end
    local myHRP = me:FindFirstChild("HumanoidRootPart")
    if not myHRP then return nil end
    local candidates = {}
    for _, pl in ipairs(Players:GetPlayers()) do
        if pl ~= LP and pl.Character then
            local hrp = pl.Character:FindFirstChild("HumanoidRootPart")
            local hum = pl.Character:FindFirstChild("Humanoid")
            if hrp and hrp:IsA("BasePart") and hum and hum.Health > 0 then
                local d = (hrp.Position - myHRP.Position).Magnitude
                if d <= TARGET_RADIUS then
                    if checkHeight(myHRP, hrp) and hasLineOfSight(myHRP, hrp, pl.Character) then
                        table.insert(candidates, {char = pl.Character, part = hrp, name = pl.Name, dist = d})
                    end
                end
            end
        end
    end
    table.sort(candidates, function(a, b) return a.dist < b.dist end)
    return candidates[1]
end

-- =============================================
-- ПОИСК ДЛЯ MLG (с локом)
-- =============================================
local function getClosestForMLG()
    if MANUAL_LOCK_ENABLED then
        if MLG_LOCKED_TARGET then
            if MLG_LOCKED_TARGET.Parent then
                local hum = MLG_LOCKED_TARGET:FindFirstChild("Humanoid")
                if hum and hum.Health > 0 then
                    local me = LP.Character
                    if me then
                        local myHRP = me:FindFirstChild("HumanoidRootPart")
                        local hrp = MLG_LOCKED_TARGET:FindFirstChild("HumanoidRootPart")
                        if myHRP and hrp then
                            local d = (hrp.Position - myHRP.Position).Magnitude
                            if d <= TARGET_RADIUS then
                                return {char = MLG_LOCKED_TARGET, part = hrp, name = MLG_LOCKED_NAME, dist = d}
                            end
                        end
                    end
                end
            end
            -- Сброс без спама
            if MLG_LOCKED_NAME ~= "" then
                print("🔓 ЛОК СНЯТ:", MLG_LOCKED_NAME)
            end
            MLG_LOCKED_TARGET = nil
            MLG_LOCKED_NAME = ""
        end
        return nil
    end
    return getClosest()
end

-- =============================================
-- FIREAT
-- =============================================
local function fireAt(t)
    local me = LP.Character
    if not me then return end
    local hb = me:FindFirstChild("Hitbox")
    local hrp = me:FindFirstChild("HumanoidRootPart")
    local weld = hrp and hrp:FindFirstChild("Hitbox Weld")
    if not (hb and hrp and weld) then return end
    local targetArm = t.char:FindFirstChild("Right Arm") or t.char:FindFirstChild("RightHand") or t.part
    local v1 = hb.Position + Vector3.new(0, 0.5, 0)
    local size = hb.Size
    local C0 = weld.C0
    local look = hrp.CFrame.LookVector
    local magnitude = (targetArm.Position - hb.Position).Magnitude
    pcall(function()
        SendPacket:FireServer("Use Punch", PUNCH_ID, t.char, v1, magnitude, size, C0, targetArm, targetArm.Size, look)
    end)
    pcall(function()
        PunchRemote:FireServer(t.char, hrp.Position, 1.8757749795913696, t.char:FindFirstChild("Head"))
    end)
end

-- =============================================
-- ХУК PUNCH
-- =============================================
_G._SPA8 = _G._SPA8 or {}
local S = _G._SPA8
local PunchClass = require(LP.PlayerScripts["StarterPlayerScripts Package"].Controller.Character.Punch)
if not S.oP then S.oP = PunchClass.Punch end

PunchClass.Punch = function(self, ...)
    local r = S.oP(self, ...)
    
    if MANUAL_LOCK_ENABLED then
        local t = getClosest()
        if t then
            MLG_LOCKED_TARGET = t.char
            MLG_LOCKED_NAME = t.name
            print("🔒 РУЧНОЙ УДАР → ЛОК:", t.name)
        end
    end
    
    if Enabled then
        local t = getClosest()
        if t then fireAt(t) end
    end
    
    return r
end

-- =============================================
-- CONTROLLER + ABILITY
-- =============================================
local CONTROLLER = nil
local ABILITY = nil

local function findController()
    if not getgc then return nil, nil end
    local ok, gc = pcall(function() return getgc(true) end)
    if not ok or not gc then return nil, nil end
    for _, obj in ipairs(gc) do
        if type(obj) == "table" and obj.OnM1Use ~= nil and obj.Modifiers ~= nil then
            return obj, obj.Components and obj.Components.Ability
        end
    end
    return nil, nil
end

CONTROLLER, ABILITY = findController()
print("🔍 Controller:", CONTROLLER and "✅" or "❌")
print("🔍 Ability:", ABILITY and "✅" or "❌")

-- =============================================
-- СПИН + УГОЛ
-- =============================================
local lastYaw = nil
local accumulatedYaw = 0
local lastAccumTime = tick()
local isSpinning = false
local spinCooldown = 0

local function detectSpin()
    local char = LP.Character
    if not char then return false end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local currentYaw = math.atan2(hrp.CFrame.LookVector.X, hrp.CFrame.LookVector.Z)
    if lastYaw then
        local delta = math.abs(math.deg(currentYaw - lastYaw))
        if delta > 180 then delta = 360 - delta end
        accumulatedYaw = accumulatedYaw + delta
    end
    lastYaw = currentYaw
    local now = tick()
    if now - lastAccumTime >= 0.2 then
        if accumulatedYaw > MLG_SPIN_THRESHOLD then
            isSpinning = true
            spinCooldown = now + 1.0
        end
        accumulatedYaw = 0
        lastAccumTime = now
    end
    if now > spinCooldown then isSpinning = false end
    return isSpinning
end

local function getAngle(target)
    local myChar = LP.Character
    if not myChar then return 999 end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return 999 end
    local look = myHrp.CFrame.LookVector
    local dir = (target.part.Position - myHrp.Position).Unit
    return math.deg(math.acos(math.clamp(look:Dot(dir), -1, 1)))
end

local function useAbility()
    if not ABILITY then return false end
    return pcall(function() ABILITY.MainMoveKeybind:Activate() end)
end

local function aimAtTarget(target)
    local myChar = LP.Character
    if not myChar then return end
    local myHrp = myChar:FindFirstChild("HumanoidRootPart")
    if not myHrp then return end
    local lookCF = CFrame.lookAt(myHrp.Position, Vector3.new(target.part.Position.X, myHrp.Position.Y, target.part.Position.Z))
    myChar:PivotTo(lookCF)
    myHrp.CFrame = lookCF
end

-- =============================================
-- HIGHLIGHT
-- =============================================
local hl = Instance.new("Highlight")
hl.Name = "SPA_InRange"
hl.FillColor = Color3.fromRGB(0, 255, 100)
hl.OutlineColor = Color3.fromRGB(0, 255, 150)
hl.FillTransparency = 0.6
hl.OutlineTransparency = 0
hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
hl.Enabled = false
hl.Parent = workspace

-- =============================================
-- AUTO-ATTACK
-- =============================================
local lastAutoAttack = 0
task.spawn(function()
    while true do
        task.wait(0.1)
        if Enabled then
            local t = getClosest()
            if t then
                hl.Adornee = t.char
                hl.Enabled = true
                if AUTO_ATTACK and (tick() - lastAutoAttack) >= AUTO_COOLDOWN then
                    lastAutoAttack = tick()
                    pcall(function() fireAt(t) end)
                end
            else
                hl.Enabled = false
            end
        else
            hl.Enabled = false
        end
    end
end)

-- =============================================
-- MLG AUTO-HIT (без continue)
-- =============================================
task.spawn(function()
    while true do
        task.wait(0.1)
        if MLG_ENABLED then
            local target = getClosestForMLG()
            if target then
                if not detectSpin() then
                    print("═══ MLG: СПИН ═══")
                    useAbility()
                    local waitStart = tick()
                    while tick() - waitStart < MLG_SPIN_WAIT_MAX do
                        task.wait(0.1)
                        if detectSpin() then break end
                    end
                end
                
                local angleWaitStart = tick()
                local shot = false
                while tick() - angleWaitStart < MLG_SPIN_WAIT_MAX do
                    task.wait(0.02)
                    target = getClosestForMLG()
                    if not target then break end
                    local a = getAngle(target)
                    if a < MLG_ANGLE_THRESHOLD then
                        print("═══ MLG: ВЫСТРЕЛ (угол " .. string.format("%.1f", a) .. ") ═══")
                        if AIM_BEFORE_SHOT then
                            aimAtTarget(target)
                            task.wait(0.01)
                            target = getClosestForMLG()
                            if target then aimAtTarget(target) end
                        end
                        useAbility()
                        shot = true
                        break
                    end
                end
                if not shot then print("⚠️ MLG: угол не достигнут") end
                task.wait(MLG_CYCLE_DELAY)
            else
                task.wait(0.3)
            end
        else
            task.wait(0.5)
        end
    end
end)

-- =============================================
-- GUI
-- =============================================
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.Name = "SilentPunchAssist"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 370)
frame.Position = UDim2.new(0, 20, 0, 20)
frame.BackgroundColor3 = Color3.fromRGB(28, 28, 38)
frame.BorderSizePixel = 1
frame.Active = true
frame.Draggable = true

local headerBar = Instance.new("Frame", frame)
headerBar.Size = UDim2.new(1, 0, 0, 24)
headerBar.BackgroundColor3 = Color3.fromRGB(48, 48, 68)

local title = Instance.new("TextLabel", headerBar)
title.Size = UDim2.new(1, -50, 1, 0)
title.Position = UDim2.new(0, 5, 0, 0)
title.Text = "Punch + MLG v34"
title.BackgroundTransparency = 1
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.SourceSansBold
title.TextSize = 13
title.TextXAlignment = Enum.TextXAlignment.Left

local minimizeBtn = Instance.new("TextButton", headerBar)
minimizeBtn.Size = UDim2.new(0, 20, 0, 20)
minimizeBtn.Position = UDim2.new(1, -25, 0, 2)
minimizeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
minimizeBtn.Text = "—"
minimizeBtn.TextColor3 = Color3.new(1, 1, 1)
minimizeBtn.Font = Enum.Font.SourceSansBold
minimizeBtn.TextSize = 18

local content = Instance.new("Frame", frame)
content.Size = UDim2.new(1, 0, 1, -24)
content.Position = UDim2.new(0, 0, 0, 24)
content.BackgroundTransparency = 1

local toggle = Instance.new("TextButton", content)
toggle.Size = UDim2.new(0, 240, 0, 28)
toggle.Position = UDim2.new(0, 10, 0, 6)
toggle.Text = "PUNCH: ON"
toggle.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
toggle.TextColor3 = Color3.new(1, 1, 1)
toggle.Font = Enum.Font.SourceSansBold
toggle.TextSize = 14

local autoBtn = Instance.new("TextButton", content)
autoBtn.Size = UDim2.new(0, 240, 0, 28)
autoBtn.Position = UDim2.new(0, 10, 0, 38)
autoBtn.Text = "AUTO-ATTACK: ON"
autoBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
autoBtn.TextColor3 = Color3.new(1, 1, 1)
autoBtn.Font = Enum.Font.SourceSansBold
autoBtn.TextSize = 13

local mlgBtn = Instance.new("TextButton", content)
mlgBtn.Size = UDim2.new(0, 240, 0, 28)
mlgBtn.Position = UDim2.new(0, 10, 0, 70)
mlgBtn.Text = "🎯 MLG: OFF"
mlgBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 50)
mlgBtn.TextColor3 = Color3.new(1, 1, 1)
mlgBtn.Font = Enum.Font.SourceSansBold
mlgBtn.TextSize = 13

local lockOnBtn = Instance.new("TextButton", content)
lockOnBtn.Size = UDim2.new(0, 240, 0, 28)
lockOnBtn.Position = UDim2.new(0, 10, 0, 102)
lockOnBtn.Text = "🔒 РУЧНОЙ ЛОК: ON"
lockOnBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
lockOnBtn.TextColor3 = Color3.new(1, 1, 1)
lockOnBtn.Font = Enum.Font.SourceSansBold
lockOnBtn.TextSize = 12

local unlockBtn = Instance.new("TextButton", content)
unlockBtn.Size = UDim2.new(0, 240, 0, 22)
unlockBtn.Position = UDim2.new(0, 10, 0, 134)
unlockBtn.Text = "🔓 СБРОСИТЬ ЛОК"
unlockBtn.BackgroundColor3 = Color3.fromRGB(80, 40, 40)
unlockBtn.TextColor3 = Color3.new(1, 1, 1)
unlockBtn.Font = Enum.Font.SourceSansBold
unlockBtn.TextSize = 11

local wallBtn = Instance.new("TextButton", content)
wallBtn.Size = UDim2.new(0, 117, 0, 28)
wallBtn.Position = UDim2.new(0, 10, 0, 162)
wallBtn.Text = "🧱 СТЕНЫ: ON"
wallBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
wallBtn.TextColor3 = Color3.new(1, 1, 1)
wallBtn.Font = Enum.Font.SourceSansBold
wallBtn.TextSize = 12

local heightBtn = Instance.new("TextButton", content)
heightBtn.Size = UDim2.new(0, 117, 0, 28)
heightBtn.Position = UDim2.new(0, 133, 0, 162)
heightBtn.Text = "⬆️ ВЫСОТА: ON"
heightBtn.BackgroundColor3 = Color3.fromRGB(40, 160, 90)
heightBtn.TextColor3 = Color3.new(1, 1, 1)
heightBtn.Font = Enum.Font.SourceSansBold
heightBtn.TextSize = 12

local track = Instance.new("Frame", content)
track.Size = UDim2.new(0, 240, 0, 8)
track.Position = UDim2.new(0, 10, 0, 200)
track.BackgroundColor3 = Color3.fromRGB(70, 70, 80)

local fill = Instance.new("Frame", track)
fill.Size = UDim2.new(0, 0, 1, 0)
fill.BackgroundColor3 = Color3.fromRGB(0, 200, 120)

local knob = Instance.new("TextButton", track)
knob.Size = UDim2.new(0, 14, 0, 18)
knob.Position = UDim2.new(0, -7, -0.62, 0)
knob.BackgroundColor3 = Color3.new(1, 1, 1)
knob.Text = ""
knob.AutoButtonColor = false

local valueBox = Instance.new("TextBox", content)
valueBox.Size = UDim2.new(0, 240, 0, 28)
valueBox.Position = UDim2.new(0, 10, 0, 220)
valueBox.Text = tostring(Range)
valueBox.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
valueBox.TextColor3 = Color3.new(1, 1, 1)
valueBox.Font = Enum.Font.SourceSans
valueBox.TextSize = 14
valueBox.ClearTextOnFocus = false

local lockLbl = Instance.new("TextLabel", content)
lockLbl.Size = UDim2.new(0, 240, 0, 18)
lockLbl.Position = UDim2.new(0, 10, 0, 254)
lockLbl.Text = "🔒 ЛОК: НЕТ"
lockLbl.BackgroundTransparency = 1
lockLbl.TextColor3 = Color3.fromRGB(255, 200, 0)
lockLbl.Font = Enum.Font.SourceSansBold
lockLbl.TextSize = 11

local spinLbl = Instance.new("TextLabel", content)
spinLbl.Size = UDim2.new(0, 240, 0, 18)
spinLbl.Position = UDim2.new(0, 10, 0, 274)
spinLbl.Text = "🌀 Спин: ВЫКЛ"
spinLbl.BackgroundTransparency = 1
spinLbl.TextColor3 = Color3.fromRGB(150, 150, 150)
spinLbl.Font = Enum.Font.SourceSansBold
spinLbl.TextSize = 12

local angleLbl = Instance.new("TextLabel", content)
angleLbl.Size = UDim2.new(0, 240, 0, 18)
angleLbl.Position = UDim2.new(0, 10, 0, 294)
angleLbl.Text = "Угол: ---°"
angleLbl.BackgroundTransparency = 1
angleLbl.TextColor3 = Color3.fromRGB(200, 200, 200)
angleLbl.Font = Enum.Font.SourceSans
angleLbl.TextSize = 11

local minimized = false
local fullSize = UDim2.new(0, 260, 0, 370)
local miniSize = UDim2.new(0, 260, 0, 24)
minimizeBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        frame.Size = miniSize
        content.Visible = false
        minimizeBtn.Text = "➕"
    else
        frame.Size = fullSize
        content.Visible = true
        minimizeBtn.Text = "—"
    end
end)

local function v2x(v) return (v - MIN) / (MAX - MIN) * track.AbsoluteSize.X end
local function x2v(x) return MIN + math.clamp(x / math.max(track.AbsoluteSize.X, 1), 0, 1) * (MAX - MIN) end
local function setVal(v, fb)
    v = math.clamp(math.round(v), MIN, MAX); Range = v; local x = v2x(v)
    knob.Position = UDim2.new(0, x - 7, -0.62, 0); fill.Size = UDim2.new(0, x, 1, 0)
    if not fb then valueBox.Text = tostring(v) end
end
local drag = false
knob.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true end end)
knob.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
UIS.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then setVal(x2v(i.Position.X - track.AbsolutePosition.X)) end end)
valueBox.FocusLost:Connect(function() local n = tonumber(valueBox.Text); if n then setVal(n, true) end end)

toggle.MouseButton1Click:Connect(function()
    Enabled = not Enabled
    toggle.Text = Enabled and "PUNCH: ON" or "PUNCH: OFF"
    toggle.BackgroundColor3 = Enabled and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(150, 50, 50)
end)

autoBtn.MouseButton1Click:Connect(function()
    AUTO_ATTACK = not AUTO_ATTACK
    autoBtn.Text = AUTO_ATTACK and "AUTO-ATTACK: ON" or "AUTO-ATTACK: OFF"
    autoBtn.BackgroundColor3 = AUTO_ATTACK and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(150, 50, 50)
end)

mlgBtn.MouseButton1Click:Connect(function()
    MLG_ENABLED = not MLG_ENABLED
    mlgBtn.Text = MLG_ENABLED and "🎯 MLG: ON ✅" or "🎯 MLG: OFF"
    mlgBtn.BackgroundColor3 = MLG_ENABLED and Color3.fromRGB(40, 160, 90) or Color3.fromRGB(150, 50, 50)
end)

lockOnBtn.MouseButton1Click:Connect(function()
    MANUAL_LOCK_ENABLED = not MANUAL_LOCK_ENABLED
    if not MANUAL_LOCK_ENABLED then
      
