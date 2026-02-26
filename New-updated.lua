task.wait(0.1)
repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Player = Players.LocalPlayer

local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
local isTablet = UserInputService.TouchEnabled and (workspace.CurrentCamera.ViewportSize.X > 900)
local guiScale = isMobile and (isTablet and 0.75 or 0.55) or 1

local sg = Instance.new("ScreenGui")
sg.Name = "LUNI010_ AutoDuels"
sg.ResetOnSpawn = false
sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
sg.IgnoreGuiInset = true
sg.Parent = Player.PlayerGui

local VP = workspace.CurrentCamera.ViewportSize
local W = math.min(560 * guiScale, VP.X * 0.95)
local H = math.min(600 * guiScale, VP.Y * 0.90)

local Features = {
    SpeedBoost         = false,
    AntiRagdoll        = false,
    AutoSteal          = false,
    SpamBat            = false,
    SpeedWhileStealing = false,
    HitCircle          = false,
    Helicopter         = false,
    GalaxyMode         = false,
    Unwalk             = false,
    Optimizer          = false,
    XRay               = false,
    Float              = false,
    RightSteal         = false,
    LeftSteal          = false,
    BatAimbot          = false,  
}

local Values = {
    BoostSpeed           = 30,
    SpinSpeed            = 10,
    DEFAULT_GRAVITY      = 196.2,
    GalaxyGravityPercent = 70,
    StealingSpeedValue   = 29,
    STEAL_RADIUS         = 20,
    HOP_POWER            = 35,
    HOP_COOLDOWN         = 0.08,
    BatAimbotSpeed       = 55,   
}

local accentObjects = {}
local function addAccent(obj, prop)
    table.insert(accentObjects, {obj = obj, prop = prop})
end

task.spawn(function()
    local h = 0
    while sg.Parent do
        h = (h + 1) % 360
        local hue = 0.5 + 0.167 * math.sin(h / 360 * math.pi * 2)
        local col = Color3.fromHSV(hue, 0.9, 1)
        for _, r in ipairs(accentObjects) do
            pcall(function() r.obj[r.prop] = col end)
        end
        task.wait(0.03)
    end
end)

local PB_W = 260 * guiScale
local PB_H = 28 * guiScale

local progressBar = Instance.new("Frame", sg)
progressBar.Size = UDim2.new(0, PB_W, 0, PB_H)
progressBar.Position = UDim2.new(0.5, -PB_W / 2, 1, -90 * guiScale)
progressBar.BackgroundColor3 = Color3.fromRGB(8, 8, 14)
progressBar.BackgroundTransparency = 0.1
progressBar.BorderSizePixel = 0
progressBar.ClipsDescendants = false
progressBar.ZIndex = 10
Instance.new("UICorner", progressBar).CornerRadius = UDim.new(1, 0)

local pStroke = Instance.new("UIStroke", progressBar)
pStroke.Thickness = 2 * guiScale
pStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
addAccent(pStroke, "Color")

local pTrack = Instance.new("Frame", progressBar)
pTrack.Size = UDim2.new(1, -8 * guiScale, 0, 6 * guiScale)
pTrack.Position = UDim2.new(0, 4 * guiScale, 1, -9 * guiScale)
pTrack.BackgroundColor3 = Color3.fromRGB(20, 20, 30)
pTrack.BorderSizePixel = 0
pTrack.ZIndex = 11
Instance.new("UICorner", pTrack).CornerRadius = UDim.new(1, 0)

local ProgressBarFill = Instance.new("Frame", pTrack)
ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
ProgressBarFill.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
ProgressBarFill.BorderSizePixel = 0
ProgressBarFill.ZIndex = 12
Instance.new("UICorner", ProgressBarFill).CornerRadius = UDim.new(1, 0)
addAccent(ProgressBarFill, "BackgroundColor3")

local ProgressPercentLabel = Instance.new("TextLabel", progressBar)
ProgressPercentLabel.Size = UDim2.new(1, 0, 1, -8 * guiScale)
ProgressPercentLabel.Position = UDim2.new(0, 0, 0, 0)
ProgressPercentLabel.BackgroundTransparency = 1
ProgressPercentLabel.Text = "0%"
ProgressPercentLabel.Font = Enum.Font.GothamBlack
ProgressPercentLabel.TextSize = 13 * guiScale
ProgressPercentLabel.TextXAlignment = Enum.TextXAlignment.Center
ProgressPercentLabel.TextYAlignment = Enum.TextYAlignment.Center
ProgressPercentLabel.ZIndex = 13
addAccent(ProgressPercentLabel, "TextColor3")

local function resetProgressBar()
    ProgressPercentLabel.Text = "0%"
    ProgressBarFill.Size = UDim2.new(0, 0, 1, 0)
end

local main = Instance.new("Frame", sg)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)

if isMobile then
    main.Position = UDim2.new(0.5, -W/2, 0.5, -H/2)
else
    main.Position = UDim2.new(1, -W - 20, 0, 20)
end

main.BackgroundColor3 = Color3.fromRGB(6, 6, 12)
main.BackgroundTransparency = 0.08
main.BorderSizePixel = 0
main.Active = true
main.Draggable = false
main.ClipsDescendants = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12 * guiScale)

local mainStroke = Instance.new("UIStroke", main)
mainStroke.Thickness = 1.5 * guiScale
mainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
addAccent(mainStroke, "Color")

local headerH = isMobile and 64 * guiScale or 58 * guiScale

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, headerH)
header.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
header.BackgroundTransparency = 0.2
header.BorderSizePixel = 0
header.ZIndex = 4
header.Active = true
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12 * guiScale)

local headerBottom = Instance.new("Frame", header)
headerBottom.Size = UDim2.new(1, 0, 0.5, 0)
headerBottom.Position = UDim2.new(0, 0, 0.5, 0)
headerBottom.BackgroundColor3 = Color3.fromRGB(10, 8, 20)
headerBottom.BackgroundTransparency = 0.2
headerBottom.BorderSizePixel = 0
headerBottom.ZIndex = 3

local headerLine = Instance.new("Frame", header)
headerLine.Size = UDim2.new(1, 0, 0, 1.5 * guiScale)
headerLine.Position = UDim2.new(0, 0, 1, -1)
headerLine.BorderSizePixel = 0
headerLine.ZIndex = 5
addAccent(headerLine, "BackgroundColor3")

