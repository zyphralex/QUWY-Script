local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local CoreGui = game:GetService("CoreGui")
local TeleportService = game:GetService("TeleportService")
local VirtualUser = game:GetService("VirtualUser")
local LogService = game:GetService("LogService")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()
local Camera = workspace.CurrentCamera

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
    Flying = false, FlySpeed = 20,
    Noclip = false, InfJump = false,
    CtrlTP = false, Fullbright = false,
    ESP = false, Spin = false,
    XRay = false, Tracers = false,
    Spectating = false, AntiAFK = false,
    NoFog = false
}

local TP_P = nil

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
    local C = Instance.new("UICorner", F); C.CornerRadius = UDim.new(0, 6)
    local S = Instance.new("UIStroke", F); S.Color = Theme.Accent; S.Thickness = 1
    local L = Instance.new("TextLabel", F)
    L.BackgroundTransparency = 1; L.Size = UDim2.new(1, 0, 1, 0); L.Font = Enum.Font.GothamMedium
    L.Text = text; L.TextColor3 = Theme.Text; L.TextSize = 12; L.TextTransparency = 1
    TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(0, 180, 0, 30)}):Play()
    wait(0.1)
    TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 0}):Play()
    wait(2)
    TweenService:Create(L, TweenInfo.new(0.2), {TextTransparency = 1}):Play()
    local out = TweenService:Create(F, TweenInfo.new(0.3), {Size = UDim2.new(0, 0, 0, 30)})
    out:Play()
    out.Completed:Wait(); F:Destroy()
end

local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Parent = ScreenGui
Main.BackgroundColor3 = Theme.Background
Main.Position = UDim2.new(0.5, -240, 0.5, -160)
Main.Size = UDim2.new(0, 480, 0, 320)
Main.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 8)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Theme.Element; MainStroke.Thickness = 1

local TopBar = Instance.new("Frame")
TopBar.Parent = Main; TopBar.BackgroundTransparency = 1; TopBar.Size = UDim2.new(1, 0, 0, 40)
local Title = Instance.new("TextLabel")
Title.Parent = TopBar; Title.BackgroundTransparency = 1; Title.Position = UDim2.new(0, 15, 0, 0); Title.Size = UDim2.new(0, 200, 1, 0)
Title.Font = Enum.Font.GothamBold; Title.Text = "QUWY"; Title.TextColor3 = Theme.Text; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton")
CloseBtn.Parent = TopBar; CloseBtn.BackgroundTransparency = 1; CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.Size = UDim2.new(0, 30, 1, 0)
CloseBtn.Font = Enum.Font.GothamMedium; CloseBtn.Text = "×"; CloseBtn.TextColor3 = Theme.SubText; CloseBtn.TextSize = 20
local MinBtn = Instance.new("TextButton")
MinBtn.Parent = TopBar; MinBtn.BackgroundTransparency = 1; MinBtn.Position = UDim2.new(1, -60, 0, 0); MinBtn.Size = UDim2.new(0, 30, 1, 0)
MinBtn.Font = Enum.Font.GothamMedium; MinBtn.Text = "−"; MinBtn.TextColor3 = Theme.SubText; MinBtn.TextSize = 20

local Sidebar = Instance.new("Frame")
Sidebar.Parent = Main; Sidebar.BackgroundTransparency = 1; Sidebar.Position = UDim2.new(0, 0, 0, 40); Sidebar.Size = UDim2.new(0, 120, 1, -40)
local SideList = Instance.new("UIListLayout", Sidebar); SideList.HorizontalAlignment = Enum.HorizontalAlignment.Center; SideList.SortOrder = Enum.SortOrder.LayoutOrder; SideList.Padding = UDim.new(0, 5)
local SidePad = Instance.new("UIPadding", Sidebar); SidePad.PaddingTop = UDim.new(0, 15)

