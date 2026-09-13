local RS=game:GetService("ReplicatedStorage")
local P=game:GetService("Players")
local U=game:GetService("UserInputService")
local R=game:GetService("RunService")
local L=P.LocalPlayer
local S=RS["ReplicatedStorage Package"]["Remote Events"].SendPacket
local M=RS["ReplicatedStorage Package"]["Remote Events"].Punch
local ID=81285671124281
local Mn,Mx,Rg,En=5,300,12,true
local AA=true
local AC=0.35
local W=true
local H=true
local MH=5
local TR=100
local ME=false
local AS=false
local MA=15
local MS=3.0
local MC=2.0
local MT=100
local AB=true
local ML=true
local LT=nil
local LN=""
local SL=false
local ST=nil
local SN=""
local ESP_ON=false
local ESP_FOLDER=Instance.new("Folder",workspace)
ESP_FOLDER.Name="ESP_Players"
local RP=RaycastParams.new()
RP.FilterType=Enum.RaycastFilterType.Exclude
local function LOS(a,b,c)
if not W then return true end
RP.FilterDescendantsInstances={L.Character,c}
local d=b.Position-a.Position
local r=workspace:Raycast(a.Position,d,RP)
if r and r.Instance and(r.Instance.CanCollide or r.Instance.Anchored)then return false end
return true
end
local function CH(a,b)
if not H then return true end
return(b.Position.Y-a.Position.Y)<=MH
end
local function makeESP(char)
if not char or not char.Parent then return end
for _,v in ipairs(ESP_FOLDER:GetChildren()) do
if v.Name:find(char.Name) then v:Destroy() end
end
for _,part in ipairs(char:GetDescendants()) do
if part:IsA("BasePart") then
local box=Instance.new("SelectionBox")
box.Name=char.Name.."_"..part.Name
box.Adornee=part
box.Color3=Color3.fromRGB(255,255,0)
box.LineThickness=0.08
box.Transparency=0.3
box.SurfaceTransparency=0.8
box.Parent=ESP_FOLDER
end
end
end
local function clearESP()
for _,v in ipairs(ESP_FOLDER:GetChildren()) do v:Destroy() end
end
local function GC()
local c=L.Character
if not c then return nil end
local h=c:FindFirstChild("HumanoidRootPart")
if not h then return nil end
local t={}
for _,p in ipairs(P:GetPlayers())do
if p~=L and p.Character then
local q=p.Character:FindFirstChild("HumanoidRootPart")
local u=p.Character:FindFirstChild("Humanoid")
if q and q:IsA("BasePart")and u and u.Health>0 then
local d=(q.Position-h.Position).Magnitude
if d<=TR and CH(h,q)and LOS(h,q,p.Character)then table.insert(t,{char=p.Character,part=q,name=p.Name,dist=d})end
end
end
end
table.sort(t,function(a,b)return a.dist<b.dist end)
return t[1]
end
local function GM()
if SL then
if ST and ST.Parent then
local u=ST:FindFirstChild("Humanoid")
if u and u.Health>0 then
local c=L.Character
if c then
local h=c:FindFirstChild("HumanoidRootPart")
local q=ST:FindFirstChild("HumanoidRootPart")
if h and q then
local d=(q.Position-h.Position).Magnitude
if d<=TR then return{char=ST,part=q,name=SN,dist=d}end
end
end
end
end
return nil
end
if ML then
if LT then
if LT.Parent then
local u=LT:FindFirstChild("Humanoid")
if u and u.Health>0 then
local c=L.Character
if c then
local h=c:FindFirstChild("HumanoidRootPart")
local q=LT:FindFirstChild("HumanoidRootPart")
if h and q then
local d=(q.Position-h.Position).Magnitude
if d<=TR then return{char=LT,part=q,name=LN,dist=d}end
end
end
end
end
if LN~=""then print("LOCK OFF:",LN)end
LT=nil
LN=""
end
return nil
end
return GC()
end
local function F(t)
local c=L.Character
if not c then return end
local hb=c:FindFirstChild("Hitbox")
local h=c:FindFirstChild("HumanoidRootPart")
local w=h and h:FindFirstChild("Hitbox Weld")
if not(hb and h and w)then return end
local a=t.char:FindFirstChild("Right Arm")or t.char:FindFirstChild("RightHand")or t.part
local v=hb.Position+Vector3.new(0,0.5,0)
local s=hb.Size
local C=w.C0
local k=h.CFrame.LookVector
local m=(a.Position-hb.Position).Magnitude
pcall(function()S:FireServer("Use Punch",ID,t.char,v,m,s,C,a,a.Size,k)end)
pcall(function()M:FireServer(t.char,h.Position,1.8757749795913696,t.char:FindFirstChild("Head"))end)
end
_G._SPA8=_G._SPA8 or{}
local SS=_G._SPA8
local PC=require(L.PlayerScripts["StarterPlayerScripts Package"].Controller.Character.Punch)
if not SS.oP then SS.oP=PC.Punch end
PC.Punch=function(s,...)
local r=SS.oP(s,...)
if not SL then
if ML and not LT then
local t=GC()
if t then LT=t.char LN=t.name print("LOCK:",t.name)end
end
if En then
local t=GC()
if t then F(t)end
end
end
return r
end
L.CharacterAdded:Connect(function()
task.wait(2)
LT=nil
LN=""
print("RESPAWN: lock cleared")
end)
local CT=nil
local ABL=nil
local function FC()
if not getgc then return nil,nil end
local o,g=pcall(function()return getgc(true)end)
if not o or not g then return nil,nil end
for _,x in ipairs(g)do
if type(x)=="table"and x.OnM1Use~=nil and x.Modifiers~=nil then return x,x.Components and x.Components.Ability end
end
return nil,nil
end
CT,ABL=FC()
print("CT:",CT and "OK"or"NO")
print("ABL:",ABL and "OK"or"NO")
task.spawn(function()
while true do
task.wait(3)
local nCT,nABL=FC()
if nCT then CT=nCT end
if nABL then ABL=nABL end
local ok,newPC=pcall(function()return require(L.PlayerScripts["StarterPlayerScripts Package"].Controller.Character.Punch)end)
if ok and newPC and newPC~=PC then
PC=newPC
if not SS.oP then SS.oP=PC.Punch end
PC.Punch=function(s,...)
local r=SS.oP(s,...)
if not SL then
if ML and not LT then
local t=GC()
if t then LT=t.char LN=t.name print("LOCK:",t.name)end
end
if En then
local t=GC()
if t then F(t)end
end
end
return r
end
print("REHOOK PUNCH")
end
end
end)
local LY=nil
local AY=0
local AT=tick()
local IS=false
local SC=0
local function DS()
local c=L.Character
if not c then return false end
local h=c:FindFirstChild("HumanoidRootPart")
if not h then return false end
local y=math.atan2(h.CFrame.LookVector.X,h.CFrame.LookVector.Z)
if LY then
local d=math.abs(math.deg(y-LY))
if d>180 then d=360-d end
AY=AY+d
end
LY=y
local n=tick()
if n-AT>=0.2 then
if AY>MT then IS=true SC=n+1 end
AY=0
AT=n
end
if n>SC then IS=false end
return IS
end
local function GA(t)
local c=L.Character
if not c then return 999 end
local h=c:FindFirstChild("HumanoidRootPart")
if not h then return 999 end
local a=h.CFrame.LookVector
local b=(t.part.Position-h.Position).Unit
return math.deg(math.acos(math.clamp(a:Dot(b),-1,1)))
end
local function UA()
if not ABL then return false end
return pcall(function()ABL.MainMoveKeybind:Activate()end)
end
local function AT2(t)
local c=L.Character
if not c then return end
local h=c:FindFirstChild("HumanoidRootPart")
if not h then return end
local cf=CFrame.lookAt(h.Position,Vector3.new(t.part.Position.X,h.Position.Y,t.part.Position.Z))
c:PivotTo(cf)
h.CFrame=cf
end
local hl=Instance.new("Highlight")
hl.Name="SPA"
hl.FillColor=Color3.fromRGB(0,255,100)
hl.OutlineColor=Color3.fromRGB(0,255,150)
hl.FillTransparency=0.6
hl.OutlineTransparency=0
hl.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
hl.Enabled=false
hl.Parent=workspace
local LA=0
-- 🔥 ЦИКЛ ESP — обновляет всех каждые 0.2 сек
task.spawn(function()
while true do
task.wait(0.2)
if ESP_ON then
for _,p in ipairs(P:GetPlayers()) do
if p~=L and p.Character then
makeESP(p.Character)
end
end
else
clearESP()
end
end
end)
-- 🔥 Когда новый игрок заходит — сразу подсвечиваем
P.PlayerAdded:Connect(function(p)
if p~=L then
p.CharacterAdded:Connect(function(char)
task.wait(0.5)
if ESP_ON then makeESP(char) end
end)
if p.Character and ESP_ON then
task.wait(0.5)
makeESP(p.Character)
end
end
end)
-- 🔥 Когда ты респавнишься — обновляем всех
L.CharacterAdded:Connect(function()
task.wait(1)
if ESP_ON then
for _,p in ipairs(P:GetPlayers()) do
if p~=L and p.Character then
makeESP(p.Character)
end
end
end
end)
task.spawn(function()
while true do
task.wait(0.1)
if En then
local t=GM()
if t then
hl.Adornee=t.char
hl.Enabled=true
if AA and(tick()-LA)>=AC then LA=tick()pcall(function()F(t)end)end
else hl.Enabled=false end
else hl.Enabled=false end
end
end)
task.spawn(function()
while true do
task.wait(0.1)
if ME then
local t=GM()
if t then
if AS then
if not DS()then
print("MLG:SPIN (auto)")
UA()
local ws=tick()
while tick()-ws<MS do task.wait(0.1)if DS()then break end end
end
end
if DS() then
local aw=tick()
local sh=false
while tick()-aw<MS do
task.wait(0.02)
t=GM()
if not t then break end
local a=GA(t)
if a<MA then
print("MLG:SHOT",string.format("%.1f",a))
if AB then
AT2(t)
task.wait(0.01)
t=GM()
if t then AT2(t)end
end
UA()
sh=true
break
end
end
if not sh then print("MLG:miss")end
task.wait(MC)
else
task.wait(0.3)
end
else task.wait(0.3)end
else task.wait(0.5)end
end
end)
local g=Instance.new("ScreenGui",L:WaitForChild("PlayerGui"))
g.Name="SPA"
g.ResetOnSpawn=false
local f=Instance.new("Frame",g)
f.Size=UDim2.new(0,260,0,530)
f.Position=UDim2.new(0,20,0,20)
f.BackgroundColor3=Color3.fromRGB(28,28,38)
f.BorderSizePixel=1
f.Active=true
f.Draggable=true
local hb=Instance.new("Frame",f)
hb.Size=UDim2.new(1,0,0,24)
hb.BackgroundColor3=Color3.fromRGB(48,48,68)
local t1=Instance.new("TextLabel",hb)
t1.Size=UDim2.new(1,-50,1,0)
t1.Position=UDim2.new(0,5,0,0)
t1.Text="Punch+MLG v42"
t1.BackgroundTransparency=1
t1.TextColor3=Color3.new(1,1,1)
t1.Font=Enum.Font.SourceSansBold
t1.TextSize=13
t1.TextXAlignment=Enum.TextXAlignment.Left
local mb=Instance.new("TextButton",hb)
mb.Size=UDim2.new(0,20,0,20)
mb.Position=UDim2.new(1,-25,0,2)
mb.BackgroundColor3=Color3.fromRGB(80,80,100)
mb.Text="—"
mb.TextColor3=Color3.new(1,1,1)
mb.Font=Enum.Font.SourceSansBold
mb.TextSize=18
local ct=Instance.new("Frame",f)
ct.Size=UDim2.new(1,0,1,-24)
ct.Position=UDim2.new(0,0,0,24)
ct.BackgroundTransparency=1
local tb=Instance.new("TextButton",ct)
tb.Size=UDim2.new(0,240,0,26)
tb.Position=UDim2.new(0,10,0,4)
tb.Text="PUNCH: ON"
tb.BackgroundColor3=Color3.fromRGB(40,160,90)
tb.TextColor3=Color3.new(1,1,1)
tb.Font=Enum.Font.SourceSansBold
tb.TextSize=13
local ab=Instance.new("TextButton",ct)
ab.Size=UDim2.new(0,240,0,26)
ab.Position=UDim2.new(0,10,0,34)
ab.Text="AUTO: ON"
ab.BackgroundColor3=Color3.fromRGB(40,160,90)
ab.TextColor3=Color3.new(1,1,1)
ab.Font=Enum.Font.SourceSansBold
ab.TextSize=13
local ml=Instance.new("TextButton",ct)
ml.Size=UDim2.new(0,240,0,26)
ml.Position=UDim2.new(0,10,0,64)
ml.Text="MLG: OFF"
ml.BackgroundColor3=Color3.fromRGB(150,50,50)
ml.TextColor3=Color3.new(1,1,1)
ml.Font=Enum.Font.SourceSansBold
ml.TextSize=13
local asp=Instance.new("TextButton",ct)
asp.Size=UDim2.new(0,240,0,26)
asp.Position=UDim2.new(0,10,0,94)
asp.Text="AUTO SPIN: OFF"
asp.BackgroundColor3=Color3.fromRGB(150,50,50)
asp.TextColor3=Color3.new(1,1,1)
asp.Font=Enum.Font.SourceSansBold
asp.TextSize=13
local espBtn=Instance.new("TextButton",ct)
espBtn.Size=UDim2.new(0,240,0,26)
espBtn.Position=UDim2.new(0,10,0,124)
espBtn.Text="ESP: OFF"
espBtn.BackgroundColor3=Color3.fromRGB(150,50,50)
espBtn.TextColor3=Color3.new(1,1,1)
espBtn.Font=Enum.Font.SourceSansBold
espBtn.TextSize=13
local lb=Instance.new("TextButton",ct)
lb.Size=UDim2.new(0,240,0,26)
lb.Position=UDim2.new(0,10,0,154)
lb.Text="LOCK: ON"
lb.BackgroundColor3=Color3.fromRGB(40,160,90)
lb.TextColor3=Color3.new(1,1,1)
lb.Font=Enum.Font.SourceSansBold
lb.TextSize=12
local ub=Instance.new("TextButton",ct)
ub.Size=UDim2.new(0,240,0,20)
ub.Position=UDim2.new(0,10,0,184)
ub.Text="UNLOCK"
ub.BackgroundColor3=Color3.fromRGB(80,40,40)
ub.TextColor3=Color3.new(1,1,1)
ub.Font=Enum.Font.SourceSansBold
ub.TextSize=11
local sb=Instance.new("TextButton",ct)
sb.Size=UDim2.new(0,240,0,26)
sb.Position=UDim2.new(0,10,0,210)
sb.Text="SNIPER: NEAREST"
sb.BackgroundColor3=Color3.fromRGB(60,80,140)
sb.TextColor3=Color3.new(1,1,1)
sb.Font=Enum.Font.SourceSansBold
sb.TextSize=12
local so=Instance.new("TextButton",ct)
so.Size=UDim2.new(0,240,0,20)
so.Position=UDim2.new(0,10,0,240)
so.Text="SNIPER OFF"
so.BackgroundColor3=Color3.fromRGB(100,40,40)
so.TextColor3=Color3.new(1,1,1)
so.Font=Enum.Font.SourceSansBold
so.TextSize=11
local wb=Instance.new("TextButton",ct)
wb.Size=UDim2.new(0,117,0,26)
wb.Position=UDim2.new(0,10,0,266)
wb.Text="WALL: ON"
wb.BackgroundColor3=Color3.fromRGB(40,160,90)
wb.TextColor3=Color3.new(1,1,1)
wb.Font=Enum.Font.SourceSansBold
wb.TextSize=12
local hb2=Instance.new("TextButton",ct)
hb2.Size=UDim2.new(0,117,0,26)
hb2.Position=UDim2.new(0,133,0,266)
hb2.Text="HEIGHT: ON"
hb2.BackgroundColor3=Color3.fromRGB(40,160,90)
hb2.TextColor3=Color3.new(1,1,1)
hb2.Font=Enum.Font.SourceSansBold
hb2.TextSize=12
local tr=Instance.new("Frame",ct)
tr.Size=UDim2.new(0,240,0,8)
tr.Position=UDim2.new(0,10,0,302)
tr.BackgroundColor3=Color3.fromRGB(70,70,80)
local fl=Instance.new("Frame",tr)
fl.Size=UDim2.new(0,0,1,0)
fl.BackgroundColor3=Color3.fromRGB(0,200,120)
local kn=Instance.new("TextButton",tr)
kn.Size=UDim2.new(0,14,0,18)
kn.Position=UDim2.new(0,-7,-0.62,0)
kn.BackgroundColor3=Color3.new(1,1,1)
kn.Text=""
kn.AutoButtonColor=false
local vb=Instance.new("TextBox",ct)
vb.Size=UDim2.new(0,240,0,26)
vb.Position=UDim2.new(0,10,0,322)
vb.Text=tostring(Rg)
vb.BackgroundColor3=Color3.fromRGB(20,20,28)
vb.TextColor3=Color3.new(1,1,1)
vb.Font=Enum.Font.SourceSans
vb.TextSize=13
vb.ClearTextOnFocus=false
local ll=Instance.new("TextLabel",ct)
ll.Size=UDim2.new(0,240,0,16)
ll.Position=UDim2.new(0,10,0,354)
ll.Text="LOCK: NONE"
ll.BackgroundTransparency=1
ll.TextColor3=Color3.fromRGB(255,200,0)
ll.Font=Enum.Font.SourceSansBold
ll.TextSize=11
local ol=Instance.new("TextLabel",ct)
ol.Size=UDim2.new(0,240,0,16)
ol.Position=UDim2.new(0,10,0,372)
ol.Text="SNIPER: OFF"
ol.BackgroundTransparency=1
ol.TextColor3=Color3.fromRGB(100,200,255)
ol.Font=Enum.Font.SourceSansBold
ol.TextSize=11
local sl=Instance.new("TextLabel",ct)
sl.Size=UDim2.new(0,240,0,16)
sl.Position=UDim2.new(0,10,0,390)
sl.Text="SPIN: OFF"
sl.BackgroundTransparency=1
sl.TextColor3=Color3.fromRGB(150,150,150)
sl.Font=Enum.Font.SourceSansBold
sl.TextSize=11
local al=Instance.new("TextLabel",ct)
al.Size=UDim2.new(0,240,0,16)
al.Position=UDim2.new(0,10,0,408)
al.Text="ANGLE: ---"
al.BackgroundTransparency=1
al.TextColor3=Color3.fromRGB(200,200,200)
al.Font=Enum.Font.SourceSans
al.TextSize=11
local cl=Instance.new("TextLabel",ct)
cl.Size=UDim2.new(0,240,0,16)
cl.Position=UDim2.new(0,10,0,426)
cl.Text="CT: ? | ABL: ?"
cl.BackgroundTransparency=1
cl.TextColor3=Color3.fromRGB(180,180,180)
cl.Font=Enum.Font.SourceSans
cl.TextSize=10
local mn=false
local fs=UDim2.new(0,260,0,530)
local ms=UDim2.new(0,260,0,24)
mb.MouseButton1Click:Connect(function()
mn=not mn
if mn then f.Size=ms ct.Visible=false mb.Text="+"else f.Size=fs ct.Visible=true mb.Text="—"end
end)
local function V2(v)return(v-Mn)/(Mx-Mn)*tr.AbsoluteSize.X end
local function X2(x)return Mn+math.clamp(x/math.max(tr.AbsoluteSize.X,1),0,1)*(Mx-Mn)end
local function SV(v,fb)
v=math.clamp(math.round(v),Mn,Mx)Rg=v
local x=V2(v)
kn.Position=UDim2.new(0,x-7,-0.62,0)
fl.Size=UDim2.new(0,x,1,0)
if not fb then vb.Text=tostring(v)end
end
local dr=false
kn.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=true end end)
kn.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then dr=false end end)
U.InputChanged:Connect(function(i)if dr and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)then SV(X2(i.Position.X-tr.AbsolutePosition.X))end end)
vb.FocusLost:Connect(function()local n=tonumber(vb.Text)if n then SV(n,true)end end)
tb.MouseButton1Click:Connect(function()En=not En tb.Text=En and"PUNCH: ON"or"PUNCH: OFF"tb.BackgroundColor3=En and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
ab.MouseButton1Click:Connect(function()AA=not AA ab.Text=AA and"AUTO: ON"or"AUTO: OFF"ab.BackgroundColor3=AA and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
ml.MouseButton1Click:Connect(function()ME=not ME ml.Text=ME and"MLG: ON"or"MLG: OFF"ml.BackgroundColor3=ME and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
asp.MouseButton1Click:Connect(function()AS=not AS asp.Text=AS and"AUTO SPIN: ON"or"AUTO SPIN: OFF"asp.BackgroundColor3=AS and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
espBtn.MouseButton1Click:Connect(function()
ESP_ON=not ESP_ON
espBtn.Text=ESP_ON and "ESP: ON" or "ESP: OFF"
espBtn.BackgroundColor3=ESP_ON and Color3.fromRGB(40,160,90) or Color3.fromRGB(150,50,50)
if not ESP_ON then clearESP() end
end)
lb.MouseButton1Click:Connect(function()ML=not ML
if not ML then LT=nil LN=""end
lb.Text=ML and"LOCK: ON"or"LOCK: OFF"
lb.BackgroundColor3=ML and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
ub.MouseButton1Click:Connect(function()if LT then print("UNLOCK:",LN)end LT=nil LN=""end)
sb.MouseButton1Click:Connect(function()
local t=GC()
if t then
ST=t.char
SN=t.name
SL=true
print("SNIPER LOCK:",t.name)
sb.Text="SNIPER: "..t.name
else
print("NO TARGET")
sb.Text="SNIPER: NO TARGET"
end
end)
so.MouseButton1Click:Connect(function()
if SL then print("SNIPER OFF:",SN)end
ST=nil
SN=""
SL=false
sb.Text="SNIPER: NEAREST"
end)
wb.MouseButton1Click:Connect(function()W=not W wb.Text=W and"WALL: ON"or"WALL: OFF"wb.BackgroundColor3=W and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
hb2.MouseButton1Click:Connect(function()H=not H hb2.Text=H and"HEIGHT: ON"or"HEIGHT: OFF"hb2.BackgroundColor3=H and Color3.fromRGB(40,160,90)or Color3.fromRGB(150,50,50)end)
task.spawn(function()
while true do
task.wait(0.15)
if g and g.Parent then
if ML then
if LT and LT.Parent then
local u=LT:FindFirstChild("Humanoid")
if u and u.Health>0 then ll.Text="LOCK: "..LN ll.TextColor3=Color3.fromRGB(255,200,0)else ll.Text="LOCK: NONE"ll.TextColor3=Color3.fromRGB(150,150,150)end
else ll.Text="LOCK: NONE"ll.TextColor3=Color3.fromRGB(150,150,150)end
else ll.Text="LOCK OFF"ll.TextColor3=Color3.fromRGB(160,160,170)end
if SL then
if ST and ST.Parent then
local u=ST:FindFirstChild("Humanoid")
if u and u.Health>0 then ol.Text="SNIPER: "..SN ol.TextColor3=Color3.fromRGB(100,200,255)else ol.Text="SNIPER: DEAD (re-lock)"ol.TextColor3=Color3.fromRGB(255,100,100)end
else ol.Text="SNIPER: DEAD (re-lock)"ol.TextColor3=Color3.fromRGB(255,100,100)end
else ol.Text="SNIPER: OFF"ol.TextColor3=Color3.fromRGB(120,120,120)end
sl.Text="SPIN: "..(IS and"ON"or"OFF")
sl.TextColor3=IS and Color3.fromRGB(0,255,100)or Color3.fromRGB(150,150,150)
local tt=GM()or GC()
if tt then
local a=GA(tt)
al.Text=string.format("ANGLE: %.1f | %s",a,tt.name)
al.TextColor3=a<MA and Color3.fromRGB(0,255,0)or Color3.fromRGB(200,200,200)
else al.Text="ANGLE: ---"end
cl.Text="CT:"..(CT and"OK"or"NO").." | ABL:"..(ABL and"OK"or"NO")
end
end
end)
SV(Rg)
print("OK v42")
