--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "Windows10Notepad"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -250, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.85, 0.85, 0.85) -- Light gray background like Windows 10
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

-- Apply a UI Corner to make it rounded
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 6)
uiCorner.Parent = mainFrame

--// Title Bar (Draggable)
local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 30)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1) -- Dark gray for title bar
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

-- Title Bar Label
local titleLabel = Instance.new("TextLabel")
titleLabel.Size = UDim2.new(1, 0, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "massive's notepad template"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Padding = UDim.new(0, 10)
titleLabel.Parent = titleBar

--// Text Editing Area
local textBox = Instance.new("TextBox")
textBox.Size = UDim2.new(1, -20, 1, -80)
textBox.Position = UDim2.new(0, 10, 0, 40)
textBox.BackgroundColor3 = Color3.new(1, 1, 1) -- White background for text
textBox.TextColor3 = Color3.new(0, 0, 0) -- Black text
textBox.TextWrapped = true
textBox.Font = Enum.Font.Code -- Makes it look more like Notepad
textBox.TextSize = 16
textBox.MultiLine = true
textBox.ClearTextOnFocus = false
textBox.TextXAlignment = Enum.TextXAlignment.Left
textBox.TextYAlignment = Enum.TextYAlignment.Top
textBox.Parent = mainFrame

-- Apply a UI Corner to the TextBox
local textBoxCorner = Instance.new("UICorner")
textBoxCorner.CornerRadius = UDim.new(0, 4)
textBoxCorner.Parent = textBox

--// Save Button
local saveButton = Instance.new("TextButton")
saveButton.Size = UDim2.new(0, 100, 0, 30)
saveButton.Position = UDim2.new(0, 10, 1, -40)
saveButton.Text = "Save"
saveButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2) -- Green save button
saveButton.TextColor3 = Color3.new(1, 1, 1)
saveButton.Font = Enum.Font.SourceSansBold
saveButton.TextSize = 16
saveButton.Parent = mainFrame

-- Apply UI Corner to Save Button
local saveButtonCorner = Instance.new("UICorner")
saveButtonCorner.CornerRadius = UDim.new(0, 6)
saveButtonCorner.Parent = saveButton

--// Clear Button
local clearButton = Instance.new("TextButton")
clearButton.Size = UDim2.new(0, 100, 0, 30)
clearButton.Position = UDim2.new(0, 120, 1, -40)
clearButton.Text = "Clear"
clearButton.BackgroundColor3 = Color3.new(0.8, 0.2, 0.2) -- Red clear button
clearButton.TextColor3 = Color3.new(1, 1, 1)
clearButton.Font = Enum.Font.SourceSansBold
clearButton.TextSize = 16
clearButton.Parent = mainFrame

-- Apply UI Corner to Clear Button
local clearButtonCorner = Instance.new("UICorner")
clearButtonCorner.CornerRadius = UDim.new(0, 6)
clearButtonCorner.Parent = clearButton

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

--// Button Functionality
saveButton.MouseButton1Click:Connect(function()
	local text = textBox.Text
	if text and text ~= "" then
		print("Saved Text: ", text) -- Print the text to the console (You can save it to a DataStore instead)
		titleLabel.Text = "Notepad - Saved"
		wait(1)
		titleLabel.Text = "Notepad - Untitled"
	else
		warn("Nothing to save!")
	end
end)

clearButton.MouseButton1Click:Connect(function()
	textBox.Text = ""
end)
