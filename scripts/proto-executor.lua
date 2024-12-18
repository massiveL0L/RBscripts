--// Services
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

--// Player Variables
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "CustomNotificationGUI"
screenGui.Parent = playerGui

--// Notification Frame
local notificationFrame = Instance.new("Frame")
notificationFrame.Size = UDim2.new(0, 300, 0, 50)
notificationFrame.Position = UDim2.new(0.5, -150, 0, -60) -- Starts slightly off-screen
notificationFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
notificationFrame.BorderSizePixel = 0
notificationFrame.Parent = screenGui

-- Apply rounded corners
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = notificationFrame

--// Notification Text
local notificationText = Instance.new("TextLabel")
notificationText.Size = UDim2.new(1, 0, 1, 0)
notificationText.BackgroundTransparency = 1
notificationText.Text = "No update found"
notificationText.TextColor3 = Color3.fromRGB(255, 255, 255)
notificationText.Font = Enum.Font.SourceSansBold
notificationText.TextSize = 20
notificationText.Parent = notificationFrame

--// Notification Appear and Disappear Animation
local function showNotification(message)
	notificationText.Text = message -- Set custom message
	notificationFrame.Position = UDim2.new(0.5, -150, 0, -60) -- Reset position in case it was moved
	notificationFrame.BackgroundTransparency = 0 -- Make sure frame is fully visible
	notificationText.TextTransparency = 0 -- Reset text transparency

	-- Tween to slide the notification down
	local showTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.Out)
	local showTween = TweenService:Create(notificationFrame, showTweenInfo, {Position = UDim2.new(0.5, -150, 0, 20)})

	-- Wait for the tween to complete before continuing
	showTween:Play()
	showTween.Completed:Wait() -- Wait for tween to finish

	-- Wait for 3 seconds before hiding
	task.wait(3)

	-- Tween to fade out and slide up the notification
	local hideTweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Sine, Enum.EasingDirection.In)
	local hideTween = TweenService:Create(notificationFrame, hideTweenInfo, {Position = UDim2.new(0.5, -150, 0, -60)})
	local fadeOutTween1 = TweenService:Create(notificationFrame, hideTweenInfo, {BackgroundTransparency = 1})
	local fadeOutTween2 = TweenService:Create(notificationText, hideTweenInfo, {TextTransparency = 1})

	-- Play all tweens at the same time
	hideTween:Play()
	fadeOutTween1:Play()
	fadeOutTween2:Play()

	-- Wait for the hide tween to complete before ending
	hideTween.Completed:Wait()
end

--// Call the Notification
showNotification("No update found")
------------------------------------------------------------------------------------
--// Services
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// GUI Creation
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ScriptExecutorGUI"
screenGui.Parent = playerGui
screenGui.IgnoreGuiInset = true

--// Loading Screen
local loadingScreen = Instance.new("Frame")
loadingScreen.Size = UDim2.new(1, 0, 1, 0)
loadingScreen.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
loadingScreen.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(0, 200, 0, 50)
loadingText.Position = UDim2.new(0.5, -100, 0.5, -100)
loadingText.Text = "Loading..."
loadingText.TextColor3 = Color3.new(1, 1, 1)
loadingText.Font = Enum.Font.SourceSansBold
loadingText.TextSize = 24
loadingText.Parent = loadingScreen

local loadingBar = Instance.new("Frame")
loadingBar.Size = UDim2.new(0, 0, 0, 10)
loadingBar.Position = UDim2.new(0.5, -100, 0.6, 0)
loadingBar.BackgroundColor3 = Color3.new(0, 0.8, 0)
loadingBar.Parent = loadingScreen

local loadingBarBack = Instance.new("Frame")
loadingBarBack.Size = UDim2.new(0, 200, 0, 10)
loadingBarBack.Position = UDim2.new(0.5, -100, 0.6, 0)
loadingBarBack.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
loadingBarBack.Parent = loadingScreen

local uiCornerLoading = Instance.new("UICorner")
uiCornerLoading.CornerRadius = UDim.new(0, 10)
uiCornerLoading.Parent = loadingBar
uiCornerLoading:Clone().Parent = loadingBarBack

-- Loading Animation
local function loadAnimation()
	for i = 1, 100, 2 do
		loadingText.Text = "Loading... " .. i .. "%"
		loadingBar:TweenSize(UDim2.new(i / 100, 0, 0, 10), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, 0.05, true)
		wait(0.05)
	end
	
	loadingScreen:TweenSize(UDim2.new(1, 0, 0, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Sine, 0.5, true, function()
		loadingScreen:Destroy()
	end)
end

--// Main Frame (Draggable)
local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 400, 0, 300)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -150)
mainFrame.BackgroundColor3 = Color3.new(0.15, 0.15, 0.15)
mainFrame.BorderSizePixel = 0
mainFrame.Visible = false
mainFrame.Parent = screenGui

-- Apply a UI Corner to make it rounded
local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 20)
uiCorner.Parent = mainFrame

--// Title Bar (Draggable)
local titleBar = Instance.new("TextLabel")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.BackgroundColor3 = Color3.new(0.1, 0.1, 0.1)
titleBar.Text = "proto-executor"
titleBar.TextColor3 = Color3.new(1, 1, 1)
titleBar.Font = Enum.Font.SourceSansBold
titleBar.TextSize = 18
titleBar.Parent = mainFrame

--// Script Input Box (Text Box)
local scriptBox = Instance.new("TextBox")
scriptBox.Size = UDim2.new(1, -20, 1, -100)
scriptBox.Position = UDim2.new(0, 10, 0, 50)
scriptBox.Text = "--https://github.com/massiveL0L"
scriptBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.2)
scriptBox.TextColor3 = Color3.new(1, 1, 1)
scriptBox.Font = Enum.Font.Code
scriptBox.TextSize = 16
scriptBox.ClearTextOnFocus = false
scriptBox.MultiLine = true
scriptBox.Parent = mainFrame

local scriptBoxCorner = Instance.new("UICorner")
scriptBoxCorner.CornerRadius = UDim.new(0, 10)
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

local executeButtonCorner = Instance.new("UICorner")
executeButtonCorner.CornerRadius = UDim.new(0, 20)
executeButtonCorner.Parent = executeButton

--// Dragging Functionality
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
	end
end)

titleBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(updateInput)

--// Execute Button Functionality
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

-- Run the loading animation and show the main GUI
loadAnimation()

task.delay(3, function()
	mainFrame.Visible = true
end)
