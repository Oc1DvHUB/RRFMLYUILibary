--[[ Oc1DvHUB v33 - Notif + AntiAFK AllGame + FPS Boost ]]

print("[Oc1DvHUB] v33 start")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local Stats = game:GetService("Stats")
local MPS = game:GetService("MarketplaceService")
local CollectionService = game:GetService("CollectionService")
local Lighting = game:GetService("Lighting")
local LP = Players.LocalPlayer

print("[Oc1DvHUB] services loaded")

local BG_LIST = {
    {name = "UTAMA", id = "rbxassetid://124159830401488"},
    {name = "LANSKYP", id = "rbxassetid://70693066629625"},
    {name = "LUFFY", id = "rbxassetid://77692656015127"},
    {name = "TEXT", id = "rbxassetid://136619070579232"},
    {name = "MBG BLUE", id = "rbxassetid://75442560708193"},
}
local LOGO = "rbxassetid://78682047053280"
local SND = "rbxassetid://7405483764"
local WALK_ANIM = "rbxassetid://127964771902906"
local RARITY_ICON = "rbxassetid://117937760490149"

local IC = {
    Rumah="rbxassetid://10734950020", Farm="rbxassetid://10734942198",
    Admin="rbxassetid://10734950309", Visual="rbxassetid://10747373176",
    Live="rbxassetid://10734950020", Tema="rbxassetid://10734961809",
    Misc="rbxassetid://10734961809", Settings="rbxassetid://10734950309",
}

local C = {
    Pri = Color3.fromRGB(255, 145, 80),
    PriDark = Color3.fromRGB(210, 110, 55),
    Bg = Color3.fromRGB(24, 24, 28),
    Panel = Color3.fromRGB(34, 34, 40),
    Card = Color3.fromRGB(44, 44, 52),
    Txt = Color3.fromRGB(240, 240, 245),
    Dim = Color3.fromRGB(150, 150, 160),
    Off = Color3.fromRGB(70, 70, 78),
    Red = Color3.fromRGB(255, 100, 110),
    Grn = Color3.fromRGB(110, 220, 140),
    Yel = Color3.fromRGB(255, 210, 110),
    Cyn = Color3.fromRGB(110, 200, 245),
    Stroke = Color3.fromRGB(255,255,255),
}

local S = {
    AutoCoin=false, AutoFarm=false,
    CoinMode="tp",
    CoinDelay=0.3, CoinTPSpeed=0, CoinWalkSpeed=16, CoinMaxDist=1000,
    Fly=false, FlySpeed=50, Noclip=false, InfJump=false,
    WalkSpeed=16, JumpPower=50,
    ESP=false, ESPName=false, ESPDist=false, SelectedPlayer=nil,
    AntiAfk=false, FpsBoost=false,
    BGBrightness=0.55,
    StartTime=os.time(), GameName="Loading...",
    curBG=1, selBG=1, HueColor=C.Pri,
    RarityNotify=true, RarityPopup=true,
}

local colorEls = {}
local function track(obj, prop)
    table.insert(colorEls, {obj = obj, prop = prop})
end
local function applyColor(newC)
    C.Pri = newC
    local darker = Color3.new(newC.R*0.82, newC.G*0.82, newC.B*0.82)
    C.PriDark = darker
    for _, e in ipairs(colorEls) do
        if e.obj and e.obj.Parent then
            local val = newC
            if e.prop == "PriDark" then val = darker end
            pcall(function() e.obj[e.prop] = val end)
        end
    end
end

local searchables = {}
local function trackSearch(frame, text)
    frame:SetAttribute("SearchText", string.lower(text))
    table.insert(searchables, frame)
end

local pg = LP:WaitForChild("PlayerGui", 5) or game:GetService("CoreGui")
local old = pg:FindFirstChild("Oc1DvHUB_UI")
if old then old:Destroy() end

local SG = Instance.new("ScreenGui")
SG.Name = "Oc1DvHUB_UI"
SG.ResetOnSpawn = false
SG.IgnoreGuiInset = true
SG.Parent = pg

print("[Oc1DvHUB] screengui created")

task.spawn(function()
    local ok, info = pcall(function() return MPS:GetProductInfo(game.PlaceId) end)
    S.GameName = (ok and info and info.Name) or "Unknown"
end)

local function sfx()
    pcall(function()
        local s = Instance.new("Sound")
        s.SoundId = SND; s.Volume = 0.25; s.Parent = SG
        s:Play(); Debris:AddItem(s, 2)
    end)
end

-- ═══════ NOTIFICATION SYSTEM (bottom-right stack) ═══════
local NotifyContainer = Instance.new("Frame")
NotifyContainer.Name = "NotifyContainer"
NotifyContainer.Size = UDim2.new(0, 260, 0, 400)
NotifyContainer.Position = UDim2.new(1, -270, 1, -410)
NotifyContainer.BackgroundTransparency = 1
NotifyContainer.ZIndex = 490
NotifyContainer.Parent = SG

local NotifyLayout = Instance.new("UIListLayout", NotifyContainer)
NotifyLayout.FillDirection = Enum.FillDirection.Vertical
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Padding = UDim.new(0, 6)

local function NotifyUser(title, msg, tp)
    tp = tp or "info"
    local colors = {success=C.Grn, error=C.Red, warn=C.Yel, info=C.Cyn}
    local iconTxt = {success="OK", error="X", warn="!", info="i"}

    local card = Instance.new("Frame")
    card.Size = UDim2.new(0, 250, 0, 52)
    card.BackgroundColor3 = Color3.fromRGB(22,22,28)
    card.BackgroundTransparency = 0.08
    card.BorderSizePixel = 0
    card.ZIndex = 500
    card.Parent = NotifyContainer
    Instance.new("UICorner", card).CornerRadius = UDim.new(0,10)

    local stroke = Instance.new("UIStroke", card)
    stroke.Color = colors[tp] or C.Pri
    stroke.Thickness = 1.5
    stroke.Transparency = 0.2
    stroke.Parent = card

    local accent = Instance.new("Frame", card)
    accent.Size = UDim2.new(0, 4, 1, -8)
    accent.Position = UDim2.new(0, 4, 0, 4)
    accent.BackgroundColor3 = colors[tp] or C.Pri
    accent.BorderSizePixel = 0
    accent.ZIndex = 501
    Instance.new("UICorner", accent).CornerRadius = UDim.new(1,0)

    local iconBox = Instance.new("Frame", card)
    iconBox.Size = UDim2.new(0, 26, 0, 26)
    iconBox.Position = UDim2.new(0, 14, 0.5, -13)
    iconBox.BackgroundColor3 = colors[tp] or C.Pri
    iconBox.BackgroundTransparency = 0.15
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 501
    Instance.new("UICorner", iconBox).CornerRadius = UDim.new(1,0)

    local icon = Instance.new("TextLabel", iconBox)
    icon.Size = UDim2.new(1,0,1,0)
    icon.BackgroundTransparency = 1
    icon.Text = iconTxt[tp] or "i"
    icon.TextColor3 = Color3.fromRGB(20,20,20)
    icon.TextSize = 12
    icon.Font = Enum.Font.GothamBold
    icon.ZIndex = 502

    local titleL = Instance.new("TextLabel", card)
    titleL.Size = UDim2.new(1, -56, 0, 16)
    titleL.Position = UDim2.new(0, 48, 0, 8)
    titleL.BackgroundTransparency = 1
    titleL.Text = title
    titleL.TextColor3 = colors[tp] or C.Pri
    titleL.TextSize = 10
    titleL.Font = Enum.Font.GothamBold
    titleL.TextXAlignment = Enum.TextXAlignment.Left
    titleL.TextTruncate = Enum.TextTruncate.AtEnd
    titleL.ZIndex = 501

    local msgL = Instance.new("TextLabel", card)
    msgL.Size = UDim2.new(1, -56, 0, 22)
    msgL.Position = UDim2.new(0, 48, 0, 24)
    msgL.BackgroundTransparency = 1
    msgL.Text = msg
    msgL.TextColor3 = C.Txt
    msgL.TextSize = 10
    msgL.Font = Enum.Font.Gotham
    msgL.TextXAlignment = Enum.TextXAlignment.Left
    msgL.TextWrapped = true
    msgL.TextTruncate = Enum.TextTruncate.AtEnd
    msgL.ZIndex = 501

    -- Slide-in animation
    card.Position = UDim2.new(0, 300, 0, 0)
    TS:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0),
    }):Play()

    -- Auto dismiss
    task.delay(3.5, function()
        pcall(function()
            TS:Create(card, TweenInfo.new(0.3), {
                Position = UDim2.new(0, 300, 0, 0),
                BackgroundTransparency = 1,
            }):Play()
            task.wait(0.3)
            card:Destroy()
        end)
    end)
end

print("[Oc1DvHUB] notify system ready")

local function RarityPopup(coinName, big)
    if not S.RarityPopup then return end
    local w = big and 260 or 210
    local h = big and 88 or 68
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0,w,0,h)
    frame.BackgroundColor3 = Color3.fromRGB(20,20,26)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.ZIndex = 300
    frame.Parent = SG
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, big and 14 or 10)
    local s = Instance.new("UIStroke", frame)
    s.Color = big and Color3.fromRGB(255,215,80) or C.Pri
    s.Thickness = 2
    s.Transparency = 0.2
    s.Parent = frame

    local img = Instance.new("ImageLabel", frame)
    img.Size = big and UDim2.new(0,64,0,64) or UDim2.new(0,46,0,46)
    img.Position = big and UDim2.new(0,12,0.5,-32) or UDim2.new(0,8,0.5,-23)
    img.BackgroundTransparency = 1
    img.Image = RARITY_ICON
    img.ZIndex = 301

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, big and -84 or -60, 0, big and 24 or 18)
    title.Position = big and UDim2.new(0,84,0,14) or UDim2.new(0,60,0,10)
    title.BackgroundTransparency = 1
    title.Text = big and "RARITY BIG!" or "RARITY SMALL"
    title.TextColor3 = big and Color3.fromRGB(255,215,80) or C.Pri
    title.TextSize = big and 16 or 12
    title.Font = Enum.Font.GothamBold
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 301

    local sub = Instance.new("TextLabel", frame)
    sub.Size = UDim2.new(1, big and -84 or -60, 0, big and 32 or 24)
    sub.Position = big and UDim2.new(0,84,0,42) or UDim2.new(0,60,0,32)
    sub.BackgroundTransparency = 1
    sub.Text = tostring(coinName)
    sub.TextColor3 = C.Txt
    sub.TextSize = big and 12 or 10
    sub.Font = Enum.Font.GothamMedium
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.TextTruncate = Enum.TextTruncate.AtEnd
    sub.ZIndex = 301

    frame.Position = UDim2.new(0.5, -w/2, 0, -120)
    TS:Create(frame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -w/2, 0, 70)
    }):Play()

    task.delay(3, function()
        pcall(function()
            TS:Create(frame, TweenInfo.new(0.3), {
                Position = UDim2.new(0.5, -w/2, 0, -120),
                BackgroundTransparency = 1,
            }):Play()
            task.wait(0.3)
            frame:Destroy()
        end)
    end)
end