local PageContainer = Instance.new("Frame")
PageContainer.Parent = Main; PageContainer.BackgroundTransparency = 1; PageContainer.Position = UDim2.new(0, 120, 0, 40); PageContainer.Size = UDim2.new(1, -120, 1, -40)

local function CreateTabBtn(text)
    local B = Instance.new("TextButton"); B.Parent = Sidebar; B.BackgroundColor3 = Theme.Background; B.Size = UDim2.new(0, 100, 0, 30)
    B.Font = Enum.Font.GothamMedium; B.Text = text; B.TextColor3 = Theme.SubText; B.TextSize = 13
    local C = Instance.new("UICorner", B); C.CornerRadius = UDim.new(0, 4)
    return B
end

local Tab1 = CreateTabBtn("Movement")
local Tab2 = CreateTabBtn("Visuals")
local Tab3 = CreateTabBtn("Players")
local Tab4 = CreateTabBtn("Stats")
local Tab5 = CreateTabBtn("Game")
local Tab6 = CreateTabBtn("Info")

local Page1 = Instance.new("Frame", PageContainer); Page1.Size = UDim2.new(1,0,1,0); Page1.BackgroundTransparency = 1
local Page2 = Instance.new("Frame", PageContainer); Page2.Size = UDim2.new(1,0,1,0); Page2.BackgroundTransparency = 1; Page2.Visible = false
local Page3 = Instance.new("Frame", PageContainer); Page3.Size = UDim2.new(1,0,1,0); Page3.BackgroundTransparency = 1; Page3.Visible = false
local Page4 = Instance.new("Frame", PageContainer); Page4.Size = UDim2.new(1,0,1,0); Page4.BackgroundTransparency = 1; Page4.Visible = false
local Page5 = Instance.new("Frame", PageContainer); Page5.Size = UDim2.new(1,0,1,0); Page5.BackgroundTransparency = 1; Page5.Visible = false
local Page6 = Instance.new("Frame", PageContainer); Page6.Size = UDim2.new(1,0,1,0); Page6.BackgroundTransparency = 1; Page6.Visible = false

local function SwitchTab(btn, page)
    for _, t in pairs({Tab1, Tab2, Tab3, Tab4, Tab5, Tab6}) do t.TextColor3 = Theme.SubText; t.BackgroundColor3 = Theme.Background end
    for _, p in pairs({Page1, Page2, Page3, Page4, Page5, Page6}) do p.Visible = false end
    btn.TextColor3 = Theme.Accent; btn.BackgroundColor3 = Theme.Element; page.Visible = true
end
SwitchTab(Tab1, Page1)
Tab1.MouseButton1Click:Connect(function() SwitchTab(Tab1, Page1) end)
Tab2.MouseButton1Click:Connect(function() SwitchTab(Tab2, Page2) end)
Tab3.MouseButton1Click:Connect(function() SwitchTab(Tab3, Page3) end)
Tab4.MouseButton1Click:Connect(function() SwitchTab(Tab4, Page4) end)
Tab5.MouseButton1Click:Connect(function() SwitchTab(Tab5, Page5) end)
Tab6.MouseButton1Click:Connect(function() SwitchTab(Tab6, Page6) end)

local function CreateButton(text, parent, x, y, callback)
    local B = Instance.new("TextButton"); B.Parent = parent; B.BackgroundColor3 = Theme.Element; B.Position = UDim2.new(0, x, 0, y); B.Size = UDim2.new(0, 165, 0, 35)
    B.Font = Enum.Font.GothamMedium; B.Text = text; B.TextColor3 = Theme.Text; B.TextSize = 12; B.AutoButtonColor = false
    local C = Instance.new("UICorner", B); C.CornerRadius = UDim.new(0, 4)
    local S = Instance.new("UIStroke", B); S.Color = Theme.Element; S.Thickness = 1; S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
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

