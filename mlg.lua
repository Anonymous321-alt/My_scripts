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
local old=ESP_FOLDER:FindFirstChild(char.Name)
if old then old:Destroy() end
local h=Instance.new("Highlight")
h.Name=char.Name
h.Adornee=char
h.FillColor=Color3.fromRGB(255,255,0)
h.FillTransparency=0.5
h.OutlineColor=Color3.fromRGB(255,255,0)
h.OutlineTransparency=0
h.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
h.Parent=ESP_FOLDER
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
task.spawn(function()
while true do
task.wait(0.1)
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

-- ============================================================
-- WALLHOP MODULE v13 (fast anim + fast twist, fixed side)
-- ============================================================
local WH_ENABLED=false
local WH_MAX_HOPS=3
local WH_MIN_HOPS=2
local WH_POWERS={52,60,68}
local WH_HOP_CD=0.16
local WH_WALL_DIST=4.5
local WH_NORMAL_Y_MAX=0.20
local WH_FWD_DOT=0.15
local WH_APEX_VY=10
local WH_MIN_VY=-25
local WH_HORIZ_KEEP=0.10
local WH_REACT_MIN=0.02
local WH_REACT_MAX=0.05
local WH_START_HESIT=0.08
local WH_FATIGUE_MIN=0.4
local WH_FATIGUE_MAX=0.9
local WH_THINK_CHANCE=0.10
local WH_THINK_MIN=0.20
local WH_THINK_MAX=0.35
local WH_SKIP_CHANCE=0.06
local WH_MISS_LAST=0.08
local WH_MOOD_JITTER=3
local WH_ANIM_DUR=0.15
local WH_ANIM_JUMP_ID="rbxassetid://507765000"
local WH_TWIST_ENABLED=true
local WH_TWIST_MIN_DEG=60
local WH_TWIST_MAX_DEG=80
local WH_TWIST_SIGN=-1
local WH_GRAVITY=196.2
local WH_hops=0
local WH_hopTarget=3
local WH_nextHopAt=0
local WH_seriesMood=0
local WH_fatiguedUntil=0
local WH_skippedStart=false
local WH_twistConn=nil
local WH_curAnimTrack=nil
local WH_rp=RaycastParams.new()
WH_rp.FilterType=Enum.RaycastFilterType.Exclude
local function WH_getRoot()
local c=L.Character
return c and c:FindFirstChild("HumanoidRootPart")
end
local function WH_getHum()
local c=L.Character
return c and c:FindFirstChildOfClass("Humanoid")
end
local function WH_onGround()
local h=WH_getHum()
if not h then return true end
return h.FloorMaterial~=Enum.Material.Air
end
local function WH_findWall()
local c=L.Character
local r=WH_getRoot()
if not c or not r then return nil end
WH_rp.FilterDescendantsInstances={c}
local cf=r.CFrame
local look=cf.LookVector
local dirs={cf.LookVector,-cf.LookVector,cf.RightVector,-cf.RightVector}
for _,d in ipairs(dirs) do
local hit=workspace:Raycast(r.Position,d*WH_WALL_DIST,WH_rp)
if hit and hit.Instance and hit.Normal then
if math.abs(hit.Normal.Y)<WH_NORMAL_Y_MAX and look:Dot(-hit.Normal)>WH_FWD_DOT then
return hit
end
end
end
return nil
end
local function WH_getVel(r)
local ok,v=pcall(function()return r.AssemblyLinearVelocity end)
if ok and v then return v end
return r.Velocity
end
local function WH_setVel(r,v)
local ok=pcall(function()r.AssemblyLinearVelocity=v end)
if not ok then r.Velocity=v end
end
local function WH_playAnim(id)
local c=L.Character
if not c then return end
local h=c:FindFirstChildOfClass("Humanoid")
local a=h and h:FindFirstChildOfClass("Animator")
if not a then return end
if WH_curAnimTrack then
pcall(function()WH_curAnimTrack:Stop(0) end)
WH_curAnimTrack=nil
end
local anim=Instance.new("Animation")
anim.AnimationId=id
local ok,track=pcall(function()return a:LoadAnimation(anim) end)
if not ok or not track then return end
WH_curAnimTrack=track
pcall(function()track:Play(0.02) end)
task.delay(WH_ANIM_DUR,function()
if WH_curAnimTrack==track then
pcall(function()track:Stop(0.03) end)
WH_curAnimTrack=nil
end
end)
end
local function WH_startTwist(wallNormal,pwr)
if not WH_TWIST_ENABLED then return end
if WH_twistConn then pcall(function()WH_twistConn:Disconnect() end) WH_twistConn=nil end
local baseDir=Vector3.new(-wallNormal.X,0,-wallNormal.Z)
if baseDir.Magnitude<0.01 then return end
baseDir=baseDir.Unit
local sign=WH_TWIST_SIGN
local maxAngle=math.rad(WH_TWIST_MIN_DEG+math.random()*(WH_TWIST_MAX_DEG-WH_TWIST_MIN_DEG))
local dur=(2*pwr)/WH_GRAVITY
local t0=tick()
WH_twistConn=R.RenderStepped:Connect(function()
local t=tick()-t0
if t>dur then
pcall(function()WH_twistConn:Disconnect() end)
WH_twistConn=nil
return
end
local r=WH_getRoot()
if not r then return end
local phase=t/dur
local amp=math.sin(phase*math.pi)^0.55
local angle=maxAngle*amp*sign
local dir=(CFrame.Angles(0,angle,0)*baseDir)
pcall(function()r.CFrame=CFrame.new(r.Position,r.Position+dir) end)
end)
end
local function WH_stopTwist()
if WH_twistConn then
pcall(function()WH_twistConn:Disconnect() end)
WH_twistConn=nil
end
end
local function WH_doHop(hit)
local r=WH_getRoot()
if not r then return end
if WH_hops>=1 and math.random()<WH_SKIP_CHANCE then
WH_nextHopAt=tick()+WH_HOP_CD+0.1+math.random()*0.1
return
end
if WH_hops>=1 and math.random()<WH_THINK_CHANCE then
WH_nextHopAt=tick()+WH_THINK_MIN+math.random()*(WH_THINK_MAX-WH_THINK_MIN)
return
end
local idx=math.min(WH_hops+1,#WH_POWERS)
local pwr=WH_POWERS[idx]+WH_seriesMood+(math.random()-0.5)*2
if WH_hops==WH_hopTarget-1 and math.random()<WH_MISS_LAST then
pwr=pwr*0.65
end
local v=WH_getVel(r)
WH_setVel(r,Vector3.new(v.X*WH_HORIZ_KEEP,pwr,v.Z*WH_HORIZ_KEEP))
WH_playAnim(WH_ANIM_JUMP_ID)
if hit and hit.Normal then
WH_startTwist(hit.Normal,pwr)
end
WH_hops=WH_hops+1
local react=WH_REACT_MIN+math.random()*(WH_REACT_MAX-WH_REACT_MIN)
WH_nextHopAt=tick()+WH_HOP_CD+react
end
R.Heartbeat:Connect(function()
if not WH_ENABLED then
if WH_hops~=0 then WH_hops=0 end
WH_stopTwist()
if WH_curAnimTrack then pcall(function()WH_curAnimTrack:Stop(0) end) WH_curAnimTrack=nil end
return
end
if WH_onGround() then
WH_stopTwist()
if WH_hops>=WH_MAX_HOPS then
WH_fatiguedUntil=tick()+WH_FATIGUE_MIN+math.random()*(WH_FATIGUE_MAX-WH_FATIGUE_MIN)
end
if WH_hops>0 then
WH_seriesMood=(math.random()-0.5)*2*WH_MOOD_JITTER
end
WH_hops=0
WH_hopTarget=(math.random()<0.7)and WH_MAX_HOPS or WH_MIN_HOPS
WH_skippedStart=false
return
end
if WH_hops>=WH_hopTarget then return end
if tick()<WH_fatiguedUntil then return end
if WH_hops==0 and not WH_skippedStart then
if math.random()<WH_START_HESIT then
WH_skippedStart=true
WH_nextHopAt=tick()+0.25+math.random()*0.25
return
end
WH_skippedStart=true
end
if tick()<WH_nextHopAt then return end
local r=WH_getRoot()
if not r then return end
local vy=WH_getVel(r).Y
if vy>WH_APEX_VY then return end
if vy<WH_MIN_VY then return end
local h=WH_getHum()
if not h or h.MoveDirection.Magnitude<0.1 then return end
local hit=WH_findWall()
if hit then WH_doHop(hit) end
end)
-- ============================================================
-- END WALLHOP MODULE
-- ============================================================

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
local whBtn=Instance.new("TextButton",ct)
whBtn.Size=UDim2.new(0,240,0,26)
whBtn.Position=UDim2.new(0,10,0,154)
whBtn.Text="WALLHOP: OFF"
whBtn.BackgroundColor3=Color3.fromRGB(150,50,50)
whBtn.TextColor3=Color3.new(1,1,1)
whBtn.Font=Enum.Font.SourceSansBold
whBtn.TextSize=13
local lb=Instance.new("TextButton",ct)
lb.Size=UDim2.new(0,240,0,26)
lb.Position=UDim2.new(0,10,0,184)
lb.Text="LOCK: ON"
lb.BackgroundColor3=Color3.fromRGB(40,160,90)
lb.TextColor3=Color3.new(1,1,1)
lb.Font=Enum.Font.SourceSansBold
lb.TextSize=12
local ub=Instance.new("TextButton",ct)
ub.Size=UDim2.new(0,240,0,20)
ub.Position=UDim2.new(0,10,0,214)
ub.Text="UNLOCK"
ub.BackgroundColor3=Color3.fromRGB(80,40,40)
ub.TextColor3=Color3.new(1,1,1)
ub.Font=Enum.Font.SourceSansBold
ub.TextSize=11
local sb=Instance.new("TextButton",ct)
sb.Size=UDim2.new(0,240,0,26)
sb.Position=UDim2.new(0,10,0,240)
sb.Text="SNIPER: NEAREST"
sb.BackgroundColor3=Color3.fromRGB(60,80,140)
sb.TextColor3=Color3.new(1,1,1)
sb.Font=Enum.Font.SourceSansBold
sb.TextSize=12
local so=Instance.new("TextButton",ct)
so.Size=UDim2.new(0,240,0,20)
so.Position=UDim2.new(0,10,0,270)
so.Text="SNIPER OFF"
so.BackgroundColor3=Color3.fromRGB(100,40,40)
so.TextColor3=Color3.new(1,1,1)
so.Font=Enum.Font.SourceSansBold
so.TextSize=11
local wb=Instance.new("TextButton",ct)
wb.Size=UDim2.new(0,117,0,26)
wb.Position=UDim2.new(0,10,0,296)
wb.Text="WALL: ON"
wb.BackgroundColor3=Color3.fromRGB(40,160,90)
wb.TextColor3=Color3.new(1,1,1)
wb.Font=Enum.Font.SourceSansBold
wb.TextSize=12
local hb2=Instance.new("TextButton",ct)
hb2.Size=UDim2.new(0,117,0,26)
hb2.Position=UDim2.new(0,133,0,296)
hb2.Text="HEIGHT: ON"
hb2.BackgroundColor3=Color3.fromRGB(40,160,90)
hb2.TextColor3=Color3.new(1,1,1)
hb2.Font=Enum.Font.SourceSansBold
hb2.TextSize=12
local tr=Instance.new("Frame",ct)
tr.Size=UDim2.new(0,240,0,8)
tr.Position=UDim2.new(0,10,0,362)
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
vb.Position=UDim2.new(0,10,0,382)
vb.Text=tostring(Rg)
vb.BackgroundColor3=Color3.fromRGB(20,20,28)
vb.TextColor3=Color3.new(1,1,1)
vb.Font=Enum.Font.SourceSans
vb.TextSize=13
vb.ClearTextOnFocus=false
local ll=Instance.new("TextLabel",ct)
ll.Size=UDim2.new(0,240,0,16)
ll.Position=UDim2.new(0,10,0,414)
ll.Text="LOCK: NONE"
ll.BackgroundTransparency=1
ll.TextColor3=Color3.fromRGB(255,200,0)
ll.Font=Enum.Font.SourceSansBold
ll.TextSize=11
local ol=Instance.new("TextLabel",ct)
ol.Size=UDim2.new(0,240,0,16)
ol.Position=UDim2.new(0,10,0,432)
ol.Text="SNIPER: OFF"
ol.BackgroundTransparency=1
ol.TextColor3=Color3.fromRGB(100,200,255)
ol.Font=Enum.Font.SourceSansBold
ol.TextSize=11
local sl=Instance.new("TextLabel",ct)
sl.Size=UDim2.new(0,240,0,16)
sl.Position=UDim2.new(0,10,0,450)
sl.Text="SPIN: OFF"
sl.BackgroundTransparency=1
sl.TextColor3=Color3.fromRGB(150,150,150)
sl.Font=Enum.Font.SourceSansBold
sl.TextSize=11
local al=Instance.new("TextLabel",ct)
al.Size=UDim2.new(0,240,0,16)
al.Position=UDim2.new(0,10,0,468)
al.Text="ANGLE: ---"
al.BackgroundTransparency=1
al.TextColor3=Color3.fromRGB(200,200,200)
al.Font=Enum.Font.SourceSans
al.TextSize=11
local cl=Instance.new("TextLabel",ct)
cl.Size=UDim2.new(0,240,0,16)
cl.Position=UDim2.new(0,10,0,486)
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
local function X2(x)re
