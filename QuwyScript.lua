local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("QUWY_AMOLED") then
    CoreGui.QUWY_AMOLED:Destroy()
end

local Colors = {
    Black = Color3.fromRGB(5, 5, 5),
    DarkGray = Color3.fromRGB(15, 15, 15),
    Purple = Color3.fromRGB(160, 80, 255),
    Text = Color3.fromRGB(255, 255, 255),
    SubText = Color3.fromRGB(150, 150, 150),
    Red = Color3.fromRGB(255, 60, 60),
    Success = Color3.fromRGB(60, 255, 120)
}

local Flying = false
local FlySpeed = 20
local Noclip = false

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QUWY_AMOLED"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = ScreenGui
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(0.5, -100, 0.85, 0)
NotifContainer.Size = UDim2.new(0, 200, 0, 50)
NotifContainer.ZIndex = 100

local function ShowNotification(text)
    local NotifFrame = Instance.new("Frame")
    NotifFrame.Parent = NotifContainer
    NotifFrame.BackgroundColor3 = Colors.DarkGray
    NotifFrame.Size = UDim2.new(0, 0, 0, 35)
    NotifFrame.Position = UDim2.new(0.5, 0, 0, 0)
    NotifFrame.AnchorPoint = Vector2.new(0.5, 0)
    NotifFrame.BorderSizePixel = 0
    NotifFrame.ClipsDescendants = true
    
    local NC = Instance.new("UICorner", NotifFrame)
    NC.CornerRadius = UDim.new(1, 0)
    
    local NS = Instance.new("UIStroke", NotifFrame)
    NS.Color = Colors.Purple
    NS.Thickness = 1
    
    local NL = Instance.new("TextLabel", NotifFrame)
    NL.BackgroundTransparency = 1
    NL.Size = UDim2.new(1, 0, 1, 0)
    NL.Font = Enum.Font.GothamBold
    NL.TextColor3 = Colors.Text
    NL.TextSize = 14
    NL.Text = text
    NL.TextTransparency = 1
    
    TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 180, 0, 35)}):Play()
    wait(0.1)
    TweenService:Create(NL, TweenInfo.new(0.3), {TextTransparency = 0}):Play()
    
    wait(2)
    
    TweenService:Create(NL, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    local out = TweenService:Create(NotifFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 35)})
    out:Play()
    out.Completed:Wait()
    NotifFrame:Destroy()
end

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Colors.Black
MainFrame.Position = UDim2.new(0.5, -225, 0.5, -150)
MainFrame.Size = UDim2.new(0, 500, 0, 350)
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true

local MainCorner = Instance.new("UICorner", MainFrame)
MainCorner.CornerRadius = UDim.new(0, 12)

local MainStroke = Instance.new("UIStroke", MainFrame)
MainStroke.Color = Colors.Purple
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.2

local TopBar = Instance.new("Frame")
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Colors.DarkGray
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BorderSizePixel = 0

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBlack
Title.Text = "QUWY <font color=\"rgb(160,80,255)\">AMOLED</font>"
Title.RichText = true
Title.TextColor3 = Colors.Text
Title.TextSize = 18
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -40, 0, 0)
CloseBtn.Size = UDim2.new(0, 40, 1, 0)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Text = "✕"
CloseBtn.TextColor3 = Colors.Red
CloseBtn.TextSize = 18

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -80, 0, 0)
MinBtn.Size = UDim2.new(0, 40, 1, 0)
MinBtn.Font = Enum.Font.GothamBold
MinBtn.Text = "—"
MinBtn.TextColor3 = Colors.Text
MinBtn.TextSize = 18

local Sidebar = Instance.new("Frame")
Sidebar.Parent = MainFrame
Sidebar.BackgroundColor3 = Colors.DarkGray
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 130, 1, -40)
Sidebar.BorderSizePixel = 0

local TabHolder = Instance.new("Frame")
TabHolder.Parent = Sidebar
TabHolder.BackgroundTransparency = 1
TabHolder.Size = UDim2.new(1, 0, 1, 0)

local UIList = Instance.new("UIListLayout", TabHolder)
UIList.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIList.Padding = UDim.new(0, 8)
local UIPad = Instance.new("UIPadding", TabHolder)
UIPad.PaddingTop = UDim.new(0, 15)

