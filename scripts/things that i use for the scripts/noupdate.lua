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