local function CreateClickButton(text, parent, x, y, callback)
    local B = Instance.new("TextButton"); B.Parent = parent; B.BackgroundColor3 = Theme.Element; B.Position = UDim2.new(0, x, 0, y); B.Size = UDim2.new(0, 165, 0, 35)
    B.Font = Enum.Font.GothamMedium; B.Text = text; B.TextColor3 = Theme.Text; B.TextSize = 12
    local C = Instance.new("UICorner", B); C.CornerRadius = UDim.new(0, 4)
    local S = Instance.new("UIStroke", B); S.Color = Theme.Element; S.Thickness = 1
    B.MouseButton1Click:Connect(function()
        TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Accent}):Play()
        wait(0.1)
        TweenService:Create(B, TweenInfo.new(0.1), {BackgroundColor3 = Theme.Element}):Play()
        callback()
    end)
end

local function CreateInput(text, parent, x, y, callback)
    local F = Instance.new("Frame"); F.Parent = parent; F.BackgroundColor3 = Theme.Element; F.Position = UDim2.new(0, x, 0, y); F.Size = UDim2.new(0, 165, 0, 35)
    local C = Instance.new("UICorner", F); C.CornerRadius = UDim.new(0, 4)
    local TB = Instance.new("TextBox"); TB.Parent = F; TB.BackgroundTransparency = 1; TB.Size = UDim2.new(1, 0, 1, 0)
    TB.Font = Enum.Font.GothamMedium; TB.Text = text; TB.TextColor3 = Theme.SubText; TB.TextSize = 12
    TB.FocusLost:Connect(function()
        local n = tonumber(string.match(TB.Text, "%d+"))
        if n then callback(n); TB.TextColor3 = Theme.Accent else TB.TextColor3 = Theme.SubText end
    end)
end

CreateButton("Fly", Page1, 10, 15, function(s, btn)
    State.Flying = s
    btn.Text = s and "Fly: Active" or "Fly"
    if s then 
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
    end
end)
CreateInput("Fly Speed (20)", Page1, 185, 15, function(v) State.FlySpeed = v; Notify("Speed: "..v) end)
CreateButton("Noclip", Page1, 10, 60, function(s, btn) State.Noclip = s; btn.Text = s and "Noclip: Active" or "Noclip" end)
CreateButton("Infinite Jump", Page1, 185, 60, function(s, btn) State.InfJump = s; btn.Text = s and "Inf Jump: Active" or "Infinite Jump" end)
CreateButton("Click TP (Ctrl)", Page1, 10, 105, function(s, btn) State.CtrlTP = s; btn.Text = s and "TP Ready" or "Click TP (Ctrl)" end)

