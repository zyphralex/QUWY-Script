local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

if CoreGui:FindFirstChild("QUWY_MINIMAL") then
    CoreGui.QUWY_MINIMAL:Destroy()
end

local Theme = {
    Background = Color3.fromRGB(12, 12, 12),
    Element = Color3.fromRGB(20, 20, 20),
    Accent = Color3.fromRGB(150, 80, 255),
    Text = Color3.fromRGB(240, 240, 240),
    SubText = Color3.fromRGB(120, 120, 120),
    Red = Color3.fromRGB(255, 70, 70),
    Green = Color3.fromRGB(70, 255, 120)
}

local State = {
    Flying = false,
    FlySpeed = 20,
    Noclip = false,
    InfJump = false,
    CtrlTP = false,
    Fullbright = false
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "QUWY_MINIMAL"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local NotifContainer = Instance.new("Frame")
NotifContainer.Parent = ScreenGui
NotifContainer.BackgroundTransparency = 1
NotifContainer.Position = UDim2.new(0.5, -100, 0.9, 0)
NotifContainer.Size = UDim2.new(0, 200, 0, 40)
NotifContainer.ZIndex = 200

local function Notify(text)
    local F = Instance.new("Frame")
    F.Parent = NotifContainer
    F.BackgroundColor3 = Theme.Element
    F.Size = UDim2.new(0, 0, 0, 30)
    F.Position = UDim2.new(0.5, 0, 0, 0)
    F.AnchorPoint = Vector2.new(0.5, 0)
    F.BorderSizePixel = 0
    
    local C = Instance.new("UICorner", F)
    C.CornerRadius = UDim.new(0, 6)
    
    local S = Instance.new("UIStroke", F)
    S.Color = Theme.Accent
    S.Thickness = 1
    
    local L = Instance.new("TextLabel", F)
    L.BackgroundTransparency = 1
    L.Size = UDim2.new(1, 0, 1, 0)
    L.Font = Enum.Font.GothamMedium
    L.Text = text
    L.TextColor3 = Theme.Text
    L.TextSize = 12
    L.TextTransparency = 1
    
    TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(0, 180, 0, 30)}):Play()
    wait(0.1)
    TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    wait(2)
    TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    local out = TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 30)})
    out:Play()
    out.Completed:Wait()
    F:Destroy()
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Theme.Background
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.BorderSizePixel = 0

local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 8)

local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Theme.Element
MainStroke.Thickness = 1

local TopBar = Instance.new("Frame")
TopBar.Parent = Main
TopBar.BackgroundTransparency = 1
TopBar.Size = UDim2.new(1, 0, 0, 40)

local Title = Instance.new("TextLabel")
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 15, 0, 0)
Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold
Title.Text = "QUWY"
Title.TextColor3 = Theme.Text
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local Divider = Instance.new("Frame")
Divider.Parent = TopBar
Divider.BackgroundColor3 = Theme.Element
Divider.BorderSizePixel = 0
Divider.Position = UDim2.new(0, 0, 1, -1)
Divider.Size = UDim2.new(1, 0, 0, 1)

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar
CloseBtn.BackgroundTransparency = 1
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Font = Enum.Font.GothamMedium
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Theme.SubText
CloseBtn.TextSize = 20

local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar
MinBtn.BackgroundTransparency = 1
MinBtn.Position = UDim2.new(1, -60, 0, 0)
MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Font = Enum.Font.GothamMedium
MinBtn.Text = "−"
MinBtn.TextColor3 = Theme.SubText
MinBtn.TextSize = 20

local Sidebar = Instance.new("Frame")
Sidebar.Parent = Main
Sidebar.BackgroundTransparency = 1
Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.Size = UDim2.new(0, 120, 1, -40)

local SideList = Instance.new("UIListLayout", Sidebar)
SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center
SideList.SortOrder = Enum.SortOrder.LayoutOrder
SideList.Padding = UDim.new(0, 5)

local SidePad = Instance.new("UIPadding", Sidebar)
SidePad.PaddingTop = UDim.new(0, 15)

local PageContainer = Instance.new("Frame")
PageContainer.Parent = Main
PageContainer.BackgroundTransparency = 1
PageContainer.Position = UDim2.new(0, 120, 0, 40)
PageContainer.Size = UDim2.new(1, -120, 1, -40)

local function CreateTabBtn(text)
    local B = Instance.new("TextButton")
    B.Parent = Sidebar
    B.BackgroundColor3 = Theme.Background
    B.Size = UDim2.new(0, 100, 0, 30)
    B.Font = Enum.Font.GothamMedium
    B.Text = text
    B.TextColor3 = Theme.SubText
    B.TextSize = 13
    
    local C = Instance.new("UICorner", B)
    C.CornerRadius = UDim.new(0, 4)
    
    return B
end

local Tab1 = CreateTabBtn("Features")
local Tab2 = CreateTabBtn("Settings")
local Tab3 = CreateTabBtn("Info")