local PageContainer = Instance.new("Frame")
PageContainer.Parent = MainFrame
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.new(0, 130, 0, 40)
PageContainer.Size = UDim2.new(1, -130, 1, -40)

local function CreateTab(name, icon)
    local Btn = Instance.new("TextButton")
    Btn.Parent = TabHolder
    Btn.BackgroundColor3 = Colors.Black
    Btn.Size = UDim2.new(0, 110, 0, 35)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = name
    Btn.TextColor3 = Colors.SubText
    Btn.TextSize = 14
    
    local C = Instance.new("UICorner", Btn)
    C.CornerRadius = UDim.new(0, 8)
    
    return Btn
end

local function CreatePage(name)
    local P = Instance.new("Frame")
    P.Name = name
    P.Parent = PageContainer
    P.Size = UDim2.new(1, 0, 1, 0)
    P.BackgroundTransparency = 1
    P.Visible = false
    return P
end

local Tab1 = CreateTab("General")
local Tab2 = CreateTab("About")
local Page1 = CreatePage("General")
local Page2 = CreatePage("About")

Page1.Visible = true
Tab1.TextColor3 = Colors.Text
Tab1.BackgroundColor3 = Colors.Purple

local function CreateFeatureBtn(text, parent, pos)
    local B = Instance.new("TextButton")
    B.Parent = parent
    B.BackgroundColor3 = Colors.DarkGray
    B.Position = pos
    B.Size = UDim2.new(0, 160, 0, 45)
    B.Font = Enum.Font.GothamBold
    B.Text = text
    B.TextColor3 = Colors.Text
    B.TextSize = 14
    
    local C = Instance.new("UICorner", B)
    C.CornerRadius = UDim.new(0, 8)
    
    local S = Instance.new("UIStroke", B)
    S.Color = Colors.Purple
    S.Thickness = 1
    S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    return B, S
end

local FlyBtn, FlyStroke = CreateFeatureBtn("ENABLE FLY", Page1, UDim2.new(0, 20, 0, 20))

local SpeedBox = Instance.new("TextBox")
SpeedBox.Parent = Page1
SpeedBox.BackgroundColor3 = Colors.DarkGray
SpeedBox.Position = UDim2.new(0, 190, 0, 20)
SpeedBox.Size = UDim2.new(0, 140, 0, 45)
SpeedBox.Font = Enum.Font.GothamMedium
SpeedBox.Text = "Fly Speed: " .. FlySpeed
SpeedBox.TextColor3 = Colors.Purple
SpeedBox.TextSize = 14
SpeedBox.PlaceholderText = "Speed..."
local SBC = Instance.new("UICorner", SpeedBox)
SBC.CornerRadius = UDim.new(0, 8)

SpeedBox.FocusLost:Connect(function()
    local n = tonumber(string.match(SpeedBox.Text, "%d+"))
    if n then 
        FlySpeed = n 
        SpeedBox.Text = "Fly Speed: " .. n
    else
        SpeedBox.Text = "Fly Speed: " .. FlySpeed
    end
end)

local NoclipBtn, NoclipStroke = CreateFeatureBtn("NOCLIP: OFF", Page1, UDim2.new(0, 20, 0, 80))

local WSLabel = Instance.new("TextLabel")
WSLabel.Parent = Page1
WSLabel.BackgroundTransparency = 1
WSLabel.Position = UDim2.new(0, 20, 0, 140)
WSLabel.Size = UDim2.new(0, 200, 0, 20)
WSLabel.Font = Enum.Font.GothamBold
WSLabel.Text = "WalkSpeed Modifier"
WSLabel.TextColor3 = Colors.SubText
WSLabel.TextXAlignment = Enum.TextXAlignment.Left
WSLabel.TextSize = 14

local WSContainer = Instance.new("Frame")
WSContainer.Parent = Page1
WSContainer.BackgroundColor3 = Colors.DarkGray
WSContainer.Position = UDim2.new(0, 20, 0, 165)
WSContainer.Size = UDim2.new(0, 310, 0, 40)
local WSCorner = Instance.new("UICorner", WSContainer)
WSCorner.CornerRadius = UDim.new(0, 8)