local EspFolder = Instance.new("Folder", CoreGui); EspFolder.Name = "QUWY_ESP"
CreateButton("ESP (Highlight)", Page2, 10, 15, function(s, btn)
    State.ESP = s
    btn.Text = s and "ESP: Active" or "ESP (Highlight)"
    if s then
        task.spawn(function()
            while State.ESP do
                for _, plr in pairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer and plr.Character then
                        if not EspFolder:FindFirstChild(plr.Name) then
                            local H = Instance.new("Highlight")
                            H.Name = plr.Name
                            H.Adornee = plr.Character
                            H.FillColor = Theme.Accent
                            H.OutlineColor = Theme.Text
                            H.FillTransparency = 0.5
                            H.OutlineTransparency = 0
                            H.Parent = EspFolder
                        end
                    end
                end
                wait(1)
            end
            EspFolder:ClearAllChildren()
        end)
    else
        EspFolder:ClearAllChildren()
    end
end)
CreateButton("Tracers", Page2, 185, 15, function(s, btn)
    State.Tracers = s
    btn.Text = s and "Tracers: ON" or "Tracers"
    if s then
        task.spawn(function()
            while State.Tracers do
                RunService.RenderStepped:Wait()
                for _, p in pairs(Players:GetPlayers()) do
                    if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                        if not p.Character:FindFirstChild("TracerLine") then
                            local a = Instance.new("Beam", p.Character); a.Name = "TracerLine"; a.FaceCamera = true; a.Width0 = 0.1; a.Width1 = 0.1; a.Color = ColorSequence.new(Theme.Accent)
                            local att0 = Instance.new("Attachment", p.Character.HumanoidRootPart)
                            local att1 = Instance.new("Attachment", LocalPlayer.Character.HumanoidRootPart)
                            a.Attachment0 = att0; a.Attachment1 = att1
                        end
                    end
                end
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p.Character then 
                    for _, v in pairs(p.Character:GetChildren()) do if v.Name == "TracerLine" or v:IsA("Attachment") then v:Destroy() end end
                end
            end
        end)
    end
end)
CreateButton("Fullbright", Page2, 10, 60, function(s, btn)
    State.Fullbright = s
    btn.Text = s and "Light: On" or "Fullbright"
    if s then Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.GlobalShadows = false
    else Lighting.Brightness = 1; Lighting.GlobalShadows = true end
end)
CreateButton("X-Ray (Walls)", Page2, 185, 60, function(s, btn)
    State.XRay = s
    btn.Text = s and "X-Ray: Active" or "X-Ray (Walls)"
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            if s then 
                if v.Transparency < 0.5 then v.LocalTransparencyModifier = 0.6 end 
            else 
                v.LocalTransparencyModifier = 0 
            end
        end
    end
end)
CreateButton("No Fog", Page2, 10, 105, function(s, btn)
    State.NoFog = s
    btn.Text = s and "Fog Removed" or "No Fog"
    if s then Lighting.FogEnd = 9e9 else Lighting.FogEnd = 10000 end
end)

local TP_Target = ""
local TP_P = nil

local InputFrame = Instance.new("Frame", Page3)
InputFrame.BackgroundColor3 = Theme.Element; InputFrame.Position = UDim2.new(0, 10, 0, 15); InputFrame.Size = UDim2.new(0, 155, 0, 35)
Instance.new("UICorner", InputFrame).CornerRadius = UDim.new(0, 4)

local TPInput = Instance.new("TextBox", InputFrame)
TPInput.BackgroundTransparency = 1; TPInput.Size = UDim2.new(1, -10, 1, 0); TPInput.Position = UDim2.new(0, 10, 0, 0)
TPInput.Font = Enum.Font.GothamMedium; TPInput.Text = "Player Name..."; TPInput.TextColor3 = Theme.SubText; TPInput.TextSize = 12; TPInput.TextXAlignment = Enum.TextXAlignment.Left

TPInput.FocusLost:Connect(function()
    local t = TPInput.Text
    if t ~= "" then 
        TPInput.TextColor3 = Theme.Accent 
        for _, p in pairs(Players:GetPlayers()) do
            if string.sub(string.lower(p.Name), 1, string.len(t)) == string.lower(t) then 
                TP_P = p
                TPInput.Text = p.Name
                break 
            end
        end
    else 
        TPInput.TextColor3 = Theme.SubText 
    end
end)

local DropToggle = Instance.new("TextButton", Page3)
DropToggle.BackgroundColor3 = Theme.Element; DropToggle.Position = UDim2.new(0, 175, 0, 15); DropToggle.Size = UDim2.new(0, 35, 0, 35)
DropToggle.Font = Enum.Font.GothamBold; DropToggle.Text = "▼"; DropToggle.TextColor3 = Theme.SubText; DropToggle.TextSize = 12
Instance.new("UICorner", DropToggle).CornerRadius = UDim.new(0, 4)

local TPBtn = Instance.new("TextButton", Page3)
TPBtn.BackgroundColor3 = Theme.Accent; TPBtn.Position = UDim2.new(0, 220, 0, 15); TPBtn.Size = UDim2.new(0, 60, 0, 35)
TPBtn.Font = Enum.Font.GothamBold; TPBtn.Text = "TP"; TPBtn.TextColor3 = Theme.Text; TPBtn.TextSize = 12
Instance.new("UICorner", TPBtn).CornerRadius = UDim.new(0, 4)