local Page1 = Instance.new("Frame", PageContainer); Page1.Size = UDim2.new(1,0,1,0); Page1.BackgroundTransparency = 1
local Page2 = Instance.new("Frame", PageContainer); Page2.Size = UDim2.new(1,0,1,0); Page2.BackgroundTransparency = 1; Page2.Visible = false
local Page3 = Instance.new("Frame", PageContainer); Page3.Size = UDim2.new(1,0,1,0); Page3.BackgroundTransparency = 1; Page3.Visible = false

local function SwitchTab(btn, page)
    Tab1.TextColor3 = Theme.SubText; Tab2.TextColor3 = Theme.SubText; Tab3.TextColor3 = Theme.SubText
    Tab1.BackgroundColor3 = Theme.Background; Tab2.BackgroundColor3 = Theme.Background; Tab3.BackgroundColor3 = Theme.Background
    Page1.Visible = false; Page2.Visible = false; Page3.Visible = false
    
    btn.TextColor3 = Theme.Accent
    btn.BackgroundColor3 = Theme.Element
    page.Visible = true
end
SwitchTab(Tab1, Page1)

Tab1.MouseButton1Click:Connect(function() SwitchTab(Tab1, Page1) end)
Tab2.MouseButton1Click:Connect(function() SwitchTab(Tab2, Page2) end)
Tab3.MouseButton1Click:Connect(function() SwitchTab(Tab3, Page3) end)

local function CreateButton(text, parent, x, y, callback)
    local B = Instance.new("TextButton")
    B.Parent = parent
    B.BackgroundColor3 = Theme.Element
    B.Position = UDim2.new(0, x, 0, y)
    B.Size = UDim2.new(0, 165, 0, 35)
    B.Font = Enum.Font.GothamMedium
    B.Text = text
    B.TextColor3 = Theme.Text
    B.TextSize = 12
    B.AutoButtonColor = false
    
    local C = Instance.new("UICorner", B)
    C.CornerRadius = UDim.new(0, 4)
    
    local S = Instance.new("UIStroke", B)
    S.Color = Theme.Element
    S.Thickness = 1
    S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    
    local Toggled = false
    
    B.MouseButton1Click:Connect(function()
        Toggled = not Toggled
        if Toggled then
            TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25,25,25)}):Play()
            TweenService:Create(S, TweenInfo.new(0.2), {Color = Theme.Accent}):Play()
            TweenService:Create(B, TweenInfo.new(0.2), {TextColor3 = Theme.Accent}):Play()
        else
            TweenService:Create(B, TweenInfo.new(0.2), {BackgroundColor3 = Theme.Element}):Play()
            TweenService:Create(S, TweenInfo.new(0.2), {Color = Theme.Element}):Play()
            TweenService:Create(B, TweenInfo.new(0.2), {TextColor3 = Theme.Text}):Play()
        end
        callback(Toggled, B)
    end)
    return B
end

local function CreateInput(text, parent, x, y, callback)
    local F = Instance.new("Frame")
    F.Parent = parent
    F.BackgroundColor3 = Theme.Element
    F.Position = UDim2.new(0, x, 0, y)
    F.Size = UDim2.new(0, 165, 0, 35)
    
    local C = Instance.new("UICorner", F)
    C.CornerRadius = UDim.new(0, 4)
    
    local TB = Instance.new("TextBox")
    TB.Parent = F
    TB.BackgroundTransparency = 1
    TB.Size = UDim2.new(1, 0, 1, 0)
    TB.Font = Enum.Font.GothamMedium
    TB.Text = text
    TB.TextColor3 = Theme.SubText
    TB.TextSize = 12
    
    TB.FocusLost:Connect(function()
        local n = tonumber(string.match(TB.Text, "%d+"))
        if n then
            callback(n)
            TB.TextColor3 = Theme.Accent
        else
            TB.TextColor3 = Theme.SubText
        end
    end)
end

-- PAGE 1 CONTENT
CreateButton("Fly", Page1, 10, 15, function(s, btn)
    State.Flying = s
    if s then 
        btn.Text = "Fly: Enabled"
        local Char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local HRP = Char:WaitForChild("HumanoidRootPart")
        local Hum = Char:WaitForChild("Humanoid")
        local BG = Instance.new("BodyGyro", HRP); BG.P = 9e4; BG.maxTorque = Vector3.new(9e9,9e9,9e9); BG.cframe = HRP.CFrame
        local BV = Instance.new("BodyVelocity", HRP); BV.velocity = Vector3.new(0,0,0); BV.maxForce = Vector3.new(9e9,9e9,9e9)
        Hum.PlatformStand = true
        task.spawn(function()
            while State.Flying and Char and Hum.Health > 0 do
                RunService.RenderStepped:Wait()
                local Cam = workspace.CurrentCamera
                BG.cframe = Cam.CFrame
                local d = Vector3.new(0,0,0)
                if UserInputService:IsKeyDown(Enum.KeyCode.W) then d = d + Cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.S) then d = d - Cam.CFrame.LookVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.A) then d = d - Cam.CFrame.RightVector end
                if UserInputService:IsKeyDown(Enum.KeyCode.D) then d = d + Cam.CFrame.RightVector end
                BV.velocity = d * State.FlySpeed
            end
            BG:Destroy(); BV:Destroy(); Hum.PlatformStand = false
        end)
    else
        btn.Text = "Fly"
    end
