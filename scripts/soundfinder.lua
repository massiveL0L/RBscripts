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

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 450)
mainFrame.Position = UDim2.new(0.5, -175, 0.5, -225)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Apply a UI Corner to make it rounded
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

--// Background Blur using ViewportFrame
local viewportFrame = Instance.new("ViewportFrame")
viewportFrame.Size = UDim2.new(1, 0, 1, 0)
viewportFrame.BackgroundTransparency = 1
viewportFrame.BorderSizePixel = 0
viewportFrame.Parent = mainFrame

-- Create a blur effect inside the ViewportFrame
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 15 -- Adjust this value to control the intensity of the blur
blurEffect.Parent = viewportFrame

-- Create a frame inside the ViewportFrame to make it look like a "blurred" background
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
backgroundFrame.BorderSizePixel = 0
backgroundFrame.Parent = viewportFrame

--// Title Bar
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleBar.BorderSizePixel = 0
titleBar.Text = "Currently Playing Sounds"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

--// Scrolling Frame to Display Sound IDs
local scrollingFrame = Instance.new("ScrollingFrame")
scrollingFrame.Size = UDim2.new(1, 0, 1, -30)
scrollingFrame.Position = UDim2.new(0, 0, 0, 30)
scrollingFrame.CanvasSize = UDim2.new(0, 0, 2, 0)
scrollingFrame.ScrollBarThickness = 6
scrollingFrame.BackgroundTransparency = 1
scrollingFrame.Parent = mainFrame

--// UIListLayout for the Sound List
local uiListLayout = Instance.new("UIListLayout")
uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
uiListLayout.Padding = UDim.new(0, 5)
uiListLayout.Parent = scrollingFrame

--// Dragging Functionality for Main Frame
local dragging = false
local dragInput, dragStart, startPos

local function updateInput(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

titleBar.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)

UserInputService.InputChanged:Connect(updateInput)

--// Function to Update Sound List
local function updateSoundList()
	-- Clear old items
	for _, child in pairs(scrollingFrame:GetChildren()) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end

	-- Search for playing sounds
	local sounds = {}
	for _, descendant in pairs(workspace:GetDescendants()) do
		if descendant:IsA("Sound") and descendant.IsPlaying then
			table.insert(sounds, descendant)
		end
	end

	-- Display sound IDs with Mute Buttons
	for _, sound in ipairs(sounds) do
		local soundFrame = Instance.new("Frame")
		soundFrame.Size = UDim2.new(1, 0, 0, 40)
		soundFrame.BackgroundTransparency = 0.2
		soundFrame.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
		soundFrame.BorderSizePixel = 0
		soundFrame.Parent = scrollingFrame

		-- Sound ID Label
		local soundLabel = Instance.new("TextLabel")
		soundLabel.Size = UDim2.new(0.75, 0, 1, 0)
		soundLabel.BackgroundTransparency = 1
		soundLabel.Text = sound.SoundId
		soundLabel.TextColor3 = Color3.new(1, 1, 1)
		soundLabel.Font = Enum.Font.SourceSans
		soundLabel.TextSize = 16
		soundLabel.TextXAlignment = Enum.TextXAlignment.Left
		soundLabel.Parent = soundFrame

		-- Mute Button
		local muteButton = Instance.new("TextButton")
		muteButton.Size = UDim2.new(0.2, 0, 0.8, 0)
		muteButton.Position = UDim2.new(0.8, 0, 0.1, 0)
		muteButton.Text = "Mute"
		muteButton.TextColor3 = Color3.new(1, 1, 1)
		muteButton.BackgroundColor3 = Color3.new(1, 0, 0)
		muteButton.Font = Enum.Font.SourceSansBold
		muteButton.TextSize = 16
		muteButton.Parent = soundFrame

		local function toggleMute()
			sound.Volume = (sound.Volume > 0) and 0 or 1
			muteButton.Text = (sound.Volume == 0) and "Unmute" or "Mute"
			muteButton.BackgroundColor3 = (sound.Volume == 0) and Color3.new(0, 1, 0) or Color3.new(1, 0, 0)
		end

		muteButton.MouseButton1Click:Connect(toggleMute)
	end

	scrollingFrame.CanvasSize = UDim2.new(0, 0, 0, #sounds * 45)
end

--// Update Sound List Regularly
local lastUpdate = 0
RunService.Heartbeat:Connect(function()
	if tick() - lastUpdate > 1 then 
		updateSoundList()
		lastUpdate = tick()
	end
end)
--// I recommend Zorara Executor.