local LiveLog = {}
local liveRef = nil
local function Log(txt, tp)
    tp = tp or "info"
    table.insert(LiveLog, {t = "[" .. os.date("%H:%M:%S") .. "] " .. txt, tp = tp})
    if #LiveLog > 80 then table.remove(LiveLog, 1) end
    if liveRef and liveRef.Parent then
        task.spawn(function()
            pcall(function()
                for _, c in ipairs(liveRef:GetChildren()) do
                    if c:IsA("TextLabel") then c:Destroy() end
                end
                local cm = {success=C.Grn, error=C.Red, warn=C.Yel, info=C.Cyn, rarity=C.Yel}
                for i, e in ipairs(LiveLog) do
                    local l = Instance.new("TextLabel")
                    l.Size = UDim2.new(1,-8,0,14)
                    l.Position = UDim2.new(0,4,0,(i-1)*16)
                    l.BackgroundTransparency = 1
                    l.Text = e.t
                    l.TextColor3 = cm[e.tp] or C.Cyn
                    l.TextSize = 9
                    l.Font = Enum.Font.Gotham
                    l.TextXAlignment = Enum.TextXAlignment.Left
                    l.TextTruncate = Enum.TextTruncate.AtEnd
                    l.ZIndex = 15
                    l.Parent = liveRef
                end
                liveRef.CanvasSize = UDim2.new(0,0,0,#LiveLog*16+8)
                liveRef.CanvasPosition = Vector2.new(0, #LiveLog*16)
            end)
        end)
    end
    print("[LIVE]["..tp:upper().."] "..txt)
end

-- MAIN WINDOW
local TW, TH = 460, 350

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,TW,0,TH)
Main.Position = UDim2.new(0.5,-TW/2,0.5,-TH/2)
Main.BackgroundColor3 = C.Bg
Main.BackgroundTransparency = 1
Main.BorderSizePixel = 0
Main.ClipsDescendants = true
Main.Active = true
Main.Parent = SG
Instance.new("UICorner", Main).CornerRadius = UDim.new(0,16)

local bgI = Instance.new("ImageLabel", Main)
bgI.Size = UDim2.new(1,0,1,0)
bgI.BackgroundTransparency = 1
bgI.Image = BG_LIST[S.curBG].id
bgI.ImageTransparency = 0.15
bgI.ScaleType = Enum.ScaleType.Crop
bgI.ZIndex = 0
Instance.new("UICorner", bgI).CornerRadius = UDim.new(0,16)

local ovl = Instance.new("Frame", Main)
ovl.Size = UDim2.new(1,0,1,0)
ovl.BackgroundColor3 = C.Bg
ovl.BackgroundTransparency = S.BGBrightness
ovl.BorderSizePixel = 0
ovl.ZIndex = 1
Instance.new("UICorner", ovl).CornerRadius = UDim.new(0,16)

local mst = Instance.new("UIStroke", Main)
mst.Thickness = 1.5
mst.Color = C.Pri
mst.Transparency = 0.35
mst.Parent = Main
track(mst, "Color")

local TH_H = 36
local Title = Instance.new("Frame", Main)
Title.Size = UDim2.new(1,0,0,TH_H)
Title.BackgroundColor3 = C.PriDark
Title.BackgroundTransparency = 0.8
Title.BorderSizePixel = 0
Title.ZIndex = 20
Title.Active = true
Instance.new("UICorner", Title).CornerRadius = UDim.new(0,16)
track(Title, "BackgroundColor3")

local logoImg = Instance.new("ImageLabel", Title)
logoImg.Size = UDim2.new(0,20,0,20)
logoImg.Position = UDim2.new(0,12,0.5,-10)
logoImg.BackgroundTransparency = 1
logoImg.Image = LOGO
logoImg.ZIndex = 21

local Ttl = Instance.new("TextLabel", Title)
Ttl.Size = UDim2.new(1,-100,1,0)
Ttl.Position = UDim2.new(0,38,0,0)
Ttl.BackgroundTransparency = 1
Ttl.RichText = true
Ttl.Text = '<font color="rgb(240,240,245)">Oc1Dv</font><font color="rgb(255,145,80)">HUB</font>'
Ttl.TextSize = 13
Ttl.Font = Enum.Font.GothamBold
Ttl.TextXAlignment = Enum.TextXAlignment.Left
Ttl.ZIndex = 21

local function updTitleColor(nc)
    local r, g, b = math.floor(nc.R*255), math.floor(nc.G*255), math.floor(nc.B*255)
    Ttl.Text = string.format('<font color="rgb(240,240,245)">Oc1Dv</font><font color="rgb(%d,%d,%d)">HUB</font>', r, g, b)
end

local MinB = Instance.new("TextButton", Title)
MinB.Size = UDim2.new(0,12,0,12)
MinB.Position = UDim2.new(1,-44,0.5,-6)
MinB.BackgroundColor3 = Color3.fromRGB(255,200,70)
MinB.BorderSizePixel = 0
MinB.Text = ""
MinB.AutoButtonColor = false
MinB.ZIndex = 22
Instance.new("UICorner", MinB).CornerRadius = UDim.new(1,0)

local ClsB = Instance.new("TextButton", Title)
ClsB.Size = UDim2.new(0,12,0,12)
ClsB.Position = UDim2.new(1,-28,0.5,-6)
ClsB.BackgroundColor3 = Color3.fromRGB(255,95,90)
ClsB.BorderSizePixel = 0
ClsB.Text = ""
ClsB.AutoButtonColor = false
ClsB.ZIndex = 22
Instance.new("UICorner", ClsB).CornerRadius = UDim.new(1,0)

local FB = Instance.new("TextButton")
FB.Size = UDim2.new(0,46,0,46)
FB.Position = UDim2.new(0,15,0,150)
FB.BackgroundColor3 = C.Bg
FB.BackgroundTransparency = 0.15
FB.BorderSizePixel = 0
FB.Text = ""
FB.AutoButtonColor = false
FB.Visible = false
FB.ZIndex = 100
FB.Parent = SG
Instance.new("UICorner", FB).CornerRadius = UDim.new(0,12)
local fbs = Instance.new("UIStroke", FB)
fbs.Color = C.Pri; fbs.Thickness = 2; fbs.Transparency = 0.3; fbs.Parent = FB
track(fbs, "Color")

local fbi = Instance.new("ImageLabel", FB)
fbi.Size = UDim2.new(1,-10,1,-10)
fbi.Position = UDim2.new(0,5,0,5)
fbi.BackgroundTransparency = 1
fbi.Image = LOGO
fbi.ZIndex = 101

local drg, dst, spt
Title.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        drg=true; dst=i.Position; spt=Main.Position
    end
end)
Title.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drg=false end
end)
UIS.InputChanged:Connect(function(i)
    if drg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - dst
        Main.Position = UDim2.new(spt.X.Scale, spt.X.Offset + d.X, spt.Y.Scale, spt.Y.Offset + d.Y)
    end
end)

local fdrg, fdst, fspt
FB.InputBegan:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
        fdrg=true; fdst=i.Position; fspt=FB.Position
    end
end)
FB.InputEnded:Connect(function(i)
    if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then fdrg=false end
end)
UIS.InputChanged:Connect(function(i)
    if fdrg and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
        local d = i.Position - fdst
        FB.Position = UDim2.new(fspt.X.Scale, fspt.X.Offset + d.X, fspt.Y.Scale, fspt.Y.Offset + d.Y)
    end
end)

local function doClose() sfx() Main.Visible=false; FB.Visible=true end
local function doShow() sfx() Main.Visible=true; FB.Visible=false end
ClsB.MouseButton1Click:Connect(doClose)
MinB.MouseButton1Click:Connect(function()
    sfx()
    local isMin = Main.AbsoluteSize.Y <= TH_H + 5
    TS:Create(Main, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {
        Size = isMin and UDim2.new(0,TW,0,TH) or UDim2.new(0,TW,0,TH_H)
    }):Play()
end)
FB.MouseButton1Click:Connect(doShow)

print("[Oc1DvHUB] title built")

-- LAYOUT
local SX, SY = 8, TH_H + 8
local SW = 96
local UH = 44
local CX = SX + SW + 6

local SB = Instance.new("Frame", Main)
SB.Size = UDim2.new(0,SW,1,-SY-UH-12)
SB.Position = UDim2.new(0,SX,0,SY)
SB.BackgroundColor3 = C.Panel
SB.BackgroundTransparency = 0.5
SB.BorderSizePixel = 0
SB.ZIndex = 10
SB.Active = true
Instance.new("UICorner", SB).CornerRadius = UDim.new(0,10)
local sbs = Instance.new("UIStroke", SB)
sbs.Color = C.Pri; sbs.Thickness = 1; sbs.Transparency = 0.7; sbs.Parent = SB
track(sbs, "Color")

local UI_ = Instance.new("Frame", Main)
UI_.Size = UDim2.new(0,SW,0,UH)
UI_.Position = UDim2.new(0,SX,1,-(UH+8))
UI_.BackgroundColor3 = C.Panel
UI_.BackgroundTransparency = 0.5
UI_.BorderSizePixel = 0
UI_.ZIndex = 10
Instance.new("UICorner", UI_).CornerRadius = UDim.new(0,10)
local uis = Instance.new("UIStroke", UI_)
uis.Color = C.Pri; uis.Thickness = 1; uis.Transparency = 0.7; uis.Parent = UI_
track(uis, "Color")

local AV = Instance.new("Frame", UI_)
AV.Size = UDim2.new(0,26,0,26)
AV.Position = UDim2.new(0,8,0.5,-13)
AV.BackgroundColor3 = Color3.fromRGB(50,50,58)
AV.BorderSizePixel = 0
AV.ZIndex = 11
Instance.new("UICorner", AV).CornerRadius = UDim.new(1,0)
local avs = Instance.new("UIStroke", AV)
avs.Color = C.Pri; avs.Thickness = 1.5; avs.Transparency = 0.35; avs.Parent = AV
track(avs, "Color")

local AVi = Instance.new("ImageLabel", AV)
AVi.Size = UDim2.new(1,-4,1,-4)
AVi.Position = UDim2.new(0,2,0,2)
AVi.BackgroundTransparency = 1
AVi.ZIndex = 12
Instance.new("UICorner", AVi).CornerRadius = UDim.new(1,0)

task.spawn(function()
    local ok, t = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and t then AVi.Image = t end
end)

local DN = Instance.new("TextLabel", UI_)
DN.Size = UDim2.new(1,-42,0,12)
DN.Position = UDim2.new(0,40,0,9)
DN.BackgroundTransparency = 1
DN.Text = LP.DisplayName or LP.Name
DN.TextColor3 = C.Txt
DN.TextSize = 10
DN.Font = Enum.Font.GothamMedium
DN.TextXAlignment = Enum.TextXAlignment.Left
DN.TextTruncate = Enum.TextTruncate.AtEnd
DN.ZIndex = 11

local UN = Instance.new("TextLabel", UI_)
UN.Size = UDim2.new(1,-42,0,10)
UN.Position = UDim2.new(0,40,0,23)
UN.BackgroundTransparency = 1
UN.Text = "@" .. LP.Name
UN.TextColor3 = C.Dim
UN.TextSize = 8
UN.Font = Enum.Font.Gotham
UN.TextXAlignment = Enum.TextXAlignment.Left
UN.TextTruncate = Enum.TextTruncate.AtEnd
UN.ZIndex = 11

local Cont = Instance.new("Frame", Main)
Cont.Size = UDim2.new(1,-(CX+8),1,-SY-8)
Cont.Position = UDim2.new(0,CX,0,SY)
Cont.BackgroundColor3 = C.Panel
Cont.BackgroundTransparency = 0.55
Cont.BorderSizePixel = 0
Cont.ZIndex = 10
Instance.new("UICorner", Cont).CornerRadius = UDim.new(0,10)
local cts = Instance.new("UIStroke", Cont)
cts.Color = C.Pri; cts.Thickness = 1; cts.Transparency = 0.7; cts.Parent = Cont
track(cts, "Color")

local SearchBar = Instance.new("Frame", Cont)
SearchBar.Size = UDim2.new(1,-12,0,22)
SearchBar.Position = UDim2.new(0,6,0,6)
SearchBar.BackgroundColor3 = Color3.fromRGB(52,52,60)
SearchBar.BackgroundTransparency = 0.25
SearchBar.BorderSizePixel = 0
SearchBar.ZIndex = 11
Instance.new("UICorner", SearchBar).CornerRadius = UDim.new(0,8)

local searchIconLbl = Instance.new("TextLabel", SearchBar)
searchIconLbl.Size = UDim2.new(0,18,1,0)
searchIconLbl.Position = UDim2.new(0,4,0,0)
searchIconLbl.BackgroundTransparency = 1
searchIconLbl.Text = ">>"
searchIconLbl.TextColor3 = C.Pri
searchIconLbl.TextSize = 9
searchIconLbl.Font = Enum.Font.GothamBold
searchIconLbl.ZIndex = 12
track(searchIconLbl, "TextColor3")