local iconLbl = Instance.new("TextLabel", header)
iconLbl.Size = UDim2.new(0, 28 * guiScale, 0, 28 * guiScale)
iconLbl.Position = UDim2.new(0, 10 * guiScale, 0.5, -14 * guiScale)
iconLbl.BackgroundTransparency = 1
iconLbl.Text = "UI"
iconLbl.TextSize = 20 * guiScale
iconLbl.Font = Enum.Font.GothamBlack
iconLbl.ZIndex = 6
addAccent(iconLbl, "TextColor3")

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -90 * guiScale, 0, 22 * guiScale)
title.Position = UDim2.new(0, 42 * guiScale, 0, 8 * guiScale)
title.BackgroundTransparency = 1
title.Text = "LUNI010_  Auto Duels"
title.Font = Enum.Font.GothamBlack
title.TextSize = 16 * guiScale
title.TextColor3 = Color3.fromRGB(240, 240, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6

local subtitle = Instance.new("TextLabel", header)
subtitle.Size = UDim2.new(1, -90 * guiScale, 0, 16 * guiScale)
subtitle.Position = UDim2.new(0, 42 * guiScale, 0, 32 * guiScale)
subtitle.BackgroundTransparency = 1
subtitle.Text = "discord.gg/pjuj99ure5  Ã¢ÂÂ¢  Auto Duels"
subtitle.TextColor3 = Color3.fromRGB(120, 120, 160)
subtitle.Font = Enum.Font.Gotham
subtitle.TextSize = 9.5 * guiScale
subtitle.TextXAlignment = Enum.TextXAlignment.Left
subtitle.ZIndex = 6

local closeBtnSize = isMobile and 36 * guiScale or 28 * guiScale
local closeBtn = Instance.new("TextButton", header)
closeBtn.Size = UDim2.new(0, closeBtnSize, 0, closeBtnSize)
closeBtn.Position = UDim2.new(1, -(closeBtnSize + 8 * guiScale), 0.5, -closeBtnSize / 2)
closeBtn.BackgroundColor3 = Color3.fromRGB(160, 30, 80)
closeBtn.Text = "X"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.Font = Enum.Font.GothamBlack
closeBtn.TextSize = 13 * guiScale
closeBtn.BorderSizePixel = 0
closeBtn.ZIndex = 7
Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6 * guiScale)
closeBtn.MouseButton1Click:Connect(function() sg:Destroy() end)
closeBtn.MouseEnter:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(220,50,100)}):Play()
end)
closeBtn.MouseLeave:Connect(function()
    TweenService:Create(closeBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(160,30,80)}):Play()
end)

if isMobile then
    local minimized = false
    local minimizeBtn = Instance.new("TextButton", header)
    minimizeBtn.Size = UDim2.new(0, closeBtnSize, 0, closeBtnSize)
    minimizeBtn.Position = UDim2.new(1, -(closeBtnSize * 2 + 16 * guiScale), 0.5, -closeBtnSize / 2)
    minimizeBtn.BackgroundColor3 = Color3.fromRGB(20, 60, 100)
    minimizeBtn.Text = ""
    minimizeBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
    minimizeBtn.Font = Enum.Font.GothamBlack
    minimizeBtn.TextSize = 14 * guiScale
    minimizeBtn.BorderSizePixel = 0
    minimizeBtn.ZIndex = 7
    Instance.new("UICorner", minimizeBtn).CornerRadius = UDim.new(0, 6 * guiScale)
    minimizeBtn.MouseButton1Click:Connect(function()
        minimized = not minimized
        if minimized then
            TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, W, 0, headerH)}):Play()
            minimizeBtn.Text = "+"
        else
            TweenService:Create(main, TweenInfo.new(0.25), {Size = UDim2.new(0, W, 0, H)}):Play()
            minimizeBtn.Text = "-"
        end
    end)
end

do
    local dragging, dragStart, startPos = false, nil, nil
    header.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = main.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            local newX = math.clamp(startPos.X.Offset + delta.X, 0, VP.X - W)
            local newY = math.clamp(startPos.Y.Offset + delta.Y, 0, VP.Y - headerH)
            main.Position = UDim2.new(0, newX, 0, newY)
        end
    end)
end

local contentArea = Instance.new("Frame", main)
contentArea.Size = UDim2.new(1, 0, 1, -headerH)
contentArea.Position = UDim2.new(0, 0, 0, headerH)
contentArea.BackgroundTransparency = 1
contentArea.BorderSizePixel = 0
contentArea.ClipsDescendants = true
contentArea.ZIndex = 3

local divider = Instance.new("Frame", contentArea)
divider.Size = UDim2.new(0, 1 * guiScale, 1, -16 * guiScale)
divider.Position = UDim2.new(0.5, 0, 0, 8 * guiScale)
divider.BorderSizePixel = 0
divider.ZIndex = 4
addAccent(divider, "BackgroundColor3")

local leftColumn = Instance.new("Frame", contentArea)
leftColumn.Size = UDim2.new(0.48, 0, 1, -10 * guiScale)
leftColumn.Position = UDim2.new(0.01, 0, 0, 5 * guiScale)
leftColumn.BackgroundTransparency = 1
leftColumn.BorderSizePixel = 0
leftColumn.ClipsDescendants = true

local leftScroll = Instance.new("ScrollingFrame", leftColumn)
leftScroll.Size = UDim2.new(1, 0, 1, 0)
leftScroll.BackgroundTransparency = 1
leftScroll.BorderSizePixel = 0
leftScroll.ScrollBarThickness = isMobile and 4 * guiScale or 3 * guiScale
leftScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
leftScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
leftScroll.ScrollingDirection = Enum.ScrollingDirection.Y
leftScroll.ElasticBehavior = Enum.ElasticBehavior.Always
leftScroll.ZIndex = 3

local rightColumn = Instance.new("Frame", contentArea)
rightColumn.Size = UDim2.new(0.48, 0, 1, -10 * guiScale)
rightColumn.Position = UDim2.new(0.51, 0, 0, 5 * guiScale)
rightColumn.BackgroundTransparency = 1
rightColumn.BorderSizePixel = 0
rightColumn.ClipsDescendants = true

local rightScroll = Instance.new("ScrollingFrame", rightColumn)
rightScroll.Size = UDim2.new(1, 0, 1, 0)
rightScroll.BackgroundTransparency = 1
rightScroll.BorderSizePixel = 0
rightScroll.ScrollBarThickness = isMobile and 4 * guiScale or 3 * guiScale
rightScroll.ScrollBarImageColor3 = Color3.fromRGB(0, 200, 255)
rightScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
rightScroll.ScrollingDirection = Enum.ScrollingDirection.Y
rightScroll.ElasticBehavior = Enum.ElasticBehavior.Always
rightScroll.ZIndex = 3

local leftLayout = Instance.new("UIListLayout", leftScroll)
leftLayout.Padding = UDim.new(0, 7 * guiScale)
leftLayout.FillDirection = Enum.FillDirection.Vertical
leftLayout.SortOrder = Enum.SortOrder.LayoutOrder
leftLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local rightLayout = Instance.new("UIListLayout", rightScroll)
rightLayout.Padding = UDim.new(0, 7 * guiScale)
rightLayout.FillDirection = Enum.FillDirection.Vertical
rightLayout.SortOrder = Enum.SortOrder.LayoutOrder
rightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local rowOrder = 0

local ROW_H = isMobile and 46 or 40
local SLIDER_H = isMobile and 56 or 50

local function makeRowFrame(parent, height)
    height = height or ROW_H
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -8 * guiScale, 0, height * guiScale)
    frame.BackgroundColor3 = Color3.fromRGB(10, 10, 20)
    frame.BackgroundTransparency = 0.1
    frame.BorderSizePixel = 0
    frame.LayoutOrder = rowOrder
    rowOrder = rowOrder + 1
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 7 * guiScale)

    local stroke = Instance.new("UIStroke", frame)
    stroke.Thickness = 1.2 * guiScale
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    addAccent(stroke, "Color")

    return frame, stroke
end

