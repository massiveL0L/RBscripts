--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AnimationPlayerGUI"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 300, 0, 150)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Apply a UI Corner to make it rounded
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

--// Title Bar (Draggable)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleBar.BorderSizePixel = 0
titleBar.Text = "https://github.com/massiveL0L/RBscripts"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

--// Input Box for Animation ID
local animationInput = Instance.new("TextBox")
animationInput.Size = UDim2.new(0.9, 0, 0, 40)
animationInput.Position = UDim2.new(0.05, 0, 0.3, 0)
animationInput.PlaceholderText = "animation id"
animationInput.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
animationInput.TextColor3 = Color3.new(1, 1, 1)
animationInput.Font = Enum.Font.SourceSans
animationInput.TextSize = 18
animationInput.Parent = mainFrame

-- Apply UI Corner to TextBox
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 8)
inputCorner.Parent = animationInput

--// Play Button
local playButton = Instance.new("TextButton")
playButton.Size = UDim2.new(0.9, 0, 0, 40)
playButton.Position = UDim2.new(0.05, 0, 0.65, 0)
playButton.Text = "play animation"
playButton.BackgroundColor3 = Color3.new(0, 0.6, 0.2)
playButton.TextColor3 = Color3.new(1, 1, 1)
playButton.Font = Enum.Font.SourceSansBold
playButton.TextSize = 18
playButton.Parent = mainFrame

-- Apply UI Corner to Button
local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(0, 8)
buttonCorner.Parent = playButton

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

--// Play Animation Function
local function playAnimation(animationId)
	if not tonumber(animationId) then
		warn("Invalid Animation ID!")
		return
	end

	local animation = Instance.new("Animation")
	animation.AnimationId = "rbxassetid://" .. animationId

	local animationTrack = humanoid:LoadAnimation(animation)
	animationTrack:Play()
end

--// Play Button Click Event
playButton.MouseButton1Click:Connect(function()
	local animationId = animationInput.Text
	if animationId and animationId ~= "" then
		playAnimation(animationId)
	else
		warn("Please enter a valid Animation ID!")
	end
end)