local WSInput = Instance.new("TextBox")
WSInput.Parent = WSContainer
WSInput.BackgroundTransparency = 1
WSInput.Size = UDim2.new(1, 0, 1, 0)
WSInput.Font = Enum.Font.GothamBold
WSInput.Text = "Set Speed (Default 16)"
WSInput.TextColor3 = Colors.Purple
WSInput.TextSize = 14

WSInput.FocusLost:Connect(function()
    local s = tonumber(WSInput.Text)
    if s and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = s
        WSInput.Text = "Speed Set: " .. s
        ShowNotification("WalkSpeed changed to " .. s)
    end
end)

local AboutTitle = Instance.new("TextLabel")
AboutTitle.Parent = Page2
AboutTitle.BackgroundTransparency = 1
AboutTitle.Size = UDim2.new(1, 0, 0.3, 0)
AboutTitle.Font = Enum.Font.FredokaOne
AboutTitle.Text = "QUWY"
AboutTitle.TextColor3 = Colors.Purple
AboutTitle.TextSize = 48

local SubTitle = Instance.new("TextLabel")
SubTitle.Parent = Page2
SubTitle.BackgroundTransparency = 1
SubTitle.Position = UDim2.new(0, 0, 0.25, 0)
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Font = Enum.Font.Gotham
SubTitle.Text = "pls follow 😭"
SubTitle.TextColor3 = Colors.SubText
SubTitle.TextSize = 14

local function CreateLinkBtn(text, url, yPos)
    local Btn = Instance.new("TextButton")
    Btn.Parent = Page2
    Btn.BackgroundColor3 = Colors.DarkGray
    Btn.Position = UDim2.new(0.5, -100, 0.45, yPos)
    Btn.Size = UDim2.new(0, 200, 0, 40)
    Btn.Font = Enum.Font.GothamBold
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.TextSize = 14
    
    local C = Instance.new("UICorner", Btn)
    C.CornerRadius = UDim.new(0, 20)
    
    local S = Instance.new("UIStroke", Btn)
    S.Color = Colors.Purple
    S.Thickness = 1
    S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    Btn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(url)
            ShowNotification("Link Copied!")
        else
            ShowNotification("Executor doesn't support copy :(")
        end
    end)
end

CreateLinkBtn("Telegram: QLogovo", "https://t.me/QLogovo", 0)
CreateLinkBtn("Discord Server", "https://discord.gg/9wCEUewSbN", 50)

local MinCircle = Instance.new("TextButton")
MinCircle.Name = "OpenCircle"
MinCircle.Parent = ScreenGui
MinCircle.BackgroundColor3 = Colors.Purple
MinCircle.Size = UDim2.new(0, 60, 0, 60)
MinCircle.Position = UDim2.new(0.1, 0, 0.1, 0)
MinCircle.Text = "Q"
MinCircle.Font = Enum.Font.FredokaOne
MinCircle.TextColor3 = Colors.Text
MinCircle.TextSize = 24
MinCircle.Visible = false
MinCircle.AutoButtonColor = true

local MCC = Instance.new("UICorner", MinCircle)
MCC.CornerRadius = UDim.new(1, 0)

local MCS = Instance.new("UIStroke", MinCircle)
MCS.Color = Colors.Text
MCS.Thickness = 2
MCS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function SwitchTab(activeBtn, activePage)
    Tab1.BackgroundColor3 = Colors.Black; Tab1.TextColor3 = Colors.SubText
    Tab2.BackgroundColor3 = Colors.Black; Tab2.TextColor3 = Colors.SubText
    Page1.Visible = false; Page2.Visible = false
    
    activeBtn.BackgroundColor3 = Colors.Purple
    activeBtn.TextColor3 = Colors.Text
    activePage.Visible = true
    
    activePage.Position = UDim2.new(0, 0, 0, 15)
    TweenService:Create(activePage, TweenInfo.new(0.25), {Position = UDim2.new(0,0,0,0)}):Play()
end

Tab1.MouseButton1Click:Connect(function() SwitchTab(Tab1, Page1) end)
Tab2.MouseButton1Click:Connect(function() SwitchTab(Tab2, Page2) end)

local function Drag(frame, hold)
    local dragToggle, dragStart, startPos
    hold.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end

Drag(MainFrame, TopBar)