local SearchInput = Instance.new("TextBox", SearchBar)
SearchInput.Size = UDim2.new(1,-26,1,0)
SearchInput.Position = UDim2.new(0,24,0,0)
SearchInput.BackgroundTransparency = 1
SearchInput.Text = ""
SearchInput.PlaceholderText = "Cari fitur..."
SearchInput.PlaceholderColor3 = C.Dim
SearchInput.TextColor3 = C.Txt
SearchInput.TextSize = 10
SearchInput.Font = Enum.Font.Gotham
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.ZIndex = 12

local THF = Instance.new("Frame", Cont)
THF.Size = UDim2.new(1,-12,0,20)
THF.Position = UDim2.new(0,6,0,32)
THF.BackgroundTransparency = 1
THF.ZIndex = 11

local THib = Instance.new("Frame", THF)
THib.Size = UDim2.new(0,18,0,18)
THib.Position = UDim2.new(0,0,0.5,-9)
THib.BackgroundColor3 = C.Pri
THib.BackgroundTransparency = 0.15
THib.BorderSizePixel = 0
THib.ZIndex = 12
Instance.new("UICorner", THib).CornerRadius = UDim.new(0,5)
track(THib, "BackgroundColor3")

local THi = Instance.new("ImageLabel", THib)
THi.Size = UDim2.new(1,-6,1,-6)
THi.Position = UDim2.new(0,3,0,3)
THi.BackgroundTransparency = 1
THi.Image = IC.Rumah
THi.ImageColor3 = Color3.fromRGB(255,255,255)
THi.ZIndex = 13

local THt = Instance.new("TextLabel", THF)
THt.Size = UDim2.new(1,-28,1,0)
THt.Position = UDim2.new(0,26,0,0)
THt.BackgroundTransparency = 1
THt.Text = "Rumah"
THt.TextColor3 = C.Txt
THt.TextSize = 11
THt.Font = Enum.Font.GothamMedium
THt.TextXAlignment = Enum.TextXAlignment.Left
THt.ZIndex = 12

local tabData = {
    {name="Rumah", icon=IC.Rumah}, {name="Farm", icon=IC.Farm},
    {name="Admin", icon=IC.Admin}, {name="Visual", icon=IC.Visual},
    {name="Live", icon=IC.Live}, {name="Tema", icon=IC.Tema},
    {name="Misc", icon=IC.Misc}, {name="Settings", icon=IC.Settings},
}

local tabContent = {}
local CONTENT_Y = 56

for i, t in ipairs(tabData) do
    if t.name == "Live" then
        local lf = Instance.new("Frame", Cont)
        lf.Size = UDim2.new(1,-12,1,-CONTENT_Y-6)
        lf.Position = UDim2.new(0,6,0,CONTENT_Y)
        lf.BackgroundColor3 = Color3.fromRGB(22,22,26)
        lf.BackgroundTransparency = 0.15
        lf.BorderSizePixel = 0
        lf.ZIndex = 10
        lf.Visible = false
        Instance.new("UICorner", lf).CornerRadius = UDim.new(0,8)

        local clr = Instance.new("TextButton", lf)
        clr.Size = UDim2.new(0,52,0,20)
        clr.Position = UDim2.new(1,-58,0,4)
        clr.BackgroundColor3 = C.Red
        clr.BackgroundTransparency = 0.15
        clr.BorderSizePixel = 0
        clr.Text = "CLEAR"
        clr.TextColor3 = Color3.fromRGB(255,255,255)
        clr.TextSize = 8
        clr.Font = Enum.Font.GothamMedium
        clr.AutoButtonColor = false
        clr.ZIndex = 15
        Instance.new("UICorner", clr).CornerRadius = UDim.new(0,6)
        clr.MouseButton1Click:Connect(function()
            LiveLog = {}
            for _, c in ipairs(liveRef:GetChildren()) do
                if c:IsA("TextLabel") then c:Destroy() end
            end
            liveRef.CanvasSize = UDim2.new(0,0,0,0)
            Log("Log cleared", "info")
        end)

        local lsc = Instance.new("ScrollingFrame", lf)
        lsc.Size = UDim2.new(1,-6,1,-28)
        lsc.Position = UDim2.new(0,3,0,26)
        lsc.BackgroundTransparency = 1
        lsc.BorderSizePixel = 0
        lsc.ScrollBarThickness = 3
        lsc.ScrollBarImageColor3 = C.Pri
        lsc.CanvasSize = UDim2.new(0,0,0,0)
        lsc.ZIndex = 12
        track(lsc, "ScrollBarImageColor3")
        liveRef = lsc
        tabContent[t.name] = lf
    else
        local sc = Instance.new("ScrollingFrame", Cont)
        sc.Size = UDim2.new(1,-12,1,-CONTENT_Y-6)
        sc.Position = UDim2.new(0,6,0,CONTENT_Y)
        sc.BackgroundTransparency = 1
        sc.BorderSizePixel = 0
        sc.ScrollBarThickness = 3
        sc.ScrollBarImageColor3 = C.Pri
        sc.CanvasSize = UDim2.new(0,0,0,0)
        sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
        sc.Visible = (i == 1)
        sc.ZIndex = 10
        tabContent[t.name] = sc
        track(sc, "ScrollBarImageColor3")
        local lay = Instance.new("UIListLayout", sc)
        lay.Padding = UDim.new(0,5)
        lay.SortOrder = Enum.SortOrder.LayoutOrder
        local pad = Instance.new("UIPadding", sc)
        pad.PaddingRight = UDim.new(0,4)
    end
end

print("[Oc1DvHUB] tabs content created")

local tabBtns = {}
local curTab = "Rumah"

for i, t in ipairs(tabData) do
    local b = Instance.new("TextButton", SB)
    b.Size = UDim2.new(1,-12,0,24)
    b.Position = UDim2.new(0,6,0,4+(i-1)*28)
    b.BackgroundColor3 = (i==1) and C.Pri or Color3.fromRGB(50,50,58)
    b.BackgroundTransparency = (i==1) and 0.05 or 0.35
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.Active = true
    b.ZIndex = 100
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,8)
    tabBtns[t.name] = b
    if i == 1 then track(b, "BackgroundColor3") end

    local ic = Instance.new("ImageLabel", b)
    ic.Size = UDim2.new(0,12,0,12)
    ic.Position = UDim2.new(0,8,0.5,-6)
    ic.BackgroundTransparency = 1
    ic.Image = t.icon
    ic.ImageColor3 = (i==1) and Color3.fromRGB(255,255,255) or C.Dim
    ic.ZIndex = 101
    ic.Active = false

    local lb = Instance.new("TextLabel", b)
    lb.Size = UDim2.new(1,-26,1,0)
    lb.Position = UDim2.new(0,26,0,0)
    lb.BackgroundTransparency = 1
    lb.Text = t.name
    lb.TextColor3 = (i==1) and Color3.fromRGB(255,255,255) or C.Txt
    lb.TextSize = 10
    lb.Font = Enum.Font.GothamMedium
    lb.TextXAlignment = Enum.TextXAlignment.Left
    lb.ZIndex = 101
    lb.Active = false

    b.MouseButton1Click:Connect(function()
        if curTab == t.name then return end
        sfx()
        curTab = t.name
        for n, bb in pairs(tabBtns) do
            local on = (n == t.name)
            TS:Create(bb, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = on and C.Pri or Color3.fromRGB(50,50,58),
                BackgroundTransparency = on and 0.05 or 0.35,
            }):Play()
            for _, ch in ipairs(bb:GetChildren()) do
                if ch:IsA("ImageLabel") then
                    TS:Create(ch, TweenInfo.new(0.2), {ImageColor3 = on and Color3.fromRGB(255,255,255) or C.Dim}):Play()
                elseif ch:IsA("TextLabel") then
                    TS:Create(ch, TweenInfo.new(0.2), {TextColor3 = on and Color3.fromRGB(255,255,255) or C.Txt}):Play()
                end
            end
        end
        for _, tt in ipairs(tabData) do
            if tt.name == t.name then
                THt.Text = tt.name
                THi.Image = tt.icon
            end
        end
        for n, c in pairs(tabContent) do
            c.Visible = (n == t.name)
        end
    end)
end

print("[Oc1DvHUB] tab buttons created")

SearchInput:GetPropertyChangedSignal("Text"):Connect(function()
    local q = string.lower(SearchInput.Text)
    for _, el in ipairs(searchables) do
        if el and el.Parent then
            if q == "" then el.Visible = true
            else
                local txt = el:GetAttribute("SearchText") or ""
                el.Visible = (txt:find(q, 1, true) ~= nil)
            end
        end
    end
end)

-- COMPONENTS
local function Toggle(parent, title, desc, def, cb)
    local c = Instance.new("Frame", parent)
    c.Size = UDim2.new(1,-4,0,38)
    c.BackgroundColor3 = C.Card
    c.BackgroundTransparency = 0.25
    c.BorderSizePixel = 0
    c.ZIndex = 10
    Instance.new("UICorner", c).CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke", c)
    s.Color = C.Stroke; s.Thickness = 1; s.Transparency = 0.82; s.Parent = c
    trackSearch(c, title)

    local tl = Instance.new("TextLabel", c)
    tl.Size = UDim2.new(1,-90,0,14)
    tl.Position = UDim2.new(0,12,0,4)
    tl.BackgroundTransparency = 1
    tl.Text = title
    tl.TextColor3 = C.Txt
    tl.TextSize = 10
    tl.Font = Enum.Font.GothamMedium
    tl.TextXAlignment = Enum.TextXAlignment.Left
    tl.ZIndex = 12

    local dl = Instance.new("TextLabel", c)
    dl.Size = UDim2.new(1,-90,0,12)
    dl.Position = UDim2.new(0,12,0,20)
    dl.BackgroundTransparency = 1
    dl.Text = desc or ""
    dl.TextColor3 = C.Dim
    dl.TextSize = 8
    dl.Font = Enum.Font.Gotham
    dl.TextXAlignment = Enum.TextXAlignment.Left
    dl.TextTruncate = Enum.TextTruncate.AtEnd
    dl.ZIndex = 12

    local sw = Instance.new("Frame", c)
    sw.Size = UDim2.new(0,36,0,20)
    sw.Position = UDim2.new(1,-46,0.5,-10)
    sw.BackgroundColor3 = def and C.Pri or C.Off
    sw.BorderSizePixel = 0
    sw.ZIndex = 12
    Instance.new("UICorner", sw).CornerRadius = UDim.new(1,0)
    if def then track(sw, "BackgroundColor3") end

    local kn = Instance.new("Frame", sw)
    kn.Size = UDim2.new(0,16,0,16)
    kn.Position = def and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
    kn.BackgroundColor3 = Color3.fromRGB(255,255,255)
    kn.BorderSizePixel = 0
    kn.ZIndex = 13
    Instance.new("UICorner", kn).CornerRadius = UDim.new(1,0)

    local ck = Instance.new("TextButton", sw)
    ck.Size = UDim2.new(1,0,1,0)
    ck.BackgroundTransparency = 1
    ck.Text = ""
    ck.ZIndex = 14

    local st = def
    ck.MouseButton1Click:Connect(function()
        st = not st
        TS:Create(sw, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = st and C.Pri or C.Off}):Play()
        TS:Create(kn, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {Position = st and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)}):Play()
        sfx()
        NotifyUser(title, st and "Diaktifkan" or "Dimatikan", st and "success" or "warn")
        if cb then pcall(cb, st) end
    end)
end