TPBtn.MouseButton1Click:Connect(function()
    if TP_P and TP_P.Character and TP_P.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character then
        LocalPlayer.Character.HumanoidRootPart.CFrame = TP_P.Character.HumanoidRootPart.CFrame
        Notify("Teleported to "..TP_P.Name)
    end
end)

local DropFrame = Instance.new("Frame", Page3)
DropFrame.BackgroundColor3 = Theme.Element; DropFrame.Position = UDim2.new(0, 10, 0, 55); DropFrame.Size = UDim2.new(0, 270, 0, 180); DropFrame.Visible = false; DropFrame.ZIndex = 10
Instance.new("UICorner", DropFrame).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", DropFrame).Color = Theme.Accent

local Scroll = Instance.new("ScrollingFrame", DropFrame)
Scroll.BackgroundTransparency = 1; Scroll.Size = UDim2.new(1, -10, 0, 130); Scroll.Position = UDim2.new(0, 5, 0, 5); Scroll.ScrollBarThickness = 2; Scroll.ZIndex = 11
local ListLayout = Instance.new("UIListLayout", Scroll); ListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local RefreshBtn = Instance.new("TextButton", DropFrame)
RefreshBtn.BackgroundColor3 = Theme.Background; RefreshBtn.Position = UDim2.new(0, 5, 1, -40); RefreshBtn.Size = UDim2.new(1, -10, 0, 35)
RefreshBtn.Font = Enum.Font.GothamMedium; RefreshBtn.Text = "Refresh List"; RefreshBtn.TextColor3 = Theme.Accent; RefreshBtn.TextSize = 12; RefreshBtn.ZIndex = 11
Instance.new("UICorner", RefreshBtn).CornerRadius = UDim.new(0, 4)

local function RefreshPlayers()
    for _, v in pairs(Scroll:GetChildren()) do if v:IsA("TextButton") then v:Destroy() end end
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer then
            local B = Instance.new("TextButton", Scroll); B.BackgroundColor3 = Theme.Background; B.Size = UDim2.new(1, 0, 0, 25)
            B.Font = Enum.Font.Gotham; B.Text = "  " .. p.Name; B.TextColor3 = Theme.Text; B.TextSize = 12; B.TextXAlignment = Enum.TextXAlignment.Left; B.ZIndex = 12
            Instance.new("UICorner", B).CornerRadius = UDim.new(0, 4)
            B.MouseButton1Click:Connect(function()
                TPInput.Text = p.Name; TPInput.TextColor3 = Theme.Accent; TP_P = p; DropFrame.Visible = false
            end)
        end
    end
    Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y)
end

RefreshBtn.MouseButton1Click:Connect(RefreshPlayers)
DropToggle.MouseButton1Click:Connect(function() DropFrame.Visible = not DropFrame.Visible; if DropFrame.Visible then RefreshPlayers() end end)

CreateButton("Spectate", Page3, 10, 60, function(s, btn)
    State.Spectating = s
    btn.Text = s and "Watching..." or "Spectate"
    if s then
        if TP_P then
            Camera.CameraSubject = TP_P.Character.Humanoid
            Notify("Spectating " .. TP_P.Name)
        else
            Notify("Select player first!")
            s = false; State.Spectating = false; btn.Text = "Spectate"
        end
    else
        Camera.CameraSubject = LocalPlayer.Character.Humanoid
    end
end)

CreateButton("SpinBot", Page3, 185, 60, function(s, btn)
    State.Spin = s
    btn.Text = s and "Spinning..." or "SpinBot"
    if s then
        local BAV = Instance.new("BodyAngularVelocity")
        BAV.Name = "Spin"; BAV.Parent = LocalPlayer.Character.HumanoidRootPart
        BAV.MaxTorque = Vector3.new(0, math.huge, 0); BAV.AngularVelocity = Vector3.new(0, 100, 0)
    else
        if LocalPlayer.Character.HumanoidRootPart:FindFirstChild("Spin") then LocalPlayer.Character.HumanoidRootPart.Spin:Destroy() end
    end
end)

