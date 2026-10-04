local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local DesyncEnabled = false
local FlyEnabled = false
local FakeCharacter = nil
local DesyncConnection = nil
local FlyConnection = nil
local SHOW_SERVER_BODY = true
local TargetSpeed = 45
local oldGui = CoreGui:FindFirstChild("ZynHubPrivateGui") or LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ZynHubPrivateGui")
if oldGui then oldGui:Destroy() end
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZynHubPrivateGui"
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 280, 0, 310)
MainFrame.Position = UDim2.new(0.5, -140, 0.4, -155)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui
local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = MainFrame
local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.8
MainStroke.Color = Color3.fromRGB(130, 50, 250)
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "💎 ZYN HUB PRIVATE"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.Parent = MainFrame
local Line = Instance.new("Frame")
Line.Size = UDim2.new(0, 250, 0, 1)
Line.Position = UDim2.new(0.5, -125, 0, 40)
Line.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
Line.BorderSizePixel = 0
Line.Parent = MainFrame
local ToggleButton = Instance.new("TextButton")
ToggleButton.Name = "ToggleButton"
ToggleButton.Size = UDim2.new(0, 240, 0, 42)
ToggleButton.Position = UDim2.new(0.5, -120, 0, 55)
ToggleButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
ToggleButton.Text = "DESYNC: INACTIVE"
ToggleButton.TextColor3 = Color3.fromRGB(220, 60, 60)
ToggleButton.Font = Enum.Font.GothamBold
ToggleButton.TextSize = 12
ToggleButton.AutoButtonColor = false
ToggleButton.Parent = MainFrame
local ButtonCorner = Instance.new("UICorner")
ButtonCorner.CornerRadius = UDim.new(0, 10)
ButtonCorner.Parent = ToggleButton
local ButtonStroke = Instance.new("UIStroke")
ButtonStroke.Thickness = 1
ButtonStroke.Color = Color3.fromRGB(220, 60, 60)
ButtonStroke.Parent = ToggleButton
local FlyButton = Instance.new("TextButton")
FlyButton.Name = "FlyButton"
FlyButton.Size = UDim2.new(0, 240, 0, 42)
FlyButton.Position = UDim2.new(0.5, -120, 0, 107)
FlyButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
FlyButton.Text = "FLY HACK: DISABLED"
FlyButton.TextColor3 = Color3.fromRGB(60, 130, 240)
FlyButton.Font = Enum.Font.GothamBold
FlyButton.TextSize = 12
FlyButton.AutoButtonColor = false
FlyButton.Parent = MainFrame
local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlyButton
local FlyStroke = Instance.new("UIStroke")
FlyStroke.Thickness = 1
FlyStroke.Color = Color3.fromRGB(60, 130, 240)
FlyStroke.Parent = FlyButton
local TrollButton = Instance.new("TextButton")
TrollButton.Name = "TrollButton"
TrollButton.Size = UDim2.new(0, 240, 0, 42)
TrollButton.Position = UDim2.new(0.5, -120, 0, 159)
TrollButton.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TrollButton.Text = "🔥 TROLL SPAWNER (LAG ENEMIES)"
TrollButton.TextColor3 = Color3.fromRGB(150, 60, 240)
TrollButton.Font = Enum.Font.GothamBold
TrollButton.TextSize = 11
TrollButton.AutoButtonColor = false
TrollButton.Parent = MainFrame
local TrollCorner = Instance.new("UICorner")
TrollCorner.CornerRadius = UDim.new(0, 10)
TrollCorner.Parent = TrollButton
local TrollStroke = Instance.new("UIStroke")
TrollStroke.Thickness = 1
TrollStroke.Color = Color3.fromRGB(150, 60, 240)
TrollStroke.Parent = TrollButton
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0, 240, 0, 20)
SpeedLabel.Position = UDim2.new(0.5, -120, 0, 215)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed Control: " .. TargetSpeed
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 195)
SpeedLabel.Font = Enum.Font.GothamMedium
SpeedLabel.TextSize = 11
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame
local SliderBackground = Instance.new("TextButton")
SliderBackground.Name = "SliderBackground"
SliderBackground.Size = UDim2.new(0, 240, 0, 6)
SliderBackground.Position = UDim2.new(0.5, -120, 0, 245)
SliderBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SliderBackground.Text = ""
SliderBackground.Parent = MainFrame
local SliderBgCorner = Instance.new("UICorner")
SliderBgCorner.CornerRadius = UDim.new(0, 3)
SliderBgCorner.Parent = SliderBackground
local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((TargetSpeed - 16) / (120 - 16), 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(130, 50, 250)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBackground
local SliderButton = Instance.new("Frame")
SliderButton.Size = UDim2.new(0, 14, 0, 14)
SliderButton.Position = UDim2.new((TargetSpeed - 16) / (120 - 16), -7, 0.5, -7)
SliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
SliderButton.Parent = SliderBackground
local SliderBtnCorner = Instance.new("UICorner")
SliderBtnCorner.CornerRadius = UDim.new(1, 0)
SliderBtnCorner.Parent = SliderButton
local function createServerClone(char)
if not SHOW_SERVER_BODY then return end
char.Archivable = true
local clone = char:Clone()
char.Archivable = false
for _, part in ipairs(clone:GetDescendants()) do
if part:IsA("BasePart") then
part.Transparency = 0.5
part.CanCollide = false
part.Color = Color3.fromRGB(130, 50, 250)
if part.Name == "HumanoidRootPart" then part.Transparency = 1 end
elseif part:IsA("Script") or part:IsA("LocalScript") then
part:Destroy()
end
end
clone.Parent = workspace
return clone
end
local function ToggleDesync()
local char = LocalPlayer.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
DesyncEnabled = not DesyncEnabled
if DesyncEnabled then
TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(30, 50, 40)}):Play()
ToggleButton.Text = "DESYNC: ACTIVE"
ToggleButton.TextColor3 = Color3.fromRGB(60, 220, 120)
ButtonStroke.Color = Color3.fromRGB(60, 220, 120)
FakeCharacter = createServerClone(char)
if FakeCharacter and FakeCharacter:FindFirstChild("HumanoidRootPart") then
FakeCharacter:PivotTo(char:GetPivot())
end
DesyncConnection = RunService.PostSimulation:Connect(function()
if char and hrp and hum then
if hum.WalkSpeed ~= TargetSpeed then
hum.WalkSpeed = TargetSpeed
end
hrp.AssemblyLinearVelocity = Vector3.new(1, 1, 1) * (2^15)
RunService.RenderStepped:Wait()
hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
end
end)
else
TweenService:Create(ToggleButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
ToggleButton.Text = "DESYNC: INACTIVE"
ToggleButton.TextColor3 = Color3.fromRGB(220, 60, 60)
ButtonStroke.Color = Color3.fromRGB(220, 60, 60)
if DesyncConnection then DesyncConnection:Disconnect() end
if FakeCharacter then FakeCharacter:Destroy() end
if hum then hum.WalkSpeed = 16 end
end
end
local function ToggleFly()
local char = LocalPlayer.Character
if not char then return end
local hrp = char:FindFirstChild("HumanoidRootPart")
local hum = char:FindFirstChildOfClass("Humanoid")
if not hrp or not hum then return end
FlyEnabled = not FlyEnabled
if FlyEnabled then
TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 35, 50)}):Play()
FlyButton.Text = "FLY HACK: ENABLED"
FlyButton.TextColor3 = Color3.fromRGB(100, 180, 255)
FlyStroke.Color = Color3.fromRGB(100, 180, 255)
local camera = workspace.CurrentCamera
FlyConnection = RunService.RenderStepped:Connect(function()
if char and hrp and hum then
hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
local moveDir = hum.MoveDirection
local flySpeed = TargetSpeed
local cameraCFrame = camera.CFrame
local newVelocity = Vector3.new(0, 0, 0)
if moveDir.Magnitude > 0 then
newVelocity = moveDir * flySpeed
end
if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
newVelocity = newVelocity + Vector3.new(0, flySpeed, 0)
elseif UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
newVelocity = newVelocity + Vector3.new(0, -flySpeed, 0)
end
hrp.AssemblyLinearVelocity = newVelocity
end
end)
else
TweenService:Create(FlyButton, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(25, 25, 35)}):Play()
FlyButton.Text = "FLY HACK: DISABLED"
FlyButton.TextColor3 = Color3.fromRGB(60, 130, 240)
FlyStroke.Color = Color3.fromRGB(60, 130, 240)
if FlyConnection then FlyConnection:Disconnect() end
end
end
local function SpawnPartsOnEnemies()
local storageFolder = workspace:FindFirstChild("TrollPartsFolder")
if not storageFolder then
storageFolder = Instance.new("Folder")
storageFolder.Name = "TrollPartsFolder"
storageFolder.Parent = workspace
end
for _, player in ipairs(Players:GetPlayers()) do
if player ~= LocalPlayer and player.Character then
local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
if enemyRoot then
for i = 1, 25 do
local part = Instance.new("Part")
part.Size = Vector3.new(3, 3, 3)
part.Position = enemyRoot.Position + Vector3.new(math.random(-4, 4), math.random(6, 18), math.random(-4, 4))
part.Material = Enum.Material.Neon
part.Color = Color3.fromHSV(math.random(), 1, 1)
part.CanCollide = true
part.Anchored = false
part.Parent = storageFolder
part.Transparency = 1
part.LocalSimulationOwnership = LocalPlayer
game:GetService("Debris"):AddItem(part, 6)
end
end
end
end
end
local function GiveTeleportTool()
local backpack = LocalPlayer:WaitForChild("Backpack")
if backpack:FindFirstChild("Teleport Tool") then return end
local tool = Instance.new("Tool")
tool.Name = "Teleport Tool"
tool.RequiresHandle = false
tool.Activated:Connect(function()
local mouse = LocalPlayer:GetMouse()
local char = LocalPlayer.Character
local hrp = char and char:FindFirstChild("HumanoidRootPart")
if hrp and mouse.Hit then
hrp.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
end
end)
tool.Parent = backpack
end
LocalPlayer.CharacterAdded:Connect(function()
task.wait(1)
GiveTeleportTool()
end)
GiveTeleportTool()
local isSliding = false
local function updateSlider(input)
local percentage = math.clamp((input.Position.X - SliderBackground.AbsolutePosition.X) / SliderBackground.AbsoluteSize.X, 0, 1)
TargetSpeed = math.round(16 + (percentage * (120 - 16)))
SpeedLabel.Text = "Speed Control: " .. TargetSpeed
SliderFill.Size = UDim2.new(percentage, 0, 1, 0)
SliderButton.Position = UDim2.new(percentage, -7, 0.5, -7)
local char = LocalPlayer.Character
local hum = char and char:FindFirstChildOfClass("Humanoid")
if hum then hum.WalkSpeed = TargetSpeed end
end
SliderBackground.InputBegan:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
isSliding = true; updateSlider(input)
end
end)
UserInputService.InputChanged:Connect(function(input)
if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
updateSlider(input)
end
end)
UserInputService.InputEnded:Connect(function(input)
if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isSliding = false end
end)
ToggleButton.MouseButton1Click:Connect(ToggleDesync)
FlyButton.MouseButton1Click:Connect(ToggleFly)
TrollButton.MouseButton1Click:Connect(SpawnPartsOnEnemies)
