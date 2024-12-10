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
screenGui.IgnoreGuiInset = true

--// Main Frame (Resizable and Draggable)
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
titleBar.BorderSizePixel = 0
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
minimizeButton.BorderSizePixel = 0
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 20
minimizeButton.Parent = titleBar

--// Section Headers
local musicLabel = Instance.new("TextLabel")
musicLabel.Size = UDim2.new(1, 0, 0, 30)
musicLabel.Position = UDim2.new(0, 0, 0, 30)
musicLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
musicLabel.Text = "Music"
musicLabel.TextColor3 = Color3.new(1, 1, 1)
musicLabel.Font = Enum.Font.SourceSansBold
musicLabel.TextSize = 18
musicLabel.Parent = mainFrame

local soundsLabel = Instance.new("TextLabel")
soundsLabel.Size = UDim2.new(1, 0, 0, 30)
soundsLabel.Position = UDim2.new(0, 0, 0, 280)
soundsLabel.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
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
musicFrame.BackgroundTransparency = 1
musicFrame.Parent = mainFrame

local soundsFrame = Instance.new("ScrollingFrame")
soundsFrame.Size = UDim2.new(1, 0, 0, 180)
soundsFrame.Position = UDim2.new(0, 0, 0, 310)
soundsFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
soundsFrame.ScrollBarThickness = 6
soundsFrame.BackgroundTransparency = 1
soundsFrame.Parent = mainFrame

local uiListLayout1 = Instance.new("UIListLayout")
uiListLayout1.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout1.Padding = UDim.new(0, 5)
uiListLayout1.Parent = musicFrame

local uiListLayout2 = Instance.new("UIListLayout")
uiListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout2.Padding = UDim.new(0, 5)
uiListLayout2.Parent = soundsFrame

--// Update Sound List
local function updateSoundList()
	for _, frame in pairs(musicFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end
	for _, frame in pairs(soundsFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end

	local sounds = {}
	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("Sound") and descendant.IsPlaying then
			table.insert(sounds, descendant)
		end
	end

	for _, sound in ipairs(sounds) do
		local parentFrame = sound.Name:lower():find("music") and musicFrame or soundsFrame

		local soundFrame = Instance.new("Frame")
		soundFrame.Size = UDim2.new(1, 0, 0, 40)
		soundFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		soundFrame.BorderSizePixel = 0
		soundFrame.Parent = parentFrame

		local soundLabel = Instance.new("TextLabel")
		soundLabel.Size = UDim2.new(0.75, 0, 1, 0)
		soundLabel.Text = sound.Name
		soundLabel.TextColor3 = Color3.new(1, 1, 1)
		soundLabel.Font = Enum.Font.SourceSans
		soundLabel.TextSize = 16
		soundLabel.TextXAlignment = Enum.TextXAlignment.Left
		soundLabel.Parent = soundFrame

		local muteButton = Instance.new("TextButton")
		muteButton.Size = UDim2.new(0.2, 0, 0.8, 0)
		muteButton.Position = UDim2.new(0.8, 0, 0.1, 0)
		muteButton.Text = "Mute"
		muteButton.TextColor3 = Color3.new(1, 1, 1)
		muteButton.BackgroundColor3 = Color3.new(1, 0, 0)
		muteButton.Parent = soundFrame

		muteButton.MouseButton1Click:Connect(function()
			sound.Volume = (sound.Volume > 0) and 0 or 1
			muteButton.Text = (sound.Volume == 0) and "Unmute" or "Mute"
		end)
	end

	musicFrame.CanvasSize = UDim2.new(0, 0, 0, #musicFrame:GetChildren() * 45)
	soundsFrame.CanvasSize = UDim2.new(0, 0, 0, #soundsFrame:GetChildren() * 45)
end

local lastUpdate = 0
RunService.Heartbeat:Connect(function()
	if tick() - lastUpdate > 1 then
		updateSoundList()
		lastUpdate = tick()
	end
end)
