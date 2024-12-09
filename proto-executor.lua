--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExecutorGUI"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
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
titleBar.Text = "proto-executor"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

--// Script Input Box (Text Box)
local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1, -20, 1, -80)
scriptBox.Position = UDim2.new(0, 10, 0, 40)
scriptBox.Text = "--https://github.com/massiveL0L"
scriptBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
scriptBox.BorderSizePixel = 0
scriptBox.TextColor3 = Color3.new(1, 1, 1)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 16
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.Parent = mainFrame

-- Apply a UI Corner to the script box
local scriptBoxCorner = Instance.new("UICorner")
scriptBoxCorner.CornerRadius = UDim.new(0, 6)
scriptBoxCorner.Parent = scriptBox

--// Execute Button
local executeButton = Instance.new("TextButton")
executeButton.Size = UDim2.new(0.9, 0, 0, 40)
executeButton.Position = UDim2.new(0.05, 0, 1, -50)
executeButton.Text = "Execute"
executeButton.BackgroundColor3 = Color3.new(0, 0.6, 0)
executeButton.TextColor3 = Color3.new(1, 1, 1)
executeButton.Font = Enum.Font.SourceSansBold
executeButton.TextSize = 20
executeButton.Parent = mainFrame

-- Apply a UI Corner to the Execute Button
local executeButtonCorner = Instance.new("UICorner")
executeButtonCorner.CornerRadius = UDim.new(0, 8)
executeButtonCorner.Parent = executeButton

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

--// Execute Script Button Functionality
executeButton.MouseButton1Click:Connect(function()
	local scriptCode = scriptBox.Text
	if scriptCode and scriptCode ~= "" then
		local success, errorMessage = pcall(function()
			loadstring(scriptCode)()
		end)
		if not success then
			warn("Script execution failed: ", errorMessage)
		end
	end
end)