end)

CreateInput("Fly Speed (20)", Page1, 185, 15, function(v) State.FlySpeed = v; Notify("Fly Speed: "..v) end)

CreateButton("Noclip", Page1, 10, 60, function(s, btn)
    State.Noclip = s
    btn.Text = s and "Noclip: Active" or "Noclip"
end)

CreateButton("Infinite Jump", Page1, 185, 60, function(s, btn)
    State.InfJump = s
    btn.Text = s and "Inf Jump: Active" or "Infinite Jump"
end)

CreateButton("Click TP (Ctrl)", Page1, 10, 105, function(s, btn)
    State.CtrlTP = s
    btn.Text = s and "TP Ready (Ctrl+Click)" or "Click TP (Ctrl)"
end)

CreateButton("Fullbright", Page1, 185, 105, function(s, btn)
    State.Fullbright = s
    if s then
        Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
    else
        Lighting.Brightness = 1; Lighting.GlobalShadows = true
    end
    btn.Text = s and "Light: On" or "Fullbright"
end)

-- PAGE 2 CONTENT
CreateInput("WalkSpeed (16)", Page2, 10, 15, function(v)
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v; Notify("WalkSpeed: "..v) end
end)
CreateInput("JumpPower (50)", Page2, 10, 60, function(v)
    if LocalPlayer.Character then LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = v; Notify("JumpPower: "..v) end
end)

-- PAGE 3 CONTENT
local InfoL = Instance.new("TextLabel", Page3)
InfoL.BackgroundTransparency = 1
InfoL.Size = UDim2.new(1,0,1,0)
InfoL.Text = "QUWY SCRIPT\nMinimalist Edition\n\nTelegram: @QLogovo\nDiscord: discord.gg/9wCEUewSbN"
InfoL.TextColor3 = Theme.SubText
InfoL.Font = Enum.Font.Gotham
InfoL.TextSize = 14

local CopyBtn = Instance.new("TextButton", Page3)
CopyBtn.BackgroundColor3 = Theme.Element
CopyBtn.Position = UDim2.new(0.5, -60, 0.7, 0)
CopyBtn.Size = UDim2.new(0, 120, 0, 30)
CopyBtn.Font = Enum.Font.GothamMedium
CopyBtn.Text = "Copy Links"
CopyBtn.TextColor3 = Theme.Text
CopyBtn.TextSize = 12
Instance.new("UICorner", CopyBtn).CornerRadius = UDim.new(0,4)
CopyBtn.MouseButton1Click:Connect(function()
    if setclipboard then setclipboard("https://t.me/QLogovo\nhttps://discord.gg/9wCEUewSbN"); Notify("Links Copied") end
end)

-- LOGIC
RunService.Stepped:Connect(function()
    if State.Noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do
            if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if State.InfJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end
end)

Mouse.Button1Down:Connect(function()
    if State.CtrlTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Mouse.Target then
        LocalPlayer.Character:MoveTo(Mouse.Hit.p)
    end
end)

-- CIRCLE & DRAG
local Circle = Instance.new("TextButton")
Circle.Parent = ScreenGui
Circle.BackgroundColor3 = Theme.Background
Circle.Size = UDim2.new(0, 45, 0, 45)
Circle.Position = UDim2.new(0.05, 0, 0.1, 0)
Circle.Text = "Q"
Circle.Font = Enum.Font.GothamBold
Circle.TextColor3 = Theme.Accent
Circle.TextSize = 22
Circle.Visible = false
Circle.AutoButtonColor = true

local CC = Instance.new("UICorner", Circle)
CC.CornerRadius = UDim.new(1, 0)

local CS = Instance.new("UIStroke", Circle)
CS.Color = Theme.Accent
CS.Thickness = 1.5
CS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function MakeDrag(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
        end
    end)
    handle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            TweenService:Create(frame, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end
MakeDrag(Main, TopBar)

local CircleDragged = false
local function CircleDragLogic()
    local dragging, dragStart, startPos
    Circle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Circle.Position; CircleDragged = false
        end
    end)
    Circle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            if delta.Magnitude > 3 then CircleDragged = true end
            TweenService:Create(Circle, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play()
        end
    end)
end
CircleDragLogic()

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

MinBtn.MouseButton1Click:Connect(function()
    Main.Visible = false
    Circle.Visible = true
    Circle.Size = UDim2.new(0,0,0,0)
    TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0,45,0,45)}):Play()
end)

Circle.MouseButton1Click:Connect(function()
    if not CircleDragged then
        Circle.Visible = false
        Main.Visible = true
        Main.Size = UDim2.new(0,0,0,0)
        TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 480, 0, 320)}):Play()
    end
end)

Main.Size = UDim2.new(0,0,0,0)
TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 480, 0, 320)}):Play()