local function makeToggle(parent, labelText, keybind)
    local frame, stroke = makeRowFrame(parent, ROW_H)

    local displayText = labelText
    if not isMobile and keybind then
        displayText = labelText .. "  [" .. keybind .. "]"
    end

    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(0.58, 0, 1, 0)
    lbl.Position = UDim2.new(0, 10 * guiScale, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = displayText
    lbl.TextColor3 = Color3.fromRGB(190, 190, 210)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11 * guiScale
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 4

    local bindBtn = nil
    if keybind and not isMobile then
        bindBtn = Instance.new("TextButton", frame)
        bindBtn.Size = UDim2.new(0, 34 * guiScale, 0, 18 * guiScale)
        bindBtn.Position = UDim2.new(1, -(34 + 52) * guiScale, 0.5, -9 * guiScale)
        bindBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 28)
        bindBtn.TextColor3 = Color3.fromRGB(0, 220, 255)
        bindBtn.Font = Enum.Font.GothamBlack
        bindBtn.TextSize = 8 * guiScale
        bindBtn.Text = "BIND"
        bindBtn.BorderSizePixel = 0
        bindBtn.ZIndex = 6
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0, 4 * guiScale)
        local bStroke = Instance.new("UIStroke", bindBtn)
        bStroke.Thickness = 1.2 * guiScale
        bStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        addAccent(bStroke, "Color")
    end

    local pillW = isMobile and 48 * guiScale or 44 * guiScale
    local pillH = isMobile and 26 * guiScale or 22 * guiScale
    local circleD = isMobile and 20 * guiScale or 18 * guiScale

    local pill = Instance.new("Frame", frame)
    pill.Size = UDim2.new(0, pillW, 0, pillH)
    pill.Position = UDim2.new(1, -(pillW + 4 * guiScale), 0.5, -pillH / 2)
    pill.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
    pill.BorderSizePixel = 0
    pill.ZIndex = 4
    Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)

    local circle = Instance.new("Frame", pill)
    circle.Size = UDim2.new(0, circleD, 0, circleD)
    circle.Position = UDim2.new(0, 2 * guiScale, 0.5, -circleD / 2)
    circle.BackgroundColor3 = Color3.new(1,1,1)
    circle.BorderSizePixel = 0
    circle.ZIndex = 5
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)

    local hitbox = Instance.new("TextButton", frame)
    hitbox.Size = UDim2.new(1, 0, 1, 0)
    hitbox.BackgroundTransparency = 1
    hitbox.Text = ""
    hitbox.ZIndex = 6

    local isOn = false

    local function updateVisual()
        if isOn then
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(0, 180, 255)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.18), {Position = UDim2.new(1, -(circleD + 2 * guiScale), 0.5, -circleD/2), BackgroundColor3 = Color3.fromRGB(200, 240, 255)}):Play()
        else
            TweenService:Create(pill, TweenInfo.new(0.18), {BackgroundColor3 = Color3.fromRGB(30,30,45)}):Play()
            TweenService:Create(circle, TweenInfo.new(0.18), {Position = UDim2.new(0, 2*guiScale, 0.5, -circleD/2), BackgroundColor3 = Color3.new(1,1,1)}):Play()
        end
    end

    return hitbox, function(state) isOn = state updateVisual() end, function() return isOn end, lbl, bindBtn
end

local function makeSlider(parent, labelText, minVal, maxVal, valueKey, onChange)
    local frame, stroke = makeRowFrame(parent, SLIDER_H)

    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(0.65, 0, 0, 18 * guiScale)
    label.Position = UDim2.new(0, 10 * guiScale, 0, 4 * guiScale)
    label.BackgroundTransparency = 1
    label.Text = labelText
    label.TextColor3 = Color3.fromRGB(170, 170, 200)
    label.Font = Enum.Font.GothamBold
    label.TextSize = 11 * guiScale
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.ZIndex = 4

    local valLabel = Instance.new("TextLabel", frame)
    valLabel.Size = UDim2.new(0, 40 * guiScale, 0, 18 * guiScale)
    valLabel.Position = UDim2.new(1, -46 * guiScale, 0, 4 * guiScale)
    valLabel.BackgroundTransparency = 1
    valLabel.Text = tostring(Values[valueKey] or minVal)
    valLabel.Font = Enum.Font.GothamBlack
    valLabel.TextSize = 11 * guiScale
    valLabel.TextXAlignment = Enum.TextXAlignment.Right
    valLabel.ZIndex = 4
    addAccent(valLabel, "TextColor3")

    local trackH = isMobile and 8 * guiScale or 6 * guiScale
    local thumbD = isMobile and 16 * guiScale or 12 * guiScale
    local trackY = isMobile and 33 * guiScale or 30 * guiScale

    local track = Instance.new("Frame", frame)
    track.Size = UDim2.new(1, -18 * guiScale, 0, trackH)
    track.Position = UDim2.new(0, 9 * guiScale, 0, trackY)
    track.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    track.BorderSizePixel = 0
    track.ZIndex = 4
    Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

    local fill = Instance.new("Frame", track)
    local initPct = ((Values[valueKey] or minVal) - minVal) / math.max(maxVal - minVal, 1)
    fill.Size = UDim2.new(initPct, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 200, 255)
    fill.BorderSizePixel = 0
    fill.ZIndex = 5
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    addAccent(fill, "BackgroundColor3")

    local thumb = Instance.new("Frame", track)
    thumb.Size = UDim2.new(0, thumbD, 0, thumbD)
    thumb.Position = UDim2.new(initPct, -thumbD/2, 0.5, -thumbD/2)
    thumb.BackgroundColor3 = Color3.new(1,1,1)
    thumb.BorderSizePixel = 0
    thumb.ZIndex = 6
    Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

    local dragging = false
    local function update(relX)
        relX = math.clamp(relX, 0, 1)
        local val = math.floor(minVal + (maxVal - minVal) * relX)
        if Values[valueKey] ~= nil then Values[valueKey] = val end
        valLabel.Text = tostring(val)
        fill.Size = UDim2.new(relX, 0, 1, 0)
        thumb.Position = UDim2.new(relX, -thumbD/2, 0.5, -thumbD/2)
        if onChange then onChange(val) end
    end

    local activeInput = nil

track.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 
    or input.UserInputType == Enum.UserInputType.Touch then
        
        dragging = true
        activeInput = input
        
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        update(rel)
    end
end)

track.InputEnded:Connect(function(input)
    if input == activeInput then
        dragging = false
        activeInput = nil
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and input == activeInput then
        local rel = (input.Position.X - track.AbsolutePosition.X) / track.AbsoluteSize.X
        update(rel)
    end
end)
-- CLICK VALUE TO TYPE NUMBER
valLabel.InputBegan:Connect(function(input)
    if input.UserInputType ~= Enum.UserInputType.MouseButton1 
    and input.UserInputType ~= Enum.UserInputType.Touch then
        return
    end

    local textBox = Instance.new("TextBox")
    textBox.Size = valLabel.Size
    textBox.Position = valLabel.Position
    textBox.BackgroundTransparency = 1
    textBox.Text = valLabel.Text
    textBox.Font = valLabel.Font
    textBox.TextSize = valLabel.TextSize
    textBox.TextColor3 = valLabel.TextColor3
    textBox.ClearTextOnFocus = false
    textBox.Parent = frame
    textBox:CaptureFocus()

    textBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            local num = tonumber(textBox.Text)
            if num then
                num = math.clamp(num, minVal, maxVal)
                local rel = (num - minVal) / math.max(maxVal - minVal, 1)
                update(rel)
            end
        end
        textBox:Destroy()
    end)
end)
    return frame
end