local function Slider(parent, title, mn, mx, df, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-4,0,38)
    f.BackgroundColor3 = C.Card
    f.BackgroundTransparency = 0.25
    f.BorderSizePixel = 0
    f.ZIndex = 10
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke", f)
    s.Color = C.Stroke; s.Thickness = 1; s.Transparency = 0.82; s.Parent = f
    trackSearch(f, title)

    local l = Instance.new("TextLabel", f)
    l.Size = UDim2.new(1,-12,0,12)
    l.Position = UDim2.new(0,10,0,5)
    l.BackgroundTransparency = 1
    l.Text = title .. ": " .. df
    l.TextColor3 = C.Txt
    l.TextSize = 9
    l.Font = Enum.Font.GothamMedium
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 11

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1,-20,0,6)
    bar.Position = UDim2.new(0,10,0,22)
    bar.BackgroundColor3 = Color3.fromRGB(60,60,68)
    bar.BorderSizePixel = 0
    bar.ZIndex = 11
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local fl = Instance.new("Frame", bar)
    fl.Size = UDim2.new((df-mn)/(mx-mn),0,1,0)
    fl.BackgroundColor3 = C.Pri
    fl.BorderSizePixel = 0
    fl.ZIndex = 12
    Instance.new("UICorner", fl).CornerRadius = UDim.new(1,0)
    track(fl, "BackgroundColor3")

    local knob = Instance.new("Frame", fl)
    knob.Size = UDim2.new(0,14,0,14)
    knob.Position = UDim2.new(1,-7,0.5,-7)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local kst = Instance.new("UIStroke", knob)
    kst.Color = Color3.fromRGB(0,0,0)
    kst.Thickness = 1
    kst.Transparency = 0.8
    kst.Parent = knob

    local dr = false
    local lastVal = df
    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then dr = true end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            if dr and lastVal ~= df then
                NotifyUser(title, "Set ke " .. lastVal, "info")
            end
            dr = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dr and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            local bs = bar.AbsoluteSize.X
            if bs <= 0 then return end
            local pct = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bs, 0, 1)
            local v = math.floor(mn + (mx-mn)*pct)
            fl.Size = UDim2.new(pct,0,1,0)
            l.Text = title .. ": " .. v
            lastVal = v
            if cb then pcall(cb, v) end
        end
    end)
end

local function Btn(parent, text, cb, col)
    local b = Instance.new("TextButton", parent)
    b.Size = UDim2.new(1,-4,0,28)
    b.BackgroundColor3 = col or C.Card
    b.BackgroundTransparency = 0.2
    b.BorderSizePixel = 0
    b.Text = text
    b.TextColor3 = (col and Color3.fromRGB(255,255,255)) or C.Pri
    b.TextSize = 10
    b.Font = Enum.Font.GothamMedium
    b.AutoButtonColor = false
    b.ZIndex = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    if not col then track(b, "TextColor3") end
    trackSearch(b, text)

    b.MouseEnter:Connect(function()
        TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.05}):Play()
    end)
    b.MouseLeave:Connect(function()
        TS:Create(b, TweenInfo.new(0.15), {BackgroundTransparency = 0.2}):Play()
    end)
    b.MouseButton1Click:Connect(function()
        sfx()
        NotifyUser(text, "Dijalankan", "info")
        if cb then pcall(cb) end
    end)
    return b
end

local function Sect(parent, text)
    local l = Instance.new("TextLabel", parent)
    l.Size = UDim2.new(1,-4,0,16)
    l.BackgroundTransparency = 1
    l.Text = text
    l.TextColor3 = C.Pri
    l.TextSize = 9
    l.Font = Enum.Font.GothamBold
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.ZIndex = 10
    track(l, "TextColor3")
    trackSearch(l, text)
end

local function Dropdown(parent, title, getListFn, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-4,0,32)
    f.BackgroundColor3 = C.Card
    f.BackgroundTransparency = 0.2
    f.BorderSizePixel = 0
    f.ZIndex = 10
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    trackSearch(f, title)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(0.4,0,1,0)
    lbl.Position = UDim2.new(0,10,0,0)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.Txt
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11

    local btn = Instance.new("TextButton", f)
    btn.Size = UDim2.new(0.6,-14,1,-8)
    btn.Position = UDim2.new(0.4,4,0,4)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,68)
    btn.BackgroundTransparency = 0.1
    btn.Text = "Select..."
    btn.TextColor3 = C.Pri
    btn.TextSize = 9
    btn.Font = Enum.Font.GothamMedium
    btn.ZIndex = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0,7)

    local popup = nil
    btn.MouseButton1Click:Connect(function()
        sfx()
        if popup then popup:Destroy(); popup = nil; return end
        local list = getListFn()
        popup = Instance.new("Frame")
        popup.Size = UDim2.new(0, btn.AbsoluteSize.X, 0, math.min(#list * 22 + 8, 150))
        popup.Position = UDim2.new(0, btn.AbsolutePosition.X - Main.AbsolutePosition.X, 0, btn.AbsolutePosition.Y - Main.AbsolutePosition.Y + 30)
        popup.BackgroundColor3 = Color3.fromRGB(40,40,48)
        popup.BackgroundTransparency = 0.05
        popup.BorderSizePixel = 0
        popup.ZIndex = 90
        popup.Parent = Main
        Instance.new("UICorner", popup).CornerRadius = UDim.new(0,10)

        local sl = Instance.new("ScrollingFrame", popup)
        sl.Size = UDim2.new(1,-4,1,-4)
        sl.Position = UDim2.new(0,2,0,2)
        sl.BackgroundTransparency = 1
        sl.BorderSizePixel = 0
        sl.ScrollBarThickness = 3
        sl.ScrollBarImageColor3 = C.Pri
        sl.CanvasSize = UDim2.new(0,0,0,#list * 22 + 8)
        sl.ZIndex = 91
        local il = Instance.new("UIListLayout", sl)
        il.Padding = UDim.new(0,2)

        for i, pName in ipairs(list) do
            local ob = Instance.new("TextButton", sl)
            ob.Size = UDim2.new(1,-4,0,20)
            ob.BackgroundColor3 = Color3.fromRGB(55,55,63)
            ob.BackgroundTransparency = 0.3
            ob.BorderSizePixel = 0
            ob.Text = pName
            ob.TextColor3 = C.Txt
            ob.TextSize = 9
            ob.Font = Enum.Font.Gotham
            ob.ZIndex = 92
            ob.LayoutOrder = i
            Instance.new("UICorner", ob).CornerRadius = UDim.new(0,6)
            ob.MouseButton1Click:Connect(function()
                btn.Text = pName
                S.SelectedPlayer = pName
                popup:Destroy(); popup = nil
                NotifyUser("Target Player", pName, "info")
                if cb then pcall(cb, pName) end
            end)
        end
    end)
end

local function HuePicker(parent, title, initialHue, cb)
    local f = Instance.new("Frame", parent)
    f.Size = UDim2.new(1,-4,0,58)
    f.BackgroundColor3 = C.Card
    f.BackgroundTransparency = 0.25
    f.BorderSizePixel = 0
    f.ZIndex = 10
    Instance.new("UICorner", f).CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke", f)
    s.Color = C.Stroke; s.Thickness = 1; s.Transparency = 0.82; s.Parent = f
    trackSearch(f, title)

    local lbl = Instance.new("TextLabel", f)
    lbl.Size = UDim2.new(1,-40,0,14)
    lbl.Position = UDim2.new(0,10,0,4)
    lbl.BackgroundTransparency = 1
    lbl.Text = title
    lbl.TextColor3 = C.Txt
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 11

    local prev = Instance.new("Frame", f)
    prev.Size = UDim2.new(0,16,0,16)
    prev.Position = UDim2.new(1,-26,0,3)
    prev.BackgroundColor3 = Color3.fromHSV(initialHue or 0.08, 0.65, 0.95)
    prev.BorderSizePixel = 0
    prev.ZIndex = 12
    Instance.new("UICorner", prev).CornerRadius = UDim.new(1,0)
    local pvs = Instance.new("UIStroke", prev)
    pvs.Color = Color3.fromRGB(255,255,255)
    pvs.Thickness = 1.5
    pvs.Transparency = 0.5
    pvs.Parent = prev

    local bar = Instance.new("Frame", f)
    bar.Size = UDim2.new(1,-20,0,20)
    bar.Position = UDim2.new(0,10,0,26)
    bar.BackgroundColor3 = Color3.fromRGB(255,255,255)
    bar.BorderSizePixel = 0
    bar.ZIndex = 11
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

    local grad = Instance.new("UIGradient", bar)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 90, 90)),
        ColorSequenceKeypoint.new(0.14, Color3.fromRGB(255, 170, 90)),
        ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255, 230, 110)),
        ColorSequenceKeypoint.new(0.42, Color3.fromRGB(150, 230, 130)),
        ColorSequenceKeypoint.new(0.56, Color3.fromRGB(110, 210, 240)),
        ColorSequenceKeypoint.new(0.70, Color3.fromRGB(120, 150, 250)),
        ColorSequenceKeypoint.new(0.85, Color3.fromRGB(210, 130, 250)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 90, 90)),
    })

    local startPct = initialHue or 0.08
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0,22,0,22)
    knob.Position = UDim2.new(startPct, -11, 0.5, -11)
    knob.BackgroundColor3 = Color3.fromRGB(255,255,255)
    knob.BorderSizePixel = 0
    knob.ZIndex = 13
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1,0)
    local ks = Instance.new("UIStroke", knob)
    ks.Color = Color3.fromRGB(255,255,255)
    ks.Thickness = 2
    ks.Transparency = 0.1
    ks.Parent = knob
    local shadow = Instance.new("UIStroke", knob)
    shadow.Color = Color3.fromRGB(0,0,0)
    shadow.Thickness = 1
    shadow.Transparency = 0.6
    shadow.Parent = knob

    local inner = Instance.new("Frame", knob)
    inner.Size = UDim2.new(0,8,0,8)
    inner.Position = UDim2.new(0.5,-4,0.5,-4)
    inner.BackgroundColor3 = Color3.fromRGB(255,255,255)
    inner.BorderSizePixel = 0
    inner.ZIndex = 14
    Instance.new("UICorner", inner).CornerRadius = UDim.new(1,0)
    local ins = Instance.new("UIStroke", inner)
    ins.Color = Color3.fromRGB(0,0,0)
    ins.Thickness = 1
    ins.Transparency = 0.7
    ins.Parent = inner

    local dragging = false
    local function updateFromX(px)
        local bs = bar.AbsoluteSize.X
        if bs <= 0 then return end
        local pct = math.clamp((px - bar.AbsolutePosition.X)/bs, 0, 1)
        knob.Position = UDim2.new(pct, -11, 0.5, -11)
        local col = Color3.fromHSV(pct, 0.65, 0.98)
        prev.BackgroundColor3 = col
        if cb then pcall(cb, col, pct) end
    end

    bar.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateFromX(i.Position.X)
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)
    UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
            updateFromX(i.Position.X)
        end
    end)

    return f
end

print("[Oc1DvHUB] components defined")

-- FEATURE FUNCS
local function gH()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end
local function tp(p)
    local h = gH()
    if h then h.CFrame = CFrame.new(p) end
end
local function ft(p)
    local h = gH()
    if not h or not p then return end
    pcall(function()
        if firetouchinterest then
            firetouchinterest(h, p, 0)
            firetouchinterest(h, p, 1)
        end
    end)
end

-- ═══════ ANTI AFK (works all games) ═══════
local antiAfkConn = nil
local antiAfkHeartbeat = nil
local lastAntiAfkKick = 0

local function startAntiAfk()
    if antiAfkConn then return end
    -- Metode 1: Idled event (official)
    antiAfkConn = LP.Idled:Connect(function()
        if not S.AntiAfk then return end
        local vu = game:GetService("VirtualUser")
        vu:CaptureController()
        vu:ClickButton2(Vector2.new(0,0))
        Log("Anti AFK: Idle prevented", "success")
    end)
    -- Metode 2: Heartbeat auto-activity (untuk game yg gak pakai idle)
    antiAfkHeartbeat = RunService.Heartbeat:Connect(function()
        if not S.AntiAfk then return end
        local now = os.clock()
        if now - lastAntiAfkKick < 30 then return end
        lastAntiAfkKick = now
        pcall(function()
            local vu = game:GetService("VirtualUser")
            vu:CaptureController()
            vu:ClickButton2(Vector2.new(0,0))
        end)
    end)
