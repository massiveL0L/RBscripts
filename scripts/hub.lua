--// Services
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

--// Variables
local gui = Instance.new("ScreenGui")
local mainFrame = Instance.new("Frame")
local topBar = Instance.new("Frame")
local titleLabel = Instance.new("TextLabel")
local minimizeButton = Instance.new("TextButton")
local updateButton = Instance.new("TextButton")
local myScriptsTab = Instance.new("Frame")

--// GUI Properties
gui.Name = "CleanGUI"
gui.Parent = game.CoreGui
gui.IgnoreGuiInset = true

mainFrame.Name = "MainFrame"
mainFrame.Parent = gui
mainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
mainFrame.Size = UDim2.new(0, 400, 0, 500)
mainFrame.Position = UDim2.new(0.5, -200, 0.5, -250)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true

-- Gaussian Blur Effect
local blurEffect = Instance.new("ImageLabel")
blurEffect.Name = "BlurEffect"
blurEffect.Parent = mainFrame
blurEffect.Size = UDim2.new(1, 0, 1, 0)
blurEffect.BackgroundTransparency = 1
blurEffect.Image = "rbxassetid://5553946656" -- Placeholder image id for Gaussian blur
blurEffect.ImageTransparency = 0.7

-- Top bar
topBar.Name = "TopBar"
topBar.Parent = mainFrame
topBar.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
topBar.Size = UDim2.new(1, 0, 0, 30)

titleLabel.Name = "TitleLabel"
titleLabel.Parent = topBar
titleLabel.Text = "My Scripts"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.Size = UDim2.new(1, -40, 1, 0)
titleLabel.Position = UDim2.new(0, 10, 0, 0)
titleLabel.Font = Enum.Font.SourceSansBold
titleLabel.TextSize = 18

topBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local dragToggle = true
        local dragStart = input.Position
        local startPos = mainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragToggle = false
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if dragToggle and input.UserInputType == Enum.UserInputType.MouseMovement then
                local delta = input.Position - dragStart
                mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end)
    end
end)

-- Minimize Button
minimizeButton.Name = "MinimizeButton"
minimizeButton.Parent = topBar
minimizeButton.Text = "_"
minimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
minimizeButton.Size = UDim2.new(0, 30, 1, 0)
minimizeButton.Position = UDim2.new(1, -30, 0, 0)
minimizeButton.Font = Enum.Font.SourceSansBold
minimizeButton.TextSize = 18

local minimized = false

minimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    local newSize = minimized and UDim2.new(0, 400, 0, 30) or UDim2.new(0, 400, 0, 500)
    TweenService:Create(mainFrame, TweenInfo.new(0.5), {Size = newSize}):Play()
end)

-- Update Button
updateButton.Name = "UpdateButton"
updateButton.Parent = mainFrame
updateButton.Text = "Update"
updateButton.TextColor3 = Color3.fromRGB(255, 255, 255)
updateButton.Size = UDim2.new(0, 80, 0, 30)
updateButton.Position = UDim2.new(0, 10, 0, 40)
updateButton.Font = Enum.Font.SourceSansBold
updateButton.TextSize = 16
updateButton.MouseButton1Click:Connect(function()
    loadstring(game:HttpGet("https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/things%20that%20i%20use%20for%20the%20scripts/update"))()
end)

-- My Scripts Tab
myScriptsTab.Name = "MyScriptsTab"
myScriptsTab.Parent = mainFrame
myScriptsTab.Size = UDim2.new(1, 0, 1, -40)
myScriptsTab.Position = UDim2.new(0, 0, 0, 70)

local scripts = {
    {"Cursor Changer", "loadstring(game:HttpGet('https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/CursorChanger.lua'))()"},
    {"Animation Player", "loadstring(game:HttpGet('https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/animationplayer.lua'))()"},
    {"ProtoEX", "loadstring(game:HttpGet('https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/proto-executor.lua'))()"},
    {"SoundFinder", "loadstring(game:HttpGet('https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/soundfinder.lua'))()"},
    {"SoundFinderSE", "loadstring(game:HttpGet('https://raw.githubusercontent.com/massiveL0L/RBscripts/main/scripts/soundfinder%20SLOW%20EDITION'))()"}
}

for i, script in ipairs(scripts) do
    local button = Instance.new("TextButton")
    button.Name = script[1] .. "Button"
    button.Parent = myScriptsTab
    button.Text = script[1]
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Size = UDim2.new(0, 360, 0, 40)
    button.Position = UDim2.new(0.05, 0, 0, (i - 1) * 50)
    button.Font = Enum.Font.SourceSansBold
    button.TextSize = 16
    button.MouseButton1Click:Connect(function()
        loadstring(script[2])()
    end)
end