do
    local curKeybind = Enum.KeyCode.E
    local listening = false
    local btn, setV, getV, lbl, bindBtn = makeToggle(leftScroll, "Speed Boost", "E")

    local Connections = {}

    local function startSpeedBoost()
        if Connections.speed then return end
        Connections.speed = RunService.Heartbeat:Connect(function()
            if not Features.SpeedBoost then return end
            pcall(function()
                local c = Player.Character
                if not c then return end
                local h = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if not h or not hum then return end
                local md = hum.MoveDirection
                if md.Magnitude > 0.1 then
                    h.AssemblyLinearVelocity = Vector3.new(md.X * Values.BoostSpeed, h.AssemblyLinearVelocity.Y, md.Z * Values.BoostSpeed)
                end
            end)
        end)
    end

    local function stopSpeedBoost()
        if Connections.speed then Connections.speed:Disconnect() Connections.speed = nil end
    end

    local function toggle()
        if listening then return end
        local on = not getV()
        setV(on)
        Features.SpeedBoost = on
        if on then startSpeedBoost() else stopSpeedBoost() end
    end

    btn.MouseButton1Click:Connect(toggle)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe or listening then return end
            if inp.KeyCode == curKeybind then toggle() end
        end)
    end

    if bindBtn then
        bindBtn.MouseButton1Click:Connect(function()
            if listening then return end
            listening = true
            bindBtn.Text = "..."
            bindBtn.TextColor3 = Color3.new(1,1,1)
            local conn
            conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                conn:Disconnect()
                curKeybind = inp.KeyCode
                listening = false
                bindBtn.Text = "BIND"
                bindBtn.TextColor3 = Color3.fromRGB(0,220,255)
                lbl.Text = "Speed Boost  [" .. curKeybind.Name .. "]"
            end)
        end)
    end
end

makeSlider(leftScroll, "Speed Value", 1, 70, "BoostSpeed")

do
    local antiRagdollMode = nil
    local ragdollConnections = {}
    local cachedCharData = {}
    local isBoosting = false
    local BOOST_SPEED = 400
    local AR_DEFAULT_SPEED = 16

    local function arCacheCharacterData()
        local char = Player.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return false end
        cachedCharData = { character = char, humanoid = hum, root = root }
        return true
    end

    local function arDisconnectAll()
        for _, conn in ipairs(ragdollConnections) do pcall(function() conn:Disconnect() end) end
        ragdollConnections = {}
    end

    local function arIsRagdolled()
        if not cachedCharData.humanoid then return false end
        local state = cachedCharData.humanoid:GetState()
        local ragdollStates = {[Enum.HumanoidStateType.Physics]=true,[Enum.HumanoidStateType.Ragdoll]=true,[Enum.HumanoidStateType.FallingDown]=true}
        if ragdollStates[state] then return true end
        local endTime = Player:GetAttribute("RagdollEndTime")
        if endTime and (endTime - workspace:GetServerTimeNow()) > 0 then return true end
        return false
    end

    local function arForceExitRagdoll()
        if not cachedCharData.humanoid or not cachedCharData.root then return end
        pcall(function() Player:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
        for _, d in ipairs(cachedCharData.character:GetDescendants()) do
            if d:IsA("BallSocketConstraint") or (d:IsA("Attachment") and d.Name:find("RagdollAttachment")) then d:Destroy() end
        end
        if not isBoosting then isBoosting = true cachedCharData.humanoid.WalkSpeed = BOOST_SPEED end
        if cachedCharData.humanoid.Health > 0 then cachedCharData.humanoid:ChangeState(Enum.HumanoidStateType.Running) end
        cachedCharData.root.Anchored = false
    end

    local function startAntiRagdoll()
        if antiRagdollMode == "v1" then return end
        if not arCacheCharacterData() then return end
        antiRagdollMode = "v1"
        local camConn = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam and cachedCharData.humanoid then cam.CameraSubject = cachedCharData.humanoid end
        end)
        table.insert(ragdollConnections, camConn)
        local respawnConn = Player.CharacterAdded:Connect(function() isBoosting = false task.wait(0.5) arCacheCharacterData() end)
        table.insert(ragdollConnections, respawnConn)
        task.spawn(function()
            while antiRagdollMode == "v1" do
                task.wait()
                if arIsRagdolled() then arForceExitRagdoll()
                elseif isBoosting then isBoosting = false if cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end end
            end
        end)
    end

    local function stopAntiRagdoll()
        antiRagdollMode = nil
        if isBoosting and cachedCharData.humanoid then cachedCharData.humanoid.WalkSpeed = AR_DEFAULT_SPEED end
        isBoosting = false arDisconnectAll() cachedCharData = {}
    end

    local btn, setV, getV = makeToggle(leftScroll, "Anti Ragdoll")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() 
setV(on) 
Features.AntiRagdoll = on
        if on then startAntiRagdoll() else stopAntiRagdoll() end
    end)
end

do
    local Cebo = {Conn=nil,Circle=nil,Align=nil,Attach=nil}
    local function startMeleeAimbot()
        local char = Player.Character or Player.CharacterAdded:Wait()
        local hrp = char:WaitForChild("HumanoidRootPart")
        Cebo.Attach = Instance.new("Attachment", hrp)
        Cebo.Align = Instance.new("AlignOrientation", hrp)
        Cebo.Align.Attachment0 = Cebo.Attach
        Cebo.Align.Mode = Enum.OrientationAlignmentMode.OneAttachment
        Cebo.Align.RigidityEnabled = true
        Cebo.Circle = Instance.new("Part")
        Cebo.Circle.Shape = Enum.PartType.Cylinder
        Cebo.Circle.Material = Enum.Material.Neon
        Cebo.Circle.Size = Vector3.new(0.05, 14.5, 14.5)
        Cebo.Circle.Color = Color3.fromRGB(0, 200, 255)
        Cebo.Circle.CanCollide = false
        Cebo.Circle.Massless = true
        Cebo.Circle.Parent = workspace
        local weld = Instance.new("Weld")
        weld.Part0 = hrp weld.Part1 = Cebo.Circle
        weld.C0 = CFrame.new(0,-1,0)*CFrame.Angles(0,0,math.rad(90))
        weld.Parent = Cebo.Circle
        Cebo.Conn = RunService.RenderStepped:Connect(function()
            local target, dmin = nil, 7.25
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= Player and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                    local d = (p.Character.HumanoidRootPart.Position - hrp.Position).Magnitude
                    if d <= dmin then target, dmin = p.Character.HumanoidRootPart, d end
                end
            end
            if target then
                char.Humanoid.AutoRotate = false
                Cebo.Align.Enabled = true
                Cebo.Align.CFrame = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
                local t = char:FindFirstChild("Bat") or char:FindFirstChild("Medusa")
                if t then t:Activate() end
            else Cebo.Align.Enabled = false char.Humanoid.AutoRotate = true end
        end)
    end
    local function stopMeleeAimbot()
        if Cebo.Conn   then Cebo.Conn:Disconnect()   Cebo.Conn   = nil end
        if Cebo.Circle then Cebo.Circle:Destroy()     Cebo.Circle = nil end
        if Cebo.Align  then Cebo.Align:Destroy()      Cebo.Align  = nil end
        if Cebo.Attach then Cebo.Attach:Destroy()     Cebo.Attach = nil end
        if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.AutoRotate = true end
    end
    local btn, setV, getV = makeToggle(leftScroll, "Hit Circle")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on)
        if on then startMeleeAimbot() else stopMeleeAimbot() end
    end)
end