end

local function stopAntiAfk()
    if antiAfkConn then antiAfkConn:Disconnect(); antiAfkConn = nil end
    if antiAfkHeartbeat then antiAfkHeartbeat:Disconnect(); antiAfkHeartbeat = nil end
end

-- ═══════ FPS BOOST ═══════
local fpsBoostBackup = {}
local fpsBoostConn = nil
local fpsOriginalLighting = {}

local function enableFpsBoost()
    -- Backup lighting
    fpsOriginalLighting.GlobalShadows = Lighting.GlobalShadows
    fpsOriginalLighting.FogEnd = Lighting.FogEnd
    fpsOriginalLighting.Brightness = Lighting.Brightness
    fpsOriginalLighting.EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale
    fpsOriginalLighting.EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale

    Lighting.GlobalShadows = false
    Lighting.FogEnd = 100000
    Lighting.Brightness = 1
    Lighting.EnvironmentDiffuseScale = 0
    Lighting.EnvironmentSpecularScale = 0

    -- Disable post effects
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("PostEffect") or v:IsA("Atmosphere") or v:IsA("BloomEffect")
           or v:IsA("BlurEffect") or v:IsA("ColorCorrectionEffect")
           or v:IsA("DepthOfFieldEffect") or v:IsA("SunRaysEffect") then
            fpsBoostBackup[v] = v.Enabled
            pcall(function() v.Enabled = false end)
        end
    end

    -- Remove particles & trails
    task.spawn(function()
        for _, d in ipairs(workspace:GetDescendants()) do
            if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke")
               or d:IsA("Fire") or d:IsA("Sparkles") or d:IsA("Explosion") then
                if not fpsBoostBackup[d] then
                    fpsBoostBackup[d] = d.Enabled
                    pcall(function() d.Enabled = false end)
                end
            end
        end
    end)

    -- Set quality to lowest
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
    end)
    pcall(function()
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
    end)

    -- Continuous cleanup untuk partikel baru
    fpsBoostConn = workspace.DescendantAdded:Connect(function(d)
        if not S.FpsBoost then return end
        if d:IsA("ParticleEmitter") or d:IsA("Trail") or d:IsA("Smoke")
           or d:IsA("Fire") or d:IsA("Sparkles") then
            task.defer(function()
                pcall(function() d.Enabled = false end)
            end)
        end
    end)
end

local function disableFpsBoost()
    -- Restore lighting
    if fpsOriginalLighting.GlobalShadows ~= nil then
        Lighting.GlobalShadows = fpsOriginalLighting.GlobalShadows
        Lighting.FogEnd = fpsOriginalLighting.FogEnd
        Lighting.Brightness = fpsOriginalLighting.Brightness
        Lighting.EnvironmentDiffuseScale = fpsOriginalLighting.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = fpsOriginalLighting.EnvironmentSpecularScale
    end
    -- Restore post effects
    for obj, state in pairs(fpsBoostBackup) do
        if obj and obj.Parent then
            pcall(function() obj.Enabled = state end)
        end
    end
    fpsBoostBackup = {}
    -- Restore quality
    pcall(function()
        settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic
    end)
    if fpsBoostConn then fpsBoostConn:Disconnect(); fpsBoostConn = nil end
end

-- ═══════ COIN SCANNER + AUTO COLLECT ═══════
local COIN_IMPORTANT_ID = "58a10e23-44a5-4f08-bd34-18ab6200c606"
local COIN_KEYWORDS = {"coin","koin","crypto","token","cash","money","gem","diamond","gold"}
local BLOCKED_KEYWORDS = {"interact","prompt","billboard","gui","dialog","button","click","shop","sign","arrow"}

local ScanDB = {
    coins = {}, lastScan = 0, totalFound = 0,
    tagFound = 0, attrFound = 0, nameFound = 0, idFound = 0,
}

local function lower(s) return string.lower(tostring(s)) end

local function hasBlocked(n)
    for _, kw in ipairs(BLOCKED_KEYWORDS) do
        if n:find(kw, 1, true) then return true end
    end
    return false
end

local function isInsideNPC(part)
    local par = part.Parent
    while par and par ~= workspace do
        if par:FindFirstChildOfClass("Humanoid") then return true end
        par = par.Parent
    end
    return false
end

local function hasImportantId(o)
    local ok, tags = pcall(function() return CollectionService:GetTags(o) end)
    if ok and tags then
        for _, t in ipairs(tags) do
            if tostring(t) == COIN_IMPORTANT_ID then return true end
        end
    end
    local ok2, attrs = pcall(function() return o:GetAttributes() end)
    if ok2 and attrs then
        for name, val in pairs(attrs) do
            if tostring(name) == COIN_IMPORTANT_ID then return true end
            if tostring(val) == COIN_IMPORTANT_ID then return true end
        end
    end
    if string.find(o.Name, COIN_IMPORTANT_ID, 1, true) then return true end
    local par = o.Parent
    local depth = 0
    while par and par ~= workspace and depth < 3 do
        if string.find(par.Name, COIN_IMPORTANT_ID, 1, true) then return true end
        local okt, ptags = pcall(function() return CollectionService:GetTags(par) end)
        if okt and ptags then
            for _, t in ipairs(ptags) do
                if tostring(t) == COIN_IMPORTANT_ID then return true end
            end
        end
        local oka, pattrs = pcall(function() return par:GetAttributes() end)
        if oka and pattrs then
            for name, val in pairs(pattrs) do
                if tostring(name) == COIN_IMPORTANT_ID then return true end
                if tostring(val) == COIN_IMPORTANT_ID then return true end
            end
        end
        par = par.Parent
        depth = depth + 1
    end
    return false
end

local function detectCoinBySource(o)
    local n = lower(o.Name)
    if hasImportantId(o) then return true, "id" end
    for _, kw in ipairs(COIN_KEYWORDS) do
        if n == kw or n:match("^" .. kw .. "%s") or n:match("%s" .. kw .. "$")
           or n:match("^" .. kw .. "%d") or n:match("^" .. kw .. "%.")
           or n:match("^" .. kw .. "_") then
            return true, "name"
        end
    end
    local ok, tags = pcall(function() return CollectionService:GetTags(o) end)
    if ok and tags then
        for _, t in ipairs(tags) do
            local tl = lower(t)
            if tl == "coin" or tl == "collectable" or tl == "pickup" or tl == "currency" then
                return true, "tag"
            end
        end
    end
    local ok2, attrs = pcall(function() return o:GetAttributes() end)
    if ok2 and attrs then
        for name, val in pairs(attrs) do
            local nl, vl = lower(name), lower(val)
            if (nl == "type" and (vl == "coin" or vl == "crypto" or vl == "cash"))
               or (nl == "category" and vl == "currency")
               or nl == "coinvalue" or nl == "worth" or nl == "reward" then
                return true, "attr"
            end
        end
    end
    return false, nil
end

local function scanMap()
    ScanDB.coins = {}
    ScanDB.totalFound = 0
    ScanDB.tagFound = 0
    ScanDB.attrFound = 0
    ScanDB.nameFound = 0
    ScanDB.idFound = 0
    ScanDB.lastScan = os.time()

    local count = 0
    for _, o in ipairs(workspace:GetDescendants()) do
        if (o:IsA("BasePart") or o:IsA("Model") or o:IsA("MeshPart")) and o.Parent then
            local part = o:IsA("BasePart") and o or o:FindFirstChildWhichIsA("BasePart")
            if part then
                local n = lower(part.Name)
                if not hasBlocked(n) and not isInsideNPC(part) then
                    local matched, source = detectCoinBySource(o)
                    if matched then
                        ScanDB.coins[o] = {
                            name = o.Name, source = source,
                            part = part, pos = part.Position,
                        }
                        ScanDB.totalFound = ScanDB.totalFound + 1
                        if source == "id" then ScanDB.idFound = ScanDB.idFound + 1
                        elseif source == "name" then ScanDB.nameFound = ScanDB.nameFound + 1
                        elseif source == "tag" then ScanDB.tagFound = ScanDB.tagFound + 1
                        elseif source == "attr" then ScanDB.attrFound = ScanDB.attrFound + 1
                        end
                        count = count + 1
                    end
                end
            end
        end
    end
    return count
end

local function getCoinList()
    if os.time() - ScanDB.lastScan > 30 or next(ScanDB.coins) == nil then
        scanMap()
    end
    local list = {}
    for obj, data in pairs(ScanDB.coins) do
        if obj and obj.Parent and data.part and data.part.Parent then
            table.insert(list, data.part)
        else
            ScanDB.coins[obj] = nil
        end
    end
    return list
end

local RARITY_KEYWORDS = {
    Big = {"big","large","huge","mega","giant","legendary","epic","rare"},
    Small = {"small","tiny","mini","little"},
}
local function detectRarity(part)
    local full = string.lower(part.Name)
    local par = part.Parent
    local depth = 0
    while par and par ~= workspace and depth < 4 do
        full = full .. " " .. string.lower(par.Name)
        par = par.Parent
        depth = depth + 1
    end
    pcall(function()
        for _, a in ipairs(part:GetAttributes()) do
            full = full .. " " .. tostring(a)
        end
    end)
    for _, kw in ipairs(RARITY_KEYWORDS.Big) do
        if full:find(kw) then return "big" end
    end
    for _, kw in ipairs(RARITY_KEYWORDS.Small) do
        if full:find(kw) then return "small" end
    end
    return nil
end

local claimedCoins = {}
local coinTracker = {}

local function findNearestCoin(h)
    local cs = getCoinList()
    if #cs == 0 then return nil, nil end
    for _, c in ipairs(cs) do
        if not coinTracker[c] then
            local rar = detectRarity(c)
            coinTracker[c] = rar or "normal"
        end
    end
    local bigTarget, smallTarget, normalTarget
    local bd, sd, nd = math.huge, math.huge, math.huge
    for _, c in ipairs(cs) do
        local d = (c.Position - h.Position).Magnitude
        if d <= S.CoinMaxDist then
            local rar = coinTracker[c] or "normal"
            if rar == "big" and d < bd then bd = d; bigTarget = c
            elseif rar == "small" and d < sd then sd = d; smallTarget = c
            elseif rar == "normal" and d < nd then nd = d; normalTarget = c
            end
        end
    end
    local target = bigTarget or smallTarget or normalTarget
    if not target then return nil, nil end
    return target, coinTracker[target] or "normal"
end

local function notifyRarity(target, rar)
    if not claimedCoins[target] and (rar == "big" or rar == "small") and S.RarityNotify then
        claimedCoins[target] = true
        RarityPopup(target.Name, rar == "big")
        Log("Rarity " .. string.upper(rar) .. ": " .. target.Name, "rarity")
    end
end

local function coinLoopTP(h)
    while S.AutoCoin and S.CoinMode == "tp" do
        local target, rar = findNearestCoin(h)
        if target then
            notifyRarity(target, rar)
            h.CFrame = CFrame.new(target.Position + Vector3.new(0, 3, 0))
            if S.CoinTPSpeed > 0 then task.wait(S.CoinTPSpeed) end
            ft(target)
            claimedCoins[target] = true
        end
        task.wait(S.CoinDelay)
    end
end

