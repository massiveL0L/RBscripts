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
mainFrame.BackgroundTransparency = 1 -- Clear background
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

--// Title Bar (for dragging and minimize button)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleBar.Text = "Sound Finder"
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

-- Quit Button
local quitButton = Instance.new("TextButton")
quitButton.Size = UDim2.new(0, 30, 0, 30)
quitButton.Position = UDim2.new(1, -70, 0, 0)
quitButton.Text = "X"
quitButton.TextColor3 = Color3.new(1, 1, 1)
quitButton.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
quitButton.Font = Enum.Font.SourceSansBold
quitButton.TextSize = 20
quitButton.Parent = titleBar

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
soundsLabel.Position = UDim2.new(0, 0, 0, 250)
soundsLabel.Text = "Sounds"
soundsLabel.TextColor3 = Color3.new(1, 1, 1)
soundsLabel.Font = Enum.Font.SourceSansBold
soundsLabel.TextSize = 18
soundsLabel.Parent = mainFrame

--// Scrolling Frames for Music and Sounds
local musicFrame = Instance.new("ScrollingFrame")
musicFrame.Size = UDim2.new(1, 0, 0, 180)
musicFrame.Position = UDim2.new(0, 0, 0, 60)
musicFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
musicFrame.ScrollBarThickness = 6
musicFrame.Parent = mainFrame

local soundsFrame = Instance.new("ScrollingFrame")
soundsFrame.Size = UDim2.new(1, 0, 0, 180)
soundsFrame.Position = UDim2.new(0, 0, 0, 300)
soundsFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
soundsFrame.ScrollBarThickness = 6
soundsFrame.Parent = mainFrame

--// Layouts for Scrolling Frames (to prevent overlap)
local musicLayout = Instance.new("UIListLayout")
musicLayout.FillDirection = Enum.FillDirection.Vertical
musicLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
musicLayout.VerticalAlignment = Enum.VerticalAlignment.Top
musicLayout.Padding = UDim.new(0, 5)
musicLayout.Parent = musicFrame

local soundsLayout = Instance.new("UIListLayout")
soundsLayout.FillDirection = Enum.FillDirection.Vertical
soundsLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
soundsLayout.VerticalAlignment = Enum.VerticalAlignment.Top
soundsLayout.Padding = UDim.new(0, 5)
soundsLayout.Parent = soundsFrame

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

--// Quit Button Functionality
quitButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)

--// Resize Functionality
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

--// Update Sound List
local function updateSoundList()
	-- Clear existing sound frames
	for _, frame in pairs(musicFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end

	for _, frame in pairs(soundsFrame:GetChildren()) do
		if frame:IsA("Frame") then frame:Destroy() end
	end

	-- Add sounds to the list
	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("Sound") and descendant.IsPlaying then
			local parentFrame = descendant.Name:lower():find("music") and musicFrame or soundsFrame

			local soundFrame = Instance.new("Frame")
			soundFrame.Size = UDim2.new(1, 0, 0, 60) -- Increased height for better spacing
			soundFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
			soundFrame.Parent = parentFrame

			local soundLabel = Instance.new("TextLabel")
			soundLabel.Size = UDim2.new(1, 0, 0.5, 0) -- Adjusted size to give more space for both labels
			soundLabel.Text = "ID: " .. descendant.SoundId
			soundLabel.TextColor3 = Color3.new(1, 1, 1)
			soundLabel.Parent = soundFrame

			local sourceLabel = Instance.new("TextLabel")
			sourceLabel.Size = UDim2.new(1, 0, 0.5, 0) -- Adjusted size to give more space for both labels
			sourceLabel.Position = UDim2.new(0, 0, 0.5, 0) -- Positioned below the ID label
			sourceLabel.Text = "Source: " .. (descendant.Parent.Name or "Unknown")
			sourceLabel.TextColor3 = Color3.new(1, 1, 1)
			sourceLabel.Parent = soundFrame

			local muteButton = Instance.new("TextButton")
			muteButton.Size = UDim2.new(0.2, 0, 0.8, 0)
			muteButton.Text = "Mute"
			muteButton.Parent = soundFrame

			-- Mute/Unmute functionality
			muteButton.MouseButton1Click:Connect(function()
				descendant.Volume = (descendant.Volume > 0) and 0 or 1
				muteButton.Text = (descendant.Volume == 0) and "Unmute" or "Mute"
			end)
		end
	end

	-- Update canvas sizes after adding new items
	musicFrame.CanvasSize = UDim2.new(0, 0, 0, musicFrame.UIListLayout.AbsoluteContentSize.Y)
	soundsFrame.CanvasSize = UDim2.new(0, 0, 0, soundsFrame.UIListLayout.AbsoluteContentSize.Y)
end

RunService.Heartbeat:Connect(function()
	updateSoundList()
end)
--// Services
local TweenService = game:GetService("TweenService")
local player = game.Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 80) -- Size of the notification
notificationFrame.Position = UDim2.new(0.5, -150, 0, 20) -- Position at the top-center of the screen
notificationFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35) -- Dark background color
notificationFrame.BackgroundTransparency = 0.8
notificationFrame.BorderSizePixel = 0
notificationFrame.Parent = playerGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10) -- Rounded corners
uiCorner.Parent = notificationFrame