do
    local helicopterSpinBAV = nil
    local function applyHelicopterSpeed()
        if helicopterSpinBAV then helicopterSpinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0) end
    end
    local function startHelicopter()
        local c = Player.Character if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
        if helicopterSpinBAV then helicopterSpinBAV:Destroy() helicopterSpinBAV = nil end
        helicopterSpinBAV = Instance.new("BodyAngularVelocity")
        helicopterSpinBAV.Name = "HelicopterBAV"
        helicopterSpinBAV.MaxTorque = Vector3.new(0, math.huge, 0)
        helicopterSpinBAV.AngularVelocity = Vector3.new(0, Values.SpinSpeed, 0)
        helicopterSpinBAV.Parent = hrp
    end
    local function stopHelicopter()
        if helicopterSpinBAV then helicopterSpinBAV:Destroy() helicopterSpinBAV = nil end
    end
    local btn, setV, getV = makeToggle(leftScroll, "Helicopter")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.Helicopter = on
        if on then startHelicopter() else stopHelicopter() end
    end)
    makeSlider(leftScroll, "Helicopter Speed", 5, 50, "SpinSpeed", function(v)
        Values.SpinSpeed = v applyHelicopterSpeed()
    end)
end

do
    local galaxyEnabled = false
    local hopsEnabled = false
    local lastHopTime = 0
    local spaceHeld = false
    local originalJumpPower = 50
    local galaxyVectorForce = nil
    local galaxyAttachment = nil

    local function captureJumpPower()
        local c = Player.Character if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum and hum.JumpPower > 0 then originalJumpPower = hum.JumpPower end
    end
    task.spawn(function() task.wait(1) captureJumpPower() end)
    Player.CharacterAdded:Connect(function() task.wait(1) captureJumpPower() end)

    local function setupGalaxyForce()
        pcall(function()
            local c = Player.Character if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
            if galaxyVectorForce then galaxyVectorForce:Destroy() end
            if galaxyAttachment  then galaxyAttachment:Destroy()  end
            galaxyAttachment = Instance.new("Attachment") galaxyAttachment.Parent = h
            galaxyVectorForce = Instance.new("VectorForce")
            galaxyVectorForce.Attachment0 = galaxyAttachment
            galaxyVectorForce.ApplyAtCenterOfMass = true
            galaxyVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
            galaxyVectorForce.Force = Vector3.new(0,0,0)
            galaxyVectorForce.Parent = h
        end)
    end

    local function updateGalaxyForce()
        if not galaxyEnabled or not galaxyVectorForce then return end
        local c = Player.Character if not c then return end
        local mass = 0
        for _, p in ipairs(c:GetDescendants()) do if p:IsA("BasePart") then mass = mass + p:GetMass() end end
        local tg = Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)
        galaxyVectorForce.Force = Vector3.new(0, mass * (Values.DEFAULT_GRAVITY - tg) * 0.95, 0)
    end

    local function adjustGalaxyJump()
        pcall(function()
            local c = Player.Character if not c then return end
            local hum = c:FindFirstChildOfClass("Humanoid") if not hum then return end
            if not galaxyEnabled then hum.JumpPower = originalJumpPower return end
            local ratio = math.sqrt((Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)) / Values.DEFAULT_GRAVITY)
            hum.JumpPower = originalJumpPower * ratio
        end)
    end

    RunService.Heartbeat:Connect(function()
        if hopsEnabled and spaceHeld then
            pcall(function()
                local c = Player.Character if not c then return end
                local h = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChildOfClass("Humanoid")
                if not h or not hum then return end
                if tick() - lastHopTime < Values.HOP_COOLDOWN then return end
                lastHopTime = tick()
                if hum.FloorMaterial == Enum.Material.Air then
                    h.AssemblyLinearVelocity = Vector3.new(h.AssemblyLinearVelocity.X, Values.HOP_POWER, h.AssemblyLinearVelocity.Z)
                end
            end)
        end
        if galaxyEnabled then updateGalaxyForce() end
    end)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe) if gpe then return end if inp.KeyCode == Enum.KeyCode.Space then spaceHeld = true end end)
        UserInputService.InputEnded:Connect(function(inp) if inp.KeyCode == Enum.KeyCode.Space then spaceHeld = false end end)
    end
    Player.CharacterAdded:Connect(function() task.wait(1) if galaxyEnabled then setupGalaxyForce() adjustGalaxyJump() end end)

    local btn, setV, getV = makeToggle(leftScroll, "Galaxy Mode")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) galaxyEnabled = on hopsEnabled = on
        if on then setupGalaxyForce() adjustGalaxyJump()
        else
            if galaxyVectorForce then galaxyVectorForce:Destroy() galaxyVectorForce = nil end
            if galaxyAttachment  then galaxyAttachment:Destroy()  galaxyAttachment  = nil end
            adjustGalaxyJump()
        end
    end)
end

do
    local isStealing = false
    local StealData = {}
    local progressConn = nil
    local stealStartTime = nil
    local autoStealConn = nil
    local STEAL_DURATION = 1.3

    local function isMyPlotByName(pn)
        local plots = workspace:FindFirstChild("Plots") if not plots then return false end
        local plot = plots:FindFirstChild(pn) if not plot then return false end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then local yb = sign:FindFirstChild("YourBase") if yb and yb:IsA("BillboardGui") then return yb.Enabled end end
        return false
    end

    local function findNearestPrompt()
        local h = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") if not h then return nil end
        local plots = workspace:FindFirstChild("Plots") if not plots then return nil end
        local np, nd, nn = nil, math.huge, nil
        for _, plot in ipairs(plots:GetChildren()) do
            if isMyPlotByName(plot.Name) then continue end
            local podiums = plot:FindFirstChild("AnimalPodiums") if not podiums then continue end
            for _, pod in ipairs(podiums:GetChildren()) do
                pcall(function()
                    local base = pod:FindFirstChild("Base")
                    local spawn = base and base:FindFirstChild("Spawn")
                    if spawn then
                        local dist = (spawn.Position - h.Position).Magnitude
                        if dist < nd and dist <= Values.STEAL_RADIUS then
                            local att = spawn:FindFirstChild("PromptAttachment")
                            if att then for _, ch in ipairs(att:GetChildren()) do if ch:IsA("ProximityPrompt") then np, nd, nn = ch, dist, pod.Name break end end end
                        end
                    end
                end)
            end
        end
        return np, nd, nn
    end

    local function executeSteal(prompt, name)
        if isStealing then return end
        if not StealData[prompt] then
            StealData[prompt] = {hold={},trigger={},ready=true}
            
        end
        local data = StealData[prompt]
        if not data.ready then return end
        data.ready = false isStealing = true stealStartTime = tick()
        if progressConn then progressConn:Disconnect() end
        progressConn = RunService.Heartbeat:Connect(function()
            if not isStealing then progressConn:Disconnect() return end
            local prog = math.clamp((tick() - stealStartTime) / STEAL_DURATION, 0, 1)
            ProgressBarFill.Size = UDim2.new(prog, 0, 1, 0)
            ProgressPercentLabel.Text = math.floor(prog * 100) .. "%"
        end)
        task.spawn(function()
    task.wait(STEAL_DURATION * (0.88 + math.random()*0.24))  
    pcall(function()
        if prompt and prompt.Parent then
            fireproximityprompt(prompt)  -- or prompt:InputHoldEnd() if no fireproximityprompt
        end
    end)
            if progressConn then progressConn:Disconnect() progressConn = nil end
            resetProgressBar() data.ready = true isStealing = false
        end)
    end

    local function startAutoSteal()
        if autoStealConn then return end
        autoStealConn = RunService.Heartbeat:Connect(function()
            if not Features.AutoSteal or isStealing then return end
            local p, _, n = findNearestPrompt() if p then executeSteal(p, n) end
        end)
    end
    local function stopAutoSteal()
        if autoStealConn then autoStealConn:Disconnect() autoStealConn = nil end
        if progressConn  then progressConn:Disconnect()  progressConn  = nil end
        isStealing = false resetProgressBar()
    end

    local btn, setV, getV = makeToggle(leftScroll, "Auto Steal")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.AutoSteal = on
        if on then startAutoSteal() else stopAutoSteal() end
    end)
    makeSlider(leftScroll, "Steal Radius", 5, 100, "STEAL_RADIUS", function(v) Values.STEAL_RADIUS = v end)