local function coinLoopWalk(h)
    local originalSpeed = nil
    while S.AutoCoin and S.CoinMode == "walk" do
        local target, rar = findNearestCoin(h)
        if target then
            notifyRarity(target, rar)
            local c = LP.Character
            local hum = c and c:FindFirstChildOfClass("Humanoid")
            if hum then
                if not originalSpeed then originalSpeed = hum.WalkSpeed end
                hum.WalkSpeed = S.CoinWalkSpeed
            end
            local reached = false
            local walkStart = os.clock()
            while S.AutoCoin and S.CoinMode == "walk" do
                local c2 = LP.Character
                local h2 = c2 and c2:FindFirstChild("HumanoidRootPart")
                local hum2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                if not h2 or not hum2 then break end
                if not target.Parent then break end
                local dist = (target.Position - h2.Position).Magnitude
                if dist <= 5 then reached = true; break end
                if os.clock() - walkStart > 15 then break end
                pcall(function() hum2:MoveTo(target.Position) end)
                task.wait(0.1)
            end
            if reached then
                ft(target)
                claimedCoins[target] = true
            end
            if hum then hum.WalkSpeed = originalSpeed or 16 end
        end
        task.wait(S.CoinDelay)
    end
    local c = LP.Character
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum and originalSpeed then hum.WalkSpeed = originalSpeed end
end

local coinC
local function startCoin()
    if coinC then return end
    Log("Auto Coin ON", "success")
    local initial = scanMap()
    Log("Scan awal: " .. initial .. " coin", "info")
    claimedCoins = {}
    coinTracker = {}
    coinC = task.spawn(function()
        while S.AutoCoin do
            local h = gH()
            if h then
                if S.CoinMode == "tp" then coinLoopTP(h)
                elseif S.CoinMode == "walk" then coinLoopWalk(h) end
            end
            task.wait(0.2)
        end
    end)
end

local function stopCoin()
    if coinC then task.cancel(coinC); coinC = nil end
end

local eHL, eBB = {}, {}
local function clrESP()
    for _, h in pairs(eHL) do if h then h:Destroy() end end
    for _, b in pairs(eBB) do if b then b:Destroy() end end
    eHL, eBB = {}, {}
end
local function mkESP(p)
    if p == LP then return end
    local c = p.Character; if not c then return end
    local hl = Instance.new("Highlight")
    hl.FillColor = C.Pri
    hl.OutlineColor = C.Pri
    hl.FillTransparency = 0.55
    hl.OutlineTransparency = 0
    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    hl.Adornee = c
    hl.Parent = c
    eHL[p] = hl
    local hrp = c:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bb = Instance.new("BillboardGui")
        bb.Size = UDim2.new(0,180,0,36)
        bb.StudsOffset = Vector3.new(0,3,0)
        bb.AlwaysOnTop = true
        bb.Adornee = hrp
        bb.Parent = c
        local nl = Instance.new("TextLabel", bb)
        nl.Name = "NameLbl"
        nl.Size = UDim2.new(1,0,0,16)
        nl.BackgroundTransparency = 1
        nl.Text = p.DisplayName .. " (@" .. p.Name .. ")"
        nl.TextColor3 = C.Pri
        nl.TextSize = 10
        nl.Font = Enum.Font.GothamMedium
        nl.TextStrokeTransparency = 0
        nl.Visible = S.ESPName
        local dl = Instance.new("TextLabel", bb)
        dl.Name = "DistLbl"
        dl.Size = UDim2.new(1,0,0,12)
        dl.Position = UDim2.new(0,0,0,16)
        dl.BackgroundTransparency = 1
        dl.Text = "0"
        dl.TextColor3 = Color3.fromRGB(255,255,255)
        dl.TextSize = 9
        dl.Font = Enum.Font.Gotham
        dl.TextStrokeTransparency = 0
        dl.Visible = S.ESPDist
        eBB[p] = bb
    end
end
local function updESP()
    if not S.ESP then clrESP(); return end
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then
            if p.Character and not eHL[p] then mkESP(p) end
            if not p.Character and eHL[p] then
                if eHL[p] then eHL[p]:Destroy(); eHL[p] = nil end
                if eBB[p] then eBB[p]:Destroy(); eBB[p] = nil end
            end
        end
    end
    local mh = gH()
    if mh then
        for p, bb in pairs(eBB) do
            local ph = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
            local dl = bb:FindFirstChild("DistLbl")
            if ph and dl then
                dl.Text = math.floor((mh.Position - ph.Position).Magnitude) .. " studs"
            end
        end
    end
end
RunService.Heartbeat:Connect(function() if S.ESP then pcall(updESP) end end)

local function aWS(v)
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then h.WalkSpeed = v end
end
local function aJP(v)
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then h.UseJumpPower = true; h.JumpPower = v end
end

local flyC, flyBV, flyBG
local function startFly()
    local c = LP.Character
    local h = c and c:FindFirstChild("HumanoidRootPart")
    if not h then return end
    flyBV = Instance.new("BodyVelocity", h)
    flyBV.MaxForce = Vector3.new(1e5,1e5,1e5)
    flyBV.Velocity = Vector3.zero
    flyBG = Instance.new("BodyGyro", h)
    flyBG.PCFrame = CFrame.new()
    flyBG.MaxTorque = Vector3.new(1e5,1e5,1e5)
    flyBG.P = 3000
    flyC = RunService.RenderStepped:Connect(function()
        if not S.Fly or not h.Parent then return end
        local cam = workspace.CurrentCamera
        local hum = c:FindFirstChildOfClass("Humanoid")
        local mv = Vector3.zero
        if hum and hum.MoveDirection.Magnitude > 0 then
            mv = cam.CFrame:VectorToWorldSpace(hum.MoveDirection) * S.FlySpeed
        end
        flyBV.Velocity = mv
        flyBG.CFrame = cam.CFrame
    end)
end
local function stopFly()
    if flyC then flyC:Disconnect(); flyC = nil end
    if flyBV then flyBV:Destroy(); flyBV = nil end
    if flyBG then flyBG:Destroy(); flyBG = nil end
end

local ncC
local function startNC()
    if ncC then return end
    ncC = RunService.Stepped:Connect(function()
        if not S.Noclip then return end
        local c = LP.Character; if not c then return end
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end
        end
    end)
end
local function stopNC() if ncC then ncC:Disconnect(); ncC = nil end end

local ijC
local function startIJ()
    if ijC then return end
    ijC = UIS.JumpRequest:Connect(function()
        if not S.InfJump then return end
        local c = LP.Character
        local h = c and c:FindFirstChildOfClass("Humanoid")
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end)
end

local function getPlayerList()
    local l = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP then table.insert(l, p.Name) end
    end
    return l
end

print("[Oc1DvHUB] features defined")

-- FILL TABS
local welcomeCard = Instance.new("Frame", tabContent.Rumah)
welcomeCard.Size = UDim2.new(1,-4,0,70)
welcomeCard.BackgroundColor3 = C.Card
welcomeCard.BackgroundTransparency = 0.25
welcomeCard.BorderSizePixel = 0
welcomeCard.ZIndex = 10
Instance.new("UICorner", welcomeCard).CornerRadius = UDim.new(0,12)

local bigAv = Instance.new("Frame", welcomeCard)
bigAv.Size = UDim2.new(0,52,0,52)
bigAv.Position = UDim2.new(0,10,0.5,-26)
bigAv.BackgroundColor3 = Color3.fromRGB(55,55,63)
bigAv.BorderSizePixel = 0
bigAv.ZIndex = 12
Instance.new("UICorner", bigAv).CornerRadius = UDim.new(1,0)
local bigAvS = Instance.new("UIStroke", bigAv)
bigAvS.Color = C.Pri; bigAvS.Thickness = 2; bigAvS.Transparency = 0.35; bigAvS.Parent = bigAv
track(bigAvS, "Color")

