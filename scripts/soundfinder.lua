--// Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "SoundTrackerGUI"
screenGui.Parent = playerGui

--// Main Frame
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

--// Title Bar (for dragging and minimize button)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleBar.Text = "sound finder"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

-- Minimize Button
local minimizeButton = Instance.new("TextButton")
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -35, 0, 0)
minimizeButton.Text = "-"
minimizeButton.TextColor3 = Color3.new(1, 1, 1)
minimizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

--// Section Headers
local musicLabel = Instance.new("TextLabel")
musicLabel.Size = UDim2.new(1, 0, 0, 30)
musicLabel.Position = UDim2.new(0, 0, 0, 30)
musicLabel.Text = "Music"
musicLabel.TextColor3 = Color3.new(1, 1, 1)
musicLabel.Font = Enum.Font.SourceSansBold
musicLabel.TextSize = 18
musicLabel.Parent = mainFrame

local soundsLabel = Instance.new("TextLabel")
soundsLabel.Size = UDim2.new(1, 0, 0, 30)
soundsLabel.Position = UDim2.new(0, 0, 0, 280)
soundsLabel.Text = "Sounds"
soundsLabel.TextColor3 = Color3.new(1, 1, 1)
soundsLabel.Font = Enum.Font.SourceSansBold
soundsLabel.TextSize = 18
soundsLabel.Parent = mainFrame

--// Scrolling Frames for Music and Sounds
local musicFrame = Instance.new("ScrollingFrame")
musicFrame.Size = UDim2.new(1, 0, 0, 220)
musicFrame.Position = UDim2.new(0, 0, 0, 60)
musicFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
musicFrame.ScrollBarThickness = 6
musicFrame.Parent = mainFrame

local soundsFrame = Instance.new("ScrollingFrame")
soundsFrame.Size = UDim2.new(1, 0, 0, 180)
soundsFrame.Position = UDim2.new(0, 0, 0, 310)
soundsFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
soundsFrame.ScrollBarThickness = 6
soundsFrame.Parent = mainFrame

--// Draggable GUI
local dragging, dragStart, startPos
titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

--// Resizable GUI
local resizeButton = Instance.new("Frame")
resizeButton.Size = UDim2.new(0, 20, 0, 20)
resizeButton.Position = UDim2.new(1, -20, 1, -20)
resizeButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
resizeButton.Parent = mainFrame

local resizing = false
resizeButton.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = true
	end
end)

resizeButton.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		resizing = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if resizing and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - mainFrame.AbsolutePosition
		mainFrame.Size = UDim2.new(0, math.max(200, delta.X), 0, math.max(200, delta.Y))
	end
end)

--// Minimize Button Functionality
local minimized = false
minimizeButton.MouseButton1Click:Connect(function()
	if minimized then
		mainFrame.Size = UDim2.new(0, 400, 0, 500)
	else
		mainFrame.Size = UDim2.new(0, 400, 0, 30)
	end
	minimized = not minimized
end)

--// Update Sound List
local function updateSoundList()
	for _, frame in pairs(musicFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end

	for _, frame in pairs(soundsFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end

	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("Sound") and descendant.IsPlaying then
			local parentFrame = descendant.Name:lower():find("music") and musicFrame or soundsFrame

			local soundFrame = Instance.new("Frame")
			soundFrame.Size = UDim2.new(1, 0, 0, 40)
			soundFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			soundFrame.Parent = parentFrame

			local soundLabel = Instance.new("TextLabel")
			soundLabel.Size = UDim2.new(0.75, 0, 1, 0)
			soundLabel.Text = descendant.Name
			soundLabel.TextColor3 = Color3.new(1, 1, 1)
			soundLabel.Parent = soundFrame

			local muteButton = Instance.new("TextButton")
			muteButton.Size = UDim2.new(0.2, 0, 0.8, 0)
			muteButton.Text = "Mute"
			muteButton.Parent = soundFrame

			muteButton.MouseButton1Click:Connect(function()
				descendant.Volume = (descendant.Volume > 0) and 0 or 1
				muteButton.Text = (descendant.Volume == 0) and "Unmute" or "Mute"
			end)
		end
	end
end

RunService.Heartbeat:Connect(function()
	updateSoundList()
end)