--// Notification Text
local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, 0, 0.6, 0) -- Takes 60% of the frame height
notificationText.Position = UDim2.new(0, 0, 0, 10)
notificationText.Text = "song finder updated"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255) -- White text color
notificationText.Font = Enum.Font.SourceSans
notificationText.TextSize = 18
notificationText.TextAlignment = Enum.TextAlignment.Center
notificationText.TextXAlignment = Enum.TextXAlignment.Center
notificationText.BackgroundTransparency = 1
notificationText.Parent = notificationFrame

--// Progress Bar
local progressBar = Instance.new("Frame")
progressBar.Size = UDim2.new(1, 0, 0.2, 0) -- Takes 20% of the frame height
progressBar.Position = UDim2.new(0, 0, 0.8, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(255, 0, 0) -- Red progress bar
progressBar.Parent = notificationFrame

local progressFill = Instance.new("Frame")
progressFill.Size = UDim2.new(0, 0, 1, 0) -- Starts empty
progressFill.BackgroundColor3 = Color3.fromRGB(0, 255, 0) -- Green fill
progressFill.Parent = progressBar

--// Fade In and Fade Out Functionality
local fadeDuration = 2 -- Duration for fade-in and fade-out in seconds
local displayDuration = 4 -- Time the notification stays visible before fading out

-- Tween for Fade-In
local fadeInTween = TweenService:Create(notificationFrame, TweenInfo.new(fadeDuration), {BackgroundTransparency = 0})
local fadeInTextTween = TweenService:Create(notificationText, TweenInfo.new(fadeDuration), {TextTransparency = 0})
local fadeInProgressBarTween = TweenService:Create(progressBar, TweenInfo.new(fadeDuration), {BackgroundTransparency = 0})

-- Tween for Fade-Out
local fadeOutTween = TweenService:Create(notificationFrame, TweenInfo.new(fadeDuration), {BackgroundTransparency = 1})
local fadeOutTextTween = TweenService:Create(notificationText, TweenInfo.new(fadeDuration), {TextTransparency = 1})
local fadeOutProgressBarTween = TweenService:Create(progressBar, TweenInfo.new(fadeDuration), {BackgroundTransparency = 1})

-- Function to Show Notification
local function showNotification()
	-- Reset progress bar size
	progressFill.Size = UDim2.new(0, 0, 1, 0)
	
	-- Play the fade-in tween
	notificationFrame.BackgroundTransparency = 1
	notificationText.TextTransparency = 1
	progressBar.BackgroundTransparency = 1
	notificationFrame.Visible = true
	TweenService:Play(fadeInTween)
	TweenService:Play(fadeInTextTween)
	TweenService:Play(fadeInProgressBarTween)

	-- Animate the progress bar
	local progressTween = TweenService:Create(progressFill, TweenInfo.new(displayDuration, Enum.EasingStyle.Linear, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 1, 0)})
	TweenService:Play(progressTween)

	-- Wait for the notification to be visible
	wait(displayDuration)

	-- Play the fade-out tween after display duration
	TweenService:Play(fadeOutTween)
	TweenService:Play(fadeOutTextTween)
	TweenService:Play(fadeOutProgressBarTween)

	-- Wait for the fade-out to complete
	wait(fadeDuration)

	-- Hide the notification after fade-out
	notificationFrame.Visible = false
end

-- Show notification immediately
showNotification()