local function CreateStatInput(name, default, y, callback)
    local L = Instance.new("TextLabel", Page4)
    L.BackgroundTransparency = 1; L.Position = UDim2.new(0, 10, 0, y); L.Size = UDim2.new(0, 200, 0, 20)
    L.Font = Enum.Font.GothamBold; L.Text = name .. " (Default: " .. default .. ")"; L.TextColor3 = Theme.SubText; L.TextSize = 11; L.TextXAlignment = Enum.TextXAlignment.Left
    local F = Instance.new("Frame", Page4)
    F.BackgroundColor3 = Theme.Element; F.Position = UDim2.new(0, 10, 0, y + 22); F.Size = UDim2.new(0, 160, 0, 30)
    Instance.new("UICorner", F).CornerRadius = UDim.new(0, 4)
    local TB = Instance.new("TextBox", F)
    TB.BackgroundTransparency = 1; TB.Size = UDim2.new(1, 0, 1, 0); TB.Font = Enum.Font.GothamMedium; TB.Text = default; TB.TextColor3 = Theme.Text; TB.TextSize = 12
    TB.FocusLost:Connect(function()
        local n = tonumber(TB.Text)
        if n then callback(n); TB.TextColor3 = Theme.Accent else TB.TextColor3 = Theme.SubText end
    end)
end

CreateStatInput("WalkSpeed", "16", 10, function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.WalkSpeed = v; Notify("WalkSpeed: "..v) end end)
CreateStatInput("JumpPower", "50", 70, function(v) if LocalPlayer.Character then LocalPlayer.Character.Humanoid.UseJumpPower = true; LocalPlayer.Character.Humanoid.JumpPower = v; Notify("JumpPower: "..v) end end)
CreateStatInput("Gravity", "196.2", 130, function(v) workspace.Gravity = v; Notify("Gravity: "..v) end)
CreateStatInput("Field of View", "70", 190, function(v) Camera.FieldOfView = v; Notify("FOV: "..v) end)

CreateClickButton("Rejoin Server", Page5, 10, 15, function()
    Notify("Rejoining...")
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end)

CreateClickButton("Reset Character", Page5, 185, 15, function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
        LocalPlayer.Character.Humanoid.Health = 0
        Notify("Respawning...")
    end
end)

CreateClickButton("Time: Day", Page5, 10, 60, function()
    Lighting.ClockTime = 14
    Notify("Set time to Day")
end)

CreateClickButton("Time: Night", Page5, 185, 60, function()
    Lighting.ClockTime = 0
    Notify("Set time to Night")
end)

CreateButton("Anti-AFK", Page5, 10, 105, function(s, btn)
    State.AntiAFK = s
    btn.Text = s and "Anti-AFK: ON" or "Anti-AFK"
    if s then
        LocalPlayer.Idled:Connect(function()
            if State.AntiAFK then
                VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                wait(1)
                VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
                Notify("Anti-AFK Triggered")
            end
        end)
    end
end)

CreateClickButton("Clear Console", Page5, 185, 105, function()
    LogService:ClearOutput()
    Notify("Console Cleared")
end)

local AboutTitle = Instance.new("TextLabel", Page6)
AboutTitle.BackgroundTransparency = 1; AboutTitle.Size = UDim2.new(1, 0, 0.3, 0); AboutTitle.Position = UDim2.new(0, 0, 0.1, 0)
AboutTitle.Font = Enum.Font.FredokaOne; AboutTitle.Text = "QUWY"; AboutTitle.TextColor3 = Theme.Accent; AboutTitle.TextSize = 50