end

-- 🌠 GALAXY SKY (new GUI style)
do
    local skyEnabled = false
    local Lighting = game:GetService("Lighting")

    local oldAmbient = Lighting.Ambient
    local oldOutdoor = Lighting.OutdoorAmbient
    local oldTop = Lighting.ColorShift_Top
    local oldBottom = Lighting.ColorShift_Bottom

    local function enableGalaxySky()
        Lighting.Ambient = Color3.fromRGB(120, 0, 255)
        Lighting.OutdoorAmbient = Color3.fromRGB(80, 0, 160)
        Lighting.ColorShift_Top = Color3.fromRGB(0, 180, 255)
        Lighting.ColorShift_Bottom = Color3.fromRGB(150, 0, 255)
    end

    local function disableGalaxySky()
        Lighting.Ambient = oldAmbient
        Lighting.OutdoorAmbient = oldOutdoor
        Lighting.ColorShift_Top = oldTop
        Lighting.ColorShift_Bottom = oldBottom
    end

    local btn, setV, getV = makeToggle(leftScroll, "Galaxy Sky")
    btn.MouseButton1Click:Connect(function()
        local on = not getV()
        setV(on)
        if on then
            enableGalaxySky()
        else
            disableGalaxySky()
        end
    end)
end


-- 🌌 GALAXY MODE (new GUI style)
do
    local galaxyEnabled = false
    local hopsEnabled = false
    local lastHopTime = 0
    local spaceHeld = false

    local galaxyVectorForce = nil
    local galaxyAttachment = nil

    local function setupGalaxyForce()
        local c = Player.Character if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart") if not h then return end

        if galaxyVectorForce then galaxyVectorForce:Destroy() end
        if galaxyAttachment then galaxyAttachment:Destroy() end

        galaxyAttachment = Instance.new("Attachment", h)
        galaxyVectorForce = Instance.new("VectorForce")
        galaxyVectorForce.Attachment0 = galaxyAttachment
        galaxyVectorForce.ApplyAtCenterOfMass = true
        galaxyVectorForce.RelativeTo = Enum.ActuatorRelativeTo.World
        galaxyVectorForce.Parent = h
    end

    local function updateGalaxyForce()
        if not galaxyEnabled or not galaxyVectorForce then return end
        local c = Player.Character if not c then return end
        local mass = 0
        for _, p in ipairs(c:GetDescendants()) do
            if p:IsA("BasePart") then
                mass += p:GetMass()
            end
        end

        local targetGravity = Values.DEFAULT_GRAVITY * (Values.GalaxyGravityPercent / 100)
        galaxyVectorForce.Force = Vector3.new(0, mass * (Values.DEFAULT_GRAVITY - targetGravity), 0)
    end

    RunService.Heartbeat:Connect(function()
        if hopsEnabled and spaceHeld then
            if tick() - lastHopTime < Values.HOP_COOLDOWN then return end
            lastHopTime = tick()

            local c = Player.Character if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart")
            if h then
                h.AssemblyLinearVelocity = Vector3.new(
                    h.AssemblyLinearVelocity.X,
                    Values.HOP_POWER,
                    h.AssemblyLinearVelocity.Z
                )
            end
        end

        if galaxyEnabled then
            updateGalaxyForce()
        end
    end)

    UserInputService.InputBegan:Connect(function(i,g)
        if g then return end
        if i.KeyCode == Enum.KeyCode.Space then
            spaceHeld = true
        end
    end)

    UserInputService.InputEnded:Connect(function(i)
        if i.KeyCode == Enum.KeyCode.Space then
            spaceHeld = false
        end
    end)

    local btn, setV, getV = makeToggle(leftScroll, "Galaxy Mode")
    btn.MouseButton1Click:Connect(function()
        local on = not getV()
        setV(on)
        galaxyEnabled = on
        hopsEnabled = on

        if on then
            setupGalaxyForce()
        else
            if galaxyVectorForce then galaxyVectorForce:Destroy() galaxyVectorForce = nil end
            if galaxyAttachment then galaxyAttachment:Destroy() galaxyAttachment = nil end
        end
    end)

    makeSlider(leftScroll, "Gravity", 0, 100, "GalaxyGravityPercent")
    makeSlider(leftScroll, "Hop Power", 0, 100, "HOP_POWER")
end

do
    local lastBatSwing = 0
    local BAT_SWING_COOLDOWN = 0.12
    local SlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}
    local function findBat()
        local c = Player.Character if not c then return nil end
        local bp = Player:FindFirstChildOfClass("Backpack")
        for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
        if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
        for _, name in ipairs(SlapList) do local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)) if t then return t end end
        return nil
    end
    local spamBatConn = nil
    local function startSpamBat()
        if spamBatConn then return end
        spamBatConn = RunService.Heartbeat:Connect(function()
            if not Features.SpamBat then return end
            local c = Player.Character if not c then return end
            local bat = findBat() if not bat then return end
            if bat.Parent ~= c then bat.Parent = c end
            local now = tick() if now - lastBatSwing < BAT_SWING_COOLDOWN then return end
            lastBatSwing = now pcall(function() bat:Activate() end)
        end)
    end
    local function stopSpamBat()
        if spamBatConn then spamBatConn:Disconnect() spamBatConn = nil end
    end
    local btn, setV, getV = makeToggle(rightScroll, "Bat Spam")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.SpamBat = on
        if on then startSpamBat() else stopSpamBat() end
    end)
end

