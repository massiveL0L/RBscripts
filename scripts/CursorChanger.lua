--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

--// Player Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CursorChangerGUI"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Apply rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

--// Gaussian Blur Background
local blurBackground = Instance.new("Frame")
blurBackground.Size = UDim2.new(1, 0, 1, 0)
blurBackground.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
blurBackground.BackgroundTransparency = 0.6
blurBackground.Parent = mainFrame

-- Apply the blur effect
local blurEffect = Instance.new("BlurEffect")
blurEffect.Size = 10
blurEffect.Parent = blurBackground

-- Create a UI corner for the blurred frame
local uiCornerBlur = Instance.new("UICorner")
uiCornerBlur.CornerRadius = UDim.new(0, 12)
uiCornerBlur.Parent = blurBackground

--// Title Bar (Draggable)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
titleBar.BorderSizePixel = 0
titleBar.Text = "Cursor Changer"
titleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

--// TextBox to input the Decal ID
local decalInput = Instance.new("TextBox")
decalInput.Size = UDim2.new(1, -20, 0, 40)
decalInput.Position = UDim2.new(0, 10, 0, 50)
decalInput.Text = "Enter Decal ID here"
decalInput.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
decalInput.BorderSizePixel = 0
decalInput.TextColor3 = Color3.fromRGB(255, 255, 255)
decalInput.Font = Enum.Font.SourceSans
decalInput.TextSize = 16
decalInput.ClearTextOnFocus = false
decalInput.Parent = mainFrame

-- Apply a UI Corner to the input box
local decalInputCorner = Instance.new("UICorner")
decalInputCorner.CornerRadius = UDim.new(0, 6)
decalInputCorner.Parent = decalInput

--// Apply Cursor Button
local applyButton = Instance.new("TextButton")
applyButton.Size = UDim2.new(0.9, 0, 0, 40)
applyButton.Position = UDim2.new(0.05, 0, 1, -50)
applyButton.Text = "Apply Cursor"
applyButton.BackgroundColor3 = Color3.fromRGB(0, 0.6, 0)
applyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
applyButton.Font = Enum.Font.SourceSansBold
applyButton.TextSize = 20
applyButton.Parent = mainFrame

-- Apply a UI Corner to the Apply Button
local applyButtonCorner = Instance.new("UICorner")
applyButtonCorner.CornerRadius = UDim.new(0, 8)
applyButtonCorner.Parent = applyButton

--// Close Button
local closeButton = Instance.new("TextButton")
closeButton.Size = UDim2.new(0, 40, 0, 30)
closeButton.Position = UDim2.new(1, -40, 0, 0)
closeButton.Text = "X"
closeButton.BackgroundColor3 = Color3.fromRGB(1, 0, 0)
closeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
closeButton.Font = Enum.Font.SourceSans
closeButton.TextSize = 18
closeButton.Parent = mainFrame

-- Apply a UI Corner to the Close Button
local closeButtonCorner = Instance.new("UICorner")
closeButtonCorner.CornerRadius = UDim.new(0, 6)
closeButtonCorner.Parent = closeButton

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

--// Apply Decal and Change Cursor
applyButton.MouseButton1Click:Connect(function()
	local decalID = decalInput.Text
	if decalID and decalID ~= "" then
		-- Set the cursor with the decal
		local cursorImage = "rbxassetid://" .. decalID
		UserInputService.MouseIconEnabled = true
		UserInputService.MouseIcon = cursorImage
	end
end)

--// Close the GUI
closeButton.MouseButton1Click:Connect(function()
	screenGui:Destroy()
end)