local SubTitle = Instance.new("TextLabel", Page6)
SubTitle.BackgroundTransparency = 1; SubTitle.Position = UDim2.new(0, 0, 0.4, 0); SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Font = Enum.Font.Gotham; SubTitle.Text = "pls follow 😭"; SubTitle.TextColor3 = Theme.SubText; SubTitle.TextSize = 14

local function CreateLinkBtn(text, url, yPos)
    local Btn = Instance.new("TextButton", Page6); Btn.BackgroundColor3 = Theme.Element; Btn.Position = UDim2.new(0.5, -100, 0.55, yPos); Btn.Size = UDim2.new(0, 200, 0, 35)
    Btn.Font = Enum.Font.GothamBold; Btn.Text = text; Btn.TextColor3 = Theme.Text; Btn.TextSize = 13
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 20); Instance.new("UIStroke", Btn).Color = Theme.Accent; Instance.new("UIStroke", Btn).Thickness = 1
    Btn.MouseButton1Click:Connect(function() if setclipboard then setclipboard(url); Notify("Link Copied!") else Notify("No Copy Support :(") end end)
end
CreateLinkBtn("Telegram: QLogovo", "https://t.me/QLogovo", 0)
CreateLinkBtn("Discord Server", "https://discord.gg/9wCEUewSbN", 45)

RunService.Stepped:Connect(function()
    if State.Noclip and LocalPlayer.Character then
        for _,v in pairs(LocalPlayer.Character:GetDescendants()) do if v:IsA("BasePart") and v.CanCollide then v.CanCollide = false end end
    end
end)
UserInputService.JumpRequest:Connect(function() if State.InfJump and LocalPlayer.Character then LocalPlayer.Character.Humanoid:ChangeState("Jumping") end end)
Mouse.Button1Down:Connect(function() if State.CtrlTP and UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) and Mouse.Target then LocalPlayer.Character:MoveTo(Mouse.Hit.p) end end)

local Circle = Instance.new("TextButton"); Circle.Parent = ScreenGui; Circle.BackgroundColor3 = Theme.Background; Circle.Size = UDim2.new(0, 45, 0, 45); Circle.Position = UDim2.new(0.05, 0, 0.1, 0)
Circle.Text = "Q"; Circle.Font = Enum.Font.GothamBold; Circle.TextColor3 = Theme.Accent; Circle.TextSize = 22; Circle.Visible = false; Circle.AutoButtonColor = true
local CC = Instance.new("UICorner", Circle); CC.CornerRadius = UDim.new(1, 0)
local CS = Instance.new("UIStroke", Circle); CS.Color = Theme.Accent; CS.Thickness = 1.5; CS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local function MakeDrag(frame, handle)
    local dragging, dragStart, startPos
    handle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = frame.Position end end)
    handle.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; TweenService:Create(frame, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play() end end)
end
MakeDrag(Main, TopBar)

local CircleDragged = false
local function CircleDragLogic()
    local dragging, dragStart, startPos
    Circle.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = true; dragStart = input.Position; startPos = Circle.Position; CircleDragged = false end end)
    Circle.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then local delta = input.Position - dragStart; if delta.Magnitude > 3 then CircleDragged = true; TweenService:Create(Circle, TweenInfo.new(0.05), {Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)}):Play() end end end)
end
CircleDragLogic()

CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
MinBtn.MouseButton1Click:Connect(function() Main.Visible = false; Circle.Visible = true; Circle.Size = UDim2.new(0,0,0,0); TweenService:Create(Circle, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0,45,0,45)}):Play() end)
Circle.MouseButton1Click:Connect(function() if not CircleDragged then Circle.Visible = false; Main.Visible = true; Main.Size = UDim2.new(0,0,0,0); TweenService:Create(Main, TweenInfo.new(0.4, Enum.EasingStyle.Back), {Size = UDim2.new(0, 480, 0, 320)}):Play() end end)
Main.Size = UDim2.new(0,0,0,0); TweenService:Create(Main, TweenInfo.new(0.5, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 480, 0, 320)}):Play()