local CircleWasDragged = false
local function DragCircle(frame)
    local dragToggle, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragToggle = true
            dragStart = input.Position
            startPos = frame.Position
            CircleWasDragged = false
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragToggle = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and dragToggle then
            local delta = input.Position - dragStart
            if delta.Magnitude > 5 then
                CircleWasDragged = true
                TweenService:Create(frame, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
            end
        end
    end)
end

DragCircle(MinCircle)

CloseBtn.MouseButton1Click:Connect(function()
    if Flying then 
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.PlatformStand = false 
        end
    end
    TweenService:Create(MainFrame, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 1}):Play()
    wait(0.3)
    ScreenGui:Destroy()
end)

MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    MinCircle.Visible = true
    MinCircle.Size = UDim2.new(0,0,0,0)
    TweenService:Create(MinCircle, TweenInfo.new(0.4, Enum.EasingStyle.Elastic), {Size = UDim2.new(0, 60, 0, 60)}):Play()
end)

MinCircle.MouseButton1Click:Connect(function()
    if CircleWasDragged then 
        CircleWasDragged = false
        return 
    end
    MinCircle.Visible = false
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0,0,0,0)
    TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 500, 0, 350)}):Play()
end)

local BodyGyro, BodyVelocity
local function StartFly()
    Flying = true
    FlyBtn.Text = "FLYING..."
    TweenService:Create(FlyStroke, TweenInfo.new(0.2), {Color = Colors.Success}):Play()
    TweenService:Create(FlyBtn, TweenInfo.new(0.2), {TextColor3 = Colors.Success}):Play()
    
    local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local HRP = Char:WaitForChild("HumanoidRootPart")
    local Humanoid = Char:WaitForChild("Humanoid")

    BodyGyro = Instance.new("BodyGyro", HRP)
    BodyGyro.P = 9e4
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = HRP.CFrame

    BodyVelocity = Instance.new("BodyVelocity", HRP)
    BodyVelocity.velocity = Vector3.new(0,0,0)
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)

    Humanoid.PlatformStand = true

    task.spawn(function()
        while Flying and Char and Humanoid.Health > 0 do
            RunService.RenderStepped:Wait()
            if not Flying then break end
            
            local Cam = workspace.CurrentCamera
            BodyGyro.cframe = Cam.CFrame
            local dir = Vector3.new(0,0,0)
            
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then dir = dir + Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then dir = dir - Cam.CFrame.LookVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then dir = dir - Cam.CFrame.RightVector end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then dir = dir + Cam.CFrame.RightVector end
            
            BodyVelocity.velocity = dir * FlySpeed
        end
    end)
end

local function StopFly()
    Flying = false
    FlyBtn.Text = "ENABLE FLY"
    TweenService:Create(FlyStroke, TweenInfo.new(0.2), {Color = Colors.Purple}):Play()
    TweenService:Create(FlyBtn, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
    
    if LocalPlayer.Character then
        local HRP = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local Hum = LocalPlayer.Character:FindFirstChild("Humanoid")
        if HRP then
            if HRP:FindFirstChild("BodyGyro") then HRP.BodyGyro:Destroy() end
            if HRP:FindFirstChild("BodyVelocity") then HRP.BodyVelocity:Destroy() end
        end
        if Hum then Hum.PlatformStand = false end
    end
end

FlyBtn.MouseButton1Click:Connect(function()
    if Flying then StopFly() else StartFly() end
end)

RunService.Stepped:Connect(function()
    if Noclip and LocalPlayer.Character then
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.CanCollide then
                part.CanCollide = false
            end
        end
    end
end)

NoclipBtn.MouseButton1Click:Connect(function()
    Noclip = not Noclip
    if Noclip then
        NoclipBtn.Text = "NOCLIP: ON"
        TweenService:Create(NoclipStroke, TweenInfo.new(0.2), {Color = Colors.Success}):Play()
        TweenService:Create(NoclipBtn, TweenInfo.new(0.2), {TextColor3 = Colors.Success}):Play()
    else
        NoclipBtn.Text = "NOCLIP: OFF"
        TweenService:Create(NoclipStroke, TweenInfo.new(0.2), {Color = Colors.Purple}):Play()
        TweenService:Create(NoclipBtn, TweenInfo.new(0.2), {TextColor3 = Colors.Text}):Play()
    end
end)

MainFrame.Size = UDim2.new(0,0,0,0)
TweenService:Create(MainFrame, TweenInfo.new(0.6, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 500, 0, 350)}):Play()