local bigAvI = Instance.new("ImageLabel", bigAv)
bigAvI.Size = UDim2.new(1,-6,1,-6)
bigAvI.Position = UDim2.new(0,3,0,3)
bigAvI.BackgroundTransparency = 1
bigAvI.ZIndex = 13
Instance.new("UICorner", bigAvI).CornerRadius = UDim.new(1,0)
task.spawn(function()
    local ok, t = pcall(function()
        return Players:GetUserThumbnailAsync(LP.UserId, Enum.ThumbnailType.AvatarBust, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and t then bigAvI.Image = t end
end)

local greetLbl = Instance.new("TextLabel", welcomeCard)
greetLbl.Size = UDim2.new(1,-76,0,16)
greetLbl.Position = UDim2.new(0,72,0,12)
greetLbl.BackgroundTransparency = 1
greetLbl.Text = "Halo, " .. (LP.DisplayName or LP.Name) .. "!"
greetLbl.TextColor3 = C.Txt
greetLbl.TextSize = 11
greetLbl.Font = Enum.Font.GothamMedium
greetLbl.TextXAlignment = Enum.TextXAlignment.Left
greetLbl.TextTruncate = Enum.TextTruncate.AtEnd
greetLbl.ZIndex = 12

local clockLbl = Instance.new("TextLabel", welcomeCard)
clockLbl.Size = UDim2.new(1,-76,0,12)
clockLbl.Position = UDim2.new(0,72,0,32)
clockLbl.BackgroundTransparency = 1
clockLbl.Text = "--"
clockLbl.TextColor3 = C.Dim
clockLbl.TextSize = 9
clockLbl.Font = Enum.Font.Gotham
clockLbl.TextXAlignment = Enum.TextXAlignment.Left
clockLbl.ZIndex = 12

local uptimeLbl = Instance.new("TextLabel", welcomeCard)
uptimeLbl.Size = UDim2.new(1,-76,0,12)
uptimeLbl.Position = UDim2.new(0,72,0,48)
uptimeLbl.BackgroundTransparency = 1
uptimeLbl.Text = "Playtime: 00:00:00"
uptimeLbl.TextColor3 = C.Dim
uptimeLbl.TextSize = 9
uptimeLbl.Font = Enum.Font.Gotham
uptimeLbl.TextXAlignment = Enum.TextXAlignment.Left
uptimeLbl.ZIndex = 12

Sect(tabContent.Rumah, "LIVE STATS")
local statsCard = Instance.new("Frame", tabContent.Rumah)
statsCard.Size = UDim2.new(1,-4,0,52)
statsCard.BackgroundColor3 = C.Card
statsCard.BackgroundTransparency = 0.25
statsCard.BorderSizePixel = 0
statsCard.ZIndex = 10
Instance.new("UICorner", statsCard).CornerRadius = UDim.new(0,12)

local function mkStatBox(parent, x, title)
    local box = Instance.new("Frame", parent)
    box.Size = UDim2.new(0,96,0,42)
    box.Position = UDim2.new(0,x,0.5,-21)
    box.BackgroundColor3 = Color3.fromRGB(52,52,60)
    box.BackgroundTransparency = 0.2
    box.BorderSizePixel = 0
    box.ZIndex = 11
    Instance.new("UICorner", box).CornerRadius = UDim.new(0,8)
    local tL = Instance.new("TextLabel", box)
    tL.Size = UDim2.new(1,0,0,12)
    tL.Position = UDim2.new(0,0,0,5)
    tL.BackgroundTransparency = 1
    tL.Text = title
    tL.TextColor3 = C.Dim
    tL.TextSize = 8
    tL.Font = Enum.Font.GothamMedium
    tL.ZIndex = 12
    local vL = Instance.new("TextLabel", box)
    vL.Size = UDim2.new(1,0,0,18)
    vL.Position = UDim2.new(0,0,0,18)
    vL.BackgroundTransparency = 1
    vL.Text = "--"
    vL.TextColor3 = C.Pri
    vL.TextSize = 12
    vL.Font = Enum.Font.GothamBold
    vL.ZIndex = 12
    track(vL, "TextColor3")
    return vL
end

local fpsVal = mkStatBox(statsCard, 8, "FPS")
local pingVal = mkStatBox(statsCard, 112, "PING")
local playerVal = mkStatBox(statsCard, 216, "PLAYERS")

Sect(tabContent.Rumah, "SERVER INFO")
local infoCard = Instance.new("Frame", tabContent.Rumah)
infoCard.Size = UDim2.new(1,-4,0,80)
infoCard.BackgroundColor3 = C.Card
infoCard.BackgroundTransparency = 0.25
infoCard.BorderSizePixel = 0
infoCard.ZIndex = 10
Instance.new("UICorner", infoCard).CornerRadius = UDim.new(0,12)

local function mkInfoRow(parent, y, label)
    local rL = Instance.new("TextLabel", parent)
    rL.Size = UDim2.new(0,80,0,14)
    rL.Position = UDim2.new(0,12,0,y)
    rL.BackgroundTransparency = 1
    rL.Text = label
    rL.TextColor3 = C.Dim
    rL.TextSize = 9
    rL.Font = Enum.Font.Gotham
    rL.TextXAlignment = Enum.TextXAlignment.Left
    rL.ZIndex = 12
    local vL = Instance.new("TextLabel", parent)
    vL.Size = UDim2.new(1,-104,0,14)
    vL.Position = UDim2.new(0,96,0,y)
    vL.BackgroundTransparency = 1
    vL.Text = "--"
    vL.TextColor3 = C.Txt
    vL.TextSize = 9
    vL.Font = Enum.Font.Gotham
    vL.TextXAlignment = Enum.TextXAlignment.Left
    vL.TextTruncate = Enum.TextTruncate.AtEnd
    vL.ZIndex = 12
    return vL
end

local jobVal = mkInfoRow(infoCard, 8, "Job ID")
local placeVal = mkInfoRow(infoCard, 28, "Place ID")
local gameVal = mkInfoRow(infoCard, 48, "Game")
local regionVal = mkInfoRow(infoCard, 68, "Region")
placeVal.Text = tostring(game.PlaceId)
jobVal.Text = game.JobId ~= "" and game.JobId or "Studio/Private"
gameVal.Text = S.GameName
regionVal.Text = (game.JobId ~= "" and "Online") or "Studio"

local fpsCount, fpsTime, curFPS = 0, 0, 0
RunService.RenderStepped:Connect(function(dt)
    fpsCount = fpsCount + 1
    fpsTime = fpsTime + dt
    if fpsTime >= 1 then
        curFPS = math.floor(fpsCount / fpsTime)
        fpsCount = 0; fpsTime = 0
    end
end)

task.spawn(function()
    while task.wait(1) do
        local t = os.date("*t")
        local h = t.hour
        local clockStr = string.format("%02d:%02d:%02d", t.hour, t.min, t.sec)
        local greet
        if h < 12 then greet = "Selamat Pagi"
        elseif h < 15 then greet = "Selamat Siang"
        elseif h < 18 then greet = "Selamat Sore"
        else greet = "Selamat Malam" end
        clockLbl.Text = clockStr
        greetLbl.Text = greet .. ", " .. (LP.DisplayName or LP.Name) .. "!"
        local el = os.time() - S.StartTime
        uptimeLbl.Text = string.format("Playtime: %02d:%02d:%02d", math.floor(el/3600), math.floor((el%3600)/60), el%60)
        fpsVal.Text = tostring(curFPS)
        pcall(function()
            local ping = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
            pingVal.Text = math.floor(ping) .. "ms"
        end)
        playerVal.Text = #Players:GetPlayers() .. "/" .. Players.MaxPlayers
        if S.GameName ~= "Loading..." then gameVal.Text = S.GameName end
    end
end)

-- Farm
Sect(tabContent.Farm, "AUTO COLLECT COIN")
Toggle(tabContent.Farm, "Auto Collect Coin", "Scan map + auto collect", false, function(v)
    S.AutoCoin = v
    if v then startCoin() else stopCoin() end
end)

Sect(tabContent.Farm, "MODE COLLECT")
local modeBtns = {}
local modeRow = Instance.new("Frame", tabContent.Farm)
modeRow.Size = UDim2.new(1,-4,0,32)
modeRow.BackgroundTransparency = 1
modeRow.ZIndex = 10
local modeLay = Instance.new("UIListLayout", modeRow)
modeLay.FillDirection = Enum.FillDirection.Horizontal
modeLay.Padding = UDim.new(0,6)
modeLay.SortOrder = Enum.SortOrder.LayoutOrder

local function updateModeBtns()
    for m, btn in pairs(modeBtns) do
        local active = (S.CoinMode == m)
        TS:Create(btn, TweenInfo.new(0.2), {
            BackgroundColor3 = active and C.Pri or C.Card,
            BackgroundTransparency = active and 0.1 or 0.25,
        }):Play()
        for _, ch in ipairs(btn:GetChildren()) do
            if ch:IsA("TextLabel") then
                ch.TextColor3 = active and Color3.fromRGB(255,255,255) or C.Txt
            end
        end
    end
end

local function mkModeBtn(mode, label)
    local b = Instance.new("TextButton", modeRow)
    b.Size = UDim2.new(0.5,-3,1,0)
    b.BackgroundColor3 = C.Card
    b.BackgroundTransparency = 0.25
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 11
    b.LayoutOrder = (mode == "tp") and 1 or 2
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    local lb = Instance.new("TextLabel", b)
    lb.Size = UDim2.new(1,0,1,0)
    lb.BackgroundTransparency = 1
    lb.Text = label
    lb.TextColor3 = C.Txt
    lb.TextSize = 10
    lb.Font = Enum.Font.GothamBold
    lb.ZIndex = 12
    b.MouseButton1Click:Connect(function()
        sfx()
        S.CoinMode = mode
        updateModeBtns()
        NotifyUser("Mode Collect", string.upper(mode), "info")
    end)
    modeBtns[mode] = b
end

mkModeBtn("tp", "TP (Instant)")
mkModeBtn("walk", "WALK (Jalan)")
updateModeBtns()

Sect(tabContent.Farm, "COIN DELAY")
Slider(tabContent.Farm, "Delay Antar Coin (x10ms)", 0, 30, math.floor(S.CoinDelay*10), function(v)
    S.CoinDelay = v/10
end)

Sect(tabContent.Farm, "TP SPEED")
Slider(tabContent.Farm, "Delay TP (x10ms, 0=instan)", 0, 20, math.floor(S.CoinTPSpeed*10), function(v)
    S.CoinTPSpeed = v/10
end)

Sect(tabContent.Farm, "WALK SPEED")
Slider(tabContent.Farm, "Walk Speed", 8, 100, S.CoinWalkSpeed, function(v)
    S.CoinWalkSpeed = v
end)

Sect(tabContent.Farm, "MAX DISTANCE")
Slider(tabContent.Farm, "Max Deteksi Coin (studs)", 50, 5000, S.CoinMaxDist, function(v)
    S.CoinMaxDist = v
end)

Sect(tabContent.Farm, "COIN SCANNER")
Btn(tabContent.Farm, "Scan Coin di Map", function()
    Log("Scanning map...", "info")
    local n = scanMap()
    Log("Ditemukan " .. n .. " coin", "success")
    Log("  ID:" .. ScanDB.idFound .. " Name:" .. ScanDB.nameFound .. " Tag:" .. ScanDB.tagFound .. " Attr:" .. ScanDB.attrFound, "info")
end)
Btn(tabContent.Farm, "Auto Scan Ulang", function()
    ScanDB.lastScan = 0
    local n = scanMap()
    Log("Re-scan: " .. n .. " coin", "success")
end)

Sect(tabContent.Farm, "RARITY NOTIFY")
Toggle(tabContent.Farm, "Rarity Popup", "Munculin popup rarity saat claim", true, function(v) S.RarityPopup = v end)
Toggle(tabContent.Farm, "Rarity Log", "Log rarity ke Live tab", true, function(v) S.RarityNotify = v end)
Btn(tabContent.Farm, "Test Rarity BIG", function() RarityPopup("TestBigCoin", true); Log("Test rarity BIG", "rarity") end)
Btn(tabContent.Farm, "Test Rarity SMALL", function() RarityPopup("TestSmallCoin", false); Log("Test rarity SMALL", "rarity") end)

-- ═══════ ADMIN TAB - Tambah AntiAFK + FPS Boost ═══════
Sect(tabContent.Admin, "UTILITY (All Game)")
Toggle(tabContent.Admin, "Anti AFK", "Anti kick idle (all game)", false, function(v)
    S.AntiAfk = v
    if v then startAntiAfk() else stopAntiAfk() end
end)
Toggle(tabContent.Admin, "FPS Boost", "Optimasi grafis + disable partikel", false, function(v)
    S.FpsBoost = v
    if v then enableFpsBoost() else disableFpsBoost() end
end)

Sect(tabContent.Admin, "MOVEMENT")
Toggle(tabContent.Admin, "Fly", "Terbang bebas", false, function(v)
    S.Fly = v
    if v then startFly() else stopFly() end
end)
Slider(tabContent.Admin, "Fly Speed", 10, 200, 50, function(v) S.FlySpeed = v end)
Toggle(tabContent.Admin, "Noclip", "Tembus dinding", false, function(v)
    S.Noclip = v
    if v then startNC() else stopNC() end
end)
Toggle(tabContent.Admin, "Infinite Jump", "Lompat terus", false, function(v)
    S.InfJump = v
    if v then startIJ() end
end)

Sect(tabContent.Admin, "SPEED")
Slider(tabContent.Admin, "WalkSpeed", 16, 300, 16, function(v) S.WalkSpeed = v; aWS(v) end)
Slider(tabContent.Admin, "JumpPower", 50, 500, 50, function(v) S.JumpPower = v; aJP(v) end)

Sect(tabContent.Admin, "TELEPORT")
Btn(tabContent.Admin, "Return To Spawn", function()
    local sp = workspace:FindFirstChildOfClass("SpawnLocation")
    if sp then tp(sp.Position + Vector3.new(0,5,0)) end
end)
Dropdown(tabContent.Admin, "Target Player", getPlayerList, function(sel) S.SelectedPlayer = sel end)
Btn(tabContent.Admin, "TP To Selected", function()
    local sel = S.SelectedPlayer
    if not sel then Log("Pilih player!", "warn"); return end
    local t = Players:FindFirstChild(sel)
    if t and t.Character then
        local hrp = t.Character:FindFirstChild("HumanoidRootPart")
        if hrp then tp(hrp.Position + Vector3.new(0,3,3)); Log("TP to " .. sel, "success") end
    end
end)
Btn(tabContent.Admin, "Bring Selected", function()
    local sel = S.SelectedPlayer
    if not sel then return end
    local t = Players:FindFirstChild(sel)
    local myH = gH()
    if t and t.Character and myH then
        local hrp = t.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = myH.CFrame + Vector3.new(0,3,3); Log("Brought " .. sel, "success") end
    end
end)

Sect(tabContent.Admin, "ESP")
Toggle(tabContent.Admin, "ESP Player", "Highlight player", false, function(v)
    S.ESP = v
    if not v then clrESP() end
end)
Toggle(tabContent.Admin, "ESP Name", "Show nama player", false, function(v)
    S.ESPName = v
    for _, bb in pairs(eBB) do
        local l = bb:FindFirstChild("NameLbl")
        if l then l.Visible = v end
    end
end)
Toggle(tabContent.Admin, "ESP Distance", "Show jarak", false, function(v)
    S.ESPDist = v
    for _, bb in pairs(eBB) do
        local l = bb:FindFirstChild("DistLbl")
        if l then l.Visible = v end
    end
end)

Sect(tabContent.Admin, "PLAYER UTILITY")
Btn(tabContent.Admin, "Reset Character", function()
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then h.Health = 0 end
end)
Btn(tabContent.Admin, "Heal Self", function()
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then h.Health = h.MaxHealth end
end)

-- Visual
local SPAWNED_NOOBS = {}
local MAX_NOOB = 6
local NPC_CFG = {WalkSpeed = 16, WanderRange = 50, WanderDelay = 3}

local function createNoobRig(position)
    local model = Instance.new("Model")
    model.Name = "NoobNPC"
    local SKIN = Color3.fromRGB(255, 204, 153)
    local SHIRT = Color3.fromRGB(0, 143, 156)
    local PANTS = Color3.fromRGB(0, 143, 20)
    local function mkPart(n, s, c, cf)
        local p = Instance.new("Part")
        p.Name = n; p.Size = s; p.Color = c
        p.Material = Enum.Material.SmoothPlastic
        p.TopSurface = Enum.SurfaceType.Smooth
        p.BottomSurface = Enum.SurfaceType.Smooth
        p.CFrame = cf; p.Parent = model
        return p
    end
    local hrp = mkPart("HumanoidRootPart", Vector3.new(2,2,1), SKIN, CFrame.new(position))
    hrp.Transparency = 1; hrp.CanCollide = false
    local head = mkPart("Head", Vector3.new(2,1,1), SKIN, CFrame.new(position + Vector3.new(0,1.5,0)))
    local face = Instance.new("Decal")
    face.Face = Enum.NormalId.Front
    face.Texture = "rbxasset://textures/face.png"
    face.Parent = head
    local torso = mkPart("Torso", Vector3.new(2,2,1), SHIRT, CFrame.new(position))
    local lArm = mkPart("Left Arm", Vector3.new(1,2,1), SKIN, CFrame.new(position + Vector3.new(-1.5,0,0)))
    local rArm = mkPart("Right Arm", Vector3.new(1,2,1), SKIN, CFrame.new(position + Vector3.new(1.5,0,0)))
    local lLeg = mkPart("Left Leg", Vector3.new(1,2,1), PANTS, CFrame.new(position + Vector3.new(-0.5,-2,0)))
    local rLeg = mkPart("Right Leg", Vector3.new(1,2,1), PANTS, CFrame.new(position + Vector3.new(0.5,-2,0)))
    local function mkMotor(name, p0, p1, c0, c1)
        local m = Instance.new("Motor6D")
        m.Name = name; m.Part0 = p0; m.Part1 = p1; m.C0 = c0; m.C1 = c1
        m.Parent = p0
    end
    mkMotor("RootJoint", hrp, torso, CFrame.new(0,0,0), CFrame.new(0,0,0))
    mkMotor("Neck", torso, head, CFrame.new(0,1,0)*CFrame.Angles(-math.pi/2,0,math.pi), CFrame.new(0,-0.5,0)*CFrame.Angles(-math.pi/2,0,math.pi))
    mkMotor("Left Shoulder", torso, lArm, CFrame.new(-1,0.5,0)*CFrame.Angles(0,-math.pi/2,0), CFrame.new(0.5,0.5,0)*CFrame.Angles(0,-math.pi/2,0))
    mkMotor("Right Shoulder", torso, rArm, CFrame.new(1,0.5,0)*CFrame.Angles(0,math.pi/2,0), CFrame.new(-0.5,0.5,0)*CFrame.Angles(0,math.pi/2,0))
    mkMotor("Left Hip", torso, lLeg, CFrame.new(-0.5,-1,0)*CFrame.Angles(0,-math.pi/2,0), CFrame.new(-0.5,1,0)*CFrame.Angles(0,-math.pi/2,0))
    mkMotor("Right Hip", torso, rLeg, CFrame.new(0.5,-1,0)*CFrame.Angles(0,math.pi/2,0), CFrame.new(0.5,1,0)*CFrame.Angles(0,math.pi/2,0))
    local hum = Instance.new("Humanoid")
    hum.RigType = Enum.HumanoidRigType.R6
    hum.WalkSpeed = NPC_CFG.WalkSpeed
    hum.MaxHealth = 100; hum.Health = 100
    hum.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
    hum.Parent = model
    local animator = Instance.new("Animator")
    animator.Parent = hum
    model.PrimaryPart = hrp
    task.spawn(function()
        task.wait(0.3)
        pcall(function()
            local anim = Instance.new("Animation")
            anim.AnimationId = WALK_ANIM
            local track = animator:LoadAnimation(anim)
            track.Looped = true
            track.Priority = Enum.AnimationPriority.Movement
            track:Play()
        end)
    end)
    return model
end

local function startNoobAI(npc)
    local hum = npc:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    task.spawn(function()
        while npc.Parent and hum.Parent and hum.Health > 0 do
            local base = npc.PrimaryPart and npc.PrimaryPart.Position or Vector3.new(0,0,0)
            local angle = math.random() * math.pi * 2
            local dist = math.random(15, NPC_CFG.WanderRange)
            local target = base + Vector3.new(math.cos(angle)*dist, 0, math.sin(angle)*dist)
            pcall(function() hum:MoveTo(target) end)
            task.wait(NPC_CFG.WanderDelay + math.random()*2)
        end
    end)
end

local function spawnNoob(ox, oz)
    if #SPAWNED_NOOBS >= MAX_NOOB then Log("Max noob", "warn"); return end
    local hrp = gH(); if not hrp then return end
    local pos = hrp.Position + hrp.CFrame.LookVector * 10 + Vector3.new(ox or 0, 3, oz or 0)
    local ok, npc = pcall(function() return createNoobRig(pos) end)
    if ok and npc then
        npc.Parent = workspace
        table.insert(SPAWNED_NOOBS, npc)
        startNoobAI(npc)
        Log("Noob (" .. #SPAWNED_NOOBS .. "/" .. MAX_NOOB .. ")", "success")
    end
end

local function clearNoobs()
    for _, n in ipairs(SPAWNED_NOOBS) do
        if n and n.Parent then n:Destroy() end
    end
    SPAWNED_NOOBS = {}
    Log("Noobs cleared", "warn")
end

Sect(tabContent.Visual, "NOOB NPC")
Btn(tabContent.Visual, "Spawn 1 Noob", function() spawnNoob(0, 0) end)
Btn(tabContent.Visual, "Spawn 6 Noobs", function()
    for i = 1, MAX_NOOB do
        spawnNoob(math.random(-15,15), math.random(-15,15))
        task.wait(0.15)
    end
end)
Btn(tabContent.Visual, "Clear All Noobs", function() clearNoobs() end, Color3.fromRGB(150, 60, 70))

-- Tema
Sect(tabContent.Tema, "BACKGROUND IMAGE")
local themeBtns = {}
for i, bg in ipairs(BG_LIST) do
    local b = Instance.new("TextButton", tabContent.Tema)
    b.Size = UDim2.new(1,-4,0,42)
    b.BackgroundColor3 = C.Card
    b.BackgroundTransparency = 0.25
    b.BorderSizePixel = 0
    b.Text = ""
    b.AutoButtonColor = false
    b.ZIndex = 11
    Instance.new("UICorner", b).CornerRadius = UDim.new(0,10)
    local s = Instance.new("UIStroke", b)
    s.Color = (i == S.selBG) and C.Pri or Color3.fromRGB(80,80,88)
    s.Thickness = (i == S.selBG) and 2 or 1
    s.Transparency = (i == S.selBG) and 0.2 or 0.6
    s.Parent = b
    trackSearch(b, "Theme " .. bg.name)

    local prev = Instance.new("ImageLabel", b)
    prev.Size = UDim2.new(0,34,0,34)
    prev.Position = UDim2.new(0,5,0.5,-17)
    prev.BackgroundColor3 = Color3.fromRGB(55,55,63)
    prev.BorderSizePixel = 0
    prev.Image = bg.id
    prev.ZIndex = 12
    Instance.new("UICorner", prev).CornerRadius = UDim.new(0,7)

    local lbl = Instance.new("TextLabel", b)
    lbl.Size = UDim2.new(1,-86,0,12)
    lbl.Position = UDim2.new(0,46,0,7)
    lbl.BackgroundTransparency = 1
    lbl.Text = i .. ". " .. bg.name
    lbl.TextColor3 = (i == S.selBG) and C.Pri or C.Txt
    lbl.TextSize = 9
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 12

    local sub = Instance.new("TextLabel", b)
    sub.Size = UDim2.new(1,-86,0,10)
    sub.Position = UDim2.new(0,46,0,23)
    sub.BackgroundTransparency = 1
    sub.Text = (i == S.curBG) and "AKTIF" or "Tap"
    sub.TextColor3 = (i == S.curBG) and C.Grn or C.Dim
    sub.TextSize = 8
    sub.Font = Enum.Font.Gotham
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 12

    local chk = Instance.new("TextLabel", b)
    chk.Size = UDim2.new(0,22,1,0)
    chk.Position = UDim2.new(1,-26,0,0)
    chk.BackgroundTransparency = 1
    chk.Text = (i == S.selBG) and "V" or ""
    chk.TextColor3 = C.Pri
    chk.TextSize = 14
    chk.Font = Enum.Font.GothamBold
    chk.ZIndex = 12

    themeBtns[i] = {btn=b, stroke=s, lbl=lbl, sub=sub, chk=chk}
    b.MouseButton1Click:Connect(function()
        sfx()
        S.selBG = i
        for j, item in pairs(themeBtns) do
            local isSel = (j == S.selBG)
            item.stroke.Color = isSel and C.Pri or Color3.fromRGB(80,80,88)
            item.stroke.Thickness = isSel and 2 or 1
            item.stroke.Transparency = isSel and 0.2 or 0.6
            item.lbl.TextColor3 = isSel and C.Pri or C.Txt
            item.chk.Text = isSel and "V" or ""
        end
    end)
end

Btn(tabContent.Tema, "Ganti Background", function()
    if S.selBG == S.curBG then Log("Sama", "warn"); return end
    S.curBG = S.selBG
    bgI.Image = BG_LIST[S.curBG].id
    for j, item in pairs(themeBtns) do
        item.sub.Text = (j == S.curBG) and "AKTIF" or "Tap"
        item.sub.TextColor3 = (j == S.curBG) and C.Grn or C.Dim
    end
    Log("BG: " .. BG_LIST[S.curBG].name, "success")
end, Color3.fromRGB(60,120,90))

Sect(tabContent.Tema, "WARNA UI (geser knob)")
local hueFrame = HuePicker(tabContent.Tema, "Geser untuk pilih warna", 0.08, function(col, pct)
    S.HueColor = col
    applyColor(col)
    updTitleColor(col)
end)

Btn(tabContent.Tema, "Terapkan Warna", function()
    applyColor(S.HueColor)
    updTitleColor(S.HueColor)
    Log("Warna diterapkan", "success")
end, Color3.fromRGB(60,120,90))

Btn(tabContent.Tema, "Reset Warna (Orange)", function()
    S.HueColor = Color3.fromRGB(255, 145, 80)
    applyColor(S.HueColor)
    updTitleColor(S.HueColor)
    Log("Reset warna", "info")
end, Color3.fromRGB(140, 70, 50))

Sect(tabContent.Tema, "BG BRIGHTNESS")
Slider(tabContent.Tema, "Kegelapan BG (x100)", 0, 80, math.floor(S.BGBrightness*100), function(v)
    S.BGBrightness = v/100
    ovl.BackgroundTransparency = S.BGBrightness
end)

-- Misc
Sect(tabContent.Misc, "UTILITY")
Btn(tabContent.Misc, "Copy Discord", function()
    if setclipboard then setclipboard("discord.gg/oc1dv") end
end)
Btn(tabContent.Misc, "Rejoin Server", function()
    game:GetService("TeleportService"):Teleport(game.PlaceId, LP)
end)

-- Settings
Sect(tabContent.Settings, "RESET")
Btn(tabContent.Settings, "Disable All", function()
    S.Fly = false; stopFly()
    S.Noclip = false; stopNC()
    S.InfJump = false
    S.ESP = false; clrESP()
    S.AutoCoin = false; stopCoin()
    S.AntiAfk = false; stopAntiAfk()
    S.FpsBoost = false; disableFpsBoost()
    clearNoobs()
    aWS(16); aJP(50)
    Log("All disabled", "warn")
end)
Btn(tabContent.Settings, "Unload UI", function()
    stopFly(); clrESP(); stopCoin(); stopAntiAfk(); disableFpsBoost(); clearNoobs()
    task.wait(0.3)
    SG:Destroy()
end, Color3.fromRGB(150, 60, 70))

UIS.InputBegan:Connect(function(i, g)
    if g then return end
    if i.KeyCode == Enum.KeyCode.RightShift then
        if Main.Visible then doClose() else doShow() end
    end
end)

Log("v33 ready", "success")
NotifyUser("Oc1DvHUB", "v33 loaded successfully", "success")
print("[Oc1DvHUB] v33 loaded OK")