do
    local SlapList = {"Bat","Slap","Iron Slap","Gold Slap","Diamond Slap","Emerald Slap","Ruby Slap","Dark Matter Slap","Flame Slap","Nuclear Slap","Galaxy Slap","Glitched Slap"}

    local function findBatForAimbot()
        local c = Player.Character if not c then return nil end
        local bp = Player:FindFirstChildOfClass("Backpack")
        for _, ch in ipairs(c:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end
        if bp then for _, ch in ipairs(bp:GetChildren()) do if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end end end
        for _, name in ipairs(SlapList) do local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name)) if t then return t end end
        return nil
    end

    local function findNearestEnemy(myHRP)
        local nearest, nearestDist, nearestTorso = nil, math.huge, nil
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= Player and p.Character then
                local eh = p.Character:FindFirstChild("HumanoidRootPart")
                local torso = p.Character:FindFirstChild("UpperTorso") or p.Character:FindFirstChild("Torso")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if eh and hum and hum.Health > 0 then
                    local d = (eh.Position - myHRP.Position).Magnitude
                    if d < nearestDist then
                        nearestDist = d
                        nearest = eh
                        nearestTorso = torso or eh
                    end
                end
            end
        end
        return nearest, nearestDist, nearestTorso
    end

    local batAimbotConn = nil

    local function startBatAimbot()
        if batAimbotConn then return end
        batAimbotConn = RunService.Heartbeat:Connect(function()
            if not Features.BatAimbot then return end
            local c = Player.Character if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart")
            local hum = c:FindFirstChildOfClass("Humanoid")
            if not h or not hum then return end


            local bat = findBatForAimbot()
            if bat and bat.Parent ~= c then
                hum:EquipTool(bat)
            end


            local target, dist, torso = findNearestEnemy(h)
            if target and torso then
                local dir = torso.Position - h.Position
                local flatDir = Vector3.new(dir.X, 0, dir.Z)
                local flatDist = flatDir.Magnitude
                local spd = Values.BatAimbotSpeed

                if flatDist > 1.5 then
                    local moveDir = flatDir.Unit
                    h.AssemblyLinearVelocity = Vector3.new(
                        moveDir.X * spd,
                        h.AssemblyLinearVelocity.Y,
                        moveDir.Z * spd
                    )
                else
                    local tv = target.AssemblyLinearVelocity
                    h.AssemblyLinearVelocity = Vector3.new(tv.X, h.AssemblyLinearVelocity.Y, tv.Z)
                end
            end
        end)
    end

    local function stopBatAimbot()
        if batAimbotConn then batAimbotConn:Disconnect() batAimbotConn = nil end
    end

    local btn, setV, getV = makeToggle(rightScroll, "Bat Aimbot")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.BatAimbot = on
        if on then startBatAimbot() else stopBatAimbot() end
    end)
    makeSlider(rightScroll, "Aimbot Speed", 20, 100, "BatAimbotSpeed", function(v) Values.BatAimbotSpeed = v end)
end

makeSlider(rightScroll, "Gravity %", 25, 130, "GalaxyGravityPercent")

do
    local sConn = nil
    local function startSpeedWhileStealing()
        if sConn then return end
        sConn = RunService.Heartbeat:Connect(function()
            if not Features.SpeedWhileStealing or not Player:GetAttribute("Stealing") then return end
            local c = Player.Character if not c then return end
            local h = c:FindFirstChild("HumanoidRootPart") if not h then return end
            local hum = c:FindFirstChildOfClass("Humanoid")
            local md = hum and hum.MoveDirection or Vector3.zero
            if md.Magnitude > 0.1 then
                h.AssemblyLinearVelocity = Vector3.new(md.X*Values.StealingSpeedValue, h.AssemblyLinearVelocity.Y, md.Z*Values.StealingSpeedValue)
            end
        end)
    end
    local function stopSpeedWhileStealing()
        if sConn then sConn:Disconnect() sConn = nil end
    end
    local btn, setV, getV = makeToggle(rightScroll, "Thief Speed")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.SpeedWhileStealing = on
        if on then startSpeedWhileStealing() else stopSpeedWhileStealing() end
    end)
    makeSlider(rightScroll, "Steal Speed", 10, 50, "StealingSpeedValue")
end

do
    local savedAnimations = {}
    local function startUnwalk()
        local c = Player.Character if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then for _, t in ipairs(hum:GetPlayingAnimationTracks()) do t:Stop() end end
        local anim = c:FindFirstChild("Animate")
        if anim then savedAnimations.Animate = anim:Clone() anim:Destroy() end
    end
    local function stopUnwalk()
        local c = Player.Character
        if c and savedAnimations.Animate then savedAnimations.Animate:Clone().Parent = c savedAnimations.Animate = nil end
    end
    local btn, setV, getV = makeToggle(rightScroll, "Unwalk")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.Unwalk = on
        if on then startUnwalk() else stopUnwalk() end
    end)
end

do
    local function enableOptimizer()
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            game:GetService("Lighting").GlobalShadows = false
            game:GetService("Lighting").Brightness = 3
        end)
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                pcall(function()
                    if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") then obj:Destroy()
                    elseif obj:IsA("BasePart") then obj.CastShadow = false obj.Material = Enum.Material.Plastic end
                end)
            end
        end)
    end
    local btn, setV, getV = makeToggle(rightScroll, "Optimizer")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.Optimizer = on
        if on then enableOptimizer() end
    end)
end

do
    local originalTransparency = {}
    local function enableXRay()
        pcall(function()
            for _, obj in ipairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj.Anchored and (obj.Name:lower():find("base") or (obj.Parent and obj.Parent.Name:lower():find("base"))) then
                    originalTransparency[obj] = obj.LocalTransparencyModifier
                    obj.LocalTransparencyModifier = 0.85
                end
            end
        end)
    end
    local function disableXRay()
        for part, value in pairs(originalTransparency) do if part then part.LocalTransparencyModifier = value end end
        originalTransparency = {}
    end
    local btn, setV, getV = makeToggle(rightScroll, "XRay")
    btn.MouseButton1Click:Connect(function()
        local on = not getV() setV(on) Features.XRay = on
        if on then enableXRay() else disableXRay() end
    end)
end

do
    local floatConn = nil
    local floatKeybind = Enum.KeyCode.F
    local floatListening = false
    local FLOAT_TARGET_HEIGHT = 10

    local function startFloat()
        local c = Player.Character if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart") if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        local floatOriginY = hrp.Position.Y + FLOAT_TARGET_HEIGHT
        local floatStartTime = tick()
        local floatDescending = false
        if floatConn then floatConn:Disconnect() floatConn = nil end
        floatConn = RunService.Heartbeat:Connect(function()
            if not Features.Float then return end
            local c2 = Player.Character if not c2 then return end
            local h = c2:FindFirstChild("HumanoidRootPart") if not h then return end
            local hum2 = c2:FindFirstChildOfClass("Humanoid")
            local isStealing = Player:GetAttribute("Stealing")
            local moveSpeed = isStealing and Values.StealingSpeedValue or Values.BoostSpeed
            local moveDir = hum2 and hum2.MoveDirection or Vector3.zero
            if tick() - floatStartTime >= 4 then floatDescending = true end
            local currentY = h.Position.Y
            local vertVel
            if floatDescending then
                vertVel = -20
                if currentY <= floatOriginY - FLOAT_TARGET_HEIGHT + 0.5 then
                    h.AssemblyLinearVelocity = Vector3.zero Features.Float = false
                    if floatConn then floatConn:Disconnect() floatConn = nil end
                    return
                end
            else
                local diff = floatOriginY - currentY
                if diff > 0.3 then vertVel = math.clamp(diff*8,5,50)
                elseif diff < -0.3 then vertVel = math.clamp(diff*8,-50,-5)
                else vertVel = 0 end
            end
            local horizX = moveDir.Magnitude > 0.1 and moveDir.X * moveSpeed or 0
            local horizZ = moveDir.Magnitude > 0.1 and moveDir.Z * moveSpeed or 0
            h.AssemblyLinearVelocity = Vector3.new(horizX, vertVel, horizZ)
        end)
    end

    local function stopFloat()
        if floatConn then floatConn:Disconnect() floatConn = nil end
        local c = Player.Character
        if c then
            local hrp = c:FindFirstChild("HumanoidRootPart")
            if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
        end
    end

    local btn, setV, getV, lbl, bindBtn = makeToggle(rightScroll, "Float", "F")

    local function toggleFloat()
        if floatListening then return end
        local on = not getV() setV(on) Features.Float = on
        if on then startFloat() else stopFloat() end
    end

    btn.MouseButton1Click:Connect(toggleFloat)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe or floatListening then return end
            if inp.KeyCode == floatKeybind then toggleFloat() end
        end)
    end

    if bindBtn then
        bindBtn.MouseButton1Click:Connect(function()
            if floatListening then return end
            floatListening = true
 bindBtn.Text = "..." 
bindBtn.TextColor3 = Color3.new(1,1,1)
            local conn 
conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                conn:Disconnect()
 floatKeybind = inp.KeyCode
 floatListening = false
                bindBtn.Text = "BIND" 
bindBtn.TextColor3 = Color3.fromRGB(0,220,255)
                lbl.Text = "Float  [" .. floatKeybind.Name .. "]"
            end)
        end)
    end
end

do
    local pathActive = false
    local lastFlatVel = Vector3.zero
    local PATH_VELOCITY_SPEED = 59.2
    local PATH_SECOND_SPEED   = 29.6
    local PATH_BASE_STOP      = 1.35
    local PATH_MIN_STOP       = 0.65
    local PATH_NEXT_POINT_BIAS= 0.45
    local PATH_SMOOTH_FACTOR  = 0.12

    local stealPath1 = {
        {pos=Vector3.new(-470.6,-5.9,34.4)},{pos=Vector3.new(-484.2,-3.9,21.4)},
        {pos=Vector3.new(-475.6,-5.8,29.3)},{pos=Vector3.new(-473.4,-5.9,111)}
    }
    local stealPath2 = {
        {pos=Vector3.new(-474.7,-5.9,91.0)},{pos=Vector3.new(-483.4,-3.9,97.3)},
        {pos=Vector3.new(-474.7,-5.9,91.0)},{pos=Vector3.new(-476.1,-5.5,25.4)}
    }

    local function pathMoveToPoint(hrp, current, nextPoint, speed)
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not pathActive then 
                     conn:Disconnect()
                     hrp.AssemblyLinearVelocity = Vector3.zero 
             return 
            end
            local pos = hrp.Position
            local target = Vector3.new(current.X, pos.Y, current.Z)
            local dir = target - pos
            local dist = dir.Magnitude
            local stopDist = math.clamp(PATH_BASE_STOP - dist*0.04, PATH_MIN_STOP, PATH_BASE_STOP)
            if dist <= stopDist then conn:Disconnect() hrp.AssemblyLinearVelocity = Vector3.zero return end
            local moveDir = dir.Unit
            if nextPoint then
                local nextDir = (Vector3.new(nextPoint.X, pos.Y, nextPoint.Z) - pos).Unit
                moveDir = (moveDir + nextDir * PATH_NEXT_POINT_BIAS).Unit
            end
            if lastFlatVel.Magnitude > 0.1 then
                moveDir = (moveDir*(1-PATH_SMOOTH_FACTOR) + lastFlatVel.Unit*PATH_SMOOTH_FACTOR).Unit
            end
            local vel = Vector3.new(moveDir.X*speed, hrp.AssemblyLinearVelocity.Y, moveDir.Z*speed)
            hrp.AssemblyLinearVelocity = vel
            lastFlatVel = Vector3.new(vel.X, 0, vel.Z)
        end)
        while pathActive and (Vector3.new(hrp.Position.X,0,hrp.Position.Z)-Vector3.new(current.X,0,current.Z)).Magnitude > PATH_BASE_STOP do
            RunService.Heartbeat:Wait()
        end
    end

    local function runStealPath(path)
        local hrp = (Player.Character or Player.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart")
        for i, p in ipairs(path) do
            if not pathActive then return end
            local speed = i > 2 and PATH_SECOND_SPEED or PATH_VELOCITY_SPEED
            local nextP = path[i+1] and path[i+1].pos
            pathMoveToPoint(hrp, p.pos, nextP, speed)
            task.wait()
        end
    end

    local function startStealPath(path)
        pathActive = true
        task.spawn(function() while pathActive do runStealPath(path) task.wait(0.1) end end)
    end
    local function stopStealPath()
        pathActive = false
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.AssemblyLinearVelocity = Vector3.zero end
    end

    local rightKeybind = Enum.KeyCode.E
    local rightListening = false
    local leftSetV = nil

    local rBtn, rSetV, rGetV, rLbl, rBindBtn = makeToggle(rightScroll, "Right Steal", "E")

    local function toggleRight()
        if rightListening then return end
        local on = not rGetV()
        rSetV(on) 
        stopStealPath()
        if leftSetV then leftSetV(false) end
        if on then startStealPath(stealPath1) end
    end

    rBtn.MouseButton1Click:Connect(toggleRight)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe or rightListening then return end
            if inp.KeyCode == rightKeybind then toggleRight() end
        end)
    end

    if rBindBtn then
        rBindBtn.MouseButton1Click:Connect(function()
            if rightListening then return end
            rightListening = true 
            rBindBtn.Text = "..."
            rBindBtn.TextColor3 = Color3.new(1,1,1)

            local conn
            conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                conn:Disconnect() 
                rightKeybind = inp.KeyCode
                rightListening = false
                rBindBtn.Text = "BIND" rBindBtn.TextColor3 = Color3.fromRGB(0,220,255)
                rLbl.Text = "Right Steal  [" .. rightKeybind.Name .. "]"
            end)
        end)
    end

    local leftKeybind = Enum.KeyCode.Q
    local leftListening = false
    local lBtn, lSetV, lGetV, lLbl, lBindBtn = makeToggle(rightScroll, "Left Steal", "Q")
    leftSetV = lSetV

    local function toggleLeft()
        if leftListening then return end
        local on = not lGetV()
       lSetV(on) 
       stopStealPath() 
       rSetV(false)
        if on then startStealPath(stealPath2) end
    end

    lBtn.MouseButton1Click:Connect(toggleLeft)

    if not isMobile then
        UserInputService.InputBegan:Connect(function(inp, gpe)
            if gpe or leftListening then return end
            if inp.KeyCode == leftKeybind then toggleLeft() end
        end)
    end

    if lBindBtn then
        lBindBtn.MouseButton1Click:Connect(function()
            if leftListening then return end
            leftListening = true
            lBindBtn.Text = "..." 
            lBindBtn.TextColor3 = Color3.new(1,1,1)

            local conn
            conn = UserInputService.InputBegan:Connect(function(inp)
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                conn:Disconnect()
                leftKeybind = inp.KeyCode 
                leftListening = false
                lBindBtn.Text = "BIND"
                lBindBtn.TextColor3 = Color3.fromRGB(0,220,255)
                lLbl.Text = "Left Steal  [" .. leftKeybind.Name .. "]"
            end)
        end)
    end
end

leftLayout.Changed:Connect(function()
    leftScroll.CanvasSize = UDim2.new(0, 0, 0, leftLayout.AbsoluteContentSize.Y + 16 * guiScale)
end)
rightLayout.Changed:Connect(function()
    rightScroll.CanvasSize = UDim2.new(0, 0, 0, rightLayout.AbsoluteContentSize.Y + 16 * guiScale)
end)

local visible = true

if not isMobile then
    UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        if input.KeyCode == Enum.KeyCode.U then
            visible = not visible
            TweenService:Create(main, TweenInfo.new(0.2), {BackgroundTransparency = visible and 0.08 or 1}):Play()
            main.Visible = visible
           end
     end)
